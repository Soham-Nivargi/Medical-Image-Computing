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

c = cell(1, num_shapes);
figure;
hold on;
for i = 1:num_shapes
    c{i} = rand(1, 3);
    plot(X{i}(:, 1), X{i}(:, 2),'.', 'Color', c{i});
    plot(X{i}(:, 1), X{i}(:, 2), 'Color', c{i});
end
title('Initial hand shapes');
axis equal; axis off;
saveas(gcf, 'Results/initial_pointsets.png');

for i = 1:num_shapes
    X{i} = X{i} - mean(X{i}, 1);         
    X{i} = X{i} / norm(X{i}, 'fro');
end


figure;
hold on;
for i = 1:num_shapes
    plot(X{i}(:, 1), X{i}(:, 2),'.', 'Color', c{i});
    plot(X{i}(:, 1), X{i}(:, 2), 'Color', c{i});
end
title('Translated and Scaled initial hand shapes');
axis equal; axis off;
saveas(gcf, 'Results/norm_initial_pointsets.png');

%% (b) Mean
[max_shape, aligned_shapes_code11] = code11_mean(X, 10);

figure;
hold on;
for i = 1:num_shapes
    plot(aligned_shapes_code11{i}(:,1), aligned_shapes_code11{i}(:,2),'.', 'Color', [0.5 0.5 0.5]);
    plot(aligned_shapes_code11{i}(:,1), aligned_shapes_code11{i}(:,2), 'Color', [0.5 0.5 0.5]);
end
plot(max_shape(:,1), max_shape(:,2), 'r-', 'LineWidth', 2);
title('Code11: Aligned Shapes and Mean Shape');
axis equal; axis off;
saveas(gcf, 'Results/code1/mean_shape.png');

%% (c) Principal modes of variation
D = num_points * 2;
data_matrix = zeros(num_shapes, D);
for i = 1:num_shapes
    flat_shape = reshape(aligned_shapes_code11{i}', [1, D]); 
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
title('Code11: Top 3 Principal Mode Variances');
xlabel('Principal Mode'); ylabel('Variance');
saveas(gcf, 'Results/code1/principal_modes.png');

%% (d) mean ± k * sqrt(variance)
k = 2;  

for mode = 1:3
    variation = k * sqrt(evals(mode)) * V(:, mode)';
    shape_plus = reshape(mean_vec + variation, [2, num_points])';
    shape_minus = reshape(mean_vec - variation, [2, num_points])';

    figure;
    hold on;
    for i = 1:num_shapes
        plot(aligned_shapes_code11{i}(:,1), aligned_shapes_code11{i}(:,2), 'Color', [0.8 0.8 0.8]);
    end
    plot(max_shape(:,1), max_shape(:,2), 'k-', 'LineWidth', 2);
    plot(shape_plus(:,1), shape_plus(:,2), 'r--', 'LineWidth', 1.5);
    plot(shape_minus(:,1), shape_minus(:,2), 'b--', 'LineWidth', 1.5);
    title(['Code11: Principal Mode ' num2str(mode) ' Variation (±' num2str(k) ' SD)']);
    axis equal; axis off;
    saveas(gcf, ['Results/code1/mode_', num2str(mode),'.png']);
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
        title(['Code11 ' titles{mode} ' Mode ±' num2str(k) '\sigma']);
    end
saveas(gcf, 'Results/code1/comparison_modes.png');
end
