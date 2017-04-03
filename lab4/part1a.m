% read in data for star cluster M45
m45 = readtable('m45.txt', 'ReadVariableNames', true);

% start plotting
hold on;

% reverse y axis
set(gca, 'ydir', 'rev');

% plot B magnitude vs color index (B - V)
plot(m45.B - m45.V, m45.V, '.');

% add labels
title('Visual Magnitude vs Color Index (B-V) of Cluster M45');
xlabel('Color Index (B - V)');
ylabel('Visual Magnitude (V)');

% end plotting
hold off;