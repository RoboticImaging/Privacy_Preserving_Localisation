function [keyPt, sigmaIdx] = localizeExtremumViaQuadraticFit(i, j, sigmaIdx, octIdx, nIntervals, DoGimgInOct, ...
                                                                                                    sigma, contrastThreshold, imgBorderWidth, ...
                                                                                                    r, nAttemptsConverge)
    % note that sigmaIdx is off by one to help calculate cube efficiently
    % quaratic fit to do subpixel location
    
    extOutsideImg = false;
    imgSize = size(DoGimgInOct(:,:,1));

    % try to converge to exact extremum
    for attemptIdx = 1:nAttemptsConverge
        cube = DoGimgInOct(i-1:i+1, j-1:j+1, sigmaIdx:sigmaIdx+2);
        grad = computeGradAtCenterPixel(cube);
        hess = computeHessianAtCentrePixel(cube);
        extUpdate = -inv(hess)*grad;

        % check if we are still within the same pixel
        if max(abs(extUpdate)) < 0.5
            break
        end

        % if not, move over to next pixel as needed
        i = i + round(extUpdate(1));
        j = j + round(extUpdate(2));
        sigmaIdx = sigmaIdx + round(extUpdate(3));

        % check if outside image
        if (i < imgBorderWidth || i > size(DoGimgInOct,1) - imgBorderWidth ||...
            j < imgBorderWidth || j > size(DoGimgInOct,1) - imgBorderWidth ||...
            sigmaIdx < 1 || sigmaIdx > nIntervals)
            extOutsideImg = true;
            break
        end
    end

    % check if keypoint max wasn't found
    if extOutsideImg || attemptIdx == nAttemptsConverge
        keyPt = NaN;
        sigmaIdx = NaN;
        return
    end

    fnValAtExt = cube(2,2,2) + 0.5*dot(grad, extUpdate);

    % generate keypoint if valid:
    if abs(fnValAtExt)*nIntervals > contrastThreshold
        xyHess = hess(1:2,1:2);
        xyHessTrace = trace(xyHess);
        xyHessDet = det(xyHess);
        % check that point is not too elongate (edge avoidance)
        if xyHessDet > 0 && r*(xyHessTrace^2) < ((r+1)^2)*xyHessDet
            keyPt.pt = [(i + extUpdate(1))*(2^octIdx), (j + extUpdate(2))*(2^octIdx)]; % position
            % note we use sigmaIdx-1 to adjust for index starting at 1
            keyPt.octave = octIdx + (sigmaIdx - 1)*2^8 + round((extUpdate(3) + 0.5)*255)*2^16;
            keyPt.size = sigma*(2^(((sigmaIdx - 1) + extUpdate(3))/nIntervals))*2^(octIdx + 1); % size, oct +1 due to double at start
            keyPt.response = abs(fnValAtExt);
        end
    end
    keyPt = NaN;
    sigmaIdx = NaN;

end