clear;
clc;
close all;


img = imread('cameraman.tif');
img = img(:,1:round(end/2));
img=double(img);

colormap gray
imagesc(img)
axis image

% lines = struct('point',{},'dir',{});
% x.point = [50,30];
% x.dir = [1,0];
% lines(1) = x;

rng(3)
lines = generateRandomLines(size(img), 2);

drawLines(lines)

figure
drawTrace(img, lines(1))
hold on

drawTrace(img, lines(2))
xlabel('position along line')
ylabel('interp intensity')
