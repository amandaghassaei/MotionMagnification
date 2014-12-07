function transform = proximityMatchStars(finalPass, frame1, frame, transformedFrame, starCenters1,...
    starCenters, forwardTransform, windowSize)

    if finalPass
        [starCenters1, starCenters] = getCentersForFinalPass(starCenters1, starCenters);
    else
        [starCenters1, starCenters] = getCentersForFirstPass(starCenters1, starCenters);
    end

    %get star centers and rad for warped img
    transformedStarCenters = transformPointsForward(forwardTransform, starCenters(:,1:2));
    transformedStarCenters(:,3) = roughCalcRad(rgb2gray(transformedFrame), round(transformedStarCenters));
    
%     drawFramesWithStarMarkers(cat(4, frame1, transformedFrame), cat(3, starCenters1(1:50,:), transformedStarCenters(1:50,:)), 200);
    
    matches = findMatches(starCenters1, transformedStarCenters, windowSize);
    
    featurePairs1 = starCenters1(matches(:,1), 1:2);
    featurePairs2 = starCenters(matches(:,2), 1:2);
    
    numMatches = 10;
    numRANSAC = 20;
    if finalPass
        numMatches = 30;
        numRANSAC = 200;
    end
    transform = transformRANSAC(featurePairs1, featurePairs2, numRANSAC, numMatches);
    testImageRegistration(frame1, frame, transform);
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

function matches = findMatches(starCenters1, transformedStarCenters, windowSize)

    matches = zeros(1,2);
    matchIndex = 1;
    for i=1:size(transformedStarCenters, 1)
        if transformedStarCenters(i,3)==-1 %this was outside the bounds of the transformed image
            continue;
        end
        
        for j=1:size(starCenters1, 1)
            dist = (starCenters1(j,1)-transformedStarCenters(i,1))^2 + (starCenters1(j,2)-transformedStarCenters(i,2))^2;
            if dist<(windowSize/2)^2
                matches(matchIndex,1) = j;
                matches(matchIndex,2) = i;
                matchIndex = matchIndex+1;
            end
        end
    end

end

function filtered = removeTiniestStars(centers)
%     remove stars with 0 rad
    filtered = zeros(1,3);
    for i=1:size(centers,1)
        if (centers(i,3)>0)
            filtered(i,:) = centers(i,:);
        else
            return;
        end
    end
end

function filtered = removeLargerStars(centers)
%     remove stars with 0 rad
    filtered = zeros(1,3);
    index = 1;
    for i=1:size(centers,1)
        if (centers(i,3)==0)
            filtered(index,:) = centers(i,:);
            index = index+1;
        end
    end
end