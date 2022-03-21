function varargout = Streaming_Server_Performance(varargin)
% STREAMING_SERVER_PERFORMANCE MATLAB code for Streaming_Server_Performance.fig
%      STREAMING_SERVER_PERFORMANCE, by itself, creates a new STREAMING_SERVER_PERFORMANCE or raises the existing
%      singleton*.
%
%      H = STREAMING_SERVER_PERFORMANCE returns the handle to a new STREAMING_SERVER_PERFORMANCE or the handle to
%      the existing singleton*.
%
%      STREAMING_SERVER_PERFORMANCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STREAMING_SERVER_PERFORMANCE.M with the given input arguments.
%
%      STREAMING_SERVER_PERFORMANCE('Property','Value',...) creates a new STREAMING_SERVER_PERFORMANCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Streaming_Server_Performance_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Streaming_Server_Performance_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

% 赛尔网络下一代互联网技术创新项目(NGII20180502)

% Modified by hankun,zhangwensheng,chenpeiying v1.0 1-Mar-2022 10:23:12
% Last Modified by hankun,zhangwensheng,chenpeiying v1.0 15-Mar-2022 10:54:12


% 初始化
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Streaming_Server_Performance_OpeningFcn, ...
                   'gui_OutputFcn',  @Streaming_Server_Performance_OutputFcn, ...
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

% --- Executes just before Streaming_Server_Performance is made visible.
function Streaming_Server_Performance_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Streaming_Server_Performance (see VARARGIN)

% Choose default command line output for Streaming_Server_Performance
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Streaming_Server_Performance wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Streaming_Server_Performance_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_test_index_ipv4.
function pushbutton_test_index_ipv4_Callback(hObject, eventdata, handles)
% function pushbutton_genMp3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_index_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% filename=handles.filename;

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R, 'value'));
disp(test_R);
tR=num2str(test_R);
disp(tR);

url=get(handles.edit_url_index_ipv4,'String');
disp(url);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
String a=textread('a.txt','%s');

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='nginx';
outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.listbox_test_index_ipv4,'String',a);
set(handles.edit_qps_index_ipv4,'String',a(35,1));
% guidata(hObject, handles);


% --- Executes on button press in pushbutton_mp3_play.
function pushbutton_mp3_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_mp3_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.mp3'];
file_out2=[filename,'_mp3.wav'];
str_cmd=['ffplay ',file_out1];
system(str_cmd);   


% --- Executes on button press in pushbutton_test_index_ipv6.
function pushbutton_test_index_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_index_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R, 'value'));
disp(test_R);
tR=num2str(test_R);
disp(tR);

url=get(handles.edit_url_index_ipv4,'String');
disp(url);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
String a=textread('a.txt','%s');

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='nginx';
outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.listbox_test_index_ipv6,'String',a);
set(handles.edit_qps_index_ipv6,'String',a(35,1));
% guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_test_index_ipv4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_test_index_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_test_all.
function pushbutton_test_all_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 固定t c d url,R循环写入csv

outfile='./out/result_qps_testall.csv';
if exist(string(outfile),'file')
    disp(['Error. \n This file already exists: ',string(outfile)]);
else
    mkdir('./out');
    newCell_title={'flag','url',...
        't','c','d','R','R_result'};
    disp(newCell_title);
    newTable = cell2table(newCell_title);
    disp(newTable)
    writetable(newTable,outfile);
end

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

% Rs = [1000 5000 15000 20000 25000 30000];
% test_R = Rs(get(handles.popupmenu_R, 'value'));
% disp(test_R);
% tR=num2str(test_R);
% disp(tR);

num=get(handles.popupmenu_url, 'value');
disp(num);
if num==1
    url='http://42.247.39.61/index.html';
elseif num==2
    url='http://[2001:DA8:D80C::a]/index.html';
elseif num==3
    url='http://42.247.39.61/media/voice1_male.mp3';
elseif num==4
    url='http://[2001:DA8:D80C::a]/media/voice1_male.mp3';
elseif num==5
    url='http://42.247.39.61/media/image3_screen_woman.jpeg';
