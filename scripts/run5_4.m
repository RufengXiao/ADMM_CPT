ret = csvread('../data/daily_used.csv',1,1);
addpath(genpath('../'))

rtns = zeros(1000,1);
xopt_array = zeros(48,1000);
args.primal_tol = 5*1e-5;
args.dual_tol = 5*1e-5;
args.verbose = 0;
args.method_num = 2;
args.utility = 1;
args.delta_neg = 0.69;
args.delta_pos = 0.61;
for itr = 1:1000
    disp('benchmark')
    itr
    period = 250;
    invest_idx = period + itr;

    R = ret(invest_idx-period:invest_idx-1,:)./100;
    R_next = ret(invest_idx,:)./100;
    R = R(:,1:48);
    R_next = R_next(1:48);

    args.lamda = 2.25;
    args.B = 0;
    args.alpha = 0.88;
    args.max_iter = 1000;
    args.distortion = 1;
    [xopt,yopt,res] = ADMM_CPT_solver(R,args);
    rtn_next = R_next * xopt;
    xopt_array(:,itr) = xopt;
    rtns(itr) = rtn_next;
end
save('../results/Empirical_benchmark_daily.mat','xopt_array','rtns');

rtns = zeros(1000,1);
xopt_array = zeros(48,1000);
for itr = 1:1000
    disp('risk-free reference point')
    itr
    period = 250;
    invest_idx = period + itr;
    
    R = ret(invest_idx-period:invest_idx-1,:)./100;
    R_next = ret(invest_idx,:)./100;
    R = R(:,1:48);
    R_next = R_next(1:48);
    
    args.lamda = 2.25;
    args.B = 0.000041;
    args.alpha = 0.88;
    args.max_iter = 1000;
    args.distortion = 1;
    [xopt,yopt,res] = ADMM_CPT_solver(R,args);
    rtn_next = R_next * xopt;
    xopt_array(:,itr) = xopt;
    rtns(itr) = rtn_next;
end
save('../results/Empirical_riskfree_reference_point_daily.mat','xopt_array','rtns');

rtns = zeros(1000,1);
xopt_array = zeros(48,1000);
for itr = 1:1000
    disp('large reference point')
    itr
    period = 250;
    invest_idx = period + itr;

    R = ret(invest_idx-period:invest_idx-1,:)./100;
    R_next = ret(invest_idx,:)./100;
    R = R(:,1:48);
    R_next = R_next(1:48);

    args.lamda = 2.25;
    args.B = 0.00072;
    args.alpha = 0.88;
    args.max_iter = 1000;
    args.distortion = 1;
    [xopt,yopt,res] = ADMM_CPT_solver(R,args);
    rtn_next = R_next * xopt;
    xopt_array(:,itr) = xopt;
    rtns(itr) = rtn_next;
end
save('../results/Empirical_large_reference_point_daily.mat','xopt_array','rtns');

rtns = zeros(1000,1);
xopt_array = zeros(48,1000);
for itr = 1:1000
    disp('no risk aversion and risk seeking')
    itr
    period = 250;
    invest_idx = period + itr;

    R = ret(invest_idx-period:invest_idx-1,:)./100;
    R_next = ret(invest_idx,:)./100;

    R = R(:,1:48);
    R_next = R_next(1:48);

    args.lamda = 2.25;
    args.B = 0;
    args.alpha = 1;
    args.max_iter = 1000;
    args.distortion = 1;
    [xopt,yopt,res] = ADMM_CPT_solver(R,args);
    rtn_next = R_next * xopt;
    xopt_array(:,itr) = xopt;
    rtns(itr) = rtn_next;
end
save('../results/Empirical_no_risk_aversion_and_risk_seeking_daily.mat','xopt_array','rtns');

rtns = zeros(1000,1);
xopt_array = zeros(48,1000);
for itr = 1:1000
    disp('no loss aversion')
    itr
    period = 250;
    invest_idx = period + itr;

    R = ret(invest_idx-period:invest_idx-1,:)./100;
    R_next = ret(invest_idx,:)./100;

    R = R(:,1:48);
    R_next = R_next(1:48);

    args.lamda = 1;
    args.B = 0;
    args.alpha = 0.88;
    args.max_iter = 1000;
    args.distortion = 1;
    [xopt,yopt,res] = ADMM_CPT_solver(R,args);
    rtn_next = R_next * xopt;
    xopt_array(:,itr) = xopt;
    rtns(itr) = rtn_next;
end
save('../results/Empirical_no_loss_aversion_daily.mat','xopt_array','rtns');

rtns = zeros(1000,1);
xopt_array = zeros(48,1000);
for itr = 1:1000
    disp('no probability distortion')
    itr
    period = 250;
    invest_idx = period + itr;

    R = ret(invest_idx-period:invest_idx-1,:)./100;
    R_next = ret(invest_idx,:)./100;


    R = R(:,1:48);
    R_next = R_next(1:48);

    args.lamda = 2.25;
    args.B = 0;
    args.alpha = 0.88;
    args.max_iter = 1000;
    args.distortion = 0;
    [xopt,yopt,res] = ADMM_CPT_solver(R,args);
    rtn_next = R_next * xopt;
    xopt_array(:,itr) = xopt;
    rtns(itr) = rtn_next;
end
save('../results/Empirical_no_probability_distortion_daily.mat','xopt_array','rtns');

rtns = zeros(1000,1);
xopt_array = zeros(48,1000);
for itr = 1:1000
    disp('risk-free reference point')
    itr
    period = 250;
    invest_idx = period + itr;
    
    R = ret(invest_idx-period:invest_idx-1,:)./100;
    R_next = ret(invest_idx,:)./100;
    R = R(:,1:48);
    R_next = R_next(1:48);
    
    args.lamda = 2.25;
    args.B = 0.000041;
    args.alpha = 0.88;
    args.max_iter = 1000;
    args.distortion = 1;
    [xopt,yopt,res] = ADMM_CPT_solver(R,args);
    rtn_next = R_next * xopt;
    xopt_array(:,itr) = xopt;
    rtns(itr) = rtn_next;
end
save('../results/Empirical_riskfree_reference_point_daily.mat','xopt_array','rtns');
