clc; close all; clear;

data1 = load('../../data/assignmentMathImagingRecon_chestCT.mat');
I1 = data1.imageAC;

data2 = load('../../data/assignmentMathImagingRecon_myPhantom.mat');
I2 = data2.imageMyPhantomAC;

figure();
imshow(I1, [])
title('Chest CT (Original)')
saveas(gcf, '../../results/q3/B/chestct_original.png')

figure();
imshow(I2, [])
title('My Phantom (Original)')
saveas(gcf, '../../results/q3/B/myphantom_original.png')

theta1 = 132:132+150;
theta1 = mod(theta1, 180);

theta2 = 20:20+150;
theta2 = mod(theta2, 180);

[R1, t1] = radon(I1,theta1);
[R2, t2] = radon(I2,theta2);

wmax1 = max(t1);
wmax2 = max(t2);

R_cos = myFilter(R1,t1,wmax1,'Cosine');
recon_cos = iradon(R_cos, theta1, 'linear','none',1, 512);
recon_cos = normalize(recon_cos);

R_shepp = myFilter(R2,t2,wmax2,'Shepp-Logan');
recon_shepp = iradon(R_shepp, theta2, 'linear','none',1, 256);
recon_shepp = normalize(recon_shepp);

rmse_cos = rrmse(I1, recon_cos);
rmse_shepp = rrmse(I2, recon_shepp);

figure();
imshow(recon_cos, [])
title('Chest CT (reconstructed)')
saveas(gcf, '../../results/q3/B/chestct_recon.png')

figure();
imshow(recon_shepp, [])
title('My phantom (reconstructed)')
saveas(gcf, '../../results/q3/B/myphantom_recon.png')