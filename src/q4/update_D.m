function D = update_D(X, R, D_init, params)
    D = D_init;
    eta = params.lr;

    losses = zeros(1, params.max_iter+1);

    % Compute loss for initial D
    loss = loss_D_update(X, R, D);
    losses(1) = loss;

    for iter = 1:params.max_iter

        % Save R to workspace
        assignin('base', 'R', R);

        % Save D to workspace
        assignin('base', 'D', D);

        grad = -2 * (X - D * R) * R';

        % store grad to workspace
        assignin('base', 'grad', grad);

        D_new = D - eta * grad;
        
        % normalize atoms
        for k = 1:size(D_new, 2)
            atom = D_new(:, k);
            norm_atom = norm(atom);
            D_new(:, k) = atom / norm_atom;
        end
        
        loss = loss_D_update(X, R, D_new);
        losses(iter+1) = loss;

        % Update learning rate
        if iter > 1
            if losses(iter+1) > losses(iter)
                eta = eta / 2;
            else
                eta = eta * 1.1;
            end
        end

        % Check convergence
        if iter > 1 && abs(losses(iter+1) - losses(iter)) < params.convergence_threshold
            break;
        end
        D = D_new;
    end
end