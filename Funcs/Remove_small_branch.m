function [ new_map  ] = Remove_small_branch( map ,len )
%REMOVE_SMALL_BRANCH 
   
     BL0=bwlabel(map);
     % Get rid of the little branches on the boundary
     index=[];
     for k=1:max(BL0(:))
        
         ijk=(BL0==k);
         if numel(find(ijk))<len
             disp('small edge');
             continue;
         end
         tmp_map=zeros(size(map));
         tmp_map(ijk)=1;
         tmp_map=bwmorph(tmp_map,'thin');
         tmp1=trace_boundary(tmp_map,len);
         index=[index;find(tmp1)];
     end
     new_map=zeros(size(map));
     new_map(index)=1; 


end


function new_map=trace_boundary(map,len) 
    new_map=map;
    branches_num=0;
    branches=Find_Branches(map);
    if ~isempty(branches)
          branches_idx=sub2ind(size(map),branches(:,1),branches(:,2));
          b_t=zeros(size(map));
          b_t(branches_idx)=1; 
          BT=bwlabel(b_t);
          branches_num=max(BT(:)); % The number of branching points
    end
   
    startpoint=StartPoint(map);
    tmp=cell(size(startpoint,1),1); % Stores pixels that pass from a starting point to a branching point
    [row,col]=size(map);
    neigh8=[-1,-1;0,-1;1,-1;1,0;1,1;0,1;-1,1;-1,0];
    if isempty(startpoint) 
        disp('circle');
    elseif size(startpoint,1)==2 && isempty(branches)
        disp('no branches');
    elseif size(startpoint,1)==1 && isempty(branches)
        disp('isolated point');
        new_map(startpoint(1),startpoint(2))=0; % Remove outliers
    else
        label=false(size(map));
        si=false(size(startpoint,1),1); 
        next=startpoint;
        
        while(1)
            next_save=zeros(size(startpoint,1),2);
            for i=1:size(startpoint,1)
                if si(i)
                    continue;
                end
               sub=next(i,:);
               label(sub(1),sub(2))=true;
               neighbors=repmat(sub,size(neigh8,1),1)+neigh8;
               sig=neighbors(:,1)<1 |neighbors(:,1)>row |neighbors(:,2)<1|neighbors(:,2)>col;
               if any(sig)
                   neighbors(sig,:)=[];
               end
               neighbors_ind=sub2ind(size(map),neighbors(:,1),neighbors(:,2));
               id=find( map(neighbors_ind) & label(neighbors_ind)==false );
               if numel(id)==1
                   tmp{i,1}=[tmp{i,1};sub];
                   next_save(i,:)=neighbors(id,:);
               elseif numel(id)>1 % Branch point
                   tmp{i,1}=[tmp{i,1};sub];
                   si(i)=true;
                   
               else
                   disp('not considered');
               end 
            end
    
             next=next_save;
             loc=ismember(next,branches,'rows');
             si(loc)=true;
             if any(si)
                 break;
             end
            
%                  
        end
        
        ij=find(si,1);
        if size(tmp{ij,1},1)<len
           t=tmp{ij,1};
           t_ind=sub2ind(size(map),t(:,1),t(:,2));
           new_map(t_ind)=0;
        end
        new_map=bwmorph(new_map,'thin');
%             for p=1:size(startpoint,1)
%                 if size(tmp{p,1},1)< len  && si(p) %阈值长度 小于5 认为是小分支
%                     t=tmp{p,1};
%                     t_ind=sub2ind(size(map),t(:,1),t(:,2));
%                     new_map(t_ind)=0;
%                 end
%             end
       
            
    end
    if ~isempty(find(new_map-map)) 
        disp('递归');
        new_map=bwmorph(new_map,'thin');
%         figure;subplot(1,2,1);imshow(new_map);subplot(1,2,2);imshow(map);
        new_map=trace_boundary(new_map,len);
       
    end
end

function branches=Find_Branches(map)
        neigh8=[-1,-1;0,-1;1,-1;1,0;1,1;0,1;-1,1;-1,0];
        branches=[];
        [row,col]=size(map);
        idx=find(map);
        [u,v]=ind2sub(size(map),idx);
        for i=1:size(u,1)
            current=[u(i),v(i)];
            neighbors=repmat(current,size(neigh8,1),1)+neigh8;
            sig=neighbors(:,1)<1 |neighbors(:,1)>row |neighbors(:,2)<1|neighbors(:,2)>col;
               if any(sig)
                   neighbors(sig,:)=[];
               end
             neighbors_idx=sub2ind(size(map),neighbors(:,1),neighbors(:,2));
            if numel( find(map(neighbors_idx)))>2
               branches=[branches;current]; 
            end
        end

end
