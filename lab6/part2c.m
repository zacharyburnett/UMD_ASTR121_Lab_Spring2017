speed_of_light = 299792458; % meters per second

velocities = zeros(1, length(galaxy_names));

for galaxy_name_index = 1:length(galaxy_names)
    current_galaxy_name = galaxy_names{galaxy_name_index};
    
    velocities(galaxy_name_index) = mean(doppler_shifts.Shift_A(current_galaxy_name) ./ spectral_lines.wavelength * speed_of_light);
end