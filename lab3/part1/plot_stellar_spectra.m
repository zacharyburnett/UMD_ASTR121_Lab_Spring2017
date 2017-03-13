% part 1, plot perfect blackbody spectra of three stars of spectral type
% M0, G2, and A0

% generate array of random wavelengths between 0.1 and 1500 nanometers
num_wavelengths = 100000;
wavelengths = random('uniform', 1e-10, 1.5e-6, 1, num_wavelengths);

% read spectral type characteristics, from:
% https://sites.uni.edu/morgans/astro/course/Notes/section2/spectraltemps.html
spectral_types = readtable('spectral_types.csv', 'Format', '%C%n%n%C');

plot(wavelengths, blackbody_intensity(wavelenghts, spectral_types(16, 'temperature')))