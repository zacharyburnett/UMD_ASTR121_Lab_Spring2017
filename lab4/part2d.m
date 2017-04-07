% read in data for star cluster M45
m45 = readtable('m45.txt', 'ReadVariableNames', true);

% load isochrones
load isochrones.mat

% get best fit isochrone
%residual_sumsquares = closest_isochrone(m45, isoc.e8);
best_fit_isochrone = isoc.e8.two;%(closest_isochrone(m45, isoc.e8));

iso_blue = best_fit_isochrone.B(1:find(diff(best_fit_isochrone.V) >= 0));
iso_visu = best_fit_isochrone.V(1:find(diff(best_fit_isochrone.V) >= 0));

interpolated_blue = interp1(best_fit_isochrone.B, linspace(1, length(best_fit_isochrone.B), length(m45.B)), 'spline')';
interpolated_visual = interp1(best_fit_isochrone.V, linspace(1, length(best_fit_isochrone.V), length(m45.V)), 'spline')';

distances = 130:10:150;

hold on

set(gca, 'ydir', 'rev');

plot(m45.B - m45.V, m45.V, '.k')

%plot(iso_blue - iso_visu, apparent_magnitude(iso_visu, 136.2), '-');

for current_distance = distances
    %plot(best_fit_isochrone.B - best_fit_isochrone.V, apparent_magnitude(best_fit_isochrone.V, current_distance), '-');
    %plot(interpolated_blue - interpolated_visual, apparent_magnitude(interpolated_visual, current_distance), '-');
    plot(iso_blue - iso_visu, apparent_magnitude(iso_visu, current_distance), '-');
end

legend(['m45', strcat(string(distances), ' pc')]);

hold off