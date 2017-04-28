function val = EvalImg(Map,refMap,opt);

Omega = zeros(size(Map));
inum = numel(find(Map));

RMap = refMap;
RMap(find(~Map)) = 0; % find 0 row and put 0


if strcmp(opt,'SSD')
val = SSD(Map,RMap) / inum;
elseif strcmp(opt,'MI')
val =  MutualInformation(Map,RMap,16);
end