function [ apparent_magnitude ] = apparent_magnitude( absolute_magnitude , distance )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

apparent_magnitude = absolute_magnitude + 5 * log(distance) / log(10) - 5;
end

