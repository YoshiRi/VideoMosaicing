function [Para, FErr]=POCestimationfromSIFT(img1,img2,flag)

[p1 ,p2] = match_ri(img1,img2);
c1 = size(img1)/2;
c2 = size(img2)/2;
p1 = p1 - repmat([c1(2) c1(1)],size(p1,1),1);
p2 = p2 - repmat([c2(2) c2(1)],size(p2,1),1);
[Para ,~ ,p1m ,p2m,FErr] = Helmert2D(p1,p2);

if FErr == -1
    return;
end
% show match
if flag
    p1m = p1m + repmat([c1(2) c1(1)],size(p1m,1),1);
    p2m = p2m + repmat([c2(2) c2(1)],size(p2m,1),1);
    show_match_clear(img1,img2,p1m,p2m);
end

end