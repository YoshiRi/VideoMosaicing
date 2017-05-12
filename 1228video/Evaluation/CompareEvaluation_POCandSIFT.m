%% open the data
clear all
close all


load('results\MosaicingNeighbor_sift.mat');
load('results\refMap_sift');
length = size(buff,2);

evaled_sift = zeros(length,2);
for k=1:length
    evaled_sift(k,1)=EvalImg(Update(k).i,refMap,'SSD');
    evaled_sift(k,2)=EvalImg(Update(k).i,refMap,'MI');
end
Update_sift = Update;
refMap_sift = refMap;
buff_sift = buff;
refMap_csift = refMap_c;

%% reload data
load('results\MosaicingFull.mat');
load('results\refMap');

evaled = zeros(length,2);

for k=1:length
    evaled(k,1)=EvalImg(Update(k).i,refMap,'SSD');
    evaled(k,2)=EvalImg(Update(k).i,refMap,'MI');
end


save('results\comparison_POCandSIFT','evaled','evaled_sift')

%% plot and showing
load('results\comparison_POCandSIFT');
load('results\refMap_sift');
refMap_sift = refMap;
refMap_csift = refMap_c;
load('results\refMap');

length = size(evaled,1);
fr = ndgrid(1:length);

hfig=figure(1);
plot(fr,evaled(:,1),'b',fr,evaled_sift(:,1),'r--');
grid on;
xlabel('frame number');
ylabel('error')
legend('with Full Relationship','with Neighbor Relationship (SIFT)','Location','best')
title('Root Mean Squared Difference for Tracked Image')
pfig = pubfig(hfig);
pfig.LegendLoc = 'best';
pfig.FigDim = [15 11];
expfig('results\ssdcompare_sift','-pdf');


hfig=figure(2);
plot(fr,evaled(:,2),'b',fr,evaled_sift(:,2),'r--');
grid on;
xlabel('frame number');
ylabel('evaluated value')
legend('with Full Relationship','with Neighbor Relationship (SIFT)','Location','best')
title('Mutual Infromation for Tracked Image')
pfig = pubfig(hfig);
pfig.LegendLoc = 'best';
pfig.FigDim = [15 11];
expfig('results\micompare_sift','-pdf');

%%
figure(3);
imshow(refMap,[0 255])
title('Ground Truth');
expfig('results\groundtruth','-pdf');

%% Checking Final Results
final=buff(length).i;
finaln=buff_sift(length).i;
GT = refMap;
GTn = refMap_sift;

GT(~final) = 0;
GTn(find(~finaln)) =0;
final(~GT) = 0;
finaln(~GTn) = 0;

figure(4);
imshow(abs(GT-final),[0 255]);
% expfig('results\fullmap_error','-pdf');
figure(5);
imshow(final,[0 255]);
% expfig('results\fullmap','-pdf');


figure(6);
imshow(abs(GTn-finaln),[0 255]);
expfig('results\neimap_sift_error','-pdf');
figure(7);
imshow(finaln,[0 255]);
expfig('results\neimap_sift','-pdf');
imshow(finaln(Amin(1):Amax(1),Amin(2):Amax(2)),[0 255]);
expfig('results\neimapc_sift','-pdf');


%% bad region
num = 200;

figure(8);
imshow(Update(num).i,[0 255])

figure(9);
GT = refMap;
GT(find(~Update(num).i)) = 0;
imshow(abs(GT-Update(num).i),[0 255])

%%
figure;
ALL = EvalImg(Update(length).i,refMap,'SSD');
N = EvalImg(Update_sift(length).i,refMap_sift,'SSD');

bar([1,2],[ALL,N]);
set( gca, 'XTickLabel', {'Proposed','Conventional'} )
ylabel('RMS Error')
grid on;