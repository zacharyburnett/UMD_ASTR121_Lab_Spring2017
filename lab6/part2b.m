% Find Doppler shifts of each spectra based on fit to rest wavelengths

% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define range of wavelengths in angstroms
wavelengths = 3650:2:7100;

% define rest wavelengths of the first nine entries in the Balmer (Hydrogen) series, as well as of Calcium II (K and H)
rest_wavelengths = [6562.8, 4861.3, 4340.5, 4101.7, 3970.1, 3968.5, 3933.7, 3889.1, 3645.6];
rest_wavelengths_names = {'Balmer alpha', 'Balmer beta', 'Balmer gamma', 'Balmer delta', 'Balmer epsilon', 'Ca II H', 'Ca II K', 'Balmer zeta', 'Balmer eta'};
rest_wavelength_property = ['emission', 'emission', 'emission', 'emission', 'emission', 'absorption', 'absorption', 'emission', 'emission'];

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% define plotting colors
line_colors = winter(3);
rainbow_colors = fliplr(jet(length(rest_wavelengths)));

% create new tab group to contain plots as tabs
tab_group = uitabgroup;

% create array to hold calculated redshifts
calculated_shifts = array2table(zeros(5, length(galaxy_names)), 'VariableNames', galaxy_names');

% plot separately
for galaxy_name_index = 1:numel(galaxy_names)
    galaxy_name = galaxy_names(galaxy_name_index);
    galaxy_name = galaxy_name{1};
    
    intensity_data = galaxy_data_struct.(galaxy_name).data;
    
    [~, local_maxima_indices] = findpeaks(intensity_data);
    [~, local_minima_indices] = findpeaks(intensity_data * -1);
    
    potential_shifts = 0:2:round(max(wavelengths) - rest_wavelengths(1));
    
    residuals = zeros(length(potential_shifts), 9);
    
    for potential_shift_index = 1:length(potential_shifts)
        potential_shift = potential_shifts(potential_shift_index);
        
        for rest_wavelength_index = 1:length(rest_wavelengths)
            rest_wavelength = rest_wavelengths(rest_wavelength_index);
            
            if strcmp(rest_wavelength_property(rest_wavelength_index), 'emission')
                [~, nearest_extrema_index] = min(abs((rest_wavelength + potential_shift) - wavelengths(local_maxima_indices)));
                residuals(potential_shift_index, rest_wavelength_index) = wavelengths(local_maxima_indices(nearest_extrema_index)) - (rest_wavelength + potential_shift);
            else % else assume absorption
                [~, nearest_extrema_index] = min(abs((rest_wavelength + potential_shift) - wavelengths(local_minima_indices)));
                residuals(potential_shift_index, rest_wavelength_index) = wavelengths(local_minima_indices(nearest_extrema_index)) - (rest_wavelength + potential_shift);
            end
        end
    end
    
    residual_sumsquares = sum(residuals.^2, 2);
    
    [~, sorted_residual_sumsquares_indices] = sort(residual_sumsquares);
    
    sorted_shifts = potential_shifts(sorted_residual_sumsquares_indices);
    
    calculated_shifts.(galaxy_name) = sorted_shifts(1:5)';
    
    current_tab = uitab(tab_group, 'Title', galaxy_name);
    axes('Parent', current_tab);
    
    hold on
    
    plot(wavelengths, intensity_data, 'k');
      
    for shift_index = 1:length(line_colors)
        plot(wavelengths - sorted_shifts(shift_index), intensity_data, 'color', line_colors(shift_index, :));
    end
    
    for rest_wavelength_index = 1:length(rest_wavelengths)
        rest_wavelength = rest_wavelengths(rest_wavelength_index);
        line([rest_wavelength rest_wavelength], get(gca, 'YLim'), 'color', rainbow_colors(rest_wavelength_index, :), 'LineStyle', '--');
    end
    
    title(galaxy_name);
    legend([galaxy_name, strcat('shift:', {' '}, string(sorted_shifts(1:length(line_colors)))), rest_wavelengths_names]);
    
    hold off
end