elseif num==6
    url='http://[2001:DA8:D80C::a]/media/image3_screen_woman.jpeg';
elseif num==7
    url='http://42.247.39.61/media/video2_50k_r15.mp4';
elseif num==8
    url='http://[2001:DA8:D80C::a]/media/video2_50k_r15.mp4';
else
    url='http://42.247.39.61/index.html';
end
disp(url);

for ii=1:5
    
Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R, ii));
disp(test_R);
tR=num2str(test_R);
disp(tR);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
a=textread('a.txt','%s');
disp(a);

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='nginx';
% outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据',ii,'写入完成。');

set(handles.listbox_test,'String',a);
set(handles.edit_qps,'String',a(35,1));

end
% handles.outfile=outfile;
% guidata(hObject, handles);


% --- Executes on button press in pushbutton_play_url_media.
function pushbutton_play_url_media_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_play_url_media (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

num=get(handles.popupmenu_url, 'value');
disp(num);
if num==1
    url='http://42.247.39.61/index.html';
elseif num==2
    url='http://[2001:DA8:D80C::a]/index.html';
elseif num==3
    url='http://42.247.39.61/media/voice1_male.mp3';
elseif num==4
    url='http://[2001:DA8:D80C::a]/media/voice1_male.mp3';
elseif num==5
    url='http://42.247.39.61/media/image3_screen_woman.jpeg';
elseif num==6
    url='http://[2001:DA8:D80C::a]/media/image3_screen_woman.jpeg';
elseif num==7
    url='http://42.247.39.61/media/video2_50k_r15.mp4';
elseif num==8
    url='http://[2001:DA8:D80C::a]/media/video2_50k_r15.mp4';
else
    url='http://42.247.39.61/index.html';
end
disp(url);

% videofile=[url];
% % handles.fileLoaded = 1;
% v = VideoReader(videofile);
% disp(v.FrameRate);
% disp(v);
% currAxes = handles.axes_signal;
% while hasFrame(v)
%     vidFrame = readFrame(v);
%     image(vidFrame, 'Parent', currAxes);
%     currAxes.Visible = 'off';
%     pause(1/v.FrameRate);
% end

% if mp3:
% axes(handles.axes_signal);
% handles.Time = 0:1/Fs:(length(handles.x)-1)/Fs;
% plot(handles.Time, handles.x);
% axis([0 max(handles.Time) -1 1]);
% xlabel('Time (s)')
% ylabel('Magnitude')
% 
% if image:
%     axes(handles.axes_signal);
% imshow(image1);

% if video:
%     axes(handles.axes_signal);
%     implay(url);
   
% axes(handles.axes_signal);
url_file=url;
str_cmd=['ffplay ',url_file];
system(str_cmd); 


% --- Executes on button press in pushbutton_test.
function pushbutton_test_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

outfile='./out/result_qps.csv';
if exist(string(outfile),'file')
    disp(['Error. \n This file already exists: ',string(outfile)]);
else
    mkdir('./out');
    newCell_title={'flag','url',...
        't','c','d','R','R_result'};
    disp(newCell_title);
    newTable = cell2table(newCell_title);
    disp(newTable)
    writetable(newTable,outfile);
end

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R, 'value'));
disp(test_R);
tR=num2str(test_R);
disp(tR);

num=get(handles.popupmenu_url, 'value');
disp(num);
if num==1
    url='http://42.247.39.61/index.html';
elseif num==2
    url='http://[2001:DA8:D80C::a]/index.html';
elseif num==3
    url='http://42.247.39.61/media/voice1_male.mp3';
elseif num==4
    url='http://[2001:DA8:D80C::a]/media/voice1_male.mp3';
elseif num==5
    url='http://42.247.39.61/media/image3_screen_woman.jpeg';
elseif num==6
    url='http://[2001:DA8:D80C::a]/media/image3_screen_woman.jpeg';
elseif num==7
    url='http://42.247.39.61/media/video2_50k_r15.mp4';
elseif num==8
    url='http://[2001:DA8:D80C::a]/media/video2_50k_r15.mp4';
