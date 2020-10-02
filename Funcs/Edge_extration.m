function [ edge_map ] = Edge_extration( bw,smap,len)
%EDGE_EXTRATION 
% bw is the a binary image
% Smap is a saliency map
% len is the size of expansion and contraction
   disp('sssssssssssssssssssssssssssssssssssss');
     s_v=smap(:); 
    [N,Edges]=histcounts(s_v,50);
    mean_saliency=mean(smap(:));
   
   
    if sum(N(10:end),2)/(size(smap,1)*size(smap,2))<0.15
        mean_saliency=mean_saliency*3;
    end
    mean_saliency=mean(smap(:));
    smap(smap>mean_saliency*2)=1;
    
    se1=strel('square',len);
    erode_img1=imerode(smap,se1); 
    dilate_img1=imdilate(smap,se1);
    se2=strel('square',ceil(len/2));
    erode_img2=imerode(smap,se2);
    dilate_img2=imdilate(smap,se2);

    bw(~logical(dilate_img1))=0;
    
    cha1=dilate_img2-erode_img2;
    cha_erode=erode_img1-erode_img2;
    
    tmp=dilate_img1-erode_img1;
    t=tmp>mean(tmp(:));
    
    bw(~t)=0;
    
    edge_map=bw;
  
end

