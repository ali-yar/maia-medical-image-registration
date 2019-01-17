function [dataNormalized,T] = normalizeData(data)
% 
% Input:
%   data: (Nx2)
% 
% Output:
%   dataNormalized: (Nx2)
%   T: (3x3)
% 
% Reference(s): 
%   https://www.uio.no/studier/emner/matnat/its/UNIK4690/v16/forelesninger/
%   http://cmp.felk.cvut.cz/cmp/courses/Y33ROV/Y33ROV_ZS20092010/lab2/lab2.html
% 

% mean point (centroid)
meanPoint = mean(data);

% center data around the origin
dataNormalized = data - meanPoint;

% scaling factor to make average distance from the origin is sqrt(2)
s = sqrt(2) / mean(sqrt(sum(dataNormalized.^2,2)));

% scale data
dataNormalized = s * dataNormalized;

% normalization matrix
T = diag([s s 1]);
T(1:2,3) = -s * meanPoint;

% % verify that the average distance is sqrt(2)
% tot_dist = 0;
% for i = 1:size(dataNormalized,1)
%     tot_dist = tot_dist + norm(dataNormalized(i,:));
% end
% avg_dist = tot_dist / size(dataNormalized,1);
% assert(avg_dist - sqrt(2)<100*eps)

end
