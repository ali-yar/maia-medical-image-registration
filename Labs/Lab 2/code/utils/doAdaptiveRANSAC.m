function [F,M] = doAdaptiveRANSAC(F,M,model)

N = Inf; % total tests
sample_count = 0;
e = 1.0; % proportion of outliers
p = 0.99; % probability of success that at least 1 test yields no outliers
t = 20; % threshold

total_features = size(F,1);

s = 4;

% create different combinations of 's' feature points
C = combnk(1:total_features,s);
idx = randperm(size(C,1));
C = C(idx,:);

max_inliers = 0;
Sin_idx = zeros(total_features,1); % set of inliers (indices)

while N > sample_count
    % build sample of random 's' point pairs
    id = C(sample_count+1,:);
    F1 = F(id,:);
    F2 = M(id,:);
    % compute homography
    H = computeHomography(F1,F2,model);
    % compute error vector (for each data point)
    err = reprojectionError(F,M,H);
    % indices of inliers
    idx = err < t;
    % total inliers
    total_inliers = sum(idx);
    % update best inlier set
    if total_inliers > max_inliers
        max_inliers = total_inliers;
        Sin_idx = idx;
    end
    % proportion of outliers
    e_ = 1 - (total_inliers / total_features);
    % update parameters
    if e_ < e
        e = e_;
        N = ceil(log(1-p) / log(1-(1-e)^s));
    end
    sample_count = sample_count + 1;
end

% retrieve inliers from feature vectors given their indices
F = F(Sin_idx,:);
M = M(Sin_idx,:);

end

