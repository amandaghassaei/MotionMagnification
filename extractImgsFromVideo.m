function [allFrames, frameRate] = extractImgsFromVideo(filename, verbose)

    fprintf('Loading video file %s\n', filename);
    % Read video
    video = VideoReader(filename);
    
    % Extract video info
    frameRate = video.FrameRate;
    numFrames = video.NumberOfFrames;
    vidHeight = video.Height;
    vidWidth = video.Width;
    numChannels = 3;
    
    %get each frame and store in array
    allFrames = zeros(vidHeight, vidWidth, numChannels, numFrames);
    for i=1:numFrames
        allFrames(:,:,:,i) = getVideoFrame(i, video, vidHeight, vidWidth, numChannels);
        if (verbose)
            fprintf('Loading video file %s, frame %i of %i\n', filename, i, numFrames);
        end
    end
end

function frame = getVideoFrame(numFrame, video, vidHeight, vidWidth, numChannels)

    tempStorage = struct('cdata', ...
		  zeros(vidHeight, vidWidth, numChannels, 'uint8'), ...
		  'colormap', []);
    tempStorage.cdata = read(video, numFrame);
    [rgbframe,~] = frame2im(tempStorage);
    frame = im2double(rgbframe);
end