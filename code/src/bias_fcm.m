function [U, centers] = bias_fcm(X, C, q, bias, mask, max_iter, epsilon)
    if nargin < 7, epsilon = 1e-5; end
    if nargin < 6, max_iter = 100; end
    if nargin < 5, q = 2; end

    N = size(X, 1);
    d = size(X, 2);
    
    % Random initial membership matrix
    U = rand(C, N);
    U = U ./ sum(U, 1);

    for iter = 1:max_iter
        U_old = U;
        
        % Compute cluster centers
        Um = U.^q;
        centers = (Um * X) ./ sum(Um, 2);
        
        % Update distances
        dist = zeros(N, C);
        for k = 1:C
            dist(:,k) = (X - centers(k)).^2';
        end
        dist = max(dist, 1e-10);
        
        % Update membership
        tmp = dist .^ (-1 / (q - 1));
        U = (tmp ./ sum(tmp, 2))';
        
        % Convergence
        if norm(U - U_old, 'fro') < epsilon
            break;
        end
    end

    U = U';          % (N x C)
    centers = centers; % (C x d)
end
