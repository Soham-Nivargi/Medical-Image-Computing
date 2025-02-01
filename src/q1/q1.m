data = load('../../data/assignmentImageDenoising_phantom.mat');
noiseless = data.imageNoiseless;
noisy = data.imageNoisy;

[rows,cols] = size(noisy);

noisy = noisy/max(noisy(:));
noiseless = noiseless/max(noiseless(:));

figure();
imshow(noiseless);
% saveas(gcf, '../../results/q1/noiseless2.png');
figure();
imshow(noisy);
% saveas(gcf, '../../results/q1/noisy2.png');

imagesc(abs(noisy));        % Show heatmap of magnitude values
colormap jet;              % Use the jet colormap
colorbar;                  % Add a color scale
axis equal;                % Keep aspect ratio
axis tight;                % Fit the axis
saveas(gcf, '../../results/q1/noisy_output.png');

imagesc(abs(noiseless));        % Show heatmap of magnitude values
colormap jet;              % Use the jet colormap
colorbar;                  % Add a color scale
axis equal;                % Keep aspect ratio
axis tight;                % Fit the axis
saveas(gcf, '../../results/q1/noisless_output.png');



err_init = RRMSE(noisy, noiseless);

% Initialize
X_in = noisy;                       
alpha = 0.05;                      
gamma = 0.01;                      
prior_type = 'quadratic';             
step_size = 0.01;

err_1 = RRMSE(X_in, noisy);

X_in = gradient_descent(alpha, gamma, step_size, prior_type, X_in, noisy, noiseless);

imagesc(abs(X_in));        % Show heatmap of magnitude values
colormap jet;              % Use the jet colormap
colorbar;                  % Add a color scale
axis equal;                % Keep aspect ratio
axis tight;                % Fit the axis

% Overlay text labels showing the magnitude of each pixel
% [numRows, numCols] = size(X_in);
% for row = 1:numRows
%     for col = 1:numCols
%         text(col, row, sprintf('%.1f', abs(X_in(row, col))), ...
%             'Color', 'w', 'FontSize', 10, 'FontWeight', 'bold', ...
%             'HorizontalAlignment', 'center');
%     end
% end

saveas(gcf, '../../results/q1/quadratic/quadratic_output.png');

err = RRMSE(X_in, noiseless);
err_2 = RRMSE(X_in, noisy);










