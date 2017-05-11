% Find Doppler shifts of each spectra based on fit to rest wavelengths

% define range of wavelengths in angstroms
wavelengths = 3650:2:7100;

% wavelengths from http://physics.nist.gov/PhysRefData/ASD/lines_form.html

% sulfur and nitrogen found at https://en.wikipedia.org/wiki/Forbidden_mechanism

% define rest wavelengths of the first nine entries in the Balmer (Hydrogen) series, as well as of Calcium II (K and H) and Sulfur
spectral_lines = table([6730.815; 6716.726; 6584; 6562.79; 6548; 4861.35; 4340.472; 4101.734; 3970.075; 3968.5; 3933.7; 3889.064], ...
    {'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'absorption'; 'absorption'; 'emission'}, ...
    'VariableNames', {'Wavelength_A', 'Type'}, ...
    'RowNames', {'SII1'; 'SII2'; 'NII1'; 'H\alpha'; 'NII2'; 'H\beta'; 'H\gamma'; 'H\delta'; 'H\epsilon'; 'CaIIH'; 'CaIIK'; 'H\zeta'});

% specify selected spectral lines.
selected_spectral_lines = spectral_lines([4,10,11], :);

% define weights assigned to priminence, intensity, and width of peaks and valleys
peak_prominence_weight = 1;
valley_prominence_weight = 3;
peak_intensity_weight = 0;
valley_intensity_weight = 1;
peak_width_weight = 0;
valley_width_weight = 1;

% define range of potential Doppler shifts
potential_shifts = 0:2:round((max(wavelengths) - max(selected_spectral_lines.Wavelength_A)));

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct)';

% define plotting colors
data_colors = summer(length(galaxy_names));
spectral_line_colors = jet(length(wavelengths));

% create new tab group to contain plots as tabs
tab_group = uitabgroup;

