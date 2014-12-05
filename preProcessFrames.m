function frames = preProcessFrames(frames, filename, verbose)
    for i=1:size(frames, 4)
        %convert to ntsc
        frames(:,:,:,i) = rgb2ntsc(frames(:,:,:,i));
        if (verbose)
            fprintf('Preprocessing frames %s, frame %i of %i\n', filename, i, size(frames, 4));
        end
    end
end

