function r_new = get_sparse_code_for_patch(x, r, D, params)
    eta = params.lr;
    p = params.p;
    losses = zeros(1, params.max_iter+1);
    loss = loss_r_update(x, r, D, params);
    losses(1) = loss;

    for iter = 1:params.max_iter
        data_grad = -2 * D' * (x - D * r);
        % Save data_grad to workspace
        assignin('base', 'data_grad', data_grad);
        absr = abs(r);
        sign_r = sign(r);
        % save absr and sign_r to workspace
        assignin('base', 'absr', absr);
        assignin('base', 'sign_r', sign_r);
        % save absr.^(p-1) to workspace
        assignin('base', 'absr_p_1', absr.^(p-1));

        reg_grad = params.lambda * p * absr.^(p-1) .* sign_r;
        % cap the reg_grad
        reg_grad(reg_grad > params.cap) = params.cap;
        % Save reg_grad to workspace
        assignin('base', 'reg_grad', reg_grad);
        
        grad = data_grad + reg_grad;
        
        r_new = r - eta * grad;
        
        loss = loss_r_update(x, r_new, D, params);
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
        r = r_new;

    end

    % Save losses to workspace
    assignin('base', 'losses_q4c', losses);
end
