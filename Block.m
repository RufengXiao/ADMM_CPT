function cargo = Block(D,a,w,M,start_point,end_point,sigma,type,args)
%     cargo.B = 0.00;
%     cargo.lamda = 2.25;
    cargo.sigma = sigma;
%     cargo.alpha = 0.88;
    cargo.args = args;
    cargo.B = args.B;
    cargo.lamda = args.lamda;
    cargo.alpha = args.alpha;
    cargo.D = D;
    cargo.a = a;
    cargo.w = w;
    cargo.M = M;
    cargo.start_point = start_point;
    cargo.end_point = end_point;
    cargo.type = type;
    cargo.obj = @(x)obj(cargo,x);
    cargo.gradient = @(x)gradient(cargo,x);
    if type == 1
        cargo.C = cargo.B - (cargo.sigma/(cargo.lamda*cargo.alpha*(1-cargo.alpha)*a))^(1/(cargo.alpha-2));
    end
    cargo.block_breaking = @()block_breaking(cargo);
    cargo.update = @(premin)update(cargo,premin);
    cargo.add_fn = @(an,wn)add_fn(cargo,an,wn);
end

function res = obj(cargo,x)
   if cargo.type == 1
       if x>cargo.B
           disp('invalid value of x');
       end
       res = cargo.D*(cargo.lamda*cargo.a*(cargo.B - x)^cargo.alpha + cargo.sigma/2*(x-cargo.w)^2)+cargo.M;
   else
       if x<cargo.B
           disp('invalid value of x');
       end
       res = cargo.D*(-cargo.a*(x-cargo.B)^cargo.alpha + cargo.sigma/2*(x-cargo.w)^2)+cargo.M;
   end
end

function res = gradient(cargo,x)
   if cargo.type == 1
       if x>cargo.B
           disp('invalid value of x');
       end
       res = cargo.D*(-cargo.alpha*cargo.lamda*cargo.a*(cargo.B - x)^(cargo.alpha-1) + cargo.sigma*(x-cargo.w));
   else
       if x<cargo.B
           disp('invalid value of x');
       end
       res = cargo.D*(-cargo.alpha*cargo.a*(x-cargo.B)^(cargo.alpha - 1) + cargo.sigma*(x-cargo.w));
   end
   
   % more stable
   if abs(x-cargo.B) < 1e-10
       res = -1000000;
   end
end

function intervals = block_breaking(cargo)
    maxsteps = 100;
    if cargo.type == 1
        if cargo.gradient(cargo.C) <=0
            intervals = {Block(cargo.D,cargo.a,cargo.w,cargo.M,cargo.start_point,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};
        elseif cargo.gradient(cargo.start_point ) <=0 && cargo.gradient(cargo.end_point)>=0
            m1 = bisectionMethod(cargo.gradient,cargo.start_point,cargo.end_point,1e-8,maxsteps);
            intervals = {Block(cargo.D,cargo.a,cargo.w,cargo.M,cargo.start_point,m1,cargo.sigma,cargo.type,cargo.args),...
                         Block(cargo.D,cargo.a,cargo.w,cargo.M,m1,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};
        elseif cargo.gradient(cargo.start_point ) <=0 && cargo.gradient(cargo.end_point)<=0 && cargo.end_point >= cargo.C
             m1 = bisectionMethod(cargo.gradient,cargo.start_point,cargo.C,1e-8,maxsteps);
             m2 = bisectionMethod(cargo.gradient,cargo.C,cargo.end_point,1e-8,maxsteps);
             if m2 == cargo.end_point
                 m2 = cargo.C;
             end
             intervals = {Block(cargo.D,cargo.a,cargo.w,cargo.M,cargo.start_point,m1,cargo.sigma,cargo.type,cargo.args),...
                         Block(cargo.D,cargo.a,cargo.w,cargo.M,m1,m2,cargo.sigma,cargo.type,cargo.args),...
                          Block(cargo.D,cargo.a,cargo.w,cargo.M,m2,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};
        elseif cargo.gradient(cargo.start_point)>=0 && cargo.gradient(cargo.end_point)<=0
              m1 = bisectionMethod(cargo.gradient,cargo.start_point,cargo.end_point,1e-8,maxsteps);
              intervals = {Block(cargo.D,cargo.a,cargo.w,cargo.M,cargo.start_point,m1,cargo.sigma,cargo.type,cargo.args),...
                         Block(cargo.D,cargo.a,cargo.w,cargo.M,m1,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};
        else
             
             intervals = {Block(cargo.D,cargo.a,cargo.w,cargo.M,cargo.start_point,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};
        end

    else
        if cargo.gradient(cargo.start_point)<=0 && cargo.gradient(cargo.end_point)>=0
             m1 = bisectionMethod(cargo.gradient,cargo.start_point,cargo.end_point,1e-8,maxsteps);
             intervals = {Block(cargo.D,cargo.a,cargo.w,cargo.M,cargo.start_point,m1,cargo.sigma,cargo.type,cargo.args),...
                         Block(cargo.D,cargo.a,cargo.w,cargo.M,m1,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};
        else
            intervals = {Block(cargo.D,cargo.a,cargo.w,cargo.M,cargo.start_point,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};
        end
    end
end

function res = find_value(cargo,x,tofind)
    res = cargo.obj(x) - tofind;
end

function intervals = update(cargo,premin)
    if cargo.obj(cargo.start_point) <= cargo.obj(cargo.end_point)
        intervals = {Block(0,0,0,premin,cargo.start_point,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};
    else
        if cargo.obj(cargo.start_point) <= premin + 1e-8
            intervals = {Block(cargo.D,cargo.a,cargo.w,cargo.M,cargo.start_point,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};
        elseif cargo.obj(cargo.end_point) >= premin
            intervals = {Block(0,0,0,premin,cargo.start_point,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};
        else
            f=@(x)find_value(cargo,x,premin);
            m1 = bisectionMethod(f,cargo.start_point,cargo.end_point,1e-8,40);
            intervals = {Block(0,0,0,premin,cargo.start_point,m1,cargo.sigma,cargo.type,cargo.args),...
                         Block(cargo.D,cargo.a,cargo.w,cargo.M,m1,cargo.end_point,cargo.sigma,cargo.type,cargo.args)};            
        end
    end
end 

function new_cargo = add_fn(cargo,an,wn)
    if cargo.D == 0
        new_cargo = Block(1,an,wn,cargo.M,cargo.start_point,cargo.end_point,cargo.sigma,cargo.type,cargo.args);
    else
        newD = cargo.D+1;
        newA = (cargo.D*cargo.a + an)/newD;
        newW = (cargo.D*cargo.w + wn)/newD;
        newM = cargo.M + cargo.sigma/2*(cargo.D*cargo.w^2 + wn^2 - newD*newW^2);
        new_cargo = Block(newD,newA,newW,newM,cargo.start_point,cargo.end_point,cargo.sigma,cargo.type,cargo.args);
    end
end