img = load('data/assignmentImageDenoising_chestCT.mat');
img = img.imageChestCT;
img = double(img);
img = img - min(img(:));
img = img / max(img(:));

range = max(img(:)) - min(img(:));
sigma = 0.1 * range;
noise = sigma * randn(size(img));
noisy_img = img + noise;

% Clip values to maintain valid intensity range
noisy_img(noisy_img < 0) = 0;
noisy_img(noisy_img > 1) = 1;

learned_D = load('results/q4/D_08.mat');

% compute an optimal estimate of the denoised image using this learned dictionary

X = get_high_variance_patches(noisy_img, 0);

R = rand(64, size(X, 2));
params = struct();
params.lambda = 0.1;
params.convergence_threshold = 1e-6;
params.lr = 0.01;
params.max_iter = 10;
params.p = 0.8;
params.cap = 10;

R = update_R(X, R, learned_D.D_08, params);
X_new = learned_D.D_08 * R;

% Reconstruct the image from the patches
denoised_img = reconstruct_image(X_new, size(noisy_img));

% Clip values to maintain valid intensity range
denoised_img(denoised_img < 0) = 0;
denoised_img(denoised_img > 1) = 1;

% Display the denoised image
figure;
imshow(denoised_img);

% Save the denoised image as a .png file
saveas(gcf, 'results/q4/denoised_image_q4_c.png');

% Display original and noisy images
figure;
subplot(1,3,1); imshow(img, []); title('Original Chest-CT Image');
subplot(1,3,2); imshow(noisy_img, []); title('Noisy Chest-CT Image');
subplot(1,3,3); imshow(denoised_img, []); title('Denoised Chest-CT Image');

% Save the figure as a .png file
saveas(gcf, 'results/q4/original_noisy_denoised_images.png');

% Plot the loss vs iteration which is stored in the workspace as loss_q4c
figure;
plot(losses_q4c);
title('Loss vs Iteration');
xlabel('Iteration');
ylabel('Loss');
saveas(gcf, 'results/q4/loss_vs_iter_q4c.png');