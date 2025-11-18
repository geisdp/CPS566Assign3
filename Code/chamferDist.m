function img_chamfer = chamferDist(img_edge)
    %CHAMFERDIST Summary of this function goes here
    %   Detailed explanation goes here
    arguments (Input)
        img_edge (:,:) logical
    end
    
    arguments (Output)
        img_chamfer
    end

    img_edge_comp = imcomplement(img_edge);
    img_chamfer = im2double(img_edge_comp);                 % Convert edge matrix to double
    img_chamfer = img_chamfer([1,1:end,end],[1,1:end,end]); % Mirror the edges so the result is the same size as the input image
    img_chamfer(img_chamfer== 1.0) = inf;                   % Set all 1.0's to infinity

    [rows, cols] = size(img_chamfer);

    % Forward pass
    for row=2:rows-1
        for col=2:cols-1
            img_chamfer(row, col) = min([img_chamfer(row-1,col)+1, img_chamfer(row,col-1)+1,  img_chamfer(row,col)]);
        end
    end

    % Backward pass
    for row=rows-1:-1:2
        for col=cols-1:-1:2
            img_chamfer(row, col) = min([img_chamfer(row,col), img_chamfer(row,col+1)+1, img_chamfer(row+1,col)+1]);
        end
    end

    % Remove the border from the output image and return it
    img_chamfer = img_chamfer(2:rows-1, 2:cols-1);
end