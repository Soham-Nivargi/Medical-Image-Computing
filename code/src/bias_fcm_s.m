function [mem, means, masked_bias] = bias_fcm(X, C, q, bias, mask, gaussian_mask, means, max_iter, epsilon, lambdas, alpha)

    N = size(X, 1);
    d = size(X, 2);
    
    % Initial membership matrix
    distances = zeros(N,C);
    mem = zeros(N,C);
    masked_bias = bias(mask==1);

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
    
    objective = compute_obj(distances, mem.^q);

    % Initialize distances
    for k=1:C
        for j=1:length(X)
            distances(j,k) = sum(weights(:,j).*((X(j) - means(k)*masked_bias).^2));
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
                distances(j,k) = lambdas(k) * sum(weights(:,j).*((X(j) - means(k)*masked_bias).^2)) + ...
                    alpha * lambdas(k) * (sum(weights(:,j).*((1 - mem(:, k))))).^q;
            end
        end

        % Update memberships
        mem = (distances.^(-1/(q-1))) ./ sum(distances.^(-1/(q-1)), 2);

        % Update bias
        mem_q = mem.^q;
        
        % for i=1:length(X)
        %     dist1 = zeros(size(X));
        %     dist2 = zeros(size(X));
        %     for j=1:length(X)
        %         dist1(j) = weights(i,j)*X(j)*(mem_q(j,:)*means);
        %         dist2(j) = weights(i,j)*(mem_q(j,:)*(means.^2));
        %     end
        %     masked_bias(i) = sum(dist1)/sum(dist2);
        % end

        % dist1 = weights .* (X' .* (mem_q*means));  % size: N × N
        % dist2 = weights .* (mem_q*(means.^2));        % size: N × N
        % masked_bias = sum(dist1, 1) ./ sum(dist2, 1);

        for i=1:length(X) 
            dist1 = weights(i,:)'.*X.*(mem_q*means).*lambdas;
            dist2 = weights(i,:)'.*(mem_q*(means.^2).*lambdas);
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
                dist3(j) = mem_q(j,k)*X(j)*sum(weights(:,j).*masked_bias);
                dist4(j) = mem_q(j,k)*sum(weights(:,j).*(masked_bias.^2));
            end
            means(k) = sum(dist3)/sum(dist4);
        end
            
        objective = compute_obj(distances, mem_q);
        disp(objective);
        % Convergence
        if iter>1 && objective_old - objective < epsilon
            break;
        end
    end
end
