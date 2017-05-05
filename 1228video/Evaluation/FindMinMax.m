function crop = FindMinMax(val,width,height,xmin,ymin)
% crop = [minx maxx ;miny maxy] ’A‚µ®”’l

map = [1 1 width width;1 height 1 height];
pmap = ConvertPosition(map,val,width,height,xmin,ymin);

crop = zeros(2);
crop(1,1) = floor(min(pmap(1,:)));
crop(2,1) = floor(min(pmap(2,:)));
crop(1,2) = floor(max(pmap(1,:)));
crop(2,2) = floor(max(pmap(2,:)));
end
