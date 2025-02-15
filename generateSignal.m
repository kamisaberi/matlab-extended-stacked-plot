function [x,y] = generateSignal()

% Parameters
fs = 256;               % Sampling frequency (Hz)
t = 0:1/fs:10;         % Time vector for 10 seconds
num_waves = 5;         % Number of random sine waves

% Initialize the EEG-like signal
eeg_signal = zeros(size(t));

% Generate random sine waves
for i = 1:num_waves
    frequency = randi([5, 30]);          % Random frequency between 5 and 30 Hz
    amplitude = rand() * 0.1;            % Random amplitude between 0 and 0.1
    phase = rand() * 2 * pi;             % Random phase shift
    eeg_signal = eeg_signal + amplitude * sin(2 * pi * frequency * t + phase);
end

% Add random noise
noise = 0.01 * randn(size(t));          % Gaussian noise
eeg_signal = eeg_signal + noise;
x = t
y = eeg_signal
end