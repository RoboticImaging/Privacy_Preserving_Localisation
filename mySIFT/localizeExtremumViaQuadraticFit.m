function [keyPt, sigmaIdx] = localizeExtremumViaQuadraticFit(i, j, sigmaIdx, octIdx, nIntervals, DoGimgInOct, ...
                                                                                                    sigma, contrastThreshold, imgBorderWidth, ...
                                                                                                    r, nAttemptsConverge)
    % quaratic fit to do subpixel location
    
    extOutsideImg = false;
    imgSize = size(DoGimgInOct(:,:,1));

    for attemptIdx = 1:nAttemptsConverge
        cube = DoGimgInOct(i-1:i+1, j-1:j+1, sigmaIdx-1:sigmaIdx+1);
        grad = computeGradAtCenterPixel(cube);
        hess = computeHessianAtCentrePixel(cube);
    end

    % up to line 155 of python which is eq (3) in SIFT paper

end