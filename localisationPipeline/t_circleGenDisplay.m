clear
clc
close all

img = imread('cameraman.tif');
img = img(:,1:round(end));
img=double(img);

colormap gray
imagesc(img)
axis image


rng(1)
[xToSample, yToSample] = generateCircleSamplesPts(size(img), 4, [10,50], 100);

hold on 
tmp = axis;
for row = 1:size(xToSample,1)
    ATplot(xToSample(row,:),yToSample(row,:))
end
axis(tmp)
axis off

% test feat extraction
% [features, metrics] = maxMinFeaturesAlongCurves(img, xToSample,yToSample);
interpVals = interp2(img,xToSample,yToSample);
figure
ATplot(interpVals')
hold on
[a,b] = max(interpVals,[],2);
ATplot(b,a,'ro');
[a,b] = min(interpVals,[],2);
ATplot(b,a,'ro');

fp = getATfontParams();
xlabel('Sample index',fp{:});
ylabel('Interpolated intensity',fp{:});
ATprettify();


