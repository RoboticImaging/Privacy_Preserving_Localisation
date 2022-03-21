clear;
clc;
close all;

dset = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';

trainingSubsetSkip = 40;

% BoF params:5
numLevels = 1;
numBranches = 5000;

testImagesIndexes = [201, 462,701];

extractor = @simpleGlobalFeatExtractor;

testExtractor(dset, trainingSubsetSkip, numLevels, numBranches, testImagesIndexes, extractor)