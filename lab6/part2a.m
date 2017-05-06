% Plot all spectra together, with lines for each rest wavelength

% All wavelength info is the same for each.
% intensity values are in the 'data' field of the struct

% define wavelengths in angstroms
wavelengths = 3650:2:7100;
calcium_ii_k_angstroms = 3933.7;
calcium_ii_h_angstroms = 3968.5;

balmer_alpha_angstroms = 6562.8;
balmer_beta_angstroms = 4861.3;
balmer_gamma_angstroms = 4340.5;
balmer_delta_angstroms = 4101.7;
balmer_epsilon_angstroms = 3970.1;
balmer_zeta_angstroms = 3889.1;
balmer_eta_angstroms = 3645.6;

% get fieldnames (galaxy names)
galaxy_names = fieldnames(galaxy_data_struct);

% define plotting colors
colors = jet(length(galaxy_names));

% plot all together
hold on

for galaxy_name_index = 1:numel(galaxy_names)
    plot(wavelengths, galaxy_data_struct.(galaxy_names{galaxy_name_index}).data, 'color', colors(galaxy_name_index, :));
end

line([calcium_ii_k_angstroms calcium_ii_k_angstroms], get(gca, 'YLim'), 'color', 'b');
line([calcium_ii_h_angstroms calcium_ii_h_angstroms], get(gca, 'YLim'), 'color', 'g');

line([balmer_alpha_angstroms balmer_alpha_angstroms], get(gca, 'YLim'), 'color', 'k');
line([balmer_beta_angstroms balmer_beta_angstroms], get(gca, 'YLim'), 'color', 'k');
line([balmer_gamma_angstroms balmer_gamma_angstroms], get(gca, 'YLim'), 'color', 'k');
line([balmer_delta_angstroms balmer_delta_angstroms], get(gca, 'YLim'), 'color', 'k');
line([balmer_epsilon_angstroms balmer_epsilon_angstroms], get(gca, 'YLim'), 'color', 'k');
line([balmer_zeta_angstroms balmer_zeta_angstroms], get(gca, 'YLim'), 'color', 'k');
line([balmer_eta_angstroms balmer_eta_angstroms], get(gca, 'YLim'), 'color', 'k');

legend([galaxy_names', 'Ca II K', 'Ca II H', 'Balmer series']);

hold off