else
    url='http://42.247.39.61/index.html';
end
disp(url);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
a=textread('a.txt','%s');
disp(a);

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='nginx';
% outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.listbox_test,'String',a);
set(handles.edit_qps,'String',a(35,1));
handles.outfile=outfile;
guidata(hObject, handles);


% --- Executes on selection change in popupmenu_t.
function popupmenu_t_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_t contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_t


% --- Executes during object creation, after setting all properties.
function popupmenu_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_c.
function popupmenu_c_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_c contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_c


% --- Executes during object creation, after setting all properties.
function popupmenu_c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_d.
function popupmenu_d_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_d contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_d


% --- Executes during object creation, after setting all properties.
function popupmenu_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_R.
function popupmenu_R_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_R contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_R


% --- Executes during object creation, after setting all properties.
function popupmenu_R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_test_index_ipv4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_test_index_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_test_index_ipv4 as text
%        str2double(get(hObject,'String')) returns contents of edit_test_index_ipv4 as a double



function edit_url_index_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_index_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_index_ipv6 as text
%        str2double(get(hObject,'String')) returns contents of edit_url_index_ipv6 as a double


% --- Executes during object creation, after setting all properties.
function edit_url_index_ipv6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_index_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_url_index_ipv4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_index_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_index_ipv4 as text
%        str2double(get(hObject,'String')) returns contents of edit_url_index_ipv4 as a double


% --- Executes during object creation, after setting all properties.
function edit_url_index_ipv4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_index_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_test_media_ipv4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_test_media_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_test_media_ipv4 as text
%        str2double(get(hObject,'String')) returns contents of edit_test_media_ipv4 as a double


% --- Executes during object creation, after setting all properties.
function edit_test_media_ipv4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_test_media_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_url_media_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_media_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_media_ipv6 as text
%        str2double(get(hObject,'String')) returns contents of edit_url_media_ipv6 as a double


% --- Executes during object creation, after setting all properties.
function edit_url_media_ipv6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_media_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_url_media_ipv4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_media_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_media_ipv4 as text
%        str2double(get(hObject,'String')) returns contents of edit_url_media_ipv4 as a double


% --- Executes during object creation, after setting all properties.
function edit_url_media_ipv4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_media_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_test_media_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_test_media_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_test_media_ipv6 as text
%        str2double(get(hObject,'String')) returns contents of edit_test_media_ipv6 as a double


% --- Executes during object creation, after setting all properties.
function edit_test_media_ipv6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_test_media_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_test_media_ipv4.
function pushbutton_test_media_ipv4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_media_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R, 'value'));
disp(test_R);
tR=num2str(test_R);
disp(tR);

url=get(handles.edit_url_index_ipv4,'String');
disp(url);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
String a=textread('a.txt','%s');

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='nginx';
outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.listbox_test_media_ipv4,'String',a);
set(handles.edit_qps_media_ipv4,'String',a(35,1));
% guidata(hObject, handles);


function edit_test_index_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_test_index_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_test_index_ipv6 as text
%        str2double(get(hObject,'String')) returns contents of edit_test_index_ipv6 as a double


% --- Executes during object creation, after setting all properties.
function edit_test_index_ipv6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_test_index_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_test_media_ipv6.
function pushbutton_test_media_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_media_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R, 'value'));
disp(test_R);
tR=num2str(test_R);
disp(tR);

url=get(handles.edit_url_index_ipv4,'String');
disp(url);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
String a=textread('a.txt','%s');

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='nginx';
outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.listbox_test_media_ipv6,'String',a);
set(handles.edit_qps_media_ipv6,'String',a(35,1));
% guidata(hObject, handles);


