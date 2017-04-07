% read in data for star cluster M45
m45 = readtable('m45.txt', 'ReadVariableNames', true);

% load isochrones
load isochrones.mat

% get best fit isochrone
best_fit_isochrone = isoc.e8.two;%(closest_isochrone(m45, isoc.e8));

iso_blue = best_fit_isochrone.B(1:find(diff(best_fit_isochrone.V) >= 0));
iso_visu = best_fit_isochrone.V(1:find(diff(best_fit_isochrone.V) >= 0));

distances = 130:10:150;

hold on

set(gca, 'ydir', 'rev');

plot(m45.B - m45.V, m45.V, '.k')

for current_distance = distances
    plot(iso_blue - iso_visu, apparent_magnitude(iso_visu, current_distance), '-');
end

% add labels
title('M45 and 2*10^8 year Isochrone with Distance Candidates');
xlabel('Color Index (B - V)');
ylabel('Visual Magnitude (V)');

legend(['m45', strcat(string(distances), ' pc')]);

hold off