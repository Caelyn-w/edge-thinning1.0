function [ new_map ] = Process_several_points_in_boundary( map )
%DELETE_SEVERAL_POINTS_IN_BOUNDARY 

        [row,col]=size(map);
        idx=find(map);
        [id_u,id_v]=ind2sub([row,col],idx);

        s=(id_u==1 |id_u==row |id_v==1 |id_v==col);
        id_boundary=sub2ind([row,col],id_u(s),id_v(s));
        tmp=zeros(row,col);
        tmp(id_boundary)=1;
        B=bwlabel(tmp,8);
        num=max(B(:));
        neigh8=[-1,-1;0,-1;1,-1;1,0;1,1;0,1;-1,1;-1,0];
        for i=1:num
            ii=find(B==i);
            if size(ii,1)==1
                continue;
            else
                neibors=[];
                [u,v]=ind2sub([row,col],ii);
                sub=[u,v];
                for j=1:size(ii,1)
                    cur=[u(j),v(j)];
                    t_neighbors=repmat(cur,8,1)+neigh8;
                    p=t_neighbors(:,1)<1 |t_neighbors(:,1)>row |t_neighbors(:,2)<1 |t_neighbors(:,2)>col;
                    if ~isempty(p)
                        t_neighbors(p,:)=[];
                    end
                    neibors=[neibors;t_neighbors];
                    
                end
                 neibors=unique(neibors,'rows');
                 neibors_idx=sub2ind([row,col],neibors(:,1),neibors(:,2));
                
                 s0=(u==1); %µÚÒ»ÐÐ
                if any(s0)
                    s01=(neibors(:,1)==2 & map(neibors_idx)==1);
                    d= sqrt( sum((repmat(neibors(s01,:),size(sub,1),1)-sub).^2,2));
                    [min_value,I]=min(d);
                    s02=true(size(sub,1),1);
                    s02(I)=false;
                    delete_point=sub(s02,:);
                    delete_point_idx=sub2ind([row,col],delete_point(:,1),delete_point(:,2));
                    map(delete_point_idx)=0;
                end
                
                s1=(u==row);
                if any(s1)
                    s11=(neibors(:,1)==row-1 & map(neibors_idx)==1);
                    d= sqrt( sum((repmat(neibors(s11,:),size(sub,1),1)-sub).^2,2));
                    [min_value,I]=min(d);
                    s12=true(size(sub,1),1);
                    s12(I)=false;
                    delete_point=sub(s12,:);
                    delete_point_idx=sub2ind([row,col],delete_point(:,1),delete_point(:,2));
                    map(delete_point_idx)=0; 
                end
                
                s2=(v==1);
                if any(s2)
                    s21=(neibors(:,2)==2 & map(neibors_idx)==1);
                    d= sqrt( sum((repmat(neibors(s21,:),size(sub,1),1)-sub).^2,2));
                    [min_value,I]=min(d);
                    s22=true(size(sub,1),1);
                    s22(I)=false;
                    delete_point=sub(s22,:);
                    delete_point_idx=sub2ind([row,col],delete_point(:,1),delete_point(:,2));
                    map(delete_point_idx)=0;
                end
                
                s3=(v==col);
                if any(s3)
                   s31=(neibors(:,2)==col-1 & map(neibors_idx)==1);
                    d= sqrt( sum((repmat(neibors(s31,:),size(sub,1),1)-sub).^2,2));
                    [min_value,I]=min(d);
                    s32=true(size(sub,1),1);
                    s32(I)=false;
                    delete_point=sub(s32,:);
                    delete_point_idx=sub2ind([row,col],delete_point(:,1),delete_point(:,2));
                    map(delete_point_idx)=0;  
                end
            end

        end
        new_map=map;

end

