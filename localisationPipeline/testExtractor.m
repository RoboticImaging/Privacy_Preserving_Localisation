function testExtractor(dset, trainingSubsetSkip, numLevels, numBranches, testImagesIndexes, extractor)
    imageSet = imageDatastore(dset,'LabelSource','foldernames','IncludeSubfolders',true);
    imageSubSet = subset(imageSet,1:trainingSubsetSkip:numel(imageSet.Files));
    
    I = readimage(imageSubSet,1);
    
    %Pick a random subset of the flower images.
    trainingSet = splitEachLabel(imageSubSet, 1, 'randomized');
    
    % Create a custom bag of features using the 'CustomExtractor' option.
    bag = bagOfFeatures(trainingSet, ...
        'CustomExtractor', extractor, ...
        'TreeProperties', [numLevels numBranches]);
    
    
    % Create a search index.
    ImageIndex = indexImages(imageSubSet,bag,'SaveFeatureLocations',false);
    
    
    
    for imgIdx = testImagesIndexes
        % Define a query image
        queryImage = readimage(imageSet,imgIdx);
        
        figure
        imshow(queryImage)
        
        % Search for the top 5 images with similar color content
        [imageIDs, scores] = retrieveImages(queryImage, ImageIndex,'NumResults',5);
        
        % Display results using montage. 
        figure
        montage(imageSubSet.Files(imageIDs),'ThumbnailSize',[200 200])
    end
end