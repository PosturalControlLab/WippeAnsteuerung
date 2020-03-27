function varargout = BalanceLabGUI(varargin)
% BalanceLabGUI MATLAB code for BalanceLabGUI.fig
%      BalanceLabGUI, by itself, creates a new BalanceLabGUI or raises the existing
%      singleton*.
%
%      H = BalanceLabGUI returns the handle to a new BalanceLabGUI or the handle to
%      the existing singleton*.
%
%      BalanceLabGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BalanceLabGUI.M with the given input arguments.
%
%      BalanceLabGUI('Property','Value',...) creates a new BalanceLabGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BalanceLabGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BalanceLabGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLESfigur
% 
% Edit the above text to modify the response to help BalanceLabGUI
% 
% Last Modified by GUIDE v2.5 30-Sep-2019 17:49:02
% 
% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @BalanceLabGUI_OpeningFcn, ...
                       'gui_OutputFcn',  @BalanceLabGUI_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    try
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    catch
    end
    % End initialization code - DO NOT EDIT

% --- Executes just before BalanceLabGUI is made visible.
function BalanceLabGUI_OpeningFcn(hObject, eventdata, handles, varargin)
    addpath(genpath('C:\Users\PosturalControlLab\PCL_cloud\LA_toolbox'))
    addpath([pwd filesep 'subfunctions']);
    addpath([pwd filesep 'models']);
    % Choose default command line output for BalanceLabGUI
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);
    % Define experimentList entries
    BalExp = getBalExp;

    for n = 1:length(BalExp)
            acronym_list{n} = BalExp(n).acronym;
    end
    set(handles.value_acronym,'string',acronym_list)
    set(handles.stimulusList_Callback,'string',BalExp(1).stimuli);
    set(handles.pu_sampling_rate, 'String', {'100';'250';'500';'1000'});%;'2000';'4000'}); higher sr -> adjust simulation sr + stimuli?
    set(handles.pu_sampling_rate, 'Value', 4);
    
    make_filename(handles)

function varargout = BalanceLabGUI_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% stimulus selection and experimental setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function stimulusList_Callback(hObject, eventdata, handles)
    global gui_hand
    % 
    set(handles.writeStim_success,'BackgroundColor','r')
    set(handles.writeStim_success,'String','Please wait. Loading...')
    drawnow
    
    % load data from sequence file
    contents = cellstr(get(handles.value_acronym,'String'));
    acronym = contents{get(handles.value_acronym,'Value')};
    contents = cellstr(get(hObject,'String'));
    seq=contents{get(hObject,'Value')};
    load([pwd filesep 'stimuli' filesep acronym filesep seq '.mat'])
    if ~exist('sr_stim','var')
        sr_stim = sr;
    end
    
    % set gain visibility and multiply stimulus
    if strcmp(acronym,'nGVS')
        nGVS_gain = str2double(get(handles.nGVS_gain,'string'));
        stim(3,:) = stim(3,:)*nGVS_gain;
    end
    
    % add zeros, if stimulus is not the expected size (8xlength)
%     if evalin('base','exist(''NCh_select'')');
        assignin('base','NCh_select',size(stim,1))
%     else
        NCh_select = evalin('base','NCh_select');
%     end
    if size(stim,1) < NCh_select
        stim = [stim; zeros(NCh_select-size(stim,1), size(stim,2))];
    end
    
    % set last sample of SR channel to zero - required for smooth ramp down
    if NCh_select > 1
        stim(2,end) = 0;
    end
    % 3.553 deg/s /V
%     offset = 0.0154; stim = stim+offset;
%     faktor = 0.1; stim=stim*faktor; 
    %
    % filter stimulus
    % stim = butterworth_filter(stim,1000,10,50,2,'low');
    % 
    assignin('base','stim',stim)
    assignin('base','t',t)
    assignin('base','sr_stim',sr_stim)

    % plot data
    plot(t,stim)
    axis([0 t(end) -5 5])
    xlabel('time (s)'); ylabel('tilt (°)')

    % write stimulus to target
        try
            tg = slrt;
            SimulinkRealTime.utils.bytes2file('stim.dat', stim)
            SimulinkRealTime.copyFileToTarget('stim.dat')
            delete('stim.dat')
            set(handles.writeStim_success,'BackgroundColor','g')
            set(handles.writeStim_success,'String',seq)
        catch
            set(handles.writeStim_success,'BackgroundColor',[.94 .94 .94])
            set(handles.writeStim_success,'String','')
            error('stimulus not written to target')
        end

    % change loaded stimulus information and reset save data information
        set(handles.saveData_success,'BackgroundColor',[.94 .94 .94])
        set(handles.saveData_success,'String','')

    % simTime = length(stim)/sr;

