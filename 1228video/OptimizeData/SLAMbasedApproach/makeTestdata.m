function Map = makeTestdata()

datalength = 350;

GrandTruth = zeros(datalength,4);

GrandTruth(:,1) = 0.6 * ndgrid(1:datalength,1);
GrandTruth(:,2) = - 0.2 *ndgrid(1:datalength,1);
GrandTruth(:,4) =  log(1 + (50 - ndgrid(1:datalength,1))/500) ;
GrandTruth(:,3) =  20 * sind( ndgrid(1:datalength,1)) ;

Noise = cat(3, 0.01 * randn(datalength,datalength,2), 0.02 * randn(datalength,datalength,1), 0.001 * randn(datalength,datalength,1));
Peaks = 0.6*ones(datalength,datalength);
scale = ndgrid(2:datalength,1);
%% ÉfÅ[É^seisei
rawMap = remakemap(GroundTruth);
Map = cat(3,rawMap+Noise(:,:,4),Peaks);

end

function Map = remakemap(v)

n = size(v,1)+1;
m = size(v,2);
Map = zeros(n,n,m);

Map(1,2:n,4) = v(:,4);
Map(1,2:n,3) = v(:,3);

for i = 2:n-1
    for j = i+1:n
        Map(i,j,3) =  Map(1,j,3) - Map(1,i.3);
        Map(i,j,4) =  Map(1,j,4) - Map(1,i.4);
    end
end

for i = 2:n-1
    for j = i+1:n
        Map(i,j) =  Map(1,j) - Map(1,i);
    end
end


end