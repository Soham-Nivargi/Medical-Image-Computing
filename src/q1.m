clc;
clear all;

% Load the images
data = load('../data/assignmentImageDenoising_phantom.mat');
noiseless = data.imageNoiseless;
noisy = data.imageNoisy;

% Get image dimensions
[rows, cols] = size(noisy);
