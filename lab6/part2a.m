% Plot all spectra separately, with lines for each rest wavelength

% define range of wavelengths in angstroms
wavelengths = 3650:2:7100;

% define rest wavelengths of the first nine entries in the Balmer (Hydrogen) series, as well as of Calcium II (K and H) and Sulfur
spectral_lines = table([6730.815; 6716.726; 6584; 6562.79; 6548; 4861.35; 4340.472; 4101.734; 3970.075; 3968.5; 3933.7; 3889.064], ...
    {'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'absorption'; 'absorption'; 'emission'}, ...
    'VariableNames', {'Wavelength_A', 'Type'}, ...
    'RowNames', {'SII1'; 'SII2'; 'NII1'; 'H\alpha'; 'NII2'; 'H\beta'; 'H\gamma'; 'H\delta'; 'H\epsilon'; 'CaIIH'; 'CaIIK'; 'H\zeta'});

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct)';

% define plotting colors
data_colors = winter(length(galaxy_names));
spectral_line_colors = jet(length(wavelengths));

% create new tab group to contain plots as tabs
tab_group = uitabgroup;

% plot separately
for current_galaxy_name_index = 1:length(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    intensity_data = galaxy_data_struct.(current_galaxy_name).data;
    
    current_tab = uitab(tab_group, 'Title', current_galaxy_name);
    axes('Parent', current_tab);
    
    hold on
    
    plot(wavelengths, intensity_data, 'k');
    
    for current_spectral_line_index = 1:height(spectral_lines)
        current_wavelength = spectral_lines.Wavelength_A(current_spectral_line_index);
        line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(round((current_wavelength - min(wavelengths)) / range(wavelengths) * length(spectral_line_colors)), :), 'LineStyle', '--');
    end
    
    title(current_galaxy_name);
    legend([current_galaxy_name, spectral_lines.Properties.RowNames']);
    xlabel('Wavelength (Angstroms)');
    ylabel('Intensity');
    
    hold off
end

% plot combined
current_tab = uitab(tab_group, 'Title', 'Combined Unshifted Data');
axes('Parent', current_tab);

hold on

for current_galaxy_name_index = 1:length(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    plot(wavelengths, galaxy_data_struct.(current_galaxy_name).data, 'color', data_colors(current_galaxy_name_index, :));
end

for current_spectral_line_index = 1:height(spectral_lines)
    current_wavelength = spectral_lines.Wavelength_A(current_spectral_line_index);
    line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(round((current_wavelength - min(wavelengths)) / range(wavelengths) * length(spectral_line_colors)), :), 'LineStyle', '--');
end

title('Combined Unshifted Data');
legend([galaxy_names, spectral_lines.Properties.RowNames']);
xlabel('Wavelength (Angstroms)');
ylabel('Intensity');
    
hold off