% Find Doppler shifts of each spectra based on fit to rest wavelengths

% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define wavelengths in angstroms
wavelengths = 3650:2:7100;
calcium_ii_k_angstroms = 3933.7; % valley
calcium_ii_h_angstroms = 3968.5; % valley

balmer_alpha_angstroms = 6562.8; % peak
balmer_beta_angstroms = 4861.3; % peak
balmer_gamma_angstroms = 4340.5; % peak
balmer_delta_angstroms = 4101.7; % in valley
balmer_epsilon_angstroms = 3970.1; % in calcium ii H
balmer_zeta_angstroms = 3889.1; % in valley
balmer_eta_angstroms = 3645.6; % peak

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
    
    potential_shifts = 0:2:round(max(wavelengths) - balmer_alpha_angstroms - 1);
    
    residuals = zeros(length(potential_shifts), 9);
    
    for potential_shift_index = 1:length(potential_shifts)
        potential_shift = potential_shifts(potential_shift_index);
        
        % for calcium II k wavelength
        [~, nearest_valley_index] = min(abs((calcium_ii_k_angstroms + potential_shift) - wavelengths(local_minima_indices)));
        residuals(potential_shift_index, 1) = wavelengths(local_minima_indices(nearest_valley_index)) - (balmer_alpha_angstroms + potential_shift);
        
        % for calcium II h wavelength (peak)
        [~, nearest_valley_index] = min(abs((calcium_ii_h_angstroms + potential_shift) - wavelengths(local_minima_indices)));
        residuals(potential_shift_index, 2) = wavelengths(local_minima_indices(nearest_valley_index)) - (balmer_alpha_angstroms + potential_shift);
        
        % for balmer alpha wavelength (peak)
        [~, nearest_peak_index] = min(abs((balmer_alpha_angstroms + potential_shift) - wavelengths(local_maxima_indices)));
        residuals(potential_shift_index, 3) = wavelengths(local_maxima_indices(nearest_peak_index)) - (balmer_alpha_angstroms + potential_shift);
        
        % for balmer beta wavelength (peak)
        [~, nearest_peak_index] = min(abs((balmer_beta_angstroms + potential_shift) - wavelengths(local_maxima_indices)));
        residuals(potential_shift_index, 4) = wavelengths(local_maxima_indices(nearest_peak_index)) - (balmer_beta_angstroms + potential_shift);

        % for balmer gamma wavelength (peak)
        [~, nearest_peak_index] = min(abs((balmer_gamma_angstroms + potential_shift) - wavelengths(local_maxima_indices)));
        residuals(potential_shift_index, 5) = wavelengths(local_maxima_indices(nearest_peak_index)) - (balmer_gamma_angstroms + potential_shift);

        % for balmer delta wavelength (valley)
        [~, nearest_valley_index] = min(abs((balmer_delta_angstroms + potential_shift) - wavelengths(local_minima_indices)));
        residuals(potential_shift_index, 6) = wavelengths(local_minima_indices(nearest_valley_index)) - (balmer_delta_angstroms + potential_shift);

        % for balmer epsilon wavelength (calcium ii h valley)
        [~, nearest_valley_index] = min(abs((balmer_epsilon_angstroms + potential_shift) - wavelengths(local_minima_indices)));
        residuals(potential_shift_index, 7) = wavelengths(local_minima_indices(nearest_valley_index)) - (balmer_epsilon_angstroms + potential_shift);

        % for balmer zeta wavelength (valley)
        [~, nearest_valley_index] = min(abs((balmer_zeta_angstroms + potential_shift) - wavelengths(local_minima_indices)));
        residuals(potential_shift_index, 8) = wavelengths(local_minima_indices(nearest_valley_index)) - (balmer_zeta_angstroms + potential_shift);

        % for balmer eta wavelength (peak)
        [~, nearest_peak_index] = min(abs((balmer_eta_angstroms + potential_shift) - wavelengths(local_maxima_indices)));
        residuals(potential_shift_index, 9) = wavelengths(local_maxima_indices(nearest_peak_index)) - (balmer_eta_angstroms + potential_shift);
        
    end
    
    residual_sumsquares = sum(residuals.^2, 2);
    
    [~, sorted_residual_sumsquares_indices] = sort(residual_sumsquares);
    
    sorted_shifts = potential_shifts(sorted_residual_sumsquares_indices);
    
    figure
    hold on
    
    for shift_index = 1:5
        plot(wavelengths - sorted_shifts(shift_index), intensity_data, 'color', colors(shift_index, :));
    end
    
    line([calcium_ii_k_angstroms calcium_ii_k_angstroms], get(gca, 'YLim'), 'color', 'b');
    line([calcium_ii_h_angstroms calcium_ii_h_angstroms], get(gca, 'YLim'), 'color', 'g');
    
    line([balmer_alpha_angstroms balmer_alpha_angstroms], get(gca, 'YLim'), 'color', 'r');
    line([balmer_beta_angstroms balmer_beta_angstroms], get(gca, 'YLim'), 'color', 'r');
    line([balmer_gamma_angstroms balmer_gamma_angstroms], get(gca, 'YLim'), 'color', 'r');
    line([balmer_delta_angstroms balmer_delta_angstroms], get(gca, 'YLim'), 'color', 'r');
    line([balmer_epsilon_angstroms balmer_epsilon_angstroms], get(gca, 'YLim'), 'color', 'r');
    line([balmer_zeta_angstroms balmer_zeta_angstroms], get(gca, 'YLim'), 'color', 'r');
    line([balmer_eta_angstroms balmer_eta_angstroms], get(gca, 'YLim'), 'color', 'r');
    
    %for shift_index = 1:5
    %    line([calcium_ii_k_angstroms + sorted_shifts(shift_index) calcium_ii_k_angstroms + sorted_shifts(shift_index)], get(gca, 'YLim'), 'LineStyle', '--', 'color', colors(shift_index, :));
    %end
    
    %for shift_index = 1:5
    %    line([calcium_ii_h_angstroms + sorted_shifts(shift_index) calcium_ii_h_angstroms + sorted_shifts(shift_index)], get(gca, 'YLim'), 'LineStyle', '-.', 'color', colors(shift_index, :));
    %end
    
    %for shift_index = 1:5
    %    line([balmer_alpha_angstroms + sorted_shifts(shift_index) balmer_alpha_angstroms + sorted_shifts(shift_index)], get(gca, 'YLim'), 'LineStyle', ':', 'color', colors(shift_index, :));
    %end
    
    title(galaxy_name);
    legend(string(1:5));
    %legend(galaxy_name, 'Ca II K', 'Ca II H', 'Balmer series');%, strcat('Ca II K shifted ', string(1:5)), strcat('Ca II H shifted ', string(1:5)), strcat('H Alpha shifted ', string(1:5))])
    
    hold off
    
    calculated_shifts.(galaxy_name) = sorted_shifts(1:5)';
end