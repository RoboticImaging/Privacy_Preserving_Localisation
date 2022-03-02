function keypts = findScaleSpaceExtrema(gImgs, DoGimgs, nIntervals, sigma, imgBorderWidth, contrastThreshold)

    r = 10; % eigenvalue ratio to determine a max
    nAttemptsConverge = 5;

    % loop over octaves:
    for octIdx = 1:length(DoGimgs)
        DoGimgsInOct = DoGimgs{octIdx};
        
        % TODO: also restrict to not be on edges of img
        % compute minima, maxima and apply contrast thresholding
        thresholdVals = abs(DoGimgsInOct) > contrastThreshold);
        DoGmax = or(and(imregionalmax( DoGimgsInOct, 26), thresholdVals),...
                               and(imregionalmax(-DoGimgsInOct, 26), thresholdVals));


        % loop over all true values
        for sigmaIdx = 1:size(DoGmax,3)
            for i = 1:size(DoGmax,1)
                for j = 1:size(DoGmax,2)
                    % check value is true
                    if DoGmax(i, j, sigmaIdx)
                        % 
                        localizationRes = localizeExtremumViaQuadraticFit(i, j, sigmaIdx, octIdx, nIntervals, DoGimgInOct, ...
                                                                                                    sigma, contrastThreshold, imgBorderWidth, ...
                                                                                                    r, nAttemptsConverge);
                    end
                end
            end
        end

    end
    keypts = 0;
end