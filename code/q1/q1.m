f = phantom(128);

integration_params = struct();
integration_params.s_step = 1;
integration_params.interp_method = 'bicubic';

ts = -90:5:90;
angles = 0:5:175;

% radon_transform = myXrayCTRadonTransform(f, integration_params);

delta_s = [0.5 1 3];

for ds = delta_s
    integration_params.s_step = ds;
    radon_transform = myXrayCTRadonTransform(f, integration_params);
    figure;
    imagesc(radon_transform);
    title(['Radon Transform with s step = ' num2str(ds)]);
    xlabel('Angle (degrees)');
    ylabel('t');
    xticks(1:36);
    xticklabels(angles);
    yticks(1:37);
    yticklabels(ts);
    colorbar;
    
    % Create a folder to save the results if it does not exist
    if ~exist(['results/q1/step_size_' strrep(num2str(ds), '.', '_')], 'dir')
        mkdir(['results/q1/step_size_' strrep(num2str(ds), '.', '_')]);
    end

    % Save this figure
    saveas(gcf, ['results/q1/step_size_' strrep(num2str(ds), '.', '_') '/radon.png']);

    % Extract radon transform corresponding to angle 0 and 90
    radon_transform_0 = radon_transform(:, 1);
    radon_transform_90 = radon_transform(:, 19);

    % plot the radon transform for angle 0 and 90 and save the figure
    figure;
    plot(ts, radon_transform_0);
    title(['Radon Transform for angle 0 with s step = ' num2str(ds)]);
    xlabel('t');
    ylabel('Radon Transform');
    saveas(gcf, ['results/q1/step_size_' strrep(num2str(ds), '.', '_') '/radon_0.png']);

    figure;
    plot(ts, radon_transform_90);
    title(['Radon Transform for angle 90 with s step = ' num2str(ds)]);
    xlabel('t');
    ylabel('Radon Transform');
    saveas(gcf, ['results/q1/step_size_' strrep(num2str(ds), '.', '_') '/radon_90.png']);

end