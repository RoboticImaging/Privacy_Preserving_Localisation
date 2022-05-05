clear;
clc;
close all;


rng(1);

dset = getDset('../data/MyDsets/PNRtopWalkthrough1/imgs');


% BoF params:
numLevels = 1;
numBranches = 5000;


visualiseImagesIndexes = [];

nLines = 2e3;
trainSubsetSkip = 20;

nIter = 2;

brightnessFactors = linspace(0.7,1.3,5);


acc = zeros(nIter,length(brightnessFactors));
for nIdx = 1:length(nLines)
    for i = 1:nIter
        sampleDensity = max(dset.imsize);
        extractor = @(img) maxMinFeaturesAlongUniqueRandLines(img, nLines(nIdx),sampleDensity);

        acc(i,nIdx) = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
end
ATerrorbar(nLines, mean(acc), std(acc)/sqrt(nIter));


