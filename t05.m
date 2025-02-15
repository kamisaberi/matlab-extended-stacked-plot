% Generate sample data
fs = 100;               % Sampling frequency (Hz)
t = 0:1/fs:10;         % Time vector for 10 seconds
y = sin(2 * pi * 1 * t); % Sine wave

% Create a figure for plotting
figure('Name', 'Disable Drag Event Example', 'Position', [100, 100, 800, 400]);

% Create the plot
hPlot = plot(t, y);
title('Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Disable drag events
set(gca, 'HitTest', 'off'); % Disable interaction with the axes
set(hPlot, 'HitTest', 'off'); % Disable interaction with the plot object
