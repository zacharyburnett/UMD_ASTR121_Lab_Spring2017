library(ggplot2)
library(reshape2)

# define spectral types
spectral_types <- c("o5", "a1", "a5", "b0", "b6", "f0", "f5", "g0", "g6", "k0", "k5", "m0", "m5")

# instantiate data frames with wavelength range
known_spectra <- data.frame(wavelength_A = read.csv("/spectra/a1.txt")$wavelength_A)
unknown_spectra <- data.frame(wavelength_A = read.csv("/spectra/a1.txt")$wavelength_A)

# read known spectral data
for (spectral_type in spectral_types)
  known_spectra[[spectral_type]] <- read.csv(paste("/spectra/", spectral_type, ".txt", sep = ""))$normalized_intensity

# read unknown spectral data
for (spectra in paste("unknown", 1:5, sep = ""))
  unknown_spectra[[spectra]] <- read.csv(paste("/spectra/", spectra, ".txt", sep = ""))$normalized_intensity

# melt known spectral data
known_spectra.melted <- melt(known_spectra, id.vars = "wavelength_A", variable.name = "spectra", value.name = "normalized_intensity")

# plot known spectral data
ggplot(known_spectra.melted, aes(x = wavelength_A, y = normalized_intensity, colour = spectra)) + geom_line()

# melt unknown spectral data
unknown_spectra.melted <- melt(unknown_spectra, id.vars = "wavelength_A", variable.name = "spectra", value.name = "normalized_intensity")

# plot unknown spectral data
ggplot(unknown_spectra.melted, aes(x = wavelength_A, y = normalized_intensity, colour = spectra)) + geom_line()
