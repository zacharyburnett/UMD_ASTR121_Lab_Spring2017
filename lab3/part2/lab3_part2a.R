library(ggplot2, reshape2)

# define working directory
lab3_dir <- "../../MATLAB/UMD_ASTR121_Lab_Spring2017/lab3"

# define spectral types
spectral_types <- c("o5", "a1", "a5", "b0", "b6", "f0", "f5", "g0", "g6", "k0", "k5", "m0", "m5")

# instantiate data frames with wavelength range
known_spectra <- data.frame(wavelength_A = read.csv(paste(lab3_dir, "/spectra/a1.txt", sep = ""))$wavelength_A)
unknown_spectra <- data.frame(wavelength_A = read.csv(paste(lab3_dir, "/spectra/a1.txt", sep = ""))$wavelength_A)

# read spectral known_spectra to one data frame
for (spectral_type in spectral_types)
  known_spectra[[spectral_type]] <- read.csv(paste(lab3_dir, "/spectra/", spectral_type, ".txt", sep = ""))$normalized_intensity

# read unknown spectral data
for (spectra in paste("unknown", 1:5, sep = ""))
  unknown_spectra[[spectra]] <- read.csv(paste(lab3_dir, "/spectra/", spectra, ".txt", sep = ""))$normalized_intensity

# join tables
spectra <- merge(known_spectra, unknown_spectra)

# melt spectral known_spectra
spectra.melted <- melt(spectra, id.vars = "wavelength_A", variable.name = "spectra", value.name = "normalized_intensity")

# plot all spectral known_spectra
ggplot(spectra.melted, aes(x = wavelength_A, y = normalized_intensity, colour = spectra)) + geom_line()
