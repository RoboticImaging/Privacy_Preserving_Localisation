function [features, metrics] = orbBriefExtractor(img)
    % orbBriefExtractor 
    p = detectORBFeatures(img);
    if length(p)==0
        figure
        imshow(img)
    end

    [f,validPts] = extractFeatures(img,p);
    features = double(f.Features);
    metrics = validPts.Metric;

end

