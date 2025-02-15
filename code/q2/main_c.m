clc; clear;
close all;

S0 = phantom(128);

mask1 = fspecial('gaussian', 11, 1);
S1 = conv2(S0, mask1, 'same');

mask2 = fspecial('gaussian', 51, 5);
S5 = conv2(S0, mask2, 'same');

theta = 0:3:177;
[R0,t0] = radon(S0,theta);
[R1,t1] = radon(S1,theta);
[R5,t5] = radon(S5,theta);

w_max0 = max(t0);
w_max1 = max(t1);
w_max5 = max(t5);

for i=1:50
    R_ramlek0 = myFilter(R0,t0,w_max0*i/50,'Ram-Lek');
    R_ramlek1 = myFilter(R1,t1,w_max1*i/50,'Ram-Lek');
    R_ramlek5 = myFilter(R5,t5,w_max5*i/50,'Ram-Lek');
    
    recon_0 = iradon(R_ramlek0, theta, 'linear','none',1, 128);
    recon_1 = iradon(R_ramlek1, theta, 'linear','none',1, 128);
    recon_5 = iradon(R_ramlek5, theta, 'linear','none',1, 128);

    recon_0 = normalize(recon_0);
    recon_1 = normalize(recon_1);
    recon_5 = normalize(recon_5);
    
    rmse0(i) = rrmse(S0, recon_0);
    rmse1(i) = rrmse(S1, recon_1);
    rmse5(i) = rrmse(S5, recon_5);
end

x = 1:50;

figure();
plot(x, rmse0);
title('RRMSE vs L')
xlabel('L (In units of w_{max}/50)')
ylabel('RRMSE')
saveas(gcf, '../../results/q2/C/S0R0.png')

figure();
plot(x, rmse1);
title('RRMSE vs L')
xlabel('L (In units of w_{max}/50)')
ylabel('RRMSE')
saveas(gcf, '../../results/q2/C/S1R1.png')

figure();
plot(x, rmse5);
title('RRMSE vs L')
xlabel('L (In units of w_{max}/50)')
ylabel('RRMSE')
saveas(gcf, '../../results/q2/C/S5R5.png')
