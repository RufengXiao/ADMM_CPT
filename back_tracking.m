function xopt = back_tracking(Hs,Hs2)
    [~,Hlength] = size(Hs);
    N = Hlength - 1;
    xopt = zeros(1,N);
    Hlast = [Hs{Hlength},Hs2{Hlength}];
    Hlast = merge(Hlast);
    [~,last_index] = size(Hlast);
    xopt(N) = Hlast{last_index}.start_point;
    for n = N:-1:2
        Hn = [Hs{n},Hs2{n}];
        Hn = merge(Hn);
        xn = xopt(n);
        [~,m] = size(Hn);
        for i = m:-1:1
            cur = Hn{i};
            if cur.start_point <= xn && cur.end_point >= xn
                break
            end
        end
        if cur.D == 0
            xopt(n-1) = cur.start_point;
        else
            xopt(n-1) = xn;
        end
    end
end