function [mean_shape, aligned_shapes] = code22_mean(X, max_iter)
    num_shapes = length(X);
    aligned_shapes = X;
    mean_shape = X{1};
    prev_mean = mean_shape;
    prev_mean_norm = prev_mean - mean(mean_shape, 1);
    prev_mean_norm = prev_mean_norm / norm(mean_shape, 'fro'); 

    for iter = 1:max_iter
        for i = 1:num_shapes
            aligned_shapes{i} = code2_mean_all(mean_shape, X{i});
        end
        mean_shape = zeros(size(X{1}));
        for i = 1:num_shapes
            mean_shape = mean_shape + aligned_shapes{i};
        end
        mean_shape = mean_shape / num_shapes;

        mean_shape_norm = mean_shape - mean(mean_shape, 1);
        mean_shape_norm = mean_shape_norm / norm(mean_shape, 'fro');

        if sqrt(sum((prev_mean_norm-mean_shape_norm).^2)) <= 1e-3
            fprintf("Converged at iteration %d\n", iter);
            break;
        end

        prev_mean =  mean_shape;
        prev_mean_norm = mean_shape_norm;
    end
end