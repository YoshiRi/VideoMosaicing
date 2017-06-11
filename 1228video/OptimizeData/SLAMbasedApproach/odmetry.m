function [Xest_n,P_n]=odmetry(Xest,Map,frame,P,N)
if frame == 1
    dX = [0 0 0 0]';
    peak = 1;
else
    dX = squeeze(Map(frame-1,frame,1:4));
    peak = Map(frame-1,frame,5);
end

len = size(P,1);

%% (1) state varying
Cta = Xest(3);
sn = sind(Cta);
cn = cosd(Cta);
invs = 1/exp(Xest(4));

A = [invs*cn, invs*sn, 0, 0;
        -invs*sn, invs*cn, 0, 0;
        0,0,1,0;
        0,0,0,1];

Diff =  A*dX;

Fx = sparse(zeros(4,4*(len+1)));
Fx(1:4,1:4)= eye(4);
% update
Xest_n = Xest;
Xest_n(1:4) = Xest(1:4) + Diff;
% Xest_n = Xest+Fx'*Diff;

%% (2) Covariance Varying
P_n = P;
N = N*peak2covs(peak);

Prr = P(1:4,1:4);
Prm = P(1:4,5:end);

%Jacobian
Jr = [1 0 invs*(-sn*dX(1)+ cn*dX(2)) -Diff(1);
         0 1 invs*(-cn*dX(1)- sn*dX(2)) -Diff(2);
         0 0 1 0;
         0 0 0 1];
Ju = [cn*invs sn*invs 0 0;
          -sn*invs cn*invs 0 0;
          0 0 1 0;
          0 0 0 1];

% update
  P_n(1:4,1:4) = Jr*Prr*Jr' + Ju*N*Ju';
  P_n(1:4,5:end) = Jr*Prm;
  P_n(5:end,1:4) = P_n(1:4,5:end)';
end

function covs  = peak2covs(peak)
% consider only two types

if peak == 1
    covs = 0.01; % almost true
elseif peak > 0.2 
    covs = 1;
else
    covs = 4;
end
end
