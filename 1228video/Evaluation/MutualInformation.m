function mu = MutualInformation(img1,img2, grad)

if(~(size(img1)==size(img2)))
    error('IMG size is differnt!');
end
    
[height,width] = size(img1);
Total = height * width;

%% ��f�̊K���ɂ���ăq�X�g�O�����̒i���͈قȂ�
hist1= zeros(grad,1);
hist2= zeros(grad,1);
hist12= zeros(grad);

%% �q�X�g�O�����쐬
Igrad = 256/grad;
for i = 1:height
    for j = 1:width
      a = floor(double(img1(i,j))/Igrad);
      b = floor(double(img2(i,j))/Igrad);
      hist1(a+1)=hist1(a+1)+1;
      hist2(b+1)=hist2(b+1)+1;
      hist12(a+1,b+1)=hist12(a+1,b+1)+1;
    end
end
% figure;
% imshow(hist12);

%% �m���ւƃR���o�[�g
hist1=hist1/Total;
hist2=hist2/Total;
hist12=hist12/Total;

%% ���ݏ��ʂ̌v�Z
% log0������n���ɖʓ|�������c
H1 = 0;
H2 = 0;
H12 = 0;
for i=1:grad
    for j =1:grad
        if(not(hist12(i,j)==0))
            H12 = H12 - hist12(i,j)*log2(hist12(i,j));
        end
    end
    if(not(hist1(i)==0))
        H1 = H1 - hist1(i)*log2(hist1(i));
    end
    if(not(hist2(i)==0))
        H2 = H2 - hist2(i)*log2(hist2(i));
    end    
end
mu = H1+H2-H12;

end