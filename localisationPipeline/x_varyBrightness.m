clear;
clc;
close all;


rng(1);

% dset = getDset('../data/MyDsets/PNRtopWalkthrough1/imgs');
dset = getDset('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb');


% BoF params:
numLevels = 1;
numBranches = 5000;


visualiseImagesIndexes = [];

nLines = 2e3;
trainSubsetSkip = 20;

nIter = 2;

brightnessFactors = linspace(0.7,1.3,5);
% brightnessFactors = 1;

sampleDensity = max(dset.imsize);
extractors = {@(img) maxMinFeaturesAlongUniqueRandCirc(img, nLines, [15,50], sampleDensity, false),...
                     @(img) maxMinFeaturesAlongUniqueRandCirc(img, nLines, [15,50], sampleDensity, true)};% one for normalise

for etorIdx = 1:length(extractors)
    extractor = extractors{etorIdx};
    acc = zeros(nIter,length(brightnessFactors));
    for nIdx = 1:length(brightnessFactors)
        for i = 1:nIter
            dstore = ATimds(dset.path, brightnessFactors(nIdx));

    
            acc(i,nIdx) = testExtractorDstore(dstore, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
        end
    end
    ATerrorbar(brightnessFactors, mean(acc), std(acc)/sqrt(nIter));
end
ATprettify();

