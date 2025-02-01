function loss = loss_function(X, R, D, params)
    % Compute the loss for the given R and D
    loss = 0;
    p = params.p;
    for i = 1:size(X, 2)
        x = X(:, i);
        r = R(:, i);
        
        loss = loss + norm(x - D * r, 2)^2 + norm(r, p)^p;
    end
end