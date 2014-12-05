function [allFrames, frameRate] = extractImgs(dataDir, filename, verbose)
    fullPath = fullfile(dataDir, filename);
    if strcmp(filename(1), '/')% if this is a sequence of images
        allFrames = extractImgsFromSequence(fullPath, verbose);
        frameRate = 10;% set default frame rate of 10fps
    else% if this is a video
        [allFrames, frameRate] = extractImgsFromVideo(fullPath, verbose);
    end
end