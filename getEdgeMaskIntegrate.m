function mask = getEdgeMaskIntegrate(matrixSize,theta)
    % takes theta (deg) and matrix size to do fancy interp
    theta = mod(theta,360);
    mask = zeros(matrixSize);
    
    edgeFn = @(x,y) double(getDistanceFromEdge(x,y,theta) > 0);
    for i = 1:matrixSize
        for j = 1:matrixSize
            [xPt,yPt] = matrixIndexToCoord(i,j,matrixSize);
            mask(i,j) = integral2(edgeFn, xPt - 0.5, xPt + 0.5, yPt - 0.5, yPt + 0.5);
        end
    end
%     mask = mask./(matrixSize^2/2);
end