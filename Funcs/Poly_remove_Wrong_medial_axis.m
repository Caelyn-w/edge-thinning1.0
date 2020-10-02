function [ new_dist_map,BL_test,n_dist_map] = Poly_remove_Wrong_medial_axis( projectors ,dist_map ,edge_map)
%  POLY_REMOVE_WRONG_MEDIAL_AXIS 

        n_dist_map=dist_map;
        idx=(dist_map>0);
        dist=dist_map(idx);
        min_dist=min(dist);
        max_dist=max(dist);
        [row,col]=size(dist_map);
        bin=0.01;
        bin_idx=min_dist:bin:max_dist;
        histgram=cell(size(bin_idx,1),1);
        mean_histgram=zeros(size(bin_idx,1),1);
        num_histgram=zeros(size(bin_idx,1),1);
        for i=1:length(bin_idx)
            s=find(dist>bin_idx(i) & dist<=bin_idx(i)+bin);
            if isempty(s)
                histgram{i,1}=[];
                mean_histgram(i)=0;
                num_histgram(i)=0;
            else
                histgram{i,1}=dist(s);
                mean_histgram(i)=mean(dist(s));
                num_histgram(i)=size(s,1);
            end
            
        end
        num_sum=cumsum(num_histgram);
        percent=0.93;
        ii= find(num_sum>percent*num_sum(end),1);
        
        ep=bin_idx(ii); % Set the threshold
        
        test_map=dist_map>ep;
        BL_test=bwlabel(test_map); 
        nn=max(BL_test(:));
        thin_map0=bwmorph(test_map,'thin'); 
        
        thin_map=Extend_edge(thin_map0);
        
       % Look for breakpoints to prepare for calculating projection points and removing false axes
        le=4;
        aroundpoints=Around_Startpoints(edge_map,le);
        
        iid=find(thin_map>0);
        [sub_u,sub_v]=ind2sub([row,col],iid);
        sub_all=[sub_u,sub_v];
        si=sub_all(:,1)==1|sub_all(:,1)==row |sub_all(:,2)==1 |sub_all(:,2)==col;
        if any(si)
             edge_start=sub_all(si,:);
        else
            edge_start=[];
        end
        original_thin_map=thin_map;
        
        P1=projectors(:,:,1);
        P2=projectors(:,:,2);

        projectors_th=4; % If the distance between projection points is less than this value, it is considered to be almost the same projection point
%         if isempty(edge_start)
%             disp('无边界起始中轴点');
%         end
  
        label=zeros(row,col);
        len=8;
        if ~isempty(aroundpoints)
            
            for cc=1:size(edge_start,1)
                 fprintf('%d 条\n',cc);
                 [new_map,new_label]=Remove_wrong_pixel(label,thin_map,P1,P2,edge_start(cc,:),len,projectors_th,aroundpoints); % Recursion removes the error axis 
                 thin_map=new_map;
                 label=new_label;
            end
            
        end
        new_dist_map=thin_map;
        
        BL=bwlabel(thin_map);
        number=max(BL(:));
        len0=8;
        for ab=1:number
            n_every=find(BL==ab);
            if size(n_every,1)<len0
                thin_map(n_every)=0;
            end
        end

%         figure;
%         imshow(thin_map);
%         title('减掉小边');
        
        cha=original_thin_map-thin_map;
        sp=StartPoint(cha);
        cha_ind0=find(cha);
        cha_ind=setdiff(cha_ind0,sp); 
        [sub_uu,sub_vv]=ind2sub([row,col],cha_ind);
      
        neigh8=[-1,-1;0,-1;1,-1;1,0;1,1;0,1;-1,1;-1,0];
        pang_delete=[];
        for  dd=1:size(cha_ind,1)
            current=[sub_uu(dd),sub_vv(dd)];
            neighbors=repmat(current,size(neigh8,1),1)+neigh8;
            s0=neighbors(:,1)<1 |neighbors(:,1)>row |neighbors(:,2)<1 |neighbors(:,2)>col;
            if any(s0)
                neighbors(s0,:)=[];
            end
            pang_delete=[pang_delete;neighbors];
        end
        pang_delete=unique(pang_delete,'rows');
        pang_delete_ind=[];
        if ~isempty(pang_delete)
             pang_delete_ind=sub2ind([row,col],pang_delete(:,1),pang_delete(:,2));
        end
        BL_test(pang_delete_ind)=0;
%         figure;
%         imshow(BL_test);
%         title('胖的删掉');
        n_dist_map(pang_delete_ind)=0;
        thin_fat_ind=setdiff(find(thin_map),find(BL_test)); 
        
        n_dist_map(thin_fat_ind)=dist_map(thin_fat_ind);
end

