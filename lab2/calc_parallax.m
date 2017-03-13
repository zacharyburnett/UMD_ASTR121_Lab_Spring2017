function [ p, sigma_p, d, sigma_d ] = calc_parallax(a, sigma_a, s, sigma_s )
%This function takes an array of apparent distances, the attributed plate
%scale s, and their uncertainties, and calculates the parallax angle
    p = (1/2).*(a.*s);
    sigma_p = p.*sqrt((sigma_a./a).^2+(sigma_s./s).^2);
    d = 1./p;
    sigma_d = d.*sqrt((sigma_p./p).^2);
end

