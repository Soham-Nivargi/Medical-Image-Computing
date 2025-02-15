clc; clear;
close all;

S0 = phantom(128);

mask1 = fspecial('gaussian', 11, 1);
S1 = conv2(S0, mask1, 'same');

mask2 = fspecial('gaussian', 51, 5);
S5 = conv2(S0, mask2, 'same');


figure();
imshow(S0)
title('S0')
saveas(gcf, '../../results/q2/B/S0.png')


figure();
imshow(S1)
title('S1')
saveas(gcf, '../../results/q2/B/S1.png')


figure();
imshow(S5)
title('S5')
saveas(gcf, '../../results/q2/B/S5.png')

theta = 0:3:177;
[R0,t0] = radon(S0,theta);
[R1,t1] = radon(S1,theta);
[R5,t5] = radon(S5,theta);

w_max0 = max(t0);
w_max1 = max(t1);
w_max5 = max(t5);

R_ramlek0 = myFilter(R0,t0,w_max0,'Ram-Lek');
R_ramlek1 = myFilter(R1,t1,w_max1,'Ram-Lek');
R_ramlek5 = myFilter(R5,t5,w_max5,'Ram-Lek');

recon_0 = 0.5*iradon(R_ramlek0, theta, 'linear','none',1, 128);
recon_1 = 0.5*iradon(R_ramlek1, theta, 'linear','none',1, 128);
recon_5 = 0.5*iradon(R_ramlek5, theta, 'linear','none',1, 128);

recon_0 = normalize(recon_0);
recon_1 = normalize(recon_1);
recon_5 = normalize(recon_5);

figure();
imshow(recon_0, []);
title('R0');
saveas(gcf, '../../results/q2/B/R0.png');

figure();
imshow(recon_1, []);
title('R1');
saveas(gcf, '../../results/q2/B/R1.png');

figure();
imshow(recon_5, []);
title('R5');
saveas(gcf, '../../results/q2/B/R5.png');

rmse0 = rrmse(S0, recon_0);
rmse1 = rrmse(S1, recon_1);
rmse5 = rrmse(S5, recon_5);


