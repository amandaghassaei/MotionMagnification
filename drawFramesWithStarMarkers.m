function drawFramesWithStarMarkers(frames, starCentersAndRadii, numToDraw)
    
    if numToDraw>size(starCentersAndRadii,1)
        numToDraw = size(starCentersAndRadii,1);
    end
    
    starCentersAndRadii(starCentersAndRadii==-1) = 0;
    
    for i=1:size(frames, 4)
        figure
        imshow(frames(:,:,:,i));
        hold on; % Prevent image from being blown away.
        viscircles(starCentersAndRadii(1:numToDraw,1:2,i), starCentersAndRadii(1:numToDraw,3,i),'EdgeColor','r');
    end

end

