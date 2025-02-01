function fin = huber(X, gamma)
    mask = abs(X) <= gamma;
    fin = sum(0.5*X.^2 .* mask + (gamma * abs(X) - 0.5 * gamma^2) .* ~mask, "all");
end