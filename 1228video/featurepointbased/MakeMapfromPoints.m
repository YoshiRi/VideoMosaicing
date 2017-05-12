%% Put value
load('featurepoints');
load('VideoImages');

addpath('C:\Users\yoshi\Documents\MATLAB\SIFT\');

% initialize
time = zeros(Numframes,1);

valMap = zeros(Numframes,Numframes,4); % buff
peakMap = zeros(Numframes,Numframes,2);
Err=0;

% save refimage
RefFramenum = 1;
RF = s(1).cdata;
RFnum = 1;

vidObj.FrameRate = 15;
cx = 128;
cy = 128;

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
%%
save(strcat('1228FullMap_SIFTr.mat'));
