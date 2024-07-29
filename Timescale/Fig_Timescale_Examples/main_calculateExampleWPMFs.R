## Written Oct. 2023 
## Code by Amanda Lohmann, amanda.lohmann@virginia.edu
## Edits to add tests of timescale structure by Dan Reuman. Later deemed not useful and but
## retained (commented) for record keeping, and because they don't affect the earlier results
## anyway. 

## R Version 4.2.1
## Dependencies 
# wsyn (Version 1.0.4)
# tidyr (Verion 1.3.0)
# plyr (Version 1.8.7)
# dplyr (Verion 1.0.10)
# MASS (Version 7.3-57)

## DESCRIPTION. Uses the "wsyn" package to calculate the wavelet phasor mean fields (WPMFs) 
# of data used in the Example WPMFs figure and then saves those values in csv 
# files (which are read later to plot the WPMFs in MATLAB). Data files should be located
# in the working directory.

## Output CSV Files (written to working directory)
# [fname]_wpmf.csv --> WPMF (magnitude only, no phase info)
# [fname]_times.csv --> timepoints in years
# [fname]_timescales.csv --> timescales for which the WPMF was calculated
# [fname]_syntimescale.csv --> mean value of synchrony at each timescale in *_timescales.csv
# [fname]_syntime.csv --> mean value of synchrony at each timepoint in *_times.csv

rm(list=ls())

#### SETTINGS ####
sigthresh = 0.95 # significance value at which to calculate contours (as 1-p_value, ex. sigthresh=0.95 corresponds to a p-value of 0.05); must be between 0 and 1
# (script will calculate one set of significance contours for each dataset)

#### IMPORTS ####
require(wsyn) # wavelet synchrony package (Version 1.0.4 at time of writing)
require(tidyr) # (Version 1.3.0 at time of writing)
require(plyr) # (Version 1.8.7 at time of writing)
require(dplyr) # (Version 1.0.10 at time of writing)
require(MASS) # (want the "write.matrix" function for writing matrices to csvs) (Version 7.3-57 at time of writing)


#### HELPER FUNCTIONS ####
#source("timescale_structure.R")

