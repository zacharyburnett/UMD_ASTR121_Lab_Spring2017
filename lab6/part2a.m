% All wavelength info is the same for each. 
% intensity values are in the 'data' field of the struct

% define wavelengths in angstroms
wavelengths = 3650:2:7100;
calcium_ii_k_wavelength = 3933.7;
calcium_ii_h_wavelength = 3968.5;
hydrogen_alpha_wavelength = 6562.8;

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% plot separately
for index = 1:numel(galaxy_names)
    figure
    hold on
    plot(wavelengths, galaxy_data_struct.(galaxy_names{index}).data, 'k');    
    line([calcium_ii_k_wavelength calcium_ii_k_wavelength], get(gca, 'YLim'), 'color', 'b');
    line([calcium_ii_h_wavelength calcium_ii_h_wavelength], get(gca, 'YLim'), 'color', 'g');
    line([hydrogen_alpha_wavelength hydrogen_alpha_wavelength], get(gca, 'YLim'), 'color', 'r');
    
    title(galaxy_names{index});
    legend([galaxy_names(index), 'Ca II K rest', 'Ca II H rest', 'H Alpha rest'])
    hold off
end