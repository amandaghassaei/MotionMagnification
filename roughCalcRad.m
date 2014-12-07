function rads = roughCalcRad(image, maxIndices)
    
    %super simple, just count num pixels in + x direction that are above a
    %threshold.  this will give good relative rads for an image, but rads 
    %should be normalized when comparing across images
    brightnessThreshold = 0.8;
    rads = zeros(size(maxIndices, 1),1);
    for i=1:size(maxIndices, 1)
        rad = 0;
        xPosition = maxIndices(i,1);
        yPosition = maxIndices(i,2);
        
        %check that we are in image bounds
        if xPosition<1 || xPosition>size(image, 2)
            rads(i) = -1;
            continue;
        end
        if yPosition<1 || yPosition>size(image, 1)
            rads(i) = -1;
            continue;
        end
        
        while(image(yPosition, xPosition) > brightnessThreshold || (image(yPosition, xPosition)-image(yPosition, xPosition+1))>0.15)
            rad = rad+1;
            xPosition = xPosition+1;
            if xPosition>size(image, 2)
                break;
            end
        end
        rads(i) = rad;
    end
end