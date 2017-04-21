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

% add labels
title('Brightness Temperature vs Frequency for 17:4:65 deg Galactic Longitude');
xlabel('Frequency (MHz)');
ylabel('Brightness Temperature (K)');

% add legend
legend(filenames);

hold off;