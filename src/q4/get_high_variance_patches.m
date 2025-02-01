function patches = get_high_variance_patches(img, threshold)
    patches = [];

    for i = 1:size(img, 1) - 7
        for j = 1:size(img, 2) - 7
            patch = img(i:i+7, j:j+7);
            if var(patch(:)) > threshold
                patches = cat(2, patches, patch(:));
            end
        end
    end
end
