%% get accurate reference from map
close all
clear all


% Get whole map
load('../Extraction/626EXPFullMap');
refnumMap = peakMap;


FigSize = [15 11];
smallFigSize = [12 8];
%% Get value Map
pmat = refnumMap(:,:,2); % get map 
minpeak = 0.075;
Bpmat = im2bw(pmat,minpeak);                        % Get binarized pmat
Spmat = Bpmat.*pmat;                                       % Get sparse peakmat

figure(1);
imshow(Bpmat);
ylabel('Reference Image Number');
xlabel('Compared Image Number');

%% kuso syuusei
n = size(time,1);
time(n) = time(n-1)*2 - time(n-1);
 
 %% 1. solve theta equation
 T_val = zeros(size(valMap,1),4);                         % put the true value
 nT_val = zeros(size(valMap,1),4);                         % put the unchi value
 sT_val = zeros(size(valMap,1),4);
 
 CtaMap = valMap(:,:,4);                                     % get theta map
 rCtaMap = CtaMap .* Bpmat;                              % get theta map
nMap = triu(ones(size(Bpmat)),1) - triu(ones(size(Bpmat)),2); % neighbor map

[T_val(2:n,4),H] = solve_Mapping(rCtaMap,Bpmat);
figure(2);
plot(time,T_val(:,4));
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('Estimated Reference with FullMap')

nT_val(2:n,4) = solve_Mapping(rCtaMap,nMap);
figure(3);
plot(time,nT_val(:,4),'r--');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('Estimated Reference with Neighbor Information')

hfig=figure(4);
plot(time,T_val(:,4),'b',time,nT_val(:,4),'r--');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('with Full Relation','with Neighbor Relation','Location','Best')
pfig = pubfig(hfig);
pfig.FigDim = FigSize;
expfig('results\thetaCompared','-pdf');
pfig.FigDim =  smallFigSize;
expfig('results\thetaCompareds','-pdf');


sT_val(2:n,4) = solve_Mapping(rCtaMap,Spmat);
figure(5);
plot(time,sT_val(:,4));
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('Estimated Reference with FullMap')

figure(6);
plot(time,T_val(:,4),'b',time,nT_val(:,4),'r--',time,sT_val(:,4),'m-.');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('with Map Information','with Neighbor Information','with weighted Map Information','Location','Best')


%% 2. solve kappa equation
KMap = valMap(:,:,3);                                        % get kappa map
lKMap = log(KMap);                                            % make log scale map
lKMap(~isfinite(lKMap))=0;

lnkappa = solve_Mapping(lKMap,Bpmat);          % solve linear equation
slnkappa = solve_Mapping(lKMap,Spmat);          % solve linear equation
nlnkappa = solve_Mapping(lKMap,nMap);          % solve linear equation


T_val(2:n,3) = exp(lnkappa);                                 % kappa 
T_val(1,3) = 1;                                 % kappa 
sT_val(2:n,3) = exp(slnkappa);                                 % kappa 
sT_val(1,3) = 1;                                 % kappa 
nT_val(2:n,3) = exp(nlnkappa);                                 % kappa 
nT_val(1,3) = 1;                                 % kappa 


figure(7);
plot(time,T_val(:,3));
xlabel('time [s]');
ylabel('Scaling ');
grid on;
legend('Estimated Reference with FullMap')

hfig=figure(8);
plot(time,T_val(:,3),'b',time,nT_val(:,3),'r--');
xlabel('time [s]');
ylabel('Scaling ');
grid on;
legend('with Full Relation','with Neighbor Relation','Location','Best')
pfig = pubfig(hfig);
pfig.FigDim =  FigSize;
expfig('results\scalingCompared','-pdf');
pfig.FigDim =  smallFigSize;
expfig('results\scalingCompareds','-pdf');


