function [e] = reprojectionError(A,B,H)

% B_ = transformFeatures(A, H);
% 
% e = (B_(:) - B(:)) .^ 2;
% e = sqrt(e);
% e = sum(e) / numel(B);



B_ = transformFeatures(A, H);
dist1 = sqrt(sum((B-B_).^2,2));

A_ = transformFeatures(B, inv(H));
dist2 = sqrt(sum((A-A_).^2,2));

e = dist1 + dist2;


% B_ = transformFeatures(A, H);
% 
% e = (B_ - B) .^ 2;
% e = sqrt(e);
% e = sum(e,2) / 2;

end

