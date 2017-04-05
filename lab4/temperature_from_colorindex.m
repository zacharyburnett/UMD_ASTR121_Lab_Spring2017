function [ temperature ] = temperature_from_colorindex( color_index, formula )
    %TEMPERATURE_FROM_COLORINDEX Returns temperature given a color index (B - V)
    
    % if second argument is not given, default to Method 1 (Wikipedia method)
    if nargin < 2
        formula = 1;
    end
    
    % get temperature from given method
    if formula == 1
        % formula from Wikipedia
        temperature = 4600 * (1 ./ (0.92 * (color_index) + 1.7) + 1 ./ (0.92 * (color_index) + 0.62));
        
    else
        % formula from http://www.astro.sunysb.edu/fwalter/AST443/b-v_temp.html
        temperature = 8540 / (color_index + 0.865);
    end
    
end
