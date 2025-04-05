inputFolder = '/Users/shreyasgrampurohit/Documents/College_Academia/Sem8/mic/assignments/assignmentShapeAnalysis/data/anatomicalSegmentations';  % <<< CHANGE THIS
outputFile = 'all_pointsets.mat';
N = 100;

imgFiles = dir(fullfile(inputFolder, '*.png'));
numImgs = length(imgFiles);

all_pointsets = cell(numImgs, 1);
image_names = cell(numImgs, 1);

for i = 1:numImgs
    filename = fullfile(inputFolder, imgFiles(i).name);
    image_names{i} = imgFiles(i).name;

    img = imread(filename);
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    bw = imbinarize(img);

    B = bwboundaries(bw, 'noholes');
    if length(B) < 2
        warning('Skipping %s: inner boundary not found.', imgFiles(i).name);
        continue;
    end
    outer = B{1};
    inner = B{2};

    resampled_outer = resample_boundary(outer, N);
    resampled_inner = resample_boundary(inner, N);
    
    pointset = [resampled_outer; resampled_inner];
    all_pointsets{i} = pointset;

    if i == 1
        disp("Im in");
        f = figure('Visible', 'off');  % <- Don't try to show it
        plot(resampled_outer(:,2), resampled_outer(:,1), 'g-', 'LineWidth', 1.5); hold on;
        plot(resampled_inner(:,2), resampled_inner(:,1), 'r-', 'LineWidth', 1.5);
        title(sprintf('Pointset for Image %d: %s', i, imgFiles(i).name), 'Interpreter', 'none');
        legend('Outer', 'Inner');
        axis equal tight;
        
        saveas(f, fullfile("pointset_001.png", sprintf('pointset_%d.png', i)));
        close(f);
    end
end

save(outputFile, 'all_pointsets', 'image_names');
fprintf('Saved %d pointsets to %s\n', numImgs, outputFile);

function resampled = resample_boundary(boundary, N)
    dists = sqrt(sum(diff(boundary).^2, 2));
    cumlen = [0; cumsum(dists)];
    cumlen = cumlen / cumlen(end);
    uniform_pos = linspace(0, 1, N);
    x = interp1(cumlen, boundary(:,2), uniform_pos);
    y = interp1(cumlen, boundary(:,1), uniform_pos);
    resampled = [y(:), x(:)];
end