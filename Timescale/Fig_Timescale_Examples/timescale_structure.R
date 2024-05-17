source("myfft.R")
source("circ_homog.R")
source("myEqualKappaTestRad.R")

#Given a spatio-temporal dataset, this function implements one way of formally testing 
#whether the timescale structure in synchrony is significant. 
#
#The test pertains to phase synchrony, looking at the heterogeneity of circular 
#variance across timescales for the Fourier phases.
#
#Args
#dat          The time series. Cleaned already, typically that should involve gap filling 
#               and using wsyn::cleandat with clev=5. Matrix where each row is a time series.
#omit_freqs   2d vector with the lower and upper bounds of a range of frequencies to omit
#               from the analysis, in units of cycles per sampling interval for the time
#               series. The typical idea here is to perform a test where the annual 
#               frequency band is excluded. Default NA means omit no frequencies.
#
#Output - a named list with the following elements
#equal.kappa.test.res       The results of circular::equal.kappa.test. This is itself a 
#                             list with several components, see the docs for the function.
#equal.kappa.test.res.omit  Same as the above, but after omitting the frequencies.
#like.rat.test.res          The results of circ_homog
#like.rat.test.res          Same as the above, but after omitting the frequencies.
#
timescale_structure<-function(dat,omit_freqs=NA)
{
  #error checking
  if (any(!is.finite(dat)))
  {
    stop("Error in timescale_structure: dat cannot have missing entries")
  }
  if (!is.na(omit_freqs[1]) && (any(omit_freqs<0) || any(omit_freqs>0.5)))
  {
    stop("Error in timescale_structure: dat cannot have missing entries")
  }
  
  #now take ffts and get all phases
  fft1<-myfft(dat[1,],detrend=F,removezero=T,cutsym=T)
  freqs<-fft1$freq
  allffts<-matrix(complex(1,0,0),dim(dat)[1],length(fft1$fft))
  allffts[1,]<-fft1$fft
  for (counter in 2:dim(dat)[1])
  {
    allffts[counter,]<-myfft(dat[counter,],detrend=F,removezero=T,cutsym=T)$fft
  }
  allphases<-Arg(allffts) %% (2*pi)
  allphases[allphases==2*pi]<-0
  
  #now test heterogeneity across timescales using the circular::equal.kappa.test function
  allphases<-circular::circular(allphases)
  gp<-matrix(rep(1:(dim(allphases)[2]),each=dim(allphases)[1]),dim(allphases)[1],dim(allphases)[2])
  equal.kappa.test.res<-myEqualKappaTestRad(allphases,gp)
  
  #same thing again but exclude the frequencies in omit_freqs
  equal.kappa.test.res.omit<-NA
  if (!is.na(omit_freqs[1]))
  {
    allphases<-Arg(allffts) %% (2*pi)
    allphases[allphases==2*pi]<-0
    allphases<-allphases[,(freqs<omit_freqs[1]) | (freqs>omit_freqs[2])]
    gp<-matrix(rep(1:(dim(allphases)[2]),each=dim(allphases)[1]),dim(allphases)[1],dim(allphases)[2])
    equal.kappa.test.res.omit<-myEqualKappaTestRad(allphases,gp)
  }
  
  #now test heterogeneity across timescales using the likelihood ratio test approach
  allphases<-Arg(allffts) %% (2*pi)
  allphases[allphases==2*pi]<-0
  like.rat.test.res<-circ_homog(t(allphases))

  #now do the same thing again but exclude the frequencies in omit_freqs
  like.rat.test.res.omit<-NA
  if (!is.na(omit_freqs[1]))
  {
    allphases<-Arg(allffts) %% (2*pi)
    allphases[allphases==2*pi]<-0
    allphases<-allphases[,(freqs<omit_freqs[1]) | (freqs>omit_freqs[2])]
    like.rat.test.res.omit<-circ_homog(t(allphases))
  }
  
  #package and return results
  return(list(equal.kappa.test.res=equal.kappa.test.res,equal.kappa.test.res.omit=equal.kappa.test.res.omit,
              like.rat.test.res=like.rat.test.res,like.rat.test.res.omit=like.rat.test.res.omit))
}

