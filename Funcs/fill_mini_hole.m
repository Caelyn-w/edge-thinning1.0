function [ filledmap ] = fill_mini_hole( Binarymap )
% Binarymap deonotes the binary map  mianarea is 1 other is 0
% filledmap denotes the pictures has been filled 4 neighbors
  
[row,col]=size(Binarymap);
 k=4;
 d4=[-1,0;0,-1;1,0;0,1];
 % d8=[-1 -1;0 -1;1 -1;1 0;1 1;0 1;-1 1;-1 0];
for ii=2:row-1
    for jj=2:col-1
        
        number=0;
        for kk=1:k
           if Binarymap(ii+d4(kk,1),jj+d4(kk,2))==1
              number=number+1; 
           end
        end
        
        if Binarymap(ii,jj)==0 && number>=3
            Binarymap(ii,jj)=1;
        end
        
    end
end


filledmap=Binarymap;
end

