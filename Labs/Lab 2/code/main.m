% init the workspace
init;

% choose if data points should be normalized (applicable only for scenario 3)
dataNormalized = 1;

% choose a scenario to run 
scenario = 1; % 1, 2 or 3

switch scenario
    case 1 % Test Lowe’s SIFT vs Third Party Implementation
        experimentSIFT;
    case 2 % Register Image Pairs Estimating Homography
        registerImages;
    case 3 % Improving the Registration Accuracy with RANSAC
        registerImagesWithRANSAC;
        % if the variable "dataNormalized" is set to 1, then data 
        % normalization is applied.
end

% clean
delete("tmp*.pgm");
delete("tmp*.key");