% --- Executes on selection change in popupmenu_url.
function popupmenu_url_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_url (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_url contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_url


% --- Executes during object creation, after setting all properties.
function popupmenu_url_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_url (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on pushbutton_test_index_ipv6 and none of its controls.
function pushbutton_test_index_ipv6_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_index_ipv6 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


function edit_url_media_ipv6_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_media_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_media_ipv6_dpdk as text
%        str2double(get(hObject,'String')) returns contents of edit_url_media_ipv6_dpdk as a double


% --- Executes during object creation, after setting all properties.
function edit_url_media_ipv6_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_media_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_url_medai_ipv4_dpdp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_medai_ipv4_dpdp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_medai_ipv4_dpdp as text
%        str2double(get(hObject,'String')) returns contents of edit_url_medai_ipv4_dpdp as a double


% --- Executes during object creation, after setting all properties.
function edit_url_medai_ipv4_dpdp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_medai_ipv4_dpdp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_test_media_ipv4_dpdk.
function pushbutton_test_media_ipv4_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_media_ipv4_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t_dpdk, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c_dpdk, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d_dpdk, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R_dpdk, 'value'));
disp(test_R);
tR=num2str(test_R);
disp(tR);

url=get(handles.edit_url_index_ipv4_dpdk,'String');
disp(url);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
String a=textread('a.txt','%s');

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='dpdk-nginx';
outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.listbox_test_media_ipv4_dpdk,'String',a);
set(handles.edit_qps_media_ipv4_dpdk,'String',a(35,1));
% guidata(hObject, handles);


% --- Executes on button press in pushbutton_test_media_ipv6_dpdk.
function pushbutton_test_media_ipv6_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_media_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t_dpdk, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c_dpdk, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d_dpdk, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R_dpdk, 'value'));
disp(test_R);
tR=num2str(test_R);
disp(tR);

url=get(handles.edit_url_index_ipv4_dpdk,'String');
disp(url);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
String a=textread('a.txt','%s');

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='dpdk-nginx';
outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.listbox_test_media_ipv6_dpdk,'String',a);
set(handles.edit_qps_media_ipv6_dpdk,'String',a(35,1));
% guidata(hObject, handles);


% --- Executes on button press in pushbutton_test_all_dpdk.
function pushbutton_test_all_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_all_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 固定t c d url,R循环写入csv

outfile='./out/result_qps_testall.csv';
if exist(string(outfile),'file')
    disp(['Error. \n This file already exists: ',string(outfile)]);
else
    mkdir('./out');
    newCell_title={'flag','url',...
        't','c','d','R','R_result'};
    disp(newCell_title);
    newTable = cell2table(newCell_title);
    disp(newTable)
    writetable(newTable,outfile);
end

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t_dpdk, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c_dpdk, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d_dpdk, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

% Rs = [1000 5000 15000 20000 25000 30000];
% test_R = Rs(get(handles.popupmenu_R, 'value'));
% disp(test_R);
% tR=num2str(test_R);
% disp(tR);

num=get(handles.popupmenu_url_dpdk, 'value');
disp(num);
if num==1
    url='http://42.247.39.61/index.html';
elseif num==2
    url='http://[2001:DA8:D80C::a]/index.html';
elseif num==3
    url='http://42.247.39.61/media/voice1_male.mp3';
elseif num==4
    url='http://[2001:DA8:D80C::a]/media/voice1_male.mp3';
elseif num==5
    url='http://42.247.39.61/media/image3_screen_woman.jpeg';
elseif num==6
    url='http://[2001:DA8:D80C::a]/media/image3_screen_woman.jpeg';
elseif num==7
    url='http://42.247.39.61/media/video2_50k_r15.mp4';
elseif num==8
    url='http://[2001:DA8:D80C::a]/media/video2_50k_r15.mp4';
else
    url='http://42.247.39.61/index.html';
end
disp(url);

for ii=1:5
    
Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R_dpdk, ii));
disp(test_R);
tR=num2str(test_R);
disp(tR);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
a=textread('a.txt','%s');
disp(a);

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='dpdk-nginx';
% outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据',ii,'写入完成。');

set(handles.listbox_test_dpdk,'String',a);
set(handles.edit_qps_dpdk,'String',a(35,1));

end
% handles.outfile=outfile;
% guidata(hObject, handles);


% --- Executes on button press in pushbutton_play_url_meida_dpdk.
function pushbutton_play_url_meida_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_play_url_meida_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

