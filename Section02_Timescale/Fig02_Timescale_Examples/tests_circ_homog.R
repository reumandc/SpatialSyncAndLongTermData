context("circ_homog.R")

source("circ_homog.R")

test_that("test logLik_func_vonmises",{
  set.seed(101)
  
  #get some data
  samp<-circular:::RvonmisesRad(50,pi/2,5)  
  
  #just call the function and see if you get something numeric
  res1<-logLik_func_vonmises(parms=c(pi/2,5),samp)  
  testthat::expect_equal(class(res1),"numeric")
  
  #make sure the likelihood is higher for the true parameters than for very different parameters
  res2<-logLik_func_vonmises(parms=c(pi,5),samp)  
  testthat::expect_gt(res1,res2)
})

test_that("test fit_vonmises",{
  set.seed(101)
  
  #get some data, actually from the von Mises
  samp<-circular:::RvonmisesRad(5000,pi/2,5)
  
  #call the function
  res<-fit_vonmises(samp)
  
  #test format
  testthat::expect_equal(names(res),c("logLik","mu","kappa","optim_out"))
  
  #test values
  testthat::expect_lt(abs(pi/2-res$mu),.1)
  testthat::expect_lt(abs(5-res$kappa),.25)
})

test_that("test logLik_func_hom",{
  set.seed(101)
  
  #get some data
  samps<-matrix(NA,3,50)
  samps[1,]<-circular:::RvonmisesRad(50,pi/2,5)  
  samps[2,]<-circular:::RvonmisesRad(50,pi,5)  
  samps[3,]<-circular:::RvonmisesRad(50,3*pi/2,5)  
  
  #just call the function and see if you get something numeric
  res1<-logLik_func_hom(mus=c(pi/2,pi,3*pi/2),kappa=5,samps)  
  testthat::expect_equal(class(res1),"numeric")
  
  #make sure the likelihood is higher for the true parameters than for very different parameters
  res2<-logLik_func_hom(mus=c(3*pi/2,pi/2,pi),kappa=5,samps)  
  testthat::expect_gt(res1,res2)
})

test_that("test fit_hom",{
  set.seed(101)
  
  #get some data
  samps<-matrix(NA,3,500)
  samps[1,]<-circular:::RvonmisesRad(500,pi/2,5)  
  samps[2,]<-circular:::RvonmisesRad(500,pi,5)  
  samps[3,]<-circular:::RvonmisesRad(500,3*pi/2,5)  
  
  #call the function
  res<-fit_hom(samps)
  
  #test format
  testthat::expect_equal(names(res),c("logLik","mus","kappa","optim_out"))
  
  #test values
  testthat::expect_lt(abs(pi/2-res$mus[1]),.1)
  testthat::expect_lt(abs(pi-res$mus[2]),.1)
  testthat::expect_lt(abs(3*pi/2-res$mus[3]),.1)
  testthat::expect_lt(abs(5-res$kappa),.25)
})

test_that("test circ_homog",{
  set.seed(101)
  
  #get some data with the same kappa
  samps<-matrix(NA,3,500)
  samps[1,]<-circular:::RvonmisesRad(500,pi/2,5)  
  samps[2,]<-circular:::RvonmisesRad(500,pi,5)  
  samps[3,]<-circular:::RvonmisesRad(500,3*pi/2,5)  
  
  #call the function
  res<-circ_homog(samps)
  
  #test correct format
  testthat::expect_equal(names(res),c("logLik_hom","logLik_het","AIC_hom","AIC_het","LikRat_teststat","df","p"))
  
  #test correct values
  testthat::expect_equal(res$df,2)
  testthat::expect_gt(res$p,0.05)
  testthat::expect_gt(res$AIC_het-res$AIC_hom,2)
  
  #get some data with different kappas
  samps<-matrix(NA,3,500)
  samps[1,]<-circular:::RvonmisesRad(500,pi/2,1)  
  samps[2,]<-circular:::RvonmisesRad(500,pi,2.5)  
  samps[3,]<-circular:::RvonmisesRad(500,3*pi/2,5)  
  
  #call the function
  res<-circ_homog(samps)
  
  #test correct values
  testthat::expect_equal(res$df,2)
  testthat::expect_lt(res$p,0.01)
  testthat::expect_gt(res$AIC_hom-res$AIC_het,3)
})