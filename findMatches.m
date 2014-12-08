function [matches, indexedMatch] = findMatches(starCenters1, transformedStarCenters, windowSize)

    matches = zeros(1,2);
    matchIndex = 1;
    
    indexedMatch = zeros(size(starCenters1,1), 1);
    for i=1:size(transformedStarCenters, 1)
        if transformedStarCenters(i,3)==-1 %this was outside the bounds of the transformed image
            continue;
        end
        bestMatch = [-1,-1,-1];
        for j=1:size(starCenters1, 1)
            dist = (starCenters1(j,1)-transformedStarCenters(i,1))^2 + (starCenters1(j,2)-transformedStarCenters(i,2))^2;
            if dist<(windowSize/2)^2
                if bestMatch(1,1) == -1 || dist<bestMatch(1,3)
                    bestMatch = [j,i,dist];
                end
            end
        end
        
        if bestMatch(1,1) ~= -1
            indexedMatch(bestMatch(1,1),1) = bestMatch(1,2);
            matches(matchIndex,1) = bestMatch(1,1);
            matches(matchIndex,2) = bestMatch(1,2);
            matchIndex = matchIndex+1;
        end
    end

end