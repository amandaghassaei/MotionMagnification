function [allFrames, frameRate] = extractImgs(dataDir, filename, verbose)
    fullPath = fullfile(dataDir, filename);
    if strcmp(filename(1), '/')% if this is a sequence of images
        allFrames = extractImgsFromSequence(fullPath, verbose);
        frameRate = 10;% set default frame rate of 10fps
    else% if this is a video
        [allFrames, frameRate] = extractImgsFromVideo(fullPath, verbose);
    end
end

function [allFrames, frameRate] = extractImgsFromVideo(filename, verbose)

    fprintf('Loading video file %s   \n', filename);
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
        else
            progmeter(i, numFrames);
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

function allFrames = extractImgsFromSequence(filename, verbose)

    fprintf('Loading images from %s directory   \n', filename);
    allFiles = getAllFilesInDir(filename);
    
%      load first image
    file1 = allFiles(1);
    img1 = im2double(imread(file1{1}));
    allFrames = zeros(size(img1, 1), size(img1, 2), size(img1, 3), size(allFiles, 1));
    allFrames(:, :, :, 1) = img1(:, :, :);
    for i=2:size(allFiles, 1)
        file = allFiles(i);
        file = file{1};
        if (verbose)
            fprintf('Loading image %s, frame %i of %i\n', file, i, size(allFiles, 1));
        else
            progmeter(i, size(allFiles, 1));
        end
        img = im2double(imread(file));
        allFrames(:, :, :, i) = img(:, :, :);
    end
end

function fileList = getAllFilesInDir(dirName)

  dirData = dir(dirName); 
  dirIndex = [dirData.isdir];
  fileList = {dirData(~dirIndex).name}';
  if ~isempty(fileList)
      % Prepend path to files
      fileList = cellfun(@(x) fullfile(dirName,x),fileList,'UniformOutput',false);
  end
 
end