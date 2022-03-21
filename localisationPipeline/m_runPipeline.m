clear;
clc;
close all;

dset = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';


imageSet = imageDatastore(dset,'LabelSource','foldernames','IncludeSubfolders',true);
imageSet = subset(imageSet,1:40:1200);

% Total number of images in the data set
numel(imageSet.Files)

% Display a one of the images
figure
I = imread(imageSet.Files{1});
imshow(I);

%Pick a random subset of the flower images.
trainingSet = splitEachLabel(imageSet, 0.6, 'randomized');

% Specify the number of levels and branching factor of the vocabulary
% tree used within bagOfFeatures. Empirical analysis is required to
% choose optimal values.
numLevels = 1;
numBranches = 5000;

% Create a custom bag of features using the 'CustomExtractor' option.
colorBag = bagOfFeatures(trainingSet, ...
    'CustomExtractor', @siftFeatureExtractor, ...
    'TreeProperties', [numLevels numBranches]);



% Create a search index.
ImageIndex = indexImages(imageSet,colorBag,'SaveFeatureLocations',false);


% Define a query image
queryImage = readimage(imageSet,21);

figure
imshow(queryImage)

% Search for the top 5 images with similar color content
[imageIDs, scores] = retrieveImages(queryImage, ImageIndex,'NumResults',5);

% Display results using montage. 
figure
montage(imageSet.Files(imageIDs),'ThumbnailSize',[200 200])