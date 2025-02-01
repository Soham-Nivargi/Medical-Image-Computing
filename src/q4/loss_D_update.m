function loss = loss_D_update(X, R, D)
    % Compute the loss for the given R
    loss = 0;
    for i = 1:size(X, 2)
        x = X(:, i);
        r = R(:, i);
        
        loss = loss + norm(x - D * r, 2)^2;
    end
end