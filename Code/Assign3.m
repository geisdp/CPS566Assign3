clear all
close all
clc

testFolder = '.\tests';
images = dir(fullfile(testFolder, '*.jpg'));

for i=1:length(images)
    fileName = images(i).name;
    filePath = fullfile(testFolder, fileName);
    img = imread(filePath);
    figure; imshow(img); title('Original Image');

    % Step 1
    img_gray = rgb2gray(img);
    figure; imshow(img_gray); title('Grayscale Image');

    img_edge = edge(img_gray, "Canny");
    figure; imshow(img_edge); title('Canny Edge Detection');

    dist = bwdist(img_edge);
    figure; imshow(dist, []);

end