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
%     featureMatchByHand(frames);
    frames = preProcessFrames(frames, filename, 'gray', verbose);
    starCentersAndRadii = locateAllStarCenters(frames);
    matchWithSift(frames, verbose);
%     matchStarFeatures(frames, starCentersAndRadii);
%     drawFramesWithStarMarkers(frames, starCentersAndRadii);   
    
%     writeVideoFromFrames(fullfile(resultsDir, filename), frameRate, frames, verbose);
end
