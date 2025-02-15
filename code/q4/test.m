f = load("data/assignmentMathImagingRecon_chestCT.mat");
f = f.imageAC;

integration_params = struct("s_step", 1, "interp_method", "linear");

n = size(f, 1);

angle =37;
t = 79;

value = myXrayIntegration(f, angle, t, integration_params);
value2 = dot(get_imaging_row(n, angle, t, integration_params), f(:)');

p = (value - value2)/value;

figure;
imshow(reshape(get_imaging_row(n, angle, t, integration_params), n, n));
title('Weight Matrix from get_imaging_row');
