function [uFrames, vFrames] = magnifyMotion(uFrames, vFrames, magnification)
    for num = 1:size(uFrames, 3)
        magUFrame = uFrames(:, :, num)*magnification;
        magVFrame = vFrames(:, :, num)*magnification;
    end

end