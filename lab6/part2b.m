% Plot all spectra separately, with lines for each rest wavelength

% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define range of wavelengths in angstroms
wavelengths = 3650:2:7100;

% define rest wavelengths of the first nine entries in the Balmer (Hydrogen) series, as well as of Calcium II (K and H)
balmer_alpha_angstroms = 6562.8;
balmer_beta_angstroms = 4861.3;
balmer_gamma_angstroms = 4340.5;
balmer_delta_angstroms = 4101.7;
balmer_epsilon_angstroms = 3970.1;
calcium_ii_h_angstroms = 3968.5;
calcium_ii_k_angstroms = 3933.7;
balmer_zeta_angstroms = 3889.1;
balmer_eta_angstroms = 3645.6;

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% define plotting colors
line_colors = winter(length(galaxy_names));
rainbow_colors = jet(9);

% create new tab group to contain plots as tabs
tab_group = uitabgroup;

% plot separately
for galaxy_name_index = 1:numel(galaxy_names)
    galaxy_name = galaxy_names{galaxy_name_index};
    intensity_data = galaxy_data_struct.(galaxy_name).data;
    
    current_tab = uitab(tab_group, 'Title', galaxy_name);
    axes('Parent', current_tab);
    
    hold on
    
    plot(wavelengths, intensity_data, 'k');
    
    line([balmer_alpha_angstroms balmer_alpha_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(9, :), 'LineStyle', '--');
    line([balmer_beta_angstroms balmer_beta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(8, :), 'LineStyle', '--');
    line([balmer_gamma_angstroms balmer_gamma_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(7, :), 'LineStyle', '--');
    line([balmer_delta_angstroms balmer_delta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(6, :), 'LineStyle', '--');
    line([balmer_epsilon_angstroms balmer_epsilon_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(5, :), 'LineStyle', '--');
    line([calcium_ii_h_angstroms calcium_ii_h_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(4, :), 'LineStyle', '--');
    line([calcium_ii_k_angstroms calcium_ii_k_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(3, :), 'LineStyle', '--');
    line([balmer_zeta_angstroms balmer_zeta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(2, :), 'LineStyle', '--');
    line([balmer_eta_angstroms balmer_eta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(1, :), 'LineStyle', '--');
    
    title(galaxy_name);
    legend(galaxy_name, 'Balmer alpha', 'Balmer beta', 'Balmer gamma', 'Balmer delta', 'Balmer epsilon', 'Ca II H', 'Ca II K', 'Balmer zeta', 'Balmer eta');
    
    hold off
end

current_tab = uitab(tab_group, 'Title', 'Combined Plot');
axes('Parent', current_tab);

% plot all together
hold on

for galaxy_name_index = 1:numel(galaxy_names)
    plot(wavelengths, galaxy_data_struct.(galaxy_names{galaxy_name_index}).data, 'color', line_colors(galaxy_name_index, :));
end

line([balmer_alpha_angstroms balmer_alpha_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(9, :), 'LineStyle', '--');
line([balmer_beta_angstroms balmer_beta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(8, :), 'LineStyle', '--');
line([balmer_gamma_angstroms balmer_gamma_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(7, :), 'LineStyle', '--');
line([balmer_delta_angstroms balmer_delta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(6, :), 'LineStyle', '--');
line([balmer_epsilon_angstroms balmer_epsilon_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(5, :), 'LineStyle', '--');
line([calcium_ii_h_angstroms calcium_ii_h_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(4, :), 'LineStyle', '--');
line([calcium_ii_k_angstroms calcium_ii_k_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(3, :), 'LineStyle', '--');
line([balmer_zeta_angstroms balmer_zeta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(2, :), 'LineStyle', '--');
line([balmer_eta_angstroms balmer_eta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(1, :), 'LineStyle', '--');

title('Combined Plot');
legend([galaxy_names', 'Balmer alpha', 'Balmer beta', 'Balmer gamma', 'Balmer delta', 'Balmer epsilon', 'Ca II H', 'Ca II K', 'Balmer zeta', 'Balmer eta']);

hold off

current_tab = uitab(tab_group, 'Title', 'Normalized Combined Plot');
axes('Parent', current_tab);

% plot all together
hold on

for galaxy_name_index = 1:numel(galaxy_names)
    plot(wavelengths, galaxy_data_struct.(galaxy_names{galaxy_name_index}).data / max(galaxy_data_struct.(galaxy_names{galaxy_name_index}).data), 'color', line_colors(galaxy_name_index, :));
end

line([balmer_alpha_angstroms balmer_alpha_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(9, :), 'LineStyle', '--');
line([balmer_beta_angstroms balmer_beta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(8, :), 'LineStyle', '--');
line([balmer_gamma_angstroms balmer_gamma_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(7, :), 'LineStyle', '--');
line([balmer_delta_angstroms balmer_delta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(6, :), 'LineStyle', '--');
line([balmer_epsilon_angstroms balmer_epsilon_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(5, :), 'LineStyle', '--');
line([calcium_ii_h_angstroms calcium_ii_h_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(4, :), 'LineStyle', '--');
line([calcium_ii_k_angstroms calcium_ii_k_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(3, :), 'LineStyle', '--');
line([balmer_zeta_angstroms balmer_zeta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(2, :), 'LineStyle', '--');
line([balmer_eta_angstroms balmer_eta_angstroms], get(gca, 'YLim'), 'color', rainbow_colors(1, :), 'LineStyle', '--');

title('Normalized Combined Plot');
legend([galaxy_names', 'Balmer alpha', 'Balmer beta', 'Balmer gamma', 'Balmer delta', 'Balmer epsilon', 'Ca II H', 'Ca II K', 'Balmer zeta', 'Balmer eta']);

hold off