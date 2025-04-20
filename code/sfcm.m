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

num_iters = 100;
tol = 1e-5;
q=2;

[U, centers] = s_fcm(brainPixels,K,q,mask,gaussian_mask,num_iters,tol);

% Plot the three memberships 
figure;
for i=1:K
    subplot(1,K,i);
    label_image = zeros(size(mask));label_image(mask==1) = U(:, i);
    imagesc(label_image);
    colormap(gray);
    title(['Membership for cluster ' num2str(i)]);
    axis image;
end