folder_path = '/Users/shreyasgrampurohit/Documents/College_Academia/Sem8/mic/Medical-Image-Computing/data/anatomicalSegmentations/anatomicalSegmentations';
U_pca = perform_pca_on_segmentations(folder_path);
[U_kpca, sigma, eigenvalues, data] = perform_kernel_pca_on_segmentations(folder_path);

distorted_folder = '/Users/shreyasgrampurohit/Documents/College_Academia/Sem8/mic/Medical-Image-Computing/data/anatomicalSegmentationsDistorted/anatomicalSegmentationsDistorted';
distorted_files = dir(fullfile(distorted_folder, '*.png'));
num_distorted = length(distorted_files);

output_pdf = 'comparison_results.pdf';
output_pdf_2 = 'comparison_results_kpca.pdf';

for i = 1:num_distorted
    distorted_img = imread(fullfile(distorted_folder, distorted_files(i).name));
    if size(distorted_img, 3) == 3
        distorted_img = rgb2gray(distorted_img);
    end
    distorted_img = im2double(imresize(distorted_img, [64, 64]));

    mean_img = mean(U_pca, 2);
    denoised_img = denoise_using_pca(distorted_img, mean_img, U_pca);

    fig = figure('Visible', 'off');
    subplot(1, 2, 1);
    imshow(distorted_img, []);
    title('Distorted Image');
    subplot(1, 2, 2);
    imshow(denoised_img, []);
    title('Denoised Image');

    exportgraphics(fig, output_pdf, 'Append', true);
    close(fig);
end

disp(['Comparison results exported to ', output_pdf]);

for i = 1:num_distorted
    distorted_img = imread(fullfile(distorted_folder, distorted_files(i).name));
    if size(distorted_img, 3) == 3
        distorted_img = rgb2gray(distorted_img);
    end
    distorted_img = im2double(imresize(distorted_img, [64, 64]));

    x = distorted_img(:);
    Kx = exp(-pdist2(x', data').^2 / (2 * sigma^2));

    k=3;
    x_proj = (Kx * U_kpca(:, 1:k)) ./ sqrt(eigenvalues(1:k));

    denoised_img_kpca = kernel_pca_preimage(x_proj, data, sigma, U_kpca(:, 1:k), eigenvalues(1:k), k);

    fig = figure('Visible', 'off');
    subplot(1, 2, 1);
    imshow(distorted_img, []);
    title('Distorted Image');
    subplot(1, 2, 2);
    imshow(denoised_img_kpca, []);
    title('Denoised Image (Kernel PCA)');

    exportgraphics(fig, output_pdf_2, 'Append', true);
    close(fig);
end

disp(['Comparison results exported to ', output_pdf_2]);

function U_pca = perform_pca_on_segmentations(folderPath)
    targetSize = [64, 64];
    imageFiles = dir(fullfile(folderPath, '*.png'));
    numImages = length(imageFiles);
    imageMatrix = zeros(prod(targetSize), numImages);

    for i = 1:numImages
        img = imread(fullfile(folderPath, imageFiles(i).name));
        if size(img, 3) == 3
            img = rgb2gray(img);
        end
        img = im2double(imresize(img, targetSize));
        imageMatrix(:, i) = img(:);
    end

    meanImageVec = mean(imageMatrix, 2);
    centeredMatrix = imageMatrix - meanImageVec;
    [U, S, ~] = svd(centeredMatrix, 'econ');
    U_pca = U;
end

function [U_kpca, sigma, eigenvalues, data] = perform_kernel_pca_on_segmentations(folderPath)
    files = dir(fullfile(folderPath, '*.png'));
    n = length(files);
    data = zeros(64*64, n);

    for i = 1:n
        img = imread(fullfile(folderPath, files(i).name));
        img = im2double(imresize(img, [64 64]));
        data(:, i) = img(:);
    end

    pairwise_dists = pdist2(data', data');
    upper_tri = triu(pairwise_dists, 1);
    nonzero_dists = upper_tri(upper_tri > 0);
    sigma = median(nonzero_dists);

    K = zeros(n, n);
    for i = 1:n
        for j = 1:n
            diff = data(:, i) - data(:, j);
            K(i, j) = exp(-norm(diff)^2 / (2 * sigma^2));
        end
    end

    N = size(K, 1);
    oneN = ones(N, N) / N;
    Kc = K - oneN * K - K * oneN + oneN * K * oneN;

    [V, D] = eig(Kc);
    [eigenvalues, idx] = sort(diag(D), 'descend');
    V = V(:, idx);

    for i = 1:N
        V(:, i) = V(:, i) / sqrt(eigenvalues(i));
    end

    U_kpca = V;
end

function denoised_img = denoise_using_pca(distorted_img, mean_img, U_pca)
    num_components = 3;
    U_pca = U_pca(:, 1:num_components);
    x = distorted_img(:);
    x_centered = x - mean_img;
    coeffs = U_pca' * x_centered;
    x_reconstructed = U_pca * coeffs + mean_img;
    denoised_img = rescale(reshape(x_reconstructed, 64, 64));

    for iter = 1:10
        denoised_img(denoised_img == 0) = min(denoised_img(denoised_img > 0));
        denoised_img(denoised_img == 1) = max(denoised_img(denoised_img < 1));
        denoised_img = denoised_img - mode(denoised_img(:));
        denoised_img = rescale(denoised_img);
    end
end

function preimage = kernel_pca_preimage(x_proj, X_train, sigma, alphas, lambdas, k)
    x_est = mean(X_train, 2);
    max_iter = 100;
    lr = 0.1;

    for iter = 1:max_iter
        Kx = exp(-pdist2(x_est', X_train').^2 / (2 * sigma^2));
        proj_est = (alphas' * Kx') ./ sqrt(lambdas);
        grad = zeros(size(x_est));
        for j = 1:size(X_train, 2)
            diff = x_est - X_train(:, j);
            kxj = exp(-norm(diff)^2 / (2 * sigma^2));
            for i = 1:k
                grad = grad + ...
                    2 * (proj_est(i) - x_proj(i)) * ...
                    alphas(j, i) * kxj * diff / (sigma^2 * sqrt(lambdas(i)));
            end
        end
        x_est = x_est - lr * grad;
    end

    preimage = reshape(x_est, 64, 64);
end