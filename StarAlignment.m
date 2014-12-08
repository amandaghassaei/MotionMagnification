% clear;
addpath('./data');
addpath('./matlabPyrTools');
addpath('./matlabPyrTools/MEX');
addpath('./FastPeakFind');
addpath('./peakfit2d');
addpath('./sift');

dataDir = './data';
resultsDir = 'results';
mkdir(resultsDir);

verbose = false;% verbose logging

% all video files or directories of image sequences to process
% be sure to put a backslash in front of directory names for proper sorting
%sequences of astronomy images should be named with the convention:
%nameYYYYMMDD for this analysis
allFilesToProcess = cellstr(char('/orionHighContrast'));

for i=1:size(allFilesToProcess, 1)
    
    if exist(makeFullPath('starCenters.mat', allFilesToProcess{i}, dataDir),'file')
        load(makeFullPath('starCenters.mat', allFilesToProcess{i}, dataDir));
    end
    
    transforms = {};
    if exist(makeFullPath('transforms.mat', allFilesToProcess{i}, dataDir),'file')
        load(makeFullPath('transforms.mat', allFilesToProcess{i}, dataDir));
    end
    
    filename = allFilesToProcess(i);
    filename = filename{1};% get string out
    
    [frames, frameRate] = loadImgs(dataDir, filename, verbose);
    framesGray = preProcessFrames(frames, filename, 'gray', verbose);
    if ~exist(makeFullPath('starCenters.mat', allFilesToProcess{i}, dataDir),'file')
        starCenters = locateAllStarCenters(framesGray, true);
        save(makeFullPath('starCenters.mat', allFilesToProcess{i}, dataDir),'starCenters');
    end
    
%     drawFramesWithStarMarkers(frames(:,:,:,1), starCenters, 500, true);
    
    %register everything to frame 1
    frame1 = frames(:,:,:,1);
    frame1Gray = framesGray(:,:,1,1);
       
    transformedFrames = frames;

    for j=2:size(frames, 4)
        
%         frame = frames(:,:,:,j);
%         frameGray = framesGray(:,:,1,j);
%         
%          %first pass at registration - get kind of close in position and scale
%          if size(transforms,2) >= j
%              [transform, transformedFrame] = featureMatchByHand(frame1, frame, transforms{j});
%          else
%              [transform, transformedFrame] = featureMatchByHand(frame1, frame);
% %           [transform, transformedFrame] = matchWithSift(frame1, frame1Gray, frame, frameGray, verbose);
% %           matchStarFeatures(frame1, frame, starCentersAndRadii);
%              transforms{j} = transform;
%              save(makeFullPath('transforms.mat', allFilesToProcess{i}, dataDir),'transforms');
%          end
% 
%         %second pass - align big stars well
%         windowSize = size(frame, 2)/8;
%         proximityMatchStars(false, frame1, frame, transformedFrame, starCenters(:,:,1), starCenters(:,:,j), transform, windowSize);
%         
%         %final pass - align using only smaller background stars (they are
%         %at infinity and do not move frame to frame)
%         windowSize = size(frame, 2)/100;
%         [transform, transformedFrame] = proximityMatchStars(true, frame1, frame, transformedFrame, starCenters(:,:,1), starCenters(:,:,j), transform, windowSize);
%         
%         transformedFrames(:,:,:,j) = transformedFrame;
    end
    
    transformedFrames = commonStarAlignment(frames, frame1, starCenters, transformedFrames, transforms);
    
    %crop frames to even number
    extra = mod(size(transformedFrames,1),32);
    if (extra>1)
        transformedFrames = transformedFrames(1:end-extra,:,:,:);
    end
    extra = mod(size(transformedFrames,2),32);
    if (extra>1)
        transformedFrames = transformedFrames(:,1:end-extra,:,:);
    end
    
    nlevels = 5;
    winsize = 3;
    medfiltsize = 11;
    nIterations = 5;

%     uFrames = zeros(size(transformedFrames(:,:,:,1), 1), size(transformedFrames(:,:,:,1), 2), size(frames,4)-1);
%     vFrames = uFrames;
% 
%     for num = 2:size(frames, 4)
%         progmeter(num, size(frames, 4));
%         [uFrames(:,:,num-1), vFrames(:,:,num-1), ~] = coarse2fine_lk(transformedFrames(:,:,:,num),transformedFrames(:,:,:,1),nlevels,winsize,medfiltsize,nIterations);
%     end
    
    [uMagFrames, vMagFrames] = magnifyMotion(uFrames, vFrames, 10);
    motionMagnifiedFrames = transformedFrames;
    for j=1:size(frames, 4)-1
        warped = warpFL(transformedFrames(:,:,:,1), uMagFrames(:,:,j), vMagFrames(:,:,j));
        motionMagnifiedFrames(:,:,:,j+1) = warped;
    end
    
    writeVideoFromFrames(fullfile(resultsDir, filename), 8, motionMagnifiedFrames, verbose);
end
