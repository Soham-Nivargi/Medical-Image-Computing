function V = huber_log_prior(estimate, gamma)
    diff_x1 = estimate - circshift(estimate, [0, 1]);  % Right neighbor
    diff_x2 = estimate - circshift(estimate, [0, -1]); % Left neighbor
    diff_y1 = estimate - circshift(estimate, [1, 0]);  % Down neighbor
    diff_y2 = estimate - circshift(estimate, [-1, 0]); % Up neighbor
   
    mask_x1 = abs(diff_x1) <= gamma;
    mask_x2 = abs(diff_x2) <= gamma;
    mask_y1 = abs(diff_y1) <= gamma;
    mask_y2 = abs(diff_y2) <= gamma;
    
    V = sum(diff_x1.^2 .* mask_x1 + (gamma * abs(diff_x1) - 0.5 * gamma^2) .* ~mask_x1, "all") + ...
        sum(diff_x2.^2 .* mask_x2 + (gamma * abs(diff_x2) - 0.5 * gamma^2) .* ~mask_x2, "all") + ...
        sum(diff_y1.^2 .* mask_y1 + (gamma * abs(diff_y1) - 0.5 * gamma^2) .* ~mask_y1, "all") + ...
        sum(diff_y2.^2 .* mask_y2 + (gamma * abs(diff_y2) - 0.5 * gamma^2) .* ~mask_y2, "all");
end
