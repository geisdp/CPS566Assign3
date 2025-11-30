clear all
close all
clc

bin_threshold = 0.5;
match_scales = [2.0, 2.5, 3.0, 3.5];
testFolder = '.\tests';
images = dir(fullfile(testFolder, '*.jpg'));
min_size = 40;
template_width = 100;

% First, process all the signs in the sign template image
img_template = imread('templates.png');
img_template_gray = rgb2gray(img_template);
figure, imshow(img_template_gray), title('BW Original Templates');

[h, w] = size(img_template_gray);
num_templates = int16(w / template_width);
for i=1:num_templates
    % Make the template image slightly largely than the actual sign in
    % order to catch the outer edges.
    border_pixels = 0;
    new_img = zeros(h+2*border_pixels, template_width+2*border_pixels);
    new_img(border_pixels+1:h+border_pixels, border_pixels+1:template_width+border_pixels) = img_template_gray(1:h, template_width*(i-1)+1:template_width*i);
    temp_edge = edge(new_img, "Canny", 0.1);
    temp_edge = cropImage(temp_edge);
    templates{i} = temp_edge;
    %figure; imshow(temp_edge); title('Template ' + string(i));
end

for i=1:length(images)
    fileName = images(i).name;
    fprintf('Processing file %s...\n', fileName);
    filePath = fullfile(testFolder, fileName);
    img = imread(filePath);
    figure; imshow(img); title('Original Image');

    %% Step 1: Compute the Distance Transform
    img_gray = rgb2gray(img);

    if i == 1
        img_edge = edge(img_gray, "Canny", [.1 .4], 1);
    elseif i == 2
        img_edge = edge(img_gray, "Canny", [.1 .3], 1);
    elseif i == 3
        img_edge = edge(img_gray, "Canny", [.1 .5], 1.5);
    elseif i == 4
        img_edge = edge(img_gray, "Canny", [.2 .4], 1);
    elseif i == 5
        img_edge = edge(img_gray, "Canny", [.1 .5], 1);
    end
    figure; imshow(img_edge); title('Canny Edge Detection');

    % Calculate the chamfer distance array
    img_chamfer = chamferDist(img_edge);
    figure; imshow(img_chamfer, []); title('Custom chamfer calculations');

    %% Step 2: Apply Chamfer Distance Matching
    matches = chamferMatch(img_chamfer, templates, match_scales);
    
    %% Step 3: Color Verification
    
    % color class for each template index:
    % 1 = red sign (stop, yoeld)
    % 2 = white/blck (speed limit, one way)
    % 3 = green sign (pedestrian crossing)

    templateColorClass = [1 2 3 3 2 1];
    
    [img_h, img_w] = size(img_gray);

    verified_matches = {};
    v_idx = 1;

    for k=1:numel(matches)
        
        info = matches{k}; % [templateIdx, scale, row, col, score]
        t_idx = info(1);
        scale = info(2);
        r1 = round(info(3));
        c1 = round(info(4));
        score = info(5);
        color_class = templateColorClass(t_idx);

        % Recompute scaled template size to know the bounding box size
        templ = templates{t_idx};
        templ_scaled = imresize(templ, scale);
        [t_h, t_w] = size(templ_scaled);

        % Clamp bounding box to image borders
        r1 = max(1, r1); % Top bounding
        c1 = max(1, c1); % Left bounding
        r2 = min(img_h, r1+t_h-1); % Bottom bounding
        c2 = min(img_w, c1+t_w-1); % Right bounding

        % Extract ROI from original RGB image
        roi =  img(r1:r2, c1:c2, :);

        % Check if this ROI has the expected color
        is_same = verifyColorByClass(roi, color_class);

        if is_same
            verified_matches{v_idx} = [t_idx, scale, r1, c1, score];
            v_idx = v_idx + 1;
        end
    end
end
