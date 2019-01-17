% dataset folder
dataset = 'DataSet00';

img_pair = {'retina*.*', '*skin*.*'};

for i = 1:numel(img_pair)
    files = dir(fullfile(data_path,dataset,img_pair{i}));
    
    figure;
    for j = 1:2
        img_path = fullfile(files(j).folder,files(j).name);
        
        image = imread(img_path);
        
        % Lowe's SIFT
        [~, ~, locs] = sift(img_path, 0);
        
        % VL Feat SIFT
        edgethresh = 10; % example of changing params for vlfeat
        octaves = 4; % original implementation uses 4
        levels = 3; % original implementation uses 3
        [frames, ~] = vlSIFT(img_path,edgethresh,octaves,levels);
        perm = randperm(size(frames,2));
        frames = frames(:,perm(1:30));
%         frames = frames(:,end-min(size(perm,2),size(locs,1)):end);
%         perm = randperm(size(frames,2)) ;
%         frames = frames(:,perm(1:min(size(perm,2),size(locs,1))));
        
        plotIdx = j * 3;
        
        subplot(2,3,plotIdx-2);
        imshow(image,[]);
        title(sprintf("Image %d",j));
        
        subplot(2,3,plotIdx-1);
        imshow(image,[]);
        showkeys2(image, locs);
        title("Lowe's SIFT");
        
        subplot(2,3,plotIdx);
        imshow(image,[]);
%          vl_plotframe(frames(:,2*size(frames,2)/3:end));
        vl_plotframe(frames);
        title("VLFeat SIFT");
        
        sgtitle(sprintf("Image Pair %d",i));
    end

end
    