function X_median = compute_geometric_median(aligned_shapes, tol, max_iter)
% Weiszfeld's algorithm

    if nargin < 2
        tol = 1e-5;
    end
    if nargin < 3
        max_iter = 100;
    end

    M = length(aligned_shapes);
    N = size(aligned_shapes{1}, 1);

    shapes_matrix = zeros(M, 2 * N);
    for i = 1:M
        shapes_matrix(i, :) = reshape(aligned_shapes{i}, [], 1);
    end

    x = mean(shapes_matrix, 1)';

    for iter = 1:max_iter
        numerator = zeros(2 * N, 1);
        denominator = 0;
        for i = 1:M
            q_i = shapes_matrix(i, :)';
            dist = norm(x - q_i);
            if dist < 1e-10
                continue;
            end
            weight = 1 / dist;
            numerator = numerator + weight * q_i;
            denominator = denominator + weight;
        end

        x_new = numerator / denominator;

        if norm(x_new - x) < tol
            break;
        end

        x = x_new;
    end

    X_median = reshape(x, N, 2);
end
