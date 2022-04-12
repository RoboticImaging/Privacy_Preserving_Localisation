clear
clc
close all

img = imread('cameraman.tif');
img = img(:,1:round(end/2));
img=double(img);

colormap gray
imagesc(img)
axis image


rng(3)
[xToSample, yToSample] = generateCircleSamplesPts(size(img), 20, [3,25], 100);

hold on 
for row = 1:size(xToSample,1)
    plot(xToSample(row,:),yToSample(row,:),'r')
end

% test feat extraction
[features, metrics] = maxMinFeaturesAlongCurves(img, xToSample,yToSample)
