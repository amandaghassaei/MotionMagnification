function matchStarFeatures(frames, starCentersAndRadii)

    %feature vectors in this context are vectors describing the distance of
    %a star to the brightest stars common to both images.  
    %first, I must figure out what those are.
    
%     starCentersAndRadii = normalizeRads(starCentersAndRadii);%first normalize to brightest/biggest star to remove scaling and exposure effects
    frame1FeatureVector = makeFeatureVector(starCentersAndRadii(:,:,1));

    for i=2:size(starCentersAndRadii,3)
        featureVector = makeFeatureVector(starCentersAndRadii(:,:,i));
        matchIndex = getIndexOfClosestMatch(featureVector, frame1FeatureVector);
        
    end

end

function matchIndex = getIndexOfClosestMatch(featureVector, frame1FeatureVector)

    matchThreshold = 0.1;

    for i=1:size(featureVector, 1)
        for j=1:size(featureVector, 1)
            
            if abs(frame1FeatureVector(i,j,1:2)-featureVector(i,j,1:2))<matchThreshold
                
            end
            
        end
    end


    matchIndex = 0;
end

function featureVector = makeFeatureVector(starCentersAndRadii)
    
    %first get 20 brightest stars
    numStars = 20;
    brightest = starCentersAndRadii(1:numStars,:);

    %calculate distance vectors of brightest stars to each other
    featureVector = zeros(numStars, numStars, 2);
    for i=1:numStars
        for j=1:numStars
            featureVector(i,j,1) = brightest(i,1)-brightest(j,1);
            featureVector(i,j,2) = brightest(i,2)-brightest(j,2);
        end
    end
    
    featureVector = normalizeFeatureVector(featureVector);
    [featureVector, I] = sortByProximityToGroup(featureVector);
    
    %tack on indices, we'll need them later
    featureVector(:,1,3) = I;
    
end

function featureVector = normalizeFeatureVector(featureVector)
    %normalize feature vector to scale of image
    maximum = max(featureVector(:));
    featureVector = featureVector/maximum;
end

function [featureVector, I] = sortByProximityToGroup(featureVector)
    %sort by proximity to other bright stars (to more easily weed out
    %outliers from cropping)
    squaredVector = featureVector.^2;
    absDist = (squaredVector(:,:,1) + squaredVector(:,:,2)).^(1/2);
    [~,I] = sort(sum(absDist,1), 'ascend');
    featureVector=featureVector(I,:,:);
    
end

function starCentersAndRadii = normalizeRads(starCentersAndRadii)
    for i=1:size(starCentersAndRadii,3)
        maximum = max(starCentersAndRadii(:,3,i));
        starCentersAndRadii(:,3,i) = starCentersAndRadii(:,3,i)/maximum;
    end
end

