function saveData(data_raw,handles)
% created by LA 5th March 2018
%


%% filename and savePath selection
% get acronym or prefix to select correct folder
    contents = cellstr(get(handles.value_acronym,'String'));
    acronym = contents{get(handles.value_acronym,'Value')};
    prefix = get(handles.edit_filename,'String');

% select and create folder if not existing; define folder name as savePath
    if isempty(prefix) % select prefix or acronym
        if ~exist(['results' filesep acronym],'dir'); mkdir(['results' filesep acronym]); end
        savePath = [pwd filesep 'results' filesep acronym];
    else
        if ~exist(['results' filesep prefix],'dir'); mkdir(['results' filesep prefix]); end
        savePath = [pwd filesep 'results' filesep prefix];
    end
    
% get filename as it is written in textbox
    fname = get(handles.filename,'String');

    
%% select data to be saved
% subfunction to calibrate data
    data = calibrateData(data_raw);
    
% stimulus information from base workspace
    t = evalin('base','t');
    stim = evalin('base','stim');
    sr_stim = evalin('base','sr_stim');
    sr = evalin('base','sr');
    
    SubjInfo = getSubjInfo(handles);
    
%% save data
    save([savePath filesep fname],'data','t','stim','sr_stim','sr','SubjInfo','fname')

%% make new filename and assign data in workspace
    % generate new filename to count up by one trial
    make_filename(handles)
    
    % assign data in main worspace
    assignin('base','data',data)
    assignin('base','SubjInfo',SubjInfo)
    assignin('base','fname',fname);
    
    
%% display success of data saving procedure and reset loaded stimulus
    set(handles.saveData_success,'String',fname)
%     set(handles.saveData_success,'BackgroundColor','g')
    set(handles.writeStim_success,'BackgroundColor',[.94 .94 .94])
    set(handles.writeStim_success,'String','')


%% temporary extra code
% hold on; plot(-data(:,3))
% figure(1); plot(data(:,3)); axis([990 1240 -0.25 0.25]); hold on; 
% figure(2);plot(data(:,3)); axis([1990 2240 -0.25 0.25]); hold on
% figure(1); plot([1 4000], [0.2 0.2],'k-'); figure(2); plot([1 4000], -[0.2 0.2],'k-');


% vel = butterworth_filter(cdiff(data(:,3))*1000,1000,100,0,1,'low');
% vel = abs(vel);
% figure(1)
% plot(vel); axis([990 1240 -70 30]); hold on
% plot(data(:,[1 3])); %axis([990 1440 -70 30])
% figure(2)
% plot(vel); axis([1990 2240 -30 70]); hold on
% plot(data(:,[1 3]));
% datetime('now')

%   figure (51); subplot(211); plot(data(:,3)); subplot(212); plot(data(:,[5 6]))
%  Learning_feedback_v2
% global n fb
% fb=[]; n=0;
