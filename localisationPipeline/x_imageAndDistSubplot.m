clear;
clc;
close all

dset = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';

imageSet = imageDatastore(dset,'LabelSource','foldernames','IncludeSubfolders',true);

img2Show = [1,200,500,700, 900];
nImgs = length(img2Show);


[x1,x2] = meshgrid(0:255, 0:255);
x1 = x1(:);
x2 = x2(:);
xi = [x1 x2];

figure 
for i = 1:nImgs
    img = readimage(imageSet, img2Show(i));

    % features to be used
    [features, metrics] = maxMinFeaturesAlongUniqueRandLines(img, 5e3, 100);
    
    ax(1) = subaxis(2, nImgs, i);
    imagesc(img)
    axis image
    axis off
    colormap(ax(1),'gray')

    ax(2) = subaxis(2, nImgs, i+nImgs);
    colormap(ax(2),'parula')
    [f,xi] = ksdensity(features,xi);
    imagesc(0:255,0:255,reshape(f,[256,256]))
    axis image
    set(gca,'YDir','normal')

end


