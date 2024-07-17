function yopt = dynamic_programming(an_array,bn_array,wn_array,sigma,args)
    [~,N] = size(an_array);
    B = args.B;
    lb = min(min(wn_array),-10);
    ub = B + 10;
    ub2 = max(wn_array) + args.alpha * max(bn_array) / sigma;
    ub = max(ub,ub2);
    
    
    % current hn intervals which is smaller than B, only store the
    % end_point of any intervals
    hnlessinterval = [B];
    % current hn intervals which is smaller than B, only store the
    % end_point of any intervals
    hnmoreinterval = [ub];
    % a, w, D, M of current hn intervals which is smaller than B
    awDMless = zeros(4,1); %1: a 2: w 3: D 4: M
    % a, w, D, M of current hn intervals which is smaller than B
    awDMmore = zeros(4,1); %1: a 2: w 3: D 4: M
    % store all intervals smaller than B of hn (n=1,...,N+1) 
    Hless = cell(N+1,1);
    % store all intervals bigger than B of hn (n=1,...,N+1) 
    Hmore = cell(N+1,1);
    % store D in all intervals smaller than B of hn (n=1,...,N+1)
    awDMlesscell = cell(N+1,1);
    % store D in all intervals bigger than B of hn (n=1,...,N+1)
    awDMmorecell = cell(N+1,1);

    Hless{1} = hnlessinterval;
    Hmore{1} = hnmoreinterval;
    awDMlesscell{1} = awDMless;
    awDMmorecell{1} = awDMmore;

    for j = 1:N
        % awDM(1,): a || awDM(2,): w || awDM(3,): D || awDM(4,): M
        % creat phi_j in the any intervals
        [~,m] = size(hnlessinterval);
        % creat the awDM array for phi_j
        awDMless = add_fn(awDMless,an_array(j),wn_array(j),m,sigma);
        % Decompose
        [awDMless,hnlessinterval] = block_breaking(awDMless,hnlessinterval,m,1,sigma,args,lb);

        % Update
        premin = 10000000;
        [~,m] = size(hnlessinterval);
        [awDMless,hnlessinterval,premin] = update(awDMless,hnlessinterval,m,1,sigma,args,lb,premin);

        % Merge
        [awDMless,hnlessinterval] = merge(awDMless,hnlessinterval,m);

        % Store
        Hless{1+j} = hnlessinterval;
        awDMlesscell{1+j} = awDMless;

        % creat phi_j in the any intervals
        [~,m] = size(hnmoreinterval);
        % creat the awDM array for phi_j
        awDMmore = add_fn(awDMmore,bn_array(j),wn_array(j),m,sigma);
        % Decompose
        [awDMmore,hnmoreinterval] = block_breaking(awDMmore,hnmoreinterval,m,2,sigma,args,lb);

        % Update
        [~,m] = size(hnmoreinterval);
        [awDMmore,hnmoreinterval,~] = update(awDMmore,hnmoreinterval,m,2,sigma,args,lb,premin);

        % Merge
        [awDMmore,hnmoreinterval] = merge(awDMmore,hnmoreinterval,m);

        % Store
        Hmore{1+j} = hnmoreinterval;
        awDMmorecell{1+j} = awDMmore;
    end
    % back_tracking
    yopt = zeros(1,N);
    hnlastinterval = [Hless{N+1},Hmore{N+1}];
    awDMlast = [awDMlesscell{N+1},awDMmorecell{N+1}];
    [~,m] = size(hnlastinterval);
    [awDMlast,hnlastinterval] = merge(awDMlast,hnlastinterval,m);
    yopt(N) = hnlastinterval(m-1);
    for n = N:-1:2
        hnlastinterval = [Hless{n},Hmore{n}];
        awDMlast = [awDMlesscell{n},awDMmorecell{n}];
        [~,m] = size(hnlastinterval);
        [awDMlast,hnlastinterval] = merge(awDMlast,hnlastinterval,m);
        [~,m] = size(hnlastinterval);
        xn = yopt(n);
        for i = m:-1:1
            if i == 1
                start_point = lb;
            else
                start_point = hnlastinterval(i-1);
            end
            end_point = hnlastinterval(i);
            if start_point <= xn && end_point >= xn
                break
            end
        end
        if awDMlast(3,i) == 0
            yopt(n-1) = start_point;
        else
            yopt(n-1) = xn;
        end
    end
end



function new_awDM = add_fn(awDM,an,wn,m,sigma)
    % awDM(1,): a || awDM(2,): w || awDM(3,): D || awDM(4,): M
    new_awDM = zeros(4,m);
    for i = 1:m
        if awDM(3,i) == 0
            new_awDM(:,i) = [an,wn,1,awDM(4,i)];
        else
            D = awDM(3,i);
            neww = (D*awDM(2,i)+wn)/(D+1);
            new_awDM(:,i) = [(D*awDM(1,i)+an)/(D+1),neww,D+1,awDM(4,i)+sigma/2*(D*awDM(2,i)^2+wn^2-(D+1)*neww^2)];
        end
    end
end

function res = gradient(x,a,w,D,sigma,Bflag,args)
   if Bflag == 1
       if x>args.B
           disp('invalid value of x');
       end
       res = D*(-args.alpha*args.lamda*a*(args.B - x)^(args.alpha-1) + sigma*(x-w));
   else
       if x<args.B
           disp('invalid value of x');
       end
       res = D*(-args.alpha*a*(x-args.B)^(args.alpha - 1) + sigma*(x-w));
   end
   
   % more stable
   if abs(x-args.B) < 1e-10
       res = -1000000;
   end
end

