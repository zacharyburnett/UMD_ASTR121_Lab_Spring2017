# read in data from CSV
known_spectra <-
  read.csv("spectra/known_spectra.csv", row.names = "wavelength_A")
unknown_spectra <-
  read.csv("spectra/unknown_spectra.csv", row.names = "wavelength_A")

# instantiate data frame with known spectral types as row names
residual_sumsquares <-
  data.frame(spectral_type = colnames(known_spectra))

# populate data frame of residual sum of squares
for (current_unknown_spectra in colnames(unknown_spectra))
  residual_sumsquares[[current_unknown_spectra]] <-
  as.vector(colSums((unknown_spectra[[current_unknown_spectra]] - known_spectra) ^
                      2))

# write to CSV file
write.csv(residual_sumsquares,
          "part2/residual_sumsquares.csv",
          row.names = FALSE)

# instantiate match data frame
matches <-
  data.frame(
    unknown_spectra = colnames(unknown_spectra),
    spectral_type_match = factor(5),
    sum_of_squares = numeric(5),
    stringsAsFactors = FALSE
  )

for (current_unknown_spectra in colnames(unknown_spectra))
  matches$spectral_type_match[which(matches$unknown_spectra == current_unknown_spectra)] <-
  residual_sumsquares$spectral_type[residual_sumsquares[[current_unknown_spectra]] == min(residual_sumsquares[[current_unknown_spectra]])]
