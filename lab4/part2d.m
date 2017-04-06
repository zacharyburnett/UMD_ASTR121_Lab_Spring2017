% read in data for star cluster M45
m45 = readtable('m45.txt', 'ReadVariableNames', true);

% load isochrones
load isochrones.mat

% get best fit isochrone
best_fit_isochrone = isoc.e8.(cell2mat(closest_isochrone(m45, isoc.e8)));

%interpolated_isochrone_absolute_magnitudes = interp1(three_isochrone_visual, 1:length(m45.V), 'spline')';

distances = 100:20:200;

hold on

set(gca, 'ydir', 'rev');

plot(m45.B - m45.V, m45.V, '.k')

for current_distance = distances
    disp(current_distance);
    plot(best_fit_isochrone.B - best_fit_isochrone.V, apparent_magnitude(best_fit_isochrone.V, current_distance), '-');
end

legend(['m45', string(distances)]);

hold off