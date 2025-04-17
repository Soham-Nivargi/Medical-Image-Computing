function [labels, means] = kmeans_estimate(arr, K, max_iters, tolerance)
    num_pixels = length(arr);
    % Step 1: Intial estimate of means (random)
    rng(1);
    rand_idx = randperm(num_pixels, K);
    means = arr(rand_idx); % Kx1 mean vector

    labels = zeros(num_pixels, 1);

    for iter = 1:max_iters
        prev_means = means;
        
        % Step 2: Cluster Assignment
        for i = 1:num_pixels
            distances = abs(arr(i) - means);
            [~, min_idx] = min(distances);
            labels(i) = min_idx;
        end
        
        % Step 3: Update means
        for k = 1:K
            cluster_points = arr(labels == k);
            if ~isempty(cluster_points)
                means(k) = mean(cluster_points);
            else
                means(k) = arr(randi(num_pixels)); % Avoid empty cluster
            end
        end
        
        % K-means convergence criteria
        if max(abs(means - prev_means)) < tolerance
            fprintf('K-means converged at iteration %d\n', iter);
            break;
        end
    end

    [means, sort_idx] = sort(means);
    new_labels = zeros(size(labels));
    for k = 1:K
        new_labels(labels == sort_idx(k)) = k;
    end
    labels = new_labels;
end