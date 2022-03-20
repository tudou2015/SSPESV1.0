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


% --- Executes on button press in pushbutton_wav_load.
function pushbutton_wav_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_wav_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile({'*.wav'},'Load Wav File');
[x,Fs] = audioread([PathName '/' FileName]);
x = x(:,1);
handles.x = x ./ max(abs(x));
handles.Fs = Fs;
axes(handles.axes_signal);
handles.Time = 0:1/Fs:(length(handles.x)-1)/Fs;
plot(handles.Time, handles.x);
axis([0 max(handles.Time) -1 1]);
xlabel('Time (s)')
ylabel('Magnitude')

axes(handles.axes_signalSpec);
Fn = handles.Fs/2;
Fy = fft(handles.x)/length(handles.x);
Fv = linspace(0, 1, fix(length(handles.x)/2) + 1)*Fn;
Iv = 1:length(Fv);
plot(Fv, abs(Fy(Iv,1))*2)
xlabel('Frequency (Hz)')
ylabel('Magnitude')

filename=FileName(1:end-4);
file_in=[filename,'.wav'];
file_out_8k=[filename,'_8k.wav'];
str_cmd_8k=['ffmpeg -i ',file_in,' -ac 1 -ar 8k ',file_out_8k];
system(str_cmd_8k);   

outfile='./out/result_fs16k.csv';
if exist(string(outfile),'file')
    disp(['Error. \n This file already exists: ',string(outfile)]);
else
    mkdir('./out');
    newCell_title={'filename','codec',...
        'filesiez','fs','mse','psnr','mHFDde','mHFDde_wav'};
    disp(newCell_title);
    newTable = cell2table(newCell_title);
    disp(newTable)
    writetable(newTable,outfile);
end

handles.filename_fs16k_outfile=outfile;
handles.fileLoaded = 1;
handles.filename=filename;
handles.PathName=PathName;
handles.FileName=FileName;
guidata(hObject, handles);


% --- Executes on button press in pushbutton_playSignal.
function pushbutton_playSignal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_playSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoaded==1)
    sound(handles.x, handles.Fs);
end


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
set(handles.listbox_test_index_ipv4,'String',a);
set(handles.edit_qps_index_ipv4,'String',a(35,1));

% handles.mHFDde_wav=m_HFD_de;
guidata(hObject, handles);


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


% --- Executes on button press in pushbutton_acc_generate.
function pushbutton_acc_generate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_acc_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.aac'];
file_out2=[filename,'_aac.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 16k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 16k ',file_out2];
system(str_cmd1);    
system(str_cmd2);


function edit_aac_mse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_mse as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_mse as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_mse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_aac_psnr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_psnr as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_psnr as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_psnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_test_index_ipv6.
function pushbutton_test_index_ipv6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_index_ipv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.mp3'];
file_out2=[filename,'_mp3.wav'];

[y1,fs1]=audioread(file_in);
[y2,fs2]=audioread(file_out2);
y1=y1(:,1);
y2=y2(:,1);
[c1x,c1y]=size(y1);
[c2x,c2y]=size(y2);
disp(['c1x=' num2str(c1x) ]);
disp(['c2x=' num2str(c2x) ]);
deltx=(c2x-c1x)/2;
y2=y2((deltx+1):(c2x-deltx),:);
[c2x,c2y]=size(y2);
disp(['c2x=' num2str(c2x) ]);
disp(['c1y=' num2str(c1y) ]);
disp(['c2y=' num2str(c2y) ]);
R=c1x;
C=c1y;
err = sum((y1-y2).^2)/(R*C);
mse=sqrt(err);
disp(['MSE=' num2str(mse) ]);
MAXVAL=65535;
psnr = 20*log10(MAXVAL/mse); 
disp(['PSNR=' num2str(psnr)]);

% fprintf('testing narrowband.\n');
% % pesq=pesq_mex(y1, y2, fs1, 'narrowband');
% pesq=PESQ_MEX(y1, y2, fs1, 'narrowband');
% set(handles.edit_mp3_pesq,'string',pesq);
% disp(pesq);

% fprintf('testing ssnr.\n');
% ssnr = segsnr( y1, y2, fs1 );
% set(handles.edit_mp3_segSNR,'string',ssnr);
% disp(ssnr);

% ssim
% audioIn = audioIn./max(abs(audioIn));
% sound(audioIn,fs)
% S = melSpectrogram(audioIn,fs)

% mHFDde
if ~exist(string(file_out2),'file')
    disp(['Error. \n No this file: ',string(file_out2)]);
else
    [x fs]=audioread(file_out2);
    tt=length(x)/fs;
    start_time = 0;
    end_time = tt;
    sig=x((fs*start_time+1):fs*end_time);
    xx=double(sig);
    
    win=1600;step=800;
    xx_left=[0,0,0,0,0,0,0,0]';
    xx_0=[xx_left;xx(1:end-8)];
    xx_1=xx;
    xx_2=[xx(9:end);xx_left];

    [HBH_de_0]=FD_HBH(xx_0,win,step);
    [HBH_de_1]=FD_HBH(xx_1,win,step);
    [HBH_de_2]=FD_HBH(xx_2,win,step);
    HBH1600800de=(HBH_de_0+HBH_de_1+HBH_de_2)/3;
    HBH1600800de_mean=mean(HBH1600800de);
    
mHFDde=HBH1600800de_mean;
disp(mHFDde);

% 编码方式
codec='mp3';
% 计算文件大小
[fid,errmsg]=fopen(file_out1);
disp(errmsg);
fseek(fid,0,'eof');
filesize = ftell(fid); 
disp(filesize);
% 参考值
mHFDde_wav=handles.mHFDde_wav;
% 存入文件
% codec,fs,vr,mse,psnr,ssim
% mp3,
outfile=handles.filename_fs16k_outfile;
newCell_title={'filename','codec',...
    'filesize','fs','mse','psnr','mHFDde','mHFDde_wav'};
 
newCell_zhi={filename,codec,...
            filesize,fs,mse,psnr,mHFDde,mHFDde_wav};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.edit_mp3_mse,'string',mse);
set(handles.edit_mp3_psnr,'string',psnr);
set(handles.edit_mp3_mHFD,'string',mHFDde);

end


function edit_mp3_mse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_mse as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_mse as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_mse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_mp3_psnr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_psnr as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_psnr as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_psnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_flac_8k_mHFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_flac_8k_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_ogg_8k_ssim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_ssim (see GCBO) 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_ogg_8k_mHFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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