function [thin_map,label]= Remove_wrong_pixel(label,thin_map,P1,P2,start_point,len,projectors_th,aroundpoints)

        
         around_id=sub2ind(size(thin_map),aroundpoints(:,1),aroundpoints(:,2));
         neigh8=[-1,-1;0,-1;1,-1;1,0;1,1;0,1;-1,1;-1,0];
         [row,col]=size(thin_map);
         start_ind=sub2ind([row,col],start_point(:,1),start_point(:,2));
         jilu_point=start_ind;
         label(start_ind)=true;
         start_projectors=sort([P1(start_ind),P2(start_ind)]); 
         [start_projector1_sub_u,start_projector1_sub_v]=ind2sub([row,col],start_projectors(1));
         start_projector1_sub=[start_projector1_sub_u,start_projector1_sub_v]; 
         [start_projector2_sub_u,start_projector2_sub_v]=ind2sub([row,col],start_projectors(2));
         start_projector2_sub=[start_projector2_sub_u,start_projector2_sub_v];
       
         
         while(1)
             
             neighbors0=repmat(start_point,size(neigh8,1),1)+neigh8;
             biaoji1=neighbors0(:,1)<1 | neighbors0(:,1)>row | neighbors0(:,2)<1 |neighbors0(:,2)>col;
             if any(biaoji1)
                 neighbors0(biaoji1,:)=[];
             end
             neighbors0_ind=sub2ind([row,col],neighbors0(:,1),neighbors0(:,2));
             biaoji2=logical(label(neighbors0_ind));
             if any(biaoji2)
                  neighbors0_ind(biaoji2,:)=[];
                  neighbors0(biaoji2,:)=[];
             end
        
             biaoji3= find(thin_map(neighbors0_ind));
             
             % Whether the bifurcation point: ==1 no bifurcation, >1 bifurcation, ==0 end
             if size(biaoji3,1)==1
                 start_point=neighbors0(biaoji3,:);
                 start_ind=neighbors0_ind(biaoji3,:); 
                 
             elseif size(biaoji3,1)>1
                 next_several_starts=neighbors0(biaoji3,:);
                 next_several_starts_ind=sub2ind([row,col],next_several_starts(:,1),next_several_starts(:,2));
                 label(next_several_starts_ind)=true; 
                 new_next_starts=[];
                 for ij=1:size(next_several_starts,1)
                  
                     nei0=repmat(next_several_starts(ij,:),size(neigh8,1),1)+neigh8;
                    
                     sii=nei0(:,1)<1 |nei0(:,1)>row |nei0(:,2)<1 |nei0(:,2)>col;
                     if any(sii)
                         nei0(sii,:)=[];
                     end
                     nei0_ind=sub2ind([row,col],nei0(:,1),nei0(:,2));
                     n_nei0=find(thin_map(nei0_ind));
                     nei_valid=nei0_ind(n_nei0,:);
                     nei0_sub_valid=nei0(n_nei0,:);
                     ijk=find(label(nei_valid)==0);
                     
                     new_next_starts=[new_next_starts;nei0_sub_valid(ijk,:)];
                     
                     
                 end
               new_next_starts=unique(new_next_starts,'rows');
                 
                 for pp=1:size(new_next_starts,1) 
                      t_map=thin_map;
                      label_t=label;
                      disp('traverse');
                      [thin_map,label]=Remove_wrong_pixel(label_t,t_map,P1,P2,new_next_starts(pp,:),len,projectors_th,aroundpoints);
                  end
                
             elseif size(biaoji3,1)==0
                 disp('traverse over');
                 break;
             end
             
       
             start_point_ind=start_ind;
             now_projectors=sort([P1(start_point_ind),P2(start_point_ind)]);
             projector1=now_projectors(1);
             projector2=now_projectors(2);
             [projector1_sub_u,projector1_sub_v]=ind2sub([row,col],projector1);
             projector1_sub= [projector1_sub_u,projector1_sub_v];
             [projector2_sub_u,projector2_sub_v]=ind2sub([row,col],projector2);
             projector2_sub=[projector2_sub_u,projector2_sub_v];
             label(start_point_ind)=true;
             loc=ismember(now_projectors,around_id);
             
             if ((sqrt(sum((projector1_sub-start_projector1_sub).^2,2))<=projectors_th && sqrt(sum((projector2_sub-start_projector2_sub).^2,2))<=projectors_th ) ...
               || (sqrt(sum((projector2_sub-start_projector1_sub).^2,2))<=projectors_th && sqrt(sum((projector1_sub-start_projector2_sub).^2,2))<=projectors_th ))...
               && all(loc)
                 jilu_point=[jilu_point;start_point_ind];
               
             else %The distance of the projection point is greater than the value
                 if size(jilu_point,1)>len
                     thin_map(jilu_point(1:end-1))=0; 
                     jilu_point=[start_point_ind];
                     start_projector1_sub=projector1_sub;
                     start_projector2_sub=projector2_sub;
                 elseif size(jilu_point,1)>1
                     huitui_point=jilu_point(2);
                     
                     start_projector1_sub=ind2sub([row,col],P1(huitui_point));
                     start_projector2_sub=ind2sub([row,col],P2(huitui_point));
                     label(jilu_point(3:end))=false;
                     jilu_point=[huitui_point];
                    continue;
                 elseif size(jilu_point,1)==1
                     jilu_point=start_point_ind;
                     start_projector1_sub=projector1_sub;
                     start_projector2_sub=projector2_sub;
                     continue;
                 end
                   
                 
             end
              
         end   
         if size(jilu_point,1)>len
             thin_map(jilu_point(1:end-1))=0;
         end
             
     
     
end

        
            
 



