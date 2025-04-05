function Y_aligned = code1_mean_rot(X_ref, Y)
    A = Y' * X_ref;
    [U, ~, V] = svd(A);
    R = U * V';
    if abs(det(R)+1)<= 1e-6
        I = [1 0; 0 -1];
        R = U * I * V';
    end

    if abs(det(R)-1)>1e-6
        m=1;
    end
    Y_aligned = Y * R;
end