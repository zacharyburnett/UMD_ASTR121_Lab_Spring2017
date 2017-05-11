speed_of_light = 299792458; % meters per second
hubble_constant = 67.7; % km/s/Mpc

% create table for radial velocities
galactic_radial_velocities = array2table(zeros(length(galaxy_names), 6), ... 
    'VariableNames', {'Distance_Mpc', 'Uncertainty_Mpc', 'Velocity_m_s', 'Uncertainty_m_s', 'Velocity_c', 'Uncertainty_c'}, ... 
    'RowNames', galaxy_names);
galactic_radial_velocities.Distance_Mpc = [24.864, 20.390, 24.830, 8.070, 3.907, 3.651, 39.613, 10.781, 9.464, 26.100, 16.275, 7.196, 13.247, 31.638, 19.400]';
galactic_radial_velocities.Uncertainty_Mpc = [5.757, 6.562, 5.214, 1.956, 0.687, 0.555, 8.947, 1.566, 1.971, 2.000, 7.316, 2.114, 4.271, 5.306, 3.267]';

% iterate over galaxies to populate radial velocities
for galaxy_name_index = 1:length(galaxy_names)
    current_galaxy_name = galaxy_names{galaxy_name_index};
    
    galactic_radial_velocities.Velocity_c(current_galaxy_name) = mean(doppler_shifts.Shift_A(current_galaxy_name) ./ spectral_lines.Wavelength_A);
    galactic_radial_velocities.Uncertainty_c(current_galaxy_name) = mean(sqrt((1 ./ spectral_lines.Wavelength_A).^2 .* (doppler_shifts.Weighted_Residual_A(current_galaxy_name)).^2));
    
    galactic_radial_velocities.Velocity_m_s(current_galaxy_name) = galactic_radial_velocities.Velocity_c(current_galaxy_name) * speed_of_light;
    galactic_radial_velocities.Uncertainty_m_s(current_galaxy_name) = galactic_radial_velocities.Uncertainty_c(current_galaxy_name) * speed_of_light;
end

% define x, y, and error metric
x = galactic_radial_velocities.Distance_Mpc;
y = galactic_radial_velocities.Velocity_m_s;
err = (galactic_radial_velocities.Uncertainty_m_s ./ max(galactic_radial_velocities.Uncertainty_m_s)) ./ ... 
    (galactic_radial_velocities.Uncertainty_Mpc / max(galactic_radial_velocities.Uncertainty_Mpc));

hubble_constant_best_fit = sum((x .* y) ./ err.^2) / sum(x.^2 ./ err.^2);

root_sum_squared_deviation_per_degree_freedom_naught = sqrt(sum((y - hubble_constant_best_fit * x).^2) / (height(galactic_radial_velocities) - 1));

hubble_constant_best_fit_uncertainty = root_sum_squared_deviation_per_degree_freedom_naught / sqrt(sum(x.^2 ./ err.^2));

hold on

% plot data with errorbars
errorbar(galactic_radial_velocities.Distance_Mpc, galactic_radial_velocities.Velocity_m_s, galactic_radial_velocities.Uncertainty_m_s, galactic_radial_velocities.Uncertainty_m_s, galactic_radial_velocities.Uncertainty_Mpc, galactic_radial_velocities.Uncertainty_Mpc, 'o');

% plot Hubble's constant from Planck
line(galactic_radial_velocities.Distance_Mpc, (hubble_constant * 1000) * galactic_radial_velocities.Distance_Mpc, 'color', 'r', 'LineStyle', '-');

% plot constant found through data
plot(galactic_radial_velocities.Distance_Mpc, hubble_constant_best_fit * galactic_radial_velocities.Distance_Mpc, '-b');
plot(galactic_radial_velocities.Distance_Mpc, (hubble_constant_best_fit + hubble_constant_best_fit_uncertainty) * galactic_radial_velocities.Distance_Mpc, ':b');
plot(galactic_radial_velocities.Distance_Mpc, (hubble_constant_best_fit - hubble_constant_best_fit_uncertainty) * galactic_radial_velocities.Distance_Mpc, ':b');

% plot zeroline
line(get(gca, 'XLim'), [0 0], 'color', 'k', 'LineStyle', '--');

title('Galactic Radial Velocity vs Distance');
xlabel('Distance (Mpc)');
ylabel('Velocity (m/s)');

legend('NED datapoints', ... 
    sprintf('H = %.4g    (Planck)     km/s/Mpc', hubble_constant), ... 
    sprintf('H = %.4g \x00B1 %f km/s/Mpc', hubble_constant_best_fit / 1000, hubble_constant_best_fit_uncertainty / 1000));
hold off