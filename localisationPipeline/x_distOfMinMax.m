clear;
clc;
close all;

dset = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';

trainingSubsetSkip = 40;

imageSet = imageDatastore(dset,'LabelSource','foldernames','IncludeSubfolders',true);
imageSubSet = subset(imageSet,1:trainingSubsetSkip:numel(imageSet.Files));



img = readimage(imageSubSet, 1);

[feat,metric] = simpleGlobalFeatExtractor(img);

plot(feat(:,1), feat(:,2),'r.')
xlim([0,255])
ylim([0,255])

figure
imshow(img)



