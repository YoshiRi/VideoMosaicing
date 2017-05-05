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

evaled_n = zeros(length,2);
for k=1:length
    evaled_n(k,1)=EvalImg(Updaten(k).i,refMap,'SSD');
    evaled_n(k,2)=EvalImg(Updaten(k).i,refMap,'MI');
end

save('results\comparison','evaled','evaled_n')


%% plot and showing
load('results\comparison');
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
imshow(refMap(183:662,1:618),[0 255])
title('Ground Truth');

%% Checking Final Results
final=buff(length).i(183:662,1:618);
finaln=buffn(length).i(183:662,1:618);
GT = refMap(183:662,1:618);
GTn = GT;

GT(find(~final)) = 0;
GTn(find(~finaln)) =0;

figure(4);
imshow(abs(GT-final),[0 255]);

figure(5);
imshow(abs(GTn-finaln),[0 255]);


%% bad region

figure(6);
imshow(Update(107).i(183:662,1:618),[0 255])

figure(7);
GT = refMap(183:662,1:618);
GT(find(~Update(107).i(183:662,1:618))) = 0;
imshow(abs(GT-Update(107).i(183:662,1:618)),[0 255])

%%
figure;
ALL = EvalImg(buff(length).i,refMap,'SSD');
N = EvalImg(buffn(length).i,refMapn,'SSD');

bar([1,2],[ALL,N]);
set( gca, 'XTickLabel', {'Proposed','Conventional'} )
ylabel('RMS Error')
grid on;