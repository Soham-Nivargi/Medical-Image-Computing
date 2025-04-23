function [mem, means, masked_bias] = bias_fcm_r(X, C, q, bias, mask, gaussian_mask, means, max_iter, epsilon, lambdas, alpha)

    N = size(X, 1);
    d = size(X, 2);
    
    % Initial membership matrix
    distances = zeros(N,C);
    mem = zeros(N,C);
    masked_bias = bias(mask==1);

    brain_indices = find(mask);
    

    % weights w_ij without memory constraint
    % weights = zeros(length(X), length(X));
    % for j=1:length(X)
    %     linear_idx = brain_indices(j);        % the linear index in the full image
    %     [x, y] = ind2sub(size(mask), linear_idx);  % convert to (row, col) = (x, y)
    %     gaussian_mask_temp = zeros(size(mask));
    %     gaussian_mask_temp(x-4:x+4, y-4:y+4) = gaussian_mask;
    %     weights(:,j) = gaussian_mask_temp(mask==1);
    % end
    
    objective = compute_obj(distances, mem.^q);
    objective_plot = [];

    % Initialize distances
    for k=1:C
        for j=1:length(X)
            % weights with memory constraint
            linear_idx = brain_indices(j);        % the linear index in the full image
                [x, y] = ind2sub(size(mask), linear_idx);  % convert to (row, col) = (x, y)
                gaussian_mask_temp = zeros(size(mask));
                if x>4 && x<=size(gaussian_mask_temp,1)-4
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(x-4:x+4, y-4:y+4) = gaussian_mask;
                    elseif y<=4
                        gaussian_mask_temp(x-4:x+4, 1:y+4) = gaussian_mask(:,6-y:9);
                    else
                        gaussian_mask_temp(x-4:x+4, y-4:size(gaussian_mask_temp,2)) = gaussian_mask(:,1:5+(size(gaussian_mask_temp,2)-y));
                    end
                elseif x<=4
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(1:x+4, y-4:y+4) = gaussian_mask(6-x:9, :);
                    elseif y<=4
                        gaussian_mask_temp(1:x+4, 1:y+4) = gaussian_mask(6-x:9,6-y:9);
                    else
                        gaussian_mask_temp(1:x+4, y-4:size(gaussian_mask_temp,2)) = gaussian_mask(6-x:9,1:5+(size(gaussian_mask_temp,2)-y));
                    end
                else
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), y-4:y+4) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x), :);
                    elseif y<=4
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), 1:y+4) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x),6-y:9);
                    else
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), y-4:size(gaussian_mask_temp,2)) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x),1:5+(size(gaussian_mask_temp,2)-y));
                    end
                end
                weights = gaussian_mask_temp(mask==1);


            distances(j,k) = sum(weights.*((X(j) - means(k)*masked_bias).^2));
            
            % weights without memory constraint
            % distances(j,k) = sum(weights(:,j).*((X(j) - means(k)*masked_bias).^2));
        end
    end

    % Initialize membership
    mem = (distances.^(-1/(q-1))) ./ sum(distances.^(-1/(q-1)), 2);

    for iter = 1:max_iter
        mem_old = mem;
        objective_old = objective;

        % Compute distances
        for k=1:C
            for j=1:length(X)
                % weights with memory constraint
                linear_idx = brain_indices(j);        % the linear index in the full image
                [x, y] = ind2sub(size(mask), linear_idx);  % convert to (row, col) = (x, y)
                gaussian_mask_temp = zeros(size(mask));
                if x>4 && x<=size(gaussian_mask_temp,1)-4
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(x-4:x+4, y-4:y+4) = gaussian_mask;
                    elseif y<=4
                        gaussian_mask_temp(x-4:x+4, 1:y+4) = gaussian_mask(:,6-y:9);
                    else
                        gaussian_mask_temp(x-4:x+4, y-4:size(gaussian_mask_temp,2)) = gaussian_mask(:,1:5+(size(gaussian_mask_temp,2)-y));
                    end
                elseif x<=4
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(1:x+4, y-4:y+4) = gaussian_mask(6-x:9, :);
                    elseif y<=4
                        gaussian_mask_temp(1:x+4, 1:y+4) = gaussian_mask(6-x:9,6-y:9);
                    else
                        gaussian_mask_temp(1:x+4, y-4:size(gaussian_mask_temp,2)) = gaussian_mask(6-x:9,1:5+(size(gaussian_mask_temp,2)-y));
                    end
                else
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), y-4:y+4) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x), :);
                    elseif y<=4
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), 1:y+4) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x),6-y:9);
                    else
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), y-4:size(gaussian_mask_temp,2)) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x),1:5+(size(gaussian_mask_temp,2)-y));
                    end
                end
                weights = gaussian_mask_temp(mask==1);
                
                distances(j,k) = lambdas(k) * sum(weights.*((X(j) - means(k)*masked_bias).^2)) + ...
                    alpha * lambdas(k) * (sum(weights.*((1 - mem(:, k))))).^q;

                % weights without memory constraint
                % distances(j,k) = lambdas(k) * sum(weights(:,j).*((X(j) - means(k)*masked_bias).^2)) + ...
                %     alpha * lambdas(k) * (sum(weights(:,j).*((1 - mem(:, k))))).^q;
            end
        end

        % Update memberships
        mem = (distances.^(-1/(q-1))) ./ sum(distances.^(-1/(q-1)), 2);

        % Update bias
        mem_q = mem.^q;
 
        for i=1:length(X)
            % weights with memory constraint
            linear_idx = brain_indices(i);        % the linear index in the full image
                [x, y] = ind2sub(size(mask), linear_idx);  % convert to (row, col) = (x, y)
                gaussian_mask_temp = zeros(size(mask));
                if x>4 && x<=size(gaussian_mask_temp,1)-4
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(x-4:x+4, y-4:y+4) = gaussian_mask;
                    elseif y<=4
                        gaussian_mask_temp(x-4:x+4, 1:y+4) = gaussian_mask(:,6-y:9);
                    else
                        gaussian_mask_temp(x-4:x+4, y-4:size(gaussian_mask_temp,2)) = gaussian_mask(:,1:5+(size(gaussian_mask_temp,2)-y));
                    end
                elseif x<=4
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(1:x+4, y-4:y+4) = gaussian_mask(6-x:9, :);
                    elseif y<=4
                        gaussian_mask_temp(1:x+4, 1:y+4) = gaussian_mask(6-x:9,6-y:9);
                    else
                        gaussian_mask_temp(1:x+4, y-4:size(gaussian_mask_temp,2)) = gaussian_mask(6-x:9,1:5+(size(gaussian_mask_temp,2)-y));
                    end
                else
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), y-4:y+4) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x), :);
                    elseif y<=4
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), 1:y+4) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x),6-y:9);
                    else
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), y-4:size(gaussian_mask_temp,2)) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x),1:5+(size(gaussian_mask_temp,2)-y));
                    end
                end
                weights = gaussian_mask_temp(mask==1);

            dist1 = weights.*X.*(mem_q*means).*lambdas;
            dist2 = weights.*(mem_q*(means.^2).*lambdas);

            % weights without memory constraint
            % dist1 = weights(:, i).*X.*(mem_q*means).*lambdas;
            % dist2 = weights(:, i).*(mem_q*(means.^2).*lambdas);

            masked_bias(i) = sum(dist1)/sum(dist2);
        end
        
        % Make masked_bias shape to 256 x 256
        reshaped_bias = zeros(size(mask));
        reshaped_bias(mask==1) = masked_bias;

        % Apply bilateral filter to the bias field. Use imbilatfilt
        % to smooth the bias field
        reshaped_bias = imbilatfilt(reshaped_bias);
        masked_bias = reshaped_bias(mask==1);
        

        % Update cluster centres
        dist3 = zeros(size(X));
        dist4 = zeros(size(X));
        for k=1:C
            for j=1:length(X)
                % weights with memory constraint
                linear_idx = brain_indices(j);        % the linear index in the full image
                [x, y] = ind2sub(size(mask), linear_idx);  % convert to (row, col) = (x, y)
                gaussian_mask_temp = zeros(size(mask));
                if x>4 && x<=size(gaussian_mask_temp,1)-4
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(x-4:x+4, y-4:y+4) = gaussian_mask;
                    elseif y<=4
                        gaussian_mask_temp(x-4:x+4, 1:y+4) = gaussian_mask(:,6-y:9);
                    else
                        gaussian_mask_temp(x-4:x+4, y-4:size(gaussian_mask_temp,2)) = gaussian_mask(:,1:5+(size(gaussian_mask_temp,2)-y));
                    end
                elseif x<=4
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(1:x+4, y-4:y+4) = gaussian_mask(6-x:9, :);
                    elseif y<=4
                        gaussian_mask_temp(1:x+4, 1:y+4) = gaussian_mask(6-x:9,6-y:9);
                    else
                        gaussian_mask_temp(1:x+4, y-4:size(gaussian_mask_temp,2)) = gaussian_mask(6-x:9,1:5+(size(gaussian_mask_temp,2)-y));
                    end
                else
                    if y>4 && y<=size(gaussian_mask_temp,2)-4
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), y-4:y+4) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x), :);
                    elseif y<=4
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), 1:y+4) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x),6-y:9);
                    else
                        gaussian_mask_temp(x-4:size(gaussian_mask_temp,1), y-4:size(gaussian_mask_temp,2)) = gaussian_mask(1:5+(size(gaussian_mask_temp,1)-x),1:5+(size(gaussian_mask_temp,2)-y));
                    end
                end
                weights = gaussian_mask_temp(mask==1);
                dist3(j) = mem_q(j,k)*X(j)*sum(weights.*masked_bias);
                dist4(j) = mem_q(j,k)*sum(weights.*(masked_bias.^2));
                
                % weights without memory constraint
                % dist3(j) = mem_q(j,k)*X(j)*sum(weights(:,j).*masked_bias);
                % dist4(j) = mem_q(j,k)*sum(weights(:,j).*(masked_bias.^2));
            end
            means(k) = sum(dist3)/sum(dist4);
        end
            
        objective = compute_obj(distances, mem_q);
        disp(objective);

        objective_plot = [objective_plot, objective];
        % Convergence
        if iter>1 && abs(objective_old - objective) < epsilon
            break;
        end
    end

    figure;
    plot(objective_plot, 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('Objective function');
    title('Iterative update of the objective function');
    grid on;
    saveas(gcf,'../results/coins/bcefcm_r/obj.png');

end
