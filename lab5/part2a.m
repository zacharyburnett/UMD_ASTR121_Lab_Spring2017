% load data at longitude 17
lon17 = readtable('lon17.dat');

% frequency mhz, brightness temperature K

plot(lon17.Var1, lon17.Var2)