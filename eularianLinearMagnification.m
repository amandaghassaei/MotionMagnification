function frames = eularianLinearMagnification(frames, upperFreqRange, lowerFreqRange, alpha, lambda_c)

    [pyrs, pind] = buildLaplacianPyrs(frames);
    pyrs = bandPassFilter_DiscreteTimeDomain(pyrs, upperFreqRange, lowerFreqRange);
    pyrs = amplify(pyrs, size(frames, 2), size(frames, 1), lambda_c, alpha, pind);
    frames = reconstructFrames(frames, pyrs, pind);
end
    

function [pyr, pind] = buildLaplacianPyr(frame)
    [pyr, pind] = buildLpyr(frame(:,:,1),'auto');
    pyr = repmat(pyr,[1 3]);
    [pyr(:,2),~] = buildLpyr(frame(:,:,2),'auto');
    [pyr(:,3),~] = buildLpyr(frame(:,:,3),'auto');
end

function [pyrs, pind] = buildLaplacianPyrs(frames)

    fprintf('Building pyramids   \n');
    [pyr, pind] = buildLaplacianPyr(frames(:,:,:,1));
    pyrs = zeros(size(pyr, 1), size(pyr, 2), size(frames,4));
    pyrs(:,:,1) = pyr;
    
    for i=2:size(pyrs, 3)
        [pyr, pind] = buildLaplacianPyr(frames(:,:,:,i));
        pyrs(:,:,i) = pyr;
        progmeter(i, size(pyrs, 3));
    end
    
end

function frames = reconstructFrames(frames, pyrs, pind)

    fprintf('Reconstructing frames   \n');
    for i=1:size(pyrs, 3)
        
        progmeter(i, size(pyrs, 3));
        frame = frames(:, :, :, i);

        reconstructedFrame = zeros(size(frame)); 
        reconstructedFrame(:,:,1) = reconLpyr(pyrs(:,1,i),pind);
        reconstructedFrame(:,:,2) = reconLpyr(pyrs(:,2,i),pind);
        reconstructedFrame(:,:,3) = reconLpyr(pyrs(:,3,i),pind);
        
        frames(:, :, :, i) = reconstructedFrame;
    end
    
    frames(:,:,:,1) = zeros(size(reconstructedFrame));
end

function filteredBands = bandPassFilter_DiscreteTimeDomain(pyrs, upperFreqRange, lowerFreqRange)
    
    fprintf('Temporal filtering   \n');
    filteredBands = pyrs;
    
    firstFrame = pyrs(:,:,1);
    previousPyrUpperBandPass = firstFrame;%store last upper band val
    previousPyrLowerBandPass = firstFrame;%store last lower band val

    for i=2:size(pyrs,3)
        
        progmeter(i,size(pyrs,3));
        pyr = pyrs(:,:,i);
             
        % bandpass filtering (I'm using a lowpass + highpass
%         pyrLowerBandPass = previousPyrLowerBandPass + (pyr - previousPyrLowerBandPass);%y[i] := y[i-1] + ? * (x[i] - y[i-1])
        
%         (from Wu et al) lowpass - lowpass
        pyrUpperBandPass = (1-upperFreqRange)*previousPyrUpperBandPass + upperFreqRange*pyr;
        pyrLowerBandPass = (1-lowerFreqRange)*previousPyrLowerBandPass + lowerFreqRange*pyr;
        filteredBands(:, :, i) = (pyrUpperBandPass - pyrLowerBandPass);
        
        previousPyrUpperBandPass = pyrUpperBandPass;
        previousPyrLowerBandPass = pyrUpperBandPass;
    end
end

function bandPassFilterContinuousTimeDomain()
    
end

function  pyrs = amplify(pyrs, frameWidth, frameHeight, lambda_c, alpha, pind)

    for i=1:size(pyrs, 3)
        
        pyr = pyrs(:,:,i);
        ind = size(pyr,1);

        delta = lambda_c/8/(1+alpha);

        % the factor to boost alpha above the bound we have in the
        % paper. (for better visualization)
        exaggeration_factor = 2;

        % compute the representative wavelength lambda for the lowest spatial 
        % freqency band of Laplacian pyramid

        lambda = (frameWidth^2 + frameHeight^2).^0.5/3; % 3 is experimental constant

        for l = size(pind, 1):-1:1
          indices = ind-prod(pind(l,:))+1:ind;
          % compute modified alpha for this level
          currAlpha = lambda/delta/8 - 1;
          currAlpha = currAlpha*exaggeration_factor;

          if (l == size(pind, 1) || l == 1) % ignore the highest and lowest frequency band
              pyr(indices,:) = 0;
          elseif (currAlpha > alpha)  % representative lambda exceeds lambda_c
              pyr(indices,:) = alpha*pyr(indices,:);
          else
              pyr(indices,:) = currAlpha*pyr(indices,:);
          end

          ind = ind - prod(pind(l,:));
          % go one level down on pyramid, 
          % representative lambda will reduce by factor of 2
          lambda = lambda/2; 
        end
    end
end

function  pyrs = amplifyMotion(pyrs, frameWidth, frameHeight, lambda_c, alpha, pind)

    for i=1:size(pyrs, 3)

        pyr = pyrs(:,:,i);
        
        currentIndex = size(pyr,1);
        delta = lambda_c/8/(1+alpha);

        % the factor to boost alpha above the bound we have in the
        % paper. (for better visualization)
        exaggeration_factor = 2;

        % compute the representative wavelength lambda for the lowest spatial 
        % freqency band of Laplacian pyramid

        lambda = (frameWidth^2 + frameHeight^2).^0.5/3; % 3 is experimental constant

        for l = size(pind, 1)-1:1
          indices = totalPyramidPixels-prod(pind(l,:))+1:currentIndex;
          
          % compute modified alpha for this level
          currAlpha = lambda/delta/8 - 1;
          currAlpha = currAlpha*exaggeration_factor;

          if (l == size(pind, 1) || l == 1) % ignore the highest and lowest frequency band
              pyr(indices,:) = 0;
          elseif (currAlpha > alpha)  % representative lambda exceeds lambda_c
              pyr(indices,:) = alpha*pyr(indices,:);
          else
              pyr(indices,:) = currAlpha*pyr(indices,:);
          end

          currentIndex = currentIndex - prod(pind(l,:));
          % go one level down on pyramid, 
          % representative lambda will reduce by factor of 2
          lambda = lambda/2; 
        end

        pyrs(:, :, i) = pyr;
        
    end
end
