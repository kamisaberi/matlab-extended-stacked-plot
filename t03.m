% Create a UI figure
fig = uifigure('Name', 'Subplot Example with uiaxes', 'Position', [100, 100, 600, 600]);

% Create uiaxes for the first subplot (top left)
ax1 = uiaxes(fig, 'Position', [0.1, 0.5, 0.35, 0.4]); % [left, bottom, width, height]
% Generate data for the first plot
t1 = 0:0.01:2*pi;
y1 = sin(t1);
plot(ax1, t1, y1);
title(ax1, 'Sine Wave');
xlabel(ax1, 'Time (s)');
ylabel(ax1, 'Amplitude');
grid(ax1, 'on');

% Create uiaxes for the second subplot (top right)
ax2 = uiaxes(fig, 'Position', [0.55, 0.5, 0.35, 0.4]); % [left, bottom, width, height]
% Generate data for the second plot
y2 = cos(t1);
plot(ax2, t1, y2);
title(ax2, 'Cosine Wave');
xlabel(ax2, 'Time (s)');
ylabel(ax2, 'Amplitude');
grid(ax2, 'on');

% Create uiaxes for the third subplot (bottom left)
ax3 = uiaxes(fig, 'Position', [0.1, 0.1, 0.35, 0.4]); % [left, bottom, width, height]
% Generate data for the third plot
y3 = tan(t1);
plot(ax3, t1, y3);
title(ax3, 'Tangent Wave');
xlabel(ax3, 'Time (s)');
ylabel(ax3, 'Amplitude');
grid(ax3, 'on');

% Create uiaxes for the fourth subplot (bottom right)
ax4 = uiaxes(fig, 'Position', [0.55, 0.1, 0.35, 0.4]); % [left, bottom, width, height]
% Generate data for the fourth plot
y4 = exp(-t1);
plot(ax4, t1, y4);
title(ax4, 'Exponential Decay');
xlabel(ax4, 'Time (s)');
ylabel(ax4, 'Amplitude');
grid(ax4, 'on');
