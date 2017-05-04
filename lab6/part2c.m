% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define wavelengths in angstroms
wavelengths = 3650:2:7100;
calcium_ii_k_wavelength = 3933.7;
calcium_ii_h_wavelength = 3968.5;
hydrogen_alpha_wavelength = 6562.8;

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

calculated_shifts = zeros(1, length(galaxy_names));

% plot separately
for galaxy_name_index = 1:numel(galaxy_names)
    intensity_data = galaxy_data_struct.(galaxy_names{galaxy_name_index}).data;

    [~, local_maxima_indices] = findpeaks(intensity_data);
    [~, local_minima_indices] = findpeaks(intensity_data * -1);

    potential_shifts = -round(max(wavelengths) - hydrogen_alpha_wavelength - 1):2:round(max(wavelengths) - hydrogen_alpha_wavelength - 1);

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

    [~, shift_index] = min(residual_sumsquares);

    calculated_shift = potential_shifts(shift_index);

    figure
    hold on

    plot(wavelengths, intensity_data, 'k');

    line([calcium_ii_k_wavelength calcium_ii_k_wavelength], get(gca, 'YLim'));
    line([calcium_ii_h_wavelength calcium_ii_h_wavelength], get(gca, 'YLim'));
    line([hydrogen_alpha_wavelength hydrogen_alpha_wavelength], get(gca, 'YLim'));

    calcium_ii_k_wavelength_shifted = calcium_ii_k_wavelength + calculated_shift;
    calcium_ii_h_wavelength_shifted = calcium_ii_h_wavelength + calculated_shift;
    hydrogen_alpha_wavelength_shifted = hydrogen_alpha_wavelength + calculated_shift;

    line([calcium_ii_k_wavelength_shifted calcium_ii_k_wavelength_shifted], get(gca, 'YLim'));
    line([calcium_ii_h_wavelength_shifted calcium_ii_h_wavelength_shifted], get(gca, 'YLim'));
    line([hydrogen_alpha_wavelength_shifted hydrogen_alpha_wavelength_shifted], get(gca, 'YLim'));

    title(galaxy_names(galaxy_name_index));
    legend([galaxy_names(galaxy_name_index), 'Ca II K rest', 'Ca II H rest', 'H Alpha rest', 'Ca II K shifted', 'Ca II H shifted', 'H Alpha shifted'])
    
    hold off
    
    calculated_shifts(galaxy_name_index) = calculated_shift;
end