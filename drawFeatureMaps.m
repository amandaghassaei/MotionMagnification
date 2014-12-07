function drawFeatureMaps(frames, featurePoints1, featurePoints2)
    
    frameHeight = size(frames, 1)/2;
    featurePoints2 = [featurePoints2(:,1), featurePoints2(:,2) + frameHeight];

    figure
    imshow(frames(:,:,:));
    hold on; % Prevent image from being blown away.
    for i=1:size(featurePoints1, 1)
        plot([featurePoints1(i,1), featurePoints2(i,1)],[featurePoints1(i,2), featurePoints2(i,2)],'Color','r','LineWidth',1);
%         plot([0,10], [200,200],'Color','r','LineWidth',2);
    end
end