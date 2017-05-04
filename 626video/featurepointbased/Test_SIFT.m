%% test for SIFT
clear all
close all
%%
addpath('C:\Users\yoshi\Documents\MATLAB\SIFT');
 
img1 = imread('image1.bmp');
img2 = imread('image2.bmp');

%% test program
show_match(img1,img2);

[p1 p2] = match_ri(img1,img2);
%%
[Param Affine] = Helmert2D(p1,p2);