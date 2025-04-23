function [U, centers] = s_fcm(X, C, q, mask, gaussian_mask, max_iter, tol)

    N = size(X, 1);
    d = size(X, 2);

    % Random initial membership matrix
    U = rand(C, N);
    U = U ./ sum(U, 1);

    brain_indices = find(mask);
    

    % weights w_ij without memory constraint
    weights = zeros(length(X), length(X));
    for j=1:length(X)
        linear_idx = brain_indices(j);        % the linear index in the full image
        [x, y] = ind2sub(size(mask), linear_idx);  % convert to (row, col) = (x, y)
        gaussian_mask_temp = zeros(size(mask));
        gaussian_mask_temp(x-4:x+4, y-4:y+4) = gaussian_mask;
        weights(:,j) = gaussian_mask_temp(mask==1);
    end

    
    Um = U.^q;
    centers = (Um * X) ./ sum(Um, 2);

    objective_plot = [];
    
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
            % weights with memory constraint
            % linear_idx = brain_indices(j);        % the linear index in the full image
            % [x, y] = ind2sub(size(mask), linear_idx);  % convert to (row, col) = (x, y)
            % gaussian_mask_temp = zeros(size(mask));
            % if x>4 && x<=size(gaussian_mask_temp,1)-4
            %     if y>4 && y<=size(gaussian_mask_temp,2)-4
            %         gaussian_mask_temp(x-4:x+4, y-4:y+4) = gaussian_mask;
            %     elseif y<=4
            %         gaussian_mask_temp(x-4:x+4, 1:y+4) = gaussian_mask(:,6-y:9);
            %     else
            %         gaussian_mask_temp(x-4:x+4, y-4:size(gaussian_mask_temp,2)) = gaussian_mask(:,1:5+(size(gaussian_mask_temp,2)-y));
            %     end
            % elseif x<=4
            %     if y>4 && y<=size(gaussian_mask_temp,2)-4
            %         gaussian_mask_temp(1:x+4, y-4:y+4) = gaussian_mask(6-x:9, :);
            %     elseif y<=4
            %         gaussian_mask_temp(1:x+4, 1:y+4) = gaussian_mask(6-x:9,6-y:9);
            %     else
            %         gaussian_mask_temp(1:x+4, y-4:size(gaussian_mask_temp,2)) = gaussian_mask(6-x:9,1:5+(size(gaussian_mask_temp,2)-y));
            %     end
            % else
            %     if y>4 && y<=size(gaussian_mask_temp,2)-4
            %         gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), y-4:y+4) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x), :);
            %     elseif y<=4
            %         gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), 1:y+4) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x),6-y:9);
            %     else
            %         gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), y-4:size(gaussian_mask_temp,2)) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x),1:5+(size(gaussian_mask_temp,2)-y));
            %     end
            % end
            % weights = gaussian_mask_temp(mask==1);
            % H(:, j) = sum(U .* weights', 2);

            % weights without memory constraint
            H(:, j) = sum(U .* weights(:, j)', 2);
            
        end
        U = H .* U;
        U = U ./ sum(U, 1);


        % Convergence using objective function
        objective_new = compute_obj(dist, (U.^q)');
        objective_plot = [objective_plot, objective_new];
        if abs(objective - objective_new) < tol
            break;
        end
        objective = objective_new;
        disp(objective);
    end

    figure;
    plot(objective_plot, 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('Objective function');
    title('Iterative update of the objective function');
    grid on;
    % saveas(gcf,'../results/coins/sfcm/obj.png');

    U = U';          % (N x C)
    centers = centers; % (C x d)
end
