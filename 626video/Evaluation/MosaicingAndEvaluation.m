clear all
close all
%% read data
addpath('..\');
filename = '626EXP'
vidObj = VideoReader(strcat(filename,'.wmv'));
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
k=1;

   GT = rgb2gray( readFrame(vidObj));
    imshow(GT)

%%    
addpath('..\Optimization\')
addpath('..\Extraction\')
load('VideoImages.mat');
load('Optimized_626.mat');


length = size(T_val,1); % 行列と配列の長さ
[height width] = size(s(1).cdata); % image size

r = sqrt ( height^2 + width^2 ) / 2; % circle size

% maxl = r*ones(2,1); % define size 
% minl =- r*ones(2,1);  % define size

%% １：元になる画像のサイズの決定

maxl = - T_val(:,1:2) + repmat(r .* T_val(:,3),1,2);
minl =  - T_val(:,1:2) - repmat(r .* T_val(:,3),1,2);

Mxy = [ max(maxl(:,1)) , max(maxl(:,2)) ]; % max x and y value 
mxy = [ min(minl(:,1)) , min(minl(:,2)) ];% min x and y value


MWid = floor(Mxy(1))+1- floor(mxy(1)) + 1; % y size of New image
MHei =  floor(Mxy(2))+1- floor(mxy(2)) + 1; % x size of New image
xmin = floor(mxy(1)) -1
ymin = floor(mxy(2)) -1 

Map = double(zeros(MHei +1,MWid + 1)); % Making a Map with a 1 line redundant array
refMap = Map;

%% Make GrandTruth
%ここには慎重な計算が必要
% A:
crop = FindMinMax( T_val(1,:) ,width,height,xmin,ymin);
Abase = [crop(2),crop(1)]; % (Ay,Ax)
Bbase = [vidHeight-height,vidWidth-width]/2;
AminA = [1 1]; AmaxA = size(Map);
BminB = [1 1]; BmaxB = [vidHeight,vidWidth];
AminB = AminA+Bbase-Abase;AmaxB = AmaxA+Bbase-Abase;
BminA = BminB+Abase-Bbase;BmaxA = BmaxB+Abase-Bbase;
%min同士はmaxをとる vise versa
Amin = max(AminA,BminA);
Bmin = max(AminB,BminB);
Amax = min(AmaxA,BmaxA);
Bmax = min(AmaxB,BmaxB);

refMap(Amin(1):Amax(1),Amin(2):Amax(2))=double(GT(Bmin(1):Bmax(1),Bmin(2):Bmax(2)));
refMap_c = refMap(Amin(1):Amax(1),Amin(2):Amax(2)); %cropped one
save('results\refMap','refMap','refMap_c');
%% Make Data
bwid = size(Map,2);
bhei = size(Map,1);
buff = struct('i',zeros(bwid,bhei,'uint8'));
Update = struct('i',zeros(bwid,bhei,'double'));

%% Image Mosaicing
length = size(T_val,1);

% put value and mosaicing
for k=1:length
    display(k);
    Image = double(s(k).cdata);
    [Map, UD]= FillMap_Eval(Map,Image,T_val(k,:),width,height,xmin,ymin);
    buff(k).i =floor(Map);
    Update(k).i = UD;
end

save('results\MosaicingFull', 'buff','Update');



%% Write to  video
% write to video
v = VideoWriter('results\MappingFull.avi');
v.FrameRate = 8; % Framerate
open(v);
%%
for k = 1:length
    writeVideo(v,uint8(buff(k).i));
end
%%
close(v);