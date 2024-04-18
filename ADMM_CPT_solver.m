function [xopt,yopt,res,itr,flag,res_srs,increase,xtime,ytime] = ADMM_CPT_solver(R,args)
    [N,m] = size(R);
    Q = R'*R;
    x = 1/m*ones(m,1);
%     x = xinit;
    if args.utility == 1
        sigma = 0.7;
    else
        sigma = 17/m;
    end
    fprintf("========== sigma: %1.4f ==========\n",sigma)
     y = zeros(N,1);
%      y = R*x;
    [an,bn] = coefficients_generating(N,args.distortion,args.delta_neg,args.delta_pos);

    lagrangian = zeros(N,1);

    t1 = clock;
    flag = 0;
    primal_tol = args.primal_tol;
    dual_tol = args.dual_tol;
    verbose = args.verbose;
    res_srs = [];
    res = 1000000;
    increase = 0;
    xtime = 0;
    ytime = 0;
    for itr = 1:args.max_iter
        ypre = y;
        ty0 = clock;
        [y,isbetter]= ysubproblem(x,y,R,lagrangian,sigma,an,bn,args);
        ty1 = clock;
        ytime = ytime + etime(ty1,ty0);
        if isbetter
            increase = increase + 1;
        end
        tx0 = clock;
        x = xsubproblem_gurobi(x,y,R,Q,lagrangian,sigma);
        tx1 = clock;
        xtime = xtime + etime(tx1,tx0);
        lagrangian = lagrangian - sigma*(y - R*x);
        primal_feasibility = norm(y - R*x);
        dual_feasibility = norm(ypre - y);
        res = negative_utility(an,bn,R,x,args);
        if verbose == 1
            fprintf('iter = %d, primal_feasibility = %1.3e, dual_feasibility = %1.3e, objval = %1.3e \n', itr,primal_feasibility,dual_feasibility,res);
        end 
       
        res_srs = [res_srs res];
        if primal_feasibility < primal_tol && dual_feasibility < dual_tol
            fprintf('The algorithm converges. Ojbective value = %1.4e\n', res);
            flag = 1;
            break
        end
%   
        if args.utility == 1
            if itr>5 && mod(itr,5) == 0 % && primal_feasibility >  primal_tol
                sigma = min(5000,sigma * 1.7);
            end
        else
           if itr <= 17 && mod(itr,2) == 0
                if primal_feasibility > 5e-2
                    sigma = sigma * 2.17;
                else
                    sigma = sigma * 1.7;
                end
           elseif itr > 17 && mod(itr,5) == 0
                sigma = sigma * 1.27;
           end
%             if  primal_feasibility <=  1e1*primal_tol && mod(itr,5) == 0 % && primal_feasibility >  primal_tol
%                 sigma = min(5000,sigma * 1.17);
%             elseif primal_feasibility <=  1e2*primal_tol && mod(itr,5) == 0
%                 sigma = min(5000,sigma * 1.27);
%             elseif primal_feasibility <=  1e3*primal_tol && mod(itr,5) == 0
%                 sigma = min(5000,sigma * 1.37);
%             elseif mod(itr,5) == 0
%                 sigma = min(5000,sigma * 2);
%             end
%             if itr>7
%                 if primal_feasibility > 1e-1 && mod(itr,3)==0
%                     sigma = min(5000,sigma * 1.7);
%                 elseif dual_feasibility > 1e3*dual_tol && mod(itr,3)==0
%                     sigma = min(5000,sigma * 1.5);
%                 elseif mod(itr,2)==0
%                     sigma = min(5000,sigma * 1.07);
%                 end
%             end
%             if primal_feasibility < 10*primal_tol && dual_feasibility > 10*dual_tol
%                 sigma = min(5000,sigma * 2);
%             end
        end

        t2 = clock;
        ctime = etime(t2,t1);
        if ctime > 1*60*60
            break
        end
    end
    fprintf('iter = %d, primal_feasibility = %1.3e, dual_feasibility = %1.3e \n', itr,primal_feasibility,dual_feasibility);
    xopt = x;
    yopt = y;
    
end

function [ynext,isbetter] = ysubproblem(x,y,R,lagrangian,sigma,an,bn,args)
       isbetter = 0;
       wn = R*x + lagrangian./sigma;
       [N,m] = size(R);
       [sorted_wn,sort_id] = sort(wn);
       reshape(sorted_wn,1,N);
       ypre = sort(y);
       if args.method_num == 1
           ysub = dynamic_programming(an,bn,sorted_wn,sigma,args);
           ysub = ysub';
       else
           ysub = PAV_solver(an,bn,sorted_wn,args,sigma);
       end
      
       ynext = zeros(N,1);
       for i = 1:N
           ynext(sort_id(i)) = ysub(i);
       end
end

function xnext = xsubproblem_gurobi(x,y,R,Q,lagrangian,sigma)
    [m,~] = size(x);
    t = y - lagrangian./sigma;
    bmodel.Q =  sparse(sigma/2 * Q);
    bmodel.obj = - sigma * (t'*R)';
    bmodel.lb = zeros(m, 1);
    bmodel.ub = ones(m, 1);
    bmodel.A = sparse(ones(1,m));
    bmodel.rhs = [1];
    bmodel.sense = '=';
    bparams.OutputFlag = 0;
    bresult = gurobi(bmodel, bparams);
    xnext = bresult.x;
end

function res = negative_utility(an,bn,R,x,args)
  ret = R*x;
  ret = sort(ret);
  [N,~] = size(ret);
  B = args.B;
  res = 0;
  if args.utility == 1
      alpha = args.alpha;
      lamda = args.lamda;
      for i = 1:N
          y = ret(i);
          if y > B
              res = res - bn(i)*(y-B)^alpha;
          else
              res = res + lamda*an(i)*(B-y)^alpha;
          end
      end
  else
      gamma_neg = args.gamma_neg;
      gamma_pos = args.gamma_pos;
      for i = 1:N
          y = ret(i);
          if y > B
              res = res - bn(i)*(1-exp(gamma_pos*(B-y)));
          else
              res = res - an(i)*(-1+exp(gamma_neg*(y-B)));
          end
      end
  end
end 

