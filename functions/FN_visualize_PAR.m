%% Sigmoid PAR

% Define parameters
PAR = 0:10:2000;              % Range for PAR (x-axis)
PARthresh_values = [10, 20, 100, 200, 400];   % Different sensitivity levels to compare

% Create the figure
figure('Color', 'w', 'Position', [100, 100, 800, 500]);
hold on;

% Loop through alpha values and plot each curve
colors = jet(length(PARthresh_values));
for ik = 1:length(PARthresh_values)
    a = PARthresh_values(ik);

    % Equation from image_9ed7ea.png
    num = PAR;
    den = PAR + a;
    fLight = num ./ den;

    plot(PAR, fLight, 'LineWidth', 2, 'Color', colors(ik,:), ...
        'DisplayName', ['PAR_{threshold} = ', num2str(a)]);
end

% Formatting
grid on;  box on;
xlabel('PAR (mmol m^-^2 s^-^1)', 'FontSize', 18);
ylabel('f_{light}', 'FontSize', 18);
% title('LUE_{camera} Sensitivity Analysis', 'FontSize', 14);
legend('Location', 'southeast','color','none'); legend box off;
xlim([0 2000]);
ylim([0 1]);