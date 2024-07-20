function x = bisectionMethod(yourFunction, xLower, xUpper, errorTolerance, maxIteration)
% BISECTIONMETHOD.M
% This function implements the bisection method for finding a root of a function within a specified interval.
% Inputs:
% yourFunction - The function for which the root is being sought. It should be a function handle.
% xLower - The lower bound of the interval in which to search for the root.
% xUpper - The upper bound of the interval in which to search for the root.
% errorTolerance - The tolerance for the error in the root estimation. The method stops when the change in the root estimate is below this threshold.
% maxIteration - The maximum number of iterations to perform. This prevents infinite loops if the method does not converge.
% Outputs:
% x - The root estimate found by the bisection method.
% If only 3 inputs are provided, sets the default maximum iterations to 100.

% if only 3 inputs are called sets the default iterations to 10
if nargin == 4
    maxIteration = 100;
end

% initiallizes several variables to be used later
xMiddleOld = xLower;
percentError = 1;
i = 1;
% creates a while loop to continue calculating until the errorTolerance % is reached or it has done the maxIterations
while percentError > errorTolerance && i < maxIteration
    i = i+1;
    xMiddle = 0.5 * (xLower + xUpper);
    yLower = yourFunction(xLower);
    yMiddle = yourFunction(xMiddle);

    percentError = abs((xMiddle - xMiddleOld)/xMiddle) * 100;

    xMiddleOld = xMiddle;

    if yMiddle < 0 && yLower < 0 || yMiddle > 0 && yLower > 0
        xLower = xMiddle;
    else 
        xUpper = xMiddle;
    end
    x = xMiddle;
end
end