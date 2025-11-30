function output_img = cropImage(input_img)
    %CROPIMAGE Crops out black border form the input image.
    arguments (Input)
        input_img (:,:) logical
    end
    
    arguments (Output)
        output_img (:,:) logical
    end
    
    [rows, cols] = find(input_img);
    min_row = min(rows);
    max_row = max(rows);
    min_col = min(cols);
    max_col = max(cols);
    output_img = input_img(min_row:max_row, min_col:max_col, :);
end