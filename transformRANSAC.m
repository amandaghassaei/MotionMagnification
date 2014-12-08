function tform = transformRANSAC(featurePairs1, featurePairs2, numRANSAC, numMatches)

    fprintf('RANSAC   \n');

    bestFitness = 0;
    bestH = 0;
    for i=1:numRANSAC
        
        progmeter(i, numRANSAC);
        %calculate homography for a set of matches

        % pick m matches randomly
        x1Hom = zeros(numMatches,2);
        x2Hom = zeros(numMatches,2);
        for k=1:numMatches
            index = randi(size(featurePairs1,1));
            x1Hom(k,:) = featurePairs1(index,:);
            x2Hom(k,:) = featurePairs2(index,:);
        end
        
        %get H for this set of matches
        testH = fitHomography(x1Hom, x2Hom);
        
        %compute agreement with other matches
        sumDiff = 0;
        for j=1:size(featurePairs1,1)
            match1 = featurePairs1(j,:);
            match2 = featurePairs2(j,:);
            homogMatch1 = transformPointsForward(testH, match2);
            diffSq = (homogMatch1(1,1)-match1(1,1))^2+(homogMatch1(1,2)-match1(1,2))^2;
            sumDiff = sumDiff + diffSq;
        end
        
        if i==1 || sumDiff<bestFitness
            bestFitness = sumDiff;
            bestH = testH;
        end
    end

    tform = bestH;
end