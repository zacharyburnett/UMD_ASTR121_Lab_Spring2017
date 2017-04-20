%%
filenames = strcat('lon', string(17:4:65), '.dat');

colors = jet(length(filenames));

data = cell(1, length(filenames));

kiloparsec_meters = 3.086e+19;

speed_of_light = 299792458; % meters per second
emitted_frequency = 1420.406; % MHz

sun_orbital_speed = 220000; % meters per second
sun_orbital_radius = 7.4 * kiloparsec_meters; % meters
sun_orbital_radius_uncertainty = 0.3 * kiloparsec_meters; % meters

galactic_longitude_uncertainties = 1; % degrees

for index = 1:length(filenames)
    data{index} = readtable(char(filenames(index)));
end

%%

left_tail_start_frequencies = zeros(1, length(data));
left_tail_start_frequencies_uncertainties = zeros(1, length(data));

for index = 1:length(data)
    current_table = data{index};

    left_tail_negative_indices = find(current_table.Var2(current_table.Var1 < 1420.406) < 0);
    left_tail = current_table.Var2(1:left_tail_negative_indices(end) + 1);

    positive_noise = max(left_tail(left_tail > 0));
    negative_noise = min(left_tail(left_tail < 0));
  
    % find left tail negative indices and signal start frequency of the noise-adjusted sample
    left_tail_negative_indices = find(current_table.Var2(current_table.Var1 < 1420.406) < mean([positive_noise, negative_noise]));
    left_tail_start_frequency = current_table.Var1(left_tail_negative_indices(end) + 1);
    
    left_tail_start_frequencies(index) = left_tail_start_frequency;
    left_tail_start_frequencies_uncertainties(index) = left_tail_start_frequency - current_table.Var1(left_tail_negative_indices(end - 1));
end

%%

% v = (femit - fobs) / fobs * c
tangential_velocities = ((emitted_frequency * 1000 - (left_tail_start_frequencies * 1000)) ./ (left_tail_start_frequencies * 1000)) * speed_of_light;

% error propagation

%tangential_velocities_uncertainties = sqrt((speed_of_light ./ (left_tail_start_frequencies * 1000)).^2 .* (left_tail_start_frequencies_uncertainties * 1000).^2 + (-1 * ((emitted_frequency * 1000) - (left_tail_start_frequencies * 1000)) ./ (left_tail_start_frequencies * 1000).^2 * speed_of_light).^2 .* (left_tail_start_frequencies_uncertainties * 1000).^2);
% for above, you use the "obs" frequency uncert twice, once for each
% propogation, also in the second term you have -(femit-fobs) when it 
%should just be -femit 
%the fix:
tangential_velocities_uncertainties = sqrt((((emitted_frequency * 1000) ./ (left_tail_start_frequencies * 1000).^2) * speed_of_light).^2 .* (left_tail_start_frequencies_uncertainties * 1000).^2);


% get orbital velocity from line of sight velocity and tangential velocity
orbital_velocities = sun_orbital_speed * sin(deg2rad(17:4:65)) + tangential_velocities;

% error propagation
%orbital_velocities_uncertainties = sqrt((sun_orbital_speed * cos(deg2rad(17:4:65)) + tangential_velocities).^2 .* tangential_velocities_uncertainties.^2 + (sun_orbital_speed * sin(deg2rad(17:4:65))).^2 .* deg2rad(galactic_longitude_uncertainties).^2);
%For this, you have found the partial derivative for theta (and included
%the tan_vel instead of treating it as a constant) but multiplied is by the
%uncertant in the tan_vel. Also, in the second term you have not found the
%derivative of sine. The fix:
orbital_velocities_uncertainties = sqrt(tangential_velocities_uncertainties.^2 + (sun_orbital_speed * cos(deg2rad(17:4:65))).^2 .* deg2rad(galactic_longitude_uncertainties).^2);


% calculate orbital radii using distance from Sun to center of Milky Way
orbital_radii = sun_orbital_radius * sin(deg2rad(17:4:65));

% error propagation
orbital_radii_uncertainties = sqrt((sin(deg2rad(17:4:65))).^2 * (sun_orbital_radius_uncertainty)^2 + (sun_orbital_radius * cos(deg2rad(17:4:65))).^2 * deg2rad(galactic_longitude_uncertainties).^2);
%the error prop for this looked correct, I only added the "deg2rad"
%function on the cosine and gal_long uncertainty
%%

