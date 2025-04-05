function [mean_shape, aligned_shapes] = mean_shape_align_b(X, max_iter)
    num_shapes = length(X);
    aligned_shapes = X;
    mean_shape = X{1};
    prev_mean = mean_shape;

    for iter = 1:max_iter
        for i = 1:num_shapes
            aligned_shapes{i} = mean_rot(mean_shape, X{i});
        end

        mean_shape = compute_geometric_median(aligned_shapes, 1e-6, 50);

        % Normalize mean shape
        mean_shape_norm = mean_shape - mean(mean_shape, 1);
        mean_shape_norm = mean_shape_norm / norm(mean_shape, 'fro');

        if sqrt(sum((prev_mean-mean_shape_norm).^2)) <= 1e-3
            fprintf("Converged at iteration %d\n", iter);
            break;
        end

        prev_mean =  mean_shape_norm;
    end
    
    for i = 1:num_shapes
        aligned_shapes{i} = mean_rot(mean_shape, X{i});
    end

end
