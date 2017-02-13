time_values = 1:365;
amplitude = 40;
period = 147;
error = 0.2;

sine_wave = generate_exoplanet_data(time_values, period, amplitude);

% get uncertainties inside the given error range
uncertainties = sine_wave .* random('uniform', -error, error, 1, length(time_values));

% apply uncertanties to generated data
generated_data = sine_wave + uncertainties;

% plot
clf
hold on
errorbar(generated_data, repmat(std(uncertainties), 1, length(generated_data)), '.');
xlabel('Time (days)');
ylabel('Meters per Second');
title('Generated Radial Velocity Curve')
hold off