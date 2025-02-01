function V = quad_log_prior(estimate)
    diff_x1 = estimate - circshift(estimate, [0, 1]);  % Right neighbor
    diff_x2 = estimate - circshift(estimate, [0, -1]); % Left neighbor
    diff_y1 = estimate - circshift(estimate, [1, 0]);  % Down neighbor
    diff_y2 = estimate - circshift(estimate, [-1, 0]); % Up neighbor

    V = sum(diff_x1(:).^2 + diff_x2(:).^2 + diff_y1(:).^2 + diff_y2(:).^2);
end
