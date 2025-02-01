function D = update_D(X, R, D_init, params)
    D = D_init;
    eta = params.lr;

    for iter = 1:20      
        grad = -2 * (X - D * R) * R';
        D_new = D - eta * grad;
        
        % normalize atoms
        for k = 1:size(D_new, 2)
            atom = D_new(:, k);
            norm_atom = norm(atom);
            if norm_atom > 1
                D_new(:, k) = atom / norm_atom;
            end
        end
        
        % Check convergence
        delta = norm(D_new - D, 'fro');
        if delta < params.convergence_threshold
            break;
        end
        D = D_new;
    end
    end