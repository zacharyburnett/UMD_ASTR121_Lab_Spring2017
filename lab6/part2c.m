speed_of_light = 299792458; % meters per second

% create table for radial velocities
galactic_radial_velocities = readtable('galaxy_list.csv', 'ReadRowNames', true);
galactic_radial_velocities.Velocity_c = zeros(height(galactic_radial_velocities), 1);
galactic_radial_velocities.Uncertainty_c = zeros(height(galactic_radial_velocities), 1);
galactic_radial_velocities.Velocity_m_s = zeros(height(galactic_radial_velocities), 1);
galactic_radial_velocities.Uncertainty_m_s = zeros(height(galactic_radial_velocities), 1);

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

hubble_time = 1 / (hubble_constant_best_fit / 1000 / 30856776000000000000);
hubble_time_uncertainty = sqrt((-(1 / hubble_constant_best_fit^2))^2 * hubble_constant_best_fit_uncertainty^2);

hold on

% plot data with errorbars
errorbar(galactic_radial_velocities.Distance_Mpc, galactic_radial_velocities.Velocity_m_s / 1000, galactic_radial_velocities.Uncertainty_m_s / 1000, galactic_radial_velocities.Uncertainty_m_s / 1000, galactic_radial_velocities.Uncertainty_Mpc, galactic_radial_velocities.Uncertainty_Mpc, 'o');

% plot constant found through data
plot(galactic_radial_velocities.Distance_Mpc, hubble_constant_best_fit * galactic_radial_velocities.Distance_Mpc / 1000, '-r');
plot(galactic_radial_velocities.Distance_Mpc, (hubble_constant_best_fit + hubble_constant_best_fit_uncertainty) * galactic_radial_velocities.Distance_Mpc / 1000, ':b');
plot(galactic_radial_velocities.Distance_Mpc, (hubble_constant_best_fit - hubble_constant_best_fit_uncertainty) * galactic_radial_velocities.Distance_Mpc / 1000, ':b');

% plot zeroline
%line(get(gca, 'XLim'), [0 0], 'color', 'k', 'LineStyle', '--');

title('Galactic Recessional Velocity vs Distance');
xlabel('Distance (Mpc)');
ylabel('Recessional Velocity (km/s)');

legend('NED datapoints', sprintf('H = %.4g \x00B1 %f km/s/Mpc', hubble_constant_best_fit / 1000, hubble_constant_best_fit_uncertainty / 1000), ... 
    'range of uncertainty');
hold off