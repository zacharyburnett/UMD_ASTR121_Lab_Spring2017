function [ generated_data ] = generate_exoplanet_data( time_values, period, amplitude )
%Generates exoplanet radial velocity curve.
%   This function accepts period (in days), amplitude (in m/s), and an array of time values,
%   and generates a sine curve of radial velocity data to simulate data from an exoplanet.

% get perfect sine wave data from given time values
generated_data = amplitude .* sin(time_values .* (2 .* pi ./ period));

end