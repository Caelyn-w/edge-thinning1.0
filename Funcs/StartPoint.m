function [ startpoints ] = StartPoint( map )
% Find the end of the boundary
[h,w]=size(map);
edgepoints=find(map);
[edge_u,edge_v]=ind2sub(size(map),edgepoints);

neigh=[-1,-1;0,-1;1,-1;1,0;1,1;0,1;-1,1;-1,0];
startpoints=[];
for k=1:length(edge_u)
     i=edge_u(k);
     j=edge_v(k);
      neighsub=repmat([i,j],size(neigh,1),1)+neigh;
      id= neighsub(:,1)<1 | neighsub(:,1)>h | neighsub(:,2)<1 | neighsub(:,2)>w;
      if ~isempty(find(id,1))
          neighsub(id,:)=[];
      end
      neighidx=sub2ind(size(map),neighsub(:,1),neighsub(:,2));
      if length(find(map(neighidx)))<=1
          startpoints=[startpoints;i,j];
      end
   
end

end

