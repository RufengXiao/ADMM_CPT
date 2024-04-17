function res = merge(intervals)
    res = {};
    [~,m] = size(intervals);
    i = 1;
    while i <= m
        cur = intervals{i};
        if cur.D > 0
            res = [res,cur];
            i = i+1;
        else
            start_point = cur.start_point;
            end_point = cur.end_point;
            v = cur.M;
            type = cur.type;
            while i <= m && intervals{i}.D == 0
                end_point = intervals{i}.end_point;
                i = i+1;
            end
            res = [res, Block(0,0,0,v,start_point,end_point,cur.sigma,type,cur.args)];
        end
    end
end