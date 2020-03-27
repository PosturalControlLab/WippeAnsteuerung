figure(1);
% nfig=2;
addpath(genpath('C:\Users\PosturalControlLab\Documents\MATLAB\LA_toolbox'))
%%
pos = -data(901:1250,3);
stim = data(901:1250,1);

sr=1000;
% subplot(3,2,nfig*2 -1)
    vel = butterworth_filter(cdiff(pos)*sr,1000,20,20,1,'low');
    plot(vel);hold on
    plot(stim,'k'); % 3.553
%     plot(diff(stim_t)*1000,'k'); % 3.553
%     ylim([-1 1])

    
%%
figure(2);
pos = -data(1901:2250,3);
stim = data(1901:2250,1);

% subplot(3,2,nfig*2)
    vel = butterworth_filter(cdiff(pos)*sr,1000,20,20,1,'low');
    plot(vel);hold on
    plot(stim,'k')
%     plot(diff(stim_t)*1000,'k'); % 3.553
%     ylim([-2.2 2.2])
    
    