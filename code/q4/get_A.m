function A = get_A(n, ts, angles, integration_params)
    A = zeros(length(ts) * length(angles), n * n);
    for i = 1:length(ts)
        t = ts(i);
        for j = 1:length(angles)
            angle = angles(j) * pi / 180;
            row = get_imaging_row(n, angle, t, integration_params);
            A((i - 1) * length(angles) + j, :) = row;
        end
    end
    A = sparse(A);
end