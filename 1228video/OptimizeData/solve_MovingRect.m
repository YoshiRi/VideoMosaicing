 % need value map and weight map
function val = solve_MovingRect(valMap,wMap,Ws)

% if size(valMap) ~= size(wMap)
%     display(size(valMap));
%     display(size(wMap));
%     error('size of Map must be the same size');
% end

%% found number
n=size(valMap,1);
length = n-Ws+1; %window size

val = zeros(n-1,1);

vpast = 0;
for k=1:length
    VM=valMap(k:k+Ws-1,k:k+Ws-1);
    WM=wMap(k:k+Ws-1,k:k+Ws-1);
    v = solve_Mapping(VM,WM);
    val(k) = v(1)+vpast;
    vpast = val(k);
end
val(n-2) = v(2)+vpast;
val(n-1) = v(3)+vpast;

end