
function frames = postProcessFrames(frames, amplifiedFrames, filename, colorspaceForProcessing, chromAttenuation, verbose)

    fprintf('Post-processing frames   \n');
    
    for i=1:size(frames, 4)
        
        frame = frames(:,:,:,i);
        amplifiedFrame = amplifiedFrames(:,:,:,i);
        if strcmp(colorspaceForProcessing, 'ntsc')
            amplifiedFrame(:,:,2) = amplifiedFrame(:,:,2)*chromAttenuation; 
            amplifiedFrame(:,:,3) = amplifiedFrame(:,:,3)*chromAttenuation;
            frame = ntsc2rgb(frame+amplifiedFrame); 
        elseif strcmp(colorspaceForProcessing, 'hsv')
            frame = hsv2rgb(frame+amplifiedFrame);
        elseif strcmp(colorspaceForProcessing, 'rgb')
            frame = frame+amplifiedFrame;
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

