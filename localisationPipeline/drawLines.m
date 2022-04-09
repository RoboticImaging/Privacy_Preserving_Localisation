function drawLines(linesStruct)
    
    for lineIdx = 1:length(linesStruct)
        tVals = linesStruct(lineIdx).tBound;
        hold on
        for tIdx = 1:length(tVals)
            coord(tIdx,:) = linesStruct(lineIdx).point + tVals(tIdx)*linesStruct(lineIdx).dir;
        end
        plot(coord(:,1), coord(:,2),'r')
    end

end