function is_same = verifyColorByClass(roi_rgb, color_class)
%VERIFYCOLORBYCLASS Simple color verification for traffic signs.
% roi_rgb      : cropped RGB patch from original image
% color_class  : 1=red, 2=white/black, 3=green

    % Convert ROI to HSV
    roi_hsv = rgb2hsv(roi_rgb);
    H = roi_hsv(:,:,1);   % hue in [0,1]
    S = roi_hsv(:,:,2);   % saturation
    V = roi_hsv(:,:,3);   % value

    mask = false(size(H)); %initializes a logical mask with all false values, same size as H.

    switch color_class
        case 1  % red sign
            % Red is around 0 or 1 in hue
            mask = (H < 0.05 | H > 0.95) & S > 0.5 & V > 0.3;

        case 2  % white/black sign (strong white background)
            % Bright and low saturation (white), ignore black text
            mask = V > 0.7 & S < 0.3;

        case 3  % green sign
            % Green roughly between 0.25 and 0.45 in hue
            mask = H > 0.25 & H < 0.45 & S > 0.4 & V > 0.3;

        otherwise
            % If class is unknown, simply fail the test
            is_same = false;
            return;
    end

    % Ratio of pixels that satisfy the color condition
    ratio = nnz(mask) / numel(mask); % nnz(mask) -> the number of true pixel, numel(mask) -> total number of pixels

    % Threshold to accept or reject the candidate 
    is_same = (ratio > 0.3);  % bigger is stricter, smaller is more tolerant
end