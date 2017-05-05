addpath('C:\Users\yoshi\Documents\GitHub\POCprogram');
addpath('C:\Users\yoshi\OneDrive\GitHub\2016117\videoreader\RIPOC_function');
AI = imread('normal.bmp');
BI = imread('light.bmp');
BI = AI;

 
%% ƒTƒCƒYŒˆ’è
[height, width ] = size(AI);
 cy = height/2;
 cx = width/2;

 % Translation, rotation and scaling
 BI = imtranslate(BI,[40, -10]);
 BI = ImageRotateScale(BI,-100,1.2,height,width);

 %%
[Param,~]= POCestimationfromSIFT(AI,BI,1)

%%
RIPOC_func(AI,BI)

%%
[~,des1,loc1] = sift_ri(AI);
[~,des2,loc2] = sift_ri(BI);

[Xi ,Err] = SIFT2POCparam(des1,loc1,des2,loc2,cx,cy);

