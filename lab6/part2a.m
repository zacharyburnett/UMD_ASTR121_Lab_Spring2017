% Plot all spectra separately, with lines for each rest wavelength

% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define range of wavelengths in angstroms
wavelengths = 3650:2:7100;

% define rest wavelengths of the first nine entries in the Balmer (Hydrogen) series, as well as of Calcium II (K and H) and Sulfur
spectral_line_names = {'Balmer alpha', 'Sulfur 1', 'Sulfur 2', 'Balmer beta', 'Balmer gamma', 'Balmer delta', 'Balmer epsilon', 'Ca II H', 'Ca II K', 'Balmer zeta', 'Balmer eta'};
spectral_line_types = {'emission', 'emission', 'emission', 'emission', 'emission', 'emission', 'emission', 'absorption', 'absorption', 'emission', 'emission'};

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% define plotting colors
data_colors = winter(length(galaxy_names));
spectral_line_colors = jet(length(spectral_line_wavelengths));

% create new tab group to contain plots as tabs
tab_group = uitabgroup;

% plot separately
for current_galaxy_name_index = 1:numel(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    intensity_data = galaxy_data_struct.(current_galaxy_name).data;
    
    current_tab = uitab(tab_group, 'Title', current_galaxy_name);
    axes('Parent', current_tab);
    
    hold on
    
    plot(wavelengths, intensity_data, 'k');
    
    for current_wavelength_index = 1:length(spectral_line_wavelengths)
        current_wavelength = spectral_line_wavelengths(current_wavelength_index);
        line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(current_wavelength_index, :), 'LineStyle', '--');
    end
    
    title(current_galaxy_name);
    legend([current_galaxy_name, spectral_line_names]);
    
    hold off
end

% plot combined
current_tab = uitab(tab_group, 'Title', 'Combined Data');
axes('Parent', current_tab);

hold on

for current_galaxy_name_index = 1:numel(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    plot(wavelengths, galaxy_data_struct.(current_galaxy_name).data, 'color', data_colors(current_galaxy_name_index, :));
end

for current_wavelength_index = 1:length(spectral_line_wavelengths)
    current_wavelength = spectral_line_wavelengths(current_wavelength_index);
    line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(current_wavelength_index, :), 'LineStyle', '--');
end

title('Combined Data');
legend([galaxy_names', spectral_line_names]);

hold off

% plot combined and normalized
current_tab = uitab(tab_group, 'Title', 'Normalized Combined Data');
axes('Parent', current_tab);

hold on

for current_galaxy_name_index = 1:numel(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    plot(wavelengths, galaxy_data_struct.(current_galaxy_name).data / max(galaxy_data_struct.(current_galaxy_name).data), 'color', data_colors(current_galaxy_name_index, :));
end

for current_wavelength_index = 1:length(spectral_line_wavelengths)
    current_wavelength = spectral_line_wavelengths(current_wavelength_index);
    line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(current_wavelength_index, :), 'LineStyle', '--');
end

title('Normalized Combined Data');
legend([galaxy_names', spectral_line_names]);

hold off