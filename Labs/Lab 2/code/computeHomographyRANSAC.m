function [H,FeatsIn,MatchesIn] = ...
    computeHomographyRANSAC(Feats,Matches,model,dataNormalized)
% 
% Input:
%   Feats: (Nx2) feature coordinates
%   Matches: (Nx2) match coordinates
%   model: (string) type of transformation. Options: 'euclidean', 
%           'similarity, 'affine', 'projective'
%   dataNormalized: (boolean) normalize inlier features
% 
% Output: 
%   H: (3x3) computed homography
%   FeatsIn: (Mx2) coordinates of inliers 
%   MatchesIn: (Mx2) coordinates of inliers' matches
% 
% Note:
%   M is < or = N
% 
% Sample usage:
%   H = computeHomographyRANSAC(F1,F2,'euclidean');

if ~exist('dataNormalized','var')
    dataNormalized = 0;
end

% remove outliers
[FeatsIn,MatchesIn] = findInliersFromRANSAC(Feats,Matches,model);

if dataNormalized == true
    % normalize inlier data
    [FeatsInNormalized,Tf] = normalizeData(FeatsIn);
    [MatchesInNormalized,Tm] = normalizeData(MatchesIn);
    % compute homography 
    H = computeHomography(FeatsInNormalized,MatchesInNormalized,model);
    % denormalize to obtain final homography
    H = inv(Tm) * H * Tf;
else
    % compute final homography 
    H = computeHomography(FeatsIn,MatchesIn,model);
end

end
