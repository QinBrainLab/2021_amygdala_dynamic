# Dynamic-kmeans
## Checklist for Data Analysis Conducted in the manuscript
  Lead author(s): Yimeng Zeng
  
  Created by Yimeng Zeng on September, 2020
  
  Updated by Yimeng Zeng on June 8th, 2021
## Summary and Requirements:
  This repository contains Matlab, Python scriptes needed to produce key results in the manuscript including figures, statstic test, fmri data preprocess and machine learning procedure.
## Test Environment(s):
MATLAB version: R2015b,R2020a  Python Version: 3.6  Operating System: windows 10, linux centos6_x86_64
## SCL raw data
  * preprocsss procedure for SCLs (conducted only on MATLAB R2020a)
  
    script: scr_preprocess.m

## Fmri data analysis

### Seed-based whole-brain functional connectivity from resting-state fMRI （Figure 1）
  * whole-brain fc analysis
  
    script: fconnect_wm_csf_nogs_final.m, fconnect_wm_csf_nogs_final_config.m
  
    Figures in the MS: Figure.1A, plotted by using MRIcron and MRIcroGL；Figure.1B-D, plotted by workbench; Others plotted by MATLAB
### Dynamic functional connectivity analysis with sliding window and k-means clustering (Figure 2,3)
  * sliding window analysis
  * k-means clustering
  * analysis for spatial-temporal properties of decoded state 
  * * time-lagged cross correlation analysis
  
    script: sliding_window_and_k_means_clustering.m
  
    Figures in the MS: Figure.2A,F, plotted by Python；Figure.2B-E, plotted by MATLAB; Figure.3A,F, plotted by Python；Figure.3B-E, plotted by MATLAB;
### Elastic-net regression for predicting skin conductance level (Figure 4,Figure 5)
  * Elastic-net regression analysis
  
    script: state_based_analysis.m
    
    Figures in the MS: Figure.4A,B plotted by MATLAB; Figure.4C,D plotted by Python
    
    Figure.5A,5B plotted by MATLAB and Excel; Figure.5C plotted by BrainNet viewer (Xia et al., 2013)
