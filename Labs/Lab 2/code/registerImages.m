% homography types
model = {'similarity', 'euclidean', 'affine', 'projective'};

% dataset folder
dataset0 = 'DataSet00';
dataset1 = 'DataSet01';

% Dataset01

% load feature coordinates of the different images
load 'data/DataSet01/Features.mat'

% read dataset folder
files = dir(fullfile(data_path,dataset1,'*.png'));

% reference image and feature coords
img_ref = imread(fullfile(files(1).folder,files(1).name));
feat_ref =  Features(1).xy;

for i = 2:numel(files)
    % moving images and feature coords
    img_mov = imread(fullfile(files(i).folder,files(i).name));
    feat_mov =  Features(i).xy;
    
    figure;
    sgtitle(sprintf("Transforming reference image to moving image %d",i-1));
    subplot(3,2,1);
    imshow(img_ref);
    title("Reference image");
    subplot(3,2,2);
    imshow(img_mov);
    title("Moving image");
    
    for j = 1:numel(model)
        % compute the transformation matrix given 2 sets of feature points
        H = computeHomography(feat_ref,feat_mov,model{j});
        
        % compute the reprojection error
        err = reprojectionError(feat_ref,feat_mov,H);
        err = mean(err);
        
        % transform the reference image
        if strcmp(model{j},'projective')
            tform = projective2d(H');
        else
            tform = affine2d(H');
        end
        img_transf = imwarp(img_ref,tform, ...
            'outputView',imref2d(size(img_ref)),'FillValues',160);
        
        % overlay transformed image with moving image
        img_overlay = imfuse(img_transf,img_mov,'falsecolor','ColorChannels',[1 2 0]);
        
        % display result
        subplot(3,2,2+j);
        imshow(img_overlay);
        title(sprintf("%s transform (error=%.2f)", model{j}, err));
    end

    
end


% Dataset00

img_pair = {'retina*.*', '*skin*.*'};

for i = 1:numel(img_pair)
    files = dir(fullfile(data_path,dataset0,img_pair{i}));
    
    % read the pair of images
    img_ref_path = fullfile(files(1).folder,files(1).name);
    img_mov_path = fullfile(files(2).folder,files(2).name);
    img_ref = imread(fullfile(files(1).folder,files(1).name));
    img_mov = imread(fullfile(files(2).folder,files(2).name));
    
    % find the corresponding features
    [~, feat_ref, feat_mov] = match(img_ref_path, img_mov_path, 0);
    
    figure;
    sgtitle(sprintf("Transforming reference image to moving image (%s)",img_pair{i}));
    subplot(3,2,1);
    imshow(img_ref);
    title("Reference image");
    subplot(3,2,2);
    imshow(img_mov);
    title("Moving image");
    
    for j = 1:numel(model)
        % compute the transformation matrix given 2 sets of feature points
        H = computeHomography(feat_ref,feat_mov,model{j});
        
        % compute the reprojection error
        err = reprojectionError(feat_ref,feat_mov,H);
        err = mean(err);
        
        % transform the reference image
        if strcmp(model{j},'projective')
            tform = projective2d(H');
        else
            tform = affine2d(H');
        end
        img_transf = imwarp(img_ref,tform, ...
            'outputView',imref2d(size(img_ref)),'FillValues',160);
        
        % overlay transformed image with moving image
        img_overlay = imfuse(img_transf,img_mov,'falsecolor','ColorChannels',[1 2 0]);
        
        % display result
        subplot(3,2,2+j);
        imshow(img_overlay);
        title(sprintf("%s transform (error=%.2f)", model{j}, err));
    end

end
    

%
% for i = 2:numel(files)
%     % moving images and feature coords
%     img_mov = imread(fullfile(files(i).folder,files(i).name));
%     feat_mov =  Features(i).xy;
%     
%     figure;
%     sgtitle(sprintf("Testing homographies on features with moving image %d",i-1));
% 
%     subplot(3,2,1);
%     imshow(img_ref); hold on;
%     plot(feat_ref(:,1), feat_ref(:,2), '*'); hold off;
%     title("Reference image");
% 
%     subplot(3,2,2);
%     imshow(img_mov); hold on;
%     plot(feat_mov(:,1), feat_mov(:,2), '*'); hold off;
%     title("Ground-truth transform");
%     
%     for j = 1:4
%         H = computeHomography(feat_ref,feat_mov,model{j});
%         feat_transf = transformFeatures(feat_ref, H);
%         
%         subplot(3,2,2+j);
%         imshow(img_mov); hold on;
%         plot(feat_transf(:,1), feat_transf(:,2), 'r*'); hold off;
%         title(sprintf("%s transform",model{j}));
%     end
%     
% end