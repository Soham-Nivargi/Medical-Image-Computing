function [U, centers] = conv_fcm(X, C, q, max_iter, tol)
    if nargin < 5, tol = 1e-5; end
    if nargin < 4, max_iter = 100; end
    if nargin < 3, q = 2; end

    N = size(X, 1);
    d = size(X, 2);
    
    
    % Random initial membership matrix
    U = rand(C, N);
    U = U ./ sum(U, 1);

    Um = U.^q;
    centers = (Um * X) ./ sum(Um, 2);
    
    % Update distances
    dist = zeros(N, C);
    for k = 1:C
        dist(:,k) = (X - centers(k)).^2';
    end
    dist = max(dist, 1e-10);
    objective = compute_obj(dist, (U.^q)');
    objective_plot = [];

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
        % Convergence using objective function
        objective_new = compute_obj(dist, (U.^q)');
        objective_plot = [objective_plot, objective_new];
        if abs(objective - objective_new) < tol
            break;
        end
        objective = objective_new;
        disp(objective);
    end
    figure;
    plot(objective_plot, 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('Objective function');
    title('Iterative update of the objective function');
    grid on;
    saveas(gcf,'../results/mri/conv_fcm/obj.png');

    U = U';          % (N x C)
    centers = centers; % (C x d)
end
