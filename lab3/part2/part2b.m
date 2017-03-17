% read in data from CSV
known_spectra = csvread('known_spectra.csv');
unknown_spectra = csvread('unknown_spectra.csv');

% populate data frame of residual sum of squares
for ( current_unknown_spectra in colnames(unknown_spectra) )
  residual_sumsquares(current_unknown_spectra) = as.vector( colSums(( unknown_spectra(current_unknown_spectra) - known_spectra ) .^2 ));
