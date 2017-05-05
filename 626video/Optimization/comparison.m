%%
clear all;

load('Optimized_626');
load('Optimized_626_sift');

FigSize = [15 11];
smallFigSize = [12 8];

%%

hfig=figure(1);
plot(time,T_val(:,4),'b',time_sift,nT_val_sift(:,4),'r--');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('with POC','with SIFT','Location','Best')
pfig = pubfig(hfig);
pfig.FigDim = FigSize;
% expfig('results\thetaCompared_POCsift','-pdf');
% pfig.FigDim =  smallFigSize;
% % expfig('results\thetaCompareds_POCsift','-pdf');

hfig=figure(2);
plot(time,T_val(:,3),'b',time_sift,nT_val_sift(:,3),'r--');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('with POC','with SIFT','Location','Best')
pfig = pubfig(hfig);
pfig.FigDim = FigSize;
% expfig('results\thetaCompared_POCsift','-pdf');
% pfig.FigDim =  smallFigSize;
% % expfig('results\thetaCompareds_POCsift','-pdf');

hfig=figure(3);
plot(time,T_val(:,2),'b',time_sift,nT_val_sift(:,2),'r--');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('with POC','with SIFT','Location','Best')
pfig = pubfig(hfig);
pfig.FigDim = FigSize;

hfig=figure(4);
plot(time,T_val(:,4),'b',time_sift,nT_val_sift(:,4),'r--');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('with POC','with SIFT','Location','Best')
pfig = pubfig(hfig);
pfig.FigDim = FigSize;

