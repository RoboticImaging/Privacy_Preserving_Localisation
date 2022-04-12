function [features, metrics] = maxMinFeaturesAlongUniqueRandLines(img, nLines, nSample)
    lines = generateRandomLines(size(img), nLines);

    img = double(img);

    [xToSample, yToSample] = lines2SamplePoints(lines, nSample); 
    interpVals = interp2(img,xToSample,yToSample);

    features = [max(interpVals,[],2), min(interpVals,[],2)];
    metrics = [max(interpVals,[],2) - min(interpVals,[],2)];

    if sum(isnan(features),"all") ~= 0
        figure 
        imshow(img);
    end
    
end