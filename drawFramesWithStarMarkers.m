function drawFramesWithStarMarkers(frames, starCentersAndRadii, numToDraw, oneFigure)
    
    totalNumCenters = size(starCentersAndRadii,1);
    if numToDraw>totalNumCenters
        numToDraw = totalNumCenters-1;
    end
    numFrames = size(frames, 4);
    
    if (oneFigure)
        combined = frames(:,:,:,1);
        combinedCenters = starCentersAndRadii(:,:,1);
        for i=2:numFrames
            combined = [combined; frames(:,:,:,i)];
            starCentersAndRadii(:,:,i) = [starCentersAndRadii(:,1,i),starCentersAndRadii(:,2,i)+(i-1)*size(frames, 1),starCentersAndRadii(:,3,i)];
            combinedCenters = [combinedCenters; starCentersAndRadii(:,:,i)];
        end
        frames = combined;
        starCentersAndRadii = combinedCenters;
    end
    
    starCentersAndRadii(starCentersAndRadii==-1) = 0;
    
    for i=1:size(frames, 4);
        figure
        imshow(frames(:,:,:,i));
        hold on; % Prevent image from being blown away.
%         plot(starCentersAndRadii(1:1+numToDraw,1),starCentersAndRadii(1:1+numToDraw,2),'r+');
        viscircles(starCentersAndRadii(1:1+numToDraw,1:2,i), starCentersAndRadii(1:1+numToDraw,3,i),'EdgeColor','r');
        if (oneFigure)
            for j=2:numFrames
                currentIndex = totalNumCenters*(j-1)+1;
%                 plot(starCentersAndRadii(currentIndex:currentIndex+numToDraw,1),starCentersAndRadii(currentIndex:currentIndex+numToDraw,2),'r+');
                viscircles(starCentersAndRadii(currentIndex:currentIndex+numToDraw,1:2), starCentersAndRadii(currentIndex:currentIndex+numToDraw,3),'EdgeColor','r');
            end
        end
    end

end

