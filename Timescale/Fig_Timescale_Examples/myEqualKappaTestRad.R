#This is basically circular:::EqualKappaTestRad, but with modified error/warning handling.
#All I did was copy the code and modify a couple lines that do warnings. I also had to
#insert "circular::" in front of some functions from the circular package. 
#
myEqualKappaTestRad<-function (x, group) 
{
  x <- x%%(2 * pi)
  ns <- tapply(x, group, FUN = length)
  r.bars <- tapply(x, group, FUN = circular:::RhoCircularRad)
  rs <- r.bars * ns
  kappas <- tapply(x, group, FUN = function(x) circular:::MlevonmisesRad(x)[4])
  grps <- length(r.bars)
  n <- length(group)
  r.bar.all <- circular:::RhoCircularRad(x)
  kappa.all <- circular:::MlevonmisesRad(x)[4]
  warn1 <- 0
  if (r.bar.all < 0.45) {
    g1 <- function(x) {
      suppressWarnings(asin(sqrt(3/8) * x))
    }
    ws <- 4 * (ns - 4)/3
    g1s <- g1(2 * r.bars)
    U <- sum(ws * g1s^2) - sum(ws * g1s)^2/sum(ws)
    if (any(is.na(g1s))) {
      warn1 <- 1
      #warning("An argument outside of [-1,1] was passed to asin function in calculation of approximate chi-squared test statistic. Bartlett's test of homogeneity was used instead of the approximation using asin.")
    }
  }
  if (r.bar.all >= 0.45 & r.bar.all <= 0.7) {
    g2 <- function(x) {
      c1 <- 1.089
      c2 <- 0.258
      asinh((x - c1)/c2)
    }
    ws <- (ns - 3)/0.798
    g2s <- g2(r.bars)
    U <- sum(ws * g2s^2) - sum(ws * g2s)^2/sum(ws)
  }
  if (r.bar.all > 0.7 | warn1 == 1) {
    vs <- ns - 1
    v <- n - grps
    d <- 1/(3 * (grps - 1)) * (sum(1/vs) - 1/v)
    U <- 1/(1 + d) * (v * log((n - sum(rs))/v) - sum(vs * 
                                                       log((ns - rs)/vs)))
  }
  p.value <- 1 - pchisq(U, grps - 1)
  result <- list(kappa = kappas, kappa.all = kappa.all, rho = r.bars, 
                 rho.all = r.bar.all, df = grps - 1, statistic = U, p.value = p.value)
  return(result)
}