function xopt = PAV_solver(an,bn,wn,args,sigma)
    % PAV_SOLVER.M
    % This function solves the y-subproblem using the Pool Adjacent Violators (PAV) algorithm which is the Algorithm 4 in the paper ``Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers''
    % Inputs:
    % an - Array of 'an' coefficients for the y-subproblem.
    % bn - Array of 'bn' coefficients for the y-subproblem.
    % wn - Array of \omega for the y-subproblem.
    % sigma - \sigma in the y-subproblem.
    % args.lambda: \mu in the model
    % args.alpha: \alpha in the model
    % args.B: reference point B in the model

    % Outputs:
    % xopt - Optimal solution for the y-subproblem

    if args.utility == 1
        if args.alpha == 1
            B = args.B;
            lamda = args.lamda;
            alpha = args.alpha;
            u1 = @(y) -lamda * (B-y);
            u2 = @(y) (y-B);
            ugrad1 = @(y) lamda;
            ugrad2 = @(y) alpha;
            uhess1 = @(y) 0;
            lb = wn(1);
            ub = max(B+1, wn(end) + max(bn)*ugrad2(B+1)/sigma);
            findc = @(sigma,a) B;
            xopt = PAV(an,bn,wn,sigma,alpha,u1,u2,ugrad1,ugrad2,uhess1,B,findc,lb,ub,args.utility);
        else
            B = args.B;
            lamda = args.lamda;
            alpha = args.alpha;
            u1 = @(y) -lamda * (B-y)^alpha;
            u2 = @(y) (y-B)^alpha;
            ugrad1 = @(y) lamda*alpha*(B-y)^(alpha-1);
            ugrad2 = @(y) alpha*(y-B)^(alpha-1);
            uhess1 = @(y) lamda*alpha*(1-alpha)*(B-y)^(alpha-2);
            lb = wn(1);
            ub = max(B+1, wn(end) + max(bn)*ugrad2(B+1)/sigma);
            findc = @(sigma,a) B - (sigma/(lamda*alpha*(1-alpha)*a))^(1/(alpha-2));
            xopt = PAV(an,bn,wn,sigma,alpha,u1,u2,ugrad1,ugrad2,uhess1,B,findc,lb,ub,args.utility);
        end
    else
        B = args.B;
        gamma_neg = args.gamma_neg;
        gamma_pos = args.gamma_pos;
        alpha = 0;
        u1 = @(y) -1 + exp(gamma_neg*(y-B));
        u2 = @(y) 1 - exp(gamma_pos*(B-y));
        ugrad1 = @(y) gamma_neg * exp(gamma_neg*(y-B));
        ugrad2 = @(y) gamma_pos * exp(gamma_pos*(B-y));
        uhess1 = @(y) gamma_neg^2 * exp(gamma_neg*(y-B));
        lb = wn(1);
        ub = max(B+1, wn(end) + max(bn)*ugrad2(B+1)/sigma);
        findc = @(sigma,a) B + log(sigma/(gamma_neg^2*a))/gamma_neg;
        xopt = PAV(an,bn,wn,sigma,alpha,u1,u2,ugrad1,ugrad2,uhess1,B,findc,lb,ub,args.utility);
    end
end