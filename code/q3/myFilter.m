function R_filt = myFilter(R, t, L, filter_type)
    rect = abs(t)<=L;
    switch filter_type
        case 'Ram-Lek'
            A_w = abs(t).*rect;
        case 'Shepp-Logan'
            A_w = abs(t) .* rect;
            idx = (t ~= 0);
            A_w(idx) = A_w(idx) .* (sin(pi*t(idx)/(2*L)) ./ (pi*t(idx)/(2*L)));
        case 'Cosine'
            A_w = abs(t) .* rect .* cos(pi*t/(2*L));
    end
    % plot(t,A_w);

    R_tilda = fft(R, [], 1);
    R_filt_f = R_tilda .* A_w;
    R_filt = real(ifft(R_filt_f, [], 1));

%     figure;
% subplot(1,2,1);
% imshow(log(abs(R_tilda) + 1), []); title('Before Filtering');
% 
% subplot(1,2,2);
% imshow(log(abs(R_filt_f) + 1), []); title('After Filtering');

end
