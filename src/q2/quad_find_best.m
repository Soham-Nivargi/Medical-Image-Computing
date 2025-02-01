data = load('../../data/assignmentImageDenoising_brainMRIslice.mat');
noiseless = data.brainMRIsliceOrig;
noisy = data.brainMRIsliceNoisy;

[rows,cols] = size(noisy);

noisy = noisy/max(noisy(:));
noiseless = noiseless/max(noiseless(:));

min_alpha = 0;

min_err = inf;
gamma = 0.15;  
prior_type = 'quadratic';

list_plot = zeros([100 1]);
i=1;
for alpha = 0.01:0.01:1.00
    X_in = noisy;            
    step_size = 0.01;                    % Initial step size (this can be adjusted)
    
    X_in = gradient_descent(alpha, gamma, step_size, prior_type, X_in, noisy, noiseless);
    
    % figure();
    % imshow(X_in);
    % saveas(gcf, '../../results/denoised2.png');
    
    err = RRMSE(X_in, noiseless);
    if(err<min_err)
       min_alpha = alpha;
       min_err = err;
    end
    list_plot(i) = err;
    i = i+1;
end

figure();
plot(list_plot);