% --- Executes on button press in pushbutton_aac_calculate.
function pushbutton_aac_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_aac_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.aac'];
file_out2=[filename,'_aac.wav'];

[y1,fs1]=audioread(file_in);
[y2,fs2]=audioread(file_out2);
y1=y1(:,1);
y2=y2(:,1);
[c1x,c1y]=size(y1);
[c2x,c2y]=size(y2);
disp(['c1x=' num2str(c1x) ]);
disp(['c2x=' num2str(c2x) ]);
deltx=(c2x-c1x)/2;
y2=y2((deltx+1):(c2x-deltx),:);
[c2x,c2y]=size(y2);
disp(['c2x=' num2str(c2x) ]);
disp(['c1y=' num2str(c1y) ]);
disp(['c2y=' num2str(c2y) ]);
R=c1x;
C=c1y;
err = sum((y1-y2).^2)/(R*C);
mse=sqrt(err);
disp(['MSE=' num2str(mse) ]);
MAXVAL=65535;
psnr = 20*log10(MAXVAL/mse); 
disp(['PSNR=' num2str(psnr)]);

% fprintf('testing narrowband.\n');
% % pesq=pesq_mex(y1, y2, fs1, 'narrowband');
% pesq=PESQ_MEX(y1, y2, fs1, 'narrowband');
% set(handles.edit_mp3_pesq,'string',pesq);
% disp(pesq);

% fprintf('testing ssnr.\n');
% ssnr = segsnr( y1, y2, fs1 );
% set(handles.edit_aac_segSNR,'string',ssnr);
% disp(ssnr);

%ssim
% audioIn = audioIn./max(abs(audioIn));
% sound(audioIn,fs)
% S = melSpectrogram(audioIn,fs)

% mHFD
if ~exist(string(file_out2),'file')
    disp(['Error. \n No this file: ',string(file_out2)]);
else
    [x fs]=audioread(file_out2);
    tt=length(x)/fs;
    start_time = 0;
    end_time = tt;
    sig=x((fs*start_time+1):fs*end_time);
    xx=double(sig);
    
    win=1600;step=800;
    xx_left=[0,0,0,0,0,0,0,0]';
    xx_0=[xx_left;xx(1:end-8)];
    xx_1=xx;
    xx_2=[xx(9:end);xx_left];

    [HBH_de_0]=FD_HBH(xx_0,win,step);
    [HBH_de_1]=FD_HBH(xx_1,win,step);
    [HBH_de_2]=FD_HBH(xx_2,win,step);
    HBH1600800de=(HBH_de_0+HBH_de_1+HBH_de_2)/3;
    HBH1600800de_mean=mean(HBH1600800de);
    
mHFDde=HBH1600800de_mean;
disp(mHFDde);

% 编码方式
codec='aac';
% 计算文件大小
[fid,errmsg]=fopen(file_out1);
disp(errmsg);
fseek(fid,0,'eof');
filesize = ftell(fid); 
disp(filesize);
% 参考值
mHFDde_wav=handles.mHFDde_wav;
% 存入文件
% codec,fs,vr,mse,psnr,ssim
% aac,
outfile=handles.filename_fs16k_outfile;
newCell_title={'filename','codec',...
    'filesize','fs','mse','psnr','mHFDde','mHFDde_wav'};
 
newCell_zhi={filename,codec,...
            filesize,fs,mse,psnr,mHFDde,mHFDde_wav};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.edit_aac_mse,'string',mse);
set(handles.edit_aac_psnr,'string',psnr);
set(handles.edit_aac_mHFD,'string',mHFDde);

end
    

% --- Executes on button press in pushbutton_test_all.
function pushbutton_test_all_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.mp3'];
file_out2=[filename,'_mp3.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 16k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 16k ',file_out2];
system(str_cmd1);    
system(str_cmd2);

filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.aac'];
file_out2=[filename,'_aac.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 16k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 16k ',file_out2];
system(str_cmd1);    
system(str_cmd2);

filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.flac'];
file_out2=[filename,'_flac.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 16k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 16k ',file_out2];
system(str_cmd1);    
system(str_cmd2);

filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.ogg'];
file_out2=[filename,'_ogg.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 16k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 16k ',file_out2];
system(str_cmd1);    
system(str_cmd2);
 

% --- Executes on button press in pushbutton_flac_8k_generate.
function pushbutton_flac_8k_generate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_flac_8k_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.flac'];
file_out2=[filename,'_flac.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 8k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 8k ',file_out2];
system(str_cmd1);    
system(str_cmd2);


% --- Executes on button press in pushbutton_flac_8k_calculate.
function pushbutton_flac_8k_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_flac_8k_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.flac'];
file_out2=[filename,'_flac.wav'];

[y1,fs1]=audioread(file_in);
[y2,fs2]=audioread(file_out2);
y1=y1(:,1);
y2=y2(:,1);
[c1x,c1y]=size(y1);
[c2x,c2y]=size(y2);
disp(['c1x=' num2str(c1x) ]);
disp(['c2x=' num2str(c2x) ]);
deltx=(c2x-c1x)/2;
y2=y2((deltx+1):(c2x-deltx),:);
[c2x,c2y]=size(y2);
disp(['c2x=' num2str(c2x) ]);
disp(['c1y=' num2str(c1y) ]);
disp(['c2y=' num2str(c2y) ]);
R=c1x;
C=c1y;
err = sum((y1-y2).^2)/(R*C);
MSE=sqrt(err);
disp(['MSE=' num2str(MSE) ]);
MAXVAL=65535;
PSNR = 20*log10(MAXVAL/MSE); 
set(handles.edit_flac_8k_mse,'string',MSE);
set(handles.edit_flac_8k_psnr,'string',PSNR);
disp(['PSNR=' num2str(PSNR)]);

% fprintf('testing narrowband.\n');
% % pesq=pesq_mex(y1, y2, fs1, 'narrowband');
% pesq=PESQ_MEX(y1, y2, fs1, 'narrowband');
% set(handles.edit_mp3_pesq,'string',pesq);
% disp(pesq);

% fprintf('testing ssnr.\n');
% ssnr = segsnr( y1, y2, fs1 );
% set(handles.edit_mp3_segSNR,'string',ssnr);
% disp(ssnr);

%ssim
% audioIn = audioIn./max(abs(audioIn));
% sound(audioIn,fs)
% S = melSpectrogram(audioIn,fs)

% mHFD
if ~exist(string(file_out2),'file')
    disp(['Error. \n No this file: ',string(file_out2)]);
