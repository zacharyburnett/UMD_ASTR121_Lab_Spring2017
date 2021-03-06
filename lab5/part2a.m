% load data at longitude 17
lon17 = readtable('lon17.dat');

% start plotting
hold on

% plot brightness temperature in K vs frequency in mhz
plot(lon17.Var1, lon17.Var2, 'b.');

% add labels
title('Brightness Temperature vs Frequency at 17 deg Galactic Longitude');
xlabel('Frequency (MHz)');
ylabel('Brightness Temperature (K)');

hold off