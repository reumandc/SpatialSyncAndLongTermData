# The following script builds growth chronologies for Bristlecone Pine (Pinus longaeva, PILO) stands.
# Data was accessed from the International Tree-Ring Data Bank: https://www.ncei.noaa.gov/access/paleo-search/?dataTypeId=18
# Tree ring measurements for PILO stands were downloaded as .rwl files from the following sites:
# ca534, ca535, ca667, nv500, nv515, nv516, nv520, nv521, ut509, and ut550.
# Script written by Ethan Kadiyala in R 4.1.0, 11/13/23

# libraries
library(tidyverse)
library(readr)
library(dplR)   # convenient functions for tree ring chronologies
library(wsyn)



# read in all raw PILO .rwl files and create a dt with all stands  ------------

# prepare files and site names
files <- list.files("data_raw")
sites <- str_remove(files, ".rwl")

# prepare for chronologies
output <- list()
earliest_year <- list()
oldest_year <- list()

# prepare a tidy df to append to
names <- c("std", "samp.depth", "year_CE", "site")
output_tidy <- as.data.frame(matrix(nrow = 0, ncol = 4))
names(output_tidy) <- names

for (i in 1:length(files)) {
  
  print(files[i])
  
  path <- str_c("data_raw/", files[i])      # get file path
  
  rwl <- read.rwl(path, format = "auto")     # read measurements
  
  rwi <- detrend(rwl, method = "ModNegExp")  # detrend for biological or stand effects

  crn <- chron(rwi)                          # take mean-value chronology (Tukey's biweight robust mean)
  
  crn_year <- crn %>% 
    mutate(year_CE = as.numeric(rownames(crn)),
           site = sites[i])    # add year_CE as a column rather than as rownames
  
  earliest_year[i] <- min(crn_year$year_CE)   # so we can create a dt to join all the rwl dts to by year_CE
  
  oldest_year[i] <- max(crn_year$year_CE)
  
  output_tidy <- output_tidy %>% 
    rbind(crn_year)
  
}

warnings()   # the warning refers to dates that extend back before 0 CE. These dates have a "-" in the year column of the .rwl file that trigger the warning.
             # The file still gets parsed correctly, I've contacted the author of the package, a dendrochronologist, to confirm the data is being read correctly


pilo <- output_tidy


# plot chronologies of all 10 stands --------------------------------------

scl <- 40 # scale second y-axis (sample depth)
pilo %>%
  ggplot(aes(x = year_CE)) +
  geom_line(aes(y = std)) +
  geom_line(aes(y = samp.depth/scl), alpha = .2) +
  facet_wrap(vars(site), ncol = 2) +
  scale_y_continuous("RWI",
                     sec.axis = sec_axis(~ . * scl, name = "Sample depth")) +
  theme_bw(base_size = 14) +
  theme(panel.grid = element_blank())

# filter for years greater than 0 CE
pilo %>%
  filter(year_CE > 0) %>% 
  ggplot(aes(x = year_CE)) +
  geom_line(aes(y = std)) +
  geom_line(aes(y = samp.depth/scl), alpha = .15) +
  facet_wrap(vars(site), ncol = 2) +
  scale_y_continuous("RWI",
                     sec.axis = sec_axis(~ . * scl, name = "Sample depth")) +
  theme_bw(base_size = 14) +
  theme(panel.grid = element_blank())


# visualize chronologies and min and max year
pilo %>% 
  group_by(site) %>% 
  summarize(year_min = min(year_CE),
            year_max = max(year_CE)) %>% 
  pivot_longer(year_min:year_max) %>% 
  ggplot(aes(x = site, y = value, color = name)) +
  geom_point() +
  theme_bw(base_size = 15)


# prepare for use in wsyn ----------------------------------------------------------
years <- pilo %>% 
  group_by(site) %>% 
  summarize(year_min = min(year_CE),
            year_max = max(year_CE))

yr_min <- max(years$year_min)
yr_max <- min(years$year_max)   # to make each series the same length

# visualize sample depth distribution and final chronologies -------------------------------------
pilo %>% 
  filter(year_CE >= yr_min,
         year_CE <= yr_max) %>%
  ggplot(aes(x = samp.depth)) +
  geom_histogram(binwidth = 5) +
  theme_bw(base_size = 16) +
  theme(panel.grid = element_blank()) +
  ylab("Count")

scl <- 45 # scale second y-axis (sample depth)
pilo %>% 
  filter(year_CE >= yr_min,
         year_CE <= yr_max) %>%
  ggplot(aes(x = year_CE)) +
  geom_line(aes(y = std)) +
  geom_line(aes(y = samp.depth/scl), alpha = .15) +
  facet_wrap(vars(site), ncol = 2) +
  scale_y_continuous("RWI",
                     sec.axis = sec_axis(~ . * scl, name = "Sample depth")) +
  theme_bw(base_size = 14) +
  theme(panel.grid = element_blank())


# save chronologies -------------------------------------------------------
pilo_trim <- pilo %>% 
  filter(year_CE >= yr_min,
         year_CE <= yr_max)   # 9 mean growth chronologies from 0 CE to 1979 CE

write_csv(pilo_trim, "Data_Timescale_Growth_Chronologies.csv")



