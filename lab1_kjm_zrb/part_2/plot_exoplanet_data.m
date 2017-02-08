time_values = 1:365;
amplitude = 40;
period = 67;
error = 0.2;

clf
hold on
plot(generate_exoplanet_data(time_values, period, amplitude, error))
xlabel('Time (days)');
ylabel('Meters per Second');
title('Generated Radial Velocity Curve')
hold off