function [awDM, hninterval] = block_breaking(awDM,hninterval,m,Bflag,sigma,args,lb)
    % awDM(1,): a || awDM(2,): w || awDM(3,): D || awDM(4,): M
    maxsteps = 100;
    count = 0;
    i = 1;
    if Bflag == 1 
        while count < m
            a = awDM(1,i);
            w = awDM(2,i);
            D = awDM(3,i);
            M = awDM(4,i);
            C = args.B - (sigma/(args.lamda*args.alpha*(1-args.alpha)*a))^(1/(args.alpha-2));
            if i == 1
                start_point = lb;
            else
                start_point = hninterval(i-1);
            end
            end_point = hninterval(i);
            cur_gradient = @(x) gradient(x,a,w,D,sigma,1,args);
            if cur_gradient(C) > 0
                if (cur_gradient(start_point) * cur_gradient(end_point)) <= 0
                    m1 = bisectionMethod(cur_gradient,start_point,end_point,1e-8,maxsteps);
                    awDM = [awDM(:,1:i),[a,w,D,M]',awDM(:,i+1:end)];
                    hninterval(i) = m1;
                    hninterval = [hninterval(1:i),end_point,hninterval(i+1:end)];
                    i = i + 1;
                elseif cur_gradient(start_point) <= 0 && cur_gradient(end_point)<=0 && end_point >= C
                    m1 = bisectionMethod(cur_gradient,start_point,C,1e-8,maxsteps);
                    m2 = bisectionMethod(cur_gradient,C,end_point,1e-8,maxsteps);
                    if m2 == end_point
                        m2 = C;
                    end
                    awDM = [awDM(:,1:i),[a,w,D,M]',[a,w,D,M]',awDM(:,i+1:end)];
                    hninterval(i) = m1;
                    hninterval = [hninterval(1:i),m2,end_point,hninterval(i+1:end)];
                    i = i + 2;
                end
            end
            i = i + 1;
            count = count + 1;
        end
    else
        while count < m
            a = awDM(1,i);
            w = awDM(2,i);
            D = awDM(3,i);
            M = awDM(4,i);
            if i == 1
                start_point = args.B;
            else
                start_point = hninterval(i-1);
            end
            end_point = hninterval(i);
            cur_gradient = @(x) gradient(x,a,w,D,sigma,2,args);
            if cur_gradient(start_point) <= 0 && cur_gradient(end_point) >= 0
                m1 = bisectionMethod(cur_gradient,start_point,end_point,1e-8,maxsteps);
                awDM = [awDM(:,1:i),[a,w,D,M]',awDM(:,i+1:end)];
                hninterval(i) = m1;
                hninterval = [hninterval(1:i),end_point,hninterval(i+1:end)];
                i = i + 1;
            end
            i = i + 1;
            count = count + 1;
        end
    end
end

function res = obj(x,a,w,D,M,sigma,Bflag,args)
   if Bflag == 1
       if x>args.B
           disp('invalid value of x');
       end
       res = D*(args.lamda*a*(args.B - x)^args.alpha + sigma/2*(x-w)^2)+M;
   else
       if x<args.B
           disp('invalid value of x');
       end
       res = D*(-a*(x-args.B)^args.alpha + sigma/2*(x-w)^2)+M;
   end
end


function [awDM,hninterval,premin] = update(awDM,hninterval,m,Bflag,sigma,args,lb,premin)
    i = 1;
    count = 0;
    while count < m
        a = awDM(1,i);
        w = awDM(2,i);
        D = awDM(3,i);
        M = awDM(4,i);
        if i == 1 
            if hninterval(i) <= args.B
                start_point = lb;
            else
                start_point = args.B;
            end
        else
            start_point = hninterval(i-1);
        end
        end_point = hninterval(i);
        cur_obj = @(x) obj(x,a,w,D,M,sigma,Bflag,args);
        if cur_obj(start_point) <= cur_obj(end_point)
            awDM(:,i) = [0,0,0,premin];
            premin = obj(end_point,0,0,0,premin,sigma,Bflag,args);
        else
            if cur_obj(start_point) > premin + 1e-8
                if cur_obj(end_point) >= premin
                    awDM(:,i) = [0,0,0,premin];
                    premin = obj(end_point,0,0,0,premin,sigma,Bflag,args);
                else
                    f = @(x) obj(x,a,w,D,M,sigma,Bflag,args) - premin;
                    m1 = bisectionMethod(f, start_point, end_point, 1e-8, 40);
                    awDM(:,i) = [0,0,0,premin];
                    awDM = [awDM(:,1:i),[a,w,D,M]',awDM(:,i+1:end)];
                    hninterval(i) = m1;
                    hninterval = [hninterval(1:i),end_point,hninterval(i+1:end)];
                    i = i + 1;
                    premin = obj(end_point,a,w,D,M,sigma,Bflag,args);
                end
            else
                premin = obj(end_point,a,w,D,M,sigma,Bflag,args);
            end
        end
        i = i + 1;
        count = count + 1;
    end
end 

function [awDM,hninterval] = merge(awDM,hninterval,m)
    % awDM(1,): a || awDM(2,): w || awDM(3,): D || awDM(4,): M
    i = 1;
    count = 0;
    while count < m
        if awDM(3,i) > 0
            i = i+1;
            count = count+1;
        else
            end_point = hninterval(i);
            v = awDM(4,i);
            pre_i = i;
            while count < m && awDM(3,i) == 0
                end_point = hninterval(i);
                i = i + 1;
                count = count + 1;
            end
            hninterval(pre_i) = end_point;
            hninterval(pre_i+1:i-1) = [];
            awDM(:,pre_i) = [0,0,0,v];
            awDM(:,pre_i+1:i-1) = [];
            i = pre_i + 1;
        end
    end
end