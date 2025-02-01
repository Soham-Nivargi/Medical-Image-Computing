img = load('data/assignmentImageDenoising_chestCT.mat');
img = img.imageChestCT;
img = double(img);
img = img - min(img(:));
img = img / max(img(:));

X = get_high_variance_patches(img, 0.05);
params = struct();
params.p = 1;
params.lambda = 0.1;
params.convergence_threshold = 1e-6;
params.lr = 0.01;

D = get_D(X, params);

