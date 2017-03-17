% part 1, plot perfect blackbody spectra of three stars of spectral type
% M0, G2, and A0

% generate array of random wavelengths between 0.1 and 1500 nanometers
wavelengths = linspace(1e-10, 1.5e-6, 200);

% read spectral type characteristics, from:
% https://sites.uni.edu/morgans/astro/course/Notes/section2/spectraltemps.html
%spectral_types = readtable('spectral_types.csv', 'Format', '%C%n%n%C');

% A0 main sequence is 9600K
A0_theory = blackbody_intensity(wavelengths, 9600);

% G2 main sequence is 5800K
G2_theory = blackbody_intensity(wavelengths, 5800);

% M0 main sequence is 3750K
M0_theory = blackbody_intensity(wavelengths, 3750);

hold on

plot(wavelengths, A0_theory, '-');
plot(wavelengths, G2_theory, '--');
plot(wavelengths, M0_theory, '.-');

legend('A0', 'G2', 'M0');
title('Plancks Law of A0, G2, and M0 stellar spectra over 200 wavelengths');

hold off