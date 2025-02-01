function D = get_D(X, params)
    % Start with a random initialization for D which is a 64 by 64 matrix
    D = params.D_init;
    if params.p < 1
        R = rand(64, size(X, 2));
    else
        R = zeros(64, size(X, 2));
    end
    losses = zeros(1, params.max_iter + 1);
    losses(1) = loss_function(X, R, D, params);

    for i = 1:params.max_iter
        D = update_D(X, R, D, params);
        R = update_R(X, R, D, params);
        loss = loss_function(X, R, D, params);
        losses(i+1) = loss;
    end

    % Plot the loss
    figure;
    plot(losses);
    title('Loss vs Iteration');
    xlabel('Iteration');
    ylabel('Loss');

    % Save figure as a .png file with name based on params.p. params.p may have a decimal point, so we convert it to a string and replace the decimal point with an underscore
    saveas(gcf, strcat('results/q4/loss_vs_iter_p_', strrep(num2str(params.p), '.', '_'), '.png'));


    % Save losses to workspace
    assignin('base', 'losses', losses);

    % create a histogram for the obtained R
    figure;
    histogram(R(:), 100);
    title('Histogram of R');
    xlabel('Value');
    ylabel('Frequency');
    % save based on the value of params.p
    saveas(gcf, strcat('results/q4/histogram_R_p_', strrep(num2str(params.p), '.', '_'), '.png'));

    % Save the image of D as a .png file with the name D_{params.p}.png
    figure;
    imagesc(D);
    colormap(gray);
    title('Learned Dictionary');
    % params.p may have a decimal point, so we convert it to a string and replace the decimal point with an underscore
    saveas(gcf, strcat('results/q4/D_', strrep(num2str(params.p), '.', '_'), '.png'));
end