%% calculate orbital parameters

% radial velocities from Doppler shift
radial_velocities = ((HI_emission_frequency - left_hand_start_of_signal_frequencies) ./ left_hand_start_of_signal_frequencies) .* speed_of_light;

% error propagation
radial_velocities_uncertainties = sqrt(...
    left_hand_start_of_signal_uncertainties .^2 .* ((HI_emission_frequency ./ left_hand_start_of_signal_frequencies.^2) .* speed_of_light).^2);

% get orbital velocity from line of sight velocity and radial velocity
orbital_velocities = solar_velocity * cos(solar_velocity_galactic_latitude) * ...
    cos(solar_velocity_galactic_longitude - galactic_longitudes) + radial_velocities;

% error propagation
orbital_velocities_uncertainties = sqrt(...
    solar_velocity_uncertainty^2 .* (cos(solar_velocity_galactic_latitude) .* cos(solar_velocity_galactic_longitude - galactic_longitudes)).^2 + ...
    solar_velocity_galactic_latitude_uncertainty^2 .* (-solar_velocity .* sin(solar_velocity_galactic_latitude) .* cos(solar_velocity_galactic_longitude - galactic_longitudes)).^2 + ...
    solar_velocity_galactic_longitude_uncertainty^2 .* (-solar_velocity .* cos(solar_velocity_galactic_latitude) .* sin(solar_velocity_galactic_longitude - galactic_longitudes)).^2 + ...
    galactic_longitudes_uncertainties^2 .* (solar_velocity .* cos(solar_velocity_galactic_latitude) .* sin(solar_velocity_galactic_longitude - galactic_longitudes)).^2 + ...
    radial_velocities_uncertainties.^2);

% calculate orbital radii using distance from Sun to center of Milky Way
orbital_radii = solar_orbital_radius .* sin(galactic_longitudes);

% error propagation
orbital_radii_uncertainties = sqrt(...
    solar_orbital_radius_uncertainty^2 .* sin(galactic_longitudes).^2 + ...
    galactic_longitudes_uncertainties.^2 .* (solar_orbital_radius .* cos(galactic_longitudes)).^2);

%% Get mass at 2 and 4 kpc

% from cftool with Bisquare remain fit
slope = 7.3e-16;
slope_uncertainty = 1.0300e-16;
y_intercept = 1.473e+05;
y_intercept_uncertainty = 15600;

theoretical_radii = meters_in_kiloparsec:meters_in_kiloparsec:(9 * meters_in_kiloparsec);

masses = (slope * theoretical_radii + y_intercept).^2 .* theoretical_radii / cavendish_constant;
masses_uncertainties = sqrt(...
    slope_uncertainty^2 * (theoretical_radii .* (slope * theoretical_radii + y_intercept)).^2 + ...
    y_intercept_uncertainty^2 * (slope * theoretical_radii + y_intercept).^2);

%% plot rotation curves

% create new figure
figure

% start plotting
hold on;

% plot calculated positions
errorbar(orbital_radii / meters_in_kiloparsec, orbital_velocities / 1000, orbital_velocities_uncertainties / 1000, orbital_velocities_uncertainties / 1000, orbital_radii_uncertainties / meters_in_kiloparsec, orbital_radii_uncertainties / meters_in_kiloparsec, 'o')

% add point for Sun
errorbar(solar_orbital_radius / meters_in_kiloparsec, solar_orbital_velocity / 1000, solar_orbital_velocity_uncertainty / 1000, solar_orbital_velocity_uncertainty / 1000, solar_orbital_radius_uncertainty / meters_in_kiloparsec, solar_orbital_radius_uncertainty / meters_in_kiloparsec, 'o')

plot(0:8, (slope .* ((0*meters_in_kiloparsec):meters_in_kiloparsec:(8*meters_in_kiloparsec)) + y_intercept) / 1000)

% plot theoretical rotation curve
% plot inside inner sphere
plot(inner_radii / meters_in_kiloparsec, orbital_velocity(inner_radii, masses(2) .* (inner_radii / max(inner_radii)).^3) / 1000, '-r');

% plot outside inner sphere
plot(outer_radii / meters_in_kiloparsec, orbital_velocity(outer_radii, masses(2)) / 1000, '-r');

% add labels
title('Derived Rotation Curve');
xlabel('Orbital Radius (kpc)');
ylabel('Orbital Velocity (km/s)');

% add ylimit
ylim([0, 350]);

% add legend
legend('HI Clouds', 'Sun', 'Bisquare Fit', '2 kpc Central Mass', 'Location', 'northwest');

hold off;
