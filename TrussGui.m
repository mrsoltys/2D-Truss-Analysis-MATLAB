function varargout = TrussGui(varargin)
% TRUSSGUI MATLAB code for TrussGui.fig
%      TRUSSGUI, by itself, creates a new TRUSSGUI or raises the existing
%      singleton*.
%
%      H = TRUSSGUI returns the handle to a new TRUSSGUI or the handle to
%      the existing singleton*.
%
%      TRUSSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRUSSGUI.M with the given input arguments.
%
%      TRUSSGUI('Property','Value',...) creates a new TRUSSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrussGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrussGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrussGui

% Last Modified by GUIDE v2.5 16-Mar-2015 10:40:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrussGui_OpeningFcn, ...
                   'gui_OutputFcn',  @TrussGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TrussGui is made visible.
function TrussGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrussGui (see VARARGIN)

% Choose default command line output for TrussGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

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
%TrussFig = figure(1);clf;
%set(TrussFig,'units','normalized','outerposition',[0 0 1 1]);
axes(handles.axes1);
redrawTruss(trussStruct)
handles.trussStruct=trussStruct;
guidata(hObject, handles);

% UIWAIT makes TrussGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrussGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.trussStruct.trussMembers = addMembers(handles.trussStruct);
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.trussStruct.trussSupports = addSupports(handles.trussStruct);
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.trussStruct.trussLoads = addLoads(handles.trussStruct,handles.axes1);
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
computeTruss(handles.trussStruct)
