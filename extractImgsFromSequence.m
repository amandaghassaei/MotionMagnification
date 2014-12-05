function allFrames = extractImgsFromSequence(filename, verbose)

    allFiles = getAllFilesInDir(filename);
    
%      load first image
    file1 = allFiles(1);
    img1 = im2double(imread(file1{1}));
    allFrames = zeros(size(img1, 1), size(img1, 2), size(img1, 3), size(allFiles, 1));
    allFrames(:, :, :, 1) = img1(:, :, :);
    for i=2:size(allFiles, 1)
        file = allFiles(i);
        file = file{1};
        if (verbose)
            fprintf('Loading image %s, frame %i of %i\n', file, i, size(allFiles, 1));
        end
        img = im2double(imread(file));
        allFrames(:, :, :, i) = img(:, :, :);
    end
end

function fileList = getAllFilesInDir(dirName)

  dirData = dir(dirName); 
  dirIndex = [dirData.isdir];
  fileList = {dirData(~dirIndex).name}';
  if ~isempty(fileList)
      % Prepend path to files
      fileList = cellfun(@(x) fullfile(dirName,x),fileList,'UniformOutput',false);
  end
 
end