else
    [x fs]=audioread(file_out2);
    tt=length(x)/fs;
    start_time = 0;
    end_time = tt;
    sig=x((fs*start_time+1):fs*end_time);
    xx=double(sig);
    
    win=800;step=400;
    xx_left=[0,0,0,0,0,0,0,0]';
    xx_0=[xx_left;xx(1:end-8)];
    xx_1=xx;
    xx_2=[xx(9:end);xx_left];

    [HBH_de_0]=FD_HBH_8k(xx_0,win,step);
    [HBH_de_1]=FD_HBH_8k(xx_1,win,step);
    [HBH_de_2]=FD_HBH_8k(xx_2,win,step);
    HBH1600800de=(HBH_de_0+HBH_de_1+HBH_de_2)/3;
    HBH1600800de_mean=mean(HBH1600800de);
    
mHFDde=HBH1600800de_mean;
set(handles.edit_flac_8k_mHFD,'string',mHFDde);
disp(mHFDde);

end


% --- Executes on button press in pushbutton_flac_generate.
function pushbutton_flac_generate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_flac_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.flac'];
file_out2=[filename,'_flac.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 16k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 16k ',file_out2];
system(str_cmd1);    
system(str_cmd2);


function edit_flac_mse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_flac_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_flac_mse as text
%        str2double(get(hObject,'String')) returns contents of edit_flac_mse as a double


% --- Executes during object creation, after setting all properties.
function edit_flac_mse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_flac_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_wma_segSNR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wma_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wma_segSNR as text
%        str2double(get(hObject,'String')) returns contents of edit_wma_segSNR as a double


% --- Executes during object creation, after setting all properties.
function edit_wma_segSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wma_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_flac_calculate.
function pushbutton_flac_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_flac_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.flac'];
file_out2=[filename,'_flac.wav'];

[y1,fs1]=audioread(file_in);
[y2,fs2]=audioread(file_out2);
y1=y1(:,1);
y2=y2(:,1);
[c1x,c1y]=size(y1);
[c2x,c2y]=size(y2);
disp(['c1x=' num2str(c1x) ]);
disp(['c2x=' num2str(c2x) ]);
% 这里不同于mp3，c1x=131839,c2x=131584,c1大。
% 也就是wma长度变短了，相对于wav。
% deltx=(c1x-c2x)/2;
% a=zeros(1,deltx);
% y2=[a,y2(:,:),a];
deltx=(c2x-c1x)/2;
y2=y2((deltx+1):(c2x-deltx),:);
[c2x,c2y]=size(y2);
disp(['c2x=' num2str(c2x) ]);
disp(['c1y=' num2str(c1y) ]);
disp(['c2y=' num2str(c2y) ]);
R=c1x;
C=c1y;
err = sum((y1-y2).^2)/(R*C);
mse=sqrt(err);
disp(['MSE=' num2str(mse) ]);
MAXVAL=65535;
psnr = 20*log10(MAXVAL/mse); 
disp(['PSNR=' num2str(psnr)]);

% fprintf('testing narrowband.\n');
% % pesq=pesq_mex(y1, y2, fs1, 'narrowband');
% pesq=PESQ_MEX(y1, y2, fs1, 'narrowband');
% set(handles.edit_mp3_pesq,'string',pesq);
% disp(pesq);

% fprintf('testing ssnr.\n');
% ssnr = segsnr( y1, y2, fs1 );
% set(handles.edit_wma_segSNR,'string',ssnr);
% disp(ssnr);

%ssim
% audioIn = audioIn./max(abs(audioIn));
% sound(audioIn,fs)
% S = melSpectrogram(audioIn,fs)

% mHFD
if ~exist(string(file_out2),'file')
    disp(['Error. \n No this file: ',string(file_out2)]);
else
    [x fs]=audioread(file_out2);
    tt=length(x)/fs;
    start_time = 0;
    end_time = tt;
    sig=x((fs*start_time+1):fs*end_time);
    xx=double(sig);
    
    win=1600;step=800;
    xx_left=[0,0,0,0,0,0,0,0]';
    xx_0=[xx_left;xx(1:end-8)];
    xx_1=xx;
    xx_2=[xx(9:end);xx_left];

    [HBH_de_0]=FD_HBH(xx_0,win,step);
    [HBH_de_1]=FD_HBH(xx_1,win,step);
    [HBH_de_2]=FD_HBH(xx_2,win,step);
    HBH1600800de=(HBH_de_0+HBH_de_1+HBH_de_2)/3;
    HBH1600800de_mean=mean(HBH1600800de);
    
mHFDde=HBH1600800de_mean;
disp(mHFDde);

% 编码方式
codec='flac';
% 计算文件大小
[fid,errmsg]=fopen(file_out1);
disp(errmsg);
fseek(fid,0,'eof');
filesize = ftell(fid); 
disp(filesize);
% 参考值
mHFDde_wav=handles.mHFDde_wav;
% 存入文件
% codec,fs,vr,mse,psnr,ssim
% flac,
outfile=handles.filename_fs16k_outfile;
newCell_title={'filename','codec',...
    'filesize','fs','mse','psnr','mHFDde','mHFDde_wav'};
 
newCell_zhi={filename,codec,...
            filesize,fs,mse,psnr,mHFDde,mHFDde_wav};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.edit_flac_mse,'string',mse);
set(handles.edit_flac_psnr,'string',psnr);
set(handles.edit_flac_mHFD,'string',mHFDde);

end


% --- Executes on button press in pushbutton_aac_8k_generate.
function pushbutton_aac_8k_generate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_aac_8k_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.aac'];
file_out2=[filename,'_aac.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 8k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 8k ',file_out2];
system(str_cmd1);    
system(str_cmd2);


% --- Executes on button press in pushbutton_aac_8k_calculate.
function pushbutton_aac_8k_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_aac_8k_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.aac'];
file_out2=[filename,'_aac.wav'];

[y1,fs1]=audioread(file_in);
[y2,fs2]=audioread(file_out2);
y1=y1(:,1);
y2=y2(:,1);
[c1x,c1y]=size(y1);
[c2x,c2y]=size(y2);
disp(['c1x=' num2str(c1x) ]);
disp(['c2x=' num2str(c2x) ]);
deltx=(c2x-c1x)/2;
y2=y2((deltx+1):(c2x-deltx),:);
[c2x,c2y]=size(y2);
disp(['c2x=' num2str(c2x) ]);
disp(['c1y=' num2str(c1y) ]);
disp(['c2y=' num2str(c2y) ]);
R=c1x;
C=c1y;
err = sum((y1-y2).^2)/(R*C);
MSE=sqrt(err);
disp(['MSE=' num2str(MSE) ]);
MAXVAL=65535;
PSNR = 20*log10(MAXVAL/MSE); 
set(handles.edit_aac_8k_mse,'string',MSE);
set(handles.edit_aac_8k_psnr,'string',PSNR);
disp(['PSNR=' num2str(PSNR)]);

