clc; close all; clear;

data1 = load('../../data/assignmentMathImagingRecon_chestCT.mat');
I1 = data1.imageAC;

data2 = load('../../data/assignmentMathImagingRecon_myPhantom.mat');
I2 = data2.imageMyPhantomAC;

theta = -1:149;

for i=0:180
    theta = mod(theta+1, 180);
    [R1, t1] = radon(I1,theta);
    [R2, t2] = radon(I2,theta);

    wmax1 = max(t1);
    wmax2 = max(t2);
    %----------------------------------------------------------------
    R_ramlek1 = myFilter(R1,t1,wmax1,'Ram-Lek');
    R_shepp1 = myFilter(R1,t1,wmax1,'Shepp-Logan');
    R_cos1 = myFilter(R1,t1,wmax1,'Cosine');

    R_ramlek2 = myFilter(R2,t2,wmax2,'Ram-Lek');
    R_shepp2 = myFilter(R2,t2,wmax2,'Shepp-Logan');
    R_cos2 = myFilter(R2,t2,wmax2,'Cosine');
    %----------------------------------------------------------------
    recon_ramlek1 = iradon(R_ramlek1, theta, 'linear','none',1, 512);
    recon_shepp1 = iradon(R_shepp1, theta, 'linear','none',1, 512);
    recon_cos1 = iradon(R_cos1, theta, 'linear','none',1, 512);

    recon_ramlek2 = iradon(R_ramlek2, theta, 'linear','none',1, 256);
    recon_shepp2 = iradon(R_shepp2, theta, 'linear','none',1, 256);
    recon_cos2 = iradon(R_cos2, theta, 'linear','none',1, 256);
    %----------------------------------------------------------------
    recon_ramlek1 = normalize(recon_ramlek1);
    recon_shepp1 = normalize(recon_shepp1);
    recon_cos1 = normalize(recon_cos1);

    recon_ramlek2 = normalize(recon_ramlek2);
    recon_shepp2 = normalize(recon_shepp2);
    recon_cos2 = normalize(recon_cos2);
    %----------------------------------------------------------------
    rmse_ramlek1(i+1) = rrmse(I1, recon_ramlek1);
    rmse_shepp1(i+1) = rrmse(I1, recon_shepp1);
    rmse_cos1(i+1) = rrmse(I1, recon_cos1);

    rmse_ramlek2(i+1) = rrmse(I2, recon_ramlek2);
    rmse_shepp2(i+1) = rrmse(I2, recon_shepp2);
    rmse_cos2(i+1) = rrmse(I2, recon_cos2);
end

figure();
plot(0:180,rmse_ramlek1);
title('Ram-lek Filter RRMSE vs Starting \theta')
xlabel('Starting \theta')
ylabel('RRMSE')
saveas(gcf,'../../results/q3/A/ramlek1.png')

figure();
plot(0:180,rmse_shepp1);
title('Shepp-Logan Filter RRMSE vs Starting \theta')
xlabel('Starting \theta')
ylabel('RRMSE')
saveas(gcf,'../../results/q3/A/shepp1.png')

figure();
plot(0:180,rmse_cos1);
title('Cosine Filter RRMSE vs Starting \theta')
xlabel('Starting \theta')
ylabel('RRMSE')
saveas(gcf,'../../results/q3/A/cosine1.png')
%----------------------------------------------------------------
figure();
plot(0:180,rmse_ramlek2);
title('Ram-lek Filter RRMSE vs Starting \theta')
xlabel('Starting \theta')
ylabel('RRMSE')
saveas(gcf,'../../results/q3/A/ramlek2.png')

figure();
plot(0:180,rmse_shepp2);
title('Shepp-Logan Filter RRMSE vs Starting \theta')
xlabel('Starting \theta')
ylabel('RRMSE')
saveas(gcf,'../../results/q3/A/shepp2.png')

figure();
plot(0:180,rmse_cos2);
title('Cosine Filter RRMSE vs Starting \theta')
xlabel('Starting \theta')
ylabel('RRMSE')
saveas(gcf,'../../results/q3/A/cosine2.png')
%----------------------------------------------------------------
[min_rmse_ram1, min_rmse_idx_ram1] = min(rmse_ramlek1);
[min_rmse_shepp1, min_rmse_idx_shepp1] = min(rmse_shepp1);
[min_rmse_cos1, min_rmse_idx_cos1] = min(rmse_cos1);

[min_rmse_ram2, min_rmse_idx_ram2] = min(rmse_ramlek2);
[min_rmse_shepp2, min_rmse_idx_shepp2] = min(rmse_shepp2);
[min_rmse_cos2, min_rmse_idx_cos2] = min(rmse_cos2);
