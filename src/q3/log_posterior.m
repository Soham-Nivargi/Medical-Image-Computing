function map = log_posterior(alpha, gamma, prior_type, X_in, Y)
    switch prior_type
        case 'quadratic'
            V = quad_log_prior(X_in);
        case 'huber'
            V = huber_log_prior(X_in, gamma);
        case 'discontinuity'
            V = discont_huber_log_prior(X_in, gamma);
    end
    map = (1-alpha) * log_likelihood(X_in, Y) + alpha * V;
end

