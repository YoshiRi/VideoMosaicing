function [Xest_n,P_n]=update(Xest,P,Map,Landmark,frame)

% observe Noise
Qbase = diag([0.01 0.01 0.1 0.001].^2);

[Y ,List, covs, Lands]= observation(Xest,Map,Landmark,frame);

Xest_old = Xest;

for i = 1:length(List)
    Num = List(i);% nanbanme
    Q = Qbase .* covs(i); % Observation covariance

    % Measured res and Landmark    
    y = Y(i,:)';
    Land = Lands(i,:)';
    % Estimated Landmark
    yhat = estimate_observation(Xest(1:4),Xest_old(4*Num+1:4*Num+4,1)); % estimated from state

    % If it is newly observed points, Initilize it
    if Xest(4*Num+1:4*Num+4,1) == [0 0 0 0]'
        Xest(4*Num+1:4*Num+4,1) = Land;
        yhat = y;
        display(Land);
        display(Num);
    end
    
    % make transform matrix F
    F = zeros(4*2,size(Xest,1));
    F(1:4,1:4) = diag([1 1 1 1]);
    F(5:8,4*Num+1:4*Num+4) = diag([1 1 1 1]);

    % make jacob matrix
    H = makejacob(Xest,Num) * F;
    % Kalman Gain
%     display(H*P*H'+Q);
    K = P*H'/(H*P*H'+Q);
    % update robot state
    Xest = Xest + K*(y-yhat);
    % update covariance matrix
    P = (eye(size(P)) - K*H)*P;
end

Xest_n = Xest;
% Xest_n(4) = Xest_old(4);
P_n = P;
end

function H = makejacob(Xest,Num)
X = Xest(1:4);
k = exp(X(4));
cs = k*cosd(X(3));
sn = k*sind(X(3));
LX = Xest(4*Num+1:4*Num+4);

dX = LX - X;
dx = dX(1); dy = dX(2);

Px = sn*dx + cs*dy;
Py = cs*dx - sn*dy;

Hr = [-cs sn Px -Py;
          -sn -cs -Py -Px;
          0 0 -1 0;
          0 0 0 -1];
Hl = [cs -sn 0 0;
          sn cs 0 0;
          0 0 1 0;
          0 0 0 1];
      
H = [Hr,Hl];
end

function [Y,List,covs,Land]=observation(Xest,Map,Ln,frame)
% initialize 
List = [];
covs = [];
Y = [];
Land = [];

len = length(Ln);
for i =1:len
    Num = Ln(i); % Location Num
    if Num > frame
        peak = Map(frame,Num,5);
        val = squeeze(Map(frame,Num,1:4));
    elseif Num < frame
        peak = Map(Num,frame,5);
        val = squeeze(Map(Num,frame,1:4));
    elseif Num == frame
        peak = 1;
        val = [0 0 0 0]';
    end
    
    % if has relation add pole
    if peak > 0.1
        covs = [covs; peak2covs(peak)];
        List = [List; i];
        Land = [Land;estimate_landpose(Xest,val)']; % estimate land pose
        Y =[Y;val'];
    end
        
end



end


function covs  = peak2covs(peak)
% consider only two types

if peak == 1
    covs = 0.01; % almost true
elseif peak > 0.5 
    covs = 2;
elseif peak > 0.2
    covs = 8;
else 
    covs = 1000;
end

end

function [Land]=estimate_landpose(Xest,dX)
% robot pose
X = Xest(1:4);
k = exp(X(4));
cs = cosd(X(3));
sn = sind(X(3));

Ainv = [cs/k sn/k 0 0 ;
             -sn/k cs/k 0 0;
             0 0 1 0;
             0 0 0 1];

Land = X + Ainv*dX;
end

function [dX]=estimate_observation(Xest,Land)
% robot pose
X = Xest(1:4);
k = exp(X(4));
cs = k*cosd(X(3));
sn = k*sind(X(3));

A = [cs -sn 0 0 ;
         sn cs 0 0;
          0 0 1 0;
          0 0 0 1];

dX= A*( Land - X );
end
