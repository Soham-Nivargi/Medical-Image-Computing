function V = quad_log_prior(estimate)
    diff_x1 = estimate - circshift(estimate, [0, 1]);  % Right neighbor
    diff_x2 = estimate - circshift(estimate, [0, -1]); % Left neighbor
    diff_y1 = estimate - circshift(estimate, [1, 0]);  % Down neighbor
    diff_y2 = estimate - circshift(estimate, [-1, 0]); % Up neighbor

    V = quadra(diff_x1) + quadra(diff_x2) + quadra(diff_y1) + quadra(diff_y2);
end