%     tg.StopTime = length(stim)/sr_stim;
    tg.SampleTime = 1/sr_stim;
    % simTime = 5000;

    decimation = 20;
    for k=1:4;
        tg.getscope(k).NumSamples = length(stim)/decimation;
        tg.getscope(k).decimation = decimation;
    end
    % set scope properties of file scope recording data
        set_sampling_rate(handles)

function pu_sampling_rate_Callback(hObject, eventdata, handles)
    set_sampling_rate(handles)

function pu_sampling_rate_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function edit_filename_Callback(hObject, eventdata, handles)
    make_filename(handles)

function edit_filename_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function value_acronym_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    acronym = contents{get(hObject,'Value')};
    ind = get(hObject,'Value');

    BalExp = getBalExp;
    set(handles.stimulusList_Callback,'Value',1);
    set(handles.stimulusList_Callback,'String',BalExp(ind).stimuli);
    assignin('base','NCh_select',BalExp(ind).NCh_select)
    
    if strcmp(acronym,'nGVS')
        set(handles.nGVS_gain,'Visible','On');
        set(handles.nGVS_gain_tag,'Visible','On');
    else
        set(handles.nGVS_gain,'Visible','Off');
        set(handles.nGVS_gain_tag,'Visible','Off');
    end

    
    makeSubjectList(handles,0)
    make_filename(handles)

function value_acronym_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    make_filename(handles)

function value_group_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    group = contents{get(hObject,'Value')};

    make_filename(handles)

function value_group_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    make_filename(handles)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% control of experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function stopButton_Callback(hObject, eventdata, handles)
    % stop(slrt);
    set(slrt,'StopTime',Inf)
    setparam(slrt,'stopSim','Value',1)

function startButton_Callback(hObject, eventdata, handles)
    global gui_hand model_name
    gui_hand = handles;
    
    tg = slrt;
    if ~strcmp(get_param(model_name,'SimulationStatus'),'external')
        set_param(model_name,'SimulationCommand','connect');
    end
    % set parameters of sway referencing
    SR1_hd = str2double(get(handles.value_hip_hook_distance,'String'));
    SR1_hh = str2double(get(handles.value_hip_sr_height,'String')) - 8;
    if ~isnan(SR1_hd) && ~isnan(SR1_hh)
        setparam(tg,'SwayRef/SR1_HookDistance','Value', SR1_hd);
        setparam(tg, 'SwayRef/SR1_HookHeight', 'Value', SR1_hh ); % set hip sway rod height minus height of PF rotation axis
    else
        setparam(tg,'SwayRef/SR1_HookDistance','Value', 0);
        setparam(tg, 'SwayRef/SR1_HookHeight', 'Value', 1);
    end
    
    % start simulation using external model
    set_param(model_name,'SimulationCommand','start');

function connect_Callback(hObject, eventdata, handles)
    global model_name
    model_name = 'TiltExp_v3';
%     model_name = 'ControllerTuning';

    connect = questdlg('Are you sure?','Connect','Yes','No','No');

    switch connect
        case 'No' 

        case 'Yes'
            % reset some GUI values and clear stimulus plot
                set(handles.saveData_success,'String','')
                set(handles.saveData_success,'BackgroundColor',[.94 .94 .94])
                set(handles.writeStim_success,'BackgroundColor',[.94 .94 .94])
                set(handles.writeStim_success,'String','')
                cla(handles.axes1)
                
            % check whether target is available
            if ~strcmp(slrtpingtarget,'success')
                error('no connection to target')
            end
                            
            % add variant control variables
                assignin('base','Var_NCh_1', Simulink.Variant('NCh_select==1'));
                assignin('base','Var_NCh_2', Simulink.Variant('NCh_select==2'));
                assignin('base','Var_NCh_3', Simulink.Variant('NCh_select==3'));
                assignin('base','Var_NCh_4', Simulink.Variant('NCh_select==4'));
                assignin('base','Var_NCh_5', Simulink.Variant('NCh_select==5'));
                assignin('base','Var_NCh_6', Simulink.Variant('NCh_select==6'));
                assignin('base','Var_NCh_7', Simulink.Variant('NCh_select==7'));
                assignin('base','Var_NCh_8', Simulink.Variant('NCh_select==8'));
