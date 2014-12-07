function drawFramesWithStarMarkers(frames, starCentersAndRadii)

    for i=1:size(frames, 4)
        figure
        imshow(frames(:,:,:,i));
        hold on; % Prevent image from being blown away.
        viscircles(starCentersAndRadii(1:2,1:2,i), starCentersAndRadii(1:2,3,i),'EdgeColor','r');
    end

end

