function V = huber_log_prior(X, gamma)
    diff_x = circshift(X, [0, -1]) - X;
    diff_y = circshift(X, [-1, 0]) - X;
   
    mask_x = abs(diff_x) <= gamma;
    mask_y = abs(diff_y) <= gamma;
    
    V = sum(diff_x.^2 .* mask_x + (gamma * abs(diff_x) - 0.5 * gamma^2) .* ~mask_x, "all") + ...
        sum(diff_y.^2 .* mask_y + (gamma * abs(diff_y) - 0.5 * gamma^2) .* ~mask_y, "all");
end
