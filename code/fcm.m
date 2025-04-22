clear; close all; clc;
addpath(genpath('src'));

data = load('../data/assignmentSegmentBrain.mat');

image = data.imageData;
mask = data.imageMask;

figure;
imshow(image);
title('UnMasked Image');
saveas(gcf, '../results/mri/conv_fcm/unmasked.png');

image = image .* mask;

figure;
imshow(image);
title('Masked Image');
saveas(gcf, '../results/mri/conv_fcm/masked.png');

brainPixels = double(image(mask == 1));

[memberships, centres] = conv_fcm(brainPixels,3,2);

label_image = zeros(size(mask));

final_label_image = zeros(size(mask));

figure;
for i=1:3
    if abs(centres(i)-0.22)<0.1
        prt = 'CSF';
        label_image(mask==1) = 1*memberships(:, i);
        final_label_image = final_label_image + label_image;
    elseif abs(centres(i)-0.62)<0.1
        prt = 'White matter';
        label_image(mask==1) = 3*memberships(:, i);
        final_label_image = final_label_image + label_image;
    else
        prt = 'Gray matter';
        label_image(mask==1) = 2*memberships(:, i);
        final_label_image = final_label_image + label_image;
    end
    subplot(1,3,i);
    label_image = zeros(size(mask));label_image(mask==1) = memberships(:, i);
    imagesc(label_image);
    colormap(gray);
    title([prt ' Membership']);
    axis image;
end
saveas(gcf, '../results/mri/conv_fcm/memberships.png');

figure;
imshow(final_label_image, []);
title('Final label image (in grayscale)');
saveas(gcf, '../results/mri/conv_fcm/grayscale_label.png');

figure();
imagesc(final_label_image.*mask);
colormap(jet(4));
colorbar('Ticks', 1:3, ...
         'TickLabels', {'Cluster 1', 'Cluster 2', 'Cluster 3'});
axis off;
title('Final Segmentation');
axis off;
title('Final label image (color)');
saveas(gcf, '../results/mri/conv_fcm/color_label.png');
