% define meters in a kiloparsec
kiloparsec_meters = 1000 * 3.086e+16;

% define mass of the Sun
solar_mass = 1.989e30;

% define mass of galaxy
galactic_mass = 5.8e11 * solar_mass; % Vayntrub, Alina (2000). "Mass of the Milky Way". The Physics Factbook. Archived from the original on August 13, 2014. Retrieved May 9, 2007.4

% define total galactic radius
galactic_radius = 15 * kiloparsec_meters;

% get linspace of radii
radii = linspace(0, galactic_radius, 1000);

% start plotting
hold on

% plot constant mass (point mass)
plot(radii / kiloparsec_meters, galactic_rotational_velocity(radii, galactic_mass) / 1000);

% plot mass proportional to radius
plot(radii / kiloparsec_meters, galactic_rotational_velocity(radii, galactic_mass * (radii / galactic_radius)) / 1000);

% plot mass proportional to radius cubed
plot(radii / kiloparsec_meters, galactic_rotational_velocity(radii, galactic_mass * (radii / galactic_radius).^3) / 1000);

% add labels
title('Rotational Velocity vs Orbital Radius: Mass Proportionalities');
xlabel('Orbital Radius (kpc)');
ylabel('Orbital Velocity (km/s)');

% set y axis limits
ylim([0, 1500]);

% add legend
legend('point mass', 'proportional to radius', 'proportional to radius cubed');

hold off