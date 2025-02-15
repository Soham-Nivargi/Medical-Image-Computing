function outMatrix = normalize(inMatrix)
    outMatrix = (inMatrix-min(inMatrix(:)))/(max(inMatrix(:))-min(inMatrix(:)));
end