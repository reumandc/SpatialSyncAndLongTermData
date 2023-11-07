Data in the file 'JRG_cover_data.csv' describe the percent cover of Plantago erecta across 1m plots in Jasper Ridge Biological Preserve (California, USA), from 1983-2019.
Columns are:
X: an integer corresponding to the row number in the full dataset (this version has been subset from the raw to include the focal species and years, only).
year: the year
species: species code (PLER)
treatment: treatment code, c=control, g=gopher exclosure, r=rabbit exclosure
trtrep: treatment replicate code (integer)
plot: plot name
cover: cover (percent) of the focal species in the plot
uniqueID: plot unique identifying code; combines treatment, trtrep, and plot

Data in the file 'JRG_plot_coordinates.csv' give the coordinates of the plots, relative to each other, in meters. Columns are:

ID: unique identifying code; matches uniqueID in JRG_cover_data.csv.
coordX: X-axis coordinate (m)
coordY: Y-xais coordinate (m)

Data collection was led by Richard Hobbs and Lauren Hallet. 