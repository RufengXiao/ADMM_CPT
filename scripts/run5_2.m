clc,clear,close all;
addpath(genpath('../'))

if exist('../data','dir')==0 
    disp('data is not exist!')
end

if exist('../results','dir')==0 
    mkdir('../results');
end

args.lamda = 2.25;
args.alpha = 0.88;
args.distortion = 1;
args.delta_neg = 0.69;
args.delta_pos = 0.61;
args.primal_tol = 5*1e-5;
args.max_iter = 1000;
args.utility = 1; % utility function

args.verbose = 1;
for risk_free = [0,1]
    for dataset = 1:2
        if dataset == 1
            ret = csvread('../data/daily_used.csv',1,1);
            if risk_free
                args.B = 0.000034;
            else
                args.B = 0;
            end 
            ret = ret(:,1:48)./100;
            periods = [50,100,150,200,250,300];%50;%[50,100,150,200,250,300];
            expe_num = 6;%1;%6;
            args.dual_tol = 2*1e-5;
            name = 48;
        elseif dataset == 2
            ret = csvread('../data/SP500_2.csv',1,1);
            if risk_free
                args.B = 0.0000027;
            else
                args.B = 0;
            end        
            periods = [300,400,500,600,700,800,900,1000];%[300,400,500,600,700,800,900,1000];
            expe_num = 8;%8;
            args.dual_tol = 5*1e-5;
            name = 500;
        end
    
    
        for method_num = 1:2
            args.method_num = method_num;
            total_iter = zeros(expe_num,1);
            objvalue = zeros(expe_num,1);
            times = zeros(expe_num,1);
            xtimes = zeros(expe_num,1);
            ytimes = zeros(expe_num,1);
            flags = zeros(expe_num,1);
            srs = zeros(1000,expe_num);
            pieces_srs = zeros(1000,expe_num);
            increases = zeros(expe_num,1);
            for iter_num = 1:expe_num
                periods(iter_num)
                period = periods(iter_num);
                end_idx = period;
                R = ret(end_idx-period+1:end_idx,:);
                size(R)
                t1 = clock;
                [xopt,yopt,res,total_iter_num,flag,res_srs,increase,xtime,ytime] = ADMM_CPT_solver(R,args);
                t2 = clock;
                total_iter(iter_num) = total_iter_num;
                objvalue(iter_num) = res;
                
                flags(iter_num) = flag;
                times(iter_num) = etime(t2,t1);
                xtimes(iter_num) = xtime;
                ytimes(iter_num) = ytime;
                srs(1:total_iter_num,iter_num) = res_srs;
            end
            if method_num == 1
                if risk_free
                    save_dir = sprintf('../results/5-2_ADMM_%d_DP_rf.mat',name);
                else
                    save_dir = sprintf('../results/5-2_ADMM_%d_DP.mat',name);
                end
            elseif method_num == 2
                if risk_free
                    save_dir = sprintf('../results/5-2_ADMM_%d_PAV_rf.mat',name);
                else
                    save_dir = sprintf('../results/5-2_ADMM_%d_PAV.mat',name);
                end
            end
            save(save_dir,'total_iter','objvalue','times','flags','srs','xtimes','ytimes');
        end
    
        fmincon_objvalue = zeros(expe_num,1);
        fmincon_times = zeros(expe_num,1);
        for i = 1:expe_num
            period = periods(i);
            end_idx = period;
            R = ret(end_idx-period+1:end_idx,:);
            [N,m] = size(R);
            size(R)
            t1 = clock;
            [an,bn] = coefficients_generating(N,args.distortion,args.delta_neg,args.delta_pos);
            A = -eye(m,m);
            b = zeros(m,1);
            Aeq = ones(1,m);
            beq = [1];
            fun = @(xx)negative_utility(an,bn,R,xx,args);
            x0 = ones(m,1)./m;
            options = optimoptions(@fmincon,'MaxFunctionEvaluations',1000000,'MaxIterations',3000);
            [xfmincon,res] = fmincon(fun,x0,A,b,Aeq,beq,[],[],[],options);
            t2 = clock;
            fmincon_objvalue(i) = res;
            fmincon_times(i) = etime(t2,t1);
        end
        if risk_free
            save_dir = sprintf('../results/5-2_fmincon_%d_rf.mat',name);
        else
            save_dir = sprintf('../results/5-2_fmincon_%d.mat',name);
        end
        save(save_dir,'fmincon_objvalue','fmincon_times');
    
        for i = 1:expe_num
            fprintf("fmincon value: %e time: %1.2f \n",fmincon_objvalue(i),fmincon_times(i))
            fprintf("ADMM value: %e  time: %1.2f \n",objvalue(i),times(i))
            fprintf("fmincon value - ADMM value: %e \n",fmincon_objvalue(i) - objvalue(i))
            fprintf("\n")
        end
    end
end


function res = negative_utility(an,bn,R,x,args)
  ret = R*x;
  ret = sort(ret);
  [N,~] = size(ret);
  B = args.B;
  alpha = args.alpha;
  lamda = args.lamda;
  res = 0;
  for i = 1:N
      y = ret(i);
      if y > B
          res = res - bn(i)*(y-B)^alpha;
      else
          res = res + lamda*an(i)*(B-y)^alpha;
      end
  end
end
