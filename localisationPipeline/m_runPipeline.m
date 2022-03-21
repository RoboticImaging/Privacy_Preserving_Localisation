clear;
clc;
close all;

dset = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';


imageSet = imageDatastore(dset,'LabelSource','foldernames','IncludeSubfolders',true);
imageSubSet = subset(imageSet,1:40:1200);

I = readimage(imageSubSet,1);

%Pick a random subset of the flower images.
trainingSet = splitEachLabel(imageSubSet, 1, 'randomized');

% Specify the number of levels and branching factor of the vocabulary
% tree used within bagOfFeatures. Empirical analysis is required to
% choose optimal values.
numLevels = 1;
numBranches = 5000;

% Create a custom bag of features using the 'CustomExtractor' option.
colorBag = bagOfFeatures(trainingSet, ...
    'CustomExtractor', @orbBriefExtractor, ...
    'TreeProperties', [numLevels numBranches]);


% Create a search index.
ImageIndex = indexImages(imageSubSet,colorBag,'SaveFeatureLocations',false);


% Define a query image
queryImage = readimage(imageSet,150);

figure
imshow(queryImage)

% Search for the top 5 images with similar color content
[imageIDs, scores] = retrieveImages(queryImage, ImageIndex,'NumResults',5);

% Display results using montage. 
figure
montage(imageSubSet.Files(imageIDs),'ThumbnailSize',[200 200])