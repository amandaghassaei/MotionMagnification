function pyramid = makePyramid( source, level )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if level==1
    pyramid = source;
    return;
end
for n=1:level-1
    source = impyramid(source, 'reduce');
end

pyramid = source;

end

