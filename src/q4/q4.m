img = load('data/assignmentImageDenoising_chestCT.mat');
img = img.imageChestCT;
img = double(img);
img = img - min(img(:));
img = img / max(img(:));

X = get_high_variance_patches(img, 0.05);
params = struct();
params.lambda = 0.1;
params.convergence_threshold = 1e-6;
params.lr = 0.01;
params.max_iter = 100;
params.D_init = rand(64, 64);
params.cap = 0.9;

% Save the image of params.D_init as a .png file
figure;
imagesc(params.D_init);
colormap(gray);
title('Initial Dictionary');
saveas(gcf, 'results/q4/initial_dictionary.png');

params.p = 2;
D_2 = get_D(X, params);
params.p = 1.6;
D_16 = get_D(X, params);
params.p = 1.2;
D_12 = get_D(X, params);
params.p = 0.8;
D_08 = get_D(X, params);

% Save D_08 as a .mat file
save('results/q4/D_08.mat', 'D_08');
