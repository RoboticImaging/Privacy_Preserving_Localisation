function keypts = findScaleSpaceExtrema(gImgs, DoGimgs, nIntervals, sigma, imgBorderWidth, contrastThreshold)

    r = 10; % eigenvalue ratio to determine a max
    nAttemptsConverge = 5;

    % loop over octaves:
    for octIdx = 1:length(DoGimgs)
        DoGimgsInOct = DoGimgs{octIdx};
        
        % TODO: also restrict to not be on edges of img
        % compute minima, maxima and apply contrast thresholding
        thresholdVals = abs(DoGimgsInOct) > contrastThreshold;

        connectedness = 26;
        DoGmax = or(and(imregionalmax( DoGimgsInOct, connectedness), thresholdVals),...
                               and(imregionalmax(-DoGimgsInOct, connectedness), thresholdVals));


        % loop over all true values
        for sigmaIdx = 1:(size(DoGmax,3)-2)
            for i = imgBorderWidth:(size(DoGmax,1)-imgBorderWidth)
                for j = imgBorderWidth:(size(DoGmax,2)-imgBorderWidth)
                    % check value is true
                    if DoGmax(i, j, sigmaIdx)
                        % 
                        localizationRes = localizeExtremumViaQuadraticFit(i, j, sigmaIdx, octIdx, nIntervals, DoGimgsInOct, ...
                                                                                                    sigma, contrastThreshold, imgBorderWidth, ...
                                                                                                    r, nAttemptsConverge);
                    end
                end
            end
        end

    end
    keypts = 0;
end