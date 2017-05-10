speed_of_light = 299792458; % meters per second
hubble_constant = 67.7; % km/s/Mpc

galactic_radial_velocities = array2table(zeros(length(galaxy_names), 6), ... 
    'VariableNames', {'Distance_Mpc', 'Uncertainty_Mpc', 'Velocity_c', 'Uncertainty_c', 'Velocity_m_s', 'Uncertainty_m_s'}, ... 
    'RowNames', galaxy_names);
galactic_radial_velocities.Distance_Mpc = [24.864, 20.390, 24.830, 8.070, 3.907, 3.651, 39.613, 10.781, 9.464, 26.100, 16.275, 7.196, 13.247, 31.638, 19.400]';
galactic_radial_velocities.Uncertainty_Mpc = [5.757, 6.562, 5.214, 1.956, 0.687, 0.555, 8.947, 1.566, 1.971, 0, 7.316, 2.114, 4.271, 5.306, 3.267]';

for galaxy_name_index = 1:length(galaxy_names)
    current_galaxy_name = galaxy_names{galaxy_name_index};
    
    galactic_radial_velocities.Velocity_c(current_galaxy_name) = mean(doppler_shifts.Shift_A(current_galaxy_name) ./ spectral_lines.Wavelength_A);
    galactic_radial_velocities.Uncertainty_c(current_galaxy_name) = mean(sqrt((1 ./ spectral_lines.Wavelength_A).^2 .* (doppler_shifts.Unweighted_Residual_A(current_galaxy_name)).^2));
    
    galactic_radial_velocities.Velocity_m_s(current_galaxy_name) = galactic_radial_velocities.Velocity_c(current_galaxy_name) * speed_of_light;
    galactic_radial_velocities.Uncertainty_m_s(current_galaxy_name) = galactic_radial_velocities.Uncertainty_c(current_galaxy_name) * speed_of_light;
end

% optimize hubble constant
sample_constants = 0:0.1:300;
theory_results = zeros(length(sample_constants), length(galaxy_names));
chi_squared = zeros(1, length(sample_constants));

for sample_constant_index = 1:length(sample_constants)
        theory_results(sample_constant_index, :) = (sample_constants(sample_constant_index) * 1000 * galactic_radial_velocities.Distance_Mpc')';
        chi_squared(sample_constant_index) = sum((theory_results(sample_constant_index, :) - galactic_radial_velocities.Velocity_m_s').^2 ./ (galactic_radial_velocities.Uncertainty_m_s').^2);
end

[~, min_chi_squared_index] = min(chi_squared);
best_fit_constant = sample_constants(min_chi_squared_index);

hold on

axis([0 (max(galactic_radial_velocities.Distance_Mpc) + max(galactic_radial_velocities.Uncertainty_Mpc)) 0 (max(galactic_radial_velocities.Velocity_m_s) + max(galactic_radial_velocities.Uncertainty_m_s))]);
errorbar(galactic_radial_velocities.Distance_Mpc, galactic_radial_velocities.Velocity_m_s, galactic_radial_velocities.Uncertainty_m_s, galactic_radial_velocities.Uncertainty_m_s, galactic_radial_velocities.Uncertainty_Mpc, galactic_radial_velocities.Uncertainty_Mpc, 'o');
line(galactic_radial_velocities.Distance_Mpc, galactic_radial_velocities.Distance_Mpc * hubble_constant * 1000, 'LineStyle', '--', 'color', 'r');
line(galactic_radial_velocities.Distance_Mpc, galactic_radial_velocities.Distance_Mpc * best_fit_constant * 1000, 'LineStyle', '--', 'color', 'b');

title('Galactic Radial Velocity vs Distance (as obtained from NED Doppler shift and distances)');
xlabel('Distance (Mpc)');
ylabel('Velocity (v/c)');

legend('NED data', strcat({'H = '}, string(hubble_constant), {' km/s/Mpc'}), strcat({'H = '}, string(best_fit_constant), {' km/s/Mpc'}));

hold off