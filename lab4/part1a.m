m45 = readtable('m45.txt', 'ReadVariableNames', true);

hold on;

set(gca, 'ydir', 'rev');
plot(m45.B - m45.V, m45.V, '.');
title('B - V Magnitude vs V Magnitude');
xlabel('Color Index (B - V)');
ylabel('Visual Magnitude (V)');

hold off;