unknown1_data = readtable('unknown1.txt', 'ReadVariableNames', true);

% get standards
spectral_types = {'A1', 'A5', 'B0', 'B6', 'F0', 'F5', 'G0', 'G6', 'K0', 'K5', 'M0', 'M5', 'O5'};

spectral_standards = array2table(zeros(0,14), 'VariableNames', {'wavelength_A', spectral_types});

for spectral_type in spectral_types:
    spectral_standards(spectral_type) = readtable(spectral_type + '.txt', 'ReadVariableNames', true).normalized_wavelength;

hold on

% convert Angstroms to meters
plot(unknown1_data.wavelength_A, unknown1_data.normalized_intensity, '--');
for spectral_type in spectral_types:
    plot(spectral_standards.wavelength_A, spectral_standards[[spectral_type]], '-');

legend(spectral_types);
title('All spectral standards, compared to Unknown Spectra 1');
xlabel('Wavelength (Angstroms)');
ylabel('Normalized Intensity');

hold off