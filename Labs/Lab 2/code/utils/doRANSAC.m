function [F,M] = doRANSAC(F,M,model)

nOutliers = 4;

s = 4;
e = 4/22; % 20%
N = 9;
v = 0.05;
% t = 5.99*v;
t = 30;

C = combnk(1:size(F,1),s);
idx = randperm(size(C,1));
idx = idx(1:N);
C = C(idx,:);

maxId = -1;

inliersSet = cell(N,1);
for i = 1:N
    % build sample of random s point pairs
    idx = C(i,:);
    F1 = F(idx,:);
    F2 = M(idx,:);
    % compute homography
    H = computeHomography(F1,F2,model);
    % compute error vector (for each data point)
    err = reprojectionError(F,M,H);
    % indices of inliers
    idxx = find(err<t);
    % add to the list
    inliersSet{i} = idxx;
    % id of sample with max inliers
    if maxId < numel(idxx) 
        maxId = i;
    end
end

idx = inliersSet{maxId};
F = F(idx,:);
M = M(idx,:);

end

