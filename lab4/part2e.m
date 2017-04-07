%%
% find isochrones closest to the visual and blue magnitudes based on sum of squares
%residual_sumsquares = closest_isochrone(m45, isoc.e8);

%blue_e8 = cell2mat(residual_sumsquares('visual', residual_sumsquares{'visual',:} == min(residual_sumsquares{'visual',:})).Properties.VariableNames);
%visual_e8 = cell2mat(residual_sumsquares('blue', residual_sumsquares{'blue',:} == min(residual_sumsquares{'blue',:})).Properties.VariableNames);

%residual_sumsquares = closest_isochrone(m45, isoc.e9);

%blue_e9 = cell2mat(residual_sumsquares('visual', residual_sumsquares{'visual',:} == min(residual_sumsquares{'visual',:})).Properties.VariableNames);
%visual_e9 = cell2mat(residual_sumsquares('blue', residual_sumsquares{'blue',:} == min(residual_sumsquares{'blue',:})).Properties.VariableNames);

visual_e8 = closest_isochrone(m45, isoc.e8);
visual_e9 = closest_isochrone(m45, isoc.e9);

%%
e8_iso = isoc.e8.(visual_e8);

e8_v = e8_iso.V;%(1:find(diff(e8_iso.V) >= 0, 1));
e8_b = e8_iso.B;%(1:find(diff(e8_iso.B) >= 0, 1));

%%
hold on

% flip axes
set(gca, 'ydir', 'rev');

plot(m45.B - m45.V, m45.V, '.k');

plot(e8_b - e8_v, apparent_magnitude(e8_v, 136.2), '-');

% add labels
title('Color Index vs Visual Apparent Magnitude');
xlabel('Color Index (B - V)');
ylabel('Visual Magnitude (V)');

legend('M45', strcat(visual_e8, ' 10^8'), strcat(visual_e9, ' 10^9'));

hold off