clear; close all; clc;
addpath(genpath('src'));

data = load('../data/assignmentSegmentBrain.mat');

image = data.imageData;
mask = data.imageMask;
image = image .* mask;
brainPixels = double(image(mask == 1));

gaussian_mask = fspecial('gaussian', [9 9], 1);  % 1 is the standard deviation (sigma), adjust as needed

bias = double(mask);
num_iters = 100;
tol = 1e-5;
C=3;
q=2;


[U, centres] = bias_fcm(brainPixels,C,q,bias,mask,gaussian_mask,num_iters,tol);