% read in data from CSV
known_spectra = readtable('known_spectra.csv', 'ReadVariableNames', true, 'ReadRowNames', true);
unknown_spectra = readtable('unknown_spectra.csv', 'ReadVariableNames', true, 'ReadRowNames', true);

% populate data frame of residual sum of squares
%for ( current_unknown_spectra in colnames(unknown_spectra) )
%  residual_sumsquares(current_unknown_spectra) = as.vector( colSums(( unknown_spectra(current_unknown_spectra) - known_spectra ) .^2 ));

residual_sumsquares = array2table(zeros(12, 5), 'VariableNames', unknown_spectra.Properties.VariableNames, 'RowNames', known_spectra.Properties.VariableNames);

for current_unknown_spectra = unknown_spectra.Properties.VariableNames
    for current_known_spectra = known_spectra.Properties.VariableNames
        residual_sumsquares(:, current_unknown_spectra) = sum((table2array(unknown_spectra(:, current_unknown_spectra)) - table2array(known_spectra)).^2);
    end
end