% Visualize fT
% Define Cardinal Temperatures
Topt = 25;  % Optimal temperature (where fT = 1)
Tamplitude = 10;  % Re-scaled width parameter for a proper curve (Sigma)
Tair = linspace(-10, 55, 1000); 

% The critical change: Adding the negative sign inside the exp()
fTemp  = exp(-((Tair - Topt).^2) / (2 * Tamplitude^2));

% Apply the clipping (forcing to zero outside the window)
% fT(Tair <= Tmin_limit | Tair >= Tmax_limit) = 0;

% Visualization
figure('Color', 'w', 'Name', 'Temperature Response Function');
plot(Tair, fTemp, 'LineWidth', 2.5, 'Color', [0.85 0.33 0.1]);
grid on;    hold on;

% Add markers for cardinal points
plot([Topt-2*Tamplitude Topt Topt+2*Tamplitude], [0 1 0], 'ko', 'MarkerFaceColor', 'k');
text(Topt-2*Tamplitude, -0.05, 'T_{opt}-2T_{amp}', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(Topt+2*Tamplitude, -0.05, 'T_{opt}+2T_{amp}', 'FontSize', 12, 'HorizontalAlignment', 'center');
% text(Tmax, -0.05, 'T_{max}', 'FontSize', 12, 'HorizontalAlignment', 'center');

xlabel('Air Temperature (T_{air}) [°C]', 'FontSize', 14);
ylabel('Temperature Scalar (fT) [0-1]', 'FontSize', 14);
% title('Temperature Response in LUE Model (fT)', 'FontSize', 14);
ylim([-0.1 1.2]);