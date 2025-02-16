function [time,eeg_signals, artifactIndices, channelIndices, channelNames] = generateEegSignal(tmax  , fs , artifactsCount , randomArtifactsPerChannel)

    % fs = 500;
    % tmax = 10;
    nch = 21;
    channelIndices = 1:nch;
    channelNames = {'Fp1','Fp2','F7','F3','Fz','F4','F8','T3','C3','Cz','C4','T4','T5','P3','Pz','P4','T6','O1','Oz','O2','A1' };
    nt = fs*tmax;
    t = (0:nt-1)/fs;
    data = randn(nt,nch);
    time = t;
    eeg_signals= data;
    % artifactsCount = 20;
    % size(t,2)
    artifactIndices=[]
    if randomArtifactsPerChannel == 0 
        artifactIndices= randsample(size(t,2) , artifactsCount )';
    else
        artifactIndices=zeros(nch, artifactsCount);
        % disp("size:")
        % size(artifactsIndices)
        for i=1:nch
            artifactIndices(i,:) =randsample(size(t,2) , artifactsCount );
        end
    end

    
    % artifacts = t(indices)
    % indices = find(artifacts == 2);

    
    
    
