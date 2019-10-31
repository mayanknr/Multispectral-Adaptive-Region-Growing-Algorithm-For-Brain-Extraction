%initial central slice slice(x,y)
%sliced mask is M(x,y)
for i=1:y
    for j=1:z
        slice(i,j)=im(ceil(x/2),i,j);
    end
end

        
 %otsu thersholding       
M(x,y)=graythresh(slice(x,y));
se=[0 1 0;1 1 1;0 1 0];

%erosion
M(x,y)=imerode(M(x,y),se);

%largest connected component
CC = bwconncomp(M(x,y));
   numOfPixels = cellfun(@numel,CC.PixelIdxList);
   [unused,indexOfMax] = max(numOfPixels);
   biggest = zeros(size(B));
   biggest(CC.PixelIdxList{indexOfMax}) = 1;
   M(x,y)=biggest;

 %dilation
 M(x,y)=imdilate(M(x,y),se);
 