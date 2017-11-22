function ShowErrorEllipse(xEst,PEst,ops)
%誤差分散円を計算し、表示する関数
Pxy=PEst(1:2,1:2);%x,yの共分散を取得
[eigvec, eigval]=eig(Pxy);%固有値と固有ベクトルの計算
%固有値の大きい方のインデックスを探す
if eigval(1,1)>=eigval(2,2)
    bigind=1;
    smallind=2;
else
    bigind=2;
    smallind=1;
end

chi=9.21;%誤差楕円のカイの二乗分布値　99%

%楕円描写
t=0:10:360;
a=real(sqrt(eigval(bigind,bigind)*chi));
b=real(sqrt(eigval(smallind,smallind)*chi));
x=[a*cosd(t);
   b*sind(t)];
%誤差楕円の角度を計算
angle = atan2(eigvec(bigind,2),eigvec(bigind,1));
if(angle < 0)
    angle = angle + 2*pi;
end

%誤差楕円の回転
R=[cos(angle) sin(angle);
   -sin(angle) cos(angle)];
x=R*x;
plot(x(1,:)+xEst(1),x(2,:)+xEst(2),ops)
