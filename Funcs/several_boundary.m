function [ boundary ] = several_boundary( srcimg )

srcimg=logical(srcimg);
N=bwlabel(~srcimg,8);% For a topology with a hole

num1=max(N(:));% The number of connected regions

boundary=cell(num1,1);
neigh4=[-1,0;0,-1;1,0;0,1];
[row,col]=size(srcimg);
for k=1:num1
    iii=find(k==N);    
    [subu,subv]=ind2sub(size(srcimg),iii);    
    for ij=1:size(subu,1)
        cur=[subu(ij),subv(ij)];
        neighbors=repmat(cur,4,1)+neigh4;
        si=neighbors(:,1)<1 |neighbors(:,1)>row |neighbors(:,2)<1 |neighbors(:,2)>col; 
        if any(si)  % Out of bounds
            neighbors(si,:)=[];
        end
        if ~isempty(neighbors)
           ind=sub2ind(size(srcimg),neighbors(:,1),neighbors(:,2));
           ss=logical(srcimg(ind));
%            disp(ss);
           if any(ss)
               start=neighbors(ss,:);
               start=start(1,:);
               break;
           end
        end
    end
   
    order_boundary= bwtraceboundary(srcimg,start,'S');
    
    boundary{k,1}=order_boundary;
end

end

