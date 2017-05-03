%% still have some problem in making map size and calc setting position

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


length = size(nT_val,1); % 行列と配列の長さ
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
refMapn = Map;

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

refMapn(Amin(1):Amax(1),Amin(2):Amax(2))=double(GT(Bmin(1):Bmax(1),Bmin(2):Bmax(2)));
refMapn_c = refMapn(Amin(1):Amax(1),Amin(2):Amax(2)); %cropped one
save('results\refMapn','refMapn','refMapn_c');


%% Make 
bwid = size(Map,2);
bhei = size(Map,1);
buffn = struct('i',zeros(bwid,bhei,'uint8'));
Updaten = struct('i',zeros(bwid,bhei,'double'));

%% Image Mosaicing
length = size(T_val,1);

% put value and mosaicing
for k=1:length
    display(k);
    Image = double(s(k).cdata);
    [Map, UD]= FillMap_Eval(Map,Image,nT_val(k,:),width,height,xmin,ymin);
    buffn(k).i =floor(Map);
    Updaten(k).i = UD;
end



%% Evaluating
evaled = zeros(length,2);

for k=1:length
    evaled(k,1)=EvalImg(Updaten(k).i,refMapn,'SSD');
    evaled(k,2)=EvalImg(Updaten(k).i,refMapn,'MI');
end

figure(3);
plot(evaled(:,1));
figure(4);
plot(evaled(:,2));

%% save
save('results\MosaicingNeighbor', 'buffn','Updaten','refMapn');

%% Write to  video
% % write to video
% v = VideoWriter('results\Mapping.avi');
% v.FrameRate = 8; % Framerate
% open(v);
% for k = 1:length
%     writeVideo(v,uint8(buff.i(k)));
% end
% 
% close(v);