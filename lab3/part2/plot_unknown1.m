% read in data from CSV
known_spectra = readtable('known_spectra.csv', 'ReadVariableNames', true);
unknown_spectra = readtable('unknown_spectra.csv', 'ReadVariableNames', true);

hold on

plot(unknown_spectra.wavelength_A, unknown_spectra.unknown1, '--');
plot(known_spectra.wavelength_A, known_spectra.o5, '-');
plot(known_spectra.wavelength_A, known_spectra.a1, '-');

legend('unknown1', 'o5', 'a1');
title('Unknown Spectra 1 vs O5 and A1 Spectra');
xlabel('Wavelength (Angstroms)');
ylabel('Normalized Intensity');

hold off