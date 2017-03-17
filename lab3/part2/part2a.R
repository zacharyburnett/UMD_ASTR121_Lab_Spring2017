library(ggplot2)
library(reshape2)

# define spectral types
spectral_types <-
  c("o5",
    "a1",
    "a5",
    "b0",
    "b6",
    "f0",
    "f5",
    "g0",
    "g6",
    "k0",
    "k5",
    "m0",
    "m5")

# instantiate data frames with wavelength range
known_spectra <-
  data.frame(wavelength_A = read.csv("spectra/a1.txt")$wavelength_A)
unknown_spectra <-
  data.frame(wavelength_A = read.csv("spectra/a1.txt")$wavelength_A)

# read known spectral data
for (current_known_spectra in spectral_types)
  known_spectra[[current_known_spectra]] <-
  read.csv(paste("spectra/", current_known_spectra, ".txt", sep = ""))$normalized_intensity

# read unknown spectral data
for (current_unknown_spectra in paste("unknown", 1:5, sep = ""))
  unknown_spectra[[current_unknown_spectra]] <-
  read.csv(paste("spectra/", current_unknown_spectra, ".txt", sep = ""))$normalized_intensity

# melt spectral data
known_spectra.melted <-
  melt(
    known_spectra,
    id.vars = "wavelength_A",
    variable.name = "spectra",
    value.name = "normalized_intensity"
  )
unknown_spectra.melted <-
  melt(
    unknown_spectra,
    id.vars = "wavelength_A",
    variable.name = "spectra",
    value.name = "normalized_intensity"
  )

# plot spectral data
ggplot(known_spectra.melted,
       aes(x = wavelength_A, y = normalized_intensity, colour = spectra)) + geom_line()
ggplot(
  unknown_spectra.melted,
  aes(x = wavelength_A, y = normalized_intensity, colour = spectra)
) + geom_line()

# write CSV files
write.csv(known_spectra, "spectra/known_spectra.csv", row.names = FALSE)
write.csv(unknown_spectra, "spectra/unknown_spectra.csv", row.names = FALSE)
