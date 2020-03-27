%% make quiet stance nGVS series stimuli
clear stim t sr

        samp_freq = 1000; % [Hz] Abtastrate der AD-Wandlerbox;
        fco = [0.02, 10]; % [Hz] Cut off Frequenzen für den bandpass filter
        duration = 240; % [s] Stimulationsdauer 
        amplitude = 1; % [mA] Stimulationsamplitude
        noise = wgn((duration)*samp_freq,1,0); % white noise Signal

        
        fnyq = samp_freq/2;
        [b,a] = butter(2,fco/fnyq,'bandpass'); % bandpass filter
        noise = filter(b,a,noise); 
        noise = mapminmax(noise',-amplitude,amplitude); % Skalierung des Signals auf die gewuenschte Amplitude
        noise = [0,noise(2:end-1),0]; % wichtig: Signal muss am Anfang und Ende genullt werden, sonst macht der Stimulator Probleme
        
        gain = [0 0.05 0.1 0.2 0.3 0.5 0.7];
        ng = [0 gain(randperm(7))];
        
        noise_ampl = repelem(ng,1,30000);
        
        sr = 1000;
        t = (1:length(noise))/sr;
        
        stim(1,:) = zeros(1,length(noise));
        stim(2,:) = zeros(1,length(noise));
        stim(3,:) = noise_ampl .* noise;
        stim(4,:) = noise_ampl;
        
        spath = 'C:\Users\PosturalControlLab\PCL_cloud\WippeAnsteuerung_v3\stimuli\nGVS\';
        save([spath 'noStim_nGVS_series30s.mat'],'sr','t','stim')
        
%% make sway referenced nGVS series stimuli
clear stim t sr

        samp_freq = 1000; % [Hz] Abtastrate der AD-Wandlerbox;
        fco = [0.02, 10]; % [Hz] Cut off Frequenzen für den bandpass filter
        duration = 240; % [s] Stimulationsdauer 
        amplitude = 1; % [mA] Stimulationsamplitude
        noise = wgn((duration)*samp_freq,1,0); % white noise Signal

        
        fnyq = samp_freq/2;
        [b,a] = butter(2,fco/fnyq,'bandpass'); % bandpass filter
        noise = filter(b,a,noise); 
        noise = mapminmax(noise',-amplitude,amplitude); % Skalierung des Signals auf die gewuenschte Amplitude
        noise = [0,noise(2:end-1),0]; % wichtig: Signal muss am Anfang und Ende genullt werden, sonst macht der Stimulator Probleme

        gain = [0 0.05 0.1 0.2 0.3 0.5 0.7];
        ng = [0 gain(randperm(7))];
        
        noise_ampl = repelem(ng,1,30000);
        
        sr = 1000;
        t = (1:length(noise))/sr;
        
        stim(1,:) = zeros(1,length(noise));
        stim(2,:) = [0 ones(1,length(noise)-2) 0]; % first and last sample need to be zero
        stim(3,:) = noise_ampl .* noise;
        stim(4,:) = noise_ampl;
        
        spath = 'C:\Users\PosturalControlLab\PCL_cloud\WippeAnsteuerung_v3\stimuli\nGVS\';
        save([spath 'swayRef_nGVS_series30s.mat'],'sr','t','stim')
        
%% make sine with one nGVS amplitude
clear stim t sr

        samp_freq = 1000; % [Hz] Abtastrate der AD-Wandlerbox;
        fco = [0.02, 10]; % [Hz] Cut off Frequenzen für den bandpass filter
        duration = 480; % [s] Stimulationsdauer 
        amplitude = 1; % [mA] Stimulationsamplitude
        noise = wgn((duration)*samp_freq,1,0); % white noise Signal
        
        fnyq = samp_freq/2;
        [b,a] = butter(2,fco/fnyq,'bandpass'); % bandpass filter
        noise = filter(b,a,noise); 
        noise = mapminmax(noise',-amplitude,amplitude); % Skalierung des Signals auf die gewuenschte Amplitude
        noise = [0,noise(2:end-1),0]; % wichtig: Signal muss am Anfang und Ende genullt werden, sonst macht der Stimulator Probleme

        gain = [0 0.05 0.1 0.2 0.3 0.5 0.7];
        ng = [0 gain(randperm(7))];
        
        noise_ampl = repelem(ng,1,60000);
        
        sr = 1000;
        t = (1:length(noise))/sr;
        
        f = 0.5;
        om = 2*pi*f;
        pf = 0.5 .* sin(om.*t);
        pf = pf .* [0.5-0.5*cos(t(1:500)*2*pi) ones(1,length(pf)-500)];
        
        stim(1,:) = pf;
        stim(2,:) = zeros(1,length(noise)); % first and last sample need to be zero
        stim(3,:) = noise_ampl .* noise;
        stim(4,:) = noise_ampl;
        
        spath = 'C:\Users\PosturalControlLab\PCL_cloud\WippeAnsteuerung_v3\stimuli\nGVS\';
        save([spath 'sine_nGVS_series60s.mat'],'sr','t','stim')
        
        
%         [pxx,freq] = pwelch(noise,[],[],[],samp_freq);
%         figure; 
%         subplot(1,2,1);
%         loglog(freq,pxx);
%         xlim([0.1 10]);
%         ylim([0 10]);
%         subplot(1,2,2)
%         plot(noise);