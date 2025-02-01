function grad = huber_log_prior_grad(estimate, gamma)
    diff_x1 = estimate - circshift(estimate, [0, 1]);  % Right neighbor
    diff_x2 = estimate - circshift(estimate, [0, -1]); % Left neighbor
    diff_x3 = estimate - circshift(estimate, [1, 0]);  % Down neighbor
    diff_x4 = estimate - circshift(estimate, [-1, 0]); % Up neighbor

    % Apply Huber gradient function
    grad = zeros(size(estimate));
    
    for diff_x = {diff_x1, diff_x2, diff_x3, diff_x4}
        d = diff_x{:};
        grad = grad + (abs(d) <= gamma) .* (d) + (abs(d) > gamma) .* gamma .* sign(d);
    end
end
