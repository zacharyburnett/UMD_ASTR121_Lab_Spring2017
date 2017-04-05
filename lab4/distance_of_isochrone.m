function [ distance ] = distance_of_isochrone( cluster_magnitudes, isochrone )
    %DISTANCE_OF_ISOCHRONE Returns best guess of distance to isochrone
    %given cluster magnitudes in B and V as well as best fit isochrone
    
    interpolated_magnitudes = interp1(isochrone.V, 1:length(cluster_magnitudes.V), 'spline');
    
    apparent_magnitude(interpolated_magnitudes, distance);
end
