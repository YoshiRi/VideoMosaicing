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


%% reload data
load('results\MosaicingRecursive.mat');

evaled_r = zeros(length,2);
for k=1:length
    evaled_r(k,1)=EvalImg(Updater(k).i,refMapr,'SSD');
    evaled_r(k,2)=EvalImg(Updater(k).i,refMapr,'MI');
end

save('results\comparison_r','evaled','evaled_n','evaled_r')

%% plot and showing
fr = ndgrid(1:length);

hfig=figure(1);
plot(fr,evaled(:,1),'b',fr,evaled_n(:,1),'r--',fr,evaled_r(:,1),'g-.',[1 351],[0 0],'c-');
grid on;
xlabel('frame number');
ylabel('error')
legend('with Full Infromation','with Neighbor Information','with Recursive Method','Ideal','Location','best')
title('Average Squared Difference for Tracked Image')
pfig = pubfig(hfig);
pfig.LegendLoc = 'best';
expfig('results\ssdcomparer','-pdf');

hfig=figure(2);
plot(fr,evaled(:,2),'b',fr,evaled_n(:,2),'r--',fr,evaled_r(:,2),'g-.',[1 351],[1 1],'c-');
grid on;
xlabel('frame number');
ylabel('evaluated value')
legend('with Full Infromation','with Neighbor Information','with Recursive Method','Ideal','Location','best')
title('Mutual Infromation for Tracked Image')
pfig = pubfig(hfig);
pfig.LegendLoc = 'best';
expfig('results\micomparer','-pdf');

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

