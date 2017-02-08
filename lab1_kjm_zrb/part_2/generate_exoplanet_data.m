function [ generated_data ] = generate_exoplanet_data( time_values, period, amplitude, error )
%Generates exoplanet radial velocity curve.
%   This function accepts period (in days), amplitude (in m/s), and an array of time values,
%   and generates a sine curve of radial velocity data to simulate data from an exoplanet with given error percentage.

% get perfect sine wave data from given time values
generated_data = amplitude .* sin(time_values .* (2 .* pi ./ period));

% get uncertainties inside the given error range
uncertainties = random('uniform', -error, error, 1, length(time_values));

% apply uncertanties to generated data
generated_data = generated_data + generated_data .* uncertainties;

end