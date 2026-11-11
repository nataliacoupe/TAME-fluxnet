% Visualize fT
% Define Cardinal Temperatures
Tmin = 0;   % Minimum temperature for photosynthesis
Topt = 25;  % Optimal temperature (where fT = 1)
Tmax = 40;  % Maximum temperature (heat stress limit)

% Create Temperature Range
Tair = linspace(-5, 45, 1000); % Air temperatures from -5 to 45 degrees

% Calculate the 'q' coefficient (This shifts the peak to Topt)
q = (Tmax - Topt) / (Topt - Tmin);

% Compute the Temperature Response (fT)
% The Wang & Engel Formula includes "q"
% This ensures the peak is exactly at Topt and the max value is 1.0
fT = ((Tair - Tmin) .* (Tmax - Tair).^q) ./ ...
     ((Topt - Tmin) * (Tmax - Topt)^q);

% Apply biological limits (clipping)
% Photosynthesis is zero below Tmin and above Tmax
fT(Tair <= Tmin | Tair >= Tmax) = 0;

% Visualization
figure('Color', 'w', 'Name', 'Temperature Response Function');
plot(Tair, fT, 'LineWidth', 2.5, 'Color', [0.85 0.33 0.1]);
grid on;
hold on;

% Add markers for cardinal points
plot([Tmin Topt Tmax], [0 1 0], 'ko', 'MarkerFaceColor', 'k');
text(Tmin, -0.05, 'T_{min}', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(Topt, 1.05, 'T_{opt}', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(Tmax, -0.05, 'T_{max}', 'FontSize', 12, 'HorizontalAlignment', 'center');

xlabel('Air Temperature (T_{air}) [°C]', 'FontSize', 12);
ylabel('Temperature Scalar (fT) [0-1]', 'FontSize', 12);
title('Temperature Response in LUE Model (fT)', 'FontSize', 14);
ylim([-0.1 1.2]);