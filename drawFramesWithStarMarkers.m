function drawFramesWithStarMarkers(frames, starCentersAndRadii)

    for i=1:size(frames, 4)
        figure
        imshow(frames(:,:,:,i));
        hold on; % Prevent image from being blown away.
        plot(starCentersAndRadii(:,2,i),starCentersAndRadii(:,1,i),'r+');
    end

end

