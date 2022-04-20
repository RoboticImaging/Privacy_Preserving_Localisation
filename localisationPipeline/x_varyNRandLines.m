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
nLines = round(logspace(1,3.2,7));
% nLines = round(logspace(1,2,2));
nIter = 4;
% nIter = 2;

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


% now repeat for unique rand Circ
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


nCircles= nLines;

radii = [15,50];

acc = zeros(nIter,length(nCircles));
% test for random lines randomly
for nIdx = 1:length(nCircles)
    for i = 1:nIter
        sampleDensity = max(dset.imsize);
        [xToSample, yToSample] = generateCircleSamplesPts(dset.imsize, nCircles(nIdx), radii, sampleDensity);
        extractor = @(img) maxMinFeaturesAlongCurves(img, xToSample,yToSample);

        acc(i,nIdx) = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
end
hold on
errorbar(nCircles, mean(acc), std(acc)/sqrt(nIter));



% now repeat for unique rand Circ
acc = zeros(nIter,length(nLines));
for nIdx = 1:length(nLines)
    for i = 1:nIter
        sampleDensity = max(dset.imsize);
        extractor = @(img) maxMinFeaturesAlongUniqueRandCirc(img,  nCircles(nIdx), radii, sampleDensity);

        acc(i,nIdx) = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
end
hold on
errorbar(nLines, mean(acc), std(acc)/sqrt(nIter));

xlabel('Number of lines')
ylabel('Accuracy')
legend('Same Lines','Random Lines','Same Circles','Random Circles')


ylim([0,1])
set(gca,'XScale','log')

% saveas(gcf,'compareRandLines.fig')

%% compare with sift baseline
extractor = @siftFeatureExtractor;
numBranches = 5000;
accSift = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);

hold on
plot(xlim,[accSift,accSift],'k--')



numBranches = 25000;

accSift(2) = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);

hold on
plot(xlim,[accSift(2),accSift(2)],'m--')
legend('Same Lines','Random Lines','Same Circles','Random Circles', 'SIFT','SIFT(5xbranches)')
saveas(gcf,'compareRandLinesAndCirc.fig')
