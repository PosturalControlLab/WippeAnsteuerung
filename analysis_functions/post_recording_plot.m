function post_recording_plot

try
    data = evalin('base','data');
    t = evalin('base','t');
    stim = evalin('base','stim');
    fname = evalin('base','fname');
    
    figure(1)
    clf

    subplot(2,1,1)
        plot(t(1:length(data)),data(:,3)); hold on
        plot(t(1:length(stim)),stim)
        legend('recorded PF','ideal stim')
        title(fname,'Interpreter','None')

    subplot(2,1,2)
        plot(t(1:length(data)),data(:,4)); hold on
        plot(t(1:length(data)),data(:,5));
        legend('hip SR','sho SR')
catch
    errordlg('Not able to plot recorded data!')
end