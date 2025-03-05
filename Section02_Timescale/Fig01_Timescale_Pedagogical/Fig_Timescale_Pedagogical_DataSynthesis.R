# The following script generates 10 synthesized time series and calculates non-timescale
# specific metrics of synchrony (correlation) as well as timescale specific metrics
# (wavelet phasor mean field). Example time series are created using sinusoidal functions
# with random noise components. The outputs are saved as .csv files to be plotted in
# MATLAB.
# Written by Ethan Kadiyala based on MATLAB code from Lawrence Sheppard, 11/7/2023
# Created in R 4.1.0

# Dependencies 
# wsyn (Version 1.0.4)

library(wsyn)
source("get_q.R")   # convenience function to get significant values for WPMF (taken from wysn::wmpf())

set.seed(seed = 641)

# create timeseries -------------------------------------------------------
a <- 1.6 # noise
b <- 1.5; # 10yr
c <- 3; # 3yr
t <- 0.5:34.5
f1 <- seq(from = .08, to = .15, length.out = 35)   # coef for long component, increases in frequency over time
f2 <- .33   # coef for short component
times <- c(1:35)

sig <- matrix(nrow = 10, ncol = 35) # create 10 time series using for loop

for (n in c(1:10)) {
  sig[n,] <- c(a*rnorm(n = 35) +                  # random noise
               b*sin(2*pi*f1*t) +                  # long component
               c*sin(2*pi*(runif(n = 1) + f2*t))  # short component with random shift
               )
}


# take pairwise correlation -----------------------------------------------
rho = matrix(nrow = 10, ncol = 10) # calculate pearson correlation for unique pairs
for (i in 1:10) {
  for (j in 1:10) {
    rho[i,j] <- cor(sig[i,], sig[j,])
    if (upper.tri(rho)[i,j] == FALSE) {     # index to avoid duplicate values and diagonal
      rho[i,j] <-  NaN
    }
  }
}


# calculate wavelet phasor mean field -------------------------------------
dat <- cleandat(sig, clev = 1, times = times)[[1]]

res <- wpmf(dat = dat, times = times, sigmethod = "quick", scale.max.input = 20)

q_value <- get_q(res)[[1]]   # get the threshold for significant WPMF values

# create pedagogical signals for example decomposition --------------------
decomposition <- matrix(nrow = 3, ncol = 35)
decomposition[1,] <- b*sin(2*pi*f1*t)                   # long component
decomposition[2,] <- c*sin(2*pi*(runif(n = 1)+f2*t - .02))    # shift slightly for visualization purposes in the example decomposition
decomposition[3,] <- a*rnorm(n = 35)                    # random noise


# save data to plot in matlab ---------------------------------------------
write.table(sig, "Fig_Timescale_Pedagogical_Timeseries.csv", sep = ",", row.names = F, col.names = F)
write.table(rho, "Fig_Timescale_Pedagogical_Correlation.csv", sep = ",", row.names = F, col.names = F)
write.table(t(res[[1]]), "Fig_Timescale_Pedagogical_WaveletPhasorMeanField.csv", sep = ",", row.names = F, col.names = F)
write.table(t(res[[3]]), "Fig_Timescale_Pedagogical_Frequencies.csv", sep = ",", row.names = F, col.names = F)
write.table(q_value, "Fig_Timescale_Pedagogical_SignificantValue.csv", sep = ",", row.names = F, col.names = F)
write.table(decomposition, "Fig_Timescale_Pedagogical_Decomposition.csv", sep = ",", row.names = F, col.names = F)
