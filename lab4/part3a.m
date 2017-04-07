% read in data for star cluster M67
m67 = readtable('m67.txt', 'ReadVariableNames', true);

% load isochrones
load isochrones.mat

% get fieldnames for e8 and e9
%e8_fields = fieldnames(isoc.e8);
e9_fields = fieldnames(isoc.e9);

% get distance
distance = 827;

hold on;

% flip axes
set(gca, 'ydir', 'rev');

%for index = 1:numel(e8_fields)
%    current_isochrone = isoc.e8.(e8_fields{index});
%    plot(current_isochrone.B - current_isochrone.V, apparent_magnitude(current_isochrone.V, distance), '-');
%end

for index = 1:numel(e9_fields)
    current_isochrone = isoc.e9.(e9_fields{index});
    plot(current_isochrone.B - current_isochrone.V, apparent_magnitude(current_isochrone.V, distance), '-');
end

% plot m45 data (already in apparent magnitude)
plot(m67.B - m67.V, m67.V, '.k');

% add labels
title('Color Index vs Visual Apparent Magnitude');
xlabel('Color Index (B - V)');
ylabel('Visual Magnitude (V)');

% add legend
%e8_entries = strcat(string(1:numel(e8_fields)), 'e8');
e9_entries = strcat(string(1:numel(e9_fields)), 'e9');

legend(e9_entries, 'M45')

hold off;

