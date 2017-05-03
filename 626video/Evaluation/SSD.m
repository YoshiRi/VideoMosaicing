function e = SSD(img1,img2)

if(~(size(img1)==size(img2)))
    error('IMG size is differnt!');
end
    
[height,width] = size(img1);
Total = height * width;


%% ãPìxç∑ÇÃSUM
MX = double(img1) - double(img2);

VX = reshape(MX,[1 numberofelements(MX)]);
VY = VX.';

e = VX * VY ;
end