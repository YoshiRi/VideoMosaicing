function val = EvalImg(Map,refMap,opt);

M = Map;
R = refMap;

R(find(~Map)) = 0; % find 0 row and put 0
M(find(~refMap)) = 0; % find 0 row and put 0

inum = numel(find(M));


if strcmp(opt,'SSD')
val = sqrt(SSD(M,R) / inum);
elseif strcmp(opt,'MI')
val =  MutualInformation(M,R,16);
end