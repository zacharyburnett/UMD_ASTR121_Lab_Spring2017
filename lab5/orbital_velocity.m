function [ velocity ] = orbital_velocity( radius, mass )
    %ORBITAL VELOCITY Returns mean orbital velocity given orbital radius and contained mass.
    
    cavendish_constant = 6.67408e-11;
    
    velocity = sqrt(cavendish_constant .* mass ./ radius);
end