%                 Var_NCh_2 = Simulink.Variant('NCh_select==2');
%                 Var_NCh_3 = Simulink.Variant('NCh_select==3');
%                 Var_NCh_4 = Simulink.Variant('NCh_select==4');
%                 Var_NCh_5 = Simulink.Variant('NCh_select==5');
%                 Var_NCh_6 = Simulink.Variant('NCh_select==6');
%                 Var_NCh_7 = Simulink.Variant('NCh_select==7');
%                 Var_NCh_8 = Simulink.Variant('NCh_select==8');
                
                if evalin('base','exist(''NCh_select'')')
                    NCh_select = evalin('base','NCh_select');
                else
                    NCh_select = 1;
                    assignin('base','NCh_select', NCh_select); 
                end

            % open and build target control model from simulink
                sr_stim=1000; % set default sampling rate - will be changed when changing stimulus
                ex_model = model_name;
                sys = load_system(ex_model);

                hws = get_param(bdroot, 'modelworkspace');
                hws.assignin('sr_stim', sr_stim);
                hws.assignin('simTime', 10);

                tg = SimulinkRealTime.target;
                cwd = pwd;
                cd([pwd filesep 'models']);
                rtwbuild(ex_model);
                cd(cwd);
    %         set_param(model_name,'SimulationCommand','connect');
    end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subject Information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function new_proband_Callback(hObject, eventdata, handles)
makeSubjectList(handles,1)
make_filename(handles)
clear_all_Callback(hObject, eventdata, handles)

function value_id_Callback(hObject, eventdata, handles)
make_filename(handles)

function value_id_CreateFcn(hObject, eventdata, handles)
 if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
 end

function labID_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function female_Callback(hObject, eventdata, handles)

female = get(hObject, 'Value');
if get(hObject,'Value') == 1
    set(handles.male, 'Value',0);
else
    set(handles.male, 'Value',1);
end

function male_Callback(hObject, eventdata, handles)

male = get(hObject, 'Value');
if get(hObject,'Value') == 1
    set(handles.female, 'Value',0);
else
    set(handles.female, 'Value',1);
end

function value_age_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_body_height_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_body_weight_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_ankle_height_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_trochanter_height_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_acromion_height_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_heel_ankle_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_foot_length_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_hip_sr_height_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_shoulder_sr_height_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_hip_hook_distance_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_sho_hook_distance_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function value_comments_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function clear_all_Callback(hObject, eventdata, handles)
set(handles.labID,'String','');
set(handles.female,'Value',0);
set(handles.male,'Value',0);
set(handles.value_age,'String','');
set(handles.value_body_height,'String','');
set(handles.value_body_weight,'String','');
set(handles.value_ankle_height,'String','');
set(handles.value_trochanter_height,'String','');
set(handles.value_acromion_height,'String','');
set(handles.value_heel_ankle,'String','');
set(handles.value_foot_length,'String','');
set(handles.value_hip_sr_height,'String','');
set(handles.value_shoulder_sr_height,'String','');
set(handles.value_hip_hook_distance,'String','');
set(handles.value_sho_hook_distance,'String','');
set(handles.value_comments,'String','');

function clear_Callback(hObject, eventdata, handles)
%set(handles.value_age,'String','');
%set(handles.value_body_height,'String','');
%set(handles.value_body_weight,'String','');
set(handles.value_ankle_height,'String','');
set(handles.value_trochanter_height,'String','');
set(handles.value_acromion_height,'String','');
set(handles.value_heel_ankle,'String','');
set(handles.value_foot_length,'String','');
set(handles.value_hip_sr_height,'String','');
set(handles.value_shoulder_sr_height,'String','');
set(handles.value_hip_hook_distance,'String','');
set(handles.value_sho_hook_distance,'String','');
set(handles.value_comments,'String','');



function nGVS_gain_Callback(hObject, eventdata, handles)
stimulusList_Callback

function nGVS_gain_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function load_subjInfo_Callback(hObject, eventdata, handles)
    loadSubjInfo(handles);

function labID_Callback(hObject, eventdata, handles)
