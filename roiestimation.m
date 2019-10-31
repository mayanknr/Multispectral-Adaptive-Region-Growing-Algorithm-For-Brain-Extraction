function roi_img=primary_threshold()
    m=loadminc('t1_icbm_normal_1mm_pn3_rf20.mnc');
    [n,dim1,dim2]=size(m);
    temp=zeros(dim1,dim2);
    
    hist=zeros(1,256);
    
    for l=1:n
        for i=1:dim1
            for j=1:dim2
                temp(i,j)=m(l,i,j);
            end    
        end
        
        hist=hist+(imhist(temp))';
    end
    
    for i=2:256
        hist(i)=hist(i)+hist(i-1);
    end
    
    %hist=ceil(hist/n);
    flag=0;
    
    
    total_pixels=n*dim1*dim2;
    
    t2=ceil(0.02*total_pixels);
    t98=floor(0.98*total_pixels);
    
    
    
    for i=1:256
        
            if hist(i)<t2
                t2=i;
            end
            
        
            if hist(i)>t98 && flag==0
                t98=i;
                flag=1;
            end
        
    end    
    
    
    
    for l=1:n
        for i=1:dim1
            for j=1:dim2
                if(t98<=m(l,i,j) || t2>=m(l,i,j))
                    m(l,i,j)=0;
                end    
            end    
        end
    end
    
    roi_img=zeros(n,dim1,dim2);
    
    for l=1:n
        for i=1:dim1
            for j=1:dim2
                if(m(l,i,j)>=ceil((t98-t2)*0.1+t2))
                    roi_img(l,i,j)=1;
                end    
            end    
        end
    end

end