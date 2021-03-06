% need value map and weight map
function [v A] = solve_Mapping(valMap,wMap)

% if size(valMap) ~= size(wMap)
%     display(size(valMap));
%     display(size(wMap));
%     error('size of Map must be the same size');
% end

% 係数行列Aの計算 : Mapより1つ小さい
n=size(wMap,1);
% 対角成分の計算
diagAvec = sum(wMap,1).' + sum(wMap,2);     % 縦足す横
diagA = diag(diagAvec(2:n));                                      % 1行目はいらない

tri = wMap(2:n,2:n); 
A = -tri+diagA-tri.';

% ベクトルBの計算
BMap = wMap .* valMap;
Bb = sum(BMap,1).' - sum(BMap,2);                 % 縦引く横
B= Bb(2:n);

v = A\B;
end