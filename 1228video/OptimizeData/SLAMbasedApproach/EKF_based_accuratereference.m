%% get accurate reference from map
clear all;
close all;
% Get whole map
load('../../extractData/1228FullMapr.mat');
%% Get value Map
pmat = refnumMap(:,:,2); % get map 
minpeak = 0.075;
Bpmat = im2bw(pmat,minpeak);                        % Get binarized pmat
Spmat = Bpmat.*pmat;                                       % Get sparse peakmat

figure(1);
imshow(Bpmat);
ylabel('Reference Image Number');
xlabel('Compared Image Number');

% make map
CtaMap = valMap(:,:,4);                                     % get theta map
KMap = valMap(:,:,3);                                        % get kappa map
lKMap = log(KMap);                                            % make log scale map
lKMap(~isfinite(lKMap))=0;

Map = cat(3,valMap(:,:,1:2),CtaMap,lKMap,Spmat);

%% kuso syuusei
time(n) = time(n-1)*2 - time(n-1);

%% for Initialization

% define length
len = size(Bpmat,1);
% number of location vector
Lnum =4;
Interval = floor(len/(Lnum));
Ln = 1:Interval:len;
Ln = Ln(2:end);

% covariance matrix and state
P = sparse(zeros(4*(1+Lnum)));
Xest = sparse(zeros(4*(1+Lnum),1));
% Initialize
P(5:end,5:end) = 1000*eye(4*Lnum);

% state noise
N = diag([0.02 0.02 0.05 0.001].^2);

%% start EKFSLAM

result.X = zeros(len,size(Xest,1));
result.P = zeros(size(P,1),size(P,2),len);

for frame = 1:len
    [Xest,P]=odmetry(Xest,Map,frame,P,N);
    [Xest,P]=update(Xest,P,Map,Ln,frame);
    result.X(frame,:) = Xest';
    result.P(:,:,frame) = P;
    % animation
    hold off;    
    hfig=figure(10);
    plot(Xest(1),Xest(2),'r*'); hold on 
    for i = 1:Lnum
        plot(Xest(1+4*i),Xest(2+4*i),'pg','MarkerSize',10); hold on;
        if [Xest(1+4*i),Xest(2+4*i)] ~= [0,0]
            ShowErrorEllipse(Xest(1+4*i:2+4*i),P(1+4*i:2+4*i,1+4*i:2+4*i),'g');hold on;
        end
    end
    ShowErrorEllipse(Xest(1:2),P,'r');hold on;
    plot(result.X(1:frame,1),result.X(1:frame,2),'k--');
    xlim([-400 400]);
    ylim([-400 400]);
    grid on;
    drawnow;
    pause(0.01);
end

%% show result debug
load('Truth');
figure(1);
plot(1:size(result.X,1),result.X(:,1),'r',1:size(Truth,1),Truth(:,1),'b--'); hold on 
plot(1:size(result.X,1),result.X(:,2),'m',1:size(Truth,1),Truth(:,2),'c--'); hold off


figure(2);
plot(1:size(result.X,1),result.X(:,3),'r',1:size(Truth,1),Truth(:,3),'b--');


figure(3);
plot(1:size(result.X,1),result.X(:,4),'r',1:size(Truth,1),Truth(:,4),'b--');

