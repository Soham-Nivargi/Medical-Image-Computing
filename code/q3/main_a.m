clc; close all; clear;

data1 = load('../../data/assignmentMathImagingRecon_chestCT.mat');

I1 = data1.imageAC;

theta = -1:149;

for i=0:180
    theta = mod(theta+1, 180);
    [R, t] = radon(I1,theta);

    wmax = max(t);
    R_ramlek = myFilter(R,t,wmax,'Ram-Lek');
    recon = iradon(R_ramlek, theta, 'linear','none',1, 512);
    rmse(i+1) = rrmse(I1, recon);
end

plot(0:180,rmse);

[min_rmse, min_rmse_idx] = min(rmse);

