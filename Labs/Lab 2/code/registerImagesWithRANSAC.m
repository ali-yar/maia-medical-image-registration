% homography types
model = {'similarity', 'euclidean', 'affine', 'projective'};

% dataset folder
dataset = 'DataSet00';

img_pair = {'retina*.*', '*skin*.*'};

for i = 1:numel(img_pair)
    files = dir(fullfile(data_path,dataset,img_pair{i}));
    
    % read the pair of images
    img_ref_path = fullfile(files(1).folder,files(1).name);
    img_mov_path = fullfile(files(2).folder,files(2).name);
    img_ref = imread(fullfile(files(1).folder,files(1).name));
    img_mov = imread(fullfile(files(2).folder,files(2).name));
    
    % find the corresponding features
    [~, feat_ref, feat_mov] = match(img_ref_path, img_mov_path, 0);
    
    figure;
    sgtitle(sprintf("(RANSAC) Transforming reference image to moving image (%s)",img_pair{i}));
    subplot(3,2,1);
    imshow(img_ref);
    title("Reference image");
    subplot(3,2,2);
    imshow(img_mov);
    title("Moving image");
    
    for j = 1:numel(model)
        % compute the transformation matrix given 2 sets of feature points
        [H,nfeat_ref,nfeat_mov] = ...
            computeHomographyRANSAC(feat_ref,feat_mov,model{j},dataNormalized);
        
        % compute the reprojection error
        err = reprojectionError(nfeat_ref,nfeat_mov,H);
        err = mean(err);
        
        % transform the reference image
        if strcmp(model{j},'projective')
            tform = projective2d(H');
        else
            tform = affine2d(H');
        end
        img_transf = imwarp(img_ref,tform, ...
            'outputView',imref2d(size(img_ref)),'FillValues',160);
%         img_transf = imwarp(img_ref,tform);
        
        % overlay transformed image with moving image
        img_overlay = imfuse(img_transf,img_mov,'falsecolor','ColorChannels',[1 2 0]);
        
        % display result
        subplot(3,2,2+j);
        imshow(img_overlay);
        title(sprintf("%s transform (error=%.2f)", model{j}, err));
    end

end