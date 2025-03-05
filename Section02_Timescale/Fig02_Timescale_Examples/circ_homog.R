#Log likelihood function for the von Mises distribution.
#
#Args
#parms        A vector containing mu and then kappa, mu between 0 and 2*pi and kappa non-negative
#samp         The sample, values between 0 and 2*pi
#
logLik_func_vonmises<-function(parms,samp)
{
  if (length(parms)!=2 || parms[1]>=2*pi || parms[1]<0 || parms[2]<0)
  {
    stop("Error in logLik_func_vonmises: bad values in parms")
  }
  
  return(sum(circular:::DvonmisesRad(samp,parms[1],parms[2],log=TRUE)))
}

#Just a wrapper to facilitate dealing with parameters bounds and wrapping
#
#Args
#parms[1] is any real number, mu is taken to be parms[1] mod 2*pi
#parms[2] is any real number, kappa is taken to be exp(parms[2])
#
logLik_func_vonmises_wrapper<-function(parms,samp)
{
  mu<-(parms[1] %% (2*pi))
  kappa<-exp(parms[2])
  return(logLik_func_vonmises(parms=c(mu,kappa),samp))  
}

#Maximum likelihood fitting of the von Mises distribution
#
#Args
#samp         The sample, numeric values between 0 and 2*pi
#
#Output - a list with the following names elements
#logLik       The maximized log likelihood
#mu, kappa    The estimated parameters
#optim_out    Other outputs from optim, the optimizer used
#
fit_vonmises<-function(samp)
{
  if (any(samp<0) || any(samp>=2*pi))
  {
    stop("Error in fit_vonmises: entries in samp must be 0 to 2*pi")  
  }
  
  csamp<-circular::circular(samp)
  par0<-c(as.numeric(mean(csamp)),log(1/as.numeric(var(csamp))))
  optres<-optim(par=par0,fn=logLik_func_vonmises_wrapper,samp=samp,method="Nelder-Mead",
                control=list(fnscale=-1,maxit=10000))
  
  logLik<-optres$value
  mu<-(optres$par[1] %% (2*pi))
  kappa<-exp(optres$par[2])
  optim_out<-optres[3:5]
  
  return(list(logLik=logLik,mu=mu,kappa=kappa,optim_out=optim_out))
}

#Log likelihood function for the homogeneous variance model
#
#Args
#samps            An N by M matrix, where there are N distinct samples and M angles from each. 
#                   These are between 0 and 2*pi.
#mus              A vector of length N of mu parameters for the von Mises distribution that applies
#                   for each sample.
#kappa            The single kappa value that applies to all N von Mises distributions
#
logLik_func_hom<-function(mus,kappa,samps)
{
  if (any(mus>=2*pi) || any(mus<0) || kappa<0)
  {
    stop("Error in logLik_func_hom: bad values in mus or kappa")
  }
  if (dim(samps)[1]!=length(mus))
  {
    stop("Error in logLik_func_hom: dim(samps)[1] needs to equal length(mus)")  
  }
  
  logLik<-0
  for (counter in 1:(dim(samps)[1]))
  {
    logLik<-logLik+logLik_func_vonmises(parms=c(mus[counter],kappa),samps[counter,])
  }
  
  return(logLik)
}

#Just a wrapper to facilitate dealing with parameters bounds and wrapping
#
#Args
#All but the last entry of parms are real numbers, mus taken to be these values mod 2*pi
#The last entry of parms is any real number, kappa is taken to be exp() of it
#
logLik_func_hom_wrapper<-function(parms,samps)
{
  mus<-(parms[1:(length(parms)-1)] %% (2*pi))
  kappa<-exp(parms[length(parms)])
  return(logLik_func_hom(mus,kappa,samps))  
}

#Maximum likelihood fitting of the homogeneous kappas model
#
#Args
#samps            An N by M matrix, where there are N distinct samples and M angles from each. 
#                   These are numeric values between 0 and 2*pi.
#
#Output - a list with the following names elements
#logLik       The maximized log likelihood
#mus, kappa   The estimated parameters
#optim_out    Other outputs from optim, the optimizer used
#
fit_hom<-function(samps)
{
  if (any(samps<0) || any(samps>=2*pi))
  {
    stop("Error in fit_hom: entries in samp must be 0 to 2*pi")  
  }
  
  csamps<-circular::circular(samps)
  cmeans<-as.numeric(apply(FUN=mean,X=csamps,MARGIN=1))
  cvars<-as.numeric(apply(FUN=var,X=csamps,MARGIN=1))
  var_val<-(mean(sqrt(cvars)))^2
  par0<-c(cmeans,log(1/var_val))
  
  optres<-optim(par=par0,fn=logLik_func_hom_wrapper,samps=samps,method="BFGS",
                control=list(fnscale=-1,maxit=1000000))
  
  logLik<-optres$value
  parres<-optres$par
  mus<-(parres[1:(length(parres)-1)] %% (2*pi))
  kappa<-exp(parres[length(parres)])
  optim_out<-optres[3:5]
  
  return(list(logLik=logLik,mus=mus,kappa=kappa,optim_out=optim_out))
}

#This is a test of homogeneity of circular variances for a collection of samples of directional data.
#It's a parametric test using the von Mises distribution and the likelihood ratio test.
#
#For each sample, different mu parameters are allowed, and either different or the same kappa parameters
#are used, in two different models. Both models are fitted and the likelihood ratio test is applied.
#
#Args
#samps            An N by M matrix, where there are N distinct samples and M angles from each.
#                   These are numeric values between 0 and 2*pi.
#
#Output - a named list with these entries
#logLik_hom       Maximized log likelihood for the model with the same kappa parameters for all samples
#logLik_het       Similar but for the model that allows heterogeneous kappa parameters
#AIC_hom
#AIC_het          AICs for the two models
#LikRat_teststat  Test statistic for the Likelihood ratio test
#df               Degrees of freedom for the Chi-squared distribution
#p                p value for the test
#
circ_homog<-function(samps)
{
  if (any(samps<0) || any(samps>=2*pi))
  {
    stop("Error in circ_homog: entries in samp must be 0 to 2*pi")
  }

  #fit the heterogeneous-variance model, separately to each sample, and sum the logLik as you go
  N<-dim(samps)[1]
  M<-dim(samps)[2]
  logLik_het<-0
  for (sampcounter in 1:N)
  {
    thisres<-fit_vonmises(samps[sampcounter,])
    logLik_het<-logLik_het+thisres$logLik
    if ((thisres$optim_out$convergence!=0) || (!is.null(thisres$optim_out$message)))
    {
      stop("Error in circ_homog: fitting failed, location 1")
    }
  }
  AIC_het<-4*(dim(samps)[1])-2*logLik_het
  
  #fit the homogeneous variance model
  thisres<-fit_hom(samps)
  if ((thisres$optim_out$convergence!=0) || (!is.null(thisres$optim_out$message)))
  {
    print(thisres$optim_out)
    stop("Error in circ_homog: fitting failed, location 2")
  }
  logLik_hom<-thisres$logLik
  AIC_hom<-2*(dim(samps)[1]+1)-2*logLik_hom

  #now do the likelihood ratio test
  LikRat_teststat<-2*(logLik_het-logLik_hom)
  df<-dim(samps)[1]-1
  p<-pchisq(LikRat_teststat,df,lower.tail=FALSE)
  
  #now return results
  return(list(logLik_hom=logLik_hom,logLik_het=logLik_het,AIC_hom=AIC_hom,AIC_het=AIC_het,LikRat_teststat=LikRat_teststat,
              df=df,p=p))
}

