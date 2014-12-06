function allStarCentersAndRadii = locateAllStarCenters(frames)
    
    allStarCentersAndRadii = zeros(1, 3, size(frames, 4));%starx, stary, starRad
    fprintf('Locating star centers and radii   \n');
    
    for i=1:size(frames, 4)
        frame = frames(:,:,1,i);%working with a 2D (gray) image
        
        %get maxima of image
%         [~,maxIndices,~,~] = extrema2(frame);
%         maxIndices = convertIndicesToXY(maxIndices, size(frame,2));
        [row, col, ~] = find(frame>0.8);
        maxIndices = row;
        maxIndices(:,2) = col;
        
        starCentersAndRadii = allStarCentersAndRadii(:,:,i);
        starCentersAndRadii(1:size(maxIndices, 1), 1:2) = maxIndices;
        
        starCentersAndRadii = sortByRadius(starCentersAndRadii);
        allStarCentersAndRadii(1:size(starCentersAndRadii,1),:,i) = starCentersAndRadii;
    end

end

function indices = convertIndicesToXY(indices, width)
    for i=1:size(indices)
        absIndex = indices(i);
        indices(i,1) = mod(absIndex, width);
        indices(i,2) = round(absIndex/width)+1;
    end
end

function starCentersAndRadii = sortByRadius(starCentersAndRadii)
    [~,I] = sort(starCentersAndRadii(:,3), 'descend');
    starCentersAndRadii=starCentersAndRadii(I,:);
end


