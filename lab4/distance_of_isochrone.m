function [ distance ] = distance_of_isochrone( cluster_apparent_magnitudes, isochrone_absolute_magnitudes, distance_interval )
    %DISTANCE_OF_ISOCHRONE Returns best guess of distance to isochrone given cluster visual magnitudes as well as best fit isochrone and distance interval in parsecs
   
    interpolated_isochrone_absolute_magnitudes = interp1(isochrone_absolute_magnitudes, linspace(1, length(isochrone_absolute_magnitudes), length(cluster_apparent_magnitudes)), 'spline')';
    
    %current_distance = distance_interval;
    
    previous_distance = distance_interval;
    previous_sumsquares = nansum((cluster_apparent_magnitudes - apparent_magnitude(interpolated_isochrone_absolute_magnitudes, previous_distance)).^2);
    
    % sweep from 0 parsecs upwards at the specified distance interval, assuming that the sum of squares will decrease up until the correct distance
    for current_distance = 130:distance_interval:1000
        % sumsquares of current distance
        current_sumsquares = nansum((cluster_apparent_magnitudes - apparent_magnitude(interpolated_isochrone_absolute_magnitudes, current_distance)).^2);
        
        disp('####################################');

        disp('Current distance:');
        disp(current_distance);
        disp('Current sumsquares:');
        disp(current_sumsquares);
        
        disp('Previous distance:');
        disp(previous_distance);
        disp('Previous sumsquares:');
        disp(previous_sumsquares);
        
        disp('Increase in sumsquares:');
        disp(current_sumsquares - previous_sumsquares);
        
        % if rate of change is POSITIVE (we've passed the minimum) then return the previous distance and break out of loop
        if current_sumsquares - previous_sumsquares > 0
            distance = previous_distance;
            break
        end
        
        % else if rate of change is negative, we haven't reached the minimum yet
        previous_distance = current_distance;
        previous_sumsquares = current_sumsquares;

        %current_distance = current_distance + distance_interval;
    end
end
