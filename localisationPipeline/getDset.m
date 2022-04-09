function dset = getDset(path)
    imageSet = imageDatastore(path,'LabelSource','foldernames','IncludeSubfolders',true);
    dset.path = path;

    img = readimage(imageSet,1);
    dset.imsize = size(img);
end