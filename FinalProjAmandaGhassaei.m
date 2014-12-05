
dataDir = './data';
resultsDir = 'results';
mkdir(resultsDir);

verbose = true;
processInNTSC = false;

% all video files or directories of image sequences to process
% be sure to put a backslash in front of directory names for proper sorting
allFilesToProcess = cellstr(char('/bookshelf', 'babyShort.mp4'));


for i=1:1%size(allFilesToProcess, 1)
    filename = allFilesToProcess(1);
    filename = filename{1};% get string out
    fullPath = fullfile(dataDir, filename);
    if strcmp(filename(1), '/')% if this is a sequence of images
        frames = extractImgsFromSequence(fullPath, verbose);
        frameRate = 10;% set default frame rate of 10fps
    else% if this is a video
        [frames, frameRate] = extractImgsFromVideo(fullFilePath, verbose);
    end
    if processInNTSC
        frames = preProcessFrames(frames, fullFilePath, verbose);
    end
    
end

if processInNTSC
    postProcessFrames(frames);
end
writeVideoFromFrames(fullfile(resultsDir, filename), frameRate, frames, verbose);

fullFilePath = fullfile(dataDir, allFilesToProcess(1));

