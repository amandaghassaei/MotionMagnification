addpath('./data');
addpath('./matlabPyrTools');
addpath('./matlabPyrTools/MEX');
addpath('./extrema');

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
    frames = preProcessFrames(frames, filename, 'gray', verbose);
    starCentersAndRadii = locateAllStarCenters(frames);
    drawFramesWithStarMarkers(frames, starCentersAndRadii)

    
%     for i=1:size(frames, 4)
%         subplot(2, 1, i);
%         imshow(frames(:,:,1,i));
%     end
    
    
   
    
%     writeVideoFromFrames(fullfile(resultsDir, filename), frameRate, frames, verbose);
end
