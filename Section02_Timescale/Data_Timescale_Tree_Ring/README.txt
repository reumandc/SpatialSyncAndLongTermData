This folder contains the code for calculating standardize growth indices (unitless) of Bristlecone Pine (Pinus longaeva, PILO) stands from raw tree ring width measurements (see below for units). 

Data was accessed from the International Tree-Ring Data Bank: https://www.ncei.noaa.gov/access/paleo-search/?dataTypeId=18

Tree ring measurements for PILO stands were downloaded as .rwl files from the following stands:
ca534 - https://doi.org/10.25921/q0we-8b37
ca535 - https://doi.org/10.25921/ppqj-xv48
ca667 - https://doi.org/10.25921/ycpw-7019
nv500 - https://doi.org/10.25921/0xbh-hd13
nv515 - https://doi.org/10.25921/r81r-sw85
nv516 - https://doi.org/10.7289/V5N8784H
nv520 - https://doi.org/10.25921/21ew-pa87
nv521 - https://doi.org/10.25921/rf2e-kb29
ut509 - https://doi.org/10.25921/9npw-ma05
ut550 - https://doi.org/10.25921/6h43-0334

Raw tree ring measurements are stored in the "data_raw" folder. Each .rwl is formatted in the Tuscon format for tree ring data. Column 1 represents the core identity (i.e. subject ID), Column 2 represents the oldest measurement in Columns 3-12, which represent tree ring width measurements. Tree ring width measurements are measured in units of 0.01 mm when the stop marker is "999" and 0.001 mm when the stop marker is "-9999". The dplR::read.rwl() function used in the "Data_Timescale_Tree.R" script detects the stop marker and corresponding units of measurement for each .rwl file.

To run the code, open the "Data_Timescale_Tree.R" scripte in a new R session and run.

We ran the code in R 4.1.0


