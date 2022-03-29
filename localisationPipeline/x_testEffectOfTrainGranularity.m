clear;
clc;
close all;

dset = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';


% BoF params:
numLevels = 1;
numBranches = 5000;

visualiseImagesIndexes = [];

skipVals = [15,30,50,70,100];

% skipVals = [5,10];
eTors = {@simpleGlobalFeatExtractor,@siftFeatureExtractor,@orbBriefExtractor};

figure
for eTorIdx = 1:length(eTors)
    acc = zeros(1,length(skipVals));
    for skipIdx = 1:length(skipVals)
        extractor = eTors{eTorIdx}; 


        trainingSubsetSkip = skipVals(skipIdx);

        acc(skipIdx) = testExtractor(dset, trainingSubsetSkip, numLevels, numBranches, ...
                                                     visualiseImagesIndexes, extractor, false);
    end
    hold on 
    plot(skipVals,acc)
end
xlabel('Training Stride')
ylabel('Accuracy')
legend('global', 'SIFT', 'ORB')

ylim([0,1])
saveas(gcf,'granularityEffect.fig')