save_wsyn_files <- function(dat,times,fname,sigthresh,scalefactor = 1) {
  # takes data matrix and time vector as arguments, and writes a series of .csv files containing WPMF values and associated data to be plotted later (written to working directory)
  
  ## Arguments
  # dat --> data in matrix formatted for wsyn (site x time), see wsyn vignette for detailed description
  # times --> vector of times corresponding to columns of dat matrix (MUST BE CONSECUTIVE INTEGERS due to wsyn constraints) 
  # fname --> prefix name for saved filed (ex, "PLANKTON")
  # sigthresh --> significance value at which to calculate contours (as 1-p_value, ex. sigthresh=0.95 corresponds to a p-value of 0.05)
  # scalefactor --> samples/year. In other words, the factor by which the "times" vector needs to be divided to achieve increments in years. For example, if data are sampled monthly, then scalefactor=12, and the increment between successive values in the "times" vector is 1/12 of a year
  
  ## Output CSV Files
  # [fname]_wpmf.csv --> WPMF (magnitude only, no phase info)
  # [fname]_times.csv --> timepoints in years
  # [fname]_timescales.csv --> timescales covered by the WPMF
  # [fname]_syntimescale.csv --> mean value of synchrony at each timescale
  # [fname]_syntime.csv --> mean value of synchrony at each timepoint
  
  ## calculate WPMF
  dat_orig<-dat
  dat = cleandat(dat,times,5)$cdat # detrend, set 0 mean, and clean data (see wsyn documentation for more details)
  res = wpmf(dat,times,sigmethod='quick') # calculate WPMF & its significance using wsyn package
  ttmat <- res$values # extract WPMF values
  mag = Mod(ttmat) # get magnitude of WPMF values (which is what we want to plot - WPMF values are complex numbers w/ mag & phase)
  
  ## calculate the mean synchrony across timescales and over time (side panels along WPMF in the resulting figure)
  # only want to use the interior 90% of data (so drop the outer 5% on each side, to avoid edge values that don't have much meaning)
  non_nan_counts <- colSums(!is.na(mag)) # how many counts in each row are not nan? AKA how many columns per row are not nan? (only edge values will be NaN at this point, so this is just to throw out purely nan padding columns)
  rowmax = max(non_nan_counts) # maximum number of non-nan values in each row (so, the total number of columns when you get rid of the padding columns)
  non_nan_counts <- rowSums(!is.na(mag)) # same as above but for the number of counts in each column that are nan
  colmax = max(non_nan_counts)
  row_keep = round(0.9*rowmax) # 90% of the maximum number of non-nan values in each row 
  col_keep = round(0.9*colmax) # 90% of the maximum number of non-nan values in each column 
  row_cut = nrow(ttmat)-row_keep # where to cut the rows to get the middle 90% 
  row_cut = ceiling(row_cut/2) 
  col_cut = ncol(ttmat)-col_keep # where to cut the columns to get the middle 90% (not the same calculation as for rows because of the rocket-cone shape)
  cut_ttmat = ttmat # new copy of ttmat
  if (row_cut > 0){ # cut ttmat to desired middle 90% of row values
    cut_ttmat[(nrow(cut_ttmat)-row_cut+1):nrow(cut_ttmat),] = NaN
    cut_ttmat[1:row_cut,] = NaN
  }
  if (col_cut > 0){ # cut ttmat to desired middle 90% of col values
    cut_ttmat[,(ncol(cut_ttmat)-col_cut+1):ncol(cut_ttmat)] = NaN
  }
  syn_timescale <- apply(FUN=mean, X=Mod(cut_ttmat),MARGIN=2,na.rm=TRUE) # marginalizing across time
  syn_time <-  apply(FUN=mean,X=Mod(cut_ttmat),MARGIN=1,na.rm=TRUE)   # marginalizing across time scale
  timescales = res$timescales # get list of timescales (from object returned by wpmf() wsyn function)
  
  q = get_q(res=res,sigthresh=sigthresh) # get the value of the WPMF that corresponds to a significance level as set by sigthresh
  
  # write output csv files
  write.matrix(mag,file=paste(fname,'_wpmf.csv',sep=''))
  write.matrix(times/scalefactor,file=paste(fname,'_times.csv',sep=''))
  write.table(timescales/scalefactor,file=paste(fname,'_timescales.csv',sep=''),row.names=FALSE,col.names = FALSE)
  write.matrix(syn_timescale,file=paste(fname,'_syntimescale.csv',sep=''))
  write.matrix(syn_time,file=paste(fname,'_syntime.csv',sep=''))
  write.matrix(q,file=paste(fname,"_q_",sub(".*\\.", "", toString(sigthresh)),".csv",sep=''))
  
  # #do the tests for "timescale structure"
  # if (scalefactor==1)
  # {
  #   tsres<-timescale_structure(dat=dat,omit_freqs=NA)
  #   saveRDS(tsres,file=paste0(fname,"_TimescaleStructure.Rds"))
  # }
  # if (scalefactor==4)
  # {
  #   tsres<-timescale_structure(dat=dat,omit_freqs=c(1/5,1/3))
  #   saveRDS(tsres,file=paste0(fname,"_TimescaleStructure.Rds"))
  # }
  # if (scalefactor==12)
  # {
  #   tsres<-timescale_structure(dat=dat,omit_freqs=c(1/13,1/11))
  #   saveRDS(tsres,file=paste0(fname,"_TimescaleStructure.Rds"))
  # }
  # 
  # #special case - aphids
  # if (fname=="APHIDS")
  # {
  #   dat1<-dat_orig[,times<=1993]
  #   dat2<-dat_orig[,times>1993]
  #   times1<-times[times<=1993]
  #   times2<-times[times>1993]
  #   dat1 <- cleandat(dat1,times1,5)$cdat 
  #   dat2 <- cleandat(dat2,times2,5)$cdat 
  #   
  #   tsres1<-timescale_structure(dat=dat1,omit_freqs=NA)
  #   saveRDS(tsres1,file=paste0("APHIDS_EARLY","_TimescaleStructure.Rds"))
  #   tsres2<-timescale_structure(dat=dat2,omit_freqs=NA)
  #   saveRDS(tsres2,file=paste0("APHIDS_LATE","_TimescaleStructure.Rds"))
  # }
}

