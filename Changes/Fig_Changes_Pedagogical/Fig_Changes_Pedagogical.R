# The following script synthesizes data to illustrate examples of changes in synchrony
# with respect to timescale, time, and geography. Example time series are created 
# using sinusoidal functions. Wavelet analysis performed in wsyn.
# Ethan Kadiyala, 10/18/2023
# Created in R version 4.1.0

library(wsyn)
library(tidyverse)
library(patchwork)
library(paletteer)

# Row 1 construct 4 time series piecing together two frequencies -------------------------------------------------
b1 <- 1
b2 <- 2
b3 <- 3
b4 <- 4

scale_coef <- 2 # to scale the amplitudes of the time series on the plot

timeinc<-1 #  sample per year
startfreq<-0.2 # cycles per year
endfreq<-0.2 # cycles per year
times<-1:100 

f <- seq(from=startfreq,length.out=length(times),to=endfreq) # frequency for each sample
phaseinc <- 2*pi*cumsum(f*timeinc)
t.series <- sin(phaseinc)/2

# make dt of times and time series
dt <- tibble(time = 1:length(times))

sig <- .3
amp <- seq(from = 1, to = .2, length.out = length(times))

set.seed(5487)
# append time series, have noise decrease and period increase with time
dt$t1 <- ( rnorm(length(times),0, sig)*amp + t.series*rev(amp) ) / scale_coef
dt$t2 <- ( rnorm(length(times),0, sig)*amp + t.series*rev(amp) ) / scale_coef
dt$t3 <- ( rnorm(length(times),0, sig)*amp + t.series*rev(amp) ) / scale_coef
dt$t4 <- ( rnorm(length(times),0, sig)*amp + t.series*rev(amp) ) / scale_coef


# plot 4 timeseries on one panel to be paired with WMF plot
p1 <- dt %>% 
  dplyr::select(time:t4) %>% 
  mutate(t1 = t1 + b1,
         t2 = t2 + b2,
         t3 = t3 + b3,
         t4 = t4 + b4) %>% 
  pivot_longer(cols = c("t1","t2","t3","t4")) %>%
  ggplot(aes(x = time, y = value, group = name)) +
  geom_line() +
  theme_bw(base_size = 17) +
  theme(panel.grid = element_blank(),
        axis.text = element_text(color = "black"),
        axis.ticks.length=unit(-0.15, "cm")) +
  xlab(element_blank()) +
  scale_x_continuous(limits = c(1,100), breaks = c(1,25,50,75,100), labels = c(0,25,50,75,100), expand = c(0.01,0.01)) +
  scale_y_continuous("", breaks = c(1,2,3,4))

p1

# wrangle, drop irrelevant columns
dat <- dt %>% 
  pivot_longer(cols = c("t1","t2","t3","t4")) %>%
  pivot_wider(names_from = time, values_from = value) %>% 
  dplyr::select(-name) %>% 
  as.matrix()

# pass through clean dat function
times = 1:ncol(dat)
dat <- cleandat(dat, times, 1)$cdat

# Define plot arguments for consistent WMF plots ---------------------------
WMF_lab <- 3.6
WMF_axis <- 2.8
WMF_ticks <- .5
WMF_spacing <- c(3.9,1.3,0)
WMF_margins <- c(5,6.75,1,4)
WMF_legendwidth <- 2
WMF_legendmar <- 7

# plot WMF
res1<-wmf(dat,times, scale.max.input = 30)

timescales <- res1$timescales        # save timescales for plot customization
ylocs <- pretty(timescales, n = 8)   # set axis intervals
xlocs <- pretty(times, n = 8)

par(mar= WMF_margins, cex.lab = WMF_lab, cex.axis = WMF_axis, tcl = WMF_ticks, mgp = WMF_spacing)
plotmag(res1,  legend.width = WMF_legendwidth, legend.mar = WMF_legendmar) 
axis(1, at = xlocs, labels = xlocs, lwd = 2)
axis(2, at = log2(ylocs), labels = ylocs, lwd = 2)


