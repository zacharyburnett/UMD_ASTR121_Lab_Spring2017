% import data into single combined struct
data_dir = 'S-UBVR-k1992';

filenames = dir(data_dir);
filenames = {filenames.name};
filenames = filenames(3:end)';

galaxy_names = strings;

for current_filename_index = 1:length(filenames)
    current_filename = filenames{current_filename_index};
    galaxy_names(current_filename_index) = [current_filename(1:3), current_filename(5:8)];
end

galaxy_data_struct = struct();

for current_galaxy_name_index = 1:length(galaxy_names)
    galaxy_data_struct.(galaxy_names{current_galaxy_name_index}) = rfits(filenames{current_galaxy_name_index});
end
