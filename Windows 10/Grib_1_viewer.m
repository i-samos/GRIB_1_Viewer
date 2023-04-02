function varargout = Grib_1_viewer(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Grib_1_viewer_OpeningFcn, ...
    'gui_OutputFcn',  @Grib_1_viewer_OutputFcn, ...
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
% --- Executes just before Grib_1_viewer is made visible.
function Grib_1_viewer_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
jarDir=pwd;
javaaddpath(jarDir);

d = dir(jarDir);
for i = 1:length(d)
    name = java.lang.String(d(i).name);
    if name.endsWith('.jar') & ~name.startsWith('.')
        javaaddpath(fullfile(jarDir, d(i).name));
    end
end
evalin('base','clear')
load('Europe.mat')
load('cloud_cmap.mat')
load('bwr.mat')
load('preci.mat')
assignin('base','cmap_blue_white_red',cmap_blue_white_red);
assignin('base','cmap_l',cmap_l);
assignin('base','cmap_m',cmap_m);
assignin('base','cmap_h',cmap_h);
assignin('base','RGB',RGB);
assignin('base','S',S);
INITIAL = pwd;
INITIAL=strcat(INITIAL,'\INPUT_GRIB\');
Infolder = dir(fullfile(INITIAL,'*'));
assignin('base','INITIAL',INITIAL);
MyListOfDirs = [];
for i = 1:length(Infolder)
    if Infolder(i).isdir==1
        MyListOfDirs{end+1,1} = Infolder(i).name;
    end
end
MyListOfDirs=MyListOfDirs(3:end,:);
[q1,~]=size(MyListOfDirs);
if q1>0
    set(handles.popupmenu13,'Value',1)
    set(handles.popupmenu13,'String',MyListOfDirs)
end
assignin('base','MyListOfDirs',MyListOfDirs);
guidata(hObject, handles);
% --- Outputs from this function are returned to the command line.
function varargout = Grib_1_viewer_OutputFcn(~, ~, handles)
varargout{1} = handles.output;
set(handles.text1,'String','LOADING');drawnow;
maximize;drawnow
set(handles.popupmenu14,'Value',1)
set(handles.checkbox5,'value',1)
set(handles.checkbox6,'value',1)
set(handles.text1,'String','READY');drawnow;
%% CALLBACKS
% --- EXIT button
function pushbutton2_Callback(~, ~, ~)
close all
% --- MAP reset button
function pushbutton3_Callback(~, ~, handles)
set(handles.text1,'String','WORKING');drawnow;
lat=evalin('base','lat');
lon=evalin('base','lon');
ylim([min(min(lon)) max(max(lon))])
xlim([min(min(lat)) max(max(lat))])
set(handles.text1,'String','READY');drawnow;
% --- PARAMETER menu
function popupmenu1_Callback(~, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
try
    BARBS2=evalin('base','BARBS2');
    delete(BARBS2);
    evalin('base','clear BARBS2')
end
% filter parametes for level
CC3=evalin('base','CC3');
var_val=get(handles.popupmenu1, 'Value');
var_str=get(handles.popupmenu1, 'String');
stringToCheck = char(var_str(var_val));
member=find(strcmp(stringToCheck, CC3(:,4)));
CC2=CC3(member,:);
% check accumulation fields
stringToCheck = 'Precipitation';
member9=find(strcmp(stringToCheck, CC2(:,4)));
if isempty(member9)
    set(handles.popupmenu14,'Visible','off')
    set(handles.text16,'Visible','off')
else
    set(handles.popupmenu14,'Visible','on')
    set(handles.text16,'Visible','on')
end
CC2(member9,18)=CC2(member9,19);
CC2=sortrows(CC2,[7],'descend');
assignin('base','CC2',CC2);
% set level menu
set(handles.popupmenu2,'Value',1);
set(handles.popupmenu2,'String',natsort(unique(CC2(:,12))));
% accumulation time to none
set(handles.popupmenu14,'Value',1)
% check for winds
var_val=get(handles.popupmenu1, 'Value');
var_str=get(handles.popupmenu1, 'String');
set(handles.popupmenu15,'Value',1);
set(handles.text1,'String','READY');drawnow;
popupmenu2_Callback(@popupmenu2_Callback, eventdata, handles)
% --- LEVEL menu
function popupmenu2_Callback(~, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
evalin( 'base', 'clear ACCUMULATION' )
CC2=evalin('base','CC2');
%% get prev run

run_val=get(handles.popupmenu3, 'Value');
run_str=get(handles.popupmenu3, 'String');
try
    PREVIOUSrun=run_str(run_val);
    assignin('base','PREVIOUSrun',PREVIOUSrun);
end
%% filter parametes for run
lev_val=get(handles.popupmenu2, 'Value');
lev_str=get(handles.popupmenu2, 'String');
stringToCheck = char(lev_str(lev_val)); % LEVEL
member=find(strcmp(stringToCheck,CC2(:,12)));
CC4=CC2(member,:);
CC4=sortrows(CC4,[17,18]);
[~,a2]=natsort(CC4(:,13));
CC4=CC4(a2,:);
assignin('base','CC4',CC4);
%% set run menu
set(handles.popupmenu3,'Value',1);
set(handles.popupmenu3,'String',unique(CC4(:,17),'sorted'));

TWRINArun=get(handles.popupmenu3, 'String');
assignin('base','TWRINArun',TWRINArun);
try
    [~,check1]=ismember(TWRINArun,PREVIOUSrun);
    check1(:,2)=1:numel(check1);
    check1(check1(:,1)==0)=nan;
    check1(any(isnan(check1), 2), :) = [];
    set(handles.popupmenu3,'Value',check1(1,2));
catch
end
set(handles.text1,'String','READY');drawnow;
popupmenu3_Callback(@popupmenu3_Callback, eventdata, handles)
plot_setting(@plot_setting, eventdata, handles)
% --- DATE menu
function popupmenu3_Callback(~, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
% try to set fcs that already is there
fcs_val=get(handles.popupmenu4, 'Value');
fcs_str=get(handles.popupmenu4, 'String');
try
    PREVIOUS=fcs_str(fcs_val);
    assignin('base','PREVIOUS',PREVIOUS);
end
%
CC4=evalin('base','CC4');
day_val=get(handles.popupmenu3, 'Value');
day_str=get(handles.popupmenu3, 'String');
stringToCheck = char(day_str(day_val)); % DATE
assignin('base','stringToCheck',stringToCheck);
member=find(strcmp(stringToCheck,CC4(:,17)));
CC4=CC4(member,:);

tempo=CC4(:,1);
[~,tempo]=unique(sort(tempo));
CC4=CC4(tempo,:);

iin=datetime(CC4(:,18),'InputFormat','dd-MMM-yy HH:mm:ss');
[iin,a2]=sort(iin);
CC4=CC4(a2,:);

set(handles.popupmenu4,'String',CC4(:,18));
set(handles.popupmenu4,'Value',1);
CC8=CC4;
%     [~,a2]=natsort(CC8(:,19));
%     CC8=CC8(a2,:);
assignin('base','CC8',CC8);
popupmenu14_Callback(@popupmenu14_Callback, eventdata, handles)

assignin('base','CC8',CC8);

% assignin('base','TIMESIZE',numel(CC8(:,13)));
TWRINA=get(handles.popupmenu4, 'String');
%     TWRINA=natsort(TWRINA);
%     iin=datetime(CC8(:,18),'InputFormat','dd-MM-yy HH:mm:ss');
%     [iin,a2]=sort(iin);
%     TWRINA=TWRINA(a2);
assignin('base','TWRINA',TWRINA);
%     set(handles.popupmenu4,'String',TWRINA);

try
    [~,check1]=ismember(TWRINA,PREVIOUS);
    check1(:,2)=1:numel(check1);
    check1(check1(:,1)==0)=nan;
    check1(any(isnan(check1), 2), :) = [];
    set(handles.popupmenu4,'Value',check1(1,2));
catch
end
set(handles.text1,'String','READY');drawnow;


popupmenu4_Callback(@popupmenu4_Callback, eventdata, handles)
% --- FCS
function popupmenu4_Callback(~, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
CC8=evalin('base','CC8');
%% filter parametes for fcs
fcs_val=get(handles.popupmenu4, 'Value');
assignin('base','fcs_val',fcs_val);
IDX=str2double(char(CC8(fcs_val,1)));
IDX2=char(CC8(fcs_val,16));
UNITS=char(CC8(fcs_val,15));
LEV=cell2mat(CC8(fcs_val,7));
PAR=cell2mat(CC8(fcs_val,4));
assignin('base','IDX2',IDX2);
assignin('base','IDX',IDX);
assignin('base','UNITS',UNITS);
assignin('base','LEV',LEV);
assignin('base','PAR',PAR);
set(handles.text3,'String',CC8(fcs_val,3))
set(handles.text4,'String',CC8(fcs_val,4))
set(handles.text5,'String',CC8(fcs_val,12))
set(handles.text6,'String',CC8(fcs_val,13))
%% read grib sketo
read_grib1_time(@read_grib1_time, eventdata, handles)
%% read winds or read grib accumulated
WIN=get(handles.popupmenu1, 'String');
WIN2=get(handles.popupmenu1, 'Value');
if strcmp(WIN(WIN2),'WINDS')==1
    WINDSVAR=1;
    assignin('base','WINDSVAR',WINDSVAR);
    data=evalin('base','data');
    data_u=data;
    fcs_val=get(handles.popupmenu4, 'Value');
    assignin('base','fcs_val',fcs_val);
    IDX=str2double(char(CC8(fcs_val,2)));
    IDX2=char(CC8(fcs_val,16));
    assignin('base','IDX2',IDX2);
    assignin('base','IDX',IDX);
    read_grib1_time(@read_grib1_time, eventdata, handles)
    data=evalin('base','data');
    data_v=data;
    data=sqrt(data_u.^2+data_v.^2);
    
    
    
    
    assignin('base','data',data);
    assignin('base','data_u',data_u);
    assignin('base','data_v',data_v);
    
else
    WINDSVAR=0;
    assignin('base','WINDSVAR',WINDSVAR);
    try
        ACCUMULATION=evalin('base','ACCUMULATION');
        if ACCUMULATION==1
            data=evalin('base','data');
            data_1=data;
            fcs_val2=get(handles.popupmenu4, 'Value');
            if fcs_val2==1
                assignin('base','fcs_val2',fcs_val2);
            else
                fcs_val2=fcs_val2-1;
                assignin('base','fcs_val2',fcs_val2);
            end
            IDX=str2double(char(CC8(fcs_val2,1)));
            IDX2=char(CC8(fcs_val2,16));
            assignin('base','IDX2',IDX2);
            assignin('base','IDX',IDX);
            read_grib1_time(@read_grib1_time, eventdata, handles)
            data=evalin('base','data');
            data_2=data;
            if fcs_val2==1
                data=data_1;
            else
                data=data_1-data_2;
            end
            assignin('base','data',data);
        end
    catch
    end
    if strcmp(PAR,'StaticStabilityLOW')
        fcs_val2=get(handles.popupmenu4, 'Value');
        IDX=str2double(char(CC8(fcs_val2,1)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_1=data;
        
        IDX=str2double(char(CC8(fcs_val2,2)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_2=data;
        
        data=-(data_2-data_1)/(850-925);
        
        assignin('base','data',data);
    elseif strcmp(PAR,'StaticStabilityHIGH')
        fcs_val2=get(handles.popupmenu4, 'Value');
        IDX=str2double(char(CC8(fcs_val2,1)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_1=data;
        
        IDX=str2double(char(CC8(fcs_val2,2)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_2=data;
        
        data=-(data_2-data_1)/(300-500);
        
        assignin('base','data',data);
        
    elseif strcmp(PAR,'StaticStabilityMED')
        fcs_val2=get(handles.popupmenu4, 'Value');
        IDX=str2double(char(CC8(fcs_val2,1)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_1=data;
        
        IDX=str2double(char(CC8(fcs_val2,2)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_2=data;
        
        data=-(data_2-data_1)/(500-700);
        
        assignin('base','data',data);
    elseif strcmp(PAR,'Q vectors - wind')
        fcs_val2=get(handles.popupmenu4, 'Value');
        IDX=str2double(char(CC8(fcs_val2,1)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_1=data;
        
        IDX=str2double(char(CC8(fcs_val2,2)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_2=data;
        
        %             IDX=str2double(char(CC8(fcs_val2,22)));
        %             IDX2=char(CC8(fcs_val2,16));
        %             assignin('base','IDX2',IDX2);
        %             assignin('base','IDX',IDX);
        %             read_grib1_time(@read_grib1_time, eventdata, handles)
        %             data=evalin('base','data');
        %             data_vv=data;
        
        Temperature700=data_1;
        Geodynamic700=data_2;
        kappa = 2/7; % kappa = R/c_p
        lon=evalin('base','lon');
        lat1=lon;
        ff = 2*(7.2921e-5).*sind(lat1);
        lat=evalin('base','lat');
        [ug vg]=gradient(Geodynamic700);
        vg=vg./ff;
        ug=ug./ff;
        PT=Temperature700*(1000/LEV)^kappa;
        sigma=-(PT/LEV).*gradient(PT);
        [gradTx gradTy]=gradient(Temperature700);
        %paragwgos ksexwrista
        [gradVG_ux gradVG_uy]=gradient(ug);
        [gradVG_vx gradVG_vy]=gradient(vg);
        Q1x=(8.314/LEV)*gradVG_ux.*gradTx;
        Q1y=(8.314/LEV)*gradVG_vx.*gradTy;
        Q2x=-(8.314/LEV)*gradVG_uy.*gradTx;
        Q2y=-(8.314/LEV)*gradVG_vy.*gradTy;
        Q1=Q1x+Q1y;
        Q2=Q2x+Q2y;
        
        div = -2*divergence(lat,lon,Q1,Q2);
        assignin('base','div',div);
        data=div;
        %             data=sqrt(Q1.^2+Q2.^2);
        %             data=data_vv;
        %
        WINDSVAR=1;
        assignin('base','WINDSVAR',WINDSVAR);
        data_u=Q1;
        data_v=Q2;
        assignin('base','data_u',data_u);
        assignin('base','data_v',data_v);
        assignin('base','data',data);
        
    elseif strcmp(PAR,'Q vectors divergence')
        fcs_val2=get(handles.popupmenu4, 'Value');
        IDX=str2double(char(CC8(fcs_val2,1)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_1=data;
        
        IDX=str2double(char(CC8(fcs_val2,2)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_2=data;
        
        Temperature700=data_1;
        Geodynamic700=data_2;
        kappa = 2/7; % kappa = R/c_p
        lon=evalin('base','lon');
        lat1=lon;
        ff = 2*(7.2921e-5).*sind(lat1);
        lat=evalin('base','lat');
        [ug vg]=gradient(Geodynamic700);
        vg=vg./ff;
        ug=ug./ff;
        PT=Temperature700*(1000/LEV)^kappa;
        sigma=-(PT/LEV).*gradient(PT);
        [gradTx gradTy]=gradient(Temperature700);
        %paragwgos ksexwrista
        [gradVG_ux gradVG_uy]=gradient(ug);
        [gradVG_vx gradVG_vy]=gradient(vg);
        Q1x=(8.314/LEV)*gradVG_ux.*gradTx;
        Q1y=(8.314/LEV)*gradVG_vx.*gradTy;
        Q2x=-(8.314/LEV)*gradVG_uy.*gradTx;
        Q2y=-(8.314/LEV)*gradVG_vy.*gradTy;
        Q1=Q1x+Q1y;
        Q2=Q2x+Q2y;
        
        div = -2*divergence(lat,lon,Q1,Q2);
        assignin('base','div',div);
        data=div;
        %             data=Q2;
        %             data=sqrt(Q1.^2+Q2.^2);
        %
        %             WINDSVAR=1;
        %             assignin('base','WINDSVAR',WINDSVAR);
        %             data_u=Q1;
        %             data_v=Q2;
        %             assignin('base','data_u',data_u);
        %             assignin('base','data_v',data_v);
        assignin('base','data',data);
        
    elseif strcmp(PAR,'ThermalWindHIGH')
        fcs_val2=get(handles.popupmenu4, 'Value');
        IDX=str2double(char(CC8(fcs_val2,1)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_1=data;
        
        IDX=str2double(char(CC8(fcs_val2,2)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_2=data;
        
        lat=evalin('base','lat');
        lon1=lat;lon1=lon1';
        lon=evalin('base','lon');
        lat1=lon;lat1=lat1;
        
        dx = 1.11e5*abs(lat(1,1)-lat(1,2))*cos(lat*pi/180);  % grid distance in zonal direction
        dy = 6.37e6*abs(lat(1,1)-lat(1,2))*pi/180;            % grid distance in meridional direction
        
        
        ff = 2*(7.2921e-5).*sind(lat1);
        dz=(data_2-data_1);
        [aa bb]=gradient(dz);
        
        Vt_x=((1./(ff.*dx)).*aa);
        Vt_y=((1./(ff.*dy)).*bb);
        Vt=sqrt(Vt_x.^2+Vt_y.^2);
        data_u=Vt_x;
        data_v=Vt_y;
        data=Vt;
        %             temp=lon==0;
        %             data(temp)=nan;
        %             data_u(temp)=nan;
        %             data_v(temp)=nan;
        assignin('base','data',data);
        assignin('base','data_u',data_u);
        assignin('base','data_v',data_v);
        WINDSVAR=1;
        assignin('base','WINDSVAR',WINDSVAR);
        
        
    elseif strcmp(PAR,'ThermalWindLOW')
        fcs_val2=get(handles.popupmenu4, 'Value');
        IDX=str2double(char(CC8(fcs_val2,1)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_1=data;
        
        IDX=str2double(char(CC8(fcs_val2,2)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data_2=data;
        
        
        lat=evalin('base','lat');
        lon1=lat;lon1=lon1';
        lon=evalin('base','lon');
        lat1=lon;lat1=lat1;
        
        dx = 1.11e5*abs(lat(1,1)-lat(1,2))*cos(lat*pi/180);  % grid distance in zonal direction
        dy = 6.37e6*abs(lat(1,1)-lat(1,2))*pi/180;            % grid distance in meridional direction
        
        
        ff = 2*(7.2921e-5).*sind(lat1);
        dz=(data_2-data_1);
        [aa bb]=gradient(dz);
        
        Vt_x=((1./(ff.*dx)).*aa);
        Vt_y=((1./(ff.*dy)).*bb);
        Vt=sqrt(Vt_x.^2+Vt_y.^2);
        data_u=Vt_x;
        data_v=Vt_y;
        data=Vt;
        %                         temp=lon==0;
        %             data(temp)=nan;
        %             data_u(temp)=nan;
        %             data_v(temp)=nan;
        assignin('base','data',data);
        assignin('base','data_u',data_u);
        assignin('base','data_v',data_v);
        
        WINDSVAR=1;
        assignin('base','WINDSVAR',WINDSVAR);
        
        
    elseif strcmp(PAR,'AIRMASS')
        fcs_val2=get(handles.popupmenu4, 'Value');
        IDX=str2double(char(CC8(fcs_val2,1)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        WV_062=data;
        
        IDX=str2double(char(CC8(fcs_val2,2)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        WV_073=data;
        
        IDX=str2double(char(CC8(fcs_val2,14)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        IR_097=data;
        
        IDX=str2double(char(CC8(fcs_val2,15)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        IR_108=data;
        
        R=WV_062-WV_073;
        R(R>0)=0;
        R(R<-25)=-25;
        
        G=IR_097-IR_108;
        G(G>5)=5;
        G(G<-40)=-40;
        
        B=WV_062;
        B(B>243)=243;
        B(B<208)=208;
        data = cat(3, imadjust(uint8(255 * mat2gray(R))), imadjust(uint8(255 * mat2gray(G))), imadjust(uint8(255-255 * mat2gray(B))));
        
        assignin('base','data',data);
    elseif strcmp(PAR,'DAY_24h')
        fcs_val2=get(handles.popupmenu4, 'Value');
        IDX=str2double(char(CC8(fcs_val2,1)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        IR_120=data;
        
        IDX=str2double(char(CC8(fcs_val2,2)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        IR_108=data;
        
        IDX=str2double(char(CC8(fcs_val2,14)));
        IDX2=char(CC8(fcs_val2,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        IR_087=data;
        
        R=IR_120-IR_108;
        R(R>2)=2;
        R(R<-4)=-4;
        G=IR_108-IR_087;
        G(G>6)=6;
        G(G<0)=0;
        B=IR_108;
        B(B>303)=303;
        B(B<248)=248;
        R=R+273.15;
        G=G+273.15;
        data = cat(3, uint8(255 * mat2gray(R)), uint8(255 * (mat2gray(G)).^(1/1.2)), uint8(255 * mat2gray(B)));
        assignin('base','data',data);
        
    end
end
%% plotting menu - change values of first plots
ll=get(handles.checkbox2,'value');
if ll==1
else
    if strcmp(PAR,'DAY_24h')
    elseif strcmp(PAR,'AIRMASS')
    else
        plot_setting(@plot_setting, eventdata, handles)
    end
end
view(2)
data=evalin('base','data');

%% winds
WINDSVAR=evalin('base','WINDSVAR');
if WINDSVAR==0
    try
        QUI=evalin('base','QUI');
        QUI.UData(:,:) = 0;
        QUI.VData(:,:) = 0;
        
        
    end
elseif  WINDSVAR==1
    %     try
    % %         data_u=evalin('base','data_u');
    % %         data_v=evalin('base','data_v');
    % %         QUI=evalin('base','QUI');
    % %         AS=evalin('base','AS');
    % %         [MINMAX_X]=AS.XLim;
    % %         DX=round(MINMAX_X(1,2)-MINMAX_X(1,1));
    % %         [MINMAX_Y]=AS.YLim;
    % %         DY=round(MINMAX_Y(1,2)-MINMAX_Y(1,1));
    % %         DD=round(mean([DX DY]));
    % %
    % %         QUI.UData = data_u(1:DD:end);
    % %         QUI.VData = data_v(1:DD:end);
    try
        QUI=evalin('base','QUI');
        delete(QUI);
    end
    try
        
        BARBS=evalin('base','BARBS');
        delete(BARBS);
    end
    try
        BARBS2=evalin('base','BARBS2');
        delete(BARBS2);
        %             evalin('base','clear BARBS2')
    end
    lat=evalin('base','lat');
    lon=evalin('base','lon');
    hold on
    AS=get(handles.axes1);
    [MINMAX_X]=AS.XLim;
    DX=round(MINMAX_X(1,2)-MINMAX_X(1,1));
    [MINMAX_Y]=AS.YLim;
    DY=round(MINMAX_Y(1,2)-MINMAX_Y(1,1));
    DD=round(mean([DX DY]));
    assignin('base','AS',AS);
    wNUM=str2num(get(handles.edit8,'String'));
    test_barb=get(handles.checkbox9,'Value');
    
    if wNUM>25 & test_barb==1
        set(handles.edit8,'String',25)
        wNUM=25;
    elseif wNUM>70 & test_barb==0
        set(handles.edit8,'String',70)
        wNUM=50;
    elseif wNUM<0
        set(handles.edit8,'String',20)
        wNUM=20;
    end
    
    xD=(MINMAX_X(1,2)-MINMAX_X(1,1))/wNUM;
    yD=(MINMAX_Y(1,2)-MINMAX_Y(1,1))/wNUM;
    [x,y] = meshgrid(MINMAX_X(1,1):xD:MINMAX_X(1,2),MINMAX_Y(1,1):yD:MINMAX_Y(1,2));
    x=double(x);
    y=double(y);
    data_u=double(data_u);
    data_v=double(data_v);
    
    u=griddata(double(lat(:)),double(lon(:)),data_u(:),x,y);
    v=griddata(double(lat(:)),double(lon(:)),data_v(:),x,y);
    
    if test_barb==0
        [DIR,SPD] = cart2pol(v*1.94384449,u*1.94384449);
        DIR=rad2deg(DIR)+180;
        idxf=SPD<5;
        u(idxf)=nan;
        v(idxf)=nan;
        
        QUI=quiver(x,y,u,v,2,'color','black','AutoScale','on');
        assignin('base','v',v);
        
        
        
        x(~idxf)=nan;
        y(~idxf)=nan;
        BARBS2=plot(x,y,'ko');
        assignin('base','BARBS2',BARBS2);
        
    else
        [DIR,SPD] = cart2pol(v*1.94384449,u*1.94384449);
        DIR=rad2deg(DIR)+180;
        ll=numel(SPD);
        
        
        idxf=SPD<5;
        %         x(~idxf)=nan;
        %         y(~idxf)=nan;
        BARBS2=plot(x,y,'ko');
        assignin('base','BARBS2',BARBS2);
        
        for lll=1:ll
            if SPD(lll)>=5
                windbarb(x(lll),y(lll),SPD(lll) ,DIR(lll),0.02,1,'black')
            end
        end
        drawnow
    end
    %QUI=quiver(lat(1:DD:end),lon(1:DD:end),data_u(1:DD:end),data_v(1:DD:end),2,'color','black');
    assignin('base','QUI',QUI);
    hold off
    
    %     catch
    %     end
end
%% every pcolor
try
    PCOL=evalin('base','PCOL');
    PCOL.CData = data;
    %         set(PCOL,'facealpha',1)
    
catch
end
%% view min max in boxes
set(handles.edit1,'String',num2str(min(min(data))));drawnow;
set(handles.edit2,'String',num2str(max(max(data))));drawnow;
%%
AS2=get(handles.axes1);
assignin('base','AS2',AS2);
popupmenu10_Callback(@popupmenu10_Callback, eventdata, handles)
popupmenu21_Callback(@popupmenu21_Callback, eventdata, handles)

lat=evalin('base','lat');
lon=evalin('base','lon');
data=evalin('base','data');
AS3=get(handles.axes1);
[MINMAX_X]=AS3.XLim;
[MINMAX_Y]=AS3.YLim;
assignin('base','AS3',AS3);
[MINMAX_X(1,2) MINMAX_X(1,1) MINMAX_Y(1,2) MINMAX_Y(1,1)];
lat(lat>MINMAX_X(1,2))=nan;
lat(lat<MINMAX_X(1,1))=nan;
lon(lon>MINMAX_Y(1,2))=nan;
lon(lon<MINMAX_Y(1,1))=nan;
A1=isnan(lat);
A2=isnan(lon);
A3=A1+A2;
A3(A3>0)=1;
A3=logical(A3);
data(A3)=nan;

try
    m1=lat(find(data==min(min(data))));
    m2=lon(find(data==min(min(data))));
    m3=data(find(data==min(min(data))));
    m1=mean(m1);
    m2=mean(m2);
    m3=mean(m3);
    m4=CC8(fcs_val,18);
    M=[m1;m2;m3;m4];
    
    try
        M1=evalin('base','M');
        M=[M1 M];
    end
    
    [mm1,mm2]=size(M);
    if mm2>30
        M(1,:)=[];
    end
    assignin('base','M',M);
end
textval=get(handles.edit19, 'String');
set(handles.text1,'String','READY');drawnow;
% --- SOURCE menu
function popupmenu13_Callback(~, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
evalin('base','clearvars -except S RGB MyListOfDirs INITIAL cmap_m cmap_l cmap_h cmap_blue_white_red')
FIRST=1;
assignin('base','FIRST',FIRST);
MyListOfDirs=evalin('base','MyListOfDirs');
DIR_NUM=get(handles.popupmenu13,'Value');
INITIAL=evalin('base','INITIAL');
Infolder = dir(char(fullfile(INITIAL,MyListOfDirs(DIR_NUM),'\*.grb')));
DIR_NAME=char(MyListOfDirs(DIR_NUM));
assignin('base','DIR_NAME',DIR_NAME);
MyListOfFiles = [];
for i = 1:length(Infolder)
    if Infolder(i).isdir==0
        MyListOfFiles{end+1,1} = Infolder(i).name;
    end
end
assignin('base','MyListOfFiles',MyListOfFiles);
evalin('base','clear CC3');
for i=1:numel(MyListOfFiles)
    assignin('base','file',char(MyListOfFiles{i,1}));
    read_contents(@read_contents, eventdata, handles)
end
CC3=evalin('base','CC3');
change_names(@change_names,eventdata,handles)
CC3=evalin('base','CC3');
% find derived quantities
evalin( 'base', 'clear WINDS' );
find_derived(@find_derived, eventdata, handles);
try
    WINDS=evalin('base','WINDS');
catch
    WINDS={};
end
try
    PT=evalin('base','PT');
catch
    PT={};
end
try
    STATICSTABILITY_LOW=evalin('base','STATICSTABILITY_LOW');
catch
    STATICSTABILITY_LOW={};
end
try
    QVECTORS=evalin('base','QVECTORS');
catch
    QVECTORS={};
end
try
    STATICSTABILITY_HIGH=evalin('base','STATICSTABILITY_HIGH');
catch
    STATICSTABILITY_HIGH={};
end
try
    STATICSTABILITY_MED=evalin('base','STATICSTABILITY_MED');
catch
    STATICSTABILITY_MED={};
end
try
    THERMAL_WIND_HIGH=evalin('base','THERMAL_WIND_HIGH');
catch
    THERMAL_WIND_HIGH={};
end
try
    THERMAL_WIND_LOW=evalin('base','THERMAL_WIND_LOW');
catch
    THERMAL_WIND_LOW={};
end
try
    AIRMASS=evalin('base','AIRMASS');
catch
    AIRMASS={};
end
try
    DAY_24h=evalin('base','DAY_24h');
catch
    DAY_24h={};
end
CC3=[CC3;WINDS;PT;STATICSTABILITY_HIGH;STATICSTABILITY_LOW;STATICSTABILITY_MED;THERMAL_WIND_LOW;THERMAL_WIND_HIGH;AIRMASS;DAY_24h;QVECTORS;];
assignin('base','CC3',CC3);
% remove single wind fields
APCP=strcmp(CC3(:,4),'UGRD');
CC3(APCP,:)=[];
APCP=strcmp(CC3(:,4),'VGRD');
CC3(APCP,:)=[];
% set parameters menu
set(handles.popupmenu1,'String',unique(CC3(:,4),'sorted'));
set(handles.popupmenu1,'Value',1);
par_val=get(handles.popupmenu1, 'Value');
par_str=get(handles.popupmenu1, 'String');
stringToCheck = char(par_str(par_val));
member=find(cellfun(@(x)contains(stringToCheck,x), CC3(:,4)));
CC3=CC3(member,:);
% exit function
evalin( 'base', 'clear lat' );
evalin( 'base', 'clear lon' );
evalin( 'base', 'clear data' );
popupmenu1_Callback(@popupmenu1_Callback, eventdata, handles)
pushbutton3_Callback(@pushbutton3_Callback, eventdata, handles)
draw_first(@draw_first, eventdata, handles)
FIRST=0;
assignin('base','FIRST',FIRST);
set(handles.text1,'String','READY');drawnow;

function popupmenu6_Callback(~, ~, handles)
str=get(handles.popupmenu6,'String');
val=get(handles.popupmenu6,'Value');
assignin('base','str',str);
assignin('base','val',val);
shading(str{val})
function popupmenu10_Callback(~, eventdata, handles)
%     popupmenu4_Callback(@popupmenu4_Callback, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
CC3=evalin('base','CC3');
UNITS=evalin('base','UNITS');
GEO=strcmp(CC3(:,4),'GeoDynamic Height');
GEO=CC3(GEO,:);
GEO1=strcmp(GEO(:,12),'sfc'); %exclude geodynamic height from contour at surface
GEO1=GEO(~GEO1,:);
GEO2=strcmp(CC3(:,4),'MSL Pressure');
GEO2=CC3(GEO2,:);
GEO=[GEO1;GEO2];
assignin('base','GEO',GEO);
set(handles.popupmenu15,'String',unique(GEO(:,12)));
check1=get(handles.popupmenu15,'String');
check2=get(handles.popupmenu15,'Value');
try
    LEV=check1(check2);
    QQ=strcmp(GEO(:,12),check1(check2));
    GEO=GEO(QQ,:);
    assignin('base','GEO',GEO);
    todo_val=get(handles.popupmenu10,'Value');
    if todo_val==1
        try
            CON2=evalin('base','CON2');
            delete(CON2);
        catch
        end
    elseif todo_val==2
        day_val=get(handles.popupmenu4, 'Value');
        day_str=get(handles.popupmenu4, 'String');
        stringToCheck = char(day_str(day_val)); % DATE
        assignin('base','stringToCheck',stringToCheck);
        member=find(strcmp(stringToCheck,GEO(:,18)));
        GEO=GEO(member,:);
        IDX=str2double(char(GEO(1,1)));
        IDX2=char(GEO(1,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        if strcmp(GEO(1,15),'[gpm]')
            data=data;
        elseif strcmp(GEO(1,15),'[Pa]')
            data=data/100;
        else
            data=data/9.81;
        end
        lat=evalin('base','lat');
        lon=evalin('base','lon');
        try
            CON2=evalin('base','CON2');
            delete(CON2);
        catch
        end
        STEP=str2num(get(handles.edit9,'String'));
        hold on
        [~,CON2]=contour(lat,lon,data,'LevelStep',STEP,'ShowText','on','LineWidth',1.5,'color','black');
        hold off
        assignin('base','CON2',CON2);
    end
catch
end
set(handles.text1,'String','READY');drawnow;
function popupmenu11_Callback(~, eventdata, handles)
MIN=get(handles.edit4,'String');
MAX=get(handles.edit6,'String');
if exist(MIN)==0 & exist(MAX)==0
    if isempty(MIN) | isempty(MAX)
    else
        axes(handles.axes1);
        caxis([str2double(MIN) str2double(MAX)]);
    end
end
str=get(handles.popupmenu11, 'String');
val=get(handles.popupmenu11, 'Value');
NUMS=get(handles.edit7,'String');
assignin('base','NUMS',NUMS);
assignin('base','str',str);
assignin('base','val',val);
B=get(handles.checkbox3,'Value');
assignin('base','B',B);
if strcmp(char(str(val)),'Precipitation')==1
    RGB=evalin('base','RGB');
    AA=RGB;
    if B==1
        AA=flipud(AA);
    end
    colormap(AA)
elseif strcmp(char(str(val)),'Clouds High')==1
    cmap_h=evalin('base','cmap_h');
    AA=cmap_h;
    AA=flipud(AA);
    if B==1
        AA=flipud(AA);
    end
    colormap(AA);
elseif strcmp(char(str(val)),'Clouds Low')==1
    cmap_l=evalin('base','cmap_l');
    AA=cmap_l;
    AA=flipud(AA);
    if B==1
        AA=flipud(AA);
    end
    colormap(AA);
elseif strcmp(char(str(val)),'BlackWhite')==1
    colormap(gray);
elseif strcmp(char(str(val)),'BF')==1
    popupmenu4_Callback(@popupmenu4_Callback, eventdata, handles)
    colormap(hsv(13));
    MIN=0;
    MAX=13;
    caxis([MIN MAX]);
elseif strcmp(char(str(val)),'KT')==1
    popupmenu4_Callback(@popupmenu4_Callback, eventdata, handles)
    colormap(flipud(hot(25)));
    MIN=0;
    MAX=100;
    caxis([MIN MAX]);
elseif strcmp(char(str(val)),'WhiteBlack')==1
    colormap(flipud(gray));
elseif strcmp(char(str(val)),'BlueWhiteRed')==1
    cmap_l=evalin('base','cmap_blue_white_red');
    AA=cmap_l;
    colormap(AA);
elseif strcmp(char(str(val)),'Clouds Medium')==1
    cmap_m=evalin('base','cmap_m');
    AA=cmap_m;
    AA=flipud(AA);
    if B==1
        AA=flipud(AA);
    end
    colormap(AA);
end
A=strcat(char(str(val)),'(',NUMS,')');
try
    AA=colormap(A);
    if B==1
        AA=flipud(AA);
    end
    colormap(AA)
catch
end
function popupmenu14_Callback(~, ~, handles)
acc_val=get(handles.popupmenu14,'Value');
acc_str=get(handles.popupmenu14,'String');
assignin('base','acc_str',acc_str);
assignin('base','acc_val',acc_val);
if strcmp(char(acc_str(acc_val)),'None')
    ACCUMULATION=0;assignin('base','ACCUMULATION',ACCUMULATION);
else
    ACCUMULATION=1;assignin('base','ACCUMULATION',ACCUMULATION);
end
CC8=evalin('base','CC8');
AN=datetime(CC8(:,17),'InputFormat','dd-MMM-yyyy HH:mm:ss');
FC=datetime(CC8(:,18),'InputFormat','dd-MMM-yyyy HH:mm:ss');
diff=hours(FC-AN);
if strcmp(char(acc_str(acc_val)),'3 hour')==1
    new(:,1)=floor(diff/3)-diff/3;
    new(new<0)=nan;
    CC8(:,19)=num2cell(new);
elseif strcmp(char(acc_str(acc_val)),'1 hour')==1
    new(:,1)=floor(diff/1)-diff/1;
    new(new<0)=nan;
    CC8(:,19)=num2cell(new);
elseif strcmp(char(acc_str(acc_val)),'6 hour')==1
    new(:,1)=floor(diff/6)-diff/6;
    new(new<0)=nan;
    CC8(:,19)=num2cell(new);
elseif strcmp(char(acc_str(acc_val)),'12 hour')==1
    new(:,1)=floor(diff/12)-diff/12;
    new(new<0)=nan;
    CC8(:,19)=num2cell(new);
elseif strcmp(char(acc_str(acc_val)),'24 hour')==1
    new(:,1)=floor(diff/24)-diff/24;
    new(new<0)=nan;
    CC8(:,19)=num2cell(new);
elseif strcmp(char(acc_str(acc_val)),'None')==1
end
CC8(any(cellfun(@(x) any(isnan(x)),CC8),2),:) = [];
iin=datetime(CC8(:,18),'InputFormat','dd-MMM-yy HH:mm:ss');
[iin,a2]=sort(iin);
CC8=CC8(a2,:);
assignin('base','CC8',CC8);
assignin('base','TIMESIZE',numel(CC8(:,13)));
set(handles.popupmenu4,'String',CC8(:,18));
set(handles.popupmenu4,'Value',1);

set(handles.text1,'String','READY');drawnow;
function popupmenu15_Callback(~, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15
popupmenu10_Callback(@popupmenu10_Callback, eventdata, handles)
function popupmenu21_Callback(~, eventdata, handles)
%     popupmenu4_Callback(@popupmenu4_Callback, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
CC3=evalin('base','CC3');
UNITS=evalin('base','UNITS');
GEO=strcmp(CC3(:,4),'Temperature');
GEO=CC3(GEO,:);
GEO1=strcmp(GEO(:,12),'sfc'); %exclude geodynamic height from contour at surface
GEO1=GEO(~GEO1,:);
GEO3=[GEO1;];
assignin('base','GEO3',GEO3);
set(handles.popupmenu22,'String',unique(GEO3(:,12)));
check1=get(handles.popupmenu22,'String');
check2=get(handles.popupmenu22,'Value');
try
    LEV=check1(check2);
    QQ=strcmp(GEO3(:,12),check1(check2));
    GEO3=GEO3(QQ,:);
    assignin('base','GEO3',GEO3);
    if todo_val==1
        try
            con2=evalin('base','con2');
            delete(con2);
        catch
        end
    elseif todo_val==2
        day_val=get(handles.popupmenu4, 'Value');
        day_str=get(handles.popupmenu4, 'String');
        stringToCheck = char(day_str(day_val)); % DATE
        assignin('base','stringToCheck',stringToCheck);
        member=find(strcmp(stringToCheck,GEO3(:,18)));
        GEO3=GEO3(member,:);
        IDX=str2double(char(GEO3(1,1)));
        IDX2=char(GEO3(1,16));
        assignin('base','IDX2',IDX2);
        assignin('base','IDX',IDX);
        read_grib1_time(@read_grib1_time, eventdata, handles)
        data=evalin('base','data');
        data=data-273.15;
        lat=evalin('base','lat');
        lon=evalin('base','lon');
        try
            con2=evalin('base','con2');
            delete(con2);
        catch
        end
        STEP=str2num(get(handles.edit18,'String'));
        hold on
        [~,con2]=contour(lat,lon,data,'LevelStep',STEP,'ShowText','on','LineWidth',1.5,'color',[47/256 79/256 79/256],'LineStyle',':');
        hold off
        assignin('base','con2',con2);
    end
catch
end
set(handles.text1,'String','READY');drawnow;
function popupmenu22_Callback(~, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu22 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu22
popupmenu21_Callback(@popupmenu21_Callback, eventdata, handles)

function edit4_Callback(~, ~, handles)
MIN=get(handles.edit4,'String');
MAX=get(handles.edit6,'String');
if exist(MIN)==0 && exist(MAX)==0
    if isempty(MIN) || isempty(MAX)
    else
        axes(handles.axes1);
        caxis([str2double(MIN) str2double(MAX)]);
    end
end
function edit6_Callback(~, ~, handles)
MIN=get(handles.edit4,'String');
MAX=get(handles.edit6,'String');
if exist(MIN)==0 && exist(MAX)==0
    if isempty(MIN) || isempty(MAX)
    else
        axes(handles.axes1);
        caxis([str2double(MIN) str2double(MAX)]);
    end
end
function edit7_Callback(~, eventdata, handles)
popupmenu11_Callback(@popupmenu11_Callback, eventdata, handles)
function edit8_Callback(~, eventdata, handles)
popupmenu4_Callback(@popupmenu4_Callback, eventdata, handles)
function edit9_Callback(~, eventdata, handles)

popupmenu10_Callback(@popupmenu10_Callback, eventdata, handles)
function edit10_Callback(~, ~, handles)
sszz=str2num(get(handles.edit10,'String'))
try
    STPL=evalin('base','STPL');
    STPL.SizeData=sszz;
    assignin('base','STPL',STPL);
end
function edit11_Callback(~, ~, handles)
sszz2=str2num(get(handles.edit11,'String'));
STNM=evalin('base','STNM');
[a,~]=size(STNM);
for i=1:a
    STNM(i).FontSize=sszz2;
end
assignin('base','STNM',STNM);
function edit12_Callback(~, eventdata, handles)
pushbutton36_Callback(@pushbutton36_Callback, eventdata, handles)
function edit13_Callback(~, eventdata, handles)
pushbutton36_Callback(@pushbutton36_Callback, eventdata, handles)
function edit14_Callback(~, eventdata, handles)
pushbutton36_Callback(@pushbutton36_Callback, eventdata, handles)
function edit15_Callback(~, eventdata, handles)
pushbutton36_Callback(@pushbutton36_Callback, eventdata, handles)
function edit18_Callback(~, eventdata, handles)
popupmenu21_Callback(@popupmenu21_Callback, eventdata, handles)
function edit19_Callback(~, ~, handles)
textval=get(handles.edit19, 'String');
axes(handles.axes1);
set(gca,'FontSize',str2num(textval))
grid on
set(gca,'layer','top')

function pushbutton6_Callback(~, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
fcs_val=get(handles.popupmenu4, 'Value');
if fcs_val==1
else
    fcs_val=fcs_val-1;
    set(handles.popupmenu4,'Value',fcs_val);
    popupmenu4_Callback(@popupmenu4_Callback, eventdata, handles)
end
set(handles.text1,'String','READY');drawnow;
function pushbutton7_Callback(~, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
TIMESIZE=evalin('base','TIMESIZE');
fcs_val=get(handles.popupmenu4, 'Value');
if fcs_val<TIMESIZE
    fcs_val=fcs_val+1;
    set(handles.popupmenu4,'Value',fcs_val);
    popupmenu4_Callback(@popupmenu4_Callback, eventdata, handles)
end
set(handles.text1,'String','READY');drawnow;
function pushbutton12_Callback(hObject, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
A=get(handles.popupmenu3, 'String');
B=get(handles.popupmenu3, 'Value');
[~,~]=size(A);
if B>1
    B=B-1;
    set(handles.popupmenu3, 'Value',B)
    popupmenu3_Callback(@popupmenu3_Callback, eventdata, handles)
end
set(handles.text1,'String','READY');drawnow;
function pushbutton13_Callback(~, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
A=get(handles.popupmenu3, 'String');
B=get(handles.popupmenu3, 'Value');
[a,~]=size(A);
if B<a
    B=B+1;
    set(handles.popupmenu3, 'Value',B)
    popupmenu3_Callback(@popupmenu3_Callback, eventdata, handles)
end
set(handles.text1,'String','READY');drawnow;
function pushbutton17_Callback(~, eventdata, handles)
MIN=get(handles.edit1,'String');
MAX=get(handles.edit2,'String');
set(handles.edit4,'String',MIN);
set(handles.edit6,'String',MAX);
popupmenu11_Callback(@popupmenu11_Callback, eventdata, handles)
function pushbutton20_Callback(~, ~, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text1,'String','WORKING');drawnow;
try
    pushbutton21_Callback(@pushbutton21_Callback)
catch
end

evalin( 'base', 'clear X' )
evalin( 'base', 'clear Y' )
evalin( 'base', 'clear Z' )

[X,Y] = getpts;

assignin('base','X',X);
assignin('base','Y',Y);
lat=evalin('base','lat');
lon=evalin('base','lon');
data=evalin('base','data');
for i=1:numel(X)
    XX=lat-X(i,1);
    YY=lon-Y(i,1);
    A=find(abs(XX)==min(abs(XX),[],2));
    B=find(abs(YY)==min(abs(YY),[],1));
    member=ismember(A,B);
    res=A(member);
    RES(i,1)=data(res);
end
RES=round(RES*100)/100;
assignin('base','RES',RES);
hold on
SCT=scatter(X,Y,30,1/RES,'filled');
for i=1:numel(RES)
    Cha{i,1}=char(strcat({'   '},char(num2str(RES(i,1)))));
end
STNM2=text(X,Y,Cha,'HorizontalAlignment','left','FontSize',14);
assignin('base','STNM2',STNM2);
assignin('base','SCT',SCT);
hold off

set(handles.text1,'String','READY');drawnow;
function pushbutton21_Callback(~, ~, ~)
STNM2=evalin('base','STNM2');
SCT=evalin('base','SCT');
delete(SCT)
delete(STNM2)
function pushbutton31_Callback(~, ~, handles)
set(handles.text1,'String','WORKING');drawnow;
A=get(handles.popupmenu3, 'Value');
B=get(handles.popupmenu3, 'String');
C=get(handles.popupmenu1, 'Value');
D=get(handles.popupmenu1, 'String');
E=get(handles.popupmenu2, 'Value');
F=get(handles.popupmenu2, 'String');
export_fig(strcat(char(D(C)),'_',char(F(E)),'_',mat2str(A),'_.png'),'-m2.5')
set(handles.text1,'String','READY');drawnow;
function pushbutton33_Callback(~, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
A=get(handles.popupmenu3, 'Value')
B=get(handles.popupmenu3, 'String')
C=get(handles.popupmenu1, 'Value')
D=get(handles.popupmenu1, 'String')
E=get(handles.popupmenu2, 'Value')
F=get(handles.popupmenu2, 'String')
for j=1:numel(B)
    set(handles.text1,'String','PRINTING');drawnow;
    export_fig(strcat('AN_',char(D(C)),'_',char(F(E)),'_',mat2str(j),'_.png'),'-m2.5')
    pushbutton13_Callback(@pushbutton13_Callback, eventdata, handles)
end
set(handles.text1,'String','READY');drawnow;
function pushbutton34_Callback(~, eventdata, handles)
set(handles.text1,'String','WORKING');drawnow;
A=get(handles.popupmenu4, 'Value')
B=get(handles.popupmenu4, 'String')
C=get(handles.popupmenu1, 'Value')
D=get(handles.popupmenu1, 'String')
E=get(handles.popupmenu2, 'Value')
F=get(handles.popupmenu2, 'String')
for j=1:numel(B)
    set(handles.text1,'String','PRINTING');drawnow;
    export_fig(strcat('FC_',char(D(C)),'_',char(F(E)),'_',mat2str(j),'_.png'),'-m2.5')
    pushbutton7_Callback(@pushbutton7_Callback, eventdata, handles)
end
set(handles.text1,'String','READY');drawnow;
function pushbutton36_Callback(~, ~, handles)
set(handles.text1,'String','WORKING');drawnow;
S=str2num(get(handles.edit12,'String'));
N=str2num(get(handles.edit13,'String'));
E=str2num(get(handles.edit14,'String'));
W=str2num(get(handles.edit15,'String'));
ylim([S N])
xlim([E W])
set(handles.text1,'String','READY');drawnow;
function pushbutton37_Callback(~, ~, handles)
INITIAL = pwd;
INITIAL=strcat(INITIAL,'\INPUT_GRIB\');
Infolder = dir(fullfile(INITIAL,'*'));
assignin('base','INITIAL',INITIAL);
MyListOfDirs = [];
for i = 1:length(Infolder)
    if Infolder(i).isdir==1
        MyListOfDirs{end+1,1} = Infolder(i).name;
    end
end
MyListOfDirs=MyListOfDirs(3:end,:);
[q1,~]=size(MyListOfDirs);
assignin('base','MyListOfDirs',MyListOfDirs);
if q1>0
    set(handles.popupmenu13,'String',MyListOfDirs)
    set(handles.popupmenu13,'Value',1)
end
function pushbutton42_Callback(~, eventdata, handles)
lat=evalin('base','lat');
lon=evalin('base','lon');
axes(handles.axes1); %set the current axes to axes4
set(handles.text1,'String','SELECT');drawnow;
hFH = imfreehand(handles.axes1);
xy = hFH.getPosition;
delete(hFH);
assignin('base','xy',xy);
xCoordinates = xy(:, 1);
yCoordinates = xy(:, 2);
XQ=lat;YQ=lon;
s1=(xCoordinates(1,1):0.001:xCoordinates(2,1));
[~,qq2]=size(s1);s2=linspace(yCoordinates(1,1),yCoordinates(2,1),qq2);
s1=[s1;s2];s1=round(100*s1)/100;
s1=s1';s1=unique(s1,'rows');[~,qq2]=size(s1');
for i=1:qq2
    t1=abs(XQ(:)-s1(i,1));
    t2=abs(YQ(:)-s1(i,2));
    a(i,1)=find(min(sqrt(abs(XQ(:)-s1(i,1)).^2+abs(YQ(:)-s1(i,2)).^2))== sqrt(abs(XQ(:)-s1(i,1)).^2+abs(YQ(:)-s1(i,2)).^2));
    a(i,2)=XQ(a(i,1));
    a(i,3)=YQ(a(i,1));
end
a=unique(a,'rows');
assignin('base','a',a);
CC2=evalin('base','CC2');
b1=get(handles.popupmenu3,'String');
b2=get(handles.popupmenu3,'Value');
b2=b1(b2);
c1=get(handles.popupmenu4,'String');
c2=get(handles.popupmenu4,'Value');
c2=c1(c2);
NEW=CC2;
stringToCheck = char(b2);
member=find(strcmp(stringToCheck, NEW(:,17)));
NEW=NEW(member,:);
stringToCheck = char(c2);
member=find(strcmp(stringToCheck, NEW(:,18)));
NEW=NEW(member,:);
[~,idx8]=unique(cell2mat(NEW(:,7)),'rows');
NEW =  NEW(idx8,:);
stringToCheck='100';
member=find(strcmp(stringToCheck, NEW(:,6)));
NEW=NEW(member,:);
NEW=sortrows(NEW,[7],'descend');
assignin('base','NEW',NEW);
[b1,c1]=size(NEW);
[c5,d5]=size(a);
if b1>0
    for k=1:b1
        WIN=get(handles.popupmenu1, 'String');
        WIN2=get(handles.popupmenu1, 'Value');
        if strcmp(WIN(WIN2),'WINDS')==1
            IDX=str2double(char(NEW(k,1)));
            IDX2=char(NEW(k,16));
            assignin('base','IDX',IDX);
            assignin('base','IDX2',IDX2);
            read_grib1_time(@read_grib1_time, eventdata, handles)
            data_u=evalin('base','data');
            IDX=str2double(char(NEW(k,2)));
            IDX2=char(NEW(k,16));
            assignin('base','IDX',IDX);
            assignin('base','IDX2',IDX2);
            read_grib1_time(@read_grib1_time, eventdata, handles)
            data_v=evalin('base','data');
            data=sqrt(data_u.^2+data_v.^2);
        else
            IDX=str2double(char(NEW(k,1)));
            IDX2=char(NEW(k,16));
            assignin('base','IDX',IDX);
            assignin('base','IDX2',IDX2);
            read_grib1_time(@read_grib1_time, eventdata, handles)
            plot_setting(@plot_setting, eventdata, handles)
            data=evalin('base','data');
        end
        for i=1:qq2
            try
                A(k,i)=data(a(i,1));
            end
        end
    end
    assignin('base','A',A);
    vertic=80;
    horizo=10;
    levels=cell2mat(NEW(:,7));
    levels2=linspace(max(levels),min(levels),vertic)';
    test=get(handles.checkbox10,'Value');
    if test==1
        if b1>1
            [XXq,YYq] = meshgrid(1:0.25:c5,levels2);
            [Xq,Yq] = meshgrid(1:1:c5,levels);
            A = interp2(Xq,Yq,A,XXq,YYq,'cubic');
        elseif b1==1
            XXq = 1:0.25:c5;
            Xq  = 1:1:c5;
            A = interp1(Xq,A,XXq,'cubic');
        end
    end
    [cc5,dd5]=size(A);
    if b1>1
        h1=figure;maximize;
        pcolor(A);shading flat;colorbar;colormap(jet(80))
        rt=levels;
        yticks(linspace(1,cc5,numel(levels)))
        yticklabels(rt);
    elseif b1==1
        h1=figure;maximize;
        plot(A,'o-');grid on
    end
    aa=a(:,2:3)';aa=round(aa*100)/100;
    cc(:,1)=linspace(min(aa(1,:)),max(aa(1,:)),horizo);
    cc(:,2)=linspace(min(aa(2,:)),max(aa(2,:)),horizo);
    aa=cellstr(string(cc'));
    bb=round(linspace(1,dd5,horizo));
    cc=round(linspace(1,dd5,horizo));
    for j=1:10
        bbb{1,j}=aa(:,j);
    end
    h2= my_xticklabels(gca,bb,bbb);
    assignin('base','A',A);
end
set(handles.text1,'String','READY');drawnow;
function pushbutton43_Callback(~, eventdata, handles)
% hObject    handle to pushbutton43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text1,'String','Select one Point');drawnow;
CC2=evalin('base','CC2');
evalin( 'base', 'clear X' )
evalin( 'base', 'clear Y' )
[X,Y] = getpts;
set(handles.text1,'String','WORKING');drawnow;
lat=evalin('base','lat');
lon=evalin('base','lon');
XQ=lat;YQ=lon;
a(1,1)=find(min(sqrt(abs(XQ(:)-X).^2+abs(YQ(:)-Y).^2))== sqrt(abs(XQ(:)-X).^2+abs(YQ(:)-Y).^2));
a(1,2)=XQ(a(1,1));
a(1,3)=YQ(a(1,1));
b1=get(handles.popupmenu3,'String');
b2=get(handles.popupmenu3,'Value');
b2=b1(b2);
c1=get(handles.popupmenu2,'String');
c2=get(handles.popupmenu2,'Value');
c2=c1(c2);
NEW=CC2;
stringToCheck = char(b2);
member=find(strcmp(stringToCheck, NEW(:,17)));
NEW=NEW(member,:);
stringToCheck = char(c2);
member=find(strcmp(stringToCheck, NEW(:,12)));
NEW=NEW(member,:);
assignin('base','NEW',NEW);
iin=datetime(NEW(:,18),'InputFormat','dd-MM-yy HH:mm:ss');
[~,idxx]=sort(iin);
NEW=NEW(idxx,:);
rt=(NEW(:,19));
[b1,c1]=size(NEW);
[c5,d5]=size(a);
WINDSVAR=evalin('base','WINDSVAR');
if b1>1
    for k=1:b1
        if WINDSVAR==0
            IDX=str2double(char(NEW(k,1)));
            IDX2=char(NEW(k,16));
            assignin('base','IDX',IDX);
            assignin('base','IDX2',IDX2);
            read_grib1_time(@read_grib1_time, eventdata, handles)
            plot_setting(@plot_setting, eventdata, handles)
            data=evalin('base','data');
            A(k,1)=data(a(1,1));
        elseif WINDSVAR==1
            IDX=str2double(char(NEW(k,1)))
            IDX2=char(NEW(k,16))
            assignin('base','IDX',IDX);
            assignin('base','IDX2',IDX2);
            read_grib1_time(@read_grib1_time, eventdata, handles)
            plot_setting(@plot_setting, eventdata, handles)
            data_u=evalin('base','data');
            IDX=str2double(char(NEW(k,2)))
            IDX2=char(NEW(k,16));
            assignin('base','IDX',IDX);
            assignin('base','IDX2',IDX2);
            read_grib1_time(@read_grib1_time, eventdata, handles)
            plot_setting(@plot_setting, eventdata, handles)
            data_v=evalin('base','data');
            [theta,rho] = cart2pol(data_u,data_v);
            A(k,1)=rho(a(1,1));
            B(k,1)=theta(a(1,1));
        end
    end
    [~,idx8]=unique(cell2mat(NEW(:,7)),'rows');
    NEW =  NEW(idx8,:);
    [b1,c1]=size(NEW);
    [d1,e1]=size(A);
    A=reshape(A,b1,d1/b1);
    [cc5,dd5]=size(A);
    h1=figure;maximize;
    plot(A,'o-');
    xticks(1:1:dd5);
    xticklabels(rt);
    xtickangle(45)
    grid on
end
set(handles.text1,'String','READY');drawnow;


function checkbox2_Callback(hObject, eventdata, handles)
pushbutton17_Callback(hObject, eventdata, handles)
function checkbox3_Callback(~, eventdata, handles)
popupmenu11_Callback(@popupmenu11_Callback, eventdata, handles)
function checkbox5_Callback(~, ~, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
ll=get(handles.checkbox5,'value');
STNM=evalin('base','STNM');
[a,~]=size(STNM);
i=1;
if ll==1
    for i=1:a
        STNM(i).Visible='on';
    end
else
    for i=1:a
        STNM(i).Visible='off';
    end
end
assignin('base','STNM',STNM);
function checkbox6_Callback(~, ~, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
ll=get(handles.checkbox6,'value');
STPL=evalin('base','STPL');
if ll==1
    STPL.Visible='on';
else
    STPL.Visible='off';
end
assignin('base','STPL',STPL);
function checkbox9_Callback(~, eventdata, handles)
popupmenu4_Callback(@popupmenu4_Callback, eventdata, handles)
function checkbox10_Callback(~, ~, ~)
%% CREATES

function listbox1_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox2_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit1_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit4_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit6_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit7_CreateFcn(hObject, ~, ~)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit8_CreateFcn(hObject, ~, ~)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit9_CreateFcn(hObject, ~, ~)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit10_CreateFcn(hObject, ~, ~)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit11_CreateFcn(hObject, ~, ~)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit12_CreateFcn(hObject, ~, ~)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit13_CreateFcn(hObject, ~, ~)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit14_CreateFcn(hObject, ~, ~)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit15_CreateFcn(hObject, ~, ~)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit18_CreateFcn(hObject, ~, ~)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit19_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu1_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu2_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu3_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu4_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu5_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu6_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'interp','flat','faceted'});
function popupmenu9_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu10_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% set(hObject, 'String', {'pcolor', 'contourf','contour'});
set(hObject, 'String', {'NONE','contour geoheight'});
function popupmenu11_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'jet','parula','hsv','hot','Precipitation','Geodynamic','Temperature','Height in m','Height in FT','Relative Humidity','MSLP','Pressure','Clouds High','Clouds Medium','Clouds Low','BlackWhite','WhiteBlack','BlueWhiteRed','KT','BF'});
function popupmenu14_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'None','1 hour','3 hour','6 hour','12 hour','24 hour'});
function popupmenu13_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu15_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu21_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'NONE','contour temp in gh'});
function popupmenu22_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%% USER-DEFINED FUNCTIONS
function draw_plots_Callback(~, eventdata, handles)
S=evalin('base','S');
AA=get(handles.edit1,'String');
assignin('base','AA',AA);
data=evalin('base','data');
try
    STEP=evalin('base','STEP');
catch
end
hold on
set(handles.edit1,'String',num2str(min(min(data))));drawnow;
set(handles.edit2,'String',num2str(max(max(data))));drawnow;
cla(handles.axes1)
axes(handles.axes1);
strQ=get(handles.popupmenu10,'String');
valQ=get(handles.popupmenu10,'Value');
assignin('base','strQ',strQ);
assignin('base','valQ',valQ);
data=evalin('base','data');
lat=evalin('base','lat');
lon=evalin('base','lon');
if strcmp(strQ(valQ),'pcolor')
    PCOL=pcolor(lat,lon,data);
    assignin('base','PCOL',PCOL);
elseif strcmp(strQ(valQ),'contourf')
    contourf(lat,lon,data,'LevelStep',STEP,'ShowText','on');
elseif strcmp(strQ(valQ),'contour')
    contour(lat,lon,data,'LevelStep',STEP,'ShowText','on','LineWidth',1.5);
end
popupmenu6_Callback(@popupmenu6_Callback, eventdata, handles);
colorbar ;
Stations=read_stations('stations.xls');
Stations_LATLON=cell2mat(Stations(:,3:4));
Stations_NAME=Stations(:,1);
Stations_NUMBER=Stations(:,2);
LOC=Stations_NAME;
X=Stations_LATLON(:,1);
Y=Stations_LATLON(:,2);
Z=zeros(size(X));
PCOL=scatter(X,Y,30,'red','filled');
for i=1:numel(X)
    PCOL=text(X(i,1),Y(i,1),2,strcat({'   '},char(LOC{i,1})),'HorizontalAlignment','left','FontSize',14);
end
hold off
function plot_setting(~, eventdata, handles)
UNITS=evalin('base','UNITS');
data=evalin('base','data');
RGB=evalin('base','RGB');
LEV=evalin('base','LEV');
LEV22=get(handles.popupmenu2,'String');
LEV2=get(handles.popupmenu2,'Value');
LEV2=LEV22(LEV2);
assignin('base','LEV2',LEV2);
g=evalin('base','g');
PAR=evalin('base','PAR');
cmap_h=evalin('base','cmap_h');
cmap_m=evalin('base','cmap_m');
cmap_l=evalin('base','cmap_l');
cmap_blue_white_red=evalin('base','cmap_blue_white_red');
set(handles.popupmenu6,'Value',1); %interp 1, flat 2, faceted 3
popupmenu6_Callback(@popupmenu6_Callback, eventdata, handles)
%% try to read winds
try
    data_v=evalin('base','data_v');
    data_u=evalin('base','data_u');
catch
end
%% change some vars
if strcmp(UNITS,{'[K]'})
    if strcmp(PAR,{'StaticStabilityLOW'}) % ypologizoume to dPT/dP
        STEP=0.01;
        MIN=-0.1;
        MAX=0.1;
        colormap(jet(round(abs(MAX-MIN)/STEP)))
        caxis([MIN MAX]);
    elseif strcmp(PAR,{'StaticStabilityHIGH'}) % ypologizoume to dPT/dP
        STEP=0.005;
        MIN=0.04;
        MAX=0.18;
        colormap(jet(round(abs(MAX-MIN)/STEP)))
        caxis([MIN MAX]);
    elseif strcmp(PAR,{'StaticStabilityMED'}) % ypologizoume to dPT/dP
        STEP=0.005;
        MIN=0.02;
        MAX=0.16;
        colormap(jet(round(abs(MAX-MIN)/STEP)))
        caxis([MIN MAX]);
    elseif strcmp(PAR,{'Potential_T'}) % ypologizoume to dPT/dP
        data=data-273.15;
        data_old=data;
        data=data*(1000/LEV)^0.286;
        STEP=0.5;
        if LEV==500
            MIN=-26;
            MAX=-10;
        elseif LEV==1000
            MIN=-5;
            MAX=45;
        elseif LEV==950
            MIN=-5;
            MAX=40;
        elseif LEV==925
            MIN=-5;
            MAX=40;
        elseif LEV==900
            MIN=-5;
            MAX=35;
        elseif LEV==850
            MIN=-10;
            MAX=35;
        elseif LEV==800
            MIN=-15;
            MAX=30;
        elseif LEV==700
            MIN=-20;
            MAX=15;
        elseif LEV==600
            MIN=-26;
            MAX=5;
        elseif LEV==400
            MIN=-60;
            MAX=-20;
        elseif LEV==300
            MIN=-80;
            MAX=-45;
        elseif LEV==200
            MIN=-80;
            MAX=-45;
        elseif LEV==150
            MIN=-80;
            MAX=-45;
        elseif LEV==100
            MIN=-80;
            MAX=-45;
        elseif LEV==2
            MIN=-10;
            MAX=45;
            data=data_old;
        else
            MIN=-80;
            MAX=-45;
        end
        colormap(jet(round(abs(MAX-MIN)/STEP)))
        caxis([MIN MAX]);
    elseif strcmp(PAR,{'Temperature'})
        data=data-273.15;
        STEP=0.5;
        if LEV==500
            MIN=-26;
            MAX=-10;
        elseif LEV==1000
            MIN=-5;
            MAX=45;
        elseif LEV==950
            MIN=-5;
            MAX=40;
        elseif LEV==925
            MIN=-5;
            MAX=40;
        elseif LEV==900
            MIN=-5;
            MAX=35;
        elseif LEV==850
            MIN=-10;
            MAX=35;
        elseif LEV==800
            MIN=-15;
            MAX=30;
        elseif LEV==700
            MIN=-20;
            MAX=15;
        elseif LEV==600
            MIN=-26;
            MAX=5;
        elseif LEV==400
            MIN=-60;
            MAX=-20;
        elseif LEV==300
            MIN=-80;
            MAX=-45;
        elseif LEV==200
            MIN=-80;
            MAX=-45;
        elseif LEV==150
            MIN=-80;
            MAX=-45;
        elseif LEV==100
            MIN=-80;
            MAX=-45;
        end
        try
            caxis([MIN MAX]);
        end
    else
        data=data-273.15;
        STEP=0.5;
        MIN=-20;
        MAX=30;
        colormap(jet(round(abs(MAX-MIN)/STEP)))
        caxis([MIN MAX]);
    end
elseif strcmp(UNITS,{'[(0 - 1)]'})
    data=data*100;;
    MIN=0;
    MAX=100;
    caxis([MIN MAX]);
    STEP=5;
elseif strcmp(UNITS,{'[%]'})
    MIN=0;
    MAX=100;
    caxis([MIN MAX]);
    if strcmp(PAR,{'Clouds High'})
        data(data==0)=nan;
        MIN=0;
        MAX=100;
        caxis([MIN MAX]);
        STEP=5;
        colormap(flipud(cmap_h));
    elseif strcmp(PAR,{'Clouds Low'})
        data(data==0)=nan;
        MIN=0;
        MAX=100;
        caxis([MIN MAX]);
        STEP=5;
        colormap(flipud(cmap_l));
    elseif strcmp(PAR,{'Clouds Medium'})
        data(data==0)=nan;
        MIN=0;
        MAX=100;
        caxis([MIN MAX]);
        STEP=5;
        colormap(flipud(cmap_m));
    else
        MIN=0;
        MAX=100;
        caxis([MIN MAX]);
        colormap(jet(20));
        STEP=5;
    end
elseif (strcmp(UNITS,{'[m/s]'}) | strcmp(UNITS,{'[m s**-1]'})) & ~strcmp(PAR,{'Vertical vel.(w)'})
    str22=get(handles.popupmenu11, 'Value');
    if str22==20
        data=evalin('base','data');
        if str22==20
            data(data<1)=0;
            data(data>=1 & data<3)=1;
            data(data>=3 & data<7)=2;
            data(data>=7 & data<10)=3;
            data(data>=10 & data<17)=4;
            data(data>=17 & data<21)=5;
            data(data>=21 & data<27)=6;
            data(data>=27 & data<33)=7;
            data(data>=33 & data<40)=8;
            data(data>=40 & data<47)=9;
            data(data>=47 & data<55)=10;
            data(data>=55 & data<63)=11;
            data(data>=63)=12;
        end
        assignin('base','data',data);
        STEP=1;
    else
        colormap(flipud(hot(25)));
        MIN=0;
        MAX=100;
        caxis([MIN MAX]);
        data=data*1.9438444924406;
        try
            data_u=data_u*1.9438444924406;
            data_v=data_v*1.9438444924406;
        end
        STEP=58;
    end
elseif (strcmp(UNITS,{'[m**2 s**-2]'}) | strcmp(UNITS,{'[gpm]'})) & ~(strcmp(LEV2,{'cld base'}) | strcmp(LEV2,{'cld top'})|strcmp(LEV2,{'0C isotherm'}) )
    MIN=min(min(data));
    MAX=max(max(data));
    caxis([MIN MAX]);
    colormap(jet(72));
    STEP=60;
elseif strcmp(PAR,{'Cloud Base Height'}) && strcmp(UNITS,{'[non-dim]'})
    data=data*3.28084; %in FT
    data=data/1000; %in KFT
    MIN=0;
    MAX=40;
    STEP=1;
    colormap(jet(round(abs(MAX-MIN)/STEP)))
    caxis([MIN MAX]);
    set(handles.popupmenu6,'Value',2); %interp 1, flat 2, faceted 3
    popupmenu6_Callback(@popupmenu6_Callback, eventdata, handles)
elseif strcmp(UNITS,{'[kg/m^2]'})||strcmp(UNITS,{'[kg/(m**2)]'})
    colormap(RGB);
    MIN=0;
    MAX=100;
    caxis([MIN MAX]);
    STEP=5;
elseif strcmp(UNITS,{'[Pa]'})
    data=data/100;
    if LEV==0
        colormap(hsv(30));
        MIN=980;
        MAX=1040;
        caxis([MIN MAX]);
        STEP=2;
    end
    STEP=20;
elseif strcmp(UNITS,{'[dbZ]'})
    colormap(jet(16));
    MIN=-20;
    MAX=60;
    caxis([MIN MAX]);
    STEP=5;
elseif strcmp(PAR,{'Height Level'})
    colormap(jet(80));
    if strcmp(UNITS,{'[gpm]'})
        data=data*3.28084; %in FT
        data=data/1000; %in KFT
    elseif strcmp(UNITS,{'[m]'})
        data=data*3.28084; %in FT
        data=data/1000; %in KFT
    end
    data(data<0)=nan;
    MIN=0;
    MAX=40;
    caxis([MIN MAX]);
    STEP=1;
elseif strcmp(LEV2,{'cld base'}) | strcmp(LEV2,{'cld top'})
    data(data<0)=nan;
    data=data*3.2808399/1000;
    MIN=0;
    MAX=50;
    caxis([MIN MAX]);
    STEP=1;
    colormap(jet(40));
    set(handles.popupmenu6,'Value',2); %interp 1, flat 2, faceted 3
    popupmenu6_Callback(@popupmenu6_Callback, eventdata, handles)
elseif strcmp(LEV2,{'0C isotherm'})
    data=data*3.2808399/1000;
    MIN=0;
    MAX=50;
    caxis([MIN MAX]);
    STEP=1;
    colormap(jet(40));
elseif strcmp(PAR,{'Vertical vel.(w)'})
    data=data*10;
    MIN=-10;
    MAX=10;
    caxis([MIN MAX]);
    STEP=1;
    colormap((cmap_blue_white_red));
elseif strcmp(PAR,{'Visibility'})
    data=data/1000;
    data(data>10)=10;
    MIN=0;
    MAX=10;
    caxis([MIN MAX]);
    STEP=1;
    colormap(jet(40));
    set(handles.popupmenu6,'Value',2); %interp 1, flat 2, faceted 3
    popupmenu6_Callback(@popupmenu6_Callback, eventdata, handles)
elseif strcmp(PAR,{'var240'})
    colormap(jet(80));
    data(data<0)=nan;
    data=data*3.28084; %in FT
    data=data/1000; %in KFT
    MIN=0;
    MAX=40;
    caxis([MIN MAX]);
    STEP=1;
elseif strcmp(PAR,{'Vertical Velocity'})
    colormap(jet(40));
    data=data*1.9438444924406; %in KT
    MIN=-1;
    MAX=1;
    caxis([MIN MAX]);
    STEP=1;
else
    STEP=1000;
end
%% write data to workspace
assignin('base','data',data);
assignin('base','STEP',STEP);
try
    assignin('base','data_u',data_u);
    assignin('base','data_v',data_v);
catch
end
function find_derived(~, ~, ~)
CC3=evalin('base','CC3');
VGRD=strcmp(CC3(:,4),'VGRD');
V=CC3(VGRD,:);
clearvars VGRD
PT=strcmp(CC3(:,4),'Temperature');
PT=CC3(PT,:);
temp=strcmp(PT(:,4),'Temperature');
PT(temp,4)={'Potential_T'};
PT2=strcmp(CC3(:,4),'GeoDynamic Height');
PT2=CC3(PT2,:);
temp=strcmp(PT2(:,4),'GeoDynamic Height');
PT2(temp,4)={'ThermalWind'};
try
    THERMAL_WIND_LOW=PT2;
    temp=strcmp(THERMAL_WIND_LOW(:,4),'ThermalWind');
    THERMAL_WIND_LOW(temp,4)={'ThermalWindLOW'};
    temp=cell2mat(THERMAL_WIND_LOW(:,7));
    Q=temp==500|temp==850;
    THERMAL_WIND_LOW=THERMAL_WIND_LOW(Q,:);
    temp=cell2mat(THERMAL_WIND_LOW(:,7));
    Q=temp==500;
    HIGH1=THERMAL_WIND_LOW(Q,1);
    Q=temp==850;
    HIGH2=THERMAL_WIND_LOW(Q,1);
    [h11,~]=size(HIGH1);
    [h21,~]=size(HIGH2);
    if h11==h21
        THERMAL_WIND_LOW=THERMAL_WIND_LOW(Q,:);
        THERMAL_WIND_LOW(:,1)=HIGH1;
        THERMAL_WIND_LOW(:,2)=HIGH2;
        THERMAL_WIND_LOW(:,12)={'500-850 mb'};
    else
        THERMAL_WIND_LOW=PT2;
        temp=strcmp(THERMAL_WIND_LOW(:,4),'ThermalWind');
        THERMAL_WIND_LOW(temp,4)={'ThermalWindLOW'};
        temp=cell2mat(THERMAL_WIND_LOW(:,7));
        Q=temp==500|temp==850;
        THERMAL_WIND_LOW=THERMAL_WIND_LOW(Q,:);
        temp=cell2mat(THERMAL_WIND_LOW(:,7));
        Q=temp==500;
        HIGH1=THERMAL_WIND_LOW(Q,:);
        Q=temp==850;
        HIGH2=THERMAL_WIND_LOW(Q,:);
        [~,temp]=intersect(HIGH1(:,3),HIGH2(:,3));
        HIGH1=HIGH1(temp,1);
        HIGH2=HIGH2(temp,1);
        THERMAL_WIND_LOW=THERMAL_WIND_LOW(temp,:);
        THERMAL_WIND_LOW(:,1)=HIGH1;
        THERMAL_WIND_LOW(:,2)=HIGH2;
        THERMAL_WIND_LOW(:,12)={'500-850 mb'};
    end
    clearvars HIGH1 HIGH2
catch
end
try
    THERMAL_WIND_HIGH=PT2;
    temp=strcmp(THERMAL_WIND_HIGH(:,4),'ThermalWind');
    THERMAL_WIND_HIGH(temp,4)={'ThermalWindHIGH'};
    temp=cell2mat(THERMAL_WIND_HIGH(:,7));
    Q=temp==300|temp==500;
    THERMAL_WIND_HIGH=THERMAL_WIND_HIGH(Q,:);
    temp=cell2mat(THERMAL_WIND_HIGH(:,7));
    Q=temp==300;
    HIGH1=THERMAL_WIND_HIGH(Q,1);
    Q=temp==500;
    HIGH2=THERMAL_WIND_HIGH(Q,1);
    [h11,~]=size(HIGH1);
    [h21,~]=size(HIGH2);
    if h11==h21
        THERMAL_WIND_HIGH=THERMAL_WIND_HIGH(Q,:);
        THERMAL_WIND_HIGH(:,1)=HIGH1;
        THERMAL_WIND_HIGH(:,2)=HIGH2;
        THERMAL_WIND_HIGH(:,12)={'300-500 mb'};
    else
        THERMAL_WIND_HIGH=PT2;
        temp=strcmp(THERMAL_WIND_HIGH(:,4),'ThermalWind');
        THERMAL_WIND_HIGH(temp,4)={'ThermalWindHIGH'};
        temp=cell2mat(THERMAL_WIND_HIGH(:,7));
        Q=temp==300|temp==500;
        THERMAL_WIND_HIGH=THERMAL_WIND_HIGH(Q,:);
        temp=cell2mat(THERMAL_WIND_HIGH(:,7));
        Q=temp==300;
        HIGH1=THERMAL_WIND_HIGH(Q,:);
        Q=temp==500;
        HIGH2=THERMAL_WIND_HIGH(Q,:);
        [~,temp]=intersect(HIGH1(:,3),HIGH2(:,3));
        HIGH1=HIGH1(temp,1);
        HIGH2=HIGH2(temp,1);
        THERMAL_WIND_HIGH=THERMAL_WIND_HIGH(temp,:);
        THERMAL_WIND_HIGH(:,1)=HIGH1;
        THERMAL_WIND_HIGH(:,2)=HIGH2;
        THERMAL_WIND_HIGH(:,12)={'300-500 mb'};
    end
    clearvars HIGH1 HIGH2
catch
end
try
    assignin('base','THERMAL_WIND_HIGH',THERMAL_WIND_HIGH);
    assignin('base','THERMAL_WIND_LOW',THERMAL_WIND_LOW);
catch
end
% q vectors
PT=strcmp(CC3(:,4),'Temperature');
PT=CC3(PT,:);PT=sortrows(PT,[12 13]);
GH=strcmp(CC3(:,4),'GeoDynamic Height');
GH=CC3(GH,:);GH=sortrows(GH,[12 13]);
tempq=ismember(PT(:,12),GH(:,12));
tempq2=ismember(GH(:,12),PT(:,12));
PT=PT(tempq2,:);
GH=GH(tempq2,:);
clearvars tempq
try
    QVECTORS=PT;
    QVECTORS(:,4)={'Q vectors divergence'};
    QVECTORS(:,15)={'[m**2 s**-1]'};
    QVECTORS(:,14)={'Geopotential [m**2 s**-2]'};
    QVECTORS(:,2)=GH(:,1);
    QVECTORS2=PT;
    QVECTORS2(:,4)={'Q vectors - wind'};
    QVECTORS2(:,15)={'[m**2 s**-1]'};
    QVECTORS2(:,14)={'Geopotential [m**2 s**-2]'};
    QVECTORS2(:,2)=GH(:,1);
    QVECTORS=[QVECTORS;QVECTORS2;];
    assignin('base','QVECTORS',QVECTORS);
    clearvars QVECTORS
catch
end
try
    STATICSTABILITY_LOW=PT;
    temp=strcmp(STATICSTABILITY_LOW(:,4),'Potential_T');
    STATICSTABILITY_LOW(temp,4)={'StaticStabilityLOW'};
    temp=cell2mat(STATICSTABILITY_LOW(:,7));
    Q=temp==850|temp==925;
    STATICSTABILITY_LOW=STATICSTABILITY_LOW(Q,:);
    temp=cell2mat(STATICSTABILITY_LOW(:,7));
    Q=temp==850;
    LOW1=STATICSTABILITY_LOW(Q,1);
    Q=temp==925;
    LOW2=STATICSTABILITY_LOW(Q,1);
    STATICSTABILITY_LOW=STATICSTABILITY_LOW(Q,:);
    STATICSTABILITY_LOW(:,1)=LOW1;
    STATICSTABILITY_LOW(:,2)=LOW2;
    STATICSTABILITY_LOW(:,12)={'850-925 mb'};
    clearvars LOW1 LOW2
catch
end
try
    STATICSTABILITY_HIGH=PT;
    temp=strcmp(STATICSTABILITY_HIGH(:,4),'Potential_T');
    STATICSTABILITY_HIGH(temp,4)={'StaticStabilityHIGH'};
    temp=cell2mat(STATICSTABILITY_HIGH(:,7));
    Q=temp==300|temp==500;
    STATICSTABILITY_HIGH=STATICSTABILITY_HIGH(Q,:);
    temp=cell2mat(STATICSTABILITY_HIGH(:,7));
    Q=temp==300;
    HIGH1=STATICSTABILITY_HIGH(Q,1);
    Q=temp==500;
    HIGH2=STATICSTABILITY_HIGH(Q,1);
    STATICSTABILITY_HIGH=STATICSTABILITY_HIGH(Q,:);
    STATICSTABILITY_HIGH(:,1)=HIGH1;
    STATICSTABILITY_HIGH(:,2)=HIGH2;
    STATICSTABILITY_HIGH(:,12)={'300-500 mb'};
    clearvars HIGH1 HIGH2
catch
end
try
    STATICSTABILITY_MED=PT;
    temp=strcmp(STATICSTABILITY_MED(:,4),'Potential_T');
    STATICSTABILITY_MED(temp,4)={'StaticStabilityMED'};
    temp=cell2mat(STATICSTABILITY_MED(:,7));
    Q=temp==500|temp==700;
    STATICSTABILITY_MED=STATICSTABILITY_MED(Q,:);
    temp=cell2mat(STATICSTABILITY_MED(:,7));
    Q=temp==500;
    MED1=STATICSTABILITY_MED(Q,1);
    Q=temp==700;
    MED2=STATICSTABILITY_MED(Q,1);
    STATICSTABILITY_MED=STATICSTABILITY_MED(Q,:);
    STATICSTABILITY_MED(:,1)=MED1;
    STATICSTABILITY_MED(:,2)=MED2;
    STATICSTABILITY_MED(:,12)={'500-700 mb'};
    clearvars MED1 MED2
catch
end
UGRD=strcmp(CC3(:,4),'UGRD');
U=CC3(UGRD,:);
clearvars UGRD
U(:,2)=V(:,1);
WINDS=U;
WINDS(:,4)=cellfun(@(x){x}, cellstr('WINDS'));
clearvars U V
assignin('base','WINDS',WINDS);
assignin('base','PT',PT);
assignin('base','STATICSTABILITY_HIGH',STATICSTABILITY_HIGH);
assignin('base','STATICSTABILITY_LOW',STATICSTABILITY_LOW);
assignin('base','STATICSTABILITY_MED',STATICSTABILITY_MED);
HL=contains(CC3(:,12),'hybrid lev');
HL=CC3(HL,:);
temp=strcmp(HL(:,4),'Temperature');
HL(temp,4)={'AIRMASS'};
try
    AIRMASS=HL;
    temp=strcmp(AIRMASS(:,4),'AIRMASS');
    AIRMASS(temp,4)={'AIRMASS'};
    temp=cell2mat(AIRMASS(:,7));
    Q=temp==62|temp==73|temp==97|temp==108;
    AIRMASS=AIRMASS(Q,:);
    temp=cell2mat(AIRMASS(:,7));
    Q=temp==62;
    LOW1=AIRMASS(Q,1);
    Q=temp==73;
    LOW2=AIRMASS(Q,1);
    Q=temp==97;
    LOW3=AIRMASS(Q,1);
    Q=temp==108;
    LOW4=AIRMASS(Q,1);
    AIRMASS=AIRMASS(Q,:);
    if  numel(LOW1)==numel(LOW2) & numel(LOW1)==numel(LOW3) & numel(LOW1)==numel(LOW4) & numel(LOW2)==numel(LOW3) & numel(LOW3)==numel(LOW4)
        AIRMASS(:,1)=LOW1;
        AIRMASS(:,2)=LOW2;
        AIRMASS(:,14)=LOW3;
        AIRMASS(:,15)=LOW4;
        AIRMASS(:,12)={'atmosphere'};
        assignin('base','AIRMASS',AIRMASS);
    else
        AIRMASS={};
    end
end
HL=contains(CC3(:,12),'hybrid lev');
HL=CC3(HL,:);
temp=strcmp(HL(:,4),'Temperature');
HL(temp,4)={'DAY_24h'};
try
    AIRMASS=HL;
    temp=strcmp(AIRMASS(:,4),'AIRMASS');
    AIRMASS(temp,4)={'DAY_24h'};
    temp=cell2mat(AIRMASS(:,7));
    Q=temp==120|temp==108|temp==87;
    AIRMASS=AIRMASS(Q,:);
    temp=cell2mat(AIRMASS(:,7));
    Q=temp==120;
    LOW1=AIRMASS(Q,1);
    Q=temp==108;
    LOW2=AIRMASS(Q,1);
    Q=temp==87;
    LOW3=AIRMASS(Q,1);
    AIRMASS=AIRMASS(Q,:);
    if  numel(LOW1)==numel(LOW2) & numel(LOW1)==numel(LOW3) & numel(LOW2)==numel(LOW3)
        AIRMASS(:,1)=LOW1;
        AIRMASS(:,2)=LOW2;
        AIRMASS(:,14)=LOW3;
        AIRMASS(:,12)={'atmosphere'};
        DAY_24h=AIRMASS;
        assignin('base','DAY_24h',DAY_24h);
    else
        AIRMASS={};
    end
end
function read_contents(~, ~, ~)
try
    CC31=evalin('base','CC3');
catch
    CC31={};
end
try
    delete('diary')
end
file=evalin('base','file');
INITIAL=evalin('base','INITIAL');
DIR_NAME=evalin('base','DIR_NAME');
CHECK=1;
read_contents_exe(strcat(INITIAL,DIR_NAME,'\',file));
diary on
read_contents_exe(strcat(INITIAL,DIR_NAME,'\',file));
diary off
CC3 = importfile('diary', 1);
assignin('base','CC3',CC3);
% delete('diary')
CC3 = cellstr(CC3);
[CC3(:,10),~]=strtok(CC3(:,10),'"');
[CC3(:,15),~]=strtok(CC3(:,15),'"');
[~,CC3(:,16)]=strtok(CC3(:,15),'[');
CC3(:,end+1)={strcat(INITIAL,DIR_NAME,'\',file)};
stringToCheck = 'GRIB1';
member=find(cellfun(@(x)contains(stringToCheck,x), CC3(:,1)));
CC3=CC3(member,:);
CC3(:,1)=[];
stringToCheck = '';
member=find(cellfun(@(x)contains(stringToCheck,x), CC3(:,15)));
tmp=cell2mat(cellfun(@(x){str2double(x)}, CC3(:,11)));
tmp(tmp==1)=60;
tmp(tmp==0)=1;
CC3(:,11)=num2cell(tmp);
CC3(:,7)=num2cell(cell2mat(cellfun(@(x){str2double(x)}, CC3(:,7))));
CC3(:,9)=num2cell(cell2mat(cellfun(@(x){str2double(x)}, CC3(:,9))));
CC3(:,10)=num2cell(cell2mat(cellfun(@(x){str2double(x)}, CC3(:,10))));
assignin('base','CC3',CC3);
clearvars tmp
nco=ncgeodataset(strcat(INITIAL,DIR_NAME,'\',file));
AN=datetime(CC3(:,3),'InputFormat','yyMMddHH');
try
    tmpHourFactor=CC3(:,13);
    tmpHourFactor=strrep(tmpHourFactor,'valid ', '');
    [tmpHourFactor,~]=strtok(tmpHourFactor,' ');
    [~,qwer]=strtok(tmpHourFactor,'??');
    tmpHourFactor=strrep(tmpHourFactor,'??', 'hr');
    tmpHourFactor=strrep(tmpHourFactor,'anl', '0min');
    [tmpHourFactor,mins]=strtok(tmpHourFactor,'min');
    [tmpHourFactor,hrs]=strtok(tmpHourFactor,'hr');
    [~,qwe4]=strtok(tmpHourFactor,'-');
    [qwe4,~]=strtok(qwe4,'-');
    ch1=find(~cellfun(@isempty,qwe4));
    ch2=find(~cellfun(@isempty,qwer));
    [tmpHourFactor,~]=strtok(tmpHourFactor,'-');
    tmpHourFactor(ch1)=qwe4(ch1);
    tmpHourFactor=str2num(str2mat(tmpHourFactor));
    mins=find(~cellfun(@isempty,mins));
    hrs=find(~cellfun(@isempty,hrs));
    tmpHourFactor(hrs)=tmpHourFactor(hrs)*60;
    tmpHourFactor(ch2)=tmpHourFactor(ch2)*0.5;
    FC=AN+minutes(tmpHourFactor);
    FC_ACC=FC;
catch
    try
        FC=AN+ minutes(cell2mat(cellfun(@(x,y) x*y, CC3(:,9),CC3(:,11),'UniformOutput',false)));
        FC_ACC=AN+ minutes(cell2mat(cellfun(@(x,y) x*y, CC3(:,10),CC3(:,11),'UniformOutput',false)));
    end
end


try
   AN=datetime(AN,'Format','yy-MMM-dd HH:mm:ss');
end
try
    FC=datetime(FC,'Format','yy-MMM-dd HH:mm:ss');
end
try
    FC_ACC=datetime(FC_ACC,'Format','yy-MMM-dd HH:mm:ss');
end

CC3(:,17)=cellstr(AN);
try
    CC3(:,18)=cellstr(FC);
catch
    CC3(:,18)=cellstr(AN);
end
try
    CC3(:,19)=cellstr(FC_ACC);
catch
    CC3(:,19)=cellstr(AN);
end
CC3=[CC31;CC3];
assignin('base','CC3',CC3);
function read_grib1_time(~, ~, ~)
% Load variables from the base workspace
[IDX, IDX2] = load_base_variables();

% Read GRIB1 data
[data, ~, ~] = ReadGRIB1(IDX2, IDX);

% Get projection information
nco = ncgeodataset(IDX2);
PROJECTION = nco.variables{1};

try
    % Get latitude and longitude from nco object
    [lat, lon] = get_lat_lon_from_nco(nco);
catch
    % Get x and y from nco object
    [x, y] = get_x_y_from_nco(nco);
    
    if strcmp(char(PROJECTION), 'LambertConformal_Projection') == 1
        % Extract projection parameters and convert x and y coordinates to lat and lon
        [lat, lon] = convert_lambert_conformal(x, y, nco);
    elseif strcmp(char(PROJECTION), 'RotatedLatLon_Projection') == 1
        % Extract projection parameters and rotate coordinates to obtain lat and lon
        [lat, lon] = convert_rotated_latlon(x, y, nco);
    end
end

% Calculate gravitational acceleration (g)
g = 9.81;

% Assign g, data, lat, and lon to the base workspace
assignin('base', 'g', g);
assignin('base', 'data', data);
assignin('base', 'lat', lat);
assignin('base', 'lon', lon);
function [IDX, IDX2] = load_base_variables()
% Load IDX and IDX2 from the base workspace

IDX = evalin('base', 'IDX');
IDX2 = evalin('base', 'IDX2');
function [lon,lat] = get_lat_lon_from_nco(nco)
% Get latitude and longitude from the nco object

lat = nco{'lat'}(:);
lon = nco{'lon'}(:);
lat1=lat;
lat = double(repmat(lat', [numel(lon), 1]));
lon = double(repmat(lon', [numel(lat1), 1]));
lat = lat';
function [x, y] = get_x_y_from_nco(nco)
% Get x and y from the nco object

x = nco{'x'}(:);
y = nco{'y'}(:);
x1=x;
x = repmat(x', [numel(y), 1]);
y = repmat(y', [numel(x1), 1]);
y = y';
function [OriginLatitude, OriginLongitude, FirstStandardParallel, SecondStandardParallel] = lambert_projection_parameters(nco)
% Extract projection parameters for Lambert Conformal Conic projection from the nco object

details = nco{'LambertConformal_Projection'};
details = details.attributes;

% Extract necessary values from the attributes
OriginLatitude = cell2mat(details(strcmp({'latitude_of_projection_origin'}, details(:, 1)), 2));
OriginLongitude = cell2mat(details(strcmp({'longitude_of_central_meridian'}, details(:, 1)), 2));
temp2 = cell2mat(details(strcmp({'standard_parallel'}, details(:, 1)), 2));
FirstStandardParallel = temp2(1, 1);

if numel(temp2) > 1
    SecondStandardParallel = temp2(2, 1);
else
    SecondStandardParallel = FirstStandardParallel;
end
function [SouthPoleLatitude, SouthPoleLongitude] = rotated_latlon_projection_parameters(nco)
% Extract projection parameters for Rotated LatLon projection from the nco object

details = nco{'RotatedLatLon_Projection'};
details = details.attributes;

% Extract necessary values from the attributes
SouthPoleLatitude = cell2mat(details(strcmp({'grid_south_pole_latitude'}, details(:, 1)), 2));
SouthPoleLongitude = cell2mat(details(strcmp({'grid_south_pole_longitude'}, details(:, 1)), 2));
function [lon, lat] = convert_lambert_conformal(x, y, nco)
% Convert x and y coordinates to latitude and longitude using Lambert Conformal Conic projection

% Extract projection parameters for Lambert Conformal Conic projection
[OriginLatitude, OriginLongitude, FirstStandardParallel, SecondStandardParallel] = lambert_projection_parameters(nco);

% Constants
GRS80 = 6378137;
InverseFlattening = 298.2572221;
FalseNorthing = 0;
FalseEasting = 0;

% Compute parameters for the conversion
a = GRS80;
f = 1 / InverseFlattening;
phi1 = FirstStandardParallel * pi() / 180;
phi2 = SecondStandardParallel * pi() / 180;
phi0 = OriginLatitude * pi() / 180;
lambda0 = OriginLongitude * pi() / 180;
N0 = FalseNorthing;
E0 = FalseEasting;
e = sqrt(2 * f - f^2);

m1 = cos(phi1) / sqrt(1 - (e * sin(phi1))^2);
m2 = cos(phi2) / sqrt(1 - (e * sin(phi2))^2);
t0 = tan(pi() / 4 - phi0 / 2) / ((1 - e * sin(phi0)) / (1 + e * sin(phi0)))^(e / 2);
t1 = tan(pi() / 4 - phi1 / 2) / ((1 - e * sin(phi1)) / (1 + e * sin(phi1)))^(e / 2);
t2 = tan(pi() / 4 - phi2 / 2) / ((1 - e * sin(phi2)) / (1 + e * sin(phi2)))^(e / 2);

if phi1 ~= phi2
    n = (log(m1) - log(m2)) / (log(t1) - log(t2));
else
    n = sin(phi1);
end

Fcap = m1 / (n * t1^n);
rho0 = a * Fcap * t0^n;
Nprime = y * 1000 - N0;
Eprime = x * 1000 - E0;
rhoprime = sign(n) * sqrt(Eprime.^2 + (rho0 - Nprime).^2);
tprime = (rhoprime / (a * Fcap)).^(1 / n);
gammaprime = atan(Eprime ./ (rho0 - Nprime));
phiout = pi() / 2 - 2 * atan(tprime);

cnt = 1;
phiIN = phiout;
while (cnt < 10)
    phiOUT = pi() / 2 - 2 * atan(tprime .* ((1 - e * sin(phiIN)) ./ (1 + e * sin(phiIN))).^(e / 2));
    phiIN = phiOUT;
    cnt = cnt + 1;
end

phix = phiOUT;
lat = phix * 180 / pi();
lon = (gammaprime / n + lambda0) * 180 / pi();
function [lon, lat] = convert_rotated_latlon(x, y, nco)
% Convert x and y coordinates to latitude and longitude using Rotated LatLon projection

% Extract projection parameters for Rotated LatLon projection
[SouthPoleLatitude, SouthPoleLongitude] = rotated_latlon_projection_parameters(nco);

lon_r = x';
lat_r = y';
SAr = -sind(lon_r) .* cosd(lat_r);
CAr = cosd(SouthPoleLatitude) .* sind(lat_r) + sind(SouthPoleLatitude) .* cosd(lat_r) .* cosd(lon_r);
lon = atand(SAr ./ CAr) + SouthPoleLongitude;
SLr = -sind(SouthPoleLatitude) .* sind(lat_r) + cosd(SouthPoleLatitude) .* cosd(lat_r) .* cosd(lon_r);
lat = asind(SLr);
lon = lon';
lat = lat';
function change_names(~, ~, ~)
%% change names
CC3=evalin('base','CC3');
APCP=strcmp(CC3(:,4),'APCP');
CC3(APCP,4)={'Precipitation'};
APCP=strcmp(CC3(:,4),'VO');
CC3(APCP,4)={'Vorticity (ralative)'};
APCP=strcmp(CC3(:,4),'DZDT');
CC3(APCP,4)={'Vertical vel.(w)'};
APCP=strcmp(CC3(:,4),'REFC');
CC3(APCP,4)={'Max dBz'};
APCP=strcmp(CC3(:,4),'TCDC');
CC3(APCP,4)={'Clouds Total'};
APCP=strcmp(CC3(:,4),'VIS');
CC3(APCP,4)={'Visibility'};
APCP=strcmp(CC3(:,4),'RDSP3');
CC3(APCP,4)={'Cloud Base Height'};
APCP=strcmp(CC3(:,4),'WVSP2');
CC3(APCP,4)={'Max wind speed 10m'};
APCP=strcmp(CC3(:,4),'SP');
CC3(APCP,4)={'Surface Pressure'};
APCP=strcmp(CC3(:,4),'CC');
CC3(APCP,4)={'Cloud Cover'};
APCP=strcmp(CC3(:,4),'geomet h');
CC3(APCP,4)={'Height Level'};
APCP=strcmp(CC3(:,4),'TOT_PREC');
CC3(APCP,4)={'Precipitation'};
APCP=strcmp(CC3(:,4),'ACPCP');
CC3(APCP,4)={'Conv. Precipitation'};
APCP=strcmp(CC3(:,4),'Total precipitation [m]');
CC3(APCP,4)={'Precipitation'};
APCP=strcmp(CC3(:,4),'TP');
CC3(APCP,4)={'Precipitation'};
APCP=strcmp(CC3(:,4),'BRTMP');
CC3(APCP,4)={'MSG simulation'};
APCP=strcmp(CC3(:,4),'DPT');
CC3(APCP,4)={'Dew point T'};
APCP=strcmp(CC3(:,4),'HCDC');
CC3(APCP,4)={'Clouds High'};
APCP=strcmp(CC3(:,4),'MCDC');
CC3(APCP,4)={'Clouds Medium'};
APCP=strcmp(CC3(:,4),'LCDC');
CC3(APCP,4)={'Clouds Low'};
APCP=strcmp(CC3(:,4),'SPFH');
CC3(APCP,4)={'Specific Humidity'};
APCP=strcmp(CC3(:,4),'HCC');
CC3(APCP,4)={'Clouds High'};
APCP=strcmp(CC3(:,4),'MCC');
CC3(APCP,4)={'Clouds Medium'};
APCP=strcmp(CC3(:,4),'LCC');
CC3(APCP,4)={'Clouds Low'};
APCP=strcmp(CC3(:,4),'POT');
CC3(APCP,4)={'Potential T'};
APCP=strcmp(CC3(:,4),'RH');
CC3(APCP,4)={'Relative Humidity'};
APCP=strcmp(CC3(:,4),'TMP');
CC3(APCP,4)={'Temperature'};
APCP=strcmp(CC3(:,4),'PRMSL');
CC3(APCP,4)={'MSL Pressure'};
APCP=strcmp(CC3(:,4),'PRES');
CC3(APCP,4)={'Pressure'};
APCP=strcmp(CC3(:,4),'HLCY');
CC3(APCP,4)={'Helicity'};
APCP=strcmp(CC3(:,4),'REFD');
CC3(APCP,4)={'Simulated CAPPI'};
APCP=strcmp(CC3(:,4),'GUST');
CC3(APCP,4)={'Wind Gust'};
APCP=strcmp(CC3(:,4),'HGT');
CC3(APCP,4)={'Height Level'};
APCP=strcmp(CC3(:,4),'MSL');
CC3(APCP,4)={'MSL Pressure'};
APCP=strcmp(CC3(:,4),'T');
CC3(APCP,4)={'Temperature'};
APCP=strcmp(CC3(:,4),'U');
CC3(APCP,4)={'UGRD'};
APCP=strcmp(CC3(:,4),'10U');
CC3(APCP,4)={'UGRD'};
APCP=strcmp(CC3(:,4),'10V');
CC3(APCP,4)={'VGRD'};
APCP=strcmp(CC3(:,4),'V');
CC3(APCP,4)={'VGRD'};
APCP=strcmp(CC3(:,4),'W');
CC3(APCP,4)={'Vertical Velocity'};
APCP=strcmp(CC3(:,4),'R');
CC3(APCP,4)={'Relative Humidity'};
APCP=strcmp(CC3(:,4),'Z');
CC3(APCP,4)={'GeoDynamic Height'};
APCP=strcmp(CC3(:,4),'Height Level');
CC3(APCP,4)={'GeoDynamic Height'};
APCP=strcmp(CC3(:,4),'2T');
CC3(APCP,4)={'Temperature'};
APCP=strcmp(CC3(:,4),'2D');
CC3(APCP,4)={'Dew point T'};
APCP=strcmp(CC3(:,4),'SSTK');
CC3(APCP,4)={'Sea Surface Temperature'};
APCP=strcmp(CC3(:,4),'SKT');
CC3(APCP,4)={'Skin Temperature'};
APCP=strcmp(CC3(:,4),'PV');
CC3(APCP,4)={'Potential Vorticity'};
APCP=strcmp(CC3(:,4),'PT');
CC3(APCP,4)={'Potential Temperature'};
APCP=strcmp(CC3(:,4),'Q');
CC3(APCP,4)={'Specific Humidity'};
assignin('base','CC3',CC3);
function draw_first(~, eventdata, handles)
% load EU,GB,GR coords
S=evalin('base','S');
% view min max in boxes
data=evalin('base','data');
set(handles.edit1,'String',num2str(min(min(data))));drawnow;
set(handles.edit2,'String',num2str(max(max(data))));drawnow;
% try to read step
try
    STEP=evalin('base','STEP');
catch
end
% plot in pcol, cont, contf
hold on
cla(handles.axes1)
axes(handles.axes1);
data=evalin('base','data');
data=data(:,:,1);
lat=evalin('base','lat');
lon=evalin('base','lon');
PCOL=pcolor(lat,lon,data);
assignin('base','PCOL',PCOL);
popupmenu6_Callback(@popupmenu6_Callback, eventdata, handles);% for pcolor to be interp or flat or ...
colorbar;
EUPL=plot([S.X], [S.Y],'Color','black','LineWidth',0.5);
assignin('base','EUPL',EUPL);
% stations plot dots
Stations=read_stations('stations.xls');
Stations_LATLON=cell2mat(Stations(:,3:4));
Stations_NAME=Stations(:,1);
Stations_NUMBER=Stations(:,2);
LOC=Stations_NAME;
X=Stations_LATLON(:,1);
Y=Stations_LATLON(:,2);
Z=zeros(size(X));
sszz=str2num(get(handles.edit10,'String'));
STPL=scatter(X,Y,sszz,'black','filled');
assignin('base','STPL',STPL);
%% stations plot text
for i=1:numel(X)
    Cha{i,1}=strcat({'   '},char(LOC{i,1}));
end
sz=str2num(get(handles.edit11,'String'));
STNM=text(X,Y,Cha,'HorizontalAlignment','left','FontSize',sz);
set (STNM, 'Clipping', 'on');
assignin('base','STNM',STNM);
set(handles.checkbox5,'Value',1)
set(handles.checkbox6,'Value',1)
% winds first all zero
data_v=data;
data_u=data;
data_v(:,:)=0;
data_u(:,:)=0;
assignin('base','data_u',data_u);
assignin('base','data_v',data_v);
hold off
edit19_Callback(@edit19_Callback, eventdata, handles)
popupmenu4_Callback(@popupmenu4_Callback, eventdata, handles)