num=get(handles.popupmenu_url_dpdk, 'value');
disp(num);
if num==1
    url='http://42.247.39.61/index.html';
elseif num==2
    url='http://[2001:DA8:D80C::a]/index.html';
elseif num==3
    url='http://42.247.39.61/media/voice1_male.mp3';
elseif num==4
    url='http://[2001:DA8:D80C::a]/media/voice1_male.mp3';
elseif num==5
    url='http://42.247.39.61/media/image3_screen_woman.jpeg';
elseif num==6
    url='http://[2001:DA8:D80C::a]/media/image3_screen_woman.jpeg';
elseif num==7
    url='http://42.247.39.61/media/video2_50k_r15.mp4';
elseif num==8
    url='http://[2001:DA8:D80C::a]/media/video2_50k_r15.mp4';
else
    url='http://42.247.39.61/index.html';
end
disp(url);

% videofile=[url];
% % handles.fileLoaded = 1;
% v = VideoReader(videofile);
% disp(v.FrameRate);
% disp(v);
% currAxes = handles.axes_signal;
% while hasFrame(v)
%     vidFrame = readFrame(v);
%     image(vidFrame, 'Parent', currAxes);
%     currAxes.Visible = 'off';
%     pause(1/v.FrameRate);
% end

% if mp3:
% axes(handles.axes_signal);
% handles.Time = 0:1/Fs:(length(handles.x)-1)/Fs;
% plot(handles.Time, handles.x);
% axis([0 max(handles.Time) -1 1]);
% xlabel('Time (s)')
% ylabel('Magnitude')
% 
% if image:
%     axes(handles.axes_signal);
% imshow(image1);

% if video:
%     axes(handles.axes_signal);
%     implay(url);
   
% axes(handles.axes_signal);
url_file=url;
str_cmd=['ffplay ',url_file];
system(str_cmd); 


% --- Executes on button press in pushbutton_test_dpdk_nginx.
function pushbutton_test_dpdk_nginx_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

outfile='./out/result_qps.csv';
if exist(string(outfile),'file')
    disp(['Error. \n This file already exists: ',string(outfile)]);
else
    mkdir('./out');
    newCell_title={'flag','url',...
        't','c','d','R','R_result'};
    disp(newCell_title);
    newTable = cell2table(newCell_title);
    disp(newTable)
    writetable(newTable,outfile);
end

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t_dpdk, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c_dpdk, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d_dpdk, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R_dpdk, 'value'));
disp(test_R);
tR=num2str(test_R);
disp(tR);

num=get(handles.popupmenu_url_dpdk, 'value');
disp(num);
if num==1
    url='http://42.247.39.61/index.html';
elseif num==2
    url='http://[2001:DA8:D80C::a]/index.html';
elseif num==3
    url='http://42.247.39.61/media/voice1_male.mp3';
elseif num==4
    url='http://[2001:DA8:D80C::a]/media/voice1_male.mp3';
elseif num==5
    url='http://42.247.39.61/media/image3_screen_woman.jpeg';
elseif num==6
    url='http://[2001:DA8:D80C::a]/media/image3_screen_woman.jpeg';
elseif num==7
    url='http://42.247.39.61/media/video2_50k_r15.mp4';
elseif num==8
    url='http://[2001:DA8:D80C::a]/media/video2_50k_r15.mp4';
else
    url='http://42.247.39.61/index.html';
end
disp(url);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
a=textread('a.txt','%s');
disp(a);

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='dpdk-nginx';
% outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.listbox_test_dpdk,'String',a);
set(handles.edit_qps_dpdk,'String',a(35,1));
handles.outfile=outfile;
guidata(hObject, handles);




% --- Executes on selection change in popupmenu_t_dpdk.
function popupmenu_t_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_t_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_t_dpdk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_t_dpdk


% --- Executes during object creation, after setting all properties.
function popupmenu_t_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_t_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_c_dpdk.
function popupmenu_c_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_c_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_c_dpdk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_c_dpdk


