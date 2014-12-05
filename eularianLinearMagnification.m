function frames = eularianLinearMagnification(filename, frames, upperFreqRange, lowerFreqRange, alpha, lambda_c)

    fprintf('Motion magnifying video %s   \n', filename);
    [amplifiedBands, pind] = bandPassFilter_DiscreteTimeDomain(frames, upperFreqRange, lowerFreqRange, alpha, lambda_c);
    undoPyramids(frames, amplifiedBands, pind);
end
    

function [pyr, pind] = buildLaplacianPyr(frame)
    [pyr, pind] = buildLpyr(frame(:,:,1),'auto');
    pyr = repmat(pyr,[1 3]);
    [pyr(:,2),~] = buildLpyr(frame(:,:,2),'auto');
    [pyr(:,3),~] = buildLpyr(frame(:,:,3),'auto');
end

function frames = undoPyramids(frames, amplifiedBands, pind)

    for i=1:size(amplifiedBands, 3)
        frame = frames(:, :, :, i);
        
        amplifiedFrame = zeros(size(frame)); 
        amplifiedFrame(:,:,1) = reconLpyr(amplifiedBands(:,1),pind);
        amplifiedFrame(:,:,2) = reconLpyr(amplifiedBands(:,2),pind);
        amplifiedFrame(:,:,3) = reconLpyr(amplifiedBands(:,3),pind);
        
        frames(:, :, :, i) = frame + amplifiedFrame;
    end
end

function [amplifiedBands, pind] = bandPassFilter_DiscreteTimeDomain(frames, upperFreqRange, lowerFreqRange, alpha, lambda_c)

    %load first image in sequence
    [pyr, ~] = buildLaplacianPyr(frames(:,:,:,1));
    previousPyrUpperBandPass = pyr;%store pyramid for band pass filtering
    previousPyrLowerBandPass = pyr;%store pyramid for band pass filtering
    
    amplifiedBands = zeros(size(pyr, 1), size(pyr, 2), size(frames,4));
    amplifiedBands(:, :, 1) = pyr;

    for i=2:size(frames,4)
        
        progmeter(i,size(frames,4));
        
        frame = frames(:,:,:,i);
        [pyr, pind] = buildLaplacianPyr(frame);
        
        % bandpass filtering (I'm using a lowpass + highpass
%         pyrLowerBandPass = previousPyrLowerBandPass + (pyr - previousPyrLowerBandPass);%y[i] := y[i-1] + ? * (x[i] - y[i-1])
        
%         (from Wu et al) lowpass - lowpass
        pyrUpperBandPass = (1-upperFreqRange)*previousPyrUpperBandPass + upperFreqRange*pyr;
        pyrLowerBandPass = (1-lowerFreqRange)*previousPyrLowerBandPass + lowerFreqRange*pyr;
        filtered = (pyrUpperBandPass - pyrLowerBandPass);
        
        amplifiedBands(:,:,i) = amplifyMotion(pyr, frame, filtered, lambda_c, alpha, pind);
                
        previousPyrUpperBandPass = pyrUpperBandPass;
        previousPyrLowerBandPass = pyrUpperBandPass;
    end
end

function bandPassFilterContinuousTimeDomain()
    
end

function  amplifiedBand = amplifyMotion(pyr, frame, filtered, lambda_c, alpha, pind)

    ind = size(pyr,1);
    delta = lambda_c/8/(1+alpha);

    % the factor to boost alpha above the bound we have in the
    % paper. (for better visualization)
    exaggeration_factor = 2;

    % compute the representative wavelength lambda for the lowest spatial 
    % freqency band of Laplacian pyramid

    lambda = (size(frame, 1)^2 + size(frame, 2)^2).^0.5/3; % 3 is experimental constant

    for l = size(pind, 1):-1:1
      indices = ind-prod(pind(l,:))+1:ind;
      % compute modified alpha for this level
      currAlpha = lambda/delta/8 - 1;
      currAlpha = currAlpha*exaggeration_factor;

      if (l == size(pind,1) || l == 1) % ignore the highest and lowest frequency band
          filtered(indices,:) = 0;
      elseif (currAlpha > alpha)  % representative lambda exceeds lambda_c
          filtered(indices,:) = alpha*filtered(indices,:);
      else
          filtered(indices,:) = currAlpha*filtered(indices,:);
      end

      ind = ind - prod(pind(l,:));
      % go one level down on pyramid, 
      % representative lambda will reduce by factor of 2
      lambda = lambda/2; 
    end
    
    amplifiedBand = filtered;
end
