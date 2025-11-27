clear all
close all
clc

bin_threshold = 0.5;
match_scales = [0.5]; %[2.0, 2.5, 3.0];
testFolder = '.\tests';
images = dir(fullfile(testFolder, '*.jpg'));
min_size = 40;

% First, process all the signs in the sign template image
img_template = imread('templates.png');
img_template_gray = rgb2gray(img_template);
figure, imshow(img_template_gray), title('BW Original Templates');
bw_template = imbinarize(img_template_gray, bin_threshold);
bw_comp = imcomplement(bw_template); % Background should be black and foreground should be white
[L, num] = bwlabel(bw_comp, 8);

[h, w] = size(bw_template);
temp_count = 0;
% Limit to 100 components in case bwlabel() creates too many components.
for i=1:min(num, 100)
    [r,c] = find(L == i);
    min_r = min(r);
    max_r = max(r);
    min_c = min(c);
    max_c = max(c);
    r = r - min_r + 1;
    c = c - min_c + 1;
    height = max_r - min_r + 1;
    width = max_c - min_c + 1;
    % Only keep labeled components that are of the minimum size
    if height>=min_size && width>=min_size
        % Make the template image slightly largely than the actual sign in
        % order to catch the outer edges.
        border_pixels = 2;
        new_img = zeros(height+2*border_pixels, width+2*border_pixels);
        for j=1:length(r)
            new_img(r(j)+border_pixels, c(j)+border_pixels) = border_pixels;
        end
        temp_count = temp_count + 1;
        temp_edge = edge(new_img, "Canny", 0.3);
        templates{temp_count} = temp_edge;
        %figure, imshow(temp_edge), title("template edges "+string(temp_count));
        %filename="../template_"+string(temp_count)+".png";
        %imwrite(temp_edge, filename);
    end
end

for i=1:length(images)
    fileName = images(i).name;
    fprintf('Processing file %s...\n', fileName);
    filePath = fullfile(testFolder, fileName);
    img = imread(filePath);
    figure; imshow(img); title('Original Image');

    %% Step 1: Compute the Distance Transform
    img_gray = rgb2gray(img);

    img_edge = edge(img_gray, "Canny", [.1 .4], 1);%.3);
    figure; imshow(img_edge); title('Canny Edge Detection');

    % Calculate the chamfer distance array
    img_chamfer = chamferDist(img_edge);
    figure; imshow(img_chamfer, []); title('Custom chamfer calculations');

    %% Step 2: Apply Chamfer Distance Matching
    matches = chamferMatch(img_chamfer, templates, match_scales);
end