myfft<-function(x,detrend=TRUE,removezero=TRUE,cutsym=TRUE)
{
  lx<-length(x)
  
  if (detrend==TRUE)
  {
    tforx<-1:lx
    x<-stats::residuals(stats::lm(x~tforx))
  }
  
  h<-stats::fft(x)
  freq<-(0:(lx-1))/lx
  
  if (removezero==TRUE)
  {
    h<-h[-1]
    freq<-freq[-1]
  }
  
  if (cutsym==TRUE)
  {
    h<-h[freq<=0.5]
    freq<-freq[freq<=0.5]
  }
  
  return(list(freq=freq,fft=h))
}