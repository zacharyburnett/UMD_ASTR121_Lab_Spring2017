m45 = readtable('m45.txt', 'ReadVariableNames', true);

distance = 130;

hold on;

% flip axes
set(gca, 'ydir', 'rev');

e8_fields = fieldnames(isoc.e8);
e9_fields = fieldnames(isoc.e9);

% plot isochrones with apparent magnitude
for index = 1:numel(e8_fields)
    isochrone = isoc.e8.(e8_fields{index});
    plot(isochrone.B - isochrone.V, apparent_magnitude(isochrone.V, distance), '-');
end

%for index = 1:numel(e9_fields)
%    isochrone = isoc.e9.(e9_fields{index});
%    plot(isochrone.B - isochrone.V, apparent_magnitude(isochrone.V, distance), '-');
%end

% plot m45 data (already in apparent magnitude)
plot(m45.B - m45.V, m45.V, '.k');

% add labels
title('Color Index vs Visual Apparent Magnitude');
xlabel('Color Index (B - V)');
ylabel('Visual Magnitude (V)');

% add legend
e8_entries = strcat(string(1:numel(e8_fields)), 'e8');
%e9_entries = strcat(string(1:numel(e9_fields)), 'e9');

legend(e8_entries, 'M45')

hold off;

