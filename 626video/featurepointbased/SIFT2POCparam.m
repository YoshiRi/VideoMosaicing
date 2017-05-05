function [Para, FErr]=SIFT2POCparam(des1,loc1,des2,loc2,cx,cy)

[p1 ,p2] = matchfromPoints(des1,loc1,des2,loc2);
if size(p1,1) == 0
    FErr = -1;
    Para = 0;
    return;
end
    
p1 = p1 - repmat([cx cy],size(p1,1),1);
p2 = p2 - repmat([cx cy],size(p2,1),1);
[Para ,~ ,p1m ,p2m,FErr] = Helmert2D(p1,p2);

if FErr == -1
    return;
end
end