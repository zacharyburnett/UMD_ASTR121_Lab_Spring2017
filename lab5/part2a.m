% load data at longitude 17
lon17 = readtable('lon17.dat');

lon17_negative_indices = find(lon17.Var2(lon17.Var1 < 1420.406) < 0);

lon17_left_tail = lon17.Var2(1:lon17_negative_indices(end) + 1);

lon17_positive_noise = max(lon17_left_tail(lon17_left_tail > 0));
lon17_negative_noise = min(lon17_left_tail(lon17_left_tail < 0));
   
% find left tail negative indices and signal start frequency of the noise-adjusted sample
lon17_negative_indices = find(lon17.Var2(lon17.Var1 < 1420.406) < mean([lon17_positive_noise, lon17_negative_noise]));
lon17_start_frequency = lon17.Var1(lon17_negative_indices(end) + 1);
lon17_start_uncertainty = lon17_start_frequency - lon17.Var1(lon17_negative_indices(end - 1));

% start plotting
hold on

% plot brightness temperature in K vs frequency in mhz
plot(lon17.Var1, lon17.Var2, 'b.');
%plot(lon17.Var1, noise_adjusted, 'b-');

line([lon17_start_frequency lon17_start_frequency], get(gca, 'YLim'), 'Color', 'b');
line(get(gca, 'XLim'), [0 0], 'Color', 'b');

% add labels
title('Brightness Temperature vs Frequency at 17 deg Galactic Longitude');
xlabel('Frequency (MHz)');
ylabel('Brightness Temperature (K)');

hold off

