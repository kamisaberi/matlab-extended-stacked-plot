close all , clc , clear
currectPath  = pwd
cd E:\LIBRARIES\Matlab\brainstorm3
brainstorm
cd(currectPath)
addpath('E:\MATLAB\libraries\eeglab2024.0\');
[hdr, EEG_field, EEG_lab] = readEEG("E:\DATASETS\EEG\Sample_EEG_data\FJ002193.EEG" , 1);
whos EEG_lab.data