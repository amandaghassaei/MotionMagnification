function allStarCentersAndRadii = locateAllStarCenters(framesGray, highRes)
    
    allStarCentersAndRadii = zeros(1, 3, size(framesGray, 4));%starx, stary, starRad
    fprintf('Locating star centers and radii   \n');
    
    for i=1:size(framesGray, 4)
        frame = framesGray(:,:,1,i);%working with a 2D (gray) image
        
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
%         [maxIndices,radii,metric] = imfindcircles(frame,[1, 10])   
        
        if ~highRes
            
            %fast peak find (~1 px accuracy)
            %http://www.mathworks.com/matlabcentral/fileexchange/37388-fast-2d-peak-finder
            %FastPeakFind(d, thres, filt ,edg, res, fid)
            peaks=FastPeakFind(frame);
            clear maxIndices;
            maxIndices(:,1) = peaks(1:2:end);
            maxIndices(:,2) = peaks(2:2:end);
            
            rads = roughCalcRad(frame, maxIndices);
            progmeter(i,size(framesGray, 4));
        else
            %first find all brightestSpots
            [row, col, ~] = find(frame>0.9);
            maxIndices = col;
            maxIndices(:,2) = row;
            
            %cluster together neighbors
            clusters = [row, col, reshape(linspace(1,size(row,1),size(row,1)),size(row, 1),1)];%assign a cluster val to each bright px
            for m=1:size(row,1)
                progmeter(i*m,size(framesGray, 4)*size(row,1));
                for n=m:size(row,1)
                    if clusters(m,3) == clusters(n,3)
                        continue;
                    end
                    if abs(clusters(m,1)-clusters(n,1))<=1 && abs(clusters(m,2)-clusters(n,2))<=1
                        cluster1Num = clusters(m,3);
                        cluster2Num = clusters(n,3);
                        newCluster = min(cluster1Num, cluster2Num);
                        if newCluster == cluster1Num
                            clusters = updateAllClusterMembers(clusters, newCluster, cluster2Num);
                        else
                            clusters = updateAllClusterMembers(clusters, newCluster, cluster1Num);
                        end
                    end
                end
            end

            peaks = zeros(1,2);
            index = 1;
            for j=1:max(clusters(:,3))
                rowSum = 0;
                colSum = 0;
                numPxs = 0;
                for k=1:size(clusters, 1)
                    if clusters(k,3) == j
                        rowSum = rowSum + clusters(k,1);
                        colSum = colSum + clusters(k,2);
                        numPxs = numPxs+1;
                    end
                end
                if numPxs == 0
                    continue;
                end
                peaks(index,2) = rowSum/numPxs;
                peaks(index,1) = colSum/numPxs;
                index = index+1;
            end
            maxIndices = peaks;
            rads = roughCalcRad(frame, maxIndices);

            %gaussian peak fit (sub-pixel accuracy
            %http://www.mathworks.com/matlabcentral/fileexchange/26504-sub-sample-peak-fitting-2d
            subSampleIndices = zeros(1,3);
            index = 1;
            for j=1:size(maxIndices,1)
                rad = rads(j)*4;
                originX = round(maxIndices(j,1)-rad/2);
                originY = round(maxIndices(j,2)-rad/2);
                if originX<1 || originY<1 || originX+rad>size(frame,2) || originY+rad>size(frame,1)
                    continue;
                end
                window = frame(originY:originY+rad, originX:originX+rad,:);
                peak = peakfit2d(window);%[y, x]
                if size(peak,1) == 0
                    continue
                end
                subSampleIndices(index,1) = originX + peak(2) - 1;
                subSampleIndices(index,2) = originY + peak(1) - 1;
                subSampleIndices(index,3) = rads(j);
                index = index +1;
            end
            maxIndices = subSampleIndices(:,1:2);
            rads = subSampleIndices(:,3);
        end
        
        clear starCentersAndRadii;
        starCentersAndRadii = allStarCentersAndRadii(:,:,i); 
        starCentersAndRadii(1:size(maxIndices, 1), 1:2) = maxIndices;
        starCentersAndRadii(1:size(maxIndices, 1),3) = rads;
        starCentersAndRadii = sortByRadius(starCentersAndRadii);
        allStarCentersAndRadii(1:size(starCentersAndRadii,1),:,i) = starCentersAndRadii;
    end

end

function clusters = updateAllClusterMembers(clusters, newCluster, oldClusterNum)
    for i=1:size(clusters, 1)
        if clusters(i,3) == oldClusterNum
            clusters(i,3) = newCluster;
        end
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


