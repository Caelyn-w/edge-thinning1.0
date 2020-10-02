function [ newmap ] = Remove_Crosses( map )
%REMOVE_CROSSES 
        neigh8=[-1,-1;0,-1;1,-1;1,0;1,1;0,1;-1,1;-1,0];
        newmap=map;
        [row,col]=size(map);
        ind=find(map);
        [subu,subv]=ind2sub(size(map),ind);
        for i=1:size(ind,1)
            current=[subu(i),subv(i)];
            neighbors=repmat(current,size(neigh8,1),1)+neigh8;
            s= neighbors(:,1)<1 | neighbors(:,1)>row |neighbors(:,2)<1 |neighbors(:,2)>col ;
            if ~isempty(s)
                neighbors(s)=[];
            end
            ind_neighbors=sub2ind(size(map),neighbors(:,1),neighbors(:,2));
            num=size(find(map(ind_neighbors)),1);
            
            if num>=3 
                newmap(ind_neighbors)=0;
                newmap(ind(i))=0;
            end
            
        end


end

