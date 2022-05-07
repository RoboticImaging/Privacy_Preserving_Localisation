clear;
clc;
close all;


img = imread('cameraman.tif');
img = img(:,1:round(end));
img=double(img);
img = img/256;

colormap gray
imagesc(img)
axis image

% lines = struct('point',{},'dir',{});
% x.point = [50,30];
% x.dir = [1,0];
% lines(1) = x;

rng(3)
lines = generateRandomLines(size(img), 4);

drawLines(lines)
axis off 

figure
for i = 1:length(lines)
    hold on
    [ta,ya] = drawTrace(img, lines(i));
    t(i,:) = ta;
    y(i,:) = ya;
end

for i = 1:length(lines)
    hold on 
    [minV,minPos] = min(y(i,:));
    ATplot(t(i,minPos), minV,'ro');
    [minV,minPos] = max(y(i,:));
    ATplot(t(i,minPos), minV,'ro');
end

param = getATfontParams();
xlabel('Position along line',param{:})
ylabel('Interpolated intensity', param{:})
box on
ATprettify();
