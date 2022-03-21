function [features, metrics] = orbBriefExtractor(img)
    % orbBriefExtractor 
    p = detectORBFeatures(img);

    [f,validPts] = extractFeatures(img,p);
    features = double(f.Features);
    metrics = validPts.Metric;
end

