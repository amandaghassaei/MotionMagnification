function testImageRegistration(frame1, frame, transform)
    transformedFrame = imwarp(frame,transform,'OutputView',imref2d(size(frame1)));
    figure
    imshowpair(frame1,transformedFrame,'blend');
end