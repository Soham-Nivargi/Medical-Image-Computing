clc; clear; close all;

mat_file = load('../data/assignmentSegmentBrainGmmEmMrf.mat');

imageData = mat_file.imageData;
imageData = imageData .* mat_file.imageMask;
imageMask = mat_file.imageMask;

K=3;

brainPixels = double(imageData(imageMask == 1));  % Vector of brain intensities

[label_vector, means] = kmeans_estimate(brainPixels, K, 25, 1e-4);

fprintf('Initial cluster means: %.2f, %.2f, %.2f\n', means(1), means(2), means(3));
% Reshape labels back to image
label_image = zeros(size(imageMask));
label_image(imageMask == 1) = label_vector;

% % figure();
% % imshow(label_image,[]);
% % title('Initial Estimate of Labels')
% Compute initial class standard deviations
stds = zeros(1,K);
for k = 1:K
    cluster_points = brainPixels(label_vector == k);
    stds(k) = std(cluster_points); % Standard deviation for each cluster
end
fprintf('Initial class standard deviations: %.2f, %.2f, %.2f\n', stds(1), stds(2), stds(3));

% beta_vaues = [0, 0.1, 0.25, 0.5, 1, 1.5, 2, 3, 5, 10, 20, 50, 100, 200];
beta_vaues = [3];
num_iters_em = 100;
num_pixels = length(label_vector);

% Store pixel positions for neighbor processing
[rows, cols] = size(imageMask);
[r_coords, c_coords] = find(imageMask == 1);

tolerance_em = 1e-3;
for beta=beta_vaues
    [final_label_image,final_means,final_stds, final_mem, log_posterior] = em_algorithm(beta, num_iters_em, tolerance_em, means, stds, ...
            num_pixels, K, brainPixels, imageMask, rows, cols, label_vector, r_coords, c_coords);
    
    
    figure();
    imshow(final_label_image, []);
    title(sprintf('Label image, beta = %.2f', beta));
    saveas(gcf, ['Results/Label_estimates_for_different_betas/', num2str(beta), '/labels.png']);
    
    white_matter_mem = zeros(size(imageMask));
    white_matter_mem(imageMask == 1) = final_mem(:,3);
    
    figure();
    imshow(white_matter_mem);
    title(sprintf('White matter membership, beta = %.2f', beta));
    saveas(gcf, ['Results/Label_estimates_for_different_betas/', num2str(beta), '/white_matter.png']);
    
    gray_matter_mem = zeros(size(imageMask));
    gray_matter_mem(imageMask == 1) = final_mem(:,2);
    figure();
    imshow(gray_matter_mem);
    title(sprintf('Gray matter membership, beta = %.2f', beta));
    saveas(gcf, ['Results/Label_estimates_for_different_betas/', num2str(beta), '/gray_matter.png']);
    
    cerbro = zeros(size(imageMask));
    cerbro(imageMask == 1) = final_mem(:,1);
    
    figure();
    imshow(cerbro);
    title(sprintf('CSF membership, beta = %.2f', beta));
    saveas(gcf, ['Results/Label_estimates_for_different_betas/', num2str(beta), '/csf.png']);
end
