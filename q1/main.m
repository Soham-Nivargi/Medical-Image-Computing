load('data/assignmentSegmentBrain.mat');

num_classes = 3; 
q = 2;     
sigma = 1.5; 
max_iters = 5; 
tolerance = 1e-3;
weight_size = 9;

% Get image size
[rows, cols] = size(imageData);

% Apply mask to imageData
maskedImageData = imageData(imageMask == 1);

% Initialize bias field
bias_field = ones(rows, cols);

% Compute Gaussian weight mask
W = gaussian_weight_mask(weight_size, sigma);

% Show W
figure;
imagesc(W);
title('Gaussian Weight Mask');
colormap gray;
axis off;

% Plot the histogram of the masked image
figure;
histogram(maskedImageData, 256);
title('Histogram of the masked image');

% Find mode of the histogram within the range of intensities 0 to 0.1
[counts, bin_edges] = histcounts(maskedImageData, 256, 'BinLimits', [0, 0.1]);
[~, max_idx] = max(counts);
mode_intensity1 = (bin_edges(max_idx) + bin_edges(max_idx + 1)) / 2;

% Find mode of the histogram within the range of intensities 0.1 to 0.3
[counts, bin_edges] = histcounts(maskedImageData, 256, 'BinLimits', [0.1, 0.3]);
[~, max_idx] = max(counts);
mode_intensity2 = (bin_edges(max_idx) + bin_edges(max_idx + 1)) / 2;

% Find mode of the histogram within the range of intensities 0.3 to 1
[counts, bin_edges] = histcounts(maskedImageData, 256, 'BinLimits', [0.3, 1]);
[~, max_idx] = max(counts);
mode_intensity3 = (bin_edges(max_idx) + bin_edges(max_idx + 1)) / 2;

class_means = [mode_intensity1, mode_intensity2, mode_intensity3];
fprintf('Initial class means: %.4f, %.4f, %.4f\n', class_means);

% Initialize membership values only for masked regions
membership_values = initialize_membership(imageData, class_means);
membership_values(~imageMask) = 0; % Set membership values to 0 outside the mask

% visualize mask
figure;
imagesc(imageMask);
title('Mask');
colormap gray;
axis off;



% Display initial membership values for each class
figure;
for k = 1:num_classes
    subplot(1, num_classes, k);
    imagesc(squeeze(membership_values(:,:,k)) .* imageMask); % Apply mask for visualization
    title(['Class ' num2str(k)]);
    colormap gray;
    axis off;
end

% Reshape membership values for computation
membership_values = reshape(membership_values, rows * cols, num_classes)';

objective_func_vals = zeros(max_iters, 1);
for iter = 1:max_iters
    dkj = compute_distance(imageData, class_means, bias_field, W, imageMask);
    dkj(:, ~imageMask(:)) = Inf; % Ignore distances outside the mask

    objective_func_vals(iter) = objective_function(imageData, dkj, membership_values, class_means, bias_field, W, q, imageMask);
    if iter > 1 && objective_func_vals(iter) > objective_func_vals(iter - 1)
        fprintf('Objective function value increased. Terminating.\n');
        break;
    end

    ujk = update_membership(dkj, q, imageMask);
    ujk(:, ~imageMask(:)) = 0; % Set membership to 0 outside the mask
    bias_field = update_bias(imageData, ujk, class_means, W, q, imageMask);
    bias_field(~imageMask) = 1; % Reset bias field outside the mask
    new_class_means = update_class_means(imageData, ujk, bias_field, W, q, imageMask);

    if max(abs(new_class_means - class_means)) < tolerance
        fprintf('Converged in %d iterations.\n', iter);
        break;
    end

    class_means = new_class_means;
end

% Reshape membership values for visualization
final_membership = reshape(ujk, num_classes, rows, cols);

% Display results
figure;
for k = 1:num_classes
    subplot(1, num_classes, k);
    imagesc(squeeze(final_membership(k, :, :)) .* imageMask); % Apply mask for visualization
    title(['Class ' num2str(k)]);
    colormap gray;
    axis off;
end

% Plot the objective function values
figure;
plot(1:iter, objective_func_vals(1:iter));
title('Objective Function Value vs. Iterations');
xlabel('Iterations');
ylabel('Objective Function Value');

% Show the corrupted image provided
figure;
imagesc(imageData .* imageMask);
title('Corrupted Image');
colormap gray;
axis off;

% Show the optimal bias field image estimate
figure;
imagesc(bias_field);
title('Optimal Bias Field Estimate');
colormap gray;
axis off;

% Show the bias-corrected image
bias_corrected_image = (imageData ./ bias_field) .* imageMask;
figure;
imagesc(bias_corrected_image);
title('Bias-Corrected Image');
colormap gray;

