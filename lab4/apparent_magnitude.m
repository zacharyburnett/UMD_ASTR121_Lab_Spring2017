function [ apparent_magnitude ] = apparent_magnitude( absolute_magnitude , distance )
    %Apparent Magnitude Returns apparent magnitude given absolute magnitude and
    %distance.
    
    apparent_magnitude = absolute_magnitude + 5 * log(distance) / log(10) - 5;
end

