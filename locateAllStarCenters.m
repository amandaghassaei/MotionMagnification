function allStarCentersAndRadii = locateAllStarCenters(frames)
    
    allStarCentersAndRadii = zeros(1, 3, size(frames, 4));%starx, stary, starRad
    fprintf('Locating star centers and radii   \n');
    
    for i=1:size(frames, 4)
        frame = frames(:,:,1,i);%working with a 2D (gray) image
        
        %get locations of stars - tried several techniques
        
        %thresholding
%         [row, col, ~] = find(frame>0.8);
%         maxIndices = col;
%         maxIndices(:,2) = row;

        %extrema
        %http://www.mathworks.com/matlabcentral/fileexchange/12275-extrema-m--extrema2-m
%         [~,maxIndices,~,~] = extrema2(frame);
%         maxIndices = convertIndicesToXY(maxIndices, size(frame,2));

        %circular Hough transform
%         [maxIndices,radii,metric] = imfindcircles(frame,[1, 10]);

        %fast peak find (~1 px accuracy)
        %http://www.mathworks.com/matlabcentral/fileexchange/37388-fast-2d-peak-finder
        peaks=FastPeakFind(frame);
        clear maxIndices;
        maxIndices(:,1) = peaks(1:2:end);
        maxIndices(:,2) = peaks(2:2:end);
        
        %peak fit (sub-pixel accuracy
        %http://www.mathworks.com/matlabcentral/fileexchange/26504-sub-sample-peak-fitting-2d
%         P = peakfit2d(frame);
        
        clear starCentersAndRadii;
        starCentersAndRadii = allStarCentersAndRadii(:,:,i);
        starCentersAndRadii(1:size(maxIndices, 1), 1:2) = maxIndices;
        rads = roughCalcRad(frame, maxIndices);
        starCentersAndRadii(1:size(maxIndices, 1),3) = rads;
        
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