% fprintf('testing narrowband.\n');
% % pesq=pesq_mex(y1, y2, fs1, 'narrowband');
% pesq=PESQ_MEX(y1, y2, fs1, 'narrowband');
% set(handles.edit_mp3_pesq,'string',pesq);
% disp(pesq);

% fprintf('testing ssnr.\n');
% ssnr = segsnr( y1, y2, fs1 );
% set(handles.edit_mp3_segSNR,'string',ssnr);
% disp(ssnr);

%ssim
% audioIn = audioIn./max(abs(audioIn));
% sound(audioIn,fs)
% S = melSpectrogram(audioIn,fs)

% mHFD
if ~exist(string(file_out2),'file')
    disp(['Error. \n No this file: ',string(file_out2)]);
else
    [x fs]=audioread(file_out2);
    tt=length(x)/fs;
    start_time = 0;
    end_time = tt;
    sig=x((fs*start_time+1):fs*end_time);
    xx=double(sig);
    
    win=800;step=400;
    xx_left=[0,0,0,0,0,0,0,0]';
    xx_0=[xx_left;xx(1:end-8)];
    xx_1=xx;
    xx_2=[xx(9:end);xx_left];

    [HBH_de_0]=FD_HBH_8k(xx_0,win,step);
    [HBH_de_1]=FD_HBH_8k(xx_1,win,step);
    [HBH_de_2]=FD_HBH_8k(xx_2,win,step);
    HBH1600800de=(HBH_de_0+HBH_de_1+HBH_de_2)/3;
    HBH1600800de_mean=mean(HBH1600800de);
    
mHFDde=HBH1600800de_mean;
set(handles.edit_aac_8k_mHFD,'string',mHFDde);
disp(mHFDde);

end


% --- Executes on button press in pushbutton_mp3_8k_calculate.
function pushbutton_mp3_8k_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_mp3_8k_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.mp3'];
file_out2=[filename,'_mp3.wav'];

[y1,fs1]=audioread(file_in);
[y2,fs2]=audioread(file_out2);
y1=y1(:,1);
y2=y2(:,1);
[c1x,c1y]=size(y1);
[c2x,c2y]=size(y2);
disp(['c1x=' num2str(c1x) ]);
disp(['c2x=' num2str(c2x) ]);
deltx=(c2x-c1x)/2;
y2=y2((deltx+1):(c2x-deltx),:);
[c2x,c2y]=size(y2);
disp(['c2x=' num2str(c2x) ]);
disp(['c1y=' num2str(c1y) ]);
disp(['c2y=' num2str(c2y) ]);
R=c1x;
C=c1y;
err = sum((y1-y2).^2)/(R*C);
MSE=sqrt(err);
disp(['MSE=' num2str(MSE) ]);
MAXVAL=65535;
PSNR = 20*log10(MAXVAL/MSE); 
set(handles.edit_mp3_8k_mse,'string',MSE);
set(handles.edit_mp3_8k_psnr,'string',PSNR);
disp(['PSNR=' num2str(PSNR)]);

% fprintf('testing narrowband.\n');
% % pesq=pesq_mex(y1, y2, fs1, 'narrowband');
% pesq=PESQ_MEX(y1, y2, fs1, 'narrowband');
% set(handles.edit_mp3_pesq,'string',pesq);
% disp(pesq);

% fprintf('testing ssnr.\n');
% ssnr = segsnr( y1, y2, fs1 );
% set(handles.edit_mp3_segSNR,'string',ssnr);
% disp(ssnr);

%ssim
% audioIn = audioIn./max(abs(audioIn));
% sound(audioIn,fs)
% S = melSpectrogram(audioIn,fs)

% mHFD
if ~exist(string(file_out2),'file')
    disp(['Error. \n No this file: ',string(file_out2)]);
else
    [x fs]=audioread(file_out2);
    tt=length(x)/fs;
    start_time = 0;
    end_time = tt;
    sig=x((fs*start_time+1):fs*end_time);
    xx=double(sig);
    
    win=800;step=400;
    xx_left=[0,0,0,0,0,0,0,0]';
    xx_0=[xx_left;xx(1:end-8)];
    xx_1=xx;
    xx_2=[xx(9:end);xx_left];

    [HBH_de_0]=FD_HBH_8k(xx_0,win,step);
    [HBH_de_1]=FD_HBH_8k(xx_1,win,step);
    [HBH_de_2]=FD_HBH_8k(xx_2,win,step);
    HBH1600800de=(HBH_de_0+HBH_de_1+HBH_de_2)/3;
    HBH1600800de_mean=mean(HBH1600800de);
    
mHFDde=HBH1600800de_mean;
set(handles.edit_mp3_8k_mHFD,'string',mHFDde);
disp(mHFDde);

end


function edit_mp3_pesq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_pesq as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_pesq as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_pesq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_mp3_segSNR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_segSNR as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_segSNR as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_segSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_aac_pesq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_pesq as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_pesq as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_pesq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_flac_psnr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_flac_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_flac_psnr as text
%        str2double(get(hObject,'String')) returns contents of edit_flac_psnr as a double


% --- Executes during object creation, after setting all properties.
function edit_flac_psnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_flac_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_wma_pesq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wma_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wma_pesq as text
%        str2double(get(hObject,'String')) returns contents of edit_wma_pesq as a double


% --- Executes during object creation, after setting all properties.
function edit_wma_pesq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wma_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_aac_segSNR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_segSNR as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_segSNR as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_segSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_flac_8k_play.
function pushbutton_flac_8k_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_flac_8k_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.flac'];
file_out2=[filename,'_flac.wav'];
str_cmd=['ffplay ',file_out1];
system(str_cmd);  


% --- Executes on button press in pushbutton_flac_play.
function pushbutton_flac_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_flac_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.flac'];
file_out2=[filename,'_flac.wav'];
str_cmd=['ffplay ',file_out1];
system(str_cmd);  


% --- Executes on button press in pushbutton_aac_8k_play.
function pushbutton_aac_8k_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_aac_8k_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.aac'];
file_out2=[filename,'_aac.wav'];
str_cmd=['ffplay ',file_out1];
system(str_cmd);  


% --- Executes on button press in pushbutton_mp3_8k_play.
function pushbutton_mp3_8k_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_mp3_8k_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.mp3'];
file_out2=[filename,'_mp3.wav'];
str_cmd=['ffplay ',file_out1];
system(str_cmd);  


