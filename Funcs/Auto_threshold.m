function [ new_edge_img ] = Auto_threshold( img ,noframe)
%AUTO_THRESHOLD   The threshold of canny operator is automatically selected
RES='edge';
if ~exist(RES, 'dir')
    mkdir(RES);
end
 res='edge\';
 sigma=0.333;
 V=median(img(:));
 V=double(V);
 lower=(max(0, (1.0 - sigma) * V))/(255.0);
 upper = (min(255, (1.0 + sigma) * V))/(255.0);
 new_edge_img=edge(img,'canny',lower,upper);
%  figure;imshow(new_edge_img);title('auto');
imwrite(new_edge_img,[res  noframe '_' num2str(lower) '_' num2str(upper) '_method1.png']);
 
 % ostu's method
 
 upper1=graythresh(img);
 lower1=upper1*0.5;
 new_edge_img1=edge(img,'canny',lower1,upper1);
%  figure;imshow(new_edge_img1);title('ostu');
 imwrite(new_edge_img1 ,[res  noframe '_' num2str(lower1) '_' num2str(upper1) '_ostu.png']);
end

