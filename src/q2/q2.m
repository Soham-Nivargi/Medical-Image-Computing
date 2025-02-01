data = load('../../data/assignmentImageDenoising_brainMRIslice.mat');
noiseless = data.brainMRIsliceOrig;
noisy = data.brainMRIsliceNoisy;

[rows,cols] = size(noisy);

noisy = noisy/max(noisy(:));
noiseless = noiseless/max(noiseless(:));

figure();
imshow(noiseless);
saveas(gcf, '../../results/q2/noiseless2.png');
figure();
imshow(noisy);
saveas(gcf, '../../results/q2/noisy2.png');

imagesc(abs(noisy));        % Show heatmap of magnitude values
colormap jet;              % Use the jet colormap
colorbar;                  % Add a color scale
axis equal;                % Keep aspect ratio
axis tight;                % Fit the axis
saveas(gcf, '../../results/q2/noisy_output.png');

imagesc(abs(noiseless));        % Show heatmap of magnitude values
colormap jet;              % Use the jet colormap
colorbar;                  % Add a color scale
axis equal;                % Keep aspect ratio
axis tight;                % Fit the axis
saveas(gcf, '../../results/q2/noisless_output.png');

err_init = RRMSE(noisy, noiseless);

% Initialize
X_in = noisy;                       
alpha = 0.95;                      
gamma = 0.01*0.8;                      
prior_type = 'huber';             
step_size = 0.01;

err_1 = RRMSE(X_in, noisy);

X_in = gradient_descent(alpha, gamma, step_size, prior_type, X_in, noisy, noiseless);

figure();
imshow(abs(X_in));
% saveas(gcf, '../../results/q2/huber/huber_denoised.png');

imagesc(abs(X_in));        % Show heatmap of magnitude values
colormap jet;              % Use the jet colormap
colorbar;                  % Add a color scale
axis equal;                % Keep aspect ratio
axis tight;                % Fit the axis
% saveas(gcf, '../../results/q2/huber/huber_output.png');

err = RRMSE(X_in, noiseless);
err_2 = RRMSE(X_in, noisy);










