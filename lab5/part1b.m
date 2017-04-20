% define meters in a kiloparsec
kiloparsec_meters = 1000 * 3.086e+16;

% define mass of the Sun
solar_mass = 1.989e30;

% define mass of galaxy
galactic_mass = 1e12 * solar_mass;

% define total galactic radius
galactic_radius = 2 * kiloparsec_meters;

% get linspace of inner radii
inner_radii = linspace(0, galactic_radius, 500);

% get linspace of outer radii
outer_radii = linspace(galactic_radius, 8 * kiloparsec_meters, 500);

% start plotting
hold on

% plot inside inner sphere
plot(inner_radii / kiloparsec_meters, galactic_rotational_velocity(inner_radii, galactic_mass * (inner_radii / max(inner_radii)).^3) / 1000, '-b');

% plot outside inner sphere
plot(outer_radii / kiloparsec_meters, galactic_rotational_velocity(outer_radii, galactic_mass) / 1000, '-b');

% add labels
title('Rotational Velocity vs Orbital Radius: Spherical Mass of Radius 2 kpc');
xlabel('Orbital Radius (kpc)');
ylabel('Orbital Velocity (km/s)');

hold off