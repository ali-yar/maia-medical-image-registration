function [ Iregistered, M] = affineReg2D( Imoving, Ifixed )
%Example of 2D affine registration
%   Robert Martí  (robert.marti@udg.edu)
%   Based on the files from  D.Kroon University of Twente 

% clean
clear all; close all; clc;

% Read two images 
Imoving=im2double(rgb2gray(imread('brain1.png'))); 
Ifixed=im2double(rgb2gray(imread('brain2.png')));

Im=Imoving;
If=Ifixed;

mtype = 'cc'; % metric type: sd: ssd gcc: gradient correlation; cc: cross-correlation
ttype = 'r'; % rigid registration, options: r: rigid, a: affine

% Parameter scaling of the Translation and Rotation
% and initial parameters
switch ttype
    case 'r'
        x=[0 0 0];
end

scale = [1 1 0.1];

x=x./scale;
    
  %optimizer  
[x]=fminsearch(@(x)affine_registration_function(x,scale,Im,If,mtype,ttype),...
    x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-10,'TolX',...
    1.000000e-10, 'MaxFunEvals', 1000*length(x)));

% [x]=fminsearch(@(x)affine_registration_function(x,scale,Im,If,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-10,'TolX', 1.000000e-10, 'MaxFunEvals', 1000*length(x),'PlotFcns',@optimplotfval));

x=x.*scale;

switch ttype
	case 'r'
        % Make the affine transformation matrix
         M=[ cos(x(3)) sin(x(3)) x(1);
            -sin(x(3)) cos(x(3)) x(2);
                0           0      1 ];
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

