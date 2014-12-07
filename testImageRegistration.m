function transformedFrame = testImageRegistration(frame1, frame, transform, show)
    transformedFrame = imwarp(frame,transform,'OutputView',imref2d(size(frame1)));
    if (show)
        figure
        imshowpair(frame1,transformedFrame,'blend');
    end
end