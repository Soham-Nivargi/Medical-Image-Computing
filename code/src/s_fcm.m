function [U, centers] = s_fcm(X, C, q, mask, gaussian_mask, max_iter, tol)

    N = size(X, 1);
    d = size(X, 2);

    % Random initial membership matrix
    U = rand(C, N);
    U = U ./ sum(U, 1);

    brain_indices = find(mask);
    weights = zeros(length(X), length(X));

    % Compute weights w_ij common across all iterations
    for j=1:length(X)
        linear_idx = brain_indices(j);        % the linear index in the full image
        [x, y] = ind2sub(size(mask), linear_idx);  % convert to (row, col) = (x, y)
        gaussian_mask_temp = zeros(size(mask));
        gaussian_mask_temp(x-4:x+4, y-4:y+4) = gaussian_mask;
        weights(:,j) = gaussian_mask_temp(mask==1);
    end

    
    Um = U.^q;
    centers = (Um * X) ./ sum(Um, 2);
    
    % Update distances
    dist = zeros(N, C);
    for k = 1:C
        dist(:,k) = (X - centers(k)).^2';
    end
    dist = max(dist, 1e-10);
    objective = compute_obj(dist, (U.^q)');

    for iter = 1:max_iter
        U_old = U;

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

        % Average membership
        H = zeros(C, N);
        for j = 1:length(X)
            H(:, j) = sum(U .* weights(:, j)', 2);
        end
        U = H .* U;
        U = U ./ sum(U, 1);


        % Convergence using objective function
        objective_new = compute_obj(dist, (U.^q)');
        if abs(objective - objective_new) < tol
            break;
        end
        objective = objective_new;
        disp(objective);
    end

    U = U';          % (N x C)
    centers = centers; % (C x d)
end
