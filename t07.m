[t, eeg_signal, artifacts ] = generateEegSignal();
eeg_signal = eeg_signal'
plot(t(1:100), eeg_signal(1,(1:100)),  "Color","black" );
hold on
% plot(t(1:100), eeg_signal(2,(1:100)),  "Color","black" );
scatter([0,0], [5,2] , "Color","r")