pdf("Fig_Changes_Pedagogical_ChangeTimeWMF.pdf", width = 12, height = 7.5)
par(mar= WMF_margins, cex.lab = WMF_lab, cex.axis = WMF_axis, tcl = WMF_ticks, mgp = WMF_spacing)
plotmag(res1, legend.width = WMF_legendwidth, legend.mar = WMF_legendmar)
axis(1, at = xlocs, labels = xlocs, lwd = 2)
axis(2, at = log2(ylocs), labels = ylocs, lwd = 2)
dev.off()


# Row 2 - decrease frequencies over time  ----------------------------------------------------

scale_coef <- 2.5 # to scale the amplitudes of the timeseries on the plot

timeinc<-1 #  sample per year
startfreq<-0.4 # cycles per year
endfreq<-0.1 # cycles per year
times<-1:100 

f<-seq(from=startfreq,length.out=length(times),to=endfreq) #frequency for each sample
phaseinc<-2*pi*cumsum(f*timeinc)
t.series<-sin(phaseinc)/2


# make dt of times and time series
dt <- tibble(time = times)

sig2 <- .3

set.seed(8201)

# append time series
dt$t1 <- c(t.series + rnorm(length(times),0, sig2)) / scale_coef

dt$t2 <- c(t.series + rnorm(length(times),0, sig2)) / scale_coef

dt$t3 <-c(t.series + rnorm(length(times),0, sig2)) / scale_coef

dt$t4 <- c(t.series + rnorm(length(times),0, sig2)) / scale_coef


# plot 4 timeseries on one panel to be paired with WMF plot
p2 <- dt %>% 
  dplyr::select(time:t4) %>% 
  mutate(t1 = t1 + b1,
         t2 = t2 + b2,
         t3 = t3 + b3,
         t4 = t4 + b4) %>% 
  pivot_longer(cols = c("t1","t2","t3","t4")) %>%
  ggplot(aes(x = time, y = value, group = name)) +
  geom_line() +
  theme_bw(base_size = 17) +
  theme(panel.grid = element_blank(),
        axis.text = element_text(color = "black"),
        axis.ticks.length=unit(-0.15, "cm"),
        axis.title.y = element_text(size = 20)) +
  xlab(element_blank()) +
  scale_x_continuous(limits = c(1,100), breaks = c(1,25,50,75,100), labels = c(0,25,50,75,100), expand = c(0.01,0.01)) +
  scale_y_continuous("Site", breaks = c(1,2,3,4))

p2

# wrangle, drop irrelevant columns
dat <- dt %>% 
  pivot_longer(cols = c("t1","t2","t3","t4")) %>%
  pivot_wider(names_from = time, values_from = value) %>% 
  dplyr::select(-name) %>% 
  as.matrix()

# pass through clean dat function
times = 1:ncol(dat)
dat <- cleandat(dat, times, 1)$cdat

# plot WMF
res2<-wmf(dat,times, scale.max.input = 30)
par(mar= WMF_margins, cex.lab = WMF_lab, cex.axis = WMF_axis, tcl = WMF_ticks, mgp = WMF_spacing)
plotmag(res2,legend.width = WMF_legendwidth, legend.mar = WMF_legendmar)
axis(1, at = xlocs, labels = xlocs, lwd = 2)
axis(2, at = log2(ylocs), labels = ylocs, lwd = 2)

pdf("Fig_Changes_Pedagogical_ChangeTimescaleWMF.pdf", width = 12, height = 7.5)
par(mar= WMF_margins, cex.lab = WMF_lab, cex.axis = WMF_axis, tcl = WMF_ticks, mgp = WMF_spacing)
plotmag(res2, legend.width = WMF_legendwidth, legend.mar = WMF_legendmar)
axis(1, at = xlocs, labels = xlocs, lwd = 2)
axis(2, at = log2(ylocs), labels = ylocs, lwd = 2)
dev.off()


