clear;
clc;
close all;

dsetFnames = {["../data/MyDsets/PNRroomSimpsonsRotated/imgs"]};
% dsetFnames = {["../data/dum_cloudy1/png"],
%               ["../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb"],
%               ["../data/MyDsets/PNRroomSimpsons/imgs"],
%               ["../data/MyDsets/PNRroomSimpsons/imgs", "../data/MyDsets/PNRroomSimpsonsRotated/imgs"]};


dsetNames = {["PNRroomRotated"]};
% dsetNames = {["dum_cloudy1"],
%                         ["Digiteo_seq_2"],
%                         ["PNRroom"],
%                         ["PNRroom", "PNRroomRotated"]};

for tabRow = 1:length(dsetFnames)
    trainDset = getDset(dsetFnames{tabRow}(1));
    trainDset.stride = 20;

    if length(dsetFnames{tabRow}) == 1
        % there is only a train dset
        testDset = trainDset;
        accuracyWidth = 1.5;
    else
        testDset = getDset(dsetFnames{tabRow}(2));
        accuracyWidth = 4.5;
    end
    testDset.stride = 3;

    curveFraction = 400; % number of curves as a fraction of the number of pixels

    minRadiiFrac = 21;
    maxRadiiFrac = 72;

    radii = min(trainDset.imsize)./[minRadiiFrac,maxRadiiFrac];

    nCurves = round(prod(trainDset.imsize)/curveFraction);
    nSamples = max(trainDset.imsize);

    etors = {@siftFeatureExtractor, 
                  @orbBriefExtractor,
                  @(img) maxMinFeaturesAlongUniqueRandCirc(img, nCurves, radii, nSamples),
                  @(img) maxMinFeaturesAlongUniqueRandLines(img, nCurves, nSamples)};
    etorNames = ["SIFT", "ORB", "Rand Circ", "Rand Lines"];


    for etorIdx = 1:length(etors)
        acc(tabRow, etorIdx) = evalExtractor(etors{etorIdx}, trainDset, testDset, accuracyWidth=accuracyWidth);
    end
end

target = fopen('evalOverDifferentDatasets.txt','a+');
fprintf(target, '----------- new exp ----------\n');
fprintf(target,'%s & ',etorNames);
fprintf(target,'\b\b\n');
% target = 1;

for tabRow = 1:length(dsetFnames)
    if length(dsetNames{tabRow}) == 1
        dsetNames{tabRow}(2) = dsetNames{tabRow}(1);
    end
    fprintf(target, '%s & %s & ', dsetNames{tabRow}(1), dsetNames{tabRow}(2));
    for etorIdx = 1:length(etors)
        [~,i] = max(acc(tabRow, etorIdx));
        if etorIdx == i
            fprintf(target, '\\textbf{%.2f}', acc(tabRow, etorIdx)*100);
        else
            fprintf(target, '%.2f', acc(tabRow, etorIdx)*100);
        end
        if etorIdx ~= length(etors)
            fprintf(target, ' & ');
        end
    end
    fprintf(target, '\\\\ \n');
end
fclose(target);