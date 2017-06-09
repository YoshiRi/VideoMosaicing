%% get accurate reference from map

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
Lnum = 20;
Interval = floor(len/(Lnum));
Ln = 1:Interval:len;
Ln = Ln(2:end);

% covariance matrix and state
P = sparse(zeros(4*(1+Lnum)));
Xest = sparse(zeros(4*(1+Lnum),1));
% Initialize
P(5:end,5:end) = 1000*eye(4*Lnum);

% state noise
N = diag([0.04 0.04 0.04 0.000001]);

%% start EKFSLAM

result.X = zeros(len,size(Xest,1));
result.P = zeros(size(P,1),size(P,2),len);

for frame = 1:100
    display(frame);
    [Xest,P]=odmetry(Xest,Map,frame,P,N);
    [Xest,P]=update(Xest,P,Map,Ln,frame);
    result.X(frame,:) = Xest';
    result.P(:,:,frame) = P;
end