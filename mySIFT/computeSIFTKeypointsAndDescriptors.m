function [keypoints,descriptors] = computeSIFTKeypointsAndDescriptors(img, sigma, nIntervals, assumedBlur, imgBorderWidth)
    % Find SIFT features [Lowe 2004]
    % following pySIFT implementation as base version
    % https://github.com/rmislam/PythonSIFT/blob/master/pysift.py
    assert(min(img,[],'all') >= 0 && max(img,[],'all') <= 1)

    %%%%%% Part 1: Generate DoG %%%%%%
    % generate the very base image by resizing to double the size
    baseImg = generateBaseImg(img, sigma, assumedBlur);
    % calculate the number of octaves
    nOct = computeNumberOfOctaves(size(img));
    % generate the sigma differences for the filters that are successively
    % applied
    gSigmas = generateGaussianSigmas(sigma, nIntervals);
    % generate stack of gaussian images
    gImgs = generateGaussianImages(img, nOct, gSigmas);
    % compute difference of gaussian in each stack
    DoGstack = generateDoG(gImgs);

    %%%%%% Part 2: find keypoints %%%%%%
    contrastThreshold = 0.04;
    keypoints = findScaleSpaceExtrema(gImgs, DoGstack, nIntervals, sigma, imgBorderWidth, contrastThreshold);




    descriptors = 0;

end

