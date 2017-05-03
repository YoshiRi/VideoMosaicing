%% open the data
clear all
close all

load('results\MosaicingFull.mat');
load('results\refMap');

length = size(buff,2);
evaled = zeros(length,2);

for k=1:length
    evaled(k,1)=EvalImg(Update(k).i,refMap,'SSD');
    evaled(k,2)=EvalImg(Update(k).i,refMap,'MI');
end

%% reload data
load('results\MosaicingNeighbor.mat');
load('results\refMapn');

evaled_n = zeros(length,2);
for k=1:length
    evaled_n(k,1)=EvalImg(Updaten(k).i,refMapn,'SSD');
    evaled_n(k,2)=EvalImg(Updaten(k).i,refMapn,'MI');
end

save('results\comparison','evaled','evaled_n')


%% plot and showing
load('results\comparison');
load('results\refMap');
load('results\refMapn');


length = size(evaled,1);
fr = ndgrid(1:length);

hfig=figure(1);
plot(fr,evaled(:,1),'b',fr,evaled_n(:,1),'r--');
grid on;
xlabel('frame number');
ylabel('error')
legend('with Full Relationship','with Neighbor Relationship','Location','best')
title('Root Mean Squared Difference for Tracked Image')
pfig = pubfig(hfig);
pfig.LegendLoc = 'best';
pfig.FigDim = [15 11];
expfig('results\ssdcompare','-pdf');


hfig=figure(2);
plot(fr,evaled(:,2),'b',fr,evaled_n(:,2),'r--');
grid on;
xlabel('frame number');
ylabel('evaluated value')
legend('with Full Relationship','with Neighbor Relationship','Location','best')
title('Mutual Infromation for Tracked Image')
pfig = pubfig(hfig);
pfig.LegendLoc = 'best';
pfig.FigDim = [15 11];
expfig('results\micompare','-pdf');

%%
figure(3);
imshow(refMap_c,[0 255])
title('Ground Truth');
expfig('results\groundtruth','-pdf');

%% Checking Final Results
final=buff(length).i;
finaln=buffn(length).i;
GT = refMap;
GTn = refMapn;

GT(~final) = 0;
GTn(find(~finaln)) =0;

figure(4);
imshow(abs(GT-final),[0 255]);
expfig('results\fullmap_error','-pdf');
figure(5);
imshow(final,[0 255]);
expfig('results\fullmap','-pdf');

figure(6);
imshow(abs(GTn-finaln),[0 255]);
expfig('results\neimap_error','-pdf');
figure(7);
imshow(finaln,[0 255]);
expfig('results\neimap','-pdf');


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
ALL = EvalImg(buff(length).i,refMap,'SSD');
N = EvalImg(buffn(length).i,refMapn,'SSD');

bar([1,2],[ALL,N]);
set( gca, 'XTickLabel', {'Proposed','Conventional'} )
ylabel('RMS Error')
grid on;