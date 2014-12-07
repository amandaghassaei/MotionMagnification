function [transform, transformedFrame] = matchWithSift(frame1, frame1Gray, frame, frameGray, verbose)

    fprintf('Feature matching with Sift...   \n');

    [frames1,descr1,~,~] = sift(frame1Gray, 'Verbosity', verbose);
    [frames2,descr2,~,~] = sift(frameGray, 'Verbosity', verbose);

    descr1=uint8(512*descr1);
    descr2=uint8(512*descr2);
    tic;
    matches=siftmatch(descr1, descr2);

%         figure; clf ;
%         plotmatches(frame1,frame,frames1(1:2,:),frames2(1:2,:),matches) ;
%         drawnow ; 

    %get all feature pairs
    featurePairs1 = zeros(size(matches, 2), 2);
    featurePairs2 = zeros(size(matches, 2), 2);
    for j=1:size(matches, 2)
        featurePairs1(j,:) = frames1(1:2,matches(1, j));
        featurePairs2(j,:) = frames2(1:2,matches(2, j));
    end

    transform = transformRANSAC(featurePairs1, featurePairs2, 200, 6);
    transformedFrame = testImageRegistration(frame1, frame, transform, true);
end