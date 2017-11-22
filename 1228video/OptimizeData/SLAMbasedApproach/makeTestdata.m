function [Map,GroundTruth] = makeTestdata()

datalength = 5;

GroundTruth = zeros(datalength,4);

GroundTruth(:,1) = 0.6 * ndgrid(1:datalength,1);
GroundTruth(:,2) = - 0.2 *ndgrid(1:datalength,1);
GroundTruth(:,4) =  log(1 + (50 - ndgrid(1:datalength,1))/500) ;
GroundTruth(:,3) =  20 * sind( ndgrid(1:datalength,1)) ;

Ns = datalength + 1;
Noise = cat(3, 0.01 * randn(Ns,Ns,2), 0.02 * randn(Ns,Ns,1), 0.001 * randn(Ns,Ns,1));
Peaks = 0.6*ones(Ns,Ns);
%% ÉfÅ[É^seisei
rawMap = remakemap(GroundTruth);

Map = cat(3,rawMap,Peaks);

end

function Map = remakemap(v)

n = size(v,1)+1;
m = size(v,2);
Map = zeros(n,n,m);

Map(1,2:n,4) = v(:,4);
Map(1,2:n,3) = v(:,3);

for i = 2:n-1
    for j = i+1:n
        Map(i,j,3) =  Map(1,j,3) - Map(1,i,3);
        Map(i,j,4) =  Map(1,j,4) - Map(1,i,4);
    end
end

for i = 2:n-1
    for j = i+1:n
        dx = [Map(1,j,1) - Map(1,i,1)];
        dy = [Map(1,j,2) - Map(1,i,2)];
        cs = cosd(Map(i,j,3))*exp(Map(i,j,4));
        sn = sind(Map(i,j,3))*exp(Map(i,j,4));
        Map(i,j,1) = cs*dx-sn*dy;
        Map(i,j,2) = sn*dy +cs*dx;
    end
end


end