clc,clear,close all;
addpath(genpath('../'))

if exist('./log','dir')==0 
    mkdir('./log');
end

if exist('../data/res_w','dir')==0 
    mkdir('../data/res_w');
end

%%%%%% Ddata Setting %%%%%%%%
for dataname = ["daily_used","SP500_2"]%["daily_used","SP500_2","rand"] % options:
    if dataname == "daily_used"
        diary './log/daily_used.txt'
        args.dual_tol = 2*1e-5;
    elseif dataname == "SP500_2"
        diary './log/SP500_2.txt'
        args.dual_tol = 5*1e-5;
    else
        diary './log/rand.txt'
        args.dual_tol = 2*1e-5;
    end
    fprintf("========== dataname: %s ==========\n",dataname)
    datapath = "../data/"+dataname+".csv";
    ret = csvread(datapath,1,1);
    
    
    %%%%%%%%%% Experiments Setting %%%%%%%%%%
    if dataname == "SP500_2"
        periods = [300,400,500,600,700,800,900,1000]; %,];%900,1000];
    elseif dataname == "daily_used"
        periods = [50,100,150,200,250,300]; %
    else
        periods = [50,100];
    end
    expe_num = length(periods);
    
    
    %%%%%%%%% Parameters Setting %%%%%%%%%%
    args.lamda = 2.25;
    args.B = 0;
    args.alpha = 0.88;
    
    args.gamma_pos = 8.4;
    args.gamma_neg = 11.4;
    
    args.delta_pos = .77;
    args.delta_neg = .79;
    
    args.primal_tol = 5*1e-5;
    
    args.max_iter = 1000; 
    args.distortion = 2;
    args.verbose = 1;
    args.method_num = 2;
    args.utility = 2; % utility function
    
    
    total_iter = zeros(expe_num,1); % total_iter is the total iteration number
    objvalue = zeros(expe_num,1); % objvalue is the optimal value
    times = zeros(expe_num,1);   % time is the total time
    xtimes = zeros(expe_num,1);  % xtime is the time of updating x
    ytimes = zeros(expe_num,1);  % ytime is the time of updating y
    flags = zeros(expe_num,1);   % 1: optimal, 0: max_iter
    srs = zeros(1000,expe_num);  % 1000 is the max_iter
    
    for iter_num = 1:expe_num
        periods(iter_num)
        period = periods(iter_num);
        end_idx = period;
        R = ret(end_idx-period+1:end_idx,:);
    
        % only for daily_used
        if dataname == "daily_used"
            R = R(:,1:48)./100;
        end
        
        size(R)
        t1 = clock;
    
        [xopt,yopt,res,total_iter_num,flag,res_srs,increase,xtime,ytime] = ADMM_CPT_solver(R,args);
        
        t2 = clock;
        filename = "../results/res_w/w_"+dataname+"_"+num2str(period)+".mat";
        save(filename,"xopt",'-mat')
    
        total_iter(iter_num) = total_iter_num;
        objvalue(iter_num) = res;
        
        flags(iter_num) = flag;
        times(iter_num) = etime(t2,t1);
        xtimes(iter_num) = xtime;
        ytimes(iter_num) = ytime;
    
        srs(1:total_iter_num,iter_num) = res_srs;
    
    end
    savefile = '../results/5-3_ADMM_PAV_'+dataname+'.mat';
    save(savefile,'total_iter','objvalue','times','flags','srs','xtimes','ytimes');
    
    
    %%%%%%%%%%%%%%%  fmincon  %%%%%%%%%%%%%%%
    fmincon_objvalue = zeros(expe_num,1);
    fmincon_times = zeros(expe_num,1);
    for i = 1:expe_num
        period = periods(i)
        end_idx = period;
        R = ret(end_idx-period+1:end_idx,:);
        % R = R(:,1:48)./100;
        if dataname == "daily_used"
            R = R(:,1:48)./100;
        end
    
        [N,m] = size(R);
        size(R)
        t1 = clock;
        [an,bn] = coefficients_generating(N,2,args.delta_pos,args.delta_neg);
        A = -eye(m,m);
        b = zeros(m,1);
        % %  drop the x >= 0 constr
        % A = [];
        % b = [];
        Aeq = ones(1,m);
        beq = [1];
        fun = @(xx)negative_utility(an,bn,R,xx,args);
        x0 = ones(m,1)./m;
    %     x0 = zeros(m,1);
        % x0(1) = 1;
        % x0 = rand(m,1);
        % x0 = x0./sum(x0);
        options = optimoptions(@fmincon,'MaxFunctionEvaluations',1000000,'MaxIterations',3000);
        [xfmincon,res] = fmincon(fun,x0,A,b,Aeq,beq,[],[],[],options);
        t2 = clock;
        fmincon_objvalue(i) = res;
        fmincon_times(i) = etime(t2,t1);
    end 
    
    for i = 1:expe_num
        fprintf("fmincon value: %e time: %1.2f \n",fmincon_objvalue(i),fmincon_times(i))
        fprintf("ADMM value: %e  time: %1.2f \n",objvalue(i),times(i))
        fprintf("fmincon value - ADMM value: %e \n",fmincon_objvalue(i) - objvalue(i))
        fprintf("\n")
    end
    
    
    savefile = '../results/5-3_fmincon_'+dataname+'.mat';
    save(savefile,'fmincon_objvalue','fmincon_times');
    diary off 
end

function res = negative_utility(an,bn,R,x,args)
  ret = R*x;
  ret = sort(ret);
  [N,~] = size(ret);
  B = args.B;
  gamma_pos = args.gamma_pos;
  gamma_neg = args.gamma_neg;
  res = 0;
  for i = 1:N
      y = ret(i);
      if y > B
          res = res - bn(i)*(1-exp(gamma_pos*(B-y)));
      else
          res = res - an(i)*(-1+exp(gamma_neg*(y-B)));
      end

  end
end 