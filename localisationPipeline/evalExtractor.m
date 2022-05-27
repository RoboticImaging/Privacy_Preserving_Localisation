function [acc] = evalExtractor(extractor, trainDset, testDset, BoWparams, nvargs)
    % determine how good an extractor is by using a train and possibly a
    % test dataset
    arguments
        extractor % a function that takes in an image and returns a feature vector
        trainDset % struct that includes how many to skip when looking through the dataset
        testDset = []
        BoWparams = {'TreeProperties', [1 5000], 'Verbose', true} % a cell arr to setup the BoW
        nvargs.trainAccStride = 5
    end

    % if no test set given, evalue on the dataset itself
%     if isempty(testDset)
%         testDset = trainDset;
%         testDset.stride = 3;
%     end

    % training segment:
%     trainFull = trainDset.imds;

    trainIdx = 1:trainDset.stride:numel(trainDset.imageSet.Files);
    trainSet = subset(trainDset.imageSet,trainIdx);


    % Create a custom bag of features using the 'CustomExtractor' option.
    bag = bagOfFeatures(trainSet, ...
        'CustomExtractor', extractor, ...
        BoWparams{:});

    % Create a search index.
    imgIdx = indexImages(trainSet,bag,'SaveFeatureLocations',false);

    % compute training accuracy

    if isempty(testDset)
        setToComputePerf = trainDset;
    else
        setToComputePerf = testDset;
    end

    imgToCompute = 1:nvargs.trainAccStride:numel(setToComputePerf.imageSet.Files);
    trainEstimatedIdx = zeros(size(imgToCompute));

    for i = 1:length(imgToCompute)
        testImage = readimage(setToComputePerf.imageSet,imgToCompute(i));
        [imageIDs, ~] = retrieveImages(testImage, imgIdx,'NumResults',1);
        if ~isempty(imageIDs)
            trainEstimatedIdx(i)  = trainIdx(imageIDs);
        else 
            trainEstimatedIdx(i) = nan;
        end
    end


    acc = computeAccuracyOverTest(imgToCompute, trainEstimatedIdx,1.5*trainDset.stride);
    fprintf('Training accuracy of extractor: %.3f\n', 100*acc);
end

%     % testing on the other dataset now
%     imgToCompute = 1:testDset.stride:numel(testDset.Files);
%     testEstimatedIdx = zeros(size(imgToCompute));
% 
%     for i = 1:length(imgToCompute)
%         testImage = readimage(imageSet,imgToCompute(i));
%         [imageIDs, ~] = retrieveImages(testImage, ImageIndex,'NumResults',1);
%         if ~isempty(imageIDs)
%             testEstimatedIdx(i)  = trainIdx(imageIDs);
%         else 
%             testEstimatedIdx(i) = nan;
%         end
%     end
% 
%     testAcc = computeAccuracyOverTest(imgToCompute, testEstimatedIdx,1.5*trainDset.stride);
%     fprintf('Training accuracy of extractor: %.3f\n', 100*trainAcc);
