clear; close all; clc;
addpath(genpath('src'));

% data = load('../data/assignmentSegmentBrain.mat');
% 
% image = data.imageData;
% mask = data.imageMask;

image = im2double(imread("coins.png"));
mask = ones(size(image));

image = image .* mask;
brainPixels = double(image(mask == 1));

K=2;
[label_vector, means] = kmeans_estimate(brainPixels, K, 25, 1e-4);
fprintf('Initial cluster means: %.2f, %.2f\n', means(1), means(2));
% Reshape labels back to image
label_image = zeros(size(mask));
label_image(mask == 1) = label_vector;

figure();
imshow(label_image,[]);
title('Initial Estimate of Labels')
saveas(gcf, '../results/coins/bcfcm/initial_labels.png');
mask_size = 9;
sigma = 2.25;

% Generate 1D Gaussian kernel
g_kernel_1d = fspecial('gaussian', [mask_size 1], sigma);

% Create 2D Gaussian kernel by outer product
gaussian_mask = g_kernel_1d * g_kernel_1d';

% Normalize to sum to 1
gaussian_mask = gaussian_mask / sum(gaussian_mask(:));

% Show W
% figure;
% imagesc(gaussian_mask);
% title('Gaussian Weight Mask');
% colormap gray;
% axis off;
% saveas(gcf, '../results/mri/bcfcm/gaussian_weights.png');

bias = double(mask);
num_iters = 10;
tol = 1e-5;
q=2;


[memberships, centres, bias_field] = bias_fcm(brainPixels,K,q,bias,mask,gaussian_mask,means,num_iters,tol);

label_image = zeros(size(mask));
final_label_image = zeros(size(mask));

% figure;
% for i=1:3
%     if i==1
%         prt = 'CSF';
%         label_image(mask==1) = centres(i)*memberships(:, i);
%         final_label_image = final_label_image + label_image;
%     elseif i==3
%         prt = 'White matter';
%         label_image(mask==1) = centres(i)*memberships(:, i);
%         final_label_image = final_label_image + label_image;
%     else
%         prt = 'Gray matter';
%         label_image(mask==1) = centres(i)*memberships(:, i);
%         final_label_image = final_label_image + label_image;
%     end
%     subplot(1,3,i);
%     label_image = zeros(size(mask));label_image(mask==1) = memberships(:, i);
%     imagesc(label_image);
%     colormap(gray);
%     title([prt ' Membership']);
%     axis image;
% end
% saveas(gcf, '../results/mri/bcfcm/memberships.png');
% 
% figure;
% imshow(final_label_image, []);
% title('Final label image (in grayscale)');
% saveas(gcf, '../results/mri/bcfcm/grayscale_label.png');
% 
% figure();
% imagesc(final_label_image.*mask);
% colormap(jet(4));
% colorbar('Ticks', 1:3, ...
%          'TickLabels', {'Cluster 1', 'Cluster 2', 'Cluster 3'});
% axis off;
% title('Final Segmentation');
% axis off;
% title('Final label image (color)');
% saveas(gcf, '../results/mri/bcfcm/color_label.png');
% 
% figure; imshow(double(mask)); title('Initial bias estimate')
% saveas(gcf, '../results/mri/bcfcm/init_bias.png')
% figure; label_bias = zeros(size(mask)); label_bias(mask==1) = bias_field;imshow(label_bias); title('Bias field')
% saveas(gcf, '../results/mri/bcfcm/bias_field.png')
% brain_pix = brainPixels./bias_field;
% figure; label_finale = zeros(size(mask)); label_finale(mask==1) = brain_pix;imshow(label_finale, []); title('Bias corrected Image')
% saveas(gcf, '../results/mri/bcfcm/bias_corrected.png')

figure;
for i=1:2
    if i==1
        prt = 'Background';
        label_image(mask==1) = centres(i)*memberships(:, i);
        final_label_image = final_label_image + label_image;
    else
        prt = 'Coins';
        label_image(mask==1) = centres(i)*memberships(:, i);
        final_label_image = final_label_image + label_image;
    end
    subplot(1,2,i);
    label_image = zeros(size(mask));label_image(mask==1) = memberships(:, i);
    imagesc(label_image);
    colormap(gray);
    title([prt ' Membership']);
    axis image;
end
saveas(gcf, '../results/coins/bcfcm/memberships.png');

figure;
imshow(final_label_image, []);
title('Final label image (in grayscale)');
saveas(gcf, '../results/coins/bcfcm/grayscale_label.png');

figure();
imagesc(final_label_image.*mask);
colormap(jet(2));
colorbar('Ticks', 1:2, ...
         'TickLabels', {'Cluster 1', 'Cluster 2'});
axis off;
title('Final Segmentation');
axis off;
title('Final label image (color)');
saveas(gcf, '../results/coins/bcfcm/color_label.png');

figure; label_bias = zeros(size(mask)); label_bias(mask==1) = bias_field;imshow(label_bias); title('Bias field')
saveas(gcf, '../results/coins/bcfcm/bias_field.png')
brain_pix = brainPixels./bias_field;
figure; label_finale = zeros(size(mask)); label_finale(mask==1) = brain_pix;imshow(label_finale, []); title('Bias corrected Image')
saveas(gcf, '../results/coins/bcfcm/bias_corrected.png')