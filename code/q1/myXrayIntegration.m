function value = myXrayIntegration(image, theta, t, integration_params)
    n = size(image, 1);
    m = size(image, 2);

    assert (n == m, 'Image must be square');

    x0 = 1 + (n - 1) / 2;
    y0 = 1 + (m - 1) / 2;

    s_step = integration_params.s_step;
    s_range = - (n - 1) * sqrt(2) / 2 : s_step : (n - 1) * sqrt(2) / 2;

    value = 0;
    for s = s_range
        x = x0 + t * cos(theta) - s * sin(theta);
        y = y0 + t * sin(theta) + s * cos(theta); % theta is in radians

        if (x < 1 || x > n || y < 1 || y > m)
            continue;
        end

        % Using interp2 and set interpolation method
        value = value + interp2(image, x, y, integration_params.interp_method, 0);

    end
end