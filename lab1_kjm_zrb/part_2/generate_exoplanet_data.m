function [ generated_data ] = generate_exoplanet_data( time_values, period, amplitude )
%Generates exoplanet radial velocity curve.
%   This function accepts period (in days), amplitude (in m/s), and an array of time values,
%   and generates a sine curve of radial velocity data to simulate data from an exoplanet.

uncertainties = random('uniform', -0.2, 0.2, 1, length(time_values));

noise_values = time_values + (time_values .* uncertainties);

generated_data = amplitude .* sin(noise_values .* (2 .* pi ./ period));
end