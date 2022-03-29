function testExtractor(dset, trainingSubsetSkip, numLevels, numBranches, visualiseImageIdxs, extractor)
    imageSet = imageDatastore(dset,'LabelSource','foldernames','IncludeSubfolders',true);

    trainIdx = 1:trainingSubsetSkip:numel(imageSet.Files);
    imageSubSet = subset(imageSet,trainIdx);
    
    I = readimage(imageSubSet,1);
    
    %Pick a random subset of the flower images.
    trainingSet = splitEachLabel(imageSubSet, 1, 'randomized');
    
    % Create a custom bag of features using the 'CustomExtractor' option.
    bag = bagOfFeatures(trainingSet, ...
        'CustomExtractor', extractor, ...
        'TreeProperties', [numLevels numBranches]);
    
    
    % Create a search index.
    ImageIndex = indexImages(imageSubSet,bag,'SaveFeatureLocations',false);
    

    for imgIdx = visualiseImageIdxs
        % Define a query image
        queryImage = readimage(imageSet,imgIdx);
        
        figure
        imshow(queryImage)
        
        % Search for the top 5 images with similar color content
        [imageIDs, ~] = retrieveImages(queryImage, ImageIndex,'NumResults',5);
        
        % Display results using montage. 
        figure
        montage(imageSubSet.Files(imageIDs),'ThumbnailSize',[200 200])
    end

    % seq slam like plots for guessed positon
    testImageIdxes = 1:3:numel(imageSet.Files);
    estimatedIdx = zeros(size(testImageIdxes));

    for i = 1:length(testImageIdxes)
        testImage = readimage(imageSet,testImageIdxes(i));
        [imageIDs, ~] = retrieveImages(testImage, ImageIndex,'NumResults',1);
        estimatedIdx(i)  = trainIdx(imageIDs);
    end

    figure
    plot(testImageIdxes, estimatedIdx,'x')
    hold on

    plot(testImageIdxes, testImageIdxes,'r')
    xlabel('Test image index')
    ylabel('Estimated image index')

    fprintf('Accuracy of extractor: %.3f\n', 100*computeAccuracyOverTest(testImageIdxes, estimatedIdx, ...
                                                                                                            2*trainingSubsetSkip))

    figure
    histogram(testImageIdxes- estimatedIdx);
end