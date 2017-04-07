function [ visual_isochrone ] = closest_isochrone( cluster_magnitudes, isochrones )
    %CLOSEST_ISOCHRONE Returns name of closest isochrone given cluster
    %magnitudes and isochrone struct
    
    % get field names of isochrone struct
    fields = fieldnames(isochrones);
    
    % create table of 0s to store sumsquares
    residual_sumsquares = array2table(zeros(2, length(fields)), 'VariableNames', fields, 'RowNames', {'visual', 'blue'});
    
    for index = 1:numel(fields)
        current_isochrone = isochrones.(fields{index});
        
        vis_mag = current_isochrone.V;%(1:find(diff(current_isochrone.V) >= 0, 1));
        %blu_mag = current_isochrone.B;%(1:find(diff(current_isochrone.V) >= 0, 1));
        
        vis_inter = interp1(vis_mag, linspace(1, length(vis_mag), length(cluster_magnitudes.V)), 'spline')';
        %vis_inter = interp1(vis_mag, 1:length(cluster_magnitudes.V), 'spline')';
        %blu_inter = interp1(blu_mag, linspace(1, length(blu_mag), length(cluster_magnitudes.V)), 'spline')';

        residual_sumsquares{1, index} = nansum((cluster_magnitudes.V - vis_inter).^2);
        %residual_sumsquares{2, index} = nansum((cluster_magnitudes.B - blu_inter).^2);
    end
    
    %disp(residual_sumsquares);
    
    visual_isochrone = cell2mat(residual_sumsquares('visual', residual_sumsquares{'visual',:} == min(residual_sumsquares{'visual',:})).Properties.VariableNames);
end
