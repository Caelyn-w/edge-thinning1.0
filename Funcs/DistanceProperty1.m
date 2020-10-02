function [ distance_value,distmap_show ] = DistanceProperty1( boundary,h,w )
% Calculate the projection symmetry measurement of each pixel in the shape

        neigh4=[-1,0;0,-1;1,0;0,1];
       
        distance_value=zeros(h,w);
        disp('is compute distance property');
        define_inf=2*(h+w);
        [B,A]=meshgrid(1:1:h,1:1:w);
        A=A';B=B';
        input_points=[B(:),A(:)]; 
        
        if size(boundary,1)==1 % the number of boundary = 1
                boundary=boundary{1};
                connect_dist1=sqrt(sum((boundary(2:end,:)-boundary(1:end-1,:)).^2,2)); 
                zong_len=sum(connect_dist1);
                connect_dist2=sqrt(sum(([boundary(2:end,:);boundary(1,:)]-boundary).^2,2));
                circle_len=sum(connect_dist2);

            for i=1:length(input_points)
                
                current_point=input_points(i,:);

                iid=sub2ind([h,w],current_point(:,1),current_point(:,2));
                points=repmat(current_point,4,1)+neigh4;
                si= points(:,1)<1 | points(:,1)>h |points(:,2)<1 | points(:,2)>w;
                if any(si)  % If at least one of the four neighborhoods is out of bounds
                    points(si,:)=[];
                end
                if size(points,1)<4
                    mmm=size(points,1);
                    combine=nchoosek(1:1:mmm,2);
                else
                      combine=nchoosek(1:1:4,2); 
                end

                point_on_boundary=zeros(size(points));
                index=zeros(size(points,1),1);
                for j=1:length(points)
                   cur_neigh=points(j,:);
                   dist=sqrt(sum((repmat(cur_neigh,size(boundary,1),1)-boundary).^2,2));
                   [min_V,I]=min(dist);
                   point_on_boundary(j,:)=boundary(I,:);
                   index(j)=I;
                end
                save_dist=zeros(size(combine,1),1);
                S=ones(size(combine,1),1);
                
                    for k=1:size(combine,1)
                         thestart=index(combine(k,1));
                         theend=index(combine(k,2));
                         startpoint=point_on_boundary(combine(k,1),:);
                         endpoint=point_on_boundary(combine(k,2),:);
                        if theend==thestart
                            d=0;
                        else

                            if thestart>theend
                                tmp=thestart;
                                thestart=theend;
                                theend=tmp;
                            end
                            distance=sum(connect_dist2(thestart:theend-1));
                            other_distance=circle_len-distance;
                            d=min(distance,other_distance);
                        end 
 
                        save_dist(k)=d;
                    end
                    
                    distance_value(iid)=max(save_dist.*S);
            end

        else  % the number of boundary > 1 
            
            boundary_content=[];
            xuhao=[];
            xuhao_in_each=[];
            neigh_dist=cell(size(boundary,1),1);
            len=zeros(size(boundary,1),1);
            for m=1:length(boundary)
                boundary_content=[boundary_content;boundary{m}];
                xuhao_in_each=[xuhao_in_each,1:1:length(boundary{m})];
                xuhao=[xuhao;repmat(m,size(boundary{m},1),1)]; % On which boundary
                neigh_dist{m}=sqrt(sum(([boundary{m}(2:end,:);boundary{m}(1,:)]-boundary{m}).^2,2)); % 如果是环就是这么长 如果不是环就去掉最后一个
                len(m)=sum(neigh_dist{m}); % If it's a ring, the total length is len
            end
            
            for jj=1:length(input_points)
                currentpoint=input_points(jj,:);
                neigh_point=repmat(currentpoint,4,1)+neigh4;
                sii=neigh_point(:,1)<1 | neigh_point(:,1)>h |neigh_point(:,2)<1 |neigh_point(:,2)>w;
                if any(sii)
                    neigh_point(sii,:)=[];
                end
                if size(neigh_point,1)<4 
                    mmm=size(neigh_point,1);
                    combine=nchoosek(1:1:mmm,2);
                else
                    combine=nchoosek(1:1:4,2); 
                end
                index=zeros(size(neigh_point,1),2); % The first column stores the ordinal number of the current point, and the second column stores the ordinal number of the current edge
                ii=sub2ind([h,w],currentpoint(:,1),currentpoint(:,2));
                
                for i=1:size(neigh_point,1)
                    cur=neigh_point(i,:); % Current neighborhoods
                    dist=sqrt(sum((repmat(cur,size(boundary_content,1),1)-boundary_content).^2,2));
                    [min_d,I]=min(dist);
                    index(i,1)=xuhao_in_each(I); 
                    index(i,2)=xuhao(I); 
                end
                save_dist=zeros(size(combine,1),1);
                for k=1:size(combine,1)
                    ind1=combine(k,1);
                    ind2=combine(k,2);
                   if  index(ind1,2)==index(ind2,2) % On the same boundary 
                      if index(ind1,1)==index(ind2,1)
                         d=0;
                      else
                          startpoint=min(index(ind1,1),index(ind2,1));
                          endpoint=max(index(ind1,1),index(ind2,1));
                          d=sum(neigh_dist{index(ind1,2)}(startpoint:endpoint));
                          
                          other_d=len(index(ind1,2))-d;
                          d=min(d,other_d);
                        
                      end
                      
                   else % Not on the same boundary
                       d=define_inf;
                       
                   end
                    save_dist(k)=d;
                end
                
                distance_value(ii)=max(save_dist);
                
            end
            
            
        end % Number of boundary
        
           distmap=distance_value;
           distmap_show=(distmap)/(max(distmap(:)));
       
end

