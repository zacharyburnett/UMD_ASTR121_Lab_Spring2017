function [ best_fit ] = closest_isochrone( cluster_magnitudes, isochrones )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

residual_sumsquares = array2table(zeros(12, 5), 'VariableNames', isochrones.Properties.VariableNames);

for current_isochrone = isochrones.Properties.VariableNames
    residual_sumsquares{:, current_isochrone} = sum(.^2)';
end

end

