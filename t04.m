% Generate sample data
fs = 100;               % Sampling frequency (Hz)
t = 0:1/fs:10;         % Time vector for 10 seconds
y = sin(2 * pi * 1 * t); % Sine wave

% Create a figure for plotting
figure('Name', 'Display Part of Data Example', 'Position', [100, 100, 800, 400]);

% Plot the entire data
plot(t, y);
title('Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Set the x-axis limits to display only a specific part of the data
xlim([2, 4]); % Display data from t = 2 to t = 4 seconds
ylim([-1, 1]); % Optional: Set y-axis limits if needed
