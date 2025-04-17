function [U, centers] = bias_fcm(X, C, q, bias, mask, gaussian_mask, label_vector, means, max_iter, epsilon)

    N = size(X, 1);
    d = size(X, 2);
    
    % Initial membership matrix
    distances = zeros(N,C);
    mem = zeros(N,C);
    masked_bias = bias(mask==1);

    for iter = 1:max_iter
        mem_old = mem;
        
        brain_indices = find(mask);
        weights = zeros(length(X), length(X));
        % Compute weights
        for j=1:size(X)
            linear_idx = brain_indices(j);        % the linear index in the full image
            [x, y] = ind2sub(size(mask), linear_idx);  % convert to (row, col) = (x, y)
            gaussian_mask_temp = zeros(size(mask));
            gaussian_mask_temp(x-4:x+4, y-4:y+4) = gaussian_mask;
            weights(:,j) = gaussian_mask_temp(mask==1);
        end
        clc;
        
        label_image(mask==1) = X;
        
            
        
        
        % Update memberships
        for k=1:C
            for j=1:size(X)
                distances(j,k) = (sum(weights(:,j).*((X(j) - means(k)*masked_bias).^2))).^(-1 / (q-1));
            end
        end
        mem = distances ./ sum(distances, 2);
        
        
        % Compute cluster centers
        Um = U.^q;
        centers = (Um * X) ./ sum(Um, 2);
        
        % Update distances
        dist = zeros(N, C);
        for k = 1:C
            dist(:,k) = (X - centers(k)).^2';
        end
        dist = max(dist, 1e-10);
        
        % Update membership
        tmp = dist .^ (-1 / (q - 1));
        U = (tmp ./ sum(tmp, 2))';
        
        % Convergence
        if norm(U - U_old, 'fro') < epsilon
            break;
        end
    end

    U = U';          % (N x C)
    centers = centers; % (C x d)
end
