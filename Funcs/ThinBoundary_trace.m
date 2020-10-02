function [ boundary_in_order ] = ThinBoundary_trace( boundarymap )
% THINBOUNDARY_TRACE  BoundaryMap is a binary map
% The purpose of this function is to store all the boundaries in the cell array in order according to the input single pixel binary-valued boundary graph.
% The first column of cell is the starting point of a boundary, and the second column is the sorted boundary point
        L=bwlabel(boundarymap,8);
        num=max(L(:));
        [row,col]=size(boundarymap);
        neigh8=[-1,-1;0,-1;1,-1;1,0;1,1;0,1;-1,1;-1,0]; 
        boundary_in_order=cell(num,2);
        for i=1:num
            id=find(L==i);
            [subu,subv]=ind2sub(size(boundarymap),id);
            boundary_in_order{i,2}=[subu,subv];
            
            startpoint=[];
            for j=1:size(id,1)
               current_sub=[subu(j),subv(j)];
               neighbors=repmat(current_sub,size(neigh8,1),1)+neigh8;
               s=neighbors(:,1)<1 |neighbors(:,1)>row |neighbors(:,2)<1 |neighbors(:,2)>col;
               if ~isempty(s)
                   neighbors(s,:)=[];
               end
               neighbors_ind=sub2ind([row,col],neighbors(:,1),neighbors(:,2));
               n= size( find(boundarymap(neighbors_ind)),1);
                  if n<2
                      startpoint=[startpoint;current_sub]; % Noncircular boundary
                  end
            end
             
            if isempty(startpoint)
                startpoint=[subu(1),subv(1)]; % Closed ring boundary
            end
            boundary_in_order{i,1}=startpoint;
            bmap=zeros(row,col);
            bmap(id)=1;
            b_order=bwtraceboundary(bmap,startpoint(1,:),'N');
            if size(startpoint,1)>1
                 end_point=startpoint(2,:);
                  [si,Ii]=ismember(end_point,b_order,'rows');
                    if si
                      boundary_in_order{i,1}=b_order(1:Ii,:);
                    else 
                        disp('error');
                    end
            else % Closed boundary
                boundary_in_order{i,1}=b_order(1:end-1,:); % The end and the beginning coincide
            end
           
           
        end

end