# Row 3 plot sites and abrupt change at two sites -------------------

# construct 4 time series, sites 1 and 2 experience abrupt change
scale_coef <- 2

# sites 1 and 2
# first half
timeinc<-1 #  sample per year
startfreq<-0.05 # cycles per year
endfreq<-0.05 # cycles per year
times<-1:50 

f<-seq(from=startfreq,length.out=length(times),to=endfreq) #frequency for each sample
phaseinc<-2*pi*cumsum(f*timeinc)
t.series.1<-sin(phaseinc)/2

# second half
timeinc<-1 #  sample per year
startfreq<-0.1 # cycles per year
endfreq<-0.1 # cycles per year
times<-1:50 

f<-seq(from=startfreq,length.out=length(times),to=endfreq) # frequency for each sample
phaseinc2<-2*pi*cumsum(f*timeinc) + phaseinc[length(phaseinc)] # this adds more continuity to the abrupt change time series
t.series.2<-sin(phaseinc2)/2

# combine both components
t.series <- c(t.series.1, t.series.2)

# make dt of times and time series
dt <- tibble(time = 1:100)

sig2 <- .15

# append time series
set.seed(8338)
dt$t1 <- c(t.series + rnorm(length(times),0, sig2)) / scale_coef
dt$t2 <- c(t.series + rnorm(length(times),0, sig2)) / scale_coef


# sites 3 and 4
timeinc<-1 #  sample per year
startfreq<-0.05 # cycles per year
endfreq<-0.05 # cycles per year
times<-1:100 

f<-seq(from=startfreq,length.out=length(times),to=endfreq) #frequency for each sample
phaseinc<-2*pi*cumsum(f*timeinc)
t.series<-sin(phaseinc)/2.5


# append time series
dt$t3 <-c(t.series + rnorm(length(times),0, sig2)) / scale_coef
dt$t4 <- c(t.series + rnorm(length(times),0, sig2)) / scale_coef

# plot
p4 <- dt %>% 
  dplyr::select(time:t4) %>% 
  mutate(t1 = t1 + b1,
         t2 = t2 + b2,
         t3 = t3 + b3,
         t4 = t4 + b4) %>% 
  pivot_longer(cols = c("t1","t2","t3","t4")) %>%
  ggplot(aes(x = time, y = value, group = name)) +
  geom_line() +
  theme_bw(base_size = 17) +
  theme(panel.grid = element_blank(),
        axis.text = element_text(color = "black"),
        axis.ticks.length=unit(-0.15, "cm")) +
  xlab(element_blank()) +
  scale_x_continuous(limits = c(1,100), breaks = c(1,25,50,75,100), labels = c(0,25,50,75,100), expand = c(0.01,0.01)) +
  scale_y_continuous("", breaks = c(1,2,3,4))

p4


# construct synchrony matrices
dat <- dt %>% 
  pivot_longer(cols = c("t1","t2","t3","t4")) %>%
  pivot_wider(names_from = time, values_from = value) %>% 
  dplyr::select(-name) %>% 
  as.matrix()

dat1 <- cleandat(dat[, 1:50], 1:50, 1)$cdat    # pre change
dat2 <- cleandat(dat[, 51:100], 1:50, 1)$cdat  # post change

sm1 <- synmat(dat1, 1:50, method="pearson")
# fields::image.plot(1:4,1:4,sm1,col=heat.colors(20))

sm2 <- synmat(dat2, 1:50, method="pearson")
# fields::image.plot(1:4,1:4,sm2,col=heat.colors(20))


# convert to a 3 column data frame (first half)
rowCol <- expand.grid(1:4, 1:4)

labs <- rowCol[as.vector(upper.tri(sm1,diag=T)),]
corr_df <- cbind(labs, sm1[upper.tri(sm1,diag=T)])
colnames(corr_df) <- c("Row","Col","corr")


