function [an,bn] = coefficients_generating(N,distortion_num,delta_neg,delta_pos)
    % COEFFICIENTS_GENERATING.M
    % This function generates coefficients 'an' and 'bn' for use in the models in the paper ''Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers''.
    % Inputs:
    % N - The number of coefficients to generate.
    % distortion_num - Selector for the distortion function to be used.
    % delta_neg - Parameter for the distortion function affecting 'an' coefficients.
    % delta_pos - Parameter for the distortion function affecting 'bn' coefficients.

    % The function supports two types of distortion functions, selected by 'distortion_num'.
    % distortion_num = 2: the setting in section 5.3 of the paper
    % distortion_num = 1: the setting in other sections of the paper

    % Outputs:
    % an - Array of 'an' coefficients.
    % bn - Array of 'bn' coefficients.
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