% read in data for star cluster M67
m67 = readtable('m67.txt', 'ReadVariableNames', true);

% load isochrones
load isochrones.mat

% get best fit isochrone
best_fit_isochrone = isoc.e9.four;%(closest_isochrone(m67, isoc.e9));

% get distance
distance = 800;

hold on;

% flip axes
set(gca, 'ydir', 'rev');

% plot m45 data (already in apparent magnitude)
plot(m67.B - m67.V, m67.V, '.k');

% plot isochrones with apparent magnitude
plot(best_fit_isochrone.B - best_fit_isochrone.V, apparent_magnitude(best_fit_isochrone.V, distance), '-')

%for current_distance = distances
%    plot(best_fit_isochrone.B - best_fit_isochrone.V, apparent_magnitude(best_fit_isochrone.V, current_distance), '-');
    %plot(interpolated_blue - interpolated_visual, apparent_magnitude(interpolated_visual, current_distance), '-');
    %plot(iso_blue - iso_visu, apparent_magnitude(iso_visu, current_distance), '-');
%end

% add labels
%title(strcat('M45 and ', closest_isochrone(m45, isoc.e8), ' * 10^8'));
xlabel('Color Index (B - V)');
ylabel('Visual Magnitude (V)');

legend('m67', closest_isochrone(m67, isoc.e9));

%legend(['m45', string(distances)]);

hold off;
