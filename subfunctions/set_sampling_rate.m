function set_sampling_rate(handles)
    
% get sampling rate selection from dropdown menu
    va = get(handles.pu_sampling_rate,'Value');
    st = get(handles.pu_sampling_rate,'string');
    sr = str2double(st{va});
    scope5 = getscope(slrt,5);
    try
        sl = evalin('base','length(stim)');
        scope5.NumSamples = round(sl*sr/1000);
    catch
    end
    scope5.decimation = round(1000/sr);
    
    assignin('base','sr',sr)