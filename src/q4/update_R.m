function R = update_R(X, R_init, D, params)
    % Update the sparse codes for all patches
    R = R_init;
    for i = 1:size(X, 2)
        x = X(:, i);

        r = R(:, i);

        r = get_sparse_code_for_patch(x, r, D, params);

        R(:, i) = r;
    end
end