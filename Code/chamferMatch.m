function [matches] = chamferMatch(img_chamfer, templates_img_gray, match_scales)
    %CHAMFERMATCH Summary of this function goes here
    %   Detailed explanation goes here
    arguments (Input)
        img_chamfer (:,:) double
        templates_img_gray {}
        match_scales double
    end
    
    arguments (Output)
        matches {}
    end

    [nrows, ncols] = size(img_chamfer);

    % Loop through each template
    for i_image = 1:numel(templates_img_gray)
        template = templates_img_gray{i_image};
    
        % Loop through all the scales to try to find a match
        best_score = Inf;
        best_pos = [0,0];
        best_scale = 0;
        for scale=match_scales
            % Resize the template based on the scale
            temp_scaled = imresize(template, scale);
            [t_rows, t_cols] = size(temp_scaled);

            % Only process if the template is < size of the input image
            if t_rows < nrows && t_cols < ncols
                [pos, score] = matchTemplate(img_chamfer, temp_scaled);
                if score < best_score
                    best_score = score;
                    best_pos = pos;
                    best_scale = scale;
                end
            end
        end
        matches{i_image} = [i_image, best_scale, best_pos(1), best_pos(2), best_score];
    end
end