% --- Executes on button press in pushbutton_mp3_8k_generate.
function pushbutton_mp3_8k_generate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_mp3_8k_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.mp3'];
file_out2=[filename,'_mp3.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 8k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 8k ',file_out2];
system(str_cmd1);    
system(str_cmd2);


% --- Executes on button press in pushbutton_aac_play.
function pushbutton_aac_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_aac_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.aac'];
file_out2=[filename,'_aac.wav'];
str_cmd=['ffplay ',file_out1];
system(str_cmd);  


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
   
axes(handles.axes_signal);
url_file=url;
str_cmd=['ffplay ',url_file];
system(str_cmd); 


function edit_aac_8k_mse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_8k_mse as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_8k_mse as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_8k_mse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_aac_8k_psnr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_8k_psnr as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_8k_psnr as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_8k_psnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_aac_8k_pesq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_8k_pesq as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_8k_pesq as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_8k_pesq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_aac_8k_segSNR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_8k_segSNR as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_8k_segSNR as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_8k_segSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_mp3_8k_mse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_8k_mse as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_8k_mse as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_8k_mse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_mp3_8k_psnr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_8k_psnr as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_8k_psnr as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_8k_psnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_mp3_8k_pesq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_8k_pesq as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_8k_pesq as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_8k_pesq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_mp3_8k_segSNR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_8k_segSNR as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_8k_segSNR as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_8k_segSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_flac_8k_mse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_flac_8k_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_flac_8k_mse as text
%        str2double(get(hObject,'String')) returns contents of edit_flac_8k_mse as a double


% --- Executes during object creation, after setting all properties.
function edit_flac_8k_mse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_flac_8k_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_wma_8k_segSNR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wma_8k_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wma_8k_segSNR as text
%        str2double(get(hObject,'String')) returns contents of edit_wma_8k_segSNR as a double


% --- Executes during object creation, after setting all properties.
function edit_wma_8k_segSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wma_8k_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_flac_8k_psnr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_flac_8k_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_flac_8k_psnr as text
%        str2double(get(hObject,'String')) returns contents of edit_flac_8k_psnr as a double


% --- Executes during object creation, after setting all properties.
function edit_flac_8k_psnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_flac_8k_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_wma_8k_pesq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wma_8k_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wma_8k_pesq as text
%        str2double(get(hObject,'String')) returns contents of edit_wma_8k_pesq as a double


% --- Executes during object creation, after setting all properties.
function edit_wma_8k_pesq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wma_8k_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ogg_8k_generate.
function pushbutton_ogg_8k_generate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ogg_8k_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.ogg'];
file_out2=[filename,'_ogg.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 8k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 8k ',file_out2];
system(str_cmd1);    
system(str_cmd2);


% --- Executes on button press in pushbutton_ogg_8k_calculate.
function pushbutton_ogg_8k_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ogg_8k_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.ogg'];
file_out2=[filename,'_ogg.wav'];

[y1,fs1]=audioread(file_in);
[y2,fs2]=audioread(file_out2);
y1=y1(:,1);
y2=y2(:,1);
[c1x,c1y]=size(y1);
[c2x,c2y]=size(y2);
disp(['c1x=' num2str(c1x) ]);
disp(['c2x=' num2str(c2x) ]);
deltx=(c2x-c1x)/2;
y2=y2((deltx+1):(c2x-deltx),:);
[c2x,c2y]=size(y2);
disp(['c2x=' num2str(c2x) ]);
disp(['c1y=' num2str(c1y) ]);
disp(['c2y=' num2str(c2y) ]);
R=c1x;
C=c1y;
err = sum((y1-y2).^2)/(R*C);
MSE=sqrt(err);
disp(['MSE=' num2str(MSE) ]);
MAXVAL=65535;
PSNR = 20*log10(MAXVAL/MSE); 
set(handles.edit_ogg_8k_mse,'string',MSE);
set(handles.edit_ogg_8k_psnr,'string',PSNR);
disp(['PSNR=' num2str(PSNR)]);

% fprintf('testing narrowband.\n');
% % pesq=pesq_mex(y1, y2, fs1, 'narrowband');
% pesq=PESQ_MEX(y1, y2, fs1, 'narrowband');
% set(handles.edit_mp3_pesq,'string',pesq);
% disp(pesq);

% fprintf('testing ssnr.\n');
% ssnr = segsnr( y1, y2, fs1 );
% set(handles.edit_mp3_segSNR,'string',ssnr);
% disp(ssnr);

%ssim
% audioIn = audioIn./max(abs(audioIn));
% sound(audioIn,fs)
% S = melSpectrogram(audioIn,fs)

% mHFD
if ~exist(string(file_out2),'file')
    disp(['Error. \n No this file: ',string(file_out2)]);
else
    [x fs]=audioread(file_out2);
    tt=length(x)/fs;
    start_time = 0;
    end_time = tt;
    sig=x((fs*start_time+1):fs*end_time);
    xx=double(sig);
    
    win=800;step=400;
    xx_left=[0,0,0,0,0,0,0,0]';
    xx_0=[xx_left;xx(1:end-8)];
    xx_1=xx;
    xx_2=[xx(9:end);xx_left];

    [HBH_de_0]=FD_HBH_8k(xx_0,win,step);
    [HBH_de_1]=FD_HBH_8k(xx_1,win,step);
    [HBH_de_2]=FD_HBH_8k(xx_2,win,step);
    HBH1600800de=(HBH_de_0+HBH_de_1+HBH_de_2)/3;
    HBH1600800de_mean=mean(HBH1600800de);
    
mHFDde=HBH1600800de_mean;
set(handles.edit_ogg_8k_mHFD,'string',mHFDde);
disp(mHFDde);

end


% --- Executes on button press in pushbutton_ogg_8k_play.
function pushbutton_ogg_8k_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ogg_8k_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.ogg'];
file_out2=[filename,'_ogg.wav'];
str_cmd=['ffplay ',file_out1];
system(str_cmd);  


function edit_ogg_8k_mse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_8k_mse as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_8k_mse as a double


% --- Executes during object creation, after setting all properties.
function edit_ogg_8k_mse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_ogg_8k_segSNR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_8k_segSNR as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_8k_segSNR as a double


% --- Executes during object creation, after setting all properties.
function edit_ogg_8k_segSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ogg_8k_psnr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_8k_psnr as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_8k_psnr as a double


