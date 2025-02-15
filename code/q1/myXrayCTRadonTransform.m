function radon_transform = myXrayCTRadonTransform(f, integration_params)
    ts = -90:5:90;
    angles = 0:5:175;

    % initialize radon_transform matrix of size len(ts) x len(angles)
    radon_transform = zeros(length(ts), length(angles));

    for i = 1:length(ts)
        t = ts(i);
        for j = 1:length(angles)
            theta = angles(j) * pi / 180;
            radon_transform(i, j) = myXrayIntegration(f, theta, t, integration_params);
        end
    end
end