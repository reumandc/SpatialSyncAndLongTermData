# The following script generates 10 synthesized timeseries and calculates non-timescale
# specific metrics of synchrony (correlation) as well as timescale specific metrics
# (wavelet phasor mean field). Example timeseries are created using sinusoidal functions
# with random noise components. The outputs are saved as .csv files to be plotted in
# MATLAB.
# Written by Ethan Kadiyala based on MATLAB code from Lawrence Sheppard, 11/7/2023
# Created in R 4.1.0

library(wsyn)
source("get_q.R")   # convenience function to get significant values for WPMF (taken from wysn::wmpf())
set.seed(seed = 31338)


# create timeseries -------------------------------------------------------
a <- 1.6 # noise
b <- 1; # 8yr
c <- 3; # 4yr
t <- 0.5:34.5
f <- seq(from = .12, to = .17, length.out = 35)
times <- c(1:35)

sig <- matrix(nrow = 10, ncol = 35) # create 10 timeseries using for loop

for (n in c(1:10)) {
  sig[n,] <- c(a*rnorm(n = 35) + 
               b*sin(2*pi*f*t) +
               c*sin(2*pi*(runif(n = 1)+0.25*t))
               )
}


# take pariwise correlation -----------------------------------------------
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

res <- wpmf(dat = dat, times = times, sigmethod = "quick")

q_value <- get_q(res)[[1]]   # get the threshold for significant WPMF values

# create pedagogical signals for example decomposition --------------------
decomposition <- matrix(nrow = 3, ncol = 35)
decomposition[1,] <- b*sin(2*pi*f*t)
decomposition[2,] <- c*sin(2*pi*(runif(n = 1)+0.25*t +.1)) # add .1 to shift the oscillations when visualized in the example decomposition
decomposition[3,] <- a*rnorm(n = 35)


# save data to plot in matlab ---------------------------------------------
write.table(sig, "Fig_Timescale_Pedagogical_Timeseries.csv", sep = ",", row.names = F, col.names = F)
write.table(rho, "Fig_Timescale_Pedagogical_Correlation.csv", sep = ",", row.names = F, col.names = F)
write.table(t(res[[1]]), "Fig_Timescale_Pedagogical_WaveletPhasorMeanField.csv", sep = ",", row.names = F, col.names = F)
write.table(t(res[[3]]), "Fig_Timescale_Pedagogical_Frequencies.csv", sep = ",", row.names = F, col.names = F)
write.table(q_value, "Fig_Timescale_Pedagogical_SignificantValue.csv", sep = ",", row.names = F, col.names = F)
write.table(decomposition, "Fig_Timescale_Pedagogical_Decomposition.csv", sep = ",", row.names = F, col.names = F)
