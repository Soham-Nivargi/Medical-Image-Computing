function map = log_posterior(alpha, gamma, prior_type, X_in, Y)
    switch prior_type
        case 'A'
            V = prior_A(X_in);
        case 'B'
            V = prior_B(X_in);
        case 'C'
            V = prior_C(X_in, gamma);
    end
    map = (1-alpha) * log_likelihood(X_in, Y) + alpha * V;
end

