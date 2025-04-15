% BCEFCM_S: Simple 1D Example Implementation
% -----------------------------------------
% Observed image
I = [0.8, 1.0, 1.2, 1.3];           % Scalar intensities
N = length(I);
C = 2;                              % Number of clusters
q = 2;                              % Fuzzifier
alpha = 100;                        % Spatial weight
NR = 2;                             % Number of neighbors (symmetric)
lambda = ones(1, C);                % Equal cluster weights

% Initialize
u = rand(C, N);
u = u ./ sum(u);                    % Normalize memberships
c = [1.0, 1.3];                     % Initial cluster centers
b = ones(1, N);                     % Initial bias field

max_iter = 10;
for iter = 1:max_iter
    % ---- Step 1: Update Cluster Centers ----
    for i = 1:C
        num = sum((I .* b) .* u(i,:).^q);
        den = sum((b.^2) .* u(i,:).^q);
        c(i) = num / den;
    end

    % ---- Step 2: Update Bias Field ----
    for x = 1:N
        num = 0;
        den = 0;
        for i = 1:C
            num = num + lambda(i) * (I(x) * c(i)) * u(i,x)^q;
            den = den + lambda(i) * (c(i)^2) * u(i,x)^q;
        end
        b(x) = num / den;
    end

    % ---- Step 3: Smooth Bias with Average Filter ----
    b_smooth = b;
    for x = 2:N-1
        b_smooth(x) = mean(b(x-1:x+1));
    end
    b = b_smooth;

    % ---- Step 4: Update Memberships ----
    for x = 1:N
        D = zeros(1, C);
        penalty = zeros(1, C);

        for i = 1:C
            % Distance term
            D(i) = (I(x) - b(x) * c(i))^2;

            % Penalty from neighbors
            neigh = max(1, x-1):min(N, x+1);
            penalty(i) = sum((1 - u(i,neigh)).^q);
        end

        % Unnormalized memberships
        tmp = zeros(1, C);
        for i = 1:C
            tmp(i) = (lambda(i)*D(i) + (alpha/NR)*lambda(i)*penalty(i))^(1/(1-q));
        end

        % Normalize memberships
        u(:,x) = tmp / sum(tmp);
    end

    % ---- Display ----
    fprintf('\nIteration %d\n', iter);
    fprintf('Centroids: %.4f  %.4f\n', c(1), c(2));
    fprintf('Bias     : %.4f  %.4f  %.4f  %.4f\n', b);
    fprintf('Memberships:\n');
    disp(u)
end

% Final hard segmentation
[~, seg] = max(u);
disp('Final segmentation:');
disp(seg);
