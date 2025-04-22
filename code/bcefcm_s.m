clear; close all; clc;
addpath(genpath('src'));

data = load('../data/assignmentSegmentBrain.mat');

image = data.imageData;
mask = data.imageMask;
image = image .* mask;
brainPixels = double(image(mask == 1));

K=3;
[label_vector, means] = kmeans_estimate(brainPixels, K, 25, 1e-4);

mask_size = 9;
sigma = 2.25;

% Generate 1D Gaussian kernel
g_kernel_1d = fspecial('gaussian', [mask_size 1], sigma);

% Create 2D Gaussian kernel by outer product
gaussian_mask = g_kernel_1d * g_kernel_1d';

% Normalize to sum to 1
gaussian_mask = gaussian_mask / sum(gaussian_mask(:));

bias = double(mask);
num_iters = 100;
tol = 1e-5;
q=2;
lambdas = [1/3, 1/3, 1/3]; % embedded
alpha = 5e-3; % regularisation

[memberships, centres, bias_field] = bias_fcm_s(brainPixels,K,q,bias,mask,gaussian_mask,means,num_iters,tol,lambdas,alpha);