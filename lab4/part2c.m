% read in data for star cluster M45
m45 = readtable('m45.txt', 'ReadVariableNames', true);

% load isochrones
load isochrones.mat

% get best fit isochrone
residual_sumsquares = closest_isochrone(m45, isoc.e8);
best_fit_isochrone = isoc.e8.(cell2mat(residual_sumsquares('visual', residual_sumsquares{'visual',:} == min(residual_sumsquares{'visual',:})).Properties.VariableNames));

% get distance
distance = 136.2;

hold on;

% flip axes
set(gca, 'ydir', 'rev');

% plot isochrones with apparent magnitude
plot(best_fit_isochrone.B - best_fit_isochrone.V, apparent_magnitude(best_fit_isochrone.V, distance), '-')

% plot m45 data (already in apparent magnitude)
plot(m45.B - m45.V, m45.V, '.k');

% add labels
title('Color Index vs Visual Apparent Magnitude');
xlabel('Color Index (B - V)');
ylabel('Visual Magnitude (V)');

legend(strcat(cell2mat(residual_sumsquares('visual', residual_sumsquares{'visual',:} == min(residual_sumsquares{'visual',:})).Properties.VariableNames), ' 10^8'), 'M45')

hold off;
