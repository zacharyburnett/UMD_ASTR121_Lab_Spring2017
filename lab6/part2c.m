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
colors = lines(5);

% create array to hold calculated redshifts
calculated_shifts = array2table(zeros(5, length(galaxy_names)), 'VariableNames', galaxy_names');

% plot separately
for galaxy_name_index = 1:numel(galaxy_names)
    galaxy_name = galaxy_names(galaxy_name_index);
    galaxy_name = galaxy_name{1};
    
    intensity_data = galaxy_data_struct.(galaxy_name).data;
    
    [~, local_maxima_indices] = findpeaks(intensity_data);
    [~, local_minima_indices] = findpeaks(intensity_data * -1);
    
    potential_shifts = 0:2:round(max(wavelengths) - hydrogen_alpha_wavelength - 1);
    
    residuals = zeros(length(potential_shifts), 3);
    
    for potential_shift = 1:length(potential_shifts)
        % for calcium II k wavelength
        [~, calcium_ii_k_nearest_valley_index] = min(abs((calcium_ii_k_wavelength + potential_shift) - wavelengths(local_minima_indices)));
        residuals(potential_shift, 1) = wavelengths(local_minima_indices(calcium_ii_k_nearest_valley_index)) - (hydrogen_alpha_wavelength + potential_shift);
        
        % for calcium II h wavelength
        [~, calcium_ii_h_nearest_valley_index] = min(abs((calcium_ii_h_wavelength + potential_shift) - wavelengths(local_minima_indices)));
        residuals(potential_shift, 2) = wavelengths(local_minima_indices(calcium_ii_h_nearest_valley_index)) - (hydrogen_alpha_wavelength + potential_shift);
        
        % for hydrogen alpha wavelength
        [~, hydrogen_alpha_nearest_peak_index] = min(abs((hydrogen_alpha_wavelength + potential_shift) - wavelengths(local_maxima_indices)));
        residuals(potential_shift, 3) = wavelengths(local_maxima_indices(hydrogen_alpha_nearest_peak_index)) - (hydrogen_alpha_wavelength + potential_shift);
    end
    
    residual_sumsquares = sum(residuals.^2, 2);
    
    [~, sorted_residual_sumsquares_indices] = sort(residual_sumsquares);
    
    sorted_shifts = potential_shifts(sorted_residual_sumsquares_indices);
    
    shifted_calcium_ii_k_wavelength = calcium_ii_k_wavelength + sorted_shifts(1:5);
    shifted_calcium_ii_h_wavelength = calcium_ii_h_wavelength + sorted_shifts(1:5);
    shifted_hydrogen_alpha_wavelength = hydrogen_alpha_wavelength + sorted_shifts(1:5);
    
    figure
    hold on
    
    plot(wavelengths, intensity_data, 'k');
    
    line([calcium_ii_k_wavelength calcium_ii_k_wavelength], get(gca, 'YLim'), 'color', 'b');
    line([calcium_ii_h_wavelength calcium_ii_h_wavelength], get(gca, 'YLim'), 'color', 'g');
    line([hydrogen_alpha_wavelength hydrogen_alpha_wavelength], get(gca, 'YLim'), 'color', 'r');
    
    for shift_index = 1:5
        line([calcium_ii_k_wavelength + sorted_shifts(shift_index) calcium_ii_k_wavelength + sorted_shifts(shift_index)], get(gca, 'YLim'), 'LineStyle', '--', 'color', colors(shift_index, :));
    end
    
    for shift_index = 1:5
        line([calcium_ii_h_wavelength + sorted_shifts(shift_index) calcium_ii_h_wavelength + sorted_shifts(shift_index)], get(gca, 'YLim'), 'LineStyle', '-.', 'color', colors(shift_index, :));
    end
    
    for shift_index = 1:5
        line([hydrogen_alpha_wavelength + sorted_shifts(shift_index) hydrogen_alpha_wavelength + sorted_shifts(shift_index)], get(gca, 'YLim'), 'LineStyle', ':', 'color', colors(shift_index, :));
    end
    
    title(galaxy_name);
    legend([galaxy_name, 'Ca II K rest', 'Ca II H rest', 'H Alpha rest', strcat('Ca II K shifted ', string(1:5)), strcat('Ca II H shifted ', string(1:5)), strcat('H Alpha shifted ', string(1:5))])
    
    hold off
    
    calculated_shifts.(galaxy_name) = sorted_shifts(1:5)';
end