% Show the residual image
residual_image = (imageData - bias_corrected_image) .* imageMask;
figure;
imagesc(residual_image);
title('Residual Image');
colormap gray;
axis off;

% Print the optimal class means
fprintf('Optimal class means: %.4f, %.4f, %.4f\n', class_means);

function dkj = compute_distance(y, c, b, w, imageMask)
    [~, M] = size(y);
    K = length(c);
    dkj = zeros(K, M*M);
    
    for k = 1:K
        for j = 1:M*M
            if imageMask(j) == 0
                continue;
            end
            wi = w_at_i(w, j, [M, M]) .* imageMask;
            dkj(k, j) = sum(sum(wi .* (y(j) - c(k) * b).^2));
        end
    end
end

function ujk = update_membership(dkj, q, imageMask)
    K = size(dkj, 1);
    ujk = zeros(size(dkj));
    
    for j = 1:size(dkj, 2)
        if imageMask(j) == 0
            continue;
        end
        denom = sum((1 ./ dkj(:, j)).^(1 / (q - 1)));
        for k = 1:K
            ujk(k, j) = (1 / dkj(k, j))^(1 / (q - 1)) / denom;
        end
    end
end

function bi = update_bias(y, ujk, c, w, q, imageMask)
    N = size(y, 1);
    bi = zeros(N, N);
    
    for i = 1:N*N
        if imageMask(i) == 0
            continue;
        end
        wati = w_at_i(w, i, [N, N]) .* imageMask;
        numerator = sum(sum(wati .* y)) * sum((ujk(:, i) .^ q) .* c);
        denominator = sum(sum(wati)) * sum((ujk(:, i) .^ q) .* c.^2);
        bi(i) = numerator / denominator;
    end
end

function ck = update_class_means(y, ujk, b, w, q, imageMask)    
    K = size(ujk, 1);
    ck = zeros(K, 1);
    
    for k = 1:K
        num = 0;
        for j = 1:size(ujk, 2)
            if imageMask(j) == 0
                continue;
            end
            wj = w_at_i(w, j, size(y)) .* imageMask;
            num = num + ujk(k, j)^q * y(j) * sum(sum(wj .* b));
        end
        denom = 0;
        for j = 1:size(ujk, 2)
            if imageMask(j) == 0
                continue;
            end
            wj = w_at_i(w, j, size(y)) .* imageMask;
            denom = denom + ujk(k, j)^q * sum(sum(wj .* (b.^2)));
        end
        ck(k) = num / denom;
    end
end

function W = gaussian_weight_mask(N, sigma)
    [x, y] = meshgrid(-floor(N/2):floor(N/2), -floor(N/2):floor(N/2));
    
    % Compute the Gaussian weights
    W = exp(-(x.^2 + y.^2) / (2 * sigma^2));
    
    % Normalize so that weights sum to 1
    W = W / sum(W(:));
end

function membership_values = initialize_membership(image, class_means)
    num_classes = length(class_means);

    [rows, cols] = size(image);
    membership_values = zeros(rows, cols, num_classes);

    for k = 1:num_classes
        membership_values(:,:,k) = exp(-abs(image - class_means(k))); % Gaussian-like assignment
    end

    sum_membership = sum(membership_values, 3);
    for k = 1:num_classes
        membership_values(:,:,k) = membership_values(:,:,k) ./ sum_membership;
    end
end

function result = w_at_i(w, i, s)
    result = zeros(s);
    [center_row, center_col] = ind2sub(s, i);
    [w_rows, w_cols] = size(w);
    
    start_row = center_row - floor(w_rows / 2);
    start_col = center_col - floor(w_cols / 2);
    
    end_row = start_row + w_rows - 1;
    end_col = start_col + w_cols - 1;
    
    valid_start_row = max(start_row, 1);
    valid_start_col = max(start_col, 1);
    valid_end_row = min(end_row, s(1));
    valid_end_col = min(end_col, s(2));
    
    w_start_row = 1 + (valid_start_row - start_row);
    w_start_col = 1 + (valid_start_col - start_col);
    w_end_row = w_rows - (end_row - valid_end_row);
    w_end_col = w_cols - (end_col - valid_end_col);
    
    result(valid_start_row:valid_end_row, valid_start_col:valid_end_col) = ...
        w(w_start_row:w_end_row, w_start_col:w_end_col);
end

function obj_func_val = objective_function(y, dkj, ujk, c, b, w, q, imageMask)
    obj_func_val = 0;
    for j = 1:size(dkj, 2)
        if imageMask(j) == 0
            continue;
        end
        wj = w_at_i(w, j, size(b)) .* imageMask;
        for k = 1:size(dkj, 1)
            obj_func_val = obj_func_val + ujk(k, j)^q * sum(sum(wj .* (y(j) - c(k) * b).^2));
        end
    end
end