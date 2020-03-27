function make_filename(handles)
% this function generates a filename that is written to the textbox
% handles.filename. Filenames are constructed as follows:
% acronym_S#_T# with S# is S followed by subject ID and T# is T by trial ID
%
% With prefix: if a prefix is entered manually this will substitute the
% acronym. Files will also be saved in the folder results/prefix (see 
% function saveData)
%
% Note: saveData reads out handles.filename to save files.



% generate index for selected subject ID, based on existing saved files for
% this subject.
    contents = cellstr(get(handles.value_id, 'String'));
    subjID = contents{get(handles.value_id,'Value')};
    prefix = get(handles.edit_filename,'String');
    contents = cellstr(get(handles.value_acronym,'String'));
    acronym = contents{get(handles.value_acronym,'Value')};
    contents = cellstr(get(handles.value_group,'String'));
    group = contents{get(handles.value_group,'Value')};
    
% generate path in which data should be saved
% path is not generated if it does not exist yet! Path is only generated
% when data is actually saved in saveData.m
    if isempty(prefix)
        folderName = [pwd filesep 'results' filesep acronym];
        prefix = acronym;
    else
        folderName = [pwd filesep 'results' filesep prefix];
    end
    
% check for already existing files for given prefix and subject
% count up by one, such that filename contains a new trial id.
    for n = 1:1000
        if ~exist([folderName filesep prefix '_S' num2str(str2double(subjID)) '_T' num2str(n) '.mat']); break; end
    end
    fname = [prefix '_S' num2str(str2double(subjID)) '_T' num2str(n) '.mat'];

% Dateiname festlegen
    set(handles.filename,'String',fname)