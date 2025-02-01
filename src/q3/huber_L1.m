function fin = huber_L1(X, gamma)
    
    mask = abs(X) <= gamma;
    huber_vals = (1/2) * (X.^2) .* mask + ...
                 (delta * (abs(X) - (1/2) * gamma)) .* ~mask;
    fin = sum(huber_vals, 3);
end