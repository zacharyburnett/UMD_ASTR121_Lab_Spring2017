%All wavelength info is the same for each. instensity
%values are in the 'data' field of the struct
wavelengths = 3650:2:7100;

% for NGC1832
figure
intensities1832 = NGC1832.data;
plot(wavelengths, intensities1832);

%etc...
figure
intensities2276 = NGC2276.data;
plot(wavelengths, intensities2276);

figure
intensities2798 = NGC2798.data;
plot(wavelengths, intensities2798);

figure
intensities2903 = NGC2903.data;
plot(wavelengths, intensities2903);

figure
intensities3034 = NGC3034.data;
plot(wavelengths, intensities3034);

figure
intensities3077 = NGC3077.data;
plot(wavelengths, intensities3077);

figure
intensities3147 = NGC3147.data;
plot(wavelengths, intensities3147);

figure
intensities3368 = NGC3368.data;
plot(wavelengths, intensities3368);

figure
intensities3627 = NGC3627.data;
plot(wavelengths, intensities3627);

figure
intensities4750 = NGC4750.data;
plot(wavelengths, intensities4750);

figure
intensities4775 = NGC4775.data;
plot(wavelengths, intensities4775);

figure
intensities5195 = NGC5195.data;
plot(wavelengths, intensities5195);

figure
intensities5248 = NGC5248.data;
plot(wavelengths, intensities5248);

figure
intensities6181 = NGC6181.data;
plot(wavelengths, intensities6181);

figure
intensities6643 = NGC6643.data;
plot(wavelengths, intensities6643);