function [RB,RN,RU]=seedregions(roi_img,M,k);
%determine seed region

%fund cumulative histogram for every slice
%where k is the kth slice
 m=loadminc('t1_icbm_normal_1mm_pn3_rf20.mnc');
    [n,dim1,dim2]=size(m);


temp=zeros(dim1,dim2);
    
    hist=zeros(256,1);
    size(hist)
    for l=1:k
        for i=1:dim1
            for j=1:dim2
                temp(i,j)=m(l,i,j);
            end    
        end
        
        hist=hist+imhist(temp);
    end
    
    
   % hist=ceil(hist/k);
    
    for i=2:256
        hist(i)=hist(i)+hist(i-1);
    end    
 
    total_pixels=n*dim1*dim2;
    
    
    t80=0.8*total_pixels;
    
    for i=1:256
       if hist(i)<t80
                t80=i;
       end
    end
        
       
rg_seeds=zeros(dim1,dim2);
for i=1:dim1
    for j=1:dim2
        if(roi_img(i,j)>=t80)
            rg_seeds(i,j)=0;
        else
            rg_seeds(i,j)=1;
        end
    end
end
%disp(rg_seeds);
% %classifying seed regions
% %get connected components
L=bwlabel(rg_seeds,8);
[r,c]=size(L);
no_cc=max(max(L));
%disp(L);
%disp(no_cc);
%       RB=cell(1,1);
%       RN=cell(1,1);
%       count1=1;
%       count2=1;
      RB=zeros(r,c);
      RN=zeros(r,c);
      RU=zeros(r,c);
      
     C1=L; 
for i=1:no_cc
      t=0;
      q=0;
     L=C1;
    for j=1:r
        for k=1:c
            if(L(j,k)~=i)
                L(j,k)=0;
            end
            
        end
    end 
    %find length of cc
    [rno,cno]=find(L==i);
    rc=[rno cno];
    p= size(rc);
    
   [ne,nb]=size(intersect(L,M));
   if(ne==0 && p(1)>=5)
       RN=RN+(L/i);
       q=1;
   end
    if(ne~=0 && p(1)>=5)
       RB=RB+(L/i);
       %count1=count1+1;
       t=1;   
   end
   
   if(t~=1 && q~=1)
       RU=RU+(L/i);
   end
end
%disp(RN);
end

       
       

       

