function [ velocity ] = galactic_rotational_velocity( radius, mass )
    %UNTITLED3 Summary of this function goes here
    %   Detailed explanation goes here
    
    cavendish_constant = 6.67408e-11;
    
    velocity = sqrt(cavendish_constant .* mass ./ radius);
end

