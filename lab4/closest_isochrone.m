function [ visual_isochrone_name, blue_isochrone_name ] = closest_isochrone( cluster_magnitudes, isochrones )
%CLOSEST_ISOCHRONE Returns name of closest isochrone given cluster 
%magnitudes and isochrone struct

% get field names of isochrone struct
fields = fieldnames(isochrones);

% create table of 0s to store sumsquares
residual_sumsquares = array2table(zeros(2, length(fields)), 'VariableNames', fields, 'RowNames', {'visual', 'blue'});

for index = 1:numel(fields)
    current_isochrone = isochrones.(fields{index});
    visual_mag = interp1(current_isochrone.V, 1:length(cluster_magnitudes.V), 'spline');
    blue_mag = interp1(current_isochrone.B, 1:length(cluster_magnitudes.B), 'spline');
    residual_sumsquares{1, index} = nansum((cluster_magnitudes.V - visual_mag').^2);
    residual_sumsquares{2, index} = nansum((cluster_magnitudes.V - blue_mag').^2);
end

visual_isochrone_name = residual_sumsquares('visual', residual_sumsquares{'visual',:} == min(residual_sumsquares{'visual',:})).Properties.VariableNames;
blue_isochrone_name = residual_sumsquares('blue', residual_sumsquares{'blue',:} == min(residual_sumsquares{'blue',:})).Properties.VariableNames;

end

