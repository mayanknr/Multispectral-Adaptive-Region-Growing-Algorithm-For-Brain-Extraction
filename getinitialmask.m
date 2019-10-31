function [M]=getinitialmask(im)
        
 %otsu thersholding       
level=graythresh(im);
M=imbinarize(im,level);

%erosion
se=strel('sphere',5);
M=imerode(M,se);


%largest connected component
M=bwareafilt(M,1);

 %dilation
 M=imdilate(M,se);
end
 