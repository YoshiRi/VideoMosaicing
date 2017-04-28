function [newMap , Update] = FillMap_Eval(Map,Image,val,width,height,xmin,ymin)

newMap = Map;                                                   % clone
Update = double(zeros(size(Map)));

crop = FindMinMax(val,width,height,xmin,ymin)
for i = crop(1,1) : crop(1,2)                               %minx to maxx
    for j = crop(2,1) : crop(2,2)
        iC = invConvertPosition([i;j],val,width,height,xmin,ymin);
        x1 = iC(1);
        y1 = iC(2);
        x2 = floor(x1);
        y2 = floor(y1);
        
        if x2 >= 1 && x1 <= size(Image, 2) && y2 >= 1 && y1 <= size(Image, 1)
            newMap(j,i) = LinearInterpolate(Image,x1,y1); % fill map with interpolation
            Update(j,i) = newMap(j,i);
        end        
        
    end
end

end


function crop = FindMinMax(val,width,height,xmin,ymin)
% crop = [minx maxx ;miny maxy] �A�������l

map = [1 1 width width;1 height 1 height];
pmap = ConvertPosition(map,val,width,height,xmin,ymin);

crop = zeros(2);
crop(1,1) = floor(min(pmap(1,:)));
crop(2,1) = floor(min(pmap(2,:)));
crop(1,2) = floor(max(pmap(1,:)));
crop(2,2) = floor(max(pmap(2,:)));
end

