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
% nLines = round(logspace(1,3.7,2));
nIter = 5;
% nIter = 1;

trainSubsetSkip = 10;

figure
acc = zeros(nIter,length(nLines));
% test for random lines randomly
for nIdx = 1:length(nLines)
    for i = 1:nIter
        sampleDensity = max(dset.imsize);
        lines = generateRandomLines(dset.imsize, nLines(nIdx));
        [xToSample, yToSample] = lines2SamplePoints(lines, sampleDensity); % I am speed
        extractor = @(img) maxMinFeaturesAlongCurves(img, xToSample,yToSample);

        acc(i,nIdx) = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
end
hold on
errorbar(nLines, mean(acc), std(acc)/sqrt(nIter));


% now repeat for unique rand lines
acc = zeros(nIter,length(nLines));
for nIdx = 1:length(nLines)
    for i = 1:nIter
        sampleDensity = max(dset.imsize);
        extractor = @(img) maxMinFeaturesAlongUniqueRandLines(img, nLines(nIdx),sampleDensity);

        acc(i,nIdx) = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
end
hold on
errorbar(nLines, mean(acc), std(acc)/sqrt(nIter));



xlabel('Number of lines')
ylabel('Accuracy')
legend('Same','Random')


ylim([0,1])


saveas(gcf,'compareRandLines.fig')

