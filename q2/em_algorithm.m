function [final_label_image,final_means,final_stds, final_mem, log_posterior] = em_algorithm(beta, num_iters_em, tolerance_em, means, stds, ...
    num_pixels, K, brainPixels, imageMask, rows, cols, label_vector, r_coords, c_coords)
    
    for em_iter = 1:num_iters_em
    
        prev_means = means;
        prev_stds = stds;
    
        % Step 1: MAP Label Update
        data_term = zeros(num_pixels, K);
        for k = 1:K
            data_term(:, k) = -0.5* log(2*pi*stds(k)^2) - 0.5 * ((brainPixels - means(k)).^2) / (stds(k)^2);
        end
    
        smoothness_term = zeros(num_pixels, K);
        label_image = zeros(rows, cols);
        label_image(imageMask == 1) = label_vector;
        
        % figure();
        % imshow(label_image, []);
        % title('Label Image');
    
        for i = 1:num_pixels
            curr_r = r_coords(i);
            curr_c = c_coords(i);
            neighbor_labels = [];
            for delta = [-1 0; 1 0; 0 -1; 0 1]'
                nr = curr_r + delta(1);
                nc = curr_c + delta(2);
                if nr >= 1 && nr <= rows && nc >=1 && nc <= cols && imageMask(nr, nc) == 1
                    neighbor_labels(end+1) = label_image(nr, nc);
                end
            end
            for k = 1:K
                smoothness_term(i, k) = -beta * sum(neighbor_labels ~= k);
            end
        end
    
        total_energy = data_term + smoothness_term;
        [~, new_labels] = max(total_energy, [], 2);
        log_posterior(em_iter) = sum(max(total_energy, [], 2));
        if em_iter>1
            if log_posterior(em_iter-1)<log_posterior(em_iter)
                label_vector = new_labels;
            end
        else
            label_vector = new_labels;
        end

        % Step 2: Soft Membership w MRF 
        membership = zeros(num_pixels, K);
        for k = 1:K
            gaussian = (1 / (sqrt(2*pi)*stds(k))) * exp(-0.5 * ((brainPixels - means(k)).^2) / (stds(k)^2));
            smooth_penalty = exp(smoothness_term(:, k));
            membership(:, k) = gaussian .* smooth_penalty;
        end
        membership = membership ./ sum(membership, 2);
    
        %Step 3: Mean update
        for k = 1:3
            numerator = sum(membership(:, k) .* brainPixels);
            denominator = sum(membership(:, k));
            means(k) = numerator / denominator;
        end
    
        %Step 4: Std dev update
        for k = 1:3
            numerator = sum(membership(:, k) .* (brainPixels - means(k)).^2);
            denominator = sum(membership(:, k));
            stds(k) = sqrt(numerator / denominator);
        end

        % EM algorithm convergence criteria
        max_mean_change = max(abs(means - prev_means));
        max_std_change = max(abs(stds - prev_stds));
        if max([max_mean_change, max_std_change]) < tolerance_em
            fprintf('Converged at iteration %d\n', em_iter);
            break;
        end
    end

    final_label_image = zeros(size(imageMask));
    final_label_image(imageMask == 1) = label_vector;
    
    final_means = means;
    final_stds = stds;
    final_mem = membership;
end