% --- Executes during object creation, after setting all properties.
function popupmenu_c_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_c_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_d_dpdk.
function popupmenu_d_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_d_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_d_dpdk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_d_dpdk


% --- Executes during object creation, after setting all properties.
function popupmenu_d_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_d_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_R_dpdk.
function popupmenu_R_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_R_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_R_dpdk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_R_dpdk


% --- Executes during object creation, after setting all properties.
function popupmenu_R_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_R_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_url_dpdk.
function popupmenu_url_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_url_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_url_dpdk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_url_dpdk


% --- Executes during object creation, after setting all properties.
function popupmenu_url_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_url_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_test_index_ipv4_dpdk.
function pushbutton_test_index_ipv4_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_index_ipv4_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t_dpdk, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c_dpdk, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d_dpdk, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R_dpdk, 'value'));
disp(test_R);
tR=num2str(test_R);
disp(tR);

url=get(handles.edit_url_index_ipv4_dpdk,'String');
disp(url);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
String a=textread('a.txt','%s');

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='dpdk-nginx';
outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.listbox_test_index_ipv4_dpdk,'String',a);
set(handles.edit_qps_index_ipv4_dpdk,'String',a(35,1));
% guidata(hObject, handles);


% --- Executes on button press in pushbutton_test_index_ipv6_dpdk.
function pushbutton_test_index_ipv6_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_index_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ts = [2 4 8 16];
test_t = ts(get(handles.popupmenu_t_dpdk, 'value'));
disp(test_t);
tt=num2str(test_t);
disp(tt);

num=get(handles.popupmenu_c_dpdk, 'value');
disp(num);
if num==1
    test_c='16';
elseif num==2
    test_c='100';
elseif num==3
    test_c='1k';
elseif num==4
    test_c='10k';
else
    test_c='16';
end
disp(test_c);
tc=num2str(test_c);
disp(tc);

num=get(handles.popupmenu_d_dpdk, 'value');
disp(num);
if num==1
    test_d='1s';
elseif num==2
    test_d='12s';
elseif num==3
    test_d='30s';
else
    test_d='1s';
end
disp(test_d);
td=num2str(test_d);
disp(td);

Rs = [1000 5000 15000 20000 25000 30000];
test_R = Rs(get(handles.popupmenu_R_dpdk, 'value'));
disp(test_R);
tR=num2str(test_R);
disp(tR);

url=get(handles.edit_url_index_ipv4_dpdk,'String');
disp(url);

str_out= ['./wrk ',' -t',tt,' -c',tc,' -d',td,' -R',tR,' ',url,' >a.txt'];
system(str_out);
String a=textread('a.txt','%s');

% 存入文件
% url,t,c,d,R,R_result
% nginx,
flag='dpdk-nginx';
outfile=handles.outfile;
newCell_title={'flag','url',...
    't','c','d','R','R_result'};
 
newCell_zhi={flag,url,...
            tt,tc,td,tR,a(35,1)};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.listbox_test_index_ipv6_dpdk,'String',a);
set(handles.edit_qps_index_ipv6_dpdk,'String',a(35,1));
% guidata(hObject, handles);


function edit_url_index_ipv6_dpdp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_index_ipv6_dpdp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_index_ipv6_dpdp as text
%        str2double(get(hObject,'String')) returns contents of edit_url_index_ipv6_dpdp as a double


% --- Executes during object creation, after setting all properties.
function edit_url_index_ipv6_dpdp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_index_ipv6_dpdp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_url_index_ipv4_dpdp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_index_ipv4_dpdp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_index_ipv4_dpdp as text
%        str2double(get(hObject,'String')) returns contents of edit_url_index_ipv4_dpdp as a double