hold on;

% plot brightness temperature in K vs frequency in mhz
for index = 1:length(data)
    current_table = data{index};

    plot(current_table.Var1, current_table.Var2, '.', 'color', colors(index, :));
end

% plot vertical lines at likely start of signal
for index = 1:length(data)
    line([left_tail_start_frequencies(index) left_tail_start_frequencies(index)], get(gca, 'YLim'), 'color', colors(index, :));
end

refline(0, 0);

% add labels
title('Brightness Temperature vs Frequency for 17:4:65 deg Galactic Longitude');
xlabel('Frequency (MHz)');
ylabel('Brightness Temperature (K)');

% add legend
legend(filenames);

hold off;

%%
figure 
hold on;

% plot calculated positions
plot(orbital_radii / kiloparsec_meters, orbital_velocities / 1000, 'x');

% add point for Sun
plot(sun_orbital_radius / kiloparsec_meters, sun_orbital_speed / 1000, 'o');

%add error bars
errorbar(orbital_radii / kiloparsec_meters, orbital_velocities / 1000, orbital_velocities_uncertainties / 1000, orbital_velocities_uncertainties / 1000, orbital_radii_uncertainties / kiloparsec_meters, orbital_radii_uncertainties / kiloparsec_meters, 'b')
errorbar(sun_orbital_radius / kiloparsec_meters, sun_orbital_speed / 1000, 0, 0, sun_orbital_radius_uncertainty / kiloparsec_meters, sun_orbital_radius_uncertainty / kiloparsec_meters)

%plot theoretical rotation curve
% plot inside inner sphere
plot(inner_radii / kiloparsec_meters, galactic_rotational_velocity(inner_radii, galactic_mass * (inner_radii / max(inner_radii)).^3) / 1000, '-b');

% plot outside inner sphere
plot(outer_radii / kiloparsec_meters, galactic_rotational_velocity(outer_radii, galactic_mass) / 1000, '-b');

% add labels
title('Orbital Radius vs Orbital Velocity');
xlabel('Orbital Radius (kpc)');
ylabel('Orbital Velocity (km/s)');

% add legend
legend('HI Clouds', 'Sun');

hold off;
%%
norm_OrbVel = max(orbital_velocities/1000);
norm_TheorVelInner = max(galactic_rotational_velocity(inner_radii, galactic_mass * (inner_radii / max(inner_radii)).^3) / 1000);
norm_TheorVelOuter = max(galactic_rotational_velocity(outer_radii, galactic_mass) / 1000);
%Replot the curves, but normalized
figure 
hold on;

% plot calculated positions
plot(orbital_radii / kiloparsec_meters, (orbital_velocities / 1000)./norm_OrbVel, 'x');

% add point for Sun
plot(sun_orbital_radius / kiloparsec_meters, (sun_orbital_speed / 1000)./norm_OrbVel, 'o');

%add error bars
errorbar(orbital_radii / kiloparsec_meters, (orbital_velocities / 1000)./norm_OrbVel, (orbital_velocities_uncertainties / 1000)./max(orbital_velocities_uncertainties / 1000), (orbital_velocities_uncertainties / 1000)./max(orbital_velocities_uncertainties / 1000), orbital_radii_uncertainties / kiloparsec_meters, orbital_radii_uncertainties / kiloparsec_meters, 'b')
errorbar(sun_orbital_radius / kiloparsec_meters, (sun_orbital_speed / 1000)./norm_OrbVel, 0, 0, sun_orbital_radius_uncertainty / kiloparsec_meters, sun_orbital_radius_uncertainty / kiloparsec_meters)

%plot theoretical rotation curve
% plot inside inner sphere
plot(inner_radii / kiloparsec_meters, (galactic_rotational_velocity(inner_radii, galactic_mass * (inner_radii / max(inner_radii)).^3) / 1000)./norm_TheorVelInner, '-b');

% plot outside inner sphere
plot(outer_radii / kiloparsec_meters, (galactic_rotational_velocity(outer_radii, galactic_mass) / 1000)./norm_TheorVelOuter, '-b');

% add labels
title('Normalized Orbital Radius vs Orbital Velocity');
xlabel('Orbital Radius (kpc)');
ylabel('Orbital Velocity (km/s)');

% add legend
legend('HI Clouds', 'Sun');

hold off;