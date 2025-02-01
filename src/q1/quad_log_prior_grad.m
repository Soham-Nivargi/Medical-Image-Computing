function grad = quad_log_prior_grad(estimate)
    grad = 2*(4 * estimate - (circshift(estimate, [0, 1]) + circshift(estimate, [0, -1]) + circshift(estimate, [1, 0]) + circshift(estimate, [-1, 0])));
end
