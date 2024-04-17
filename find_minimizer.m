function x_mini = find_minimizer(alpha,func,grad1,grad2,hess1,B,C,lb,ub,utility)
    if utility == 1
        if alpha == 1
            xs = [];
            fvals = [];
            if grad2(B) < 0
                x1 = bisectionMethod(grad2,B,ub,1e-8,80);
                xs = [xs,x1];
                fvals = [fvals,func(x1)];
            end
            
            
            if grad1(B) > 0
                x2 = bisectionMethod(grad1,lb,B,1e-8,80);
                xs = [xs,x2];
                fvals = [fvals,func(x2)];
            end
            
            
            xs = [xs,B];
            fvals = [fvals,func(B)];
        
            
            fmin = Inf;
            
            m = size(xs,2);
            
            for i = 1:m
                if fmin > fvals(i)
                    x_mini = xs(i);
                    fmin = fvals(i);
                end
            end
        else
            xs = [];
            fvals = [];
            if grad2(B) < 0
                x1 = bisectionMethod(grad2,B,ub,1e-8,80);
                xs = [xs,x1];
                fvals = [fvals,func(x1)];
            end
            
            if hess1(B) >= 0
                if grad1(B) > 0
                    x2 = bisectionMethod(grad1,lb,B,1e-8,80);
                    xs = [xs,x2];
                    fvals = [fvals,func(x2)];
                end
            else
                if grad1(C) >  0
                    if grad1(C) > 0
                        x3 = bisectionMethod(grad1,lb,C,1e-8,80);
                        xs = [xs,x3];
                        fvals = [fvals,func(x3)];
                    end
                end
            end
            
            
            if (  (grad1(B) < 0) && grad1(B) > 0)
                xs = [xs,B];
                fvals = [fvals,func(B)];
            end
            
            fmin = Inf;
            
            m = size(xs,2);
            
            for i = 1:m
                if fmin > fvals(i)
                    x_mini = xs(i);
                    fmin = fvals(i);
                end
            end
        end
    else
        xs = [];
        fvals = [];
    
        if grad2(B) < 0
            x1 = bisectionMethod(grad2,B,ub,1e-8,80);
            xs = [xs,x1];
            fvals = [fvals,func(x1)];
        else
            x1 = B;
            xs = [xs,x1];
            fvals = [fvals,func(x1)];
        end
    
        if hess1(B) < 0
            if grad1(C) > 0
                x2 = bisectionMethod(grad1,lb,C,1e-8,80);
                xs = [xs,x2];
                fvals = [fvals, func(x2)];
            end
        else
            if grad1(B) > 0
                x2 = bisectionMethod(grad1,lb,B,1e-8,80);
                xs = [x2];
                fvals = [fvals, func(x2)];
            end
        end
    
        fmin = Inf;
        
        m = size(xs,2);
        
        for i = 1:m
            if fmin > fvals(i)
                x_mini = xs(i);
                fmin = fvals(i);
            end
        end
    
        if m == 0
            x_mini = B;
        end
    end
end