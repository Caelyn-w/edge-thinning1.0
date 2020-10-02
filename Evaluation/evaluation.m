function [scx,jmx] = evaluation(st1,st2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% sjmx=0;
fxx=0;
scx=0;
jmx=0;
% tresx=0;
dr=dir(fullfile(st2, '*.png'));
tresm=1;  % d in F_d

houzhui='_skeleton.png';

for i=1:numel(dr)
    fl=dr(i).name
    fl_gt=strcat('sym',fl(4:end-11));
    disp(fl_gt);
    if exist(strcat(st1,fl_gt,'.jpg'),'file')||exist(strcat(st1,fl_gt,'.png'),'file')

        try
            gt=double(imread(strcat(st1,fl_gt,'.png'))); % groundtruth
        catch
            gt=double(imread(strcat(st1,fl_gt,'.jpg')));
        end
        
        rs=double(imread(strcat(st2,dr(i).name)));  % The result after thresholding
       
        rs=double(im2bw(mat2gray(rs),graythresh(mat2gray(rs))));
        Mp=size(rs,1);Np=size(rs,2); % Returns the number of rows and columns of the result matrix after thresholding
        gt=double(im2bw(mat2gray(imresize(gt,[Mp,Np],'nearest')),0));
        
        
        mask2=[0 1 1 1 0
            1 1 1 1 1
            1 1 1 1 1
            1 1 1 1 1
            0 1 1 1 0];
        mask3=[0 0 1 1 1 0 0
               0 1 1 1 1 1 0
               1 1 1 1 1 1 1
               1 1 1 1 1 1 1
               1 1 1 1 1 1 1
               0 1 1 1 1 1 0
               0 0 1 1 1 0 0];
        
    % jaccard similarity 
        jm=j_measure(gt,rs);
        
        m2=gt+rs;
        
        list1=find(m2==2); %gt==1, rs==1


        scr=0;
        [M,N]=find(gt==1); 
        for k=1:numel(M)
            if tresm==1||M(k)-tresm<1||M(k)+tresm>Mp||N(k)-tresm<1||N(k)+tresm>Np
                trf=sum(sum(rs(max(1,M(k)-tresm):min(M(k)+tresm,Mp),max(1,N(k)-tresm):min(Np,N(k)+tresm))));
            elseif tresm==2
                trf=sum(sum(rs(max(1,M(k)-tresm):min(M(k)+tresm,Mp),max(1,N(k)-tresm):min(Np,N(k)+tresm)).*mask2));
            else
                
                trf=sum(sum(rs(max(1,M(k)-tresm):min(M(k)+tresm,Mp),max(1,N(k)-tresm):min(Np,N(k)+tresm)).*mask3));
            end 
            
            if trf>0
                scr=scr+1;
            end
        end
        
        scr=scr/(numel(M)+eps);
        scr2=0;
        [M2,N2]=find(rs==1);
        for k=1:numel(M2)
            if tresm==1||M2(k)-tresm<1||M2(k)+tresm>Mp||N2(k)-tresm<1||N2(k)+tresm>Np
                trf=sum(sum(gt(max(1,M2(k)-tresm):min(M2(k)+tresm,Mp),max(1,N2(k)-tresm):min(Np,N2(k)+tresm))));
            elseif tresm==2
                trf=sum(sum(gt(max(1,M2(k)-tresm):min(M2(k)+tresm,Mp),max(1,N2(k)-tresm):min(Np,N2(k)+tresm)).*mask2));
            else
                
                trf=sum(sum(gt(max(1,M2(k)-tresm):min(M2(k)+tresm,Mp),max(1,N2(k)-tresm):min(Np,N2(k)+tresm)).*mask3));
            end
            if trf>0
                scr2=scr2+1;
            end
        end
        
        scr2=scr2/(numel(M2)+eps);
        
 
        list2=find(rs==1); %rs==1
        
        list3=find(gt==1); %gt==1
%         list4=find(m2==0);
      
        pre=numel(list1)/(numel(list2)+eps); % Precision
        rec=numel(list1)/(numel(list3)+eps); % Recall
        disp('pre准确率：');
        disp(pre);
        disp('rec召回率：');
        disp(rec);
        fx=2*pre*rec/(pre+rec+eps);
        fxx=fxx+fx; % F measure(d=0)
        scx=scx+2*scr2*scr/(scr+scr2+eps); 
        jmx=jmx+jm; %jaccard similarity
%         sjmx=sjmx+sjm; %分割的
        
   
     
    end
end
if i
    fxx=fxx/i;
    scx=scx/i;
    jmx=jmx/i;
    disp('fxxf度量：');
    disp(fxx);
    disp('fxxfd度量：');
    disp(scx);
    disp('jaccard相似度：');
    disp(jmx);

%     sjmx=sjmx/i;
else
    i=1;
  %  fxx=fxx/i;
    scx=scx/i;
    jmx=jmx/i;
    
%    sjmx=sjmx/i;
    i=0;
end
end

