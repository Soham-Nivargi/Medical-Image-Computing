function x = myART(x0, permutation, b, ts, angles, art_params, integration_params)
    lambda = art_params.lambda;
    max_iter = art_params.max_iter;
    global_tol = art_params.tol;
    
    x = x0;
    n = sqrt(length(x0));
    for iter = 1:max_iter
        x_old = x;
        for i = permutation
            angle = angles(floor((i-1)/length(ts)) + 1);
            t_idx = mod(i-1, length(ts)) + 1;
            t = ts(t_idx);
            a_i = get_imaging_row(n, angle, t, integration_params);
            
            % ART update
            residual = b(i) - dot(a_i, x);
            x = x + lambda * residual * a_i / norm(a_i)^2;
        end
        
        % Global convergence check
        if norm(x - x_old) < global_tol
            disp(['Converged at iteration ', num2str(iter)]);
            break;
        end
        if iter == max_iter
            disp('Maximum iterations reached');
        end
    end
end
