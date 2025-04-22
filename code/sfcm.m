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

[memberships, centres] = s_fcm(brainPixels,K,q,mask,gaussian_mask,num_iters,tol);

label_image = zeros(size(mask));
final_label_image = zeros(size(mask));

figure;
for i=1:3
    if abs(centres(i)-0.22)<0.1
        prt = 'CSF';
        label_image(mask==1) = 1*memberships(:, i);
        final_label_image = final_label_image + label_image;
    elseif abs(centres(i)-0.62)<0.1
        prt = 'White matter';
        label_image(mask==1) = 3*memberships(:, i);
        final_label_image = final_label_image + label_image;
    else
        prt = 'Gray matter';
        label_image(mask==1) = 2*memberships(:, i);
        final_label_image = final_label_image + label_image;
    end
    subplot(1,3,i);
    label_image = zeros(size(mask));label_image(mask==1) = memberships(:, i);
    imagesc(label_image);
    colormap(gray);
    title([prt ' Membership']);
    axis image;
end
saveas(gcf, '../results/mri/sfcm/memberships.png');

figure;
imshow(final_label_image, []);
title('Final label image (in grayscale)');
saveas(gcf, '../results/mri/sfcm/grayscale_label.png');

figure();
imagesc(final_label_image.*mask);
colormap(jet(4));
colorbar('Ticks', 1:3, ...
         'TickLabels', {'Cluster 1', 'Cluster 2', 'Cluster 3'});
axis off;
title('Final Segmentation');
axis off;
title('Final label image (color)');
saveas(gcf, '../results/mri/sfcm/color_label.png');
