main_calculateWPMFs.R creates the WPMF magnitude & other files needed for plotting
main_plotWPMFs.m plots those outputs, generating the panels of the Example WPMFs figure 


DATASETS USED:

(a) SHOREBIRD COUNTS
shorebird_counts.csv

EDI CITATION: Santa Barbara Coastal LTER and J. Dugan. 2021. SBC LTER: Beach: Time series of abundance of birds and stranded kelp on selected beaches, ongoing since 2008 ver 10. Environmental Data Initiative. https://doi.org/10.6073/pasta/06c6b9983a5f0a44349e027a002f5040

Full methods and details are described in the reference mentioned above.
In short: 
 
These data are counts of shorebirds on 1km along-shore transects at each of 5 sites. The data here represent the sum across shorebird species by month for each site. Each column represents a month; the data run from Jan 2009 to Dec 2019. Each row represents a site (Arroyo Quemado, Isla Vista, East Campus, Arroyo Burro, Santa Claus Lane).

The aggregated shorebird count is made up of the following species: American Avocet, Baird's Sandpiper, Black-bellied Plover, Black-necked Stilt, Black Turnstone, unidentified Dowitchers, Dunlin, Greater Yellowlegs, Killdeer, Least Sandpiper, Lesser Yellowlegs, Long-billed Curlew, Long-billed Dowitcher, Marbled Godwit, Pectoral Sandpiper, Red-necked Phalarope, Red Knot, Ruddy Turnstone, Sanderling, Semipalmated Plover, Short-billed Dowitcher, Snowy Plover, Spotted Sandpiper, Surfbird, Wandering Tattler, Western Sandpiper, Whimbrel, Willet, and Wilson's Plover.

(b) CAR ACCIDENTS

//TODO!!!!

(c) KELP BIOMASS
kelp_biomass.csv

EDI CITATION: Santa Barbara Coastal LTER, T. Bell, K. Cavanaugh, D. Reuman, M. Castorani, L. Sheppard, and J. Walter. 2021. SBC LTER: REEF: Macrocystis pyrifera biomass and environmental drivers in southern and central California ver 1. Environmental Data Initiative. https://doi.org/10.6073/pasta/27e795dee803493140d6a7cdc3d23379 (Accessed 2023-11-15).

STUDY CITATION: Castorani, M. C., Bell, T. W., Walter, J. A., Reuman, D. C., Cavanaugh, K. C., & Sheppard, L. W. (2022). Disturbance and nutrients synchronise kelp forests across scales through interacting Moran effects. Ecology Letters, 25(8), 1854-1868.

Full methods and details are described in the references cited above. 
In short: 

These data are estimates of kelp biomass from satellite data at sites along Central California. Columns: site_id (see study cited above for map of site locations by site ID), year, quarter of the year, kelp biomass (kg)

(d) WILLOW-CARROT APHID PHENOLOGIES 
willow_carrot_aphid_phenology.csv

STUDY CITATION: Sheppard, L., Bell, J., Harrington, R. et al. Changes in large-scale climate alter spatial synchrony of aphid pests. Nature Clim Change 6, 610–613 (2016). https://doi.org/10.1038/nclimate2881

Full methods and details are described in the reference cited above.

The data give the Julian day of first flight of willow-carrot aphids at each of 11 locations in each of 35 years. 

Columns: Years (listed in row 1)
Rows: Locations 
Location details are listed in Supplementary Table 1 of the study cited above. The locations are:
Ayr, Broom's Barn, Dundee, Edinburgh, Herefore, Newcastle, Preston, Rothamsted, Starcross, Writtle, and Wye.

(e) DEER ABUNDANCES
deer_abundances.csv

DRYAD CITATION: Anderson, Thomas et al. (2021). Data from: Synchronous effects produce cycles in deer populations and deer-vehicle collisions [Dataset]. Dryad. https://doi.org/10.5061/dryad.rn8pk0p85

STUDY CITATION: Anderson, T. L., Sheppard, L. W., Walter, J. A., Rolley, R. E., & Reuman, D. C. (2021). Synchronous effects produce cycles in deer populations and deer‐vehicle collisions. Ecology Letters, 24(2), 337-347.

Full methods and details are described in the reference cited above.

These data are estimates of deer abundance (from population models) of deer in counties of Wisconsin. Columns = Years, Rows = Counties.

(f) PLANKTON COLOR INDICES
plankton_color_index.csv

DRYAD CITATION: Sheppard, Lawrence William; Defriez, Emma J.; Reid, Philip Christopher; Reuman, Daniel C. (2019). Data from: Synchrony is more than its top-down and climatic parts: interacting Moran effects on phytoplankton in British seas [Dataset]. Dryad. https://doi.org/10.5061/dryad.rq3jc84

STUDY CITATION: Anderson, T. L., Sheppard, L. W., Walter, J. A., Hendricks, S. P., Levine, T. D., White, D. S., & Reuman, D. C. (2019). The dependence of synchrony on timescale and geography in freshwater plankton. Limnology and Oceanography, 64(2), 483-502.

Full methods and details are described in the reference cited above.

These data are plankton color index (PCI) values for 26 areas of the North Sea (see Supplementary Figure 4 in the study referenced above for a map). Columns=Year, Rows=Area. The first row contains the years and the first column contains the area ID number.

(g) DENGUE CASE COUNTS 
dengue_cases_log_transf.csv

STUDY CITATION: García-Carreras, B., Yang, B., Grabowski, M. K., Sheppard, L. W., Huang, A. T., Salje, H., ... & Cummings, D. A. (2022). Periodic synchronisation of dengue epidemics in Thailand over the last 5 decades driven by temperature and immunity. PLoS biology, 20(3), e3001160.

Full methods and details are described in the reference cited above.

Data are ln-transformed dengue case counts from passive surveillance data from 72 provinces of Thailand. The data are in wide format, where columns=provinces and rows=months. 

(h) BRISTLECONE PINE GROWTH RATES
// TODO !!!!!