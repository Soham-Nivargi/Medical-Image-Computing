function grad_t = log_posterior_grad(alpha, gamma, prior_type, X_in, Y)
    switch prior_type
        case 'A'
            grad = prior_A_grad(X_in);
        case 'B'
            grad = prior_B_grad(X_in);
        case 'C'
            grad = prior_C_grad(X_in, gamma);
    end
    grad_t = (1-alpha) * log_likelihood_grad(X_in, Y) + alpha * grad;
end

