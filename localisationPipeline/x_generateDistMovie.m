clear;
clc;
close all;
wbars = findall(0,'type','figure','tag','TMWWaitbar');
delete(wbars);

dset = getDset('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb');

imageSet = imageDatastore(dset.path,'LabelSource','foldernames','IncludeSubfolders',true);

skip  = 3;
nLines = 2e3;
nCircles = nLines;
radii = [15,50];

[x1,x2] = meshgrid(0:255, 0:255);
x1 = x1(:);
x2 = x2(:);
xi = [x1 x2];

imgIdxs = 1:skip:length(imageSet.Files);

cmap = ["gray"; "default"; "default"];
yDirs = ["reverse"; "normal"; "normal"];
xlabel = "max";
ylabel = "min";
showAxes = [0;1;1];

figure(1)
set(gcf,'Position',[488.0000   63.4000  418.6000  698.6000]);
axisParams = {'FontSize',8};


imgStack = zeros(dset.imsize(1), dset.imsize(2), length(imgIdxs));
lineFeatureStack = zeros(256, 256, length(imgIdxs));
circFeatureStack = zeros(256, 256, length(imgIdxs));

wbar = waitbar(0,'Loading...');

% data extraction loop:
for i = 1:length(imgIdxs)
    waitbar(i/length(imgIdxs), wbar, sprintf("%.2f%% done",100*i/length(imgIdxs)));
    imgStack(:,:,i) = readimage(imageSet, imgIdxs(i));

    [features, ~] = maxMinFeaturesAlongUniqueRandLines(imgStack(:,:,i), nLines, 100);
    [f,xi] = ksdensity(features,xi);
    lineFeatureStack(:,:,i) = reshape(f,[256,256]);

    [xToSample, yToSample] = generateCircleSamplesPts(dset.imsize, nCircles, radii, 200);
    [features, ~] = maxMinFeaturesAlongCurves(imgStack(:,:,i), xToSample,yToSample);
    [f,xi] = ksdensity(features,xi);
    circFeatureStack(:,:,i) = reshape(f,[256,256]);
end

save('fingerprintsInDset.mat', 'imgStack','lineFeatureStack','circFeatureStack','imgIdxs')

%% generate vid
% plotting loop:
lineMax = max(lineFeatureStack,[],'all');
circMax = max(circFeatureStack,[],'all');

fparam = getATfontParams();


for i = 1:length(imgIdxs)
    figure(1)  

    imPltStack{1} = imgStack(:,:,i);
    imPltStack{2} = lineFeatureStack(:,:,i)/lineMax;
    imPltStack{3} = circFeatureStack(:,:,i)/circMax;
    clf
    ATimgrid(imPltStack, [3,1],'showAxes',showAxes,'colormaps',cmap,...
                   'xlabels',xlabel,'ylabels',ylabel,'yDirs',yDirs,'axisParams',axisParams);
    annotation('textbox', [0.10, 0.95, 0, 0], 'string', sprintf("%d/%d", imgIdxs(i), length(imageSet.Files)), 'HorizontalAlignment','center',...
                      'VerticalAlignment','middle', fparam{:})
    F(i) = getframe(gcf);
    drawnow
end


% create the video writer with 10 fps
writerObj = VideoWriter('test.mp4','MPEG-4');
writerObj.FrameRate = 3;
% set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i);    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);