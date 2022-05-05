function ax = displayFingerprint(imgs, extractors)
    arguments
        imgs (1,:) cell 
        extractors (1,:) cell {}
    end
    
    nRows = length(extractors) + 1;
    nCols = length(imgs);

    [x1,x2] = meshgrid(0:255, 0:255);
    x1 = x1(:);
    x2 = x2(:);
    xi = [x1 x2];

    imgCell = imgs;
    for row = 2:(nRows)
        rowCell = {};
        for col = 1:nCols
            [features, ~] = extractors{row-1}(imgs{col});
            [f,xi] = ksdensity(features,xi);
            rowCell{col} = reshape(f,[256,256]);
%             [f,xi] = ksdensity(features);
%             rowCell{col} = reshape(f,30,[]);
        end
        imgCell = vertcat(imgCell, rowCell);
    end

    cmap = ["gray"; repmat("default",nRows-1,1)];
    yDirs = ["reverse"; repmat("normal",nRows-1,1)];
    ax = ATimgrid(imgCell, [nRows, nCols], 'colormaps',cmap,'yDirs',yDirs);

end