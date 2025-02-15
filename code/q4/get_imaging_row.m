function row = get_imaging_row(n, angle, t, integration_params)
    weight_matrix = zeros(n, n);
    x0 = 1 + (n - 1) / 2;
    y0 = 1 + (n - 1) / 2;

    s_step = integration_params.s_step;
    s_range = - (n - 1) * sqrt(2) / 2 : s_step : (n - 1) * sqrt(2) / 2;

    for s = s_range
        x = x0 + t * cos(angle) - s * sin(angle);
        y = y0 + t * sin(angle) + s * cos(angle);

        x_round = round(x);
        y_round = round(y);

        if (x_round < 1 || x_round > n || y_round < 1 || y_round > n)
            continue;
        end

        weight_matrix(x_round, y_round) = weight_matrix(x_round, y_round) + 1;
    end

    row = weight_matrix(:)';    
end