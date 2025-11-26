function [best_pos, best_score] = matchTemplate(img_dist, template)
    %MATCHTEMPLATE Summary of this function goes here
    %   Detailed explanation goes here
    arguments (Input)
        img_dist (:,:) double
        template (:,:) logical
    end
    
    arguments (Output)
        best_pos (1,2)
        best_score double
    end
    
    best_score = inf;
    [img_rows, img_cols] = size(img_dist);
    [temp_rows, temp_cols] = size(template);
    count = sum(template, "all");

    % Slide template over the input image
    for row = 1:(img_rows - temp_rows+1)
        for col = 1:(img_cols - temp_cols+1)
            total = 0;
            
            for trow=1:temp_rows
                for tcol=1:temp_cols
                    if template(trow,tcol)
                        total = total + img_dist(trow+row-1, tcol+col-1);
                    end
                end
            end
            if count == 0
                match_score = inf;
            else
                match_score = total / count;
            end
            
            if match_score  < best_score
                best_score = match_score ;
                best_pos = [row, col];
            end
        end
    end
end