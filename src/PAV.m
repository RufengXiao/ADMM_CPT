function yopt = PAV(an,bn,wn,sigma,alpha,u1,u2,ugrad1,ugrad2,uhess1,B,findc,lb,ub,utility)
    % PAV.M
    % This function implements the Pool Adjacent Violators (PAV) algorithm for solving the y-subproblem in the paper ''Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers''.

    % Inputs:
    % an, bn, wn - Arrays containing coefficients for the y-subproblem.
    % sigma - \sigma in the y-subproblem.
    % alpha - \alpha in the model.
    % u1, u2 - Utility functions for the y-subproblem. u1 is used when y <= B, u2 is used when y > B.
    % ugrad1, ugrad2 - Gradient functions of u1 and u2.
    % uhess1 - Hessian function of u1.
    % B - Reference point B in the model.
    % findc - find the c, s.t. sigma = an hess1(c).
    % lb, ub - Lower and upper bounds for the solution.
    % utility - utility function type. 2 only for the section 5.3, 1 in other sections.

    % Outputs:
    % yopt - Optimal solution for the y-subproblem

    [~,N] = size(an);
    
    pools = 1:N;
    yval = [zeros(1,N);zeros(1,N)]; % second is the flag place
    blocks_num = N;
    
    flag = 1;
    
    while flag

        for j = 1:blocks_num
            if j == 1
                cur = 1:pools(j);
            else
                cur = pools(j-1)+1:pools(j);
            end

            if yval(2,j) == 0
                cur_an = an(cur);
                cur_bn = bn(cur);
                cur_wn = wn(cur);
                a = sum(cur_an);
                b = sum(cur_bn);
                w = mean(cur_wn);
                [~,cur_size] = size(cur_an);
                s = sigma * cur_size;
                
                func = @(y) Utility(y,a,b,u1,u2,B) + s/2*(y-w).^2;
                grad1 = @(y) -a * ugrad1(y) + s*(y-w);
                grad2 = @(y) -b *ugrad2(y) + s*(y-w);
                hess1 = @(y) -a * uhess1(y) + s;
                C = findc(s,a);
                y_mini = find_minimizer(alpha,func,grad1,grad2,hess1,B,C,lb,ub,utility);

                yval(1,j) = y_mini;
                yval(2,j) = 1;
            end
        end
        
        isotone = 1;
        for j = 1:blocks_num-1
            if yval(1,j+1) < yval(1,j)
                isotone = 0;
                pool_block = j;
                break
            end
        end
        if isotone == 1
            flag = 0;
        else
            blocks_num = blocks_num - 1;
            pools(pool_block) = pools(pool_block)+1;
            pools(pool_block+1) = [];
            yval(2,pool_block) = 0; % flag place is set to 0
            yval(:,pool_block+1) = []; 
        end 
    end
    
    yopt = zeros(1,N);
    
    for j = 1:blocks_num
        if j == 1
            yopt(1:pools(j)) = yval(1,j);
        else
            yopt(pools(j-1)+1:pools(j)) = yval(1,j);
        end
    end
end

function u = Utility(y,a,b,u1,u2,B)
    if y <= B
        u = -a*u1(y);
    else
        u = -b*u2(y);
    end
end