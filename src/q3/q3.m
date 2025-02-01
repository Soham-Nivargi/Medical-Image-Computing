data = load('../../data/assignmentImageDenoising_microscopy.mat');
noiseless = double(data.microscopyImageOrig);
noisy = double(data.microscopyImageNoisyScale350sigma0point06);

[rows,cols] = size(noisy);

noisy = noisy/max(noisy(:));
noiseless = noiseless/max(noiseless(:));

% figure();
% imshow(noiseless);
% saveas(gcf, '../../results/q3/noiseless2.png');
% figure();
% imshow(noisy);
% saveas(gcf, '../../results/q3/noisy2.png');

err_init = RRMSE(noisy, noiseless);

% Initialize
X_in = noisy;                       
alpha = 0.23;               
gamma = 0.01;                      
prior_type = 'A';             
step_size = 0.1;

err_1 = RRMSE(X_in, noisy);

X_in = gradient_descent(alpha, gamma, step_size, prior_type, X_in, noisy, noiseless);

figure();
imshow(abs(X_in));
saveas(gcf, '../../results/q3/A/A_denoised.png');

err = RRMSE(X_in, noiseless);
err_2 = RRMSE(X_in, noisy);










