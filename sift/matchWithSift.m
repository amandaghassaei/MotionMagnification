function matchWithSift(frames, verbose)

    frame1 = frames(:,:,1,1);

    for i=2:size(frames, 4)
        
        frame = frames(:,:,1,i);
        
        [frames1,descr1,~,dogss1] = sift(frame1, 'Verbosity', verbose);
        [frames2,descr2,~,dogss2] = sift(frame, 'Verbosity', verbose);

        descr1=uint8(512*descr1);
        descr2=uint8(512*descr2);
        tic;
        matches=siftmatch(descr1, descr2);

%         figure; clf ;
%         plotmatches(im1,frames(:,:,1,i),frames1(1:2,:),frames2(1:2,:),matches) ;
%         drawnow ; 

        %get all feature pairs
        featurePairs1 = zeros(size(matches, 2), 2);
        featurePairs2 = zeros(size(matches, 2), 2);
        for j=1:size(matches, 2)
            featurePairs1(j,:) = frames1(1:2,matches(1, j));
            featurePairs2(j,:) = frames2(1:2,matches(2, j));
        end

        transform = transformRANSAC(featurePairs1, featurePairs2);
        transformedFrame = imwarp(frame,transform);
        figure
        imshow(frame1);
        figure
        imshow(frame);
        figure
        imshow(transformedFrame);
        
    end
    
end

function tform = transformRANSAC(featurePairs1, featurePairs2)

    numRANSAC = 20;

    bestFitness = 0;
    bestH = 0;
    for i=1:numRANSAC
        %calculate homography for a set of matches
        m = 5;%number of matched pairs to compute homography

        % pick m matches randomly
        x1Hom = zeros(m,2);
        x2Hom = zeros(m,2);
        for k=1:4
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
            homogMatch1 = transformPointsForward(testH, match1);
            diffSq = (homogMatch1(1,1)-match2(1,1))^2+(homogMatch1(1,2)-match2(1,2))^2;
            sumDiff = sumDiff + diffSq;
        end
        
        if i==1 || sumDiff<bestFitness
            bestFitness = sumDiff;
            bestH = testH;
        end
    end

    tform = bestH;
end

function tform = fitHomography(matchedPoints1,matchedPoints2)
    tform = fitgeotrans(matchedPoints1,matchedPoints2,'affine');
%     tform = estimateGeometricTransform(matchedPoints1,matchedPoints2,'projective');
end