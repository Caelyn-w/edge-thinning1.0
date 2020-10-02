
%%
clc
clear
% replace the path as mentioned below
% st1='Data/src/CO-SKEL/GT_skeletons/horse/'; %¹Ç¼ÜµÄgroundtruth
% st2='Data/horse_skeleton_shenwei/';
%  st1='Data/src/CO-SKEL/sym/';
%  st2='Data/TEST_coskel/co_theta3/';

%-------------------------heatmap_coskel8------------------------
%  st1='Data/00groundtruth_sk_cosel/';
%  st2='Data/02heatmap_sk_coskel/';
 
 %-------------------------heatmap_WHSYM8------------------------
%  st1='Data/00groundtrue_sk_whsymmax/';
%  st2='Data/02heatmap_sk_whsymmax/';
 
 %-------------------------our_WHSYM------------------------
%  st1='Data/00groundtrue_sk_whsymmax/';
%  st2='Data/01our_sk_whsymmax/';
 
 %-------------------------our_coskel------------------------
%  st1='Data/00groundtruth_sk_coskel/';
%  st2='Data/01our_sk_coskel/';
 
 %-------------------------shenwei2013_WHSYM------------------------
 st1='Data/00groundtrue_sk_whsymmax/';
 st2='Data/03shenwei2013_sk_whsymmax/';

  %-------------------------shenwei2013_coskel------------------------
%  st1='Data/00groundtruth_sk_coskel/';
%  st2='Data/03shenwei2013_sk_coskel/';

 %-------------------------baiDCE_WHSYM------------------------
%  st1='Data/00groundtrue_sk_whsymmax/';
%  st2='Data/04baiDCE_sk_whsymmax/';
 
 %-------------------------baiDCE_coskel------------------------
%  st1='Data/00groundtruth_sk_coskel/';
%  st2='Data/04baiDCE_sk_coskel/';
%  

%-------------------------shnewei2011_WHSYM------------------------
 st1='Data/00groundtrue_sk_whsymmax/';
 st2='Data/05shenwei2011_sk_whsymmax/';
 
 %-------------------------shenwei2011_coskel------------------------
%  st1='Data/00groundtruth_sk_coskel/';
%  st2='Data/04baiDCE_sk_coskel/';
%  

% st1='Data/wh-symmax/RES/train/sym/';
% st2='Data\WH_theta2\';
% st3='../CO-SKEL_v1.1/GT_masks/camel/'; %·Ö¸îµÄgroundtruth
% st4='../CO-SKEL_v1.1/segmentation_masks/';

%%

addpath(st1)
addpath(st2)
% addpath(st3)
% addpath(st4)

[F3,J]=evaluation(st1,st2);