% --- Executes during object creation, after setting all properties.
function edit_ogg_8k_psnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_ogg_8k_pesq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_8k_pesq as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_8k_pesq as a double


% --- Executes during object creation, after setting all properties.
function edit_ogg_8k_pesq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ogg_generate.
function pushbutton_ogg_generate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ogg_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.ogg'];
file_out2=[filename,'_ogg.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 16k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 16k ',file_out2];
system(str_cmd1);    
system(str_cmd2);


function edit_ogg_mse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_mse as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_mse as a double


% --- Executes during object creation, after setting all properties.
function edit_ogg_mse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_mse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_ogg_segSNR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_segSNR as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_segSNR as a double


% --- Executes during object creation, after setting all properties.
function edit_ogg_segSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_segSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ogg_calculate.
function pushbutton_ogg_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ogg_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.ogg'];
file_out2=[filename,'_ogg.wav'];

[y1,fs1]=audioread(file_in);
[y2,fs2]=audioread(file_out2);
y1=y1(:,1);
y2=y2(:,1);
[c1x,c1y]=size(y1);
[c2x,c2y]=size(y2);
disp(['c1x=' num2str(c1x) ]);
disp(['c2x=' num2str(c2x) ]);
deltx=(c2x-c1x)/2;
y2=y2((deltx+1):(c2x-deltx),:);
[c2x,c2y]=size(y2);
disp(['c2x=' num2str(c2x) ]);
disp(['c1y=' num2str(c1y) ]);
disp(['c2y=' num2str(c2y) ]);
R=c1x;
C=c1y;
err = sum((y1-y2).^2)/(R*C);
mse=sqrt(err);
disp(['MSE=' num2str(mse) ]);
MAXVAL=65535;
psnr = 20*log10(MAXVAL/mse); 
disp(['PSNR=' num2str(psnr)]);

% fprintf('testing narrowband.\n');
% % pesq=pesq_mex(y1, y2, fs1, 'narrowband');
% pesq=PESQ_MEX(y1, y2, fs1, 'narrowband');
% set(handles.edit_mp3_pesq,'string',pesq);
% disp(pesq);

% fprintf('testing ssnr.\n');
% ssnr = segsnr( y1, y2, fs1 );
% set(handles.edit_ogg_segSNR,'string',ssnr);
% disp(ssnr);

%ssim
% audioIn = audioIn./max(abs(audioIn));
% sound(audioIn,fs)
% S = melSpectrogram(audioIn,fs)

% mHFD
if ~exist(string(file_out2),'file')
    disp(['Error. \n No this file: ',string(file_out2)]);
else
    [x fs]=audioread(file_out2);
    tt=length(x)/fs;
    start_time = 0;
    end_time = tt;
    sig=x((fs*start_time+1):fs*end_time);
    xx=double(sig);
    
    win=1600;step=800;
    xx_left=[0,0,0,0,0,0,0,0]';
    xx_0=[xx_left;xx(1:end-8)];
    xx_1=xx;
    xx_2=[xx(9:end);xx_left];

    [HBH_de_0]=FD_HBH(xx_0,win,step);
    [HBH_de_1]=FD_HBH(xx_1,win,step);
    [HBH_de_2]=FD_HBH(xx_2,win,step);
    HBH1600800de=(HBH_de_0+HBH_de_1+HBH_de_2)/3;
    HBH1600800de_mean=mean(HBH1600800de);
    
mHFDde=HBH1600800de_mean;
disp(mHFDde);

% 编码方式
codec='ogg';
% 计算文件大小
[fid,errmsg]=fopen(file_out1);
disp(errmsg);
fseek(fid,0,'eof');
filesize = ftell(fid); 
disp(filesize);
% 参考值
mHFDde_wav=handles.mHFDde_wav;
% 存入文件
% codec,fs,vr,mse,psnr,ssim
% ogg,
outfile=handles.filename_fs16k_outfile;
newCell_title={'filename','codec',...
    'filesize','fs','mse','psnr','mHFDde','mHFDde_wav'};
 
newCell_zhi={filename,codec,...
            filesize,fs,mse,psnr,mHFDde,mHFDde_wav};
disp(newCell_zhi);
newTable = cell2table(newCell_zhi);
newTable.Properties.VariableNames=newCell_title;
nasdaq=readtable(outfile);
nasdaq.Properties.VariableNames=newCell_title;
 
newNasdaq =[nasdaq;newTable];  
writetable(newNasdaq,outfile);
% 写入完成。
disp('数据写入完成。');

set(handles.edit_ogg_mse,'string',mse);
set(handles.edit_ogg_psnr,'string',psnr);
set(handles.edit_ogg_mHFD,'string',mHFDde);

end


function edit_ogg_psnr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_psnr as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_psnr as a double


% --- Executes during object creation, after setting all properties.
function edit_ogg_psnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_ogg_pesq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_pesq as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_pesq as a double


% --- Executes during object creation, after setting all properties.
function edit_ogg_pesq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_pesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ogg_play.
function pushbutton_ogg_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ogg_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
file_in=[filename,'.wav'];
file_out1=[filename,'.ogg'];
file_out2=[filename,'_ogg.wav'];
str_cmd=['ffplay ',file_out1];
system(str_cmd);  


function edit_mp3_ssim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_ssim as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_ssim as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_ssim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_mp3_mHFD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_mHFD as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_mHFD as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_mHFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_wma_ssim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wma_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wma_ssim as text
%        str2double(get(hObject,'String')) returns contents of edit_wma_ssim as a double


% --- Executes during object creation, after setting all properties.
function edit_wma_ssim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wma_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_flac_mHFD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_flac_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_flac_mHFD as text
%        str2double(get(hObject,'String')) returns contents of edit_flac_mHFD as a double


% --- Executes during object creation, after setting all properties.
function edit_flac_mHFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_flac_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_aac_ssim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_ssim as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_ssim as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_ssim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_aac_mHFD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_mHFD as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_mHFD as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_mHFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_ogg_ssim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_ssim as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_ssim as a double


% --- Executes during object creation, after setting all properties.
function edit_ogg_ssim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_ogg_mHFD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_mHFD as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_mHFD as a double


% --- Executes during object creation, after setting all properties.
function edit_ogg_mHFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ogg_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_ogg_8k_ssim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_8k_ssim as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_8k_ssim as a double


function edit_ogg_8k_mHFD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ogg_8k_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ogg_8k_mHFD as text
%        str2double(get(hObject,'String')) returns contents of edit_ogg_8k_mHFD as a double


