function [transform, transformedFrame] = proximityMatchStars(finalPass, frame1, frame, transformedFrame, starCenters1,...
    starCenters, forwardTransform, windowSize)

    if finalPass
        [starCenters1, starCenters] = getCentersForFinalPass(starCenters1, starCenters);
    else
        [starCenters1, starCenters] = getCentersForFirstPass(starCenters1, starCenters);
    end

    %get star centers and rad for warped img
    transformedStarCenters = transformPointsForward(forwardTransform, starCenters(:,1:2));
    transformedStarCenters(:,3) = roughCalcRad(rgb2gray(transformedFrame), round(transformedStarCenters));
    
%     centersDim = min(size(starCenters1,1), size(transformedStarCenters,1));
%     drawFramesWithStarMarkers(cat(4, frame1, transformedFrame), cat(3, starCenters1(1:centersDim,:), transformedStarCenters(1:centersDim,:)), 200, true);
    
    [matches, ~] = findMatches(starCenters1, transformedStarCenters, windowSize);
    
    featurePairs1 = starCenters1(matches(:,1), 1:2);
    featurePairs2 = starCenters(matches(:,2), 1:2);
    drawFeatureMaps([frame1; transformedFrame], featurePairs1, transformedStarCenters(matches(:,2), 1:2));
    
    numMatches = 10;
    numRANSAC = 20;
    if finalPass
        numMatches = 30;
        numRANSAC = 200;
    end
    transform = transformRANSAC(featurePairs1, featurePairs2, numRANSAC, numMatches);
    transformedFrame = testImageRegistration(frame1, frame, transform, false);
end

function [starCenters1, starCenters] = getCentersForFinalPass(starCenters1, starCenters)
    %filter out tiny stars
    starCenters1 = removeLargerStars(starCenters1);
    starCenters = removeLargerStars(starCenters);
end

function [starCenters1, starCenters] = getCentersForFirstPass(starCenters1, starCenters)
    %filter out tiny stars
    starCenters1 = removeTiniestStars(starCenters1);
    starCenters = removeTiniestStars(starCenters);
end

function filtered = removeTiniestStars(centers)
%     remove stars with small rad
    centers( ~any(centers,2), : ) = [];
    numCenters = size(centers, 1);
    totalFeatures = max(round(numCenters/2), 200);
    if totalFeatures>numCenters
        totalFeatures = numCenters;
    end
    filtered = centers(1:totalFeatures, :);
end

function filtered = removeLargerStars(centers)
%     remove stars with large rad
    centers( ~any(centers,2), : ) = [];
    numCenters = size(centers, 1);
    totalFeatures = max(round(numCenters*2/3), 200);
    if totalFeatures>numCenters
        totalFeatures = numCenters;
    end
    filtered = centers(numCenters-totalFeatures+1:end, :);
end