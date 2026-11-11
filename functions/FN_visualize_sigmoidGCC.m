%% Sigmoid GCC

% Define parameters
GCC = 0:0.01:1;              % Range for GCC (x-axis)
alpha_values = [0.5, 1, 2, 5, 10];   % Different sensitivity levels to compare

% Create the figure
figure('Color', 'w', 'Position', [100, 100, 800, 500]);
hold on;

% Loop through alpha values and plot each curve
colors = jet(length(alpha_values));
for i = 1:length(alpha_values)
    a = alpha_values(i);

    % Equation from image_9ed7ea.png
    num = 1 - exp(-a .* GCC);
    den = 1 + exp(-a .* GCC - 0.5);
    LUE_cam = num ./ den;

    plot(GCC, LUE_cam, 'LineWidth', 2, 'Color', colors(i,:), ...
        'DisplayName', ['\alpha = ', num2str(a)]);
end

% Add the theoretical limit (asymptote)
asymptote = 1 / (1 + exp(-0.5));
yline(asymptote, '--k', 'Theoretical Limit \approx 0.622', ...
    'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left','DisplayName','lim');

% Formatting
grid on;
xlabel('GCC', 'FontSize', 18);
ylabel('LUE_{camera}', 'FontSize', 18);
% title('LUE_{camera} Sensitivity Analysis', 'FontSize', 14);
legend('Location', 'southeast','color','none'); legend box off;
xlim([0 1]);
ylim([0 1]);