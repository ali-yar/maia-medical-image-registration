% init the workspace
init;

doNormalization = 1;

model = 'projective';

dataset1 = 'DataSet01';

% load feature coordinates of the different images
load 'data/DataSet01/Features.mat'

% read dataset folder
files = dir(fullfile(data_path,dataset1,'*.png'));

% reference image and feature coords
img_ref = imread(fullfile(files(1).folder,files(1).name));
feat_ref =  Features(1).xy;

% moving images and feature coords
i = 4;
img_mov = imread(fullfile(files(i).folder,files(i).name));
feat_mov =  Features(i).xy;

% reduce the number of features
feat_ref = feat_ref(1:3:end,:);
feat_mov = feat_mov(1:3:end,:);

% create outliers
feat_mov([1 5 10 15],1) = feat_mov([1 5 9 15],1)/2;

% compute the homography
[new_H, new_f_ref, new_f_mov] = ...
    computeHomographyRANSAC(feat_ref,feat_mov,model,doNormalization);

% display putative matches (before outlier removal)
drawMatches(img_ref,img_mov,feat_ref,feat_mov,1);

% display correct matches (after outlier removal)
drawMatches(img_ref,img_mov,new_f_ref,new_f_mov,1);


figure;
sgtitle(sprintf("%s transform",model));
subplot(2,2,1);
imshow(img_ref);
title("Reference image");
subplot(2,2,2);
imshow(img_mov);
title("Moving image");

% ******************** BEFORE RANSAC ********************

% compute the transformation matrix given 2 sets of feature points
H = computeHomography(feat_ref,feat_mov,model);

% compute the reprojection error
err = reprojectionError(feat_ref,feat_mov,H);
err = mean(err);

% transform the reference image
if strcmp(model,'projective')
    tform = projective2d(H');
elseif strcmp(model,'matrix')
    tform = projective2d(H');
else
    tform = affine2d(H');
end
img_transf = imwarp(img_ref,tform, ...
    'outputView',imref2d(size(img_ref)),'FillValues',160);

% overlay transformed image with moving image
img_overlay = imfuse(img_transf,img_mov,'falsecolor','ColorChannels',[1 2 0]);

% display result
subplot(2,2,3);
imshow(img_overlay);
title(sprintf("Without RANSAC (error=%.2f)", err));

% ******************** AFTER RANSAC ********************

% compute the reprojection error
err = reprojectionError(new_f_ref,new_f_mov,new_H);
err = mean(err);

% transform the reference image
if strcmp(model,'projective')
    tform = projective2d(new_H');
elseif strcmp(model,'matrix')
    tform = projective2d(new_H');
else
    tform = affine2d(new_H');
end
img_transf = imwarp(img_ref,tform, ...
    'outputView',imref2d(size(img_ref)),'FillValues',160);

% overlay transformed image with moving image
img_overlay = imfuse(img_transf,img_mov,'falsecolor','ColorChannels',[1 2 0]);

% display result
subplot(2,2,4);
imshow(img_overlay);
title(sprintf("With RANSAC (error=%.2f)", err));