get_q <- function (res, sigthresh = 0.95) {
  # uses the "quick" significance testing method in wsyn (see package for more details)
  # to calculate the mag(WPMF) value that defines the significance threshold indicated by the input sigthresh 
  
  ## Arguments 
  # res --> output of wpmf() function
  # sigthresh --> significance threshold (described at top of this script)
  
  ## Outputs
  # q --> value of mag(WPMF) above which the WPMF is significant
  
  signif <- get_signif(res) # extract the significance testing information from the res object
  if (!all(is.na(res))) { # if not entirely NA
    if (signif[[1]] == "quick") {  # confirm that the "quick" option was used for significance testing
      q <- stats::quantile(signif[[2]], sigthresh) # get the value of mag(WPMF) above which the value of the WPMF is significant
    }
    else {
      stop('Error - no code written for fft or aaft options') # only using "quick" for this fig
    }
  }
  else{
    stop('No significant areas - no code written to deal with absence of contours')
  }
  return(q)
}


#### (1) PLANKTON ####
dat = read.csv('plankton_color_indices.csv',header=FALSE)
dat <- subset(dat, select = -V1) # drop the first row, which is just an index
times = unlist(dat[1,], use.names = FALSE) # get the time (years)
dat = dat[-1,] # drop year row
row.names(dat) <- NULL # reset the row index
dat = as.matrix(dat) # convert to matrix
rownames(dat) <- NULL # clear row names
colnames(dat) <- NULL # clear column names
fname = 'PLANKTON'
save_wsyn_files(dat,times,fname,sigthresh)


#### (2) DEER ####
dat = read.csv('deer_abundances.csv',header=FALSE) # county not district deer abundance used in fig 3 in the deer paper
dat <- subset(dat, select = -V1) # drop the first row, which is the county names
times = unlist(dat[1,], use.names = FALSE) # get the time (years)
dat = dat[-1,]
row.names(dat) <- NULL # reset the row index
dat = as.matrix(dat) # convert to matrix
rownames(dat) <- NULL # clear row names
colnames(dat) <- NULL # clear column names
fname='DEER'
save_wsyn_files(dat,times,fname,sigthresh)


#### (3) DENGUE ####
dat = read.csv('dengue_cases_log_transf.csv')
dat = t(dat)
times = unlist(dat['Time',], use.names = FALSE) # get the time (years)
dat = dat[-c(1:5),] # remove metadata rows
dat = as.matrix(dat) # convert to matrix
dat <- matrix(as.numeric(dat), nrow = nrow(dat))
rownames(dat) <- NULL # clear row names
colnames(dat) <- NULL # clear column names
times = as.numeric(times) # they got read in as strings urgh
scalefactor = 12 # need times that differ by 1, so convert from years to months 
times = round(times*scalefactor) 
fname = 'DENGUE'
save_wsyn_files(dat,times,fname,sigthresh,scalefactor = scalefactor)


#### (4) APHIDS ####
dat <- read.csv(file='willow_carrot_aphid_phenologies.csv',header=F)
times = unlist(dat[1,],use.names=FALSE)
dat=dat[-c(1),]
dat[dat == -999] = NA
row_medians = apply(dat, 1, median, na.rm=TRUE) # replace NAs with medians
na_locs = which(is.na(dat),arr.ind=TRUE)
for (i in 1:nrow(na_locs)){
  rx = as.numeric(na_locs[i,1])
  cx = as.numeric(na_locs[i,2])
  dat[rx,cx] = row_medians[rx]
}
dat <- as.matrix(dat)
aphids = dat
times = seq(1976,2010)
fname = 'APHIDS'
save_wsyn_files(dat,times,fname,sigthresh)


