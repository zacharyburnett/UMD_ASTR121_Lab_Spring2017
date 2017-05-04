% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define wavelengths in angstroms
wavelengths = 3650:2:7100;
calcium_ii_k_wavelength = 3933.7;
calcium_ii_h_wavelength = 3968.5;
hydrogen_alpha_wavelength = 6562.8;

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% define plotting colors
colors = jet(length(galaxy_names));

% plot all together
hold on

for galaxy_name_index = 1:numel(galaxy_names)
    plot(wavelengths, galaxy_data_struct.(galaxy_names{galaxy_name_index}).data, 'color', colors(galaxy_name_index, :));
end

line([calcium_ii_k_wavelength calcium_ii_k_wavelength], get(gca, 'YLim'), 'color', 'b');
line([calcium_ii_h_wavelength calcium_ii_h_wavelength], get(gca, 'YLim'), 'color', 'g');
line([hydrogen_alpha_wavelength hydrogen_alpha_wavelength], get(gca, 'YLim'), 'color', 'r');

legend([galaxy_names', 'Ca II K rest', 'Ca II H rest', 'H Alpha rest']);

hold off