% create table to hold calculated redshifts
doppler_shifts = array2table(zeros(length(galaxy_names), 3), ...
    'VariableNames', {'Shift_A'; 'Unweighted_Residual_A'; 'Weighted_Residual_A'}, ...
    'RowNames', galaxy_names');

% create table to hold weighted and unweighted residuals
spectral_line_weighted_residuals = array2table(zeros(height(doppler_shifts), height(selected_spectral_lines)), ...
    'VariableNames', strrep(selected_spectral_lines.Properties.RowNames, '\', '_'), ...
    'RowNames', galaxy_names');

spectral_line_unweighted_residuals = array2table(zeros(height(doppler_shifts), height(selected_spectral_lines)), ...
    'VariableNames', strrep(selected_spectral_lines.Properties.RowNames, '\', '_'), ...
    'RowNames', galaxy_names');

% plot separately
for current_galaxy_name_index = 1:length(galaxy_names)
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
            current_wavelength = selected_spectral_lines.Wavelength_A(current_spectral_line_index);
            
            % check if emission line
            if strcmp(selected_spectral_lines.Type(current_spectral_line_index), 'emission')
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
    doppler_shifts.Unweighted_Residual_A(current_galaxy_name) = mean(abs(unweighted_residuals(least_sum_of_squares_index, :)));
    doppler_shifts.Weighted_Residual_A(current_galaxy_name) = mean(abs(weighted_residuals(least_sum_of_squares_index, :)));
    
    % populate spectral line tables
    spectral_line_unweighted_residuals{current_galaxy_name_index, :} = unweighted_residuals(least_sum_of_squares_index, :);
    spectral_line_weighted_residuals{current_galaxy_name_index, :} = weighted_residuals(least_sum_of_squares_index, :);
    
    doppler_shifts.Shift_A(current_galaxy_name) = doppler_shifts.Shift_A(current_galaxy_name) + mean(doppler_shifts.Weighted_Residual_A(current_galaxy_name));
    
    % add new tab to figure window
    current_tab = uitab(tab_group, 'Title', current_galaxy_name);
    axes('Parent', current_tab);
    
    % start plotting
    hold on
    
    % plot shifted intensity data
    plot(wavelengths - doppler_shifts.Shift_A(current_galaxy_name), current_intensity_data, 'color', 'k');
    
    % create array for spectral line legend entries
    spectral_line_legend_entries = strings(1, height(selected_spectral_lines));
    
    % draw selected spectral lines
    for current_spectral_line_index = 1:height(selected_spectral_lines)
        current_wavelength = selected_spectral_lines.Wavelength_A(current_spectral_line_index);
        current_spectral_line_name = selected_spectral_lines.Properties.RowNames{current_spectral_line_index};
        line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(round((current_wavelength - min(wavelengths)) / range(wavelengths) * length(spectral_line_colors)), :), 'LineStyle', '--');
        
        spectral_line_legend_entries(current_spectral_line_index) = sprintf('%-5s %+10.3f \x212B', ... 
            current_spectral_line_name, ... 
            spectral_line_unweighted_residuals.(strrep(current_spectral_line_name, '\', '_'))(current_galaxy_name));
    end
    
    
    % add title and legend
    title(current_galaxy_name);
    legend([strcat({'best fit shift: '}, string(doppler_shifts.Shift_A(current_galaxy_name)), {' '}, char(197)), spectral_line_legend_entries]);
    xlabel('Wavelength (Angstroms)');
    ylabel('Intensity');
        
    % end plotting
    hold off
end

% plot combined
current_tab = uitab(tab_group, 'Title', 'Combined Unshifted Data');
axes('Parent', current_tab);

hold on

for current_galaxy_name_index = 1:length(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    plot(wavelengths, galaxy_data_struct.(current_galaxy_name).data, 'color', data_colors(current_galaxy_name_index, :));
end

for current_spectral_line_index = 1:height(selected_spectral_lines)
    current_wavelength = selected_spectral_lines.Wavelength_A(current_spectral_line_index);
    line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(round((current_wavelength - min(wavelengths)) / range(wavelengths) * length(spectral_line_colors)), :), 'LineStyle', '--');
end

title('Combined Unshifted Data');
legend([galaxy_names, selected_spectral_lines.Properties.RowNames']);
xlabel('Wavelength (Angstroms)');
ylabel('Intensity');
    
hold off

% add new tab to figure window
current_tab = uitab(tab_group, 'Title', 'Combined Shifted Data');
axes('Parent', current_tab);

% start plotting combined data
hold on

% plot each galaxy's shifted intensity data
for current_galaxy_name_index = 1:length(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    plot(wavelengths - doppler_shifts.Shift_A(current_galaxy_name), galaxy_data_struct.(current_galaxy_name).data, 'color', data_colors(current_galaxy_name_index, :));
end

% draw selected spectral lines
for current_wavelength_index = 1:height(selected_spectral_lines)
    current_wavelength = selected_spectral_lines.Wavelength_A(current_wavelength_index);
    line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(round((current_wavelength - min(wavelengths)) / range(wavelengths) * length(spectral_line_colors)), :), 'LineStyle', '--');
end

% create array for galaxy legend entries
galaxy_legend_entries = strings(1, length(galaxy_names));

% populate galaxy legend entries
for galaxy_name_index = 1:length(galaxy_names)
    galaxy_legend_entries(galaxy_name_index) = sprintf('%7s \t %2d \x00B1 %-3.2g \x212B', ... 
        galaxy_names{galaxy_name_index}, ... 
        doppler_shifts.Shift_A(galaxy_name_index), ... 
        abs(doppler_shifts.Weighted_Residual_A(galaxy_name_index)));
end

% add title and legend
title('Combined Shifted Data');
legend([galaxy_legend_entries, selected_spectral_lines.Properties.RowNames']);
xlabel('Wavelength (Angstroms)');
ylabel('Intensity');
    
% end plotting combined data
hold off