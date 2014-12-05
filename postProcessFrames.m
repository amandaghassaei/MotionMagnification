function frames = postProcessFrames(frames, filename, colorspaceForProcessing, chromAttenuation, verbose)

    fprintf('Post-processing frames   \n');
    
    for i=1:size(frames, 4)
        
        frame = frames(:,:,:,i);
        if strcmp(colorspaceForProcessing, 'ntsc')
            frame(:,:,2) = frame(:,:,2)*chromAttenuation; 
            frame(:,:,3) = frame(:,:,3)*chromAttenuation;
            frame = ntsc2rgb(frame); 
        elseif strcmp(colorspaceForProcessing, 'hsv')
            frame = hsv2rgb(frame);
        end
            
        if (verbose)
            fprintf('Post-processing frames %s, frame %i of %i\n', filename, i, size(frames, 4));
        else
            progmeter(i, size(frames, 4));
        end
        
        
        %clip to rgb bounds
        frame(frame > 1) = 1;
        frame(frame < 0) = 0;
        
        frames(:,:,:,i) = frame(:,:,:);
    end

end

