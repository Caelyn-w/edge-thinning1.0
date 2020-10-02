
Instructions

This repository aims to obtain the binary boundary by thinning the image edge map, which uses the idea of skeletonization.

##################################################################################################
If you use this code, please cite the following:
@article{DBLP:journals/cvgip/WangXGZ20,
  author    = {Yuting Wang and Shiqing Xin and Shanshan Gao and Yuanfeng Zhou},
  title     = {Skeletal saliency map computation based on projection symmetry analysis},
  journal   = {Graph. Model.},
  volume    = {109},
  pages     = {101070},
  year      = {2020}
}
##################################################################################################

Requirements: Matlab R2015b

##################################################################################################
Usage: Run SkeletalSaliencyMap_DEMO.m.

     NOTE: (1) The input images are placed in the Data/test_img folder. And the results are placed in the Data/result folder.
                (2) Be careful to modify lines 9 and 201 of the SkeletalSaliencyMap_DEMO.m
                