close all;
clear;
clc;

data = load('../../data/hands2D.mat');
shapes = data.shapes;

[num_coords, num_points, num_shapes] = size(shapes);
X = cell(1, num_shapes);
for i = 1:num_shapes
    X{i} = shapes(:, :, i)'; 
end

%% (b) Run Code22 and visualize results
[max_shape, aligned_shapes_code22] = code22_mean(X, 10);

figure;
hold on;
for i = 1:num_shapes
    plot(aligned_shapes_code22{i}(:,1), aligned_shapes_code22{i}(:,2), 'Color', [0.5 0.5 0.5]);
end
plot(max_shape(:,1), max_shape(:,2), 'r-', 'LineWidth', 2);
title('Code22: Aligned Shapes and Mean Shape');
axis equal; axis off;
saveas(gcf, 'Results/code2/mean_shape.png');

%% (c) principal modes of variation
D = num_points * 2;
data_matrix = zeros(num_shapes, D);
for i = 1:num_shapes
    flat_shape = reshape(aligned_shapes_code22{i}', [1, D]);  % Flattening (2x56 → 112x1 → 1x112)
    data_matrix(i, :) = flat_shape;
end

% Compute mean and center data
mean_vec = mean(data_matrix, 1);
centered_data = data_matrix - mean_vec;

% Estimate covariance matrix (Sample Covariance for Gaussian Model)
Cov = cov(centered_data);

% Perform eigen-decomposition to get principal modes
[V, S] = eig(Cov);
[evals, idx] = sort(diag(S), 'descend');
V = V(:, idx);  % Reorder eigenvectors

% (c) Plot top 3 eigenvalues
figure;
bar(evals(1:3));
title('Top 3 Principal Mode Variances (Code22)');
xlabel('Principal Mode'); ylabel('Variance');
saveas(gcf, 'Results/code2/principal_modes.png');

%% (d) Visualize shape mean ± k * sqrt(variance) along top principal modes
k = 2;  % You can try k = 3 as well

for mode = 1:3
    variation = k * sqrt(evals(mode)) * V(:, mode)';
    shape_plus = reshape(mean_vec + variation, [2, num_points])';
    shape_minus = reshape(mean_vec - variation, [2, num_points])';

    figure;
    hold on;
    for i = 1:num_shapes
        plot(aligned_shapes_code22{i}(:,1), aligned_shapes_code22{i}(:,2), 'Color', [0.8 0.8 0.8]);
    end
    plot(max_shape(:,1), max_shape(:,2), 'k-', 'LineWidth', 2);
    plot(shape_plus(:,1), shape_plus(:,2), 'r--', 'LineWidth', 1.5);
    plot(shape_minus(:,1), shape_minus(:,2), 'b--', 'LineWidth', 1.5);
    title(['Principal Mode ' num2str(mode) ' Variation (±' num2str(k) ' SD)']);
    axis equal; axis off;
    saveas(gcf, ['Results/code2/mode_', num2str(mode),'.png']);
end

k_vals = [2, 3];
titles = {'1st', '2nd', '3rd'};

figure;
for mode = 1:3
    for j = 1:2
        k = k_vals(j);
        variation = k * sqrt(evals(mode)) * V(:, mode)';
        shape_plus = reshape(mean_vec + variation, [2, num_points])';
        shape_minus = reshape(mean_vec - variation, [2, num_points])';

        subplot(3,2,(mode-1)*2 + j);
        hold on;
        plot(max_shape(:,1), max_shape(:,2), 'k-', 'LineWidth', 2);
        plot(shape_plus(:,1), shape_plus(:,2), 'r--', 'LineWidth', 1.5);
        plot(shape_minus(:,1), shape_minus(:,2), 'b--', 'LineWidth', 1.5);
        axis equal; axis off;
        title([titles{mode} ' Mode ±' num2str(k) '\sigma']);
    end
saveas(gcf, 'Results/code2/comparison_modes.png');
end
