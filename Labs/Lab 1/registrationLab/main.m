clear all; close all; clc;

% moving and fixed images
Imoving = im2double(rgb2gray(imread('brain1.png'))); 
Ifixed = im2double(rgb2gray(imread('brain2.png')));

% if registering brain1 and brain4, use mtype='gcc', ttype='a2', depth=7

% metric type
% 'sd': ssd | 'cc': cross-correlation | 'gcc': gradient correlation
mtype = 'sd';

% rigid registration
% 'r': rigid | 'a1': affine (6-params) | 'a2': affine (7-params)
ttype = 'a1';

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
    case 'r'
        params = [0 0 0];
        scale = [1 1 0.1];
    case 'a1'
        params = [0 0 1 0 0 1];
        scale = [1 1 0.001 0.001 0.001 0.001];
    case 'a2'
        params =     [0  0   0     1   1     0      0];
        scale = [1  1 0.01 0.1 0.1 0.0001 0.0001];
end

% iteratively register images at different levels of the pyramid
for i = 1:depth
    fprintf("Registering pyramids at level %i:\n", i);
    Imoving_ = ImovingPyr{i};
    Ifixed_ = IfixedPyr{i};
    [Iregistered, x] = affineReg2D(Imoving_, Ifixed_, mtype, ttype, params, scale);
    params = x;
end

% Show the registration results
figure,
subplot(2,2,1), imshow(Imoving); title("Moving Image");
subplot(2,2,2), imshow(Ifixed); title("Fixed Image");
subplot(2,2,3), imshow(Iregistered); title("Registered Image");
subplot(2,2,4), imshow(abs(Ifixed-Iregistered)); title("Difference Image");
% uncomment below if registering brain1 and brain4
% subplot(2,2,4), imshow(abs(Ifixed-1+Iregistered)); title("Difference Image");