function edit_wma_8k_ssim_Callback(hObject, ~, handles)
% hObject    handle to edit_wma_8k_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wma_8k_ssim as text
%        str2double(get(hObject,'String')) returns contents of edit_wma_8k_ssim as a double


% --- Executes during object creation, after setting all properties.
function edit_wma_8k_ssim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wma_8k_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_flac_8k_mHFD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_flac_8k_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_flac_8k_mHFD as text
%        str2double(get(hObject,'String')) returns contents of edit_flac_8k_mHFD as a double


function edit_aac_8k_ssim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_8k_ssim as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_8k_ssim as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_8k_ssim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_aac_8k_mHFD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aac_8k_mHFD as text
%        str2double(get(hObject,'String')) returns contents of edit_aac_8k_mHFD as a double


% --- Executes during object creation, after setting all properties.
function edit_aac_8k_mHFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aac_8k_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_mp3_8k_ssim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_8k_ssim as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_8k_ssim as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_8k_ssim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_ssim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_mp3_8k_mHFD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mp3_8k_mHFD as text
%        str2double(get(hObject,'String')) returns contents of edit_mp3_8k_mHFD as a double


% --- Executes during object creation, after setting all properties.
function edit_mp3_8k_mHFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mp3_8k_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_wav_mHFD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wav_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wav_mHFD as text
%        str2double(get(hObject,'String')) returns contents of edit_wav_mHFD as a double


% --- Executes during object creation, after setting all properties.
function edit_wav_mHFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wav_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_test.
function pushbutton_test_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test (see GCBO)
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
set(handles.listbox_test_index_ipv4,'String',a);
set(handles.edit_qps,'String',a(35,1));


% handles.mHFDde_wav=m_HFD_de;
guidata(hObject, handles);



% --- Executes on button press in pushbutton_wav_8k_load.
function pushbutton_wav_8k_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_wav_8k_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile({'*.wav'},'Load Wav File');
[x,Fs] = audioread([PathName '/' FileName]);
x = x(:,1);
% assignin('base','Fs',Fs);
handles.x = x ./ max(abs(x));
handles.Fs = Fs;
axes(handles.axes_signal_8k);
handles.Time = 0:1/Fs:(length(handles.x)-1)/Fs;
plot(handles.Time, handles.x);
axis([0 max(handles.Time) -1 1]);
xlabel('Time (s)')
ylabel('Magnitude')

axes(handles.axes_signalSpec_8k);
Fn = handles.Fs/2;
Fy = fft(handles.x)/length(handles.x);
Fv = linspace(0, 1, fix(length(handles.x)/2) + 1)*Fn;
Iv = 1:length(Fv);
plot(Fv, abs(Fy(Iv,1))*2)
xlabel('Frequency (Hz)')
ylabel('Magnitude')

filename=FileName(1:end-4);
% file_in=[filename,'.wav'];
% file_out_8k=[filename,'_8k.wav'];
% str_cmd_8k=['ffmpeg -i ',file_in,' -ac 1 -ar 8k ',file_out_8k];
% system(str_cmd_8k);    

handles.fileLoaded = 1;
handles.filename_8k=filename;
handles.PathName_8k=PathName;
handles.FileName_8k=FileName;
guidata(hObject, handles);


% --- Executes on button press in pushbutton_wav_8k_generateAll.
function pushbutton_wav_8k_generateAll_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_wav_8k_generateAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.mp3'];
file_out2=[filename,'_mp3.wav'];

fses = [8000 32000 44000 48000 64000];
file_fs = fses(get(handles.popupmenu_file_fs, 'value'));
disp(file_fs);

str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 8k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 8k ',file_out2];
system(str_cmd1);    
system(str_cmd2);

file_out1=[filename,'.aac'];
file_out2=[filename,'_aac.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 8k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 8k ',file_out2];
system(str_cmd1);    
system(str_cmd2);

file_out1=[filename,'.flac'];
file_out2=[filename,'_flac.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 8k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 8k ',file_out2];
system(str_cmd1);    
system(str_cmd2);

file_out1=[filename,'.ogg'];
file_out2=[filename,'_ogg.wav'];
str_cmd1=['ffmpeg -i ',file_in,' -ac 1 -ar 8k ',file_out1];
str_cmd2=['ffmpeg -i ',file_out1,' -ac 1 -ar 8k ',file_out2];
system(str_cmd1);    
system(str_cmd2);


% --- Executes on button press in pushbutton_wav_8k_play.
function pushbutton_wav_8k_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_wav_8k_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.mp3'];
file_out2=[filename,'_mp3.wav'];
str_cmd=['ffplay ',file_in];
system(str_cmd);  


function edit_wav_8k_mHFD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wav_8k_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wav_8k_mHFD as text
%        str2double(get(hObject,'String')) returns contents of edit_wav_8k_mHFD as a double


% --- Executes during object creation, after setting all properties.
function edit_wav_8k_mHFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wav_8k_mHFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_wav_8k_calculate.
function pushbutton_wav_8k_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_wav_8k_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename_8k;
file_in=[filename,'.wav'];
file_out1=[filename,'.mp3'];
file_out2=[filename,'_mp3.wav'];

% mHFD
if ~exist(string(file_in),'file')
    disp(['Error. \n No this file: ',string(file_out2)]);
else
    [x fs]=audioread(file_in);
    x=x(:,1);
%     disp(x);
    tt=length(x)/fs;
    start_time = 0;
    end_time = tt;
    sig=x((fs*start_time+1):fs*end_time);
    xx=double(sig);
    
    win=800;step=400;
    xx_left=[0,0,0,0,0,0,0,0]';
    xx_0=[xx_left;xx(1:end-8)];
    xx_1=xx;
    xx_2=[xx(9:end);xx_left];

    [HBH_de_0]=FD_HBH_8k(xx_0,win,step);
    [HBH_de_1]=FD_HBH_8k(xx_1,win,step);
    [HBH_de_2]=FD_HBH_8k(xx_2,win,step);
    HBH1600800de=(HBH_de_0+HBH_de_1+HBH_de_2)/3;
    HBH1600800de_mean=mean(HBH1600800de);
    
m_HFD_de=HBH1600800de_mean;
set(handles.edit_wav_8k_mHFD,'string',m_HFD_de);
disp(m_HFD_de);

end


% HFD
% function [HBH_xx,HBH_de,HBH_dede] = FD_HBH(serie,win,step)
function [HBH_de] = FD_HBH(serie,win,step)
    win=win;step=step;
    xx=enframe(serie,win,step);

    for i=1:size(xx,1)-1
        x1=xx(i,:);x2=xx(i+1,:);
        y=(x1+x2)/2; 
        s=y;
        t_HBH=abs(2-Higuchi_FD(s,16));
        m(i,:)=t_HBH;
    end

    dtm=zeros(size(m));
    for i=3:size(m,1)-2
        dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
    end
    dtm=dtm/10;

