% All wavelength info is the same for each. 
% intensity values are in the 'data' field of the struct

% define wavelengths in angstroms
wavelengths = 3650:2:7100;

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% define plotting colors
colors = jet(length(galaxy_names));

for index = 1:numel(galaxy_names)
    %figure
    hold on
    plot(wavelengths, galaxy_data_struct.(galaxy_names{index}).data, 'color', colors(index, :));
    hold off
    %title(galaxy_names{index});
end

legend(galaxy_names);
