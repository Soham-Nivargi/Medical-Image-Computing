close all;
clear;
clc;

data = load('../../data/robustShapeMean2D.mat');
shapes = data.pointsets;

[num_shapes, num_points, num_coords] = size(shapes);
X = cell(1, num_shapes);
for i = 1:num_shapes
    X{i} = squeeze(shapes(i, :, :)); 
end

% c = cell(1, num_shapes);
% figure;
% hold on;
% for i = 1:num_shapes
%     c{i} = rand(1, 3);
%     plot(X{i}(:, 1), X{i}(:, 2), 'Color', c{i});
% end
% title('Initial shapes');
% axis equal; axis off;
% saveas(gcf, 'Results/initial_pointsets.png');
% 
% for i = 1:num_shapes
%     X{i} = X{i} - mean(X{i}, 1);         
%     X{i} = X{i} / norm(X{i}, 'fro');
% end
% 
% figure;
% hold on;
% for i = 1:num_shapes
%     plot(X{i}(:, 1), X{i}(:, 2), 'Color', c{i});
% end
% title('Translated and Scaled Initial shapes');
% axis equal; axis off;
% saveas(gcf, 'Results/norm_initial_pointsets.png');

%% (b) Shape mean
[max_shape, aligned_shapes] = mean_shape_align_a(X, 10);

figure;
hold on;
for i = 1:num_shapes
    plot(aligned_shapes{i}(:,1), aligned_shapes{i}(:,2),'.', 'Color', [0.5 0.5 0.5]);
end
plot(max_shape(:,1), max_shape(:,2), 'r-', 'LineWidth', 2);
title('Squared: Aligned Shapes and Mean Shape');
axis equal; axis off;
saveas(gcf, 'Results/Part a/mean_shape.png');

%% (c) Principal modes of variation
D = num_points * 2;
data_matrix = zeros(num_shapes, D);
for i = 1:num_shapes
    flat_shape = reshape(aligned_shapes{i}', [1, D]);  
    data_matrix(i, :) = flat_shape;
end

mean_vec = mean(data_matrix, 1);
centered_data = data_matrix - mean_vec;

% covariance matrix
Cov = cov(centered_data);

% eigen-decomposition
[V, S] = eig(Cov);
[evals, idx] = sort(diag(S), 'descend');
V = V(:, idx);  

figure;
bar(evals(1:3));
title('Squared: Top 3 Principal Mode Variances');
xlabel('Principal Mode'); ylabel('Variance');
saveas(gcf, 'Results/Part a/principal_modes.png');

%% (d) shape mean ± k * sqrt(variance)
k = 2;  

for mode = 1:3
    variation = k * sqrt(evals(mode)) * V(:, mode)';
    shape_plus = reshape(mean_vec + variation, [2, num_points])';
    shape_minus = reshape(mean_vec - variation, [2, num_points])';

    figure;
    hold on;
    for i = 1:num_shapes
        plot(aligned_shapes{i}(:,1), aligned_shapes{i}(:,2), 'Color', [0.8 0.8 0.8]);
    end
    plot(max_shape(:,1), max_shape(:,2), 'k-', 'LineWidth', 2);
    plot(shape_plus(:,1), shape_plus(:,2), 'r--', 'LineWidth', 1.5);
    plot(shape_minus(:,1), shape_minus(:,2), 'b--', 'LineWidth', 1.5);
    title(['Squared: Principal Mode ' num2str(mode) ' Variation (±' num2str(k) ' SD)']);
    axis equal; axis off;
    saveas(gcf, ['Results/Part a/mode_', num2str(mode),'.png']);
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
        title(['Squared ' titles{mode} ' Mode ±' num2str(k) '\sigma']);
    end
saveas(gcf, 'Results/Part a/comparison_modes.png');
end
