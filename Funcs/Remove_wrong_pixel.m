function [thin_map,label]= Remove_wrong_pixel(label,thin_map,P1,P2,start_point,len,projectors_th)
% The input is a point coordinate start_point 
% similar to a recursive traversal of the tree
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
            % Those that have been marked should be removed 
             biaoji3= find(thin_map(neighbors0_ind));
             
             % Split point or not: ==1 no     >1 yes     ==0 the end
             if size(biaoji3,1)==1
                 start_point=neighbors0(biaoji3,:);
                 start_ind=neighbors0_ind(biaoji3,:); % next point
                 
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
                 
                 for pp=1:size(new_next_starts,1) % trace 
                      t_map=thin_map;
                      label_t=label;
                      disp('ตÝน้');
                      [thin_map,label]=Remove_wrong_pixel(label_t,t_map,P1,P2,new_next_starts(pp,:),len,projectors_th);
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
             
             if (sqrt(sum((projector1_sub-start_projector1_sub).^2,2))<=projectors_th && sqrt(sum((projector2_sub-start_projector2_sub).^2,2))<=projectors_th )...
                || (sqrt(sum((projector2_sub-start_projector1_sub).^2,2))<=projectors_th && sqrt(sum((projector1_sub-start_projector2_sub).^2,2))<=projectors_th )
                 jilu_point=[jilu_point;start_point_ind]; % To record what has been traversed
               
             else 
                 if size(jilu_point,1)>len
                     thin_map(jilu_point)=0;
                     jilu_point=[start_point_ind];
                     start_projector1_sub=projector1_sub;
                     start_projector2_sub=projector2_sub;
                 else
                     jilu_point=[start_point_ind];
                     start_projector1_sub=projector1_sub;
                     start_projector2_sub=projector2_sub;
                    continue;
                 end
                   
                 
             end
              
         end   
         if size(jilu_point,1)>len
             thin_map(jilu_point)=0;
         end
             
     figure;imshow(thin_map);
     
end

        
            
 




