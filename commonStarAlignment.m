function transformedFrames = commonStarAlignment(frames, frame1, starCenters, transformedFrames, transforms)
    %find stars common to every image
    commonStars = zeros(1,size(frames, 4));
    frame1StarCenters = starCenters(:,:,1);
    frame1StarCenters(~any(frame1StarCenters,2),:) = [];%remove zero rows
    
    numCentersToTest = size(frame1StarCenters, 1);
    commonStars(1:numCentersToTest,1) = reshape(linspace(1,numCentersToTest,numCentersToTest),[numCentersToTest,1]);
    
    windowSize = size(frames, 2)/100;
    for j=2:size(frames,4)
        tStarCenters(:,1:2,j) = transformPointsForward(transforms{j}, starCenters(:,1:2,j));
        tStarCenters(:,3,j) = roughCalcRad(rgb2gray(transformedFrames(:,:,:,j)), round(tStarCenters(:,:,j)));
        [~,commonStars(:,j)] = findMatches(frame1StarCenters, tStarCenters(:,:,j), windowSize);
    end
    
    commonStars(any(commonStars==0,2),:)=[];%remove any rows with zeros
    
    %pick smaller stars
    commonStars = commonStars(round(size(commonStars,1)/2):end,:);
    
    featurePoints1 = starCenters(commonStars(:,1),1:2,1);
    for j=2:size(frames, 4)
        featurePoints2 = starCenters(commonStars(:,j),1:2,j);
        transform = fitHomography(featurePoints1,featurePoints2);
        transformedFrames(:,:,:,j) = testImageRegistration(frame1, frames(:,:,:,j), transform, false);
    end
end