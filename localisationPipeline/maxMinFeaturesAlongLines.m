function [features, metrics] = maxMinFeaturesAlongLines(img, xToSample,yToSample)
    % find max and min along an arbitrary line through the image

    img = double(img);


    interpVals = interp2(img,xToSample,yToSample);

    features = [max(interpVals,[],2), min(interpVals,[],2)];
    metrics = [max(interpVals,[],2) - min(interpVals,[],2)];


end