function D = get_D(X, params)
    % Start with a random initialization for D which is a 64 by 64 matrix
    D = rand(64, 64);
    R = zeros(64, size(X, 2));

    for i = 1:20
        D = update_D(X, R, D, params);
        R = update_R(X, R, D, params);
    end
