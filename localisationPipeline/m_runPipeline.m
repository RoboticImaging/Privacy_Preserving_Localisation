clear;
clc;
close all;

dsetName = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';
% dsetName = '../data/dum_cloudy1/png';

dset = getDset(dsetName);


trainingSubsetSkip = 30;

% BoF params:5
numLevels = 1;
numBranches = 5000;

visualiseImagesIndexes = [201, 462,701];

% extractor = @simpleGlobalFeatExtractor;
% extractor = @siftFeatureExtractor;
% extractor = @orbBriefExtractor;

% if using random lines:
nLines = 5000;
sampleDensity = max(dset.imsize);
lines = generateRandomLines(dset.imsize, 100);
[xToSample, yToSample] = lines2SamplePoints(lines, 200); % I am speed
extractor = @(img) maxMinFeaturesAlongLines(img, xToSample,yToSample);

testExtractor(dset, trainingSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor)


