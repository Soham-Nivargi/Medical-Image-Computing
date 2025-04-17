clear; close all; clc;
addpath(genpath('src'));

data = load('../data/assignmentSegmentBrain.mat');

image = data.imageData;
mask = data.imageMask;
image = image .* mask;
brainPixels = double(image(mask == 1));

K=3;
[label_vector, means] = kmeans_estimate(brainPixels, K, 25, 1e-4);

gaussian_mask = fspecial('gaussian', [9 9], 1);

bias = double(mask);
num_iters = 100;
tol = 1e-5;
q=2;


[U, centres] = bias_fcm(brainPixels,K,q,bias,mask,gaussian_mask,label_vector,means,num_iters,tol);