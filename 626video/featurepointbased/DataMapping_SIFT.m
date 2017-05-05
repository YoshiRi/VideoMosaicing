 
 %% function MakeReference(filename)
clear all
addpath('C:\Users\yoshi\Documents\MATLAB\SIFT');
 
% read data
filename = '..\626EXP'

vidObj = VideoReader(strcat(filename,'.wmv'));

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;
Frate = vidObj.Framerate;

%% define cx cy = center.x center.y     Width and Height
cy = vidHeight/2;
cx = vidWidth/2;
Wid = 256;
Hei = 256;

% put feature descripter and loc
feature = struct('des',[],'loc',[]);

% Open frame and do output
while hasFrame(vidObj)
   s(k).cdata = rgb2gray( imcrop(readFrame(vidObj),[ cx - Wid/2, cy - Hei/2,Wid-1,Hei-1]) );
    [~,des,loc] = sift_ri(s(k).cdata);
    feature(k).des = des;
    feature(k).loc = loc;
   k = k+1;
end
Numframes = k - 1;

%%
save('featurepoints','feature');
save('VideoImages','s','Numframes','Wid','Hei');
%% Put value
load('featurepoints');
load('VideoImages');

Numframes = k - 1;
% initialize
time = zeros(Numframes,1);

valMap = zeros(Numframes,Numframes,4); % buff
val_ref = zeros(Numframes,4,1); % real
peakMap = zeros(Numframes,Numframes,2);
Err=[0 0];

% save refimage
RefFramenum = 1;
RF = s(1).cdata;
RFnum = 1;


for i = 1 : Numframes-1
        % hoge
    time(i)=i/vidObj.FrameRate;
    for j = i+1 : Numframes
        % extract image displacement and peak value to evaluate the correctness
        [Xi ,Err] = SIFT2POCparam(feature(i).des,feature(i).loc,feature(j).des,feature(j).loc,cx,cy);
        peakMap(i,j,1) = Err(1); %max
        peakMap(i,j,2) = 0; %min
        
        if Err == -1
            Xi = [0 0 1 0];
            peakMap(i,j,1) = 0; 
        end
        for k = 1 : 4
            valMap(i,j,k) = Xi(k);
        end
    end
end
save(strcat(filename,'FullMap.mat'));
