% load data at longitude 17
lon17 = readtable('lon17.dat');

% start plotting
hold on

% plot brightness temperature in K vs frequency in mhz
plot(lon17.Var1, lon17.Var2);

% add labels
title('Brightness Temperature vs Frequency');
xlabel('Frequency (MHz)');
ylabel('Brightness Temperature (K)');

hold off

