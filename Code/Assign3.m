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

    %% Step 1: Compute the Distance Transform
    img_gray = rgb2gray(img);
    figure; imshow(img_gray); title('Grayscale Image');

    img_edge = edge(img_gray, "Canny");
    figure; imshow(img_edge); title('Canny Edge Detection');

    % Calculate the chamfer distance array
    img_chamfer = chamferDist(img_edge);
    figure; imshow(img_chamfer, []); title('Custom chamfer calculations');

    %% Step 2: Apply Chamfer Distance Matching

end