
CI5e9 = isoc.e9.five.B - isoc.e9.five.V;
CI95e9 = isoc.e9.ninept5.B - isoc.e9.ninept5.V;
CI2e8= isoc.e8.two.B - isoc.e8.two.V;
CI7e8 = isoc.e8.seven.B - isoc.e8.seven.V;

V5e9 = isoc.e9.five.V;
V95e9 = isoc.e9.ninept5.V;
V2e8 = isoc.e8.two.V;
V7e8 = isoc.e8.seven.V;

hold on;

set(gca, 'ydir', 'rev');
plot(CI5e9, V5e9, '.k', CI95e9, V95e9, '.r', CI2e8, V2e8, '.g', CI7e8, V7e8, '.b');
title('B - V Magnitude vs V Magnitude of a Cluster age 5E9');
xlabel('Color Index (B - V)');
ylabel('Visual Magnitude (V)');

hold off;

