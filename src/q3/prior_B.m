function V = prior_B(estimate)
    diff_x1 = estimate - circshift(estimate, [0, 1]);  % Right neighbor
    diff_x2 = estimate - circshift(estimate, [0, -1]); % Left neighbor
    diff_y1 = estimate - circshift(estimate, [1, 0]);  % Down neighbor
    diff_y2 = estimate - circshift(estimate, [-1, 0]); % Up neighbor

    V = sum(L2(diff_x1) + L2(diff_x2) + L2(diff_y1) + L2(diff_y2), "all");
end