%% Initilize Grid
clear;clc;
trussStruct=struct();
trussStruct.trussMembers=[];
trussStruct.trussSupports=[];
trussStruct.trussLoads=[];
trussStruct.trussForces=[];

prompt = {'Horizontal Spacing Interval [ft/m]: ',...
    'Number of Horizontal Spaces: ',...
    'Vertical Spacing Interval [ft/m]: ',...
    'Number of Horizontal Spaces: '};
dlg_title = 'New Truss Setup';
num_lines = 1;
def = {'2','4','1.5','3'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
trussStruct.dx=str2num(answer{1});
trussStruct.nx=round(str2num(answer{2}));
trussStruct.dy=str2num(answer{3});
trussStruct.ny=round(str2num(answer{4}));

% Display Coordnate System
TrussFig = figure(1);clf;
set(TrussFig,'units','normalized','outerposition',[0 0 1 1]);
redrawTruss(trussStruct)

%% Add Members
trussStruct.trussMembers = addMembers(trussStruct);

%% Add Joints
trussStruct.trussSupports = addSupports(trussStruct);
%% Add Loads
trussStruct.trussLoads = addLoads(trussStruct)

%% Compute
computeTruss(trussStruct)
%%
% pb = uicontrol(TrussFig,'Style','pushbutton','String','Edit Members',...
%                 'Position',[50 600 100 40],...
%                 'Callback',@pushbutton1_Callback);
% function pushbutton1_Callback([b, eventdata)
% % hObject    handle to pushbutton1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% display('Goodbye');
% close(gcf);