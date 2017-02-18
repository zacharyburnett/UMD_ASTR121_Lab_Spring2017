input_data = dlmread('lab1_sample.txt')

%errorbar(input_data(:, 2), input_data(:, 3), '.');

createFit(1:length(input_data(:, 2)), input_data(:, 2))