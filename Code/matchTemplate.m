function [best_pos, best_score] = matchTemplate(img_dist, template)
    %MATCHTEMPLATE This function slides the given template over the input
    %image and calculates the score for each pixel in the input image.  The
    %best (lowest) score is returned along with the upper left location
    %where the best score was found.
    arguments (Input)
        img_dist (:,:) double    % Input mage that has been through chamferDist()
        template (:,:) logical   % Template image to search for
    end
    
    arguments (Output)
        best_pos (1,2)      % Upper left location where the best score was found
        best_score double   % Best (lowest) score
    end
    
    best_score = inf;
    [img_rows, img_cols] = size(img_dist);
    [temp_rows, temp_cols] = size(template);
    count = sum(template, "all");

    % Slide template over the input image
    for row = 1:(img_rows - temp_rows+1)
        for col = 1:(img_cols - temp_cols+1)
            total = 0;
            
            % Loop through each pixel in the template
            for trow=1:temp_rows
                for tcol=1:temp_cols
                    if template(trow,tcol)
                        % If the template pixel is True, add the distance
                        % at that point in the input image to the total
                        total = total + img_dist(trow+row-1, tcol+col-1);
                    end
                end
            end
            if count == 0
                match_score = inf;
            else
                % The score is the average distance per pixel
                match_score = total / count;
            end
            
            if match_score  < best_score
                % If the score is lower than the previous best, keep it
                best_score = match_score ;
                best_pos = [row, col];
            end
        end
    end
end