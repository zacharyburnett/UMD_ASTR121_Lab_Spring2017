filenames = strcat('lon', string(17:4:65), '.dat');

colors = jet(length(filenames));

data = cell(1, length(filenames));

for index = 1:length(filenames)
    data{index} = readtable(char(filenames(index)));
end

left_tail_start_frequencies = zeros(1, length(data));
left_tail_start_uncertainties = zeros(1, length(data));

% start plotting
hold on

% plot brightness temperature in K vs frequency in mhz
for index = 1:length(data)
    current_table = data{index};

    left_tail_negative_indices = find(current_table.Var2(current_table.Var1 < 1420.406) < 0);
    left_tail = current_table.Var2(1:left_tail_negative_indices(end) + 1);

    positive_noise = max(left_tail(left_tail > 0));
    negative_noise = min(left_tail(left_tail < 0));
  
    plot(current_table.Var1, current_table.Var2, '.', 'color', colors(index, :));

    % find left tail negative indices and signal start frequency of the noise-adjusted sample
    left_tail_negative_indices = find(current_table.Var2(current_table.Var1 < 1420.406) < mean([positive_noise, negative_noise]));
    left_tail_start_frequency = current_table.Var1(left_tail_negative_indices(end) + 1);
    
    left_tail_start_frequencies(index) = left_tail_start_frequency;
    left_tail_start_uncertainties(index) = left_tail_start_frequency - current_table.Var1(left_tail_negative_indices(end - 1));
end

% plot vertical lines at likely start of signal
for index = 1:length(data)
    line([left_tail_start_frequencies(index) left_tail_start_frequencies(index)], get(gca, 'YLim'), 'color', colors(index, :));
end

% add labels
title('Brightness Temperature vs Frequency for 17:4:65 deg Galactic Longitude');
xlabel('Frequency (MHz)');
ylabel('Brightness Temperature (K)');

% add legend
legend(filenames);

refline(0, 0);

% end plotting
hold off