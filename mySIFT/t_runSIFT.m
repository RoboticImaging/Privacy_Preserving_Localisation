clear;
clc;
close all;

img = imread('cameraman.tif');
% img = img(1:end/2,:);
img = im2double(img)*255;

sigma = 1.6;
nIntervals = 3;
assumedBlur = 0.5;
imgBorderWidth = 5;



%TODO: double check all sigmaIndex-ing and make sure you haven't mixed up python and maltab
[key,disc] = computeSIFTKeypointsAndDescriptors(img, sigma, nIntervals, assumedBlur, imgBorderWidth);

figure
colormap(gray)
imagesc(img)
hold on
plot(key.selectStrongest(20))
axis image