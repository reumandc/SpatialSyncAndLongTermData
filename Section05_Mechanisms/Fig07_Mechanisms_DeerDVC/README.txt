This directory has the code making the figure on cycles and synchrony in deer and deer-vehicle
collisions in Wisconsin.

To get the figure, set the working directory of R to this directory, and run the script
Fig_Mechanisms_DeerDVC.R from a fresh R session. You may have to verify that the dependencies 
at the top of the file are available. See below for descriptions of the data files.

Author-- Thomas L. Anderson
email-- thander@siue.edu

All files below are those used in Anderson et al. (2021). Descriptions of each file are below, with
full details found in the previous reference. 

Fig_Mechanisms_DeerDVC_deer-- A matrix of deer abundance values for 71 counties in Wisconsin (rows) for 36 years (1981-2016, columns). 
Abundance values come from conversions of Wisconsin Department of Natural Resources
deer management unit values to county-level abundance estimates. The first column is the county name. 


Fig_Mechanisms_DeerDVC_abunsurrsum-- These are constructed artificial time series data for deer for each location 
that had the same spectral characteristics as the original deer data, except they were not spatially synchronised.
We accomplished this by randomising phases of the Fourier transforms of the county-level time series.
We summed each set of surrogate time series spatially to produce surrogate statewide 
total time series for deer, representing the hypothetical case of no synchrony. 

Fig_Mechanisms_DeerDVC_dvc-- A matrix of deer-vehicle collisions (DVC) values for 71 counties in Wisconsin (rows) for 29 years (1987-2016, columns). 
DVC values come from Wisconsin Department of Transportation estimates at the county level, based on those investigated by insurance claims. 
The first column is the county name. 
 

Fig_Mechanisms_DeerDVC_dvcsurrsum-- These are constructed artificial time series data for DVCs for each location 
that had the same spectral characteristics as the original DVC data, except they were not spatially synchronised.
We accomplished this by randomising phases of the Fourier transforms of the county-level time series.
We summed each set of surrogate time series spatially to produce surrogate statewide 
total time series for DVC, representing the hypothetical case of no synchrony. 