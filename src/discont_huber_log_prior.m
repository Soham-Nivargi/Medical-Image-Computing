function V = discont_huber_log_prior(X, gamma)
    diff_x = circshift(X, [0, -1]) - X;
    diff_y = circshift(X, [-1, 0]) - X;

    V = sum(gamma * abs(diff_x) - gamma^2 * log(1 + abs(diff_x)/gamma), "all") + ...
        sum(gamma * abs(diff_y) - gamma^2 * log(1 + abs(diff_y)/gamma), "all");
end