#### (5) KELP ####
dat = read.csv('kelp_biomasses.csv')
first_southern_site = 243 # all sites < 243 are central CA, all sites >= 243 are southern CA
dat = dat[dat$site_id < first_southern_site,]
dat$time = dat$year + ((dat$quarter-1)*0.25)
scalefactor = 4 # measured quarterly
dat$time = dat$time*scalefactor
dat <- dat %>%
  pivot_wider(names_from = site_id, id_cols = time, values_from = kelp)
times = dat$time
dat = subset(dat,select=-c(time))
dat = as.matrix(dat)
dat = t(dat)
fname="KELP"
save_wsyn_files(dat,times,fname,sigthresh,scalefactor=scalefactor)


#### (6) SHOREBIRDS ####
dat = read.csv('shorebird_counts.csv',header=FALSE)
dat = subset(dat,select=-c(V1))
times = unname(unlist(dat[1,]))
years = sub("_.*$","",times)
months = sub(".*_", "", times)
years = as.numeric(years)*12
months = as.numeric(months)
times = years+months
scalefactor = 12
dat = dat[-1,]
colnames(dat) = NULL
rownames(dat) = NULL
dat = apply(dat, c(1, 2), as.numeric)
row_medians = apply(dat, 1, median, na.rm=TRUE) # replace missing values with site median
na_locs = which(is.na(dat),arr.ind=TRUE)
for (i in 1:nrow(na_locs)){
  rx = as.numeric(na_locs[i,1])
  cx = as.numeric(na_locs[i,2])
  dat[rx,cx] = row_medians[rx]
}
dat = as.matrix(dat)
times = times
fname = 'SHOREBIRDS'
save_wsyn_files(dat,times,fname,sigthresh,scalefactor=scalefactor)


#### (7) CAR ACCIDENTS ####
dat = read.csv('car_accidents.csv')
times = dat$Month.Code
years = sub("/.*$","",times)
months = sub(".*/", "", times)
years = as.numeric(years)*12
months = as.numeric(months)
times = years+months
scalefactor=12
dat = dat[,-1]
dat = dat[,-1]
dat = dat[,-1]
colnames(dat) = NULL
rownames(dat) = NULL
dat = apply(dat, c(1, 2), as.numeric)
dat = as.matrix(dat)
dat = t(dat)
fname = 'CARACCIDENTS'
save_wsyn_files(dat,times,fname,sigthresh,scalefactor=scalefactor)


#### (8) BRISTLECONE PINE (PILO) ####
df = read.csv('bristlecone_pine_growth_rates.csv')
df = df[,!names(df) %in%  c("samp.depth")]
times = min(df$year_CE):max(df$year_CE)
df <- df %>% # reshape into wide format
  spread(key = "year_CE", value = "std")
df = df[,!names(df) %in% c('site')]
dat = as.matrix(df)
fname = "PILO"
save_wsyn_files(dat,times,fname,sigthresh)

