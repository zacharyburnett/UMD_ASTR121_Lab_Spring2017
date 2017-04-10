% point source (constant mass)

% define mass of galaxy
galactic_mass = 5.8e11 * 1.989e30; % Vayntrub, Alina (2000). "Mass of the Milky Way". The Physics Factbook. Archived from the original on August 13, 2014. Retrieved May 9, 2007.4

% define meters in a kiloparsec
kiloparsec_meters = 3.086e19; % wikipedia

% define total galactic radius
galactic_radius = 15 * kiloparsec_meters;

% get linspace of radii
radii = linspace(0, galactic_radius, 1000);

% get velocities
velocities_m_s = galactic_rotational_velocity(radii, galactic_mass);

% start plotting
hold on

% plot constant mass (point mass)
plot(radii / kiloparsec_meters, galactic_rotational_velocity(radii, galactic_mass) / 1000);

% plot mass proportional to radius
plot(radii / kiloparsec_meters, galactic_rotational_velocity(radii, galactic_mass * (radii / galactic_radius)) / 1000);

% plot mass proportional to radius cubed
plot(radii / kiloparsec_meters, galactic_rotational_velocity(radii, galactic_mass * (radii / galactic_radius).^3) / 1000);

xlabel('Radius (kpc)');
ylabel('Velocity (km/s)');

legend('point mass', 'proportional to radius', 'proportional to radius cubed');

hold off