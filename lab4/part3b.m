% read in data for star cluster M67
m67 = readtable('m67.txt', 'ReadVariableNames', true);

% load isochrones
load isochrones.mat

% get best fit isochrone
best_fit_isochrone = isoc.e9.four;%(closest_isochrone(m45, isoc.e8));

iso_blue = best_fit_isochrone.B;
iso_visu = best_fit_isochrone.V;

distances = 750:50:850;

hold on

set(gca, 'ydir', 'rev');

plot(m67.B - m67.V, m67.V, '.k')

for current_distance = distances
    plot(iso_blue - iso_visu, apparent_magnitude(iso_visu, current_distance), '-');
end

legend(['m67', strcat(string(distances), ' pc')]);

hold off