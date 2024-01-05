# SpatialSyncAndLongTermData

Code supporting a paper called "Insights into spatial synchrony enabled by long-term data". 

DC Reuman, University of Kansas, reuman@ku.edu  
JA Walter, UC Davis and University of Virginia  
LW Sheppard, Marine Biological Association of the UK  
VA Karatayev, University of Kansas  
ES Kadiyala, Univrsity of Virginia  
AC Lohmann, University of Virginia  
TL Anderson, Southern Illinois University, Edwardsville  
NJ Coombs, University of Kansas  
KJ Haynes, University of Virginia  
LM Hallett, University of Oregon  
MCN Castorani, University of Virginia  

## Introduction

This repository can be used to reproduce the analyses behind the paper "Insights into spatial synchrony enabled by long-term data," which in this case means reproducing the figurs. Necessary data are also included in the repository, or scripts are present which cause data to be downloaded automatically from permanent repositories. 

## How to reproduce results, how this repository is organized

The paper "Insights into spatial synchrony enabled by long-term data" has three main sections, on the
timescale structure of synchrony, on changes in synchrony, and on mechanisms of synchrony. This
repository correspondingly has three directories, each containing subdirectories which correspond
to the figures in that section. For some figures, computer code was not used to create the figure,
and those figures are not represented here. Each directory has a README which explains how to use
the materials in that directory to produce the corresponding figure.

## Dependencies

### Dependencies on R and Matlab

All figures were created with R and/or Matlab. For final tests of the code, we used R version 
4.3.0 running on Ubuntu linux 18.04 and Matlab 2023b. Different figures were initially made by different
coauthors on different machines, but all code was verified on the setup described above.

### R package versions

See the README within each directory for specifics, but R package dependencies are listed at the
top of each script. 

## Acknowlegements

D.C.R. was partly supported by the U.S. National Science Foundation (NSF) through NSF-OCE award 2023474, and also by the McDonnell Foundation and the Humboldt Foundation. M.C.N.C., E.S.K., and A.C.L. were supported by NSF-OCE award 2023555. J.A.W. was supported by California Department of Fish and Wildlife grant Q2296003 and NSF-OCE 2023555. The Rothamsted Insect Survey, a National Bioscience Resource Infrastructure, is funded by the Biotechnology and Biological Sciences Research Council under the award BBS/E/RH/23NB0006. We thank James Bell for data cooperation and useful discussions. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the authors and do not necessarily reflect the views of the National Science Foundation or the other funders. 

