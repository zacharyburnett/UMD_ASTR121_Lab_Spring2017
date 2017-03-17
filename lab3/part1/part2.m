B0_data = readtable('lab3\spectra\b0.txt', 'ReadVariableNames', true);

% B0 main sequence is 29200K
B0_theory = blackbody_intensity(B0_data.wavelength_A .* 1e-10, 29200);
B0_normalized_theory = B0_theory / max(B0_theory);

hold on

% convert Angstroms to meters
plot(B0_data.wavelength_A, B0_data.normalized_intensity, '-');
plot(B0_data.wavelength_A, B0_normalized_theory, '--');

legend('data', 'theory');
title('B0 stellar spectral data vs theory');

hold off