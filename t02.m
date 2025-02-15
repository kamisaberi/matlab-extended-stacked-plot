% Create a UI figure
fig = uifigure('Name', 'Stacked Panel Example', 'Position', [100, 100, 600, 600]);

% Create a main panel to hold the stacked panels
mainPanel = uipanel(fig, 'Position', [0, 0, 1, 1]);

% Create the first subplot panel
panel1 = uipanel(mainPanel, 'Position', [0, 0.5, 1, 0.5]);
ax1 = axes(panel1);
% Generate some data for the first plot
t1 = 0:0.01:2*pi;
y1 = sin(t1);
plot(ax1, t1, y1);
title(ax1, 'Sine Wave');
xlabel(ax1, 'Time (s)');
ylabel(ax1, 'Amplitude');
grid(ax1, 'on');

% Create the second subplot panel
panel2 = uipanel(mainPanel, 'Position', [0, 0, 1, 0.5]);
ax2 = axes(panel2);
% Generate some data for the second plot
t2 = 0:0.01:2*pi;
y2 = cos(t2);
plot(ax2, t2, y2);
title(ax2, 'Cosine Wave');
xlabel(ax2, 'Time (s)');
ylabel(ax2, 'Amplitude');
grid(ax2, 'on');
