function stopSimulation()
global gui_hand model_name

    set_param(model_name,'SimulationCommand','disconnect');
    tg = slrt;
    
    try
        SimulinkRealTime.copyFileToHost('data.dat')
        output = SimulinkRealTime.utils.getFileScopeData('data.dat');
        delete('data.dat')
        
        tg.fs.removefile('data.dat')

    catch
        tg.fs.getopenfiles
        tg.fs.fileinfo('data.dat')

        error('Error trying to copy data file from target to host')
    end
    
    %% speichern von Daten
    try
        saveData(output.data,gui_hand)
    catch
        error('Error trying to save data')
    end
        
    setparam(slrt,'stopSim','Value',0)
%     setparam(slrt,'SwayRef/holdPFpos','Value',0)
    
    %% run post-processing routines
        post_recording_plot

