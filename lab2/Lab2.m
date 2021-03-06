%import 4 main sets of values calculated from data
a = separation_mm; %in mm
sigma_a = separation_uncert; %in mm
s = plate_scale; %unit conversion arcsec/mm
sigma_s = plate_scale_uncert; %arcsec/mm

hippData = hipparcos_parsec; %actual (theoretical data) from satallite

[p, sigma_p, d, sigma_d] = calc_parallax(a,sigma_a,s,sigma_s); %call function calc_parallax

diff = zeros(1,length(d)); %initialize the differece array between theory and experiment

%calculate difference for each dataset
for i = 1:length(p)
   diff(i) = abs(d(i) - hippData(i)); 
end

%graph difference vs data set with error bars from calc_Parallax
hold on
dataset = 1:1:10;
zeroline = 0;
errorbar(dataset,diff,sigma_d,'.');
plot([0,11],[0,0],'r-');
xlim([0,11]);
xlabel('Star Number');
ylabel('Difference (from Hipparcos Data) (Parsec)');
legend('Difference w/ Error Bars', 'Zeroline');
title('Residual of Calculated Star Distances using Parallax with Error Bars')
hold off

%synthesize data set 1 distance measurements from class mates
classData = [4.2, 3.9, 4.4, 4.5, 5.88, 4.5, 4.8];
sigma_classData = [0.3, 1.5, 0.35, 0.4, 3.65, 0.59, 0.5];

%calc average distance and calculate the uncertainty in the mean
d1_avg = sum(classData)/length(classData);
sigma_d1_avg = sum(sigma_classData)/length(classData);

figure
%plot histogram of this data
hist(classData,8);
xlabel('Distance to Star 1 (parsec)')
ylabel('Frequency')
set(gca,'XLim',[3.5 6])
set(gca,'XTick',[3.5:0.2:6])
title('Class Data on Parallax Angle of Star 1')
