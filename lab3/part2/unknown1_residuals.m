% read in data from CSV
known_spectra = readtable('known_spectra.csv', 'ReadVariableNames', true);
unknown_spectra = readtable('unknown_spectra.csv', 'ReadVariableNames', true);

% find residuals between unknown1 and all known spectra
residuals = array2table(unknown_spectra.unknown1 - table2array(known_spectra), 'VariableNames', known_spectra.Properties.VariableNames);

hold on

plot(known_spectra.wavelength_A, residuals.o5, '-');
plot(unknown_spectra.wavelength_A, residuals.a1, '--');

legend('o5', 'a1');
title('Unknown Spectra 1 residuals compared to O5 and A1 Spectra');

hold off