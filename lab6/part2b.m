% Find Doppler shifts of each spectra based on fit to rest wavelengths

% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define range of wavelengths in angstroms
wavelengths = 3650:2:7100;

% wavelengths from http://physics.nist.gov/PhysRefData/ASD/lines_form.html
% SII 6730.815; SII 6716.726;

% sulfur and nitrogen found at https://en.wikipedia.org/wiki/Forbidden_mechanism

% define rest wavelengths of the first nine entries in the Balmer (Hydrogen) series, as well as of Calcium II (K and H) and Sulfur
spectral_lines = table([6730.815; 6716.726; 6584; 6562.79; 6548; 4861.35; 4340.472; 4101.734; 3970.075; 3968.5; 3933.7; 3889.064], ... 
    {'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'emission'; 'absorption'; 'absorption'; 'emission'}, ... 
    'RowNames', {'Sulfur II 1'; 'Sulfur II 2'; 'Nitrogen II 1'; 'Balmer alpha'; 'Nitrogen II 2'; 'Balmer beta'; 'Balmer gamma'; 'Balmer delta'; 'Balmer epsilon'; 'Ca II H'; 'Ca II K'; 'Balmer zeta'}, ... 
    'VariableNames', {'wavelength', 'type'});

% specify selected spectral lines
selected_spectral_lines = spectral_lines([2:4,6,10:11], :);

% define aggressiveness of seeking prominence
prominence_aggressiveness = 5;

% define minimum prominences for peaks and valleys
minimum_peak_prominence = 0.3;
minimum_valley_prominence = 0.2;

% define range of potential Doppler shifts
potential_shifts = 0:2:round((max(wavelengths) - max(spectral_lines.wavelength)));

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% define plotting colors
data_colors = winter(length(galaxy_names));
shift_colors = winter(1);
spectral_line_colors = fliplr(jet(length(spectral_lines.wavelength)));

% create new tab group to contain plots as tabs
tab_group = uitabgroup;

% create array to hold calculated redshifts
doppler_shifts = array2table(zeros(length(galaxy_names), 2), 'RowNames', galaxy_names, 'VariableNames', {'Shift_A'; 'Uncertainty_A'});

% plot separately
for current_galaxy_name_index = 1:numel(galaxy_names)
    current_galaxy_name = galaxy_names{current_galaxy_name_index};
    
    intensity_data = galaxy_data_struct.(current_galaxy_name).data;
    
    [local_maxima_intensities, local_maxima_wavelengths, local_maxima_widths, local_maxima_prominences] = findpeaks(intensity_data, wavelengths, 'MinPeakProminence', minimum_peak_prominence);
    [local_minima_intensities, local_minima_wavelengths, local_minima_widths, local_minima_prominences] = findpeaks(intensity_data * -1, wavelengths, 'MinPeakProminence', minimum_valley_prominence);
    
    weights = zeros(length(potential_shifts), height(selected_spectral_lines));
    residuals = zeros(length(potential_shifts), height(selected_spectral_lines));
  
    for current_potential_shift_index = 1:length(potential_shifts)
        current_potential_shift = potential_shifts(current_potential_shift_index);
        
        for current_spectral_line_index = 1:height(selected_spectral_lines)
            current_wavelength = selected_spectral_lines.wavelength(current_spectral_line_index);
            
            if strcmp(selected_spectral_lines.type(current_spectral_line_index), 'emission')
                [~, nearest_extrema_index] = min(((current_wavelength + current_potential_shift) - local_maxima_wavelengths).^2);
                weights(current_potential_shift_index, current_spectral_line_index) = 1 / (local_maxima_prominences(nearest_extrema_index)).^prominence_aggressiveness;
                residuals(current_potential_shift_index, current_spectral_line_index) = ((current_wavelength + current_potential_shift) - local_maxima_wavelengths(nearest_extrema_index));
            else % else assume absorption
                [~, nearest_extrema_index] = min(((current_wavelength + current_potential_shift) - local_minima_wavelengths).^2);
                weights(current_potential_shift_index, current_spectral_line_index) = 1 / (local_minima_prominences(nearest_extrema_index)).^prominence_aggressiveness;
                residuals(current_potential_shift_index, current_spectral_line_index) = ((current_wavelength + current_potential_shift) - local_minima_wavelengths(nearest_extrema_index));
            end
        end
    end
    
    % find sums of every residual row
    residual_sumsquares = sum((residuals .* weights).^2, 2);
    
    [~, sorted_residual_sumsquares_indices] = sort(residual_sumsquares);
    
    doppler_shifts.Shift_A(current_galaxy_name) = potential_shifts(sorted_residual_sumsquares_indices(1));
    doppler_shifts.Uncertainty_A(current_galaxy_name) = mean(abs(residuals(sorted_residual_sumsquares_indices(1))));
    
    current_tab = uitab(tab_group, 'Title', current_galaxy_name);
    axes('Parent', current_tab);
    
    hold on
    
    %plot(wavelengths, intensity_data, 'k');
    
    current_shift = doppler_shifts.Shift_A(current_galaxy_name);
    plot(wavelengths - current_shift, intensity_data, 'color', 'b');
        
    for current_spectral_line_index = 1:length(spectral_lines.wavelength)
        current_wavelength = spectral_lines.wavelength(current_spectral_line_index);
        line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(current_spectral_line_index, :), 'LineStyle', '--');
    end
    
    title(current_galaxy_name);
    legend([strcat('shift:', {' '}, string(doppler_shifts.Shift_A(current_galaxy_name)), {' '}, 'A'), spectral_lines.Properties.RowNames']);
    
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

for current_wavelength_index = 1:length(spectral_lines.wavelength)
    current_wavelength = spectral_lines.wavelength(current_wavelength_index);
    line([current_wavelength current_wavelength], get(gca, 'YLim'), 'color', spectral_line_colors(current_wavelength_index, :), 'LineStyle', '--');
end

title('Combined Shifted Data');
legend([galaxy_names', spectral_lines.Properties.RowNames']);

hold off
