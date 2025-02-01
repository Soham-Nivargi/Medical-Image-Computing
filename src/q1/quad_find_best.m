% Load the images
data = load('../../data/assignmentImageDenoising_phantom.mat');
noiseless = data.imageNoiseless;
noisy = data.imageNoisy;

[rows,cols] = size(noisy);

noisy = noisy/max(noisy(:));
noiseless = noiseless/max(noiseless(:));

min_err = 0;

for alpha= 0.01:1.00
    % Initialize
    X_in = noisy;                     
    gamma = 0.15;                      
    prior_type = 'huber';             % Choose 'quadratic', 'huber', or 'discontinuity'
    step_size = 0.01;                    % Initial step size (this can be adjusted)
    
    X_in = gradient_descent(alpha, gamma, step_size, prior_type, X_in, noisy, noiseless);
    
    figure();
    imshow(X_in);
    saveas(gcf, '../../results/denoised2.png');
    
    err = RRMSE(X_in, noiseless);
end










