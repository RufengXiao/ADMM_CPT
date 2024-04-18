function [Hs,Hs2] = dynamic_programming(an_array,bn_array,wn_array,sigma,args)
    [~,N] = size(an_array);
    B = args.B;
    lb = min(min(wn_array),-10);
    ub = B + 10;
    ub2 = max(wn_array) + args.alpha * max(bn_array) / sigma;
    ub = max(ub,ub2);
    H1less = {Block(0,0,0,0,lb,B,sigma,1,args)}; % current hn blocks
    H1more = {Block(0,0,0,0,B,ub,sigma,2,args)};
    Hs = {H1less}; % smaller than B
    Hs2 = {H1more}; % bigger than B
    
    for j = 1:N
        Hless = Hs{j};
        philess = {};
        [~,m] = size(Hless);
        for i = 1:m
            philess = [philess,Hless{i}.add_fn(an_array(j),wn_array(j))];
        end
        
        decomposed_philess = {};
        for i = 1:m
            decomposed_philess = [decomposed_philess,philess{i}.block_breaking()];
        end
        
        premin = 10000000;
        hn = {};
        [~,M] = size(decomposed_philess);
        for i = 1:M
            cur = decomposed_philess{i};
            updated_hn = cur.update(premin);
            [~,last_index] = size(updated_hn);
            last = updated_hn{last_index};
            premin = last.obj(last.end_point);
            hn = [hn,updated_hn];
        end
        hn = merge(hn);
        %hn
        Hs = [Hs,{hn}];
        %Hs
        
        Hmore = Hs2{j};
        phimore = {};
        [~,m] = size(Hmore);
        for i = 1:m
            phimore = [phimore,Hmore{i}.add_fn(bn_array(j),wn_array(j))];
        end
        
        decomposed_phimore = {};
        for i = 1:m
            decomposed_phimore = [decomposed_phimore,phimore{i}.block_breaking()];
        end
        
        hn2 = {};
        [~,M] = size(decomposed_phimore);
        for i = 1:M
            cur = decomposed_phimore{i};
            updated_hn = cur.update(premin);
            [~,last_index] = size(updated_hn);
            last = updated_hn{last_index};
            premin = last.obj(last.end_point);
            hn2 = [hn2,updated_hn];
        end
        hn2 = merge(hn2);
        Hs2 = [Hs2,{hn2}];
    end

end