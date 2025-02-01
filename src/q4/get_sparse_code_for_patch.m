function r_new = get_sparse_code_for_patch(x, r, D, params)
    eta = params.lr;
    p = params.p;
    for iter = 1:20
        data_grad = -2 * D' * (x - D * r);
        absr = abs(r);
        sign_r = sign(r);
        reg_grad = params.lambda * params.p * absr.^(p-1) .* sign_r;
        grad = data_grad + reg_grad;

        r_new = r - eta * grad;

        if norm(r_new - r, 2) < params.convergence_threshold
            break;
        end
        r = r_new;

    end
