
% create new tab group to contain plots as tabs
tab_group = uitabgroup;

for current_galaxy_name_index = 1:numel(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    
    intensity_data = galaxy_data_struct.(current_galaxy_name).data;
    
    [pks, locs, ~, prom] = findpeaks(intensity_data, wavelengths, 'MinPeakProminence', 0.1);

    current_tab = uitab(tab_group, 'Title', current_galaxy_name);
    axes('Parent', current_tab);
    
    findpeaks(intensity_data, wavelengths, 'MinPeakProminence', 0.1, 'Annotate', 'extents')
    
    for index = 1:length(prom)
        text(locs(index) + 0.02, pks(index), {string(round(prom(index), 2) * 10)})
    end
    
    [pks, locs, ~, prom] = findpeaks(-1 * intensity_data, wavelengths, 'MinPeakProminence', 0.1);
    
    for index = 1:length(prom)
        text(locs(index) + 0.02, -pks(index), {string(round(prom(index), 3) * 10)})
    end
end