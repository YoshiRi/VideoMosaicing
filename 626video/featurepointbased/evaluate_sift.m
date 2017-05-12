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

%% from matches
[~,des1,loc1] = sift_ri(AI);
[~,des2,loc2] = sift_ri(BI);

[Xi ,Err] = SIFT2POCparam(des1,loc1,des2,loc2,cx,cy);

%% use cv_tools
addpath('C:\Users\yoshi\Documents\MATLAB\rvctools_cv');
startup_rvc;
%% added for sift
%     run('C:\Users\yoshi\Documents\MATLAB\vlfeat-0.9.20\toolbox\vl_setup')
addpath('C:\Users\yoshi\Documents\MATLAB\vlfeat-0.9.20\toolbox\noprefix');
% for surf use
addpath('C:\Users\yoshi\Documents\MATLAB\OpenSURF_version1c');
%%
asf = isurf(AI);
bsf = isurf(BI);
mt = FeatureMatch(asf,bsf,10)