function subj = loadSubjInfo(handles)

% subject info  

    contents = cellstr(get(handles.value_id, 'String'));
    subjID = contents{get(handles.value_id,'Value')};
    prefix = get(handles.edit_filename,'String');
    contents = cellstr(get(handles.value_acronym,'String'));
    acronym = contents{get(handles.value_acronym,'Value')};
    
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
    fname = [folderName filesep prefix '_S' num2str(str2double(subjID)) '_T' num2str(n-1) '.mat'];

    load(fname,'SubjInfo');
    subj = SubjInfo;
    if isfield(subj,'lab_id')
        set(handles.labID,'String',subj.lab_id);
    end
    
    if strcmp(subj.gender,'female')
        set(handles.female,'Value',1)
    elseif strcmp(subj.gender,'male')
        set(handles.male,'Value',1)
    end
    
    set(handles.value_age,'String', num2str(subj.age));
    set(handles.value_body_height,'String',num2str(subj.body_height));
    set(handles.value_body_weight,'String',num2str(subj.body_weight));
    set(handles.value_ankle_height,'String',num2str(subj.ankle_height));
    set(handles.value_trochanter_height,'String',num2str(subj.trochanter_height));
    set(handles.value_acromion_height,'String',num2str(subj.acromion_height));
    set(handles.value_heel_ankle,'String',num2str(subj.heel_ankle));
    set(handles.value_foot_length,'String',num2str(subj.foot_length));
    set(handles.value_hip_sr_height,'String',num2str(subj.hip_sr_height));
    set(handles.value_shoulder_sr_height,'String',num2str(subj.shoulder_sr_height));
    set(handles.value_hip_hook_distance, 'String',num2str(subj.hip_hook_distance));
    set(handles.value_sho_hook_distance,'String',num2str(subj.shoulder_hook_distance));
    set(handles.value_comments,'String',subj.comments);
 