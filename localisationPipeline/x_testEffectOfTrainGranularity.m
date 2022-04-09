clear;
clc;
close all;

dsetName = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';
% dsetName = '../data/dum_cloudy1/png';

dset = getDset(dsetName);


% BoF params:
numLevels = 1;
numBranches = 5000;

visualiseImagesIndexes = [];
% 
skipVals = [7,15,30,50,70,100];

% skipVals = [100,101];
% eTors = {@simpleGlobalFeatExtractor,@siftFeatureExtractor,@orbBriefExtractor};
eTors = {@(img) colFeaturesMinMax(img,false,false),
              @(img) colFeaturesMinMax(img,false,true),
              @(img) colFeaturesMinMax(img,true,false),
              @(img) colFeaturesMinMax(img,true,true)};

legCell = {'No Metric',
                'No Metric, normalise to mean of whole img ',
                'contrast Metric',
                'contrast Metric, normalise to mean of whole img'};

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
% legend('global', 'SIFT', 'ORB')
legend(legCell)

ylim([0,1])
saveas(gcf,'granularityEffectForDifferentColumns.fig')

