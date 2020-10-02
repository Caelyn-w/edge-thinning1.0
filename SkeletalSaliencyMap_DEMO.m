clc
clear
addpath('Funcs');
addpath('Evaluation');

SRC='Data\test_img';
RES='Data\result';
srcSuffix = '.png'; % Please note to modify the file form
files = dir(fullfile(SRC, strcat('*', srcSuffix)));

%%
for m=1:length(files)

    close all
    disp(m);
    
    srcName = files(m).name;
    noSuffixName = srcName(1:end-length(srcSuffix));
    srcImg = imread(fullfile(SRC, srcName));
    
    [h,l,ch]=size(srcImg);
    
    if ch==1 % Binary images   
        srcImg=im2bw(srcImg, 0.82);  % !!! Truncated threshold (modifiable)
        Using_Gauss_band=true;    
    end
    
    srcImg3=srcImg;

    % Timing starts
    tic
    if Using_Gauss_band  % Binary images
    
         [row,col]=size(srcImg);
          
         srcImg=bwmorph(srcImg,'clean');
         srcImg=bwmorph(srcImg,'fill'); 

         [boundary,L] = bwboundaries(srcImg,'holes');
         all_edge_points=[];
         for aa=1:size(boundary,1)
             wide_boundary=boundary{aa,1};
             edge_points=sub2ind([row,col],wide_boundary(:,1),wide_boundary(:,2));
             all_edge_points=[all_edge_points;edge_points];
         end

         [new_out_map,out_show]=DistanceProperty1(boundary,row,col);
         new_out_map(logical(~srcImg))=0; % Delete the outer axis
         [A,B]=meshgrid(1:1:l,1:1:h);
                
    end
    toc
   
    %% Save the results 
    
    if Using_Gauss_band
        out_map1=new_out_map;
    end
    
    result3=out_map1/max(out_map1(:));
    result_bian=zeros(size(result3,1),size(result3,2),3); 
    result_bian(:,:,1)=result3*255;
    result_bian(:,:,2)=result3*255;
    result_bian(:,:,3)=result3*255;
    result_bian(all_edge_points)=255;
    result_bian(all_edge_points+(h*l))=0;
    result_bian(all_edge_points+(2*h*l))=0;
    imwrite(uint8(result_bian),[RES '\' noSuffixName '_ourmap.png']);% our skeletal saliency map

    rf0=graythresh(result3)/9; % !!! Truncated threshold (modifiable)
    ep_map=result3>rf0;
    imwrite(ep_map,[RES '\' noSuffixName '_skeleton.png']); 
    rgb_result=zeros(h,l,3);
    axis_ind=find(ep_map);
    
    if ch==1
        rgb_result(:,:,1)=255*srcImg3;
        rgb_result(:,:,2)=255*srcImg3;
        rgb_result(:,:,3)=255*srcImg3;
        rgb_result(axis_ind)=255;
        rgb_result(axis_ind+l*h)=0;
        rgb_result(axis_ind+2*l*h)=0;
    else
        rgb_result=srcImg3;
        rgb_result(axis_ind)=255;
        rgb_result(axis_ind+l*h)=0;
        rgb_result(axis_ind+2*l*h)=0;
    end
    
    imwrite(uint8(rgb_result),[RES '\' noSuffixName '_rgb_axis1.png']); 
    
 end    
