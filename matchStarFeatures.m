function matchStarFeatures(frames, starCentersAndRadii)
    
    starCentersAndRadii = normalizeRads(starCentersAndRadii);%first normalize to brightest/biggest star to remove scaling and exposure effects
    frame1FeatureVector = makeFeatureVector(starCentersAndRadii(:,:,1));

    for i=2:size(starCentersAndRadii,3)
        featureVector = makeFeatureVector(starCentersAndRadii(:,:,i));
        
        
    end

end

function matchIndex = getIndexOfClosestMatch(featureVector, frame1FeatureVector)
    
end

function featureVector = makeFeatureVector(starCentersAndRadii)
    
    %first get five brightest stars
    numStars = 5;
    brightest = starCentersAndRadii(1:numStars,:);

    %calculate distance vectors of brightest stars to each other
    featureVector = zeros(numStars, numStars, 2);
    for i=1:numStars
        for j=1:numStars
            featureVector(i,j,1) = brightest(i,1)-brightest(j,1);
            featureVector(i,j,2) = brightest(i,2)-brightest(j,2);
        end
    end
    
    %normalize feature vector to scale
    maximum = max(featureVector(:));
    featureVector = featureVector/maximum;
    
end

function starCentersAndRadii = normalizeRads(starCentersAndRadii)
    for i=1:size(starCentersAndRadii,3)
        maximum = max(starCentersAndRadii(:,3,i));
        starCentersAndRadii(:,3,i) = starCentersAndRadii(:,3,i)/maximum;
    end
end

