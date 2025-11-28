function [matches] = chamferMatch(img_dist, templates_img_gray, match_scales)
    %CHAMFERMATCH This function loops through the list of template images,
    %and loops through the list of scale factors for each template image,
    %to match the scaled template with street signs in the input image.
    %The input image is an image on which chamferDist() has been alread
    %been executed.
    arguments (Input)
        img_dist (:,:) double    % Input mage that has been through chamferDist()
        templates_img_gray {}    % List of street sign templates
        match_scales double      % List of scale factors to be applised to each sign template
    end
    
    arguments (Output)
        matches {}              % List of best matches for each template image/scale factor combination.
                                % Each element of the list contains a list with the following values:
                                %    Template image index
                                %    Optimal scale factor
                                %    Row of the top left corner of the match in the input image
                                %    Col of the top left corner of the match in the input image
                                %    Score of this template/scale factor
    end

    [nrows, ncols] = size(img_dist);

    % Loop through each template
    for i_image = 1:numel(templates_img_gray)
        template = templates_img_gray{i_image};
    
        % Loop through all the scales to try to find a match
        best_score = Inf;
        best_pos = [0,0];
        best_scale = 0;

        % Loop through each scale factor
        for scale=match_scales
            % Resize the template based on the scale
            temp_scaled = imresize(template, scale);
            [t_rows, t_cols] = size(temp_scaled);

            % Only process if the template is < size of the input image
            if t_rows < nrows && t_cols < ncols
                [pos, score] = matchTemplate(img_dist, temp_scaled);
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