% Load the images
data = load('../../data/assignmentImageDenoising_phantom.mat');
noiseless = data.imageNoiseless;
noisy = data.imageNoisy;

[rows,cols] = size(noisy);

noisy = noisy/max(noisy(:));
noiseless = noiseless/max(noiseless(:));

min_alpha = 0;

min_err = inf;  
prior_type = 'huber';

list_plot = zeros([100 100]);
i=1;
j=1;

for alpha = 0.01:0.01:1.00
    for gamma = 0.01:0.01:1.00
        X_in = noisy;            
        step_size = 0.01;                    % Initial step size (this can be adjusted)
        
        X_in = gradient_descent(alpha, gamma, step_size, prior_type, X_in, noisy, noiseless);
        
        % figure();
        % imshow(X_in);
        % saveas(gcf, '../../results/denoised2.png');
        
        err = RRMSE(X_in, noiseless);
        if(err<min_err)
           min_alpha = alpha;
           min_gamma = gamma;
           min_err = err;
        end
        list_plot(i) = err;
        i = i+1;
    end
    j = j+1;
end

figure();
% imagesc(matrix);       % Display heatmap
% colorbar;              % Add color scale
% colormap jet;          % Set colormap (options: jet, parula, hot, etc.)
% axis equal;            % Keep aspect ratio









