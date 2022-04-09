clear;
clc;
close all;

rng(1);


dset = getDset('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb');


% BoF params:
numLevels = 1;
numBranches = 5000;

visualiseImagesIndexes = [];


% skipVals = [5,10];
% eTors = {@simpleGlobalFeatExtractor,@siftFeatureExtractor,@orbBriefExtractor};
nLines = round(logspace(1,3.7,10));
nIter = 10;

figure
acc = zeros(nIter,length(nLines));
for nIdx = 1:length(nLines)
    for i = 1:nIter
        sampleDensity = max(dset.imsize);
        lines = generateRandomLines(dset.imsize, 100);
        [xToSample, yToSample] = lines2SamplePoints(lines, 200); % I am speed
        extractor = @(img) maxMinFeaturesAlongLines(img, xToSample,yToSample);

        acc(i,nIdx) = testExtractor(dset, 10, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
end
errorbar(nLines, mean(acc), std(acc)/sqrt(nIter));
xlabel('Number of lines')
ylabel('Accuracy')


ylim([0,1])


