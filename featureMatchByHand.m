function [transform, transformedFrame] = featureMatchByHand(frame1, frame, transform)
        
%     matchedPoints1 = [440.000000000000,221.000000000000;474.000000000000,189;98.0000000000000,200;90.0000000000000,118.000000000000;64.0000000000000,173];
%     matchedPoints2 = [376.000000000000,158;395.000000000000,130;137,190;123.000000000000,137;109.000000000000,178];
%     matchedPoints1 = [376.000000000000,159.000000000000;398.000000000000,268.000000000000;152,327.000000000000;60.0000000000000,199;121.000000000000,136.000000000000];
%     matchedPoints2 = [360.000000000000,182;356.000000000000,300;94.0000000000000,301;32.0000000000000,149;108.000000000000,97.9999999999999];

    if (nargin < 3)
        fprintf('Select 5 feature pairs, select from top, then bottom, then top, then bottom...   \n');
        [matchedPoints1,matchedPoints2] = selectFeaturePoints(frame1, frame);
        transform = fitgeotrans(matchedPoints2,matchedPoints1,'projective');
    end
    transformedFrame = testImageRegistration(frame1, frame, transform, false);   
end

function [matchedPoints1,matchedPoints2] = selectFeaturePoints(frame1, frame)

    figure;
    imshow([frame1;frame]);

    %manually select 10 pts
    correspondingPts = ginput(10);
    for i=2:2:10
        correspondingPts(i,2) = correspondingPts(i,2)-size(frame1,1);
    end
    matchedPoints1 = correspondingPts(1:2:end,:);
    matchedPoints2 = correspondingPts(2:2:end,:);
end