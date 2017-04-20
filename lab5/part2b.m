%% define constants

% galactic longitudes observed in data
galactic_longitudes = deg2rad(17:4:65);
galactic_longitudes_uncertainties = deg2rad(1);

% define meters in a kiloparsec
meters_in_kiloparsec = 1000 * 3.086e+16;

speed_of_light = 299792458; % meters per second
HI_emission_frequency = 1420.405752; % neutral hydrogen emission frequecy in MHz

solar_velocity = 299000; % meters per second
solar_velocity_uncertainty = 15000; % meters per second

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

%% plot rotation curves

% get linspace of inner radii
inner_radii = linspace(0, 2 * meters_in_kiloparsec, 500);

% get linspace of outer radii
outer_radii = linspace(2 * meters_in_kiloparsec, 8 * meters_in_kiloparsec, 500);

% define mass of the Sun
solar_mass = 1.989e30;

% define mass inside 2 kpc in kg
mass_inside_two_kpc = 3e10 * solar_mass;

%figure
hold on;

% plot calculated positions
errorbar(orbital_radii / meters_in_kiloparsec, orbital_velocities / 1000, orbital_velocities_uncertainties / 1000, orbital_velocities_uncertainties / 1000, orbital_radii_uncertainties / meters_in_kiloparsec, orbital_radii_uncertainties / meters_in_kiloparsec, 'o')

% add point for Sun
errorbar(solar_orbital_radius / meters_in_kiloparsec, solar_velocity / 1000, solar_velocity_uncertainty / 1000, solar_velocity_uncertainty / 1000, solar_orbital_radius_uncertainty / meters_in_kiloparsec, solar_orbital_radius_uncertainty / meters_in_kiloparsec, 'o')

% plot theoretical rotation curve
% plot inside inner sphere
%plot(inner_radii / meters_in_kiloparsec, (galactic_rotational_velocity(inner_radii, mass_inside_two_kpc * (inner_radii / max(inner_radii)).^3) / 1000), 'b');

% plot outside inner sphere
%plot(outer_radii / meters_in_kiloparsec, (galactic_rotational_velocity(outer_radii, mass_inside_two_kpc) / 1000), 'b');

% add labels
title('Normalized Orbital Radius vs Orbital Velocity');
xlabel('Orbital Radius (kpc)');
ylabel('Orbital Velocity (km/s)');

% add legend
legend('HI Clouds', 'Sun', 'Location', 'northwest');

hold off;