function [ intensities ] = blackbody_intensity( wavelengths, temperature )
%blackbody_intensity Returns intensity in solar irradiance per meter per steradian
%of a blackbody with the given array of wavelengths and a single temperature.

planck_constant = 6.6626e-34; % Planck's constant (h) in meters squared kilograms per second
boltzmann_constant = 1.381e-23; % Boltzmann's constant (k_B) in joules per Kelvin
speed_of_light = 299792458; % Speed of light (c) in meters per second.

intensities = ( 2 * planck_constant * speed_of_light^2 ) ./ ( wavelengths.^5 .* ( exp(( planck_constant * speed_of_light ) ./ ( wavelengths .* boltzmann_constant * temperature )) - 1 ));
end

