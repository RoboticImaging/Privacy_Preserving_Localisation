function [keyPts] = computeKeypointsWithOrientations(keypoint, octIdx, gImg, radiusFact, nBins, peakRatio, windowScaleFactor)
    % reutrn a struct array of keypoints
    
    % default vals
    if nargin == 3
        radiusFact = 3;
        nBins = 36;
        peakRatio = 0.8;
        windowScaleFactor = 1.5;
    end

    imgSize = size(gImg);

    % calculate window to look at
    scale = windowScaleFactor*keypoint.size/(2^(octIdx));
    radius = round(radiusFact*scale);
    weightFact = -0.5/scale^2;
    rawHist = zeros(1,nBins);
    smoothedHist = zeros(1,nBins);

    for i = -radius:radius
        regionY = round(keypoint.pt(1)/(2^(octIdx-1))) + i;
        if regionY > 0 && regionY < imgSize(1)
            for j = -radius:radius
                regionX = round(keypoint.pt(2)/(2^(octIdx-1))) + j;
                if regionX > 1 && regionX < imgSize(2)-1
                    dx = gImg(regionY, regionX+1) - gImg(regionY, regionX-1);
                    dy = gImg(regionY+1, regionX) - gImg(regionY-1, regionX);
                    gradMag = sqrt(dx^2 + dy^2);
                    gradOrient = atan2d(dy,dx);
                    weight = exp(weightFact*(i^2 + j^2));
                    histIdx = round(gradOrient*nBins/360);
                    histIdx = mod(histIdx,nBins) + 1;
                    rawHist(histIdx) = rawHist(histIdx) + weight*gradMag;
                end
            end
        end
    end


    for binIdx = 1:nBins
        idxPlusOne = mod(binIdx,nBins) + 1;
        idxMinusOne = mod(binIdx-2,nBins) + 1;
        idxPlusTwo = mod(binIdx+1,nBins) + 1;
        idxMinusTwo = mod(binIdx-3,nBins) + 1;
        smoothedHist(binIdx) = (6*rawHist(binIdx) + ...
                                               4*(rawHist(idxPlusOne) + rawHist(idxMinusOne)) + ...
                                               1/16*(rawHist(idxPlusTwo) + rawHist(idxMinusTwo)));
    end

    % find all the peaks
    orientationMax = max(smoothedHist);
    orientationPeaks = and(smoothedHist > circshift(smoothedHist,1),...
                                            smoothedHist > circshift(smoothedHist,-1));


    keyPts = struct('pt', {}, 'size', {},'response', {}, 'octave', {}, 'orientation', {});
    
    for binIdx = 1:nBins
        % check if peak
        if orientationPeaks(binIdx)
            peakVal = smoothedHist(binIdx);
            if peakVal > peakRatio*orientationMax
                % peak interp
                idxPlusOne = mod(binIdx,nBins) + 1;
                idxMinusOne = mod(binIdx-2,nBins) + 1;
                left = smoothedHist(idxMinusOne);
                right = smoothedHist(idxPlusOne);
                interpPeakIdx = (binIdx + 0.5*(left-right)/(left-2*peakVal+right));
                orientation = 360 - interpPeakIdx*360/nBins;
                newKeypt.pt = keypoint.pt;
                newKeypt.size = keypoint.size;
                newKeypt.response = keypoint.response;
                newKeypt.octave = keypoint.octave;
                newKeypt.orientation = orientation;

                keyPts = [keyPts, newKeypt];
            end
        end
    end
end