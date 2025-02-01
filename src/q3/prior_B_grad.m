function grad = prior_B_grad(estimate)
    diff_x1 = estimate - circshift(estimate, [0, 1]);  % Right neighbor
    diff_x2 = estimate - circshift(estimate, [0, -1]); % Left neighbor
    diff_y1 = estimate - circshift(estimate, [1, 0]);  % Down neighbor
    diff_y2 = estimate - circshift(estimate, [-1, 0]); % Up neighbor

    grad = (diff_x1+diff_x2+diff_y1+diff_y2);
end