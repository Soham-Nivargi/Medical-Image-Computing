f = load('data/assignmentMathImagingRecon_chestCT.mat');
f = f.imageAC;

integration_params = struct('s_step', 1, 'interp_method', 'linear');

n = size(f, 1);

angles = 0:10:170;
ts = -90:10:90;

% A = get_A(n, ts, angles, integration_params);
disp('Acquiring Radon Transform');

% acquired_radon_transform = myXrayCTRadonTransform(f, integration_params, ts, angles);

% b = acquired_radon_transform(:);

% add noise to b, Gaussian noise with a standard deviation that is 5% of the intensity range in the data
% b = b + 0.05 * (max(b) - min(b)) * randn(size(b));

disp('Radon Transform acquired');

% % save b
% save('results/q4/b.mat', 'b');

% load b
load('results/q4/b.mat');

x0 = zeros(1, n*n);
permutation = randperm(length(angles) * length(ts));

art_params = struct('lambda', 0.1, 'tol', 1e-3, 'max_iter', 1000);

x = myART(x0, permutation, b, ts, angles, art_params, integration_params);

% reshape x to n x n
x = reshape(x, n, n);

% Plot grayscale images of f and x
figure;
subplot(1, 2, 1);
imagesc(f);
title('Original Image');
colormap gray;
axis image;

subplot(1, 2, 2);
imagesc(x);
title('Reconstructed Image');
colormap gray;
axis image;