function value = myXrayIntegration(image, theta, t, integration_params)
    % Get image size
    [n, m] = size(image);

    % Ensure image is square (optional, depending on your application)
    assert(n == m, 'Image must be square');

    % Center of the image
    x0 = 1 + (n - 1) / 2;
    y0 = 1 + (m - 1) / 2;

    % Integration parameters
    s_step = integration_params.s_step;
    s_range = - (n - 1) * sqrt(2) / 2 : s_step : (n - 1) * sqrt(2) / 2;

    % Initialize value
    value = 0;

    % Create grid for interpolation
    [X, Y] = meshgrid(1:m, 1:n);

    % Perform integration
    for s = s_range
        % Compute (x, y) coordinates
        x = x0 + t * cos(theta) - s * sin(theta);
        y = y0 + t * sin(theta) + s * cos(theta);

        % Interpolate using interp2
        interpolated_value = interp2(X, Y, image, y, x, integration_params.interp_method, NaN);

        % Skip if out of bounds
        if isnan(interpolated_value)
            continue;
        end

        % Accumulate value and count valid samples
        value = value + interpolated_value;
    end
end