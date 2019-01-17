% clear
clear; close all; clc;

% paths
current_dir = pwd;
data_path = fullfile(current_dir,'data');
utils_path = fullfile(current_dir,'utils');
lowe_lib_path = fullfile(current_dir,'lowe');
vlfeat_lib_path = fullfile(current_dir,'vlfeat','toolbox');

% add folders to search path
addpath(genpath(data_path), genpath(utils_path), genpath("tmp"),...
    genpath(lowe_lib_path), genpath(vlfeat_lib_path));

% add VLFeat Toolbox to path
vl_setup();

% modify the system path (temporarily)
originalPATH = getenv('PATH');
if ~contains(originalPATH,lowe_lib_path)
    setenv('PATH', [originalPATH lowe_lib_path ';']);
end
