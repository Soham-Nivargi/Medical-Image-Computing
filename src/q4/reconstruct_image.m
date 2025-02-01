function img = reconstruct_image(X, img_size)
    img = zeros(img_size);
    count = zeros(img_size);
    patch_size = 8;
    patch_count = 0;
    for i = 1:img_size(1) - patch_size + 1
        for j = 1:img_size(2) - patch_size + 1
            patch = reshape(X(:, patch_count + 1), [patch_size, patch_size]);
            img(i:i+patch_size-1, j:j+patch_size-1) = img(i:i+patch_size-1, j:j+patch_size-1) + patch;
            count(i:i+patch_size-1, j:j+patch_size-1) = count(i:i+patch_size-1, j:j+patch_size-1) + 1;
            patch_count = patch_count + 1;
        end
    end
    img = img ./ count;
end