function X_median = compute_geometric_median(aligned_shapes, tol, max_iter)
% Computes the geometric median of M aligned Nx2 shapes using Weiszfeld's algorithm
%
% Inputs:
%   aligned_shapes: a cell array of M shapes, each of size Nx2
%   tol: tolerance for convergence (e.g., 1e-5)
%   max_iter: maximum number of iterations (e.g., 100)
%
% Output:
%   X_median: the estimated mean shape (Nx2) that minimizes sum of distances

    if nargin < 2
        tol = 1e-5;
    end
    if nargin < 3
        max_iter = 100;
    end

    M = length(aligned_shapes);
    N = size(aligned_shapes{1}, 1);

    % Flatten all shapes to 2N vectors
    shapes_matrix = zeros(M, 2 * N);
    for i = 1:M
        shapes_matrix(i, :) = reshape(aligned_shapes{i}, [], 1);
    end

    % Initialize mean shape as the arithmetic mean
    x = mean(shapes_matrix, 1)';

    for iter = 1:max_iter
        numerator = zeros(2 * N, 1);
        denominator = 0;
        for i = 1:M
            q_i = shapes_matrix(i, :)';
            dist = norm(x - q_i);
            if dist < 1e-10
                % If very close, skip to avoid instability
                continue;
            end
            weight = 1 / dist;
            numerator = numerator + weight * q_i;
            denominator = denominator + weight;
        end

        x_new = numerator / denominator;

        % Check convergence
        if norm(x_new - x) < tol
            break;
        end

        x = x_new;
    end

    % Reshape back to Nx2
    X_median = reshape(x, N, 2);
end
