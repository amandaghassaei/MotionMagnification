function frames = preProcessFrames(frames, filename, colorspaceForProcessing, verbose)
    
    if strcmp(colorspaceForProcessing, 'rgb')
        return;
    end
    fprintf('Converting %s to %s colorspace   \n', filename, colorspaceForProcessing);
    
    for i=1:size(frames, 4)
        
        frame = frames(:,:,:,i);
        if strcmp(colorspaceForProcessing, 'ntsc')
            frames(:,:,:,i) = rgb2ntsc(frame);
        elseif strcmp(colorspaceForProcessing, 'hsv')
            frames(:,:,:,i) = rgb2hsv(frame);
        elseif strcmp(colorspaceForProcessing, 'lab')
%             frames(:,:,:,i) = rgb2lab(frame);
        elseif strcmp(colorspaceForProcessing, 'gray')
            frames(:,:,1,i) = rgb2gray(frame);
        end
            
        if (verbose)
            fprintf('Preprocessing frames %s, frame %i of %i\n', filename, i, size(frames, 4));
        else
            progmeter(i, size(frames, 4));
        end
    end
end

