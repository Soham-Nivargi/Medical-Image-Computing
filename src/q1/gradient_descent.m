function X_in = gradient_descent(alpha, gamma, step_size, prior_type, X_in, noisy, noiseless)

    prev_lp = log_posterior(alpha, gamma, prior_type, X_in, noisy);  % Initial log-posterior
    
    % Gradient descent loop
    for iter = 1:150
        grad = log_posterior_grad(alpha, gamma, prior_type, X_in, noisy);  % Compute the gradient
        
        % Update X (gradient descent)
        X_in = X_in - step_size * grad;  % Subtract gradient to minimize log-posterior
        
        X_in = X_in / max(X_in(:));
        new_lp = log_posterior(alpha, gamma, prior_type, X_in, noisy);  % New log-posterior
    
	    if new_lp/prev_lp < 1
		    step_size = step_size * 1.1;
        else
		    step_size = step_size * 0.5;
        end
    
        if abs(new_lp-prev_lp) < 1e-8 % If change in log-posterior is very small, stop
            disp(['Converged at iteration ', num2str(iter)]);
            break;
        end
        prev_lp = new_lp;
        % Adaptive step size
        % if new_lp < prev_lp  % If the log-posterior decreases, accept the update
        %     X_in = X_new;  % Accept new X
        %     prev_lp = new_lp;  % Update previous log-posterior
        %     step_size = step_size * 1.1;  % Increase step size
        % else  % If the log-posterior increases, decrease step size
        %     step_size = step_size * 0.5;  % Decrease step size
        % end
        
        if mod(iter, 10) == 0
            fprintf('Iteration %d, Objective Value: %.4f\n', iter, new_lp);
        end
    
    end   
end









