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

% specify selected spectral lines (previous selection: [1:2,4:7,10:11])
selected_spectral_lines = spectral_lines;

% define aggressiveness of seeking prominence and intensity
peak_prominence_weight = 1;
valley_prominence_weight = 3;
peak_intensity_weight = 0;
valley_intensity_weight = 1;
peak_width_weight = 0;
valley_width_weight = 1;

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
    
    current_intensity_data = galaxy_data_struct.(current_galaxy_name).data;
    
    % find local minima and maxima
    [local_maxima_intensities, local_maxima_wavelengths, local_maxima_widths, local_maxima_prominences] = findpeaks(current_intensity_data, wavelengths);
    [local_minima_intensities, local_minima_wavelengths, local_minima_widths, local_minima_prominences] = findpeaks(current_intensity_data * -1, wavelengths);
    
    % create arrays for weighted and unweighted residuals, as well as for applied weights
    weighted_residuals = zeros(length(potential_shifts), height(selected_spectral_lines));
    unweighted_residuals = zeros(length(potential_shifts), height(selected_spectral_lines));
    weights = zeros(length(potential_shifts), height(selected_spectral_lines));
    
    % iterate over potential wavelength shifts
    for current_potential_shift_index = 1:length(potential_shifts)
        current_potential_shift = potential_shifts(current_potential_shift_index);
        
        % iterate over spectral lines
        for current_spectral_line_index = 1:height(selected_spectral_lines)
            current_wavelength = selected_spectral_lines.wavelength(current_spectral_line_index);
            
            % check if emission line
            if strcmp(selected_spectral_lines.type(current_spectral_line_index), 'emission')
                current_weights = (local_maxima_prominences').^peak_prominence_weight ...
                    ./ (local_maxima_widths).^peak_width_weight ...
                    ./ abs(local_maxima_intensities' - mean(current_intensity_data)).^peak_intensity_weight;
                
                % get the index of the nearest local maximum (weighted and unweighted)
                [~, weighted_nearest_extrema_index] = min(abs((current_wavelength + current_potential_shift) - local_maxima_wavelengths) ./ current_weights);
                [~, unweighted_nearest_extrema_index] = min(abs((current_wavelength + current_potential_shift) - local_maxima_wavelengths));
                
                % populate weights
                weights(current_potential_shift_index, current_spectral_line_index) = current_weights(weighted_nearest_extrema_index);
                
                % get residuals (weighted and unweighted) between the shifted spectral line and the nearest local maximum, for uncertainty purposes
                weighted_residuals(current_potential_shift_index, current_spectral_line_index) = ((current_wavelength + current_potential_shift) - local_maxima_wavelengths(weighted_nearest_extrema_index));
                unweighted_residuals(current_potential_shift_index, current_spectral_line_index) = ((current_wavelength + current_potential_shift) - local_maxima_wavelengths(unweighted_nearest_extrema_index));
            else % else assume absorption
                current_weights = (local_minima_prominences').^valley_prominence_weight ...
                    ./ (local_minima_widths).^valley_width_weight ...
                    ./ abs(local_minima_intensities' - mean(current_intensity_data)).^valley_intensity_weight;
                
                % get the index of the nearest local minimum (weighted and unweighted)
                [~, weighted_nearest_extrema_index] = min(abs((current_wavelength + current_potential_shift) - local_minima_wavelengths) ./ current_weights);
                [~, unweighted_nearest_extrema_index] = min(abs((current_wavelength + current_potential_shift) - local_minima_wavelengths));
                
                % populate weights
                weights(current_potential_shift_index, current_spectral_line_index) = current_weights(weighted_nearest_extrema_index);
                
                % get residuals (weighted and unweighted) between the shifted spectral line and the nearest local minimum, for uncertainty purposes
                weighted_residuals(current_potential_shift_index, current_spectral_line_index) = ((current_wavelength + current_potential_shift) - local_minima_wavelengths(weighted_nearest_extrema_index));
                unweighted_residuals(current_potential_shift_index, current_spectral_line_index) = ((current_wavelength + current_potential_shift) - local_minima_wavelengths(unweighted_nearest_extrema_index));
            end
        end
    end
    
    % find sum of squares of every residual row and sort
    weighted_residual_sumsquares = sum((weighted_residuals ./ weights).^2, 2);
    [~, sorted_weighted_residual_sumsquares_indices] = sort(weighted_residual_sumsquares);
    least_sum_of_squares_index = sorted_weighted_residual_sumsquares_indices(1);
    
    % populate current row of Doppler shift table
    doppler_shifts.Shift_A(current_galaxy_name) = potential_shifts(least_sum_of_squares_index);
    doppler_shifts.Weighted_Uncertainty_A(current_galaxy_name) = mean(abs(weighted_residuals(least_sum_of_squares_index)));
    doppler_shifts.Unweighted_Uncertainty_A(current_galaxy_name) = mean(abs(unweighted_residuals(least_sum_of_squares_index)));
    
    % add new tab to figure window
    current_tab = uitab(tab_group, 'Title', current_galaxy_name);
    axes('Parent', current_tab);
    
    % start plotting
    hold on
    
    % plot original intensity data
    %plot(wavelengths, intensity_data, 'k');
    
    % plot shifted intensity data
    plot(wavelengths - doppler_shifts.Shift_A(current_galaxy_name), current_intensity_data, 'color', 'b');
    
    % draw selected spectral lines
    for current_spectral_line_index = 1:height(selected_spectral_lines)
        current_wavelength = selected_spectral_lines.wavelength(current_spectral_line_index);
        line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', selected_spectral_line_colors(current_spectral_line_index, :), 'LineStyle', '--');
    end
    
    % add title and legend
    title(current_galaxy_name);
    legend([strcat({'shift: '}, string(doppler_shifts.Shift_A(current_galaxy_name)), {' A'}), ...
        strcat(selected_spectral_lines.Properties.RowNames', ...
        {': w '}, string(weighted_residuals(current_galaxy_name_index, :)), {' A'}, ...
        {': u '}, string(unweighted_residuals(current_galaxy_name_index, :)), {' A'})]);
    
    % end plotting
    hold off
end

% add new tab to figure window
current_tab = uitab(tab_group, 'Title', 'Combined Shifted Data');
axes('Parent', current_tab);

% start plotting combined data
hold on

% plot each galaxy's shifted intensity data
for current_galaxy_name_index = 1:numel(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    plot(wavelengths - doppler_shifts.Shift_A(current_galaxy_name), galaxy_data_struct.(current_galaxy_name).data, 'color', data_colors(current_galaxy_name_index, :));
end

% draw selected spectral lines
for current_wavelength_index = 1:height(spectral_lines)
    current_wavelength = spectral_lines.wavelength(current_wavelength_index);
    line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(current_wavelength_index, :), 'LineStyle', '--');
end

% add title and legend
title('Combined Shifted Data');
legend([strcat(galaxy_names', {': w '}, string(doppler_shifts{:, 1}'), ...
    {': u '}, string(doppler_shifts{:, 2}')), ...
    spectral_lines.Properties.RowNames']);

% end plotting combined data
hold off