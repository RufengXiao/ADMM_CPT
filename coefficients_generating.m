function [an,bn] = coefficients_generating(N,distortion_num,delta_neg,delta_pos)
    if distortion_num == 1
        an = zeros(1,N);
        bn = zeros(1,N);
        for i = 1:N
            an(i) = distortion(i/N,delta_neg) - distortion((i-1)/N,delta_neg);
            bn(i) = distortion((N-i+1)/N,delta_pos) - distortion((N-i)/N,delta_pos);
        end
    elseif distortion_num == 2
        an = -diff(distortionarray(flip(cumsum(ones(1,N)/N)), delta_neg));
        an = [an, distortion(1/N, delta_neg)];
        % make monotone
        idx_min = find(an==min(an));
        an(1:idx_min) = an(idx_min);
        an = flip(an);
    
        bn = -diff(distortionarray(flip(cumsum(ones(1,N)/N)), delta_pos));
        bn = [bn, distortion(1/N, delta_pos)];
        % make monotone
        idx_min = find(bn==min(bn));
        bn(1:idx_min) = bn(idx_min);
    else
        an = 1/N*ones(1,N);
        bn = 1/N*ones(1,N);
    end
end


function res = distortion(p,gamma)
    res = p^gamma/(p^gamma + (1-p)^gamma)^(1/gamma);
end

function res = distortionarray(p,gamma)
    res = p.^gamma./(p.^gamma + (1-p).^gamma).^(1/gamma);
end