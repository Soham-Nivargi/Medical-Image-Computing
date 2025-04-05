function Y_aligned = mean_rot(X_ref, Y)
    N = size(X_ref, 1);
   
    x = X_ref(:,1); y = X_ref(:,2);
    u = Y(:,1);     v = Y(:,2);
   
    A = [u, -v, ones(N,1), zeros(N,1);
         v,  u, zeros(N,1), ones(N,1)];
    b = [x; y];
   
    params = lsqr(A,b);
    a = params(1); b1 = params(2);
    tx = params(3); ty = params(4);
    
    R = [a, b1; -b1, a]; 
    Y_aligned = (Y * R) + [tx, ty];
end
