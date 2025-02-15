clc; clear;
close all;

I = phantom(128);
theta = 0:3:177;

I_f = fftshift(fft2(I));

[R,t] = radon(I,theta);

figure();
imshow(R,[],'Xdata',theta,'Ydata',t,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('t')
colormap(gca,hot), colorbar



% figure;
% imagesc(theta, t, abs(R_tilda)); 
% colormap(gca,hot), colorbar
% xlabel('\theta (degrees)')
% ylabel('Frequency (ω)')
% title('Fourier Radon Transform')

w_max = max(t);

% R_ramlek = myFilter(R,t,w_max,'Cosine');
% 
% figure;
% imagesc(theta, t, abs(R_ramlek));
% colormap(gca, hot); colorbar;
% xlabel('\theta (degrees)');
% ylabel('Frequency (\omega)');
% title('Filtered Sinogram');
% 
% recon_cosine = iradon(R_ramlek, theta, 'linear','none',1,128);



recon_ref = iradon(R, theta, 'linear', 'Cosine',1,128);

figure();
subplot(1,2,1);
imshow(recon_cosine, []);
subplot(1,2,2);
imshow(mat2gray(abs(recon_ref)), []);

% figure;
% imshow(abs(mat2gray(abs(recon_ref)) - mat2gray(abs(recon_cosine))));
% title('Difference (iradon vs. Your Method)');


