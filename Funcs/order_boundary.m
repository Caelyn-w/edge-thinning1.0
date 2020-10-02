% This function is used to make the 2D mass points be in order
% output: orderpoints N*2 points are in order can be connected one by one to a polygon
% intput: points N*1 
%  maps : the boundary points are 1 the other area is 0

function orderpoints=order_boundary(points_mess,maps)

	[h,w]=size(maps);
	label=false(size(maps));
	orderpoints=[];
    [points_x,points_y]=ind2sub(size(maps),points_mess);
	% points=ind2sub(size(maps),points_mess);
    s=size(points_x,1);
	start=[points_x(1),points_y(1)]; %
	label(start(1),start(2))=true;
	 
	for i=1:size(points_x,1)
    start_x=start(1);
    start_y=start(2);
	orderpoints=[orderpoints;start];
	 
	 top_x=start_x-1; %top
	 top_y=start_y;
	 if(top_x<1)
	 fprintf('top touch the edge!\n');
	 else 
	     if( maps(top_x,top_y)==1 && label(top_x,top_y)==false )
	        label(top_x,top_y)=true;
			start=[top_x,top_y];
			continue;
		end
	 end
	
	 left_top_x=start_x-1; % top_left
	 left_top_y=start_y-1;
	 if(left_top_x<1||left_top_y<1)
	 fprintf('left top touch the edge!\n');
	 else
	   if(maps(left_top_x,left_top_y)==1 && label(left_top_x,left_top_y)==false)
			label(left_top_x,left_top_y)=true;
			start=[left_top_x,left_top_y];
			continue;
	   end
	 end
	
	 left_x=start_x; % left
	 left_y=start_y-1;
	 if(left_y<1)
	 fprintf('left touch the edge!\n');
	 else
	    if(maps(left_x,left_y)==1 && label(left_x,left_y)==false)
			label(left_x,left_y)=true;
			start=[left_x,left_y];
			continue;
		end
	 end
	
	left_down_x=start_x+1;% left down
	left_down_y=start_y-1;
	if(left_down_x>h || left_down_y<1 )
		fprintf('left down touch the edges!\n');
	else
		if(maps(left_down_x,left_down_y)==1 && label(left_down_x,left_down_y)==false)
			label(left_down_x,left_down_y)=true;
			start=[left_down_x,left_down_y];
			continue;
		end
	end
	
	down_x=start_x+1; % down
	down_y=start_y;
	if(down_x>h)
	fprintf('down touch the edge!\n');
	else
	   if(maps(down_x,down_y)==1 && label(down_x,down_y)==false)
	       label(down_x,down_y)=true;
		   start=[down_x,down_y];
		   continue;
		end
	end
	
	
	right_down_x=start_x+1;% right down 
	right_down_y=start_y+1;
	if(right_down_x>h || right_down_y>w)
		fprintf('right down touch the edge!\n');
	else
		if(maps(right_down_x,right_down_y)==1 && label(right_down_x,right_down_y)==false)
			label(right_down_x,right_down_y)=true;
			start=[right_down_x,right_down_y];
			continue;
		end 
	end
	
	right_x=start_x;% right
	right_y=start_y+1;
	if(right_y>w)
	    fprintf('right touch the edge!\n');
	else
		if(maps(right_x,right_y)==1 && label(right_x,right_y)==false)
			label(right_x,right_y)=true;
			start=[right_x,right_y];
			continue;
		end
	end
	
	right_up_x=start_x-1;% right up 
	right_up_y=start_y+1;
	if(right_up_x<1 || right_up_y>w)
		fprintf('right up touch the edge!\n');
	else
		if(maps(right_up_x,right_up_y)==1 && label(right_up_x,right_up_y)==false)
			label(right_up_x,right_up_y)=true;
			start=[right_up_x,right_up_y];
			continue;
		end
	end
	 
		fprintf('all points dont fit the request! so is it an end point?\n ');
	    break; %
	
	end %for

%     figure;
%     xx=[orderpoints(:,1),[orderpoints(2:end,1);orderpoints(1,1)] ];
%     yy=[orderpoints(:,2),[orderpoints(2:end,2);orderpoints(1,2)] ];
%     plot(xx,yy,'r-o');
end % function

