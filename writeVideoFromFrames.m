function writeVideoFromFrames(filename, frameRate, frames, verbose)

    fprintf('Writing video to %s   \n', filename);
    output = VideoWriter(filename);
    output.FrameRate = frameRate;
    open(output);
    
    for i=1:size(frames, 4)
        writeVideo(output,im2uint8(frames(:,:,:,i)));
        if (verbose)
            fprintf('Writing video %s, frame %i of %i\n', filename, i, size(frames, 4));
        else
            progmeter(i, size(frames, 4));
        end
    end
        
    close(output);
end