% --- Executes during object creation, after setting all properties.
function edit_url_index_ipv4_dpdp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_index_ipv4_dpdp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_qps_index_ipv4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps_index_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps_index_ipv4 as text
%        str2double(get(hObject,'String')) returns contents of edit_qps_index_ipv4 as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_index_ipv4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps_index_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_qps_media_ipv4_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps_media_ipv4_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps_media_ipv4_dpdk as text
%        str2double(get(hObject,'String')) returns contents of edit_qps_media_ipv4_dpdk as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_media_ipv4_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps_media_ipv4_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_qps_media_ipv6_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps_media_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps_media_ipv6_dpdk as text
%        str2double(get(hObject,'String')) returns contents of edit_qps_media_ipv6_dpdk as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_media_ipv6_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps_media_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_qps_index_ipv4_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps_index_ipv4_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps_index_ipv4_dpdk as text
%        str2double(get(hObject,'String')) returns contents of edit_qps_index_ipv4_dpdk as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_index_ipv4_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps_index_ipv4_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_qps_index_ipv6_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps_index_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps_index_ipv6_dpdk as text
%        str2double(get(hObject,'String')) returns contents of edit_qps_index_ipv6_dpdk as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_index_ipv6_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps_index_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_qps_meida_ipv4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps_meida_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps_meida_ipv4 as text
%        str2double(get(hObject,'String')) returns contents of edit_qps_meida_ipv4 as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_meida_ipv4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps_meida_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_qps_media_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps_media_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps_media_ipv6 as text
%        str2double(get(hObject,'String')) returns contents of edit_qps_media_ipv6 as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_media_ipv6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps_media_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_qps_index_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps_index_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps_index_ipv6 as text
%        str2double(get(hObject,'String')) returns contents of edit_qps_index_ipv6 as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_index_ipv6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps_index_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_qps_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps_dpdk as text
%        str2double(get(hObject,'String')) returns contents of edit_qps_dpdk as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_qps_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps as text
%        str2double(get(hObject,'String')) returns contents of edit_qps as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_test_index_ipv4.
function listbox_test_index_ipv4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_test_index_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_test_index_ipv4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_test_index_ipv4


% --- Executes during object creation, after setting all properties.
function listbox_test_index_ipv4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_test_index_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_test_index_ipv6.
function listbox_test_index_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_test_index_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_test_index_ipv6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_test_index_ipv6


% --- Executes during object creation, after setting all properties.
function listbox_test_index_ipv6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_test_index_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_test_media_ipv4.
function listbox_test_media_ipv4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_test_media_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_test_media_ipv4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_test_media_ipv4


% --- Executes during object creation, after setting all properties.
function listbox_test_media_ipv4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_test_media_ipv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_test_meida_ipv6.
function listbox_test_meida_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_test_meida_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_test_meida_ipv6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_test_meida_ipv6


% --- Executes during object creation, after setting all properties.
function listbox_test_meida_ipv6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_test_meida_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_media_ipv4_dpdk.
function listbox_media_ipv4_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_media_ipv4_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_media_ipv4_dpdk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_media_ipv4_dpdk


% --- Executes during object creation, after setting all properties.
function listbox_media_ipv4_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_media_ipv4_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_test_media_ipv6_dpdk.
function listbox_test_media_ipv6_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_test_media_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_test_media_ipv6_dpdk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_test_media_ipv6_dpdk


% --- Executes during object creation, after setting all properties.
function listbox_test_media_ipv6_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_test_media_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_test_index_ipv4_dpdk.
function listbox_test_index_ipv4_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_test_index_ipv4_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_test_index_ipv4_dpdk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_test_index_ipv4_dpdk


% --- Executes during object creation, after setting all properties.
function listbox_test_index_ipv4_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_test_index_ipv4_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_test_index_ipv6_dpdk.
function listbox_test_index_ipv6_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_test_index_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_test_index_ipv6_dpdk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_test_index_ipv6_dpdk


% --- Executes during object creation, after setting all properties.
function listbox_test_index_ipv6_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_test_index_ipv6_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_test_dpdk.
function listbox_test_dpdk_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_test_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_test_dpdk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_test_dpdk


% --- Executes during object creation, after setting all properties.
function listbox_test_dpdk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_test_dpdk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_test.
function listbox_test_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_test contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_test


% --- Executes during object creation, after setting all properties.
function listbox_test_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

