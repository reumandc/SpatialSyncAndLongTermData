This folder has the code for making the pedagogical figure showing the conceptual framework 
of the wavelet phasor mean field (WPMF).

The files include:
Fig_Timescale_Pedagogical_DataSynthesis.R creates the WPMF magnitude, example timeseries,
Pearson correlation coefficients, example timescale decomposition & other files needed 
for plotting [RUN THIS FILE FIRST]
Fig_Timescale_Pedagogical.m plots those outputs, generating the panels of the pedagogical 
figure
get_q.R is a convenience function to get significant values for WPMF (taken from wysn::wmpf())

To run Fig_Timescale_Pedagogical_DataSynthesis.R: From a fresh R session, set the R working directory to 
this directory, and see the dependencies at the top of Fig_Timescale_Pedagogical_DataSynthesis.R and make sure 
they are satisfied. Then run the script. The original script was created in R 4.1.0.

To run main_plotExampleWPMFs.m set the matlab working directory to this directory, and, from a fresh
Matlab session, run the script. You may need a fairly recent version of matlab - we used 2021a.
