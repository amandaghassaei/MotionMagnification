function tform = fitHomography(matchedPoints1,matchedPoints2)
    tform = fitgeotrans(matchedPoints2,matchedPoints1,'affine');
end