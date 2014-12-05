function postProcessFrames(frames)

    fprintf('Post-processing frames');
    
    for i=1:size(frames, 4)
        frame = ntsc2rgb(frames(:,:,:,i)); 
        
        %clip to rgb bounds
        frame(frame > 1) = 1;
        frame(frame < 0) = 0;
        
        frames(:,:,:,i) = frame(:,:,:);
    end

end

