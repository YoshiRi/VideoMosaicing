clear all;
close all;

load('results\MosaicingFull.mat');

%%
length = size(buff,2);
resmap=buff(length).i(183:662,1:618);

%% load neighbor
load('results\MosaicingNeighbor.mat');

length = size(buffn,2);
neimap=buffn(length).i(183:662,1:618);

%% figure out

hfig1 = figure(1);
imshow(resmap,[0 255]);
pfig1 = pubfig(hfig1);
expfig('results\FullMap','-pdf');

hfig2 = figure(2);
imshow(neimap,[0 255]);
pfig2 = pubfig(hfig2);
expfig('results\NeighborMap','-pdf');


%% Show the difference
load('results\refMap');

hfig = figure(3);
imshow(refMap(183:662,1:618),[0 255])
title('Ground Truth');
pfig = pubfig(hfig);
expfig('results\groundtruth','-pdf');

GT = refMap(183:662,1:618);
GTn = GT;

GT(find(~resmap)) = 0;
GTn(find(~neimap)) =0;

hfig=figure(4);
imshow(abs(GT-resmap),[0 255]);
pfig = pubfig(hfig);
expfig('results\diffFull','-pdf');

hfig=figure(5);
imshow(abs(GTn-neimap),[0 255]);
pfig = pubfig(hfig);
expfig('results\diffNeighbor','-pdf');