% HBH_xx=m;
HBH_de=dtm;


% HFD_8k
% function [HBH_xx,HBH_de,HBH_dede] = FD_HBH(serie,win,step)
function [HBH_de] = FD_HBH_8k(serie,win,step)
    win=win;step=step;
    xx=enframe(serie,win,step);

    for i=1:size(xx,1)-1
        x1=xx(i,:);x2=xx(i+1,:);
        y=(x1+x2)/2;
        s=y;
        t_HBH=abs(2-Higuchi_FD(s,8));
        m(i,:)=t_HBH;
    end

    dtm=zeros(size(m));
    for i=3:size(m,1)-2
        dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
    end
    dtm=dtm/10;

% HBH_xx=m;
HBH_de=dtm;


% --- Executes on selection change in popupmenu_file_fs.
function popupmenu_file_fs_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_file_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_file_fs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_file_fs


% --- Executes during object creation, after setting all properties.
function popupmenu_file_fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_file_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12


% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu13.
function popupmenu13_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu13


% --- Executes during object creation, after setting all properties.
function popupmenu13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
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


% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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



function edit79_Callback(hObject, eventdata, handles)
% hObject    handle to edit79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit79 as text
%        str2double(get(hObject,'String')) returns contents of edit79 as a double


% --- Executes during object creation, after setting all properties.
function edit79_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_url_ipv6_dpdk_nginx_media_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_ipv6_dpdk_nginx_media (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_ipv6_dpdk_nginx_media as text
%        str2double(get(hObject,'String')) returns contents of edit_url_ipv6_dpdk_nginx_media as a double


% --- Executes during object creation, after setting all properties.
function edit_url_ipv6_dpdk_nginx_media_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_ipv6_dpdk_nginx_media (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_url_ipv4_dpdp_nginx_media_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_ipv4_dpdp_nginx_media (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_ipv4_dpdp_nginx_media as text
%        str2double(get(hObject,'String')) returns contents of edit_url_ipv4_dpdp_nginx_media as a double


% --- Executes during object creation, after setting all properties.
function edit_url_ipv4_dpdp_nginx_media_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_ipv4_dpdp_nginx_media (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit82_Callback(hObject, eventdata, handles)
% hObject    handle to edit82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit82 as text
%        str2double(get(hObject,'String')) returns contents of edit82 as a double


% --- Executes during object creation, after setting all properties.
function edit82_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton55.
function pushbutton55_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_test_dpdk_nginx.
function pushbutton_test_dpdk_nginx_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_t_dpdk_nginx.
function popupmenu_t_dpdk_nginx_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_t_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_t_dpdk_nginx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_t_dpdk_nginx


% --- Executes during object creation, after setting all properties.
function popupmenu_t_dpdk_nginx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_t_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_c_dpdk_nginx.
function popupmenu_c_dpdk_nginx_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_c_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_c_dpdk_nginx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_c_dpdk_nginx


% --- Executes during object creation, after setting all properties.
function popupmenu_c_dpdk_nginx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_c_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_d_dpdk_nginx.
function popupmenu_d_dpdk_nginx_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_d_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_d_dpdk_nginx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_d_dpdk_nginx


% --- Executes during object creation, after setting all properties.
function popupmenu_d_dpdk_nginx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_d_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_R_dpdk_nginx.
function popupmenu_R_dpdk_nginx_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_R_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_R_dpdk_nginx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_R_dpdk_nginx


% --- Executes during object creation, after setting all properties.
function popupmenu_R_dpdk_nginx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_R_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_url_dpdk_nginx.
function popupmenu_url_dpdk_nginx_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_url_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_url_dpdk_nginx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_url_dpdk_nginx


% --- Executes during object creation, after setting all properties.
function popupmenu_url_dpdk_nginx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_url_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit75_Callback(hObject, eventdata, handles)
% hObject    handle to edit75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit75 as text
%        str2double(get(hObject,'String')) returns contents of edit75 as a double


% --- Executes during object creation, after setting all properties.
function edit75_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_url_ipv6_dpdp_nginx_index_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_ipv6_dpdp_nginx_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_ipv6_dpdp_nginx_index as text
%        str2double(get(hObject,'String')) returns contents of edit_url_ipv6_dpdp_nginx_index as a double


% --- Executes during object creation, after setting all properties.
function edit_url_ipv6_dpdp_nginx_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_ipv6_dpdp_nginx_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_url_ipv4_dpdp_nginx_index_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url_ipv4_dpdp_nginx_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url_ipv4_dpdp_nginx_index as text
%        str2double(get(hObject,'String')) returns contents of edit_url_ipv4_dpdp_nginx_index as a double


% --- Executes during object creation, after setting all properties.
function edit_url_ipv4_dpdp_nginx_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url_ipv4_dpdp_nginx_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit78_Callback(hObject, eventdata, handles)
% hObject    handle to edit78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit78 as text
%        str2double(get(hObject,'String')) returns contents of edit78 as a double


% --- Executes during object creation, after setting all properties.
function edit78_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit78 (see GCBO)
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



function edit89_Callback(hObject, eventdata, handles)
% hObject    handle to edit89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit89 as text
%        str2double(get(hObject,'String')) returns contents of edit89 as a double


% --- Executes during object creation, after setting all properties.
function edit89_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit90_Callback(hObject, eventdata, handles)
% hObject    handle to edit90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit90 as text
%        str2double(get(hObject,'String')) returns contents of edit90 as a double


% --- Executes during object creation, after setting all properties.
function edit90_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit87_Callback(hObject, eventdata, handles)
% hObject    handle to edit87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit87 as text
%        str2double(get(hObject,'String')) returns contents of edit87 as a double


% --- Executes during object creation, after setting all properties.
function edit87_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit88_Callback(hObject, eventdata, handles)
% hObject    handle to edit88 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit88 as text
%        str2double(get(hObject,'String')) returns contents of edit88 as a double


% --- Executes during object creation, after setting all properties.
function edit88_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit88 (see GCBO)
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



function edit_qps_dpdk_nginx_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qps_dpdk_nginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qps_dpdk_nginx as text
%        str2double(get(hObject,'String')) returns contents of edit_qps_dpdk_nginx as a double


% --- Executes during object creation, after setting all properties.
function edit_qps_dpdk_nginx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qps_dpdk_nginx (see GCBO)
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
