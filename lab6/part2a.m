% Plot all spectra separately, with lines for each rest wavelength

% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define range of wavelengths in angstroms
wavelengths = 3650:2:7100;

% define rest wavelengths of the first nine entries in the Balmer (Hydrogen) series, as well as of Calcium II (K and H)
rest_wavelengths = [6562.8, 4861.3, 4340.5, 4101.7, 3970.1, 3968.5, 3933.7, 3889.1, 3645.6];
rest_wavelengths_names = {'Balmer alpha', 'Balmer beta', 'Balmer gamma', 'Balmer delta', 'Balmer epsilon', 'Ca II H', 'Ca II K', 'Balmer zeta', 'Balmer eta'};

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% define plotting colors
line_colors = winter(length(galaxy_names));
rainbow_colors = jet(length(rest_wavelengths));

% create new tab group to contain plots as tabs
tab_group = uitabgroup;

% plot combined
current_tab = uitab(tab_group, 'Title', 'Combined Plot');
axes('Parent', current_tab);

% plot all together
hold on

for galaxy_name_index = 1:numel(galaxy_names)
    plot(wavelengths, galaxy_data_struct.(galaxy_names{galaxy_name_index}).data, 'color', line_colors(galaxy_name_index, :));
end

for rest_wavelength_index = 1:length(rest_wavelengths)
    rest_wavelength = rest_wavelengths(rest_wavelength_index);
    line([rest_wavelength rest_wavelength], get(gca, 'YLim'), 'color', rainbow_colors(length(rest_wavelengths) - rest_wavelength_index + 1, :), 'LineStyle', '--');
end

title('Combined Plot');
legend([galaxy_names', rest_wavelengths_names]);

hold off

% plot combined and normalized
current_tab = uitab(tab_group, 'Title', 'Normalized Combined Plot');
axes('Parent', current_tab);

hold on

for galaxy_name_index = 1:numel(galaxy_names)
    plot(wavelengths, galaxy_data_struct.(galaxy_names{galaxy_name_index}).data / max(galaxy_data_struct.(galaxy_names{galaxy_name_index}).data), 'color', line_colors(galaxy_name_index, :));
end

for rest_wavelength_index = 1:length(rest_wavelengths)
    rest_wavelength = rest_wavelengths(rest_wavelength_index);
    line([rest_wavelength rest_wavelength], get(gca, 'YLim'), 'color', rainbow_colors(length(rest_wavelengths) - rest_wavelength_index + 1, :), 'LineStyle', '--');
end

title('Normalized Combined Plot');
legend([galaxy_names', rest_wavelengths_names]);

hold off

% plot separately
for galaxy_name_index = 1:numel(galaxy_names)
    galaxy_name = galaxy_names{galaxy_name_index};
    intensity_data = galaxy_data_struct.(galaxy_name).data;
    
    current_tab = uitab(tab_group, 'Title', galaxy_name);
    axes('Parent', current_tab);
    
    hold on
    
    plot(wavelengths, intensity_data, 'k');
    
    for rest_wavelength_index = 1:length(rest_wavelengths)
        rest_wavelength = rest_wavelengths(rest_wavelength_index);
        line([rest_wavelength rest_wavelength], get(gca, 'YLim'), 'color', rainbow_colors(length(rest_wavelengths) - rest_wavelength_index + 1, :), 'LineStyle', '--');
    end
    
    title(galaxy_name);
    legend([galaxy_name, rest_wavelengths_names]);
    
    hold off
end