figure(9);
plot(time,T_val(:,3),'b',time,nT_val(:,3),'r--',time,sT_val(:,3),'m-.');
xlabel('time [s]');
ylabel('Scaling ');
grid on;
legend('with Full Relation','with Neighbor Information','with weighted Map Information','Location','Best')

%% 3. solve translation equation
 TMap = valMap(:,:,1:2);
 
 CtaMap2 = repmat(T_val(:,4),1,n);
 KMap2 = repmat(T_val(:,3),1,n);
 csMap = cosd(CtaMap2) .* KMap2;
 snMap = sind(CtaMap2) .* KMap2;

TrMapx = csMap .* TMap(:,:,1) + snMap.* TMap(:,:,2);
TrMapy = -snMap .* TMap(:,:,1) + csMap.* TMap(:,:,2);

 CtaMap2 = repmat(nT_val(:,4),1,n);
 KMap2 = repmat(nT_val(:,3),1,n);
 csMap = cosd(CtaMap2) .* KMap2;
 snMap = sind(CtaMap2) .* KMap2;
nTrMapx = csMap .* TMap(:,:,1) + snMap.* TMap(:,:,2);
nTrMapy = -snMap .* TMap(:,:,1) + csMap.* TMap(:,:,2);



T_val(2:n,1) = solve_Mapping(TrMapx,Bpmat);          % solve linear equation
T_val(2:n,2) = solve_Mapping(TrMapy,Bpmat);          % solve linear equation
sT_val(2:n,1) = solve_Mapping(TrMapx,Spmat);          % solve linear equation
sT_val(2:n,2) = solve_Mapping(TrMapy,Spmat);          % solve linear equation
nT_val(2:n,1) = solve_Mapping(nTrMapx,nMap);          % solve linear equation
nT_val(2:n,2) = solve_Mapping(nTrMapy,nMap);          % solve linear equation


hfig=figure(10);
plot(time,T_val(:,2),'b',time,nT_val(:,2),'r--');
xlabel('time [s]');
ylabel('y axis translation [pix]');
grid on;
legend('with Full Relation','with Neighbor Relation','Location','Best')
pfig = pubfig(hfig);
pfig.FigDim =  FigSize;
expfig('results\yCompared','-pdf');
pfig.FigDim =  smallFigSize;
expfig('results\yCompareds','-pdf');


hfig=figure(11);
plot(time,T_val(:,1),'b',time,nT_val(:,1),'r--');
xlabel('time [s]');
ylabel('x axis translation [pix]');
grid on;
legend('with Full Relation','with Neighbor Relation','Location','Best')
pfig = pubfig(hfig);
pfig.FigDim =  FigSize;
expfig('results\xCompared','-pdf');
pfig.FigDim =  smallFigSize;
expfig('results\xCompareds','-pdf');


figure(15);
plot(T_val(:,1),T_val(:,2),'b',nT_val(:,1),nT_val(:,2),'r--',T_val(1,1),T_val(1,2),'bo',T_val(n,1),T_val(n,2),'bx');
xlabel('x axis [pix]');
ylabel('y axis [pix]');
grid on;
legend('with Map Information','with Neighbor Information','Start','Goal','Location','Best')


figure(12);
plot(time,T_val(:,2),'b',time,nT_val(:,2),'r--',time,sT_val(:,2),'m-.');
xlabel('time [s]');
ylabel('y axis translation [pix]');
grid on;
legend('with Map Information','with Neighbor Information','with weighted Map Information','Location','Best')

figure(13);
plot(time,T_val(:,1),'b',time,nT_val(:,1),'r--',time,sT_val(:,1),'m-.');
xlabel('time [s]');
ylabel('x axis translation [pix]');
grid on;
legend('with Map Information','with Neighbor Information','with weighted Map Information','Location','Best')

%% show
hv = diag(H);
figure(14);
plot(2:n,hv);
grid on;
xlabel('frame number')
ylabel('sum of weight')
legend('Sum of Weights')

%% save the result
save('Optimized_626','T_val','nT_val','time');