clear; close all; clc;
addpath(genpath('src'));

data = load('../data/assignmentSegmentBrain.mat');

image = data.imageData;
mask = data.imageMask;

image = image .* mask;
brainPixels = double(image(mask == 1));

[U, centres] = conv_fcm(brainPixels,3,2);