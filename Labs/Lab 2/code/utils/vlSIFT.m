function [frames, descriptors] = vlSIFT(img_path,edgethresh,octaves,levels)
%VLSIFT

% keys = {'Octaves','Levels','FirstOctave','PeakThresh','EdgeThresh', ...
%     'NormThresh','Magnif','WindowSize','Frames','Orientations','Verbose'};

% read image, convert to grayscale, convert to single precision
img = im2single(rgb2gray(imread(img_path)));

[frames, descriptors] = vl_sift(img, 'edgethresh', edgethresh, ...
    'Octaves', octaves, 'Levels', levels);

end