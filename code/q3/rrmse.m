function error = rrmse(A, B)
    error = sqrt(sum((A(:) - B(:)).^2) / sum(A(:).^2));
end

