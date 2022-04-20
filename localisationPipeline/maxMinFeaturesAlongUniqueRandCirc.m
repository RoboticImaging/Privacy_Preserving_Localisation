function [features, metrics] = maxMinFeaturesAlongUniqueRandCirc(img, nCircles, radii, nSample)
    [xToSample, yToSample] = generateCircleSamplesPts(size(img), nCircles, radii, nSample);
    [features, metrics] = maxMinFeaturesAlongCurves(img, xToSample,yToSample);
end
