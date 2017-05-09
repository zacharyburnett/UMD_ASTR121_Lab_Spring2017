% Find Doppler shifts of each spectra based on fit to rest wavelengths

% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define range of wavelengths in angstroms
wavelengths = 3650:2:7100;

% wavelengths from http://physics.nist.gov/PhysRefData/ASD/lines_form.html

% sulfur and nitrogen found at https://en.wikipedia.org/wiki/Forbidden_mechanism

% define rest wavelengths of the first nine entries in the Balmer (Hydrogen) series, as well as of Calcium II (K and H) and Sulfur
spectral_lines = table([6730.815; 6716.726; 6584; 6562.79; 6548; 4861.35; 4340.472; 4101.734; 3970.075; 3968.5; 3933.7; 3889.064], ...
    {'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'absorption'; 'absorption'; 'emission'}, ...
    'VariableNames', {'wavelength', 'type'}, ...
    'RowNames', {'Sulfur II 1'; 'Sulfur II 2'; 'Nitrogen II 1'; 'Balmer alpha'; 'Nitrogen II 2'; 'Balmer beta'; 'Balmer gamma'; 'Balmer delta'; 'Balmer epsilon'; 'Ca II H'; 'Ca II K'; 'Balmer zeta'});

% specify selected spectral lines
selected_spectral_lines = spectral_lines;%spectral_lines([1:2,4,5:7,10:11], :);

% define aggressiveness of seeking prominence and intensity
peak_prominence_weight = 1;
valley_prominence_weight = 3;
peak_intensity_weight = 0;
valley_intensity_weight = 1;
peak_width_weight = 0;
valley_width_weight = 1;

% define minimum prominences for peaks and valleys
minimum_peak_prominence = 0.185;
minimum_valley_prominence = 0.185;

% define range of potential Doppler shifts
potential_shifts = 0:2:round((max(wavelengths) - max(spectral_lines.wavelength)));

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% define plotting colors
data_colors = winter(length(galaxy_names));
shift_colors = winter(1);
spectral_line_colors = fliplr(jet(height(spectral_lines)));
selected_spectral_line_colors = fliplr(jet(height(selected_spectral_lines)));

% create new tab group to contain plots as tabs
tab_group = uitabgroup;

% create array to hold calculated redshifts
doppler_shifts = array2table(zeros(length(galaxy_names), 3), ...
    'VariableNames', {'Shift_A'; 'Weighted_Uncertainty_A'; 'Unweighted_Uncertainty_A'}, ...
    'RowNames', galaxy_names);

% plot separately
for current_galaxy_name_index = 1:numel(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    
    intensity_data = galaxy_data_struct.(current_galaxy_name).data;
    
    [local_maxima_intensities, local_maxima_wavelengths, local_maxima_widths, local_maxima_prominences] = findpeaks(intensity_data, wavelengths);%, 'MinPeakProminence', minimum_peak_prominence);
    [local_minima_intensities, local_minima_wavelengths, local_minima_widths, local_minima_prominences] = findpeaks(intensity_data * -1, wavelengths);%, 'MinPeakProminence', minimum_valley_prominence);
    
    weighted_residuals = zeros(length(potential_shifts), height(selected_spectral_lines));
    unweighted_residuals = zeros(length(potential_shifts), height(selected_spectral_lines));
    
    weights = zeros(length(potential_shifts), height(selected_spectral_lines));
    
    for current_potential_shift_index = 1:length(potential_shifts)
        current_potential_shift = potential_shifts(current_potential_shift_index);
        
        for current_spectral_line_index = 1:height(selected_spectral_lines)
            current_wavelength = selected_spectral_lines.wavelength(current_spectral_line_index);
            
            if strcmp(selected_spectral_lines.type(current_spectral_line_index), 'emission')
                current_weights = ((local_maxima_prominences).^peak_prominence_weight ./ (local_maxima_widths').^peak_width_weight .* abs(local_maxima_intensities - mean(intensity_data)).^peak_intensity_weight)';
                [~, weighted_nearest_extrema_index] = min(abs((current_wavelength + current_potential_shift) - local_maxima_wavelengths) ./ current_weights);
                weights(current_potential_shift_index, current_spectral_line_index) = current_weights(weighted_nearest_extrema_index);
                weighted_residuals(current_potential_shift_index, current_spectral_line_index) = ((current_wavelength + current_potential_shift) - local_maxima_wavelengths(weighted_nearest_extrema_index));
                
                [~, unweighted_nearest_extrema_index] = min(abs((current_wavelength + current_potential_shift) - local_maxima_wavelengths));
                unweighted_residuals(current_potential_shift_index, current_spectral_line_index) = ((current_wavelength + current_potential_shift) - local_maxima_wavelengths(unweighted_nearest_extrema_index));
            else % else assume absorption
                current_weights = ((local_minima_prominences).^valley_prominence_weight ./ (local_minima_widths').^valley_width_weight ./ abs(local_minima_intensities - mean(intensity_data)).^valley_intensity_weight)';
                [~, weighted_nearest_extrema_index] = min(abs((current_wavelength + current_potential_shift) - local_minima_wavelengths) ./ current_weights);
                weights(current_potential_shift_index, current_spectral_line_index) = current_weights(weighted_nearest_extrema_index);
                weighted_residuals(current_potential_shift_index, current_spectral_line_index) = ((current_wavelength + current_potential_shift) - local_minima_wavelengths(weighted_nearest_extrema_index));
                
                [~, unweighted_nearest_extrema_index] = min(abs((current_wavelength + current_potential_shift) - local_minima_wavelengths));
                unweighted_residuals(current_potential_shift_index, current_spectral_line_index) = ((current_wavelength + current_potential_shift) - local_minima_wavelengths(unweighted_nearest_extrema_index));
            end
        end
    end
    
    % find sums of every residual row
    weighted_residual_sumsquares = sum((weighted_residuals ./ weights).^2, 2);
    
    [~, sorted_weighted_residual_sumsquares_indices] = sort(weighted_residual_sumsquares);
    
    doppler_shifts.Shift_A(current_galaxy_name) = potential_shifts(sorted_weighted_residual_sumsquares_indices(1));
    doppler_shifts.Weighted_Uncertainty_A(current_galaxy_name) = mean(abs(weighted_residuals(sorted_weighted_residual_sumsquares_indices(1))));
    doppler_shifts.Unweighted_Uncertainty_A(current_galaxy_name) = mean(abs(unweighted_residuals(sorted_weighted_residual_sumsquares_indices(1))));
    
    current_tab = uitab(tab_group, 'Title', current_galaxy_name);
    axes('Parent', current_tab);
    
    hold on
    
    %plot(wavelengths, intensity_data, 'k');
    
    current_shift = doppler_shifts.Shift_A(current_galaxy_name);
    plot(wavelengths - current_shift, intensity_data, 'color', 'b');
    
    for current_spectral_line_index = 1:height(selected_spectral_lines)
        current_wavelength = selected_spectral_lines.wavelength(current_spectral_line_index);
        line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', selected_spectral_line_colors(current_spectral_line_index, :), 'LineStyle', '--');
    end
    
    title(current_galaxy_name);
    legend([strcat({'shift: '}, string(doppler_shifts.Shift_A(current_galaxy_name)), {' A'}), ...
        strcat(selected_spectral_lines.Properties.RowNames', ... 
        {': w '}, string(weighted_residuals(current_galaxy_name_index, :)), {' A'}, ... 
        {': u '}, string(unweighted_residuals(current_galaxy_name_index, :)), {' A'})]);
    
    hold off
end

% plot combined
current_tab = uitab(tab_group, 'Title', 'Combined Shifted Data');
axes('Parent', current_tab);

hold on

for current_galaxy_name_index = 1:numel(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    plot(wavelengths - doppler_shifts.Shift_A(current_galaxy_name), galaxy_data_struct.(current_galaxy_name).data, 'color', data_colors(current_galaxy_name_index, :));
end

for current_wavelength_index = 1:height(spectral_lines)
    current_wavelength = spectral_lines.wavelength(current_wavelength_index);
    line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(current_wavelength_index, :), 'LineStyle', '--');
end

title('Combined Shifted Data');
legend([strcat(galaxy_names', {': w '}, string(doppler_shifts{:, 1}'), ... 
    {': u '}, string(doppler_shifts{:, 2}')), ... 
    spectral_lines.Properties.RowNames']);

hold off
