function grad_t = log_posterior_grad(alpha, gamma, prior_type, X_in, Y)
    switch prior_type
        case 'quadratic'
            grad = quad_log_prior_grad(X_in);
        case 'huber'
            grad = huber_log_prior_grad(X_in, gamma);
        case 'discontinuity'
            grad = discont_huber_log_prior_grad(X_in, gamma);
    end
    grad_t = (1-alpha) * log_likelihood_grad(X_in, Y) + alpha * grad;
end

