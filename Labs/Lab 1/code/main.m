clear all; close all; clc;

tStart = tic;

% if need to display "metric vs iteration" plot
plotMetric = true;

% refer to affine_transform_2d_double.m for the different options
interpMode = 0;

img1_name = "brain1";
img2_name = "brain2";
factor = -1; % change to 1 if using images with inverted intensities like brain4

% moving and fixed images
Imoving = im2double(rgb2gray(imread(strcat(img1_name,'.png')))); 
Ifixed = im2double(rgb2gray(imread(strcat(img2_name,'.png'))));

% metric type
% 'ssd': ssd | 'cc': cross-correlation | 'gcc': gradient correlation
mtype = 'ssd';

% rigid registration
% 'rigid': rigid | 'affine': affine (7-params) | 'affine6params': affine (6-params)
ttype = 'rigid';

% multiresolution levels
depth = 5;

% build the pyramids in a decreasing, bottom-up order
% declare the pyramids
ImovingPyr = cell(depth);
IfixedPyr = cell(depth);
% temporary aliases
Imoving_ = Imoving;
Ifixed_ = Ifixed;
for i = 1:depth
    % add the images to their pyramids
    ImovingPyr{depth-i+1} = Imoving_;
    IfixedPyr{depth-i+1} = Ifixed_;
    % subsample
    Imoving_ = impyramid(Imoving_, 'reduce');
    Ifixed_ = impyramid(Ifixed_, 'reduce');
end

% initial variables values
switch ttype
    case 'rigid'
        params = [0 0 0];
        scale = [1 1 0.1];
    case 'affine6params'
        params = [0  0     1     0     0     1];
        scale  = [1  1 0.001 0.001 0.001 0.001];
    case 'affine'
        params = [0  0    0   1   1      0      0];
        scale  = [1  1 0.01 0.1 0.1 0.0001 0.0001];
end

% iteratively register images at different levels of the pyramid
for i = 1:depth
    fprintf("Registering pyramids at level %i:\n", i);
    Imoving_ = ImovingPyr{i};
    Ifixed_ = IfixedPyr{i};
    [Iregistered, x] = affineReg2D(Imoving_, Ifixed_, mtype, ttype, params, scale, factor, interpMode, plotMetric);
    x(1) = x(1) * 2;
    x(2) = x(2) * 2;
    params = x;
end

tElapsed = toc(tStart);

% just to invert intensities of 1 image before computing ssd if the 
% 2 images have relatively inverted intensities
if (factor == -1)
    e = sum((Iregistered(:) - Ifixed(:)).^2) / numel(Iregistered);
else
    e = sum((1-Iregistered(:) - Ifixed(:)).^2) / numel(Iregistered);
end


% Show the registration results
figure,
sgtitle(sprintf("Metric=%s | Transformation Type=%s\nDissimilarity error=%.5f | Exec=%.1fs",mtype,ttype,e,tElapsed));
subplot(2,2,1), imshow(Imoving); title(sprintf("Moving image (%s)",img1_name));
subplot(2,2,2), imshow(Ifixed); title(sprintf("Fixed image (%s)",img2_name));
subplot(2,2,3), imshow(Iregistered); title("Registered image");
if (factor == -1)
    subplot(2,2,4), imshow(imabsdiff(Ifixed,Iregistered)); title("Difference image");
else
    subplot(2,2,4), imshow(imabsdiff(Ifixed,1-Iregistered)); title("Difference image");
end

