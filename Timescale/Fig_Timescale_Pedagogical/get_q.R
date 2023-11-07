get_q <- function (res, sigthresh = 0.95) {
  # extracts the mag(WPMF) value that defines the significance threshold indicated by the input sigthresh 
  
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