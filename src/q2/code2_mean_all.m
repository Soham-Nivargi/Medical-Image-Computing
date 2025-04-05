function Y_aligned = code2_mean_all(X_ref, Y)
    N = size(X_ref, 1);
    
    % Columns
    x = X_ref(:,1); y = X_ref(:,2);
    u = Y(:,1);     v = Y(:,2);
    
    % Matrix and vector
    A = [u, -v, ones(N,1), zeros(N,1);
         v,  u, zeros(N,1), ones(N,1)];
    b = [x; y];
    
    % Solve least-squares
    params = lsqr(A,b);
    a = params(1); b1 = params(2);
    tx = params(3); ty = params(4);
    
    % Transform
    R = [a, b1; -b1, a]; % this includes scale
    Y_aligned = (Y * R) + [tx, ty];
end
