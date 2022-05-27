clear;
clc;
close all;

dsetFnames = {["../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb"],
              ["../data/dum_cloudy1/png"],
              ["../data/MyDsets/PNRroomSimpsons/imgs"],
              ["../data/MyDsets/PNRroomSimpsons/imgs", "../data/MyDsets/PNRroomSimpsonsRotated/imgs"]};

dsetNames = {["Digiteo_seq_2"],
                        ["dum_cloudy1"],
                        ["PNRroomSimpsons"],
                        ["PNRroomSimpsons", "PNRroomSimpsonsRotated"]};

for tabRow = 1:length(dsetFnames)
    trainDset = getDset(dsetFnames{tabRow}(1));
    trainDset.stride = 20;

    if length(dsetFnames{tabRow}) == 1
        % there is only a train dset
        testDset = trainDset;
    else
        testDset = getDset(dsetFnames{tabRow}(2));
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

    for etorIdx = 1:length(etors)
        acc(tabRow, etorIdx) = evalExtractor(etors{etorIdx}, trainDset, testDset);
    end
end



