%% define constants

% galactic longitudes observed in data
galactic_longitudes = deg2rad(17:4:65);
galactic_longitudes_uncertainties = deg2rad(1);

% define meters in a kiloparsec
meters_in_kiloparsec = 3.086e+16 * 1000; % meters

% define gravitational constant
cavendish_constant = 6.67408e-11;

speed_of_light = 299792458; % meters per second
HI_emission_frequency = 1420.405752; % neutral hydrogen emission frequecy in MHz

solar_velocity = 299 * 1000; % meters per second
solar_velocity_uncertainty = 15 * 1000; % meters per second

% galactic longitude component of solar motion, in radians
solar_velocity_galactic_longitude = deg2rad(98.8);
solar_velocity_galactic_longitude_uncertainty = deg2rad(3.6);

% galactic latitude component of solar motion, in radians
solar_velocity_galactic_latitude = deg2rad(-5.9);
solar_velocity_galactic_latitude_uncertainty = deg2rad(3.0);

% solar distance to galactic center
solar_orbital_radius = 7.4 * meters_in_kiloparsec; % meters
solar_orbital_radius_uncertainty = 0.3 * meters_in_kiloparsec; % meters

% define plotting colors
colors = jet(length(galactic_longitudes));

% calculate solar orbital velocity
solar_orbital_velocity = solar_velocity * cos(solar_velocity_galactic_latitude) * cos(solar_velocity_galactic_longitude - deg2rad(90));

% error propagation
solar_orbital_velocity_uncertainty = sqrt(...
    solar_velocity_uncertainty^2 * (cos(solar_velocity_galactic_latitude) * cos(solar_velocity_galactic_longitude - deg2rad(90))).^2 + ...
    solar_velocity_galactic_latitude_uncertainty^2 * (-solar_orbital_velocity * sin(solar_velocity_galactic_latitude) * cos(solar_velocity_galactic_longitude - deg2rad(90))).^2 + ...
    solar_velocity_galactic_longitude_uncertainty^2 * (-solar_orbital_velocity * cos(solar_velocity_galactic_latitude) * sin(solar_velocity_galactic_longitude - deg2rad(90))).^2);

% get linspace of radii inside 2 kpc
inner_radii = linspace(0, 2 * meters_in_kiloparsec, 200);

% get linspace of radii outside 2 kpc
outer_radii = linspace(2 * meters_in_kiloparsec, 8 * meters_in_kiloparsec, 200);

%% read data

% define data filenames
filenames = strcat('lon', string(17:4:65), '.dat');

% create cell array to store data
data = cell(1, length(filenames));

% populate data array
for index = 1:length(filenames)
    data{index} = readtable(char(filenames(index)));
end

%% get left-hand start of signal

% create array to store start of signal
left_hand_start_of_signal_frequencies = zeros(1, length(data));
left_hand_start_of_signal_uncertainties = zeros(1, length(data));

for index = 1:length(data)
    current_table = data{index};

    left_tail_negative_indices = find(current_table.Var2(current_table.Var1 < 1420.406) < 0);
    left_tail = current_table.Var2(1:left_tail_negative_indices(end) + 1);

    left_tail_positive_noise = max(left_tail(left_tail > 0));
    left_tail_negative_noise = min(left_tail(left_tail < 0));
  
    % find left tail negative indices and signal start frequency of the noise-adjusted sample
    left_tail_negative_indices = find(current_table.Var2(current_table.Var1 < 1420.406) < mean([left_tail_positive_noise, left_tail_negative_noise]));
    left_tail_start_frequency = current_table.Var1(left_tail_negative_indices(end) + 1);
    
    left_hand_start_of_signal_frequencies(index) = left_tail_start_frequency;
    left_hand_start_of_signal_uncertainties(index) = left_tail_start_frequency - current_table.Var1(left_tail_negative_indices(end - 1));
end

%% plot left-hand start of signal frequencies

hold on;

% plot brightness temperature in K vs frequency in mhz
for index = 1:length(data)
    current_table = data{index};

    plot(current_table.Var1, current_table.Var2, '.', 'color', colors(index, :));
end

% plot vertical lines at likely start of signal
for index = 1:length(data)
    line([left_hand_start_of_signal_frequencies(index) left_hand_start_of_signal_frequencies(index)], get(gca, 'YLim'), 'color', colors(index, :));
end

refline(0, 0);

% add labels
title('Brightness Temperature vs Frequency for 17:4:65 deg Galactic Longitude');
xlabel('Frequency (MHz)');
ylabel('Brightness Temperature (K)');

% add legend
legend(filenames);

hold off;

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
plot(inner_radii / meters_in_kiloparsec, galactic_rotational_velocity(inner_radii, masses(2) .* (inner_radii / max(inner_radii)).^3) / 1000, '-r');
%errorbar(inner_radii / meters_in_kiloparsec, galactic_rotational_velocity(inner_radii, masses(2) .* (inner_radii / max(inner_radii)).^3) / 1000, galactic_rotational_velocity(inner_radii, masses(2) - masses_uncertainties(2) .* (inner_radii / max(inner_radii)).^3) / 1000, galactic_rotational_velocity(inner_radii, masses(2) + masses_uncertainties(2) .* (inner_radii / max(inner_radii)).^3) / 1000, '-r');

% plot outside inner sphere
plot(outer_radii / meters_in_kiloparsec, galactic_rotational_velocity(outer_radii, masses(2)) / 1000, '-r');
%errorbar(outer_radii / meters_in_kiloparsec, galactic_rotational_velocity(outer_radii, masses(2)) / 1000, galactic_rotational_velocity(outer_radii, masses(2) - masses_uncertainties(2)) / 1000, galactic_rotational_velocity(outer_radii, masses(2) + masses_uncertainties(2)) / 1000, '-r');

% add labels
title('Derived Rotation Curve');
xlabel('Orbital Radius (kpc)');
ylabel('Orbital Velocity (km/s)');

% add ylimit
ylim([0, 350]);

% add legend
legend('HI Clouds', 'Sun', 'Bisquare Fit', '2 kpc Central Mass', 'Location', 'northwest');

hold off;
