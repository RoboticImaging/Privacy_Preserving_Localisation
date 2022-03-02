function [keyPt, sigmaIdx] = localizeExtremumViaQuadraticFit(i, j, sigmaIdx, octIdx, nIntervals, DoGimgInOct, ...
                                                                                                    sigma, contrastThreshold, imgBorderWidth, ...
                                                                                                    r, nAttemptsConverge)
    % quaratic fit to do subpixel location
    
    extOutsideImg = false;
    imgSize = size(DoGimgInOct(:,:,1));
    


end