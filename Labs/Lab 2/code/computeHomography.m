function H = computeHomography(F1,F2,model)
% computeHomography
% 
% The function find the homography matrix given a set of features and their
% correspondences.
% Features in image 1 and the corresponding features in image 2. Each of 
% the image features are placed in a Nx2 matrix. With the
% x-coordinate in the first col and y-coordinate in the second col.
% The model represents the type of transformation needed which includes
% euclidean, similarity, affine and projective transforms.
% 
% Input:
%   F1: (Nx2) feature coordinates
%   F2: (Nx2) match coordinates
%   Model: (string) type of transformation. Options: 'euclidean', 
%           'similarity, 'affine', 'projective'
% 
% Output: 
%   H: (3x3) computed homographic matrix that transform F1 into F2
% 
% Sample usage: H = computeHomography(F1,F2,'euclidean');

% total features/points
N = size(F1,1);

b = reshape(F2',[],1);

switch model
    case {'euclidean','similarity'}
    %     |x'|       |x -y  1  0|     |a|
    %     |y'|   =   |y  x  0  1|  *  |b|
    %      .               .          |c|
    %      .               .          |d|
        A = zeros(2*N,4);
        A(1:2:end,1:3) = [F1(:,1) -F1(:,2) ones(N,1)];
        A(2:2:end,logical([1,1,0,1])) = [F1(:,2) F1(:,1) ones(N,1)];
        
        % solve for x: A*x = b
        x = A \ b;
        
        if strcmp(model,'similarity')
            H = [   x(1) -x(2) x(3);
                    x(2)  x(1) x(4);
                    0     0    1    ];
        else
            ang = atan2(x(2),x(1));
            H = [   cos(ang) -sin(ang) x(3);
                    sin(ang)  cos(ang) x(4);
                    0           0      1    ];
        end

    case 'affine'
    %     |x'|       |x  y  1  0  0  0|     |a|
    %     |y'|   =   |0  0  0  x  y  1|  *  |b|
    %      .                  .             |c|
    %      .                  .             |d|
    %      .                  .             |e|
    %      .                  .             |f|
        
        A = zeros(2*N,6);
        A(1:2:end,1:3) = [F1(:,1) F1(:,2) ones(N,1)];
        A(2:2:end,4:end) = A(1:2:end-1,1:3);
        
        % solve for x: A*x = b
        x = A \ b;
        
        H = [ reshape(x,3,[])';
                0   0   1   ];

    case 'projective'
    %     |x'|       |x  y  1  0  0  0  -x'.x  -x'.y|     |a|
    %     |y'|   =   |0  0  0  x  y  1  -y'.x  -y'.y|  *  |b|
    %      .                  .                           |c|
    %      .                  .                           |d|
    %      .                  .                           |e|
    %      .                  .                           |f|
    %      .                  .                           |g|
    %      .                  .                           |h|
    
        A = zeros(2*N,8);
        A(1:2:end,1:3) = [F1(:,1) F1(:,2) ones(N,1)];
        A(1:2:end,7:end) = [-F2(:,1).*F1(:,1)  -F2(:,1).*F1(:,2)];
        A(2:2:end,4:end) = [A(1:2:end-1,1:3) -F2(:,2).*F1(:,1) -F2(:,2).*F1(:,2)];
        
        % solve for x: A*x = b
        x = A \ b;
        
        x(end+1) = 1;
        
        H = reshape(x,3,[])';
    
    case 'matrix'
        A = zeros(2*N,9);
        A(1:2:end,4:end) = [-F1(:,1) -F1(:,2) -ones(N,1) F2(:,2).*F1(:,1) F2(:,2).*F1(:,2) F2(:,2)];
        A(2:2:end,[1 2 3 7 8 9]) = [F1(:,1) F1(:,2) ones(N,1) -F2(:,1).*F1(:,1) -F2(:,1).*F1(:,2) -F2(:,1)];
        
        [U,S,V] = svd(A);
        
        x = V(:,end);
        
        H = reshape(x,3,[])';
        
end