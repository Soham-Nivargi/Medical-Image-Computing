function noise = log_likelihood(estimate, observed)
    % noise = 0.5 * sum(estimate(:).^2) - sum(log(besseli(0, observed(:) .* estimate(:))));
    noise = sum((estimate(:)-observed(:)).^2);
end

