function subj = getSubjInfo(handles)

% subject info  
    subj.id = str2double(get(handles.value_id,'String'));
            
    subj.lab_id = get(handles.labID,'String');
    
    if get(handles.female,'Value')
        subj.gender = 'female';
    elseif get(handles.male,'Value')
        subj.gender = 'male';
    else
        subj.gender = '';
    end
    
    subj.age = str2double(get(handles.value_age,'String'));
    subj.body_height = str2double(get(handles.value_body_height,'String'));
    subj.body_weight = str2double(get(handles.value_body_weight,'String'));
    subj.ankle_height = str2double(get(handles.value_ankle_height,'String'));
    subj.trochanter_height = str2double(get(handles.value_trochanter_height,'String'));
    subj.acromion_height = str2double(get(handles.value_acromion_height,'String'));
    subj.heel_ankle = str2double(get(handles.value_heel_ankle,'String'));
    subj.foot_length = str2double(get(handles.value_foot_length,'String'));
    subj.hip_sr_height = str2double(get(handles.value_hip_sr_height,'String'));
    subj.shoulder_sr_height = str2double(get(handles.value_shoulder_sr_height,'String'));
    subj.hip_hook_distance = str2double(get(handles.value_hip_hook_distance, 'String'));
    subj.shoulder_hook_distance = str2double(get(handles.value_sho_hook_distance,'String'));
    subj.comments = get(handles.value_comments,'String');
 