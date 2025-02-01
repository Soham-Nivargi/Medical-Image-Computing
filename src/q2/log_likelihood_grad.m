function grad = log_likelihood_grad(estimate, observed)
    % grad = estimate-besseli(1,observed .* estimate)./besseli(0,observed .* estimate).*observed;
    grad = estimate-observed;
end
