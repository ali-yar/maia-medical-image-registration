function [ Iregistered, M] = affineReg2D( Imoving, Ifixed )

% Example of 2D affine registration
%   Robert Martí  (robert.marti@udg.edu)
%   Based on the files from  D.Kroon University of Twente 

% clean
clear all; close all; clc;

% Read two images 
Imoving = im2double(rgb2gray(imread('brain1.png'))); 
Ifixed = im2double(rgb2gray(imread('brain2.png')));

Im = Imoving;
If = Ifixed;

% metric type
% sd: ssd | gcc: gradient correlation | cc: cross-correlation
mtype = 'sd';

% rigid registration
% r: rigid, a1: affine (6-params), a2: affine (7-params)
ttype = 'a2'; 

% Parameter scaling of the Translation and Rotation
% and initial parameters
switch ttype
    case 'r'
        x=[0 0 0];
        scale = [1 1 0.1];
    case 'a1'
        x=[0 0 1 0 0 1];
        scale = [1 1 0.001 0.001 0.001 0.001];
    case 'a2'
        x =     [0  0   0     1   1     0      0];
        scale = [1  1 0.01 0.1 0.1 0.0001 0.0001];
end

x = x ./ scale;

% optimizer  
opts = optimset('Display','iter',...
                'MaxIter',5000,...
                'TolFun', 1.0e-15,...
                'TolX', 1.0e-15,...
                'MaxFunEvals', 10000*length(x));
[x] = fminsearch(@(x)affine_registration_function(x,scale,Im,If,mtype,ttype),...
    x,opts);

% [x]=fminsearch(@(x)affine_registration_function(x,scale,Im,If,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-10,'TolX', 1.000000e-10, 'MaxFunEvals', 1000*length(x),'PlotFcns',@optimplotfval));

x= x .* scale;

% Make the affine transformation matrix
switch ttype
	case 'r'
        M = [ cos(x(3)) sin(x(3)) x(1);
             -sin(x(3)) cos(x(3)) x(2);
               0           0      1 ];
	case 'a1'
        M = [ x(3)  x(4)    x(1);
              x(5)  x(6)	x(2);
              0       0 	1  ];
    case 'a2'
        Rot = [ cos(x(3)) sin(x(3)) 0;
               -sin(x(3)) cos(x(3)) 0;
                 0           0      1 ];
        Transl = [ 1    0   x(1);
                  0    1   x(2);
                  0    0    1 ];
        Scale = [  x(4)  0    0;
                   0     x(5)  0;
                   0     0     1 ];
        ShearX = [ 1    x(6)   0;
                   0     1     0;
                   0     0     1 ];
        ShearY = [ 1     0     0;
                   x(7)  1     0;
                   0     0     1 ];
        M = Rot * Transl * Scale * ShearX * ShearY;
end
     

 % Transform the image 
Icor=affine_transform_2d_double(double(Im),double(M),0); % 3 stands for cubic interpolation

% Show the registration results
figure,
subplot(2,2,1), imshow(If);
subplot(2,2,2), imshow(Im);
subplot(2,2,3), imshow(Icor);
subplot(2,2,4), imshow(abs(If-Icor));

end