labs <- rowCol[as.vector(lower.tri(sm1,diag=T)),]
corr_df_bind <- cbind(labs, sm1[lower.tri(sm1,diag=T)])
colnames(corr_df_bind) <- c("Row","Col","corr")

corr_df_pre <- rbind(corr_df, corr_df_bind)

# plot first half correlation matrix
p5 <- corr_df_pre %>% 
  ggplot(aes(x = Row, y = Col, fill = corr)) +
  geom_tile() +
  scale_fill_gradientn(colours=rev(paletteer_c("grDevices::Blues", 10)), 
                       na.value = "grey",
                       breaks=c(0,0.5,1),
                       limits=c(-.1,1))+
  theme_bw(base_size = 25) +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_text(color = "black"),
        aspect.ratio = 1,
        legend.position = "none",
        plot.title = element_text(hjust = 0.5, size = 23)) +
  coord_cartesian(expand = F) +
  ylab("Site") +
  xlab(element_blank()) +
  labs(fill = "Synchrony") +
  labs(title = "Pre-abrupt change", position = "top center")

p5

# convert to a 3 column data frame (second half)
rowCol <- expand.grid(1:4, 1:4)

labs <- rowCol[as.vector(upper.tri(sm2,diag=T)),]
corr_df <- cbind(labs, sm2[upper.tri(sm2,diag=T)])
colnames(corr_df) <- c("Row","Col","corr")


labs <- rowCol[as.vector(lower.tri(sm2,diag=T)),]
corr_df_bind <- cbind(labs, sm2[lower.tri(sm2,diag=T)])
colnames(corr_df_bind) <- c("Row","Col","corr")

corr_df_post <- rbind(corr_df, corr_df_bind)

# plot second half correlation matrix
p6 <- corr_df_post %>% 
  ggplot(aes(x = Row, y = Col, fill = corr)) +
  geom_tile() +
  scale_fill_gradientn(colours=rev(paletteer_c("grDevices::Blues", 10)), 
                       na.value = "grey",
                       breaks=c(0,0.5,1),
                       limits=c(-.2,1))+     # in case of negative correlation by chance
  theme_bw(base_size = 25) +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_text(color = "black"),
        aspect.ratio = 1,
        legend.position = "none",
        plot.title = element_text(hjust = 0.5, size = 23)) +
  coord_cartesian(expand = F) +
  xlab(element_blank()) +
  ylab(element_blank()) +
  labs(fill = "Synchrony")+
  labs(title = "Post-abrupt change", position = "top center")

p6

# get only the legend
p7 <- corr_df_post %>% 
  filter(corr == -9999) %>% 
  ggplot(aes(x = Row, y = Col, fill = corr)) +
  geom_tile() +
  scale_fill_gradientn(colours=rev(paletteer_c("grDevices::Blues", 10)), 
                       na.value = "grey",
                       breaks=c(0,0.5,1),
                       limits=c(-.1,1))+ 
  theme_bw(base_size = 22) +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_text(color = "black"),
        aspect.ratio = 1,
        legend.position = "top") +
  coord_cartesian(expand = F) +
  xlab(element_blank()) +
  ylab(element_blank()) +
  labs(fill = "Synchrony")

p7


# construct panel in patchwork, save plots --------------------------------

# patch sections
patch1 <- p1 / p2 / p4
patch1 + xlab("Time") + theme(axis.title.x = element_text(size = 20))
ggsave("Fig_Changes_Pedagogical_Timeseries.pdf", width = 7, height = 10)

patch2 <- (p5 | p6) + xlab("Site")
patch2 
ggsave("Fig_Changes_Pedagogical_Matrices.pdf", width = 7.5, height = 10)

p7
ggsave("Fig_Changes_Pedagogical_MatrixLegend.pdf", width = 8, height = 7)
