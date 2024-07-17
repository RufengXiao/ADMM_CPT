clc
clear all
addpath(genpath('../'))

periods = [50,100,200,300,400,500];
period_num = 6;

repeat_num = 10;
dp_val = zeros(period_num,repeat_num);
dp_time = zeros(period_num,repeat_num);
pav_val = zeros(period_num,repeat_num);
pav_time = zeros(period_num,repeat_num);
fmincon_val = zeros(period_num,repeat_num);
fmincon_time = zeros(period_num,repeat_num);

rand('seed',0);
for i = 1:period_num
    for j = 1:repeat_num
        N = periods(i);
        [an,bn] = coefficients_generating(N,1,0.69,0.61);
        wn = -0.1+2*0.1*rand(1,N);
        wn = sort(wn);
        args.B = 0;
        args.lamda = 2.25;
        args.alpha = 0.88;
        sigma = 10;
        t1 = clock;
        xopt = dynamic_programming(an,bn,wn,sigma,args);
        t2 = clock;
        res = obj(an,bn,wn,xopt);
        dp_val(i,j) = res;
        dp_time(i,j) = etime(t2,t1);
        
        t1 = clock;
        args.lamda = 2.25;
        args.alpha = 0.88;
        args.B = 0;
        args.utility = 1;
        xopt2 = PAV_solver(an,bn,wn,args,sigma);
        t2 = clock;
        res2 = obj(an,bn,wn,xopt2);
        pav_val(i,j) = res2;
        pav_time(i,j) = etime(t2,t1);
        
        t1 = clock;
        f = @(xn)obj(an,bn,wn,xn);
        [~,N] = size(wn);
        A = zeros(N-1,N);
        for k = 1:N-1
            A(k,k) = 1;
            A(k,k+1) = -1;
        end
        b = zeros(N-1,1);
        options = optimoptions(@fmincon,'MaxFunctionEvaluations',1000000,'MaxIterations',3000);
        [x,fval] = fmincon(f,wn,A,b,[],[],[],[],[],options);
        t2 = clock;
        fmincon_val(i,j) = fval;
        fmincon_time(i,j) = etime(t2,t1);
    end
end
save('../results/5-1_subproblemtest.mat','dp_val','dp_time','pav_val','pav_time','fmincon_val','fmincon_time');

function res = obj(an,bn,wn,xn)
    sigma = 10;
    B = 0;
    alpha = 0.88;
    lamda = 2.25;
    res = 0;
    [~,N] = size(xn);
    for i = 1:N
        x = xn(i);
        if x > B
            res = res - bn(i)*(x-B)^alpha + sigma/2*(x-wn(i))^2;
        else
            res = res + lamda*an(i)*(B-x)^alpha + sigma/2*(x-wn(i))^2;
        end
    end
end