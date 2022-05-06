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

brightnessFactors = linspace(0.7,1.3,8);


acc = zeros(nIter,length(brightnessFactors));
for nIdx = 1:length(brightnessFactors)
    for i = 1:nIter
        dstore = ATimds(dset.path, brightnessFactors(nIdx));
        sampleDensity = max(dset.imsize);

        extractor = @(img) maxMinFeaturesAlongUniqueRandLines(img, nLines,sampleDensity);

        acc(i,nIdx) = testExtractorDstore(dstore, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
end
ATerrorbar(brightnessFactors, mean(acc), std(acc)/sqrt(nIter));
ATprettify();

