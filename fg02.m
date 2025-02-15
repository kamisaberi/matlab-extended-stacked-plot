% Create a simple UI with uiaxes
fig = uifigure('Position', [100, 100, 400, 300]);
ax = uiaxes(fig, 'Position', [50, 50, 300, 200]);

% Plot something on the uiaxes
plot(ax, rand(1, 10));

% Hide the uiaxes
ax.Visible = 'off';

% Optionally, you can provide a button to toggle visibility
uibutton(fig, 'Text', 'Toggle Axes Visibility', ...
    'Position', [150, 10, 100, 30], ...
    'ButtonPushedFcn', @(btn, event) toggleVisibility(ax));

function toggleVisibility(ax)
    % Toggle the visibility of the uiaxes
    if strcmp(ax.Visible, 'on')
        ax.Visible = 'off';
    else
        ax.Visible = 'on';
    end
end
