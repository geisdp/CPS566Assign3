function is_same = verifyColorByClass(roi_rgb, color_class)
%VERIFYCOLORBYCLASS Simple color verification for traffic signs.
% roi_rgb      : cropped RGB patch from original image
% color_class  : 1=red, 2=white/black, 3=yellow

    % Convert ROI to HSV
    roi_hsv = rgb2hsv(roi_rgb);
    H = roi_hsv(:,:,1);   % hue in [0,1]
    S = roi_hsv(:,:,2);   % saturation
    V = roi_hsv(:,:,3);   % value

    mask = false(size(H)); %initializes a logical mask with all false values, same size as H.
    thr = 0.25;

    switch color_class
        case 1  % red sign
            % Red is around 0 or 1 in hue
            mask = (H < 0.05 | H > 0.95) & S > 0.45 & V > 0.3;
            thr = 0.20;

        case 2  % white/black sign (Speed Limit, One way)
            % Bright and low saturation, allow a bit gray
            mask = V > 0.4 & S < 0.1;
            thr = 0.30;

        case 3  % yellow sign
            % yellow roughly between 0.10 and 0.18 in hue
            mask = (H > 0.10 & H < 0.18) & S > 0.4 & V > 0.35;
            thr = 0.20;

        otherwise
            % If class is unknown, fail the test
            is_same = false;
            return;
    end

    % Ratio of pixels that satisfy the color condition
    ratio = nnz(mask) / numel(mask); % nnz(mask) -> the number of true pixel, numel(mask) -> total number of pixels

    % Threshold to accept or reject the candidate 
    is_same = (ratio > thr);  % bigger is stricter, smaller is more tolerant
end
