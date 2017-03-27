% formula from
% http://www.astro.sunysb.edu/fwalter/AST443/b-v_temp.html
%temperature = 8540 / (color_index + 0.865);

color_indices = [0.5, 1.8, -0.03];

num_wavelengths = 1000;

wavelengths_nm = linspace(100, 800, num_wavelengths);

temperatures = temperature_from_colorindex(color_indices);

normalized_intensities = array2table(zeros(num_wavelengths, 3));

for index = 1:length(temperatures)
    current_intensities = blackbody_intensity(wavelengths_nm * 1e-9, temperatures(index));
    normalized_intensities{:, index} = reshape(current_intensities ./ max(current_intensities), [1000 1]);
end

% start plotting
hold on

% plot Planck intensities
for index = 1:length(temperatures)
    plot(wavelengths_nm, normalized_intensities{:, index});
end

% get y limit from axes
y_limit = get(gca,'ylim');

% Blue is centered on 445 nm, with a range of 380 nm - 510 nm or 495 nm,
% and a full width half max range of 398 nm - 492 nm
blue_area = fill([398 398 492 492], [y_limit fliplr(y_limit)], 'b','EdgeColor','none');

% Visual is centered on 551 nm, with a range of 380 nm - 722 nm or 750 nm
% and a full width half max range of 507 nm - 595 nm
visual_area = fill([507 507 595 595], [y_limit fliplr(y_limit)], 'g','EdgeColor','none');

% flip children to make line show on top of filled areas
set(gca, 'children', flipud(get(gca,'children')));

% add labels
title('Normalized Planck Intenisites vs Wavelength (nm) with B and V Filter Regions');
xlabel('Wavelength');
ylabel('Intensity');

legend('Visual Region', 'Blue Region', 'Color Index -0.03', 'Color Index 1.8', 'Color Index 0.5');

hold off