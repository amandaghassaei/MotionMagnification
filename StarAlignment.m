addpath('./data');
addpath('./matlabPyrTools');
addpath('./matlabPyrTools/MEX');
addpath('./FastPeakFind');
addpath('./sift');

dataDir = './data';
resultsDir = 'results';
mkdir(resultsDir);

verbose = false;% verbose logging

% all video files or directories of image sequences to process
% be sure to put a backslash in front of directory names for proper sorting
%sequences of astronomy images should be named with the convention:
%nameYYYYMMDD for this analysis
allFilesToProcess = cellstr(char('/orion'));

for i=1:size(allFilesToProcess, 1)
    
    filename = allFilesToProcess(i);
    filename = filename{1};% get string out
    
    [frames, frameRate] = loadImgs(dataDir, filename, verbose);
    framesGray = preProcessFrames(frames, filename, 'gray', verbose);
    starCenters = locateAllStarCenters(framesGray, true);
%     drawFramesWithStarMarkers(frames, starCenters, 500, true); 
    
    %register everything to frame 1
    frame1 = frames(:,:,:,1);
    frame1Gray = framesGray(:,:,1,1);

    for j=2:size(frames, 4)
        
        frame = frames(:,:,:,j);
        frameGray = framesGray(:,:,1,j);
        
         %first pass at registration - get kind of close in position and scale
        [transform, transformedFrame] = featureMatchByHand(frame1, frame);
%         [transform, transformedFrame] = matchWithSift(frame1, frame1Gray, frame, frameGray, verbose);
%         matchStarFeatures(frame1, frame, starCentersAndRadii);

        %second pass - align big stars well
        windowSize = size(frame, 2)/20;
        proximityMatchStars(false, frame1, frame, transformedFrame, starCenters(:,:,1), starCenters(:,:,j), transform, windowSize);
        
        %final pass - align using only smaller background stars (they are
        %at infinity and do not move frame to frame)
        windowSize = size(frame, 2)/100;
        proximityMatchStars(true, frame1, frame, transformedFrame, starCenters(:,:,1), starCenters(:,:,j), transform, windowSize);
    
    end
%     writeVideoFromFrames(fullfile(resultsDir, filename), frameRate, frames, verbose);
end
