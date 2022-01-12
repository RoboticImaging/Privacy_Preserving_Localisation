clear;
clc;
close all;


mask = getMask(3);

mask.values = uint8([1 0 -1;
                                  2 0 -2;
                                  1 0 -1]);


dataset = 'Digiteo_seq_2';
fname = 'frame0.png';

img = imread(strcat('data/',dataset,'/Passive-Stereo/RGB-D/rgb/',fname));

imshow(img);

slideRow = true;
vec = slideMask1D(img,mask,slideRow);
figure
plot(vec);