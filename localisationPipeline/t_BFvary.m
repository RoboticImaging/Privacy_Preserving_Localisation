% test script to check that brightness is actually varying
clear;
clc;
close all;


dset = getDset('../data/MyDsets/PNRtopWalkthrough1/imgs');


imgIdx = [1,2];


BFvals = linspace(0.7,1.3,3);


for row = 1:length(imgIdx)
    for col = 1:length(BFvals)
        imds = ATimds(dset.path, BFvals(col));
        imgStack{row,col} = readimage(imds, imgIdx(row));
    end
end

tmp = zeros(1,1,2);
tmp(1,1,2) = 1;

ATimgrid(imgStack, [length(imgIdx),length(BFvals)], 'imBounds', tmp, 'yDirs', "reverse")



