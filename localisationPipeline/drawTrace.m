function [tvals,interpVals] = drawTrace(img, line)

    [xToSample, yToSample, tvals] = lines2SamplePoints(line, 200);

    interpVals = interp2(img,xToSample,yToSample);
    ATplot(tvals,interpVals)
end