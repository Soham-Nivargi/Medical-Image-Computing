function [mean_shape, aligned_shapes] = code22_mean(X, max_iter)
    num_shapes = length(X);
    aligned_shapes = X;
    mean_shape = X{1};
    prev_mean = mean_shape;

    for iter = 1:max_iter
        for i = 1:num_shapes
            aligned_shapes{i} = code2_mean_all(mean_shape, X{i});
        end
        mean_shape = zeros(size(X{1}));
        for i = 1:num_shapes
            mean_shape = mean_shape + aligned_shapes{i};
        end
        mean_shape = mean_shape / num_shapes;

        if sqrt(sum((prev_mean-mean_shape).^2)) <= 1e-3
            fprintf("Converged at iteration %d\n", iter);
            break;
        end

        prev_mean =  mean_shape;
    end
end