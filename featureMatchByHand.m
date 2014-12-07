function [transform, transformedFrame] = featureMatchByHand(frame1, frame)

    fprintf('Select 5 feature pairs, select from top, then bottom, then top, then bottom...   \n');
        
    matchedPoints1 = [440.000000000000,221.000000000000;474.000000000000,189;98.0000000000000,200;90.0000000000000,118.000000000000;64.0000000000000,173];
    matchedPoints2 = [376.000000000000,158;395.000000000000,130;137,190;123.000000000000,137;109.000000000000,178];

%         [matchedPoints1,matchedPoints2] = selectFeaturePoints(frame1, frame);
    transform = fitgeotrans(matchedPoints2,matchedPoints1,'projective');
    transformedFrame = imwarp(frame,transform,'OutputView',imref2d(size(frame1)));
%     figure
%     imshowpair(frame1,transformedFrame,'blend');    
end

function [matchedPoints1,matchedPoints2] = selectFeaturePoints(frame1, frame)

    imshow([frame1;frame]);

    %manually select 20 pts
    correspondingPts = ginput(10);
    for i=2:2:10
        correspondingPts(i,2) = correspondingPts(i,2)-size(frame1,1);
    end
    matchedPoints1 = correspondingPts(1:2:end,:);
    matchedPoints2 = correspondingPts(2:2:end,:);
end