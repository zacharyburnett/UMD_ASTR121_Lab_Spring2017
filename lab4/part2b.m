m45 = readtable('m45.txt', 'ReadVariableNames', true);
CI5e9 = isoc.e9.five.B - isoc.e9.five.V;
V5e9 = isoc.e9.five.V;

hold on;

set(gca, 'ydir', 'rev');
plot(CI5e9, V5e9, '.k', m45.B - m45.V, m45.V, '.r');
title('B - V Magnitude vs V Magnitude of a Cluster age 5E9');
xlabel('Color Index (B - V)');
ylabel('Visual Magnitude (V)');

hold off;

