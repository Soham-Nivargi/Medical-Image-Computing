function V = huber_log_prior(estimate, gamma)
    diff_x1 = estimate - circshift(estimate, [0, 1]);  % Right neighbor
    diff_x2 = estimate - circshift(estimate, [0, -1]); % Left neighbor
    diff_y1 = estimate - circshift(estimate, [1, 0]);  % Down neighbor
    diff_y2 = estimate - circshift(estimate, [-1, 0]); % Up neighbor
  
    V = huber(diff_x1, gamma) + huber(diff_x2, gamma) + huber(diff_y1, gamma) + huber(diff_y2, gamma);
end


