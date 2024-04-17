function x = bisectionMethod(yourFunction, xLower, xUpper, errorTolerance, maxIteration)

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