# #### Now make a table with all the results for testing the significance of timescale structure ###
# 
# digs<-3
# 
# tab<-data.frame(System=c("Shorebirds","Car crashes","Kelp","Aphids","Aphids, early","Aphids, late",
#                          "Deer","Plankton","Dengue","Bristlecone","Null"),
#                 Test_1=NA,Test_1_no_annual=NA,Test_2=NA,Test_2_no_annual=NA)
# 
# #shorebird
# h<-readRDS(file="SHOREBIRDS_TimescaleStructure.Rds")
# tab[1,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[1,3]<-round(h$equal.kappa.test.res.omit$p.value,digs)
# tab[1,4]<-round(h$like.rat.test.res$p,digs)
# tab[1,5]<-round(h$like.rat.test.res.omit$p,digs)
# 
# #car crash
# h<-readRDS(file="CARACCIDENTS_TimescaleStructure.Rds")
# tab[2,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[2,3]<-round(h$equal.kappa.test.res.omit$p.value,digs)
# tab[2,4]<-round(h$like.rat.test.res$p,digs)
# tab[2,5]<-round(h$like.rat.test.res.omit$p,digs)
# 
# #kelp
# h<-readRDS(file="KELP_TimescaleStructure.Rds")
# tab[3,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[3,3]<-round(h$equal.kappa.test.res.omit$p.value,digs)
# tab[3,4]<-round(h$like.rat.test.res$p,digs)
# tab[3,5]<-round(h$like.rat.test.res.omit$p,digs)
# 
# #aphid
# h<-readRDS(file="APHIDS_TimescaleStructure.Rds")
# tab[4,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[4,4]<-round(h$like.rat.test.res$p,digs)
# 
# #aphid early
# h<-readRDS(file="APHIDS_EARLY_TimescaleStructure.Rds")
# tab[5,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[5,4]<-round(h$like.rat.test.res$p,digs)
# 
# #aphid late
# h<-readRDS(file="APHIDS_LATE_TimescaleStructure.Rds")
# tab[6,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[6,4]<-round(h$like.rat.test.res$p,digs)
# 
# #deer 
# h<-readRDS(file="DEER_TimescaleStructure.Rds")
# tab[7,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[7,4]<-round(h$like.rat.test.res$p,digs)
# 
# #plankton
# h<-readRDS(file="PLANKTON_TimescaleStructure.Rds")
# tab[8,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[8,4]<-round(h$like.rat.test.res$p,digs)
# 
# #dengue
# h<-readRDS(file="DENGUE_TimescaleStructure.Rds")
# tab[9,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[9,3]<-round(h$equal.kappa.test.res.omit$p.value,digs)
# tab[9,4]<-round(h$like.rat.test.res$p,digs)
# tab[9,5]<-round(h$like.rat.test.res.omit$p,digs)
# 
# #pine
# h<-readRDS(file="PILO_TimescaleStructure.Rds")
# tab[10,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[10,4]<-round(h$like.rat.test.res$p,digs)
# 
# #null
# h<-readRDS(file="NULLSIM_TimescaleStructure.Rds")
# tab[11,2]<-round(h$equal.kappa.test.res$p.value,digs)
# tab[11,4]<-round(h$like.rat.test.res$p,digs)
# 
# tabx<-xtable::xtable(tab,digits=3,row.names=NULL)
# print(tabx,file="Table_pvalResults_TimescaleStructure.tex",include.rownames=FALSE)

### (9) SIMULATED NULL EXAMPLE (NULLSIM) for the SI ####

#do it once
set.seed(100)
matsize<-10
tslen<-50
sig<-matrix(.3,matsize,matsize)
diag(sig)<-1
dat<-t(mvtnorm::rmvnorm(tslen,mean=rep(0,matsize),sigma=sig))
times<-seq(from=1,to=tslen,by=1)

dat<-wsyn::cleandat(dat,times,clev=2)$cdat
wpmfres<-wsyn::wpmf(dat,times,sigmethod="quick",nrand=1000000)
pdf(file="NULLSIM1.pdf")
wsyn::plotmag(wpmfres,sigthresh=c(.95,.999))
dev.off()

#do it once
set.seed(105)
matsize<-10
tslen<-50
sig<-matrix(.3,matsize,matsize)
diag(sig)<-1
dat<-t(mvtnorm::rmvnorm(tslen,mean=rep(0,matsize),sigma=sig))
times<-seq(from=1,to=tslen,by=1)

dat<-wsyn::cleandat(dat,times,clev=2)$cdat
wpmfres<-wsyn::wpmf(dat,times,sigmethod="quick",nrand=1000000)
pdf(file="NULLSIM2.pdf")
wsyn::plotmag(wpmfres,sigthresh=c(.95,.999))
dev.off()
