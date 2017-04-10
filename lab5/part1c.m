% linear mass

% define mass of galaxy
galactic_mass = 5.8e11; % Vayntrub, Alina (2000). "Mass of the Milky Way". The Physics Factbook. Archived from the original on August 13, 2014. Retrieved May 9, 2007.4

% define meters in a kiloparsec
kiloparsec_meters = 3.086e19; % wikipedia

% define total galactic radius
galactic_radius = 15 * kiloparsec_meters;

% get linspace of radii
radii = linspace(0, galactic_radius, 1000);

% get velocities
velocities_m_s = galactic_rotational_velocity(radii, galactic_mass * (radii.^3 / galactic_radius));

% start plotting
hold on

plot(radii / kiloparsec_meters, velocities_m_s / 1000);

xlabel('Radius (kpc)');
ylabel('Velocity (km/s)');

hold off