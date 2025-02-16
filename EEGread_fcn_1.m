function [hdr, EEG_field, EEG_lab] = EEGread_fcn_1(address, Epoch_num)

% Add FieldTrip to the path (change the path to your FieldTrip installation)
addpath('D:\Dr. Oghabian\fieldtrip-20240916'); 
ft_defaults;  % Set up FieldTrip defaults

hdr = ft_read_header(address);

% Sampling rate (in Hz)
Fs = hdr.Fs;

% Define the time window (in seconds)
start_time = Epoch_num*10-10;  % Start time in seconds
duration = 10;    % Duration of 10 seconds
end_time = start_time + duration;

% Convert the time window to sample indices
start_sample = round(start_time * Fs) + 1;  % +1 because MATLAB uses 1-based indexing
end_sample = round(end_time * Fs);

%% Selecting 10sec Epoch form EEG Method 1

% Use ft_read_data to load only the specific segment of the EEG data
cfg = [];
cfg.dataset = address;
cfg.trialdef.prestim = start_time; % Start time of the trial in seconds
cfg.trialdef.poststim = end_time;  % End time of the trial in seconds

% Read the specific data segment (channels x samples)
EEG_segment = ft_read_data(address, 'begsample', start_sample, 'endsample', end_sample);

% Create a time vector for the loaded segment
segment_time_vector = (start_sample:end_sample) / Fs;

% Display basic information
disp(['Loaded EEG data segment from ', num2str(start_time), 's to ', num2str(end_time), 's']);
disp(['Number of channels: ', num2str(size(EEG_segment, 1))]);
disp(['Number of time points: ', num2str(size(EEG_segment, 2))]);

% Get the electrode labels (channel labels) from the header
electrode_labels = hdr.label;

% Display available electrode labels (for your reference)
% disp('Available electrode labels:');
% disp(electrode_labels);

% Define the electrode labels you want to select (example labels, replace with yours)
selected_electrodes = {'FP1','FP2','F7','F3','FZ','F4','F8','T1','T2','T3','C3','CZ','C4','T4','T5','P3',...
'PZ','P4','T6','O1','O2'};  % Replace with the electrodes you want to extract

% Find the indices of the selected electrodes
selected_indices = find(ismember(electrode_labels, selected_electrodes));

% Extract the EEG data for the selected electrodes
EEG_selected_segment = EEG_segment(selected_indices, :);

% Assume these variables exist:
% - EEG_data: (channels x time points) EEG data matrix
% - Fs: Sampling rate (e.g., 1000 Hz)
% - electrode_labels: cell array of electrode names (e.g., {'Fz', 'Cz', 'Pz', ...})
% - start_time: Starting time of the EEG recording (in seconds, e.g., 0)

% Number of channels and time points
[n_channels, n_timepoints] = size(EEG_selected_segment);

% Create the FieldTrip-compatible structure
EEG_field = struct();

% Assign channel labels (Nx1 cell array)
EEG_field.label = selected_electrodes;  % Example: {'Fz', 'Cz', 'Pz', ...}

% Wrap the EEG data in a 1x1 cell array (channels x time points)
EEG_field.trial = {EEG_selected_segment};  % FieldTrip expects this in a cell array

% Create the time vector (1xN vector of time points, in seconds)
end_time = start_time + (n_timepoints - 1) / Fs;  % Calculate end time
EEG_field.time = {linspace(start_time, end_time, n_timepoints)};  % Create time vector

% Add the sampling frequency
EEG_field.fsample = Fs;

% Optionally, add sample info (start and end sample indices)
EEG_field.sampleinfo = [1 n_timepoints];

% No Event
EEG_field.event = [];
% Now `data` is in FieldTrip format, and you can use ft_preprocessing
disp('Converted data is ready for ft_preprocessing.');
%% Method 1: Re-reference to a average 
% Example: Use ft_preprocessing to filter or re-reference the data
cfg = [];
cfg.reref = 'yes';
cfg.refchannel = 'all';  % Example: average re-reference
EEG_field_reref = ft_preprocessing(cfg, EEG_field);

% Now `EEG_field_reref` contains the re-referenced EEG data.
%% Method 2: Re-reference to a specific electrode (e.g., 'Cz')
% cfg = [];
% cfg.reref = 'yes';  % Enable re-referencing
% cfg.refchannel = {'Cz'};  % Specify the reference channel
% % Perform the re-referencing to Cz
% EEG_field_reref = ft_preprocessing(cfg, EEG_field);

%% Convert Fieldtrip format into EEGlab format
% Assume you have a FieldTrip data structure 'data'

% Create an empty EEGLAB structure
EEG_lab = eeg_emptyset;

% Assign FieldTrip data to EEGLAB fields
EEG_lab.data = EEG_field.trial{1};  % Extract the first trial (continuous data format)
EEG_lab.nbchan = size(EEG_lab.data, 1);  % Number of channels
EEG_lab.srate = EEG_field.fsample;  % Sampling rate
EEG_lab.pnts = size(EEG_lab.data, 2);  % Number of time points (samples)
EEG_lab.xmin = EEG_field.time{1}(1);  % Start time of the recording
EEG_lab.xmax = EEG_field.time{1}(end);  % End time of the recording
EEG_lab.times = EEG_field.time{1};  % Time vector corresponding to the data
EEG_lab.chanlocs = struct('labels', EEG_field.label);  % Channel labels
% Set the dataset name (this is necessary for saving the dataset)
EEG_lab.setname = 'Manual_Converted_EEG';  % Set the name of the dataset
% No events? Set up empty event structure
EEG_lab.event = [];  % Empty events
% ICA-related fields must be initialized as empty arrays
EEG_lab.icaweights = [];  % Initialize the ICA weights field (empty since ICA hasn't been run)
EEG_lab.icasphere = [];   % Initialize the ICA sphere field (empty)
EEG_lab.icawinv = [];     % Initialize the ICA inverse weights (empty)
EEG_lab.icaact = [];      % Initialize the ICA activations (empty)
% Initialize the trials field
EEG_lab.trials = 1;  % Continuous data should have EEG.trials set to 1
% Initialize required but empty fields for continuous data
EEG_lab.epoch = [];  % Initialize epoch as an empty structure for continuous data
EEG_lab.urevent = [];  % Empty urevent structure, since we don't have event data
EEG_lab.reject = struct();  % Initialize an empty reject field (EEG.reject)
% Optional: Add history or command field for dataset metadata
EEG_lab.history = '';  % No history for now, can be filled with a string later
% Finalize the EEG structure
EEG_lab = eeg_checkset(EEG_lab);

% Visualize the converted EEG data in EEGLAB
% pop_eegplot(EEG_lab, 1, 1, 1);

% Optionally save the dataset in EEGLAB format
% to do
% EEG_lab = pop_saveset(EEG_lab,'filepath','E:\BIO_PhD\Grant_EEG\EEG_software(BESA)\Software\GUI','filename', 'EEG_lab_data.set');
end

