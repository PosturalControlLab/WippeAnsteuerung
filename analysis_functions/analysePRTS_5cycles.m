%Analyse PRTS - 5 cycles
n=0;
for k=62:65
    n=n+1;
    load([pwd filesep 'results' filesep 'PFCalibr' filesep 'PFCalibr_S3__T' num2str(k) '.mat'])

in = reshape(stim,[20000,5]); in = in';
out = reshape(data(:,3),[20000,5]); out = out';
% out = reshape(data(:,1),[20000,5]); out = out';

[FD(n),TD(n)] = getFRF(in,out,1000,1000);
end
plotFRF(FD,TD)

% subplot(321); title('stimulus pp4; ideales Soll zu Ist; no Lenze Connector')