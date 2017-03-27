function [ temperature ] = temperature_from_colorindex( color_index )
%TEMPERATURE_FROM_COLORINDEX Summary of this function goes here
%   Detailed explanation goes here

temperature = 4600 * (1 ./ (0.92 .* (color_index) + 1.7) + 1 ./ (0.92 .* (color_index) + 0.62));
end

