function frames = preProcessFrames(frames, filename, colorspaceForProcessing, verbose)
    
    if strcmp(colorspaceForProcessing, 'rgb')
        return;
    end
    fprintf('Preprocessing frames %s   \n', filename);
    
    for i=1:size(frames, 4)
        
        frame = frames(:,:,:,i);
        if strcmp(colorspaceForProcessing, 'ntsc')
            frames(:,:,:,i) = rgb2ntsc(frame);
        elseif strcmp(colorspaceForProcessing, 'hsv')
            frames(:,:,:,i) = rgb2hsv(frame);
        end
            
        if (verbose)
            fprintf('Preprocessing frames %s, frame %i of %i\n', filename, i, size(frames, 4));
        else
            progmeter(i, size(frames, 4));
        end
    end
end

