function makeSubjectList(handles,new)

    prefix = get(handles.edit_filename,'String');
    contents = cellstr(get(handles.value_acronym,'String'));
    acronym = contents{get(handles.value_acronym,'Value')};
    
% generate path in which data is saved
% path is not generated if it does not exist yet! Path is only generated
% when data is actually saved in saveData.m
    if isempty(prefix)
        folderName = [pwd filesep 'results' filesep acronym];
        prefix = acronym;
    else
        folderName = [pwd filesep 'results' filesep prefix];
    end    
    
% check for already existing files for given prefix and subject.
    sl=[]; n=0;
    for k = 1:200
        if exist([folderName filesep prefix '_S' num2str(k) '_T1.mat'],'file'); 
            n=n+1;
            sl = [sl; k];
        end
    end
    if new
        if isempty(sl); sl=1; else sl = [sl; max(sl)+1]; end
            sl = num2str(sl);
            set(handles.value_id,'string',sl)
            set(handles.value_id,'value',n+1)
    elseif isempty(sl)
        sl = '0';
        set(handles.value_id,'string',sl)
        set(handles.value_id,'value',1)
    else
        sl = num2str(sl);
        set(handles.value_id,'string',sl)
        set(handles.value_id,'value',n)
    end
    