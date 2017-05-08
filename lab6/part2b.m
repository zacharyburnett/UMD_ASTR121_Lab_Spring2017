% Find Doppler shifts of each spectra based on fit to rest wavelengths

% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define range of wavelengths in angstroms
wavelengths = 3650:2:7100;

% define rest wavelengths of the first nine entries in the Balmer (Hydrogen) series, as well as of Calcium II (K and H) and Sulfur
spectral_line_wavelengths = [6562.8, 6731, 6717, 4861.3, 4340.5, 4101.7, 3970.1, 3968.5, 3933.7, 3889.1, 3645.6];
spectral_line_names = {'Balmer alpha', 'Sulfur 1', 'Sulfur 2', 'Balmer beta', 'Balmer gamma', 'Balmer delta', 'Balmer epsilon', 'Ca II H', 'Ca II K', 'Balmer zeta', 'Balmer eta'};
spectral_line_types = {'emission', 'emission', 'emission', 'emission', 'emission', 'emission', 'emission', 'absorption', 'absorption', 'emission', 'emission'};

% specify selected spectral lines
selection = [1,8,9];

% get selection
selected_wavelengths = spectral_line_wavelengths(selection);
selected_properties = spectral_line_types(selection);
selected_names = spectral_line_names(selection);

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% define plotting colors
data_colors = winter(length(galaxy_names));
shift_colors = winter(1);
spectral_line_colors = fliplr(jet(length(spectral_line_wavelengths)));

% create new tab group to contain plots as tabs
tab_group = uitabgroup;

% define potential shifts to iterate over
potential_shifts = 0:2:round((max(wavelengths) - selected_wavelengths(1)) / 3);

% create array to hold calculated redshifts
calculated_shifts = array2table(zeros(length(potential_shifts), length(galaxy_names)), 'VariableNames', galaxy_names');

% plot separately
for current_galaxy_name_index = 1:numel(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    
    intensity_data = galaxy_data_struct.(current_galaxy_name).data;
    
    [~, local_maxima_wavelengths, ~, local_maxima_prominences] = findpeaks(intensity_data, wavelengths, 'MinPeakProminence', 0.4);
    [~, local_minima_wavelengths, ~, local_minima_prominences] = findpeaks(intensity_data * -1, wavelengths, 'MinPeakProminence', 0.3);
    
    residuals = zeros(length(potential_shifts), length(selection));
    
    for current_potential_shift_index = 1:length(potential_shifts)
        current_potential_shift = potential_shifts(current_potential_shift_index);
        
        for current_spectral_line_index = 1:length(selection)
            current_wavelength = selected_wavelengths(current_spectral_line_index);
            
            if strcmp(selected_properties(current_spectral_line_index), 'emission')
                [~, nearest_extrema_index] = min(abs((current_wavelength + current_potential_shift) - local_maxima_wavelengths) ./ local_maxima_prominences');
                residuals(current_potential_shift_index, current_spectral_line_index) = local_maxima_wavelengths(nearest_extrema_index) - (current_wavelength + current_potential_shift);
            else % else assume absorption
                [~, nearest_extrema_index] = min(abs((current_wavelength + current_potential_shift) - local_minima_wavelengths) ./ local_minima_prominences');
                residuals(current_potential_shift_index, current_spectral_line_index) = local_minima_wavelengths(nearest_extrema_index) - (current_wavelength + current_potential_shift);
            end
        end
    end
    
    residual_sumsquares = sum(residuals.^2, 2);
    
    [~, sorted_residual_sumsquares_indices] = sort(residual_sumsquares);
    
    calculated_shifts.(current_galaxy_name) = potential_shifts(sorted_residual_sumsquares_indices)';
    
    current_tab = uitab(tab_group, 'Title', current_galaxy_name);
    axes('Parent', current_tab);
    
    hold on
    
    %plot(wavelengths, intensity_data, 'k');
    
    for current_shift_index = 1:size(shift_colors, 1)
        current_shift = calculated_shifts.(current_galaxy_name)(current_shift_index);
        plot(wavelengths - current_shift, intensity_data, 'color', shift_colors(current_shift_index, :));
    end
    
    for current_spectral_line_index = 1:length(spectral_line_wavelengths)
        current_wavelength = spectral_line_wavelengths(current_spectral_line_index);
        line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(current_spectral_line_index, :), 'LineStyle', '--');
    end
    
    title(current_galaxy_name);
    legend([strcat('shift:', {' '}, string(calculated_shifts.(current_galaxy_name)(1:size(shift_colors, 1)))), spectral_line_names]);
    
    hold off
end

% plot combined
current_tab = uitab(tab_group, 'Title', 'Combined Shifted Data');
axes('Parent', current_tab);

hold on

for current_galaxy_name_index = 1:numel(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    plot(wavelengths - calculated_shifts.(current_galaxy_name)(1), galaxy_data_struct.(current_galaxy_name).data, 'color', data_colors(current_galaxy_name_index, :));
end

for current_wavelength_index = 1:length(spectral_line_wavelengths)
    current_wavelength = spectral_line_wavelengths(current_wavelength_index);
    line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(current_wavelength_index, :), 'LineStyle', '--');
end

title('Combined Shifted Data');
legend([galaxy_names', spectral_line_names]);

hold off
