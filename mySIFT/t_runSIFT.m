clear;
clc;
close all;

img = imread('cameraman.tif');
img = im2double(img);

sigma = 1.6;
nIntervals = 3;
assumedBlur = 0.5;
imgBorderWidth = 5;


[key,disc] = computeSIFTKeypointsAndDescriptors(img, sigma, nIntervals, assumedBlur, imgBorderWidth);

figure
colormap(gray)
imagesc(img)
hold on
plot(key.selectStrongest(10))
axis image