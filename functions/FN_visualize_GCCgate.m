% Visualize GCC as gate
GCC_norm = 0:0.01:1;  % Normalized Green Chromatic Coordinate (0 to 1)
x0 = 0.35;            % Midpoint (Inflection point where fGate = 0.5)
k_values = [15, 30, 60]; % Different steepness factors to compare
color_mtx = [ 255/255 127/255 20/255; 50/255 77/255 255/255; ...
    0.1020 0.5882 0.2549; 60/255 187/255 255/255];

figure('Color', 'w', 'Name', 'fGate Sigmoid Function');
hold on; grid on;

colors = ['b', 'g', 'r']; % Colors for different k values

for ix = 1:length(k_values)
    k = k_values(ix);

    % Calculate fGate
    fGate = 1 ./ (1 + exp(-k .* (GCC_norm - x0)));

    if ix ==1
        plot(GCC_norm, fGate, 'LineWidth', 2, 'Color', color_mtx(ix,:), ...
            'DisplayName', sprintf('k: %d (wake-up speed)', k));
    else
        plot(GCC_norm, fGate, 'LineWidth', 2, 'Color', color_mtx(ix,:),'DisplayName', sprintf('k: %d',k));
        legend box off
    end
end

xline(x0, '--y', ['X_0 threshold: = ', num2str(x0)], 'LabelVerticalAlignment',...
    'bottom','Color','k', 'FontSize', 14, 'HandleVisibility', 'off');
% yline(0.5, '--', 'color', [0.5 0.5 0.5], 'HandleVisibility', 'off');

xlabel('GCC', 'FontSize', 12);
ylabel('f_{GCC} (fractional activation)', 'FontSize', 14);
legend('Location', 'northeast'); set(gca, 'FontSize', 14);
hold off;    box on;