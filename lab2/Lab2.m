%import 4 main sets of values calculated from data
a = seperation_mm; %in mm
sigma_a = separation_uncert; %in mm
s = plate_scale; %unit conversion arcsec/mm
sigma_s = plate_scale_uncert; %arcsec/mm

hipparcos_data = hippData; %actual (theoretical data) from satallite
diff = zeros(1,length(d)); %initialize the differece array between theory and esxperiment

[p, sigma_p, d, sigma_d] = calc_parallax(a,sigma_a,s,sigma_s); %call function calc_parallax

%calculate difference for each dataset
for i = 1:length(p)
   diff(i) = (d(i) - hippData(i)); 
end

%graph difference vs data set with error bars from calc_Parallaz
errorbar(linspace(1,10),diff,sigma_d);

%synthesize data set 1 distance measurements from class mates
classData = [];
sigma_classData = [];

%calc average distance and calculate the uncertainty in the mean
d1_avg = sum(classData)/length(classData);
sigma_d1_avg = sigma_classData/sqrt(length(classData));

%plot histogram of this data
histogram(classData);