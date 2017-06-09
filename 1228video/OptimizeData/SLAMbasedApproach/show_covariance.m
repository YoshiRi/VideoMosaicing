function show_covariance(P)

p = P(:);
Mp = max(p);
mp = min(p);

figure(100);
imshow(P,[mp Mp]);

lP = log(P);
lP(~isfinite(lP))=0;
p = lP(:);
Mp = max(p);
mp = min(p);

figure(101);
imshow(P,[mp Mp]);

end