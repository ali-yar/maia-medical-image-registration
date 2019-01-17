function drawMatches(img_ref,img_mov,feat_ref,feat_mov,points)

if ~exist('points','var')
    points = 0;
end

% Create a new image showing the two images side by side.
im3 = appendimages(img_ref,img_mov);

figure('Position', [100 100 size(im3,2) size(im3,1)]);
colormap('gray');
imshow(im3);
hold on;
cols = size(img_ref,2);

if points == 1
    for i = 1:size(feat_ref,1)
        text(feat_ref(i,1), feat_ref(i,2), ['*',num2str(i)], 'Color', 'c', 'FontSize',10);
        text(feat_mov(i,1)+cols, feat_mov(i,2), ['*',num2str(i)], 'Color', 'c', 'FontSize',10);
    end
else
    for i = 1:size(feat_ref,1)
        line([feat_ref(i,1) feat_mov(i,1)+cols], ...
        [feat_ref(i,2) feat_mov(i,2)], 'Color', 'c')
    end
end

hold off;

end

