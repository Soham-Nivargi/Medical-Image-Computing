function loss = loss_r_update(X, R, D, params)
    % Compute the loss for the given D
    p = params.p;
    loss = 0;
    for i = 1:size(X, 2)
        x = X(:, i);
        r = R(:, i);
        loss = loss + norm(x - D * r, 2)^2 + params.lambda * norm(r, p)^p;
    end
end