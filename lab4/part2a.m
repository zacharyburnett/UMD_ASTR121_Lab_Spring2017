%load isochrones.mat

color_index_5e9 = isoc.e9.five.B - isoc.e9.five.V;
color_index_95e9 = isoc.e9.ninept5.B - isoc.e9.ninept5.V;
color_index_2e8= isoc.e8.two.B - isoc.e8.two.V;
color_index_7e8 = isoc.e8.seven.B - isoc.e8.seven.V;

visual_magnitude_5e9 = isoc.e9.five.V;
visual_magnitude_95e9 = isoc.e9.ninept5.V;
visual_magnitude_2e8 = isoc.e8.two.V;
visual_magnitude_7e8 = isoc.e8.seven.V;

hold on;

set(gca, 'ydir', 'rev');
plot(color_index_2e8, apparent_magnitude(visual_magnitude_2e8, 40), '.b', color_index_7e8, apparent_magnitude(visual_magnitude_7e8, 40), '.g', color_index_5e9, apparent_magnitude(visual_magnitude_5e9, 40), '.r', color_index_95e9, apparent_magnitude(visual_magnitude_95e9, 40), '.k');
title('Color Index vs Visual Apparent Magnitude at 40 parsecs');
xlabel('Color Index (B - V)');
ylabel('Visual Apparent Magnitude (V)');

legend('2e8', '7e8', '5e9', '9.5e9')

hold off;

