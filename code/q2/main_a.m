clc; clear;
close all;

I = phantom(128);
theta = 0:3:177;

figure();
imshow(I)
title('Shepp-Logan Phantom')
saveas(gcf, '../../results/q2/phantom.png')

I_f = fftshift(fft2(I));

[R,t] = radon(I,theta);

figure();
imshow(R,[],'Xdata',theta,'Ydata',t,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('t')
title('Radon Transform of Shepp-Logan Phantom')
colormap(gca,hot), colorbar
saveas(gcf, '../../results/q2/A/radon.png')

w_max = max(t);
%-------------------------------------------------------------------
R_ramlek_full = myFilter(R,t,w_max,'Ram-Lek');
R_ramlek_half = myFilter(R,t,w_max/2,'Ram-Lek');

R_shepp_full = myFilter(R,t,w_max,'Shepp-Logan');
R_shepp_half = myFilter(R,t,w_max/2,'Shepp-Logan');

R_cosine_full = myFilter(R,t,w_max,'Cosine');
R_cosine_half = myFilter(R,t,w_max/2,'Cosine');
%-------------------------------------------------------------------
figure();
imshow(R_ramlek_half,[],'Xdata',theta,'Ydata',t,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('t')
title('Filtered Radon Transform (RamLek Half Width)')
colormap(gca,hot), colorbar
saveas(gcf, '../../results/q2/A/frt_ram_half.png')

figure();
imshow(R_ramlek_full,[],'Xdata',theta,'Ydata',t,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('t')
title('Filtered Radon Transform (RamLek Full Width)')
colormap(gca,hot), colorbar
saveas(gcf, '../../results/q2/A/frt_ram_full.png')
%-------------------------------------------------------------------
figure();
imshow(R_shepp_half,[],'Xdata',theta,'Ydata',t,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('t')
title('Filtered Radon Transform (Shepp-Logan Half Width)')
colormap(gca,hot), colorbar
saveas(gcf, '../../results/q2/A/frt_shepp_half.png')

figure();
imshow(R_shepp_full,[],'Xdata',theta,'Ydata',t,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('t')
title('Filtered Radon Transform (Shepp-Logan Full Width)')
colormap(gca,hot), colorbar
saveas(gcf, '../../results/q2/A/frt_shepp_full.png')
%-------------------------------------------------------------------
figure();
imshow(R_cosine_half,[],'Xdata',theta,'Ydata',t,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('t')
title('Filtered Radon Transform (Cosine Half Width)')
colormap(gca,hot), colorbar
saveas(gcf, '../../results/q2/A/frt_cos_half.png')

figure();
imshow(R_cosine_full,[],'Xdata',theta,'Ydata',t,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('t')
title('Filtered Radon Transform (Cosine Full Width)')
colormap(gca,hot), colorbar
saveas(gcf, '../../results/q2/A/frt_cos_full.png')

%-------------------------------------------------------------------
recon_ramlek_half = 0.5*iradon(R_ramlek_half, theta, 'linear','none', 1, 128);
recon_ramlek_full = 0.5*iradon(R_ramlek_full, theta, 'linear','none', 1, 128);
recon_ramlek_ref = iradon(R, theta, 'linear', 'Ram-Lak', 1, 128);

recon_shepp_half = 0.5*iradon(R_shepp_half, theta, 'linear','none', 1, 128);
recon_shepp_full = 0.5*iradon(R_shepp_full, theta, 'linear','none', 1, 128);
recon_shepp_ref = iradon(R, theta, 'linear', 'Shepp-Logan', 1, 128);

recon_cosine_half = 0.5*iradon(R_cosine_half, theta, 'linear','none', 1, 128);
recon_cosine_full = 0.5*iradon(R_cosine_full, theta, 'linear','none', 1, 128);
recon_cosine_ref = iradon(R, theta, 'linear', 'Cosine', 1, 128);

%-------------------------------------------------------------------
recon_ramlak_half = normalize(recon_ramlek_half);
recon_ramlak_full = normalize(recon_ramlek_full);
recon_ramlak_ref = normalize(recon_ramlek_ref);

recon_shepp_half = normalize(recon_shepp_half);
recon_shepp_full = normalize(recon_shepp_full);
recon_shepp_ref = normalize(recon_shepp_ref);

recon_cosine_half = normalize(recon_cosine_half);
recon_cosine_full = normalize(recon_cosine_full);
recon_cosine_ref = normalize(recon_cosine_ref);
%-------------------------------------------------------------------
figure();
subplot(1,3,1);
imshow(recon_ramlak_ref, []);
title('Reference (Ram-Lek Filter)')
subplot(1,3,2);
imshow(recon_ramlak_full, []);
title('Full width (Ram-Lek Filter)')
subplot(1,3,3);
imshow(recon_ramlak_half, []);
title('Half width (Ram-Lek Filter)')
saveas(gcf, '../../results/q2/A/ramlak_comparison.png')
%-------------------------------------------------------------------
figure();
subplot(1,3,1);
imshow(recon_shepp_ref, []);
title('Reference (Shepp-Logan Filter)')
subplot(1,3,2);
imshow(recon_shepp_full, []);
title('Full width (Shepp-Logan Filter)')
subplot(1,3,3);
imshow(recon_shepp_half, []);
title('Half width (Shepp-Logan Filter)')
saveas(gcf, '../../results/q2/A/shepp_comparison.png')
%-------------------------------------------------------------------
figure();
subplot(1,3,1);
imshow(recon_cosine_ref, []);
title('Reference (Cosine Filter)')
subplot(1,3,2);
imshow(recon_cosine_full, []);
title('Full width (Cosine Filter)')
subplot(1,3,3);
imshow(recon_cosine_half, []);
title('Half width (Cosine Filter)')
saveas(gcf, '../../results/q2/A/cosine_comparison.png')
%-------------------------------------------------------------------
figure();
imshow(recon_ramlak_full, []);
title('Ram-Lak Full Width Reconstruction')
saveas(gcf, '../../results/q2/A/ramlak_full.png')

figure();
imshow(recon_ramlak_half, []);
title('Ram-Lak Half Width Reconstruction')
saveas(gcf, '../../results/q2/A/ramlak_half.png')

figure();
imshow(recon_ramlak_ref, []);
title('Ram-Lak Reference Reconstruction')
saveas(gcf, '../../results/q2/A/ramlak_ref.png')
%-------------------------------------------------------------------
figure();
imshow(recon_shepp_full, []);
title('Shepp-Logan Full Width Reconstruction')
saveas(gcf, '../../results/q2/A/shepp_full.png')

figure();
imshow(recon_shepp_half, []);
title('Shepp-Logan Half Width Reconstruction')
saveas(gcf, '../../results/q2/A/shepp_half.png')

figure();
imshow(recon_shepp_ref, []);
title('Shepp-Logan Reference Reconstruction')
saveas(gcf, '../../results/q2/A/cosine_ref.png')
%-------------------------------------------------------------------
figure();
imshow(recon_cosine_full, []);
title('Cosine Full Width Reconstruction')
saveas(gcf, '../../results/q2/A/cosine_full.png')

figure();
imshow(recon_cosine_half, []);
title('Cosine Half Width Reconstruction')
saveas(gcf, '../../results/q2/A/cosine_half.png')

figure();
imshow(recon_cosine_ref, []);
title('Cosine Reference Reconstruction')
saveas(gcf, '../../results/q2/A/cosine_ref.png')



