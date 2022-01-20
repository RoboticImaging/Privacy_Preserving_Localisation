function convs = runDisks(img,diskRadii)
    convs = zeros(size(img,1),size(img,2),length(diskRadii));
    for i = 1:length(diskRadii)
        opt.radius = diskRadii(i);
        mask = getValidHardwareMask("disk",opt);
        convs(:,:,i) = conv2(img,mask,'same');
    end
end