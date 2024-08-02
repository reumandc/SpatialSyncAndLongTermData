## Changing geographies of synchrony in Jasper Ridge data

## Created in R version 4.2.1

rm(list=ls())

library(wsyn) #v 1.0.4
library(ecodist) #v 2.0.9
library(viridis) #v 0.6.2


setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

dat.raw <- read.csv("./JRG_cover_data.csv")
coords <- read.csv("./JRG_plot_coordinates.csv")

## convert into plot-by-year matrices

plots <- unique(dat.raw$uniqueID)
years <- 1983:2019

plantago.mat <- matrix(NA, nrow=length(plots), ncol=length(years))

for(ii in 1:length(plots)){
  for(jj in 1:length(years)){
    
    if(any(dat.raw$uniqueID==plots[ii] & dat.raw$year==years[jj])){
      plantago.mat[ii,jj] <- dat.raw$cover[dat.raw$uniqueID==plots[ii] & dat.raw$year==years[jj]]
    }

  }
}

#fill NAs with medians
for(ii in 1:length(plots)){
  
  if(any(is.na(plantago.mat[ii,]))){
    plantago.mat[ii,is.na(plantago.mat[ii,])] <- median(plantago.mat[ii,], na.rm=TRUE)
  }
  
}


plantago.cln <- cleandat(plantago.mat, years, clev=5)$cdat

pre <- 1983:2000
post <- 2002:2019


#make synchrony matrices and test differences
cormat.plantago.pre <- cor(t(plantago.cln[,years %in% pre]))
cormat.plantago.post <- cor(t(plantago.cln[,years %in% post]))

cor(lower(cormat.plantago.post), lower(cormat.plantago.pre))
mantel(as.dist(cormat.plantago.post) ~ as.dist(cormat.plantago.pre)) #p = 0.59

coords<-coords[match(plots, coords$ID),]

edgeMin1 <- quantile(lower(cormat.plantago.pre), 0.9)
edgeMin2 <- quantile(lower(cormat.plantago.post), 0.9)

## make figure

pdf("synchNet_pre_postInvasion.pdf", width=3, height=6)

par(mfrow=c(2,1), mar=c(3.1,3.1,1.4,0.6), mgp=c(2,0.7,0))
plot(NA, NA, xlim=range(coords$coordX), ylim=range(coords$coordY), asp=1,
     xlab="Plot X coordinate (m)", ylab="Plot Y coordinate (m)")

mtext("Pre-invasion", cex=1, line=0.1)

for(ii in 2:length(plots)){
  for(jj in 1:ii){
    if(cormat.plantago.pre[ii,jj] >= edgeMin1){
      lines(x=c(coords$coordX[ii], coords$coordX[jj]), y=c(coords$coordY[ii], coords$coordY[jj]))
    }
  }
}
points(coords$coordX, coords$coordY, pch=21, bg="darkgrey", cex=1.1)
text(par("usr")[1]+0.05*diff(par("usr")[1:2]),
     par("usr")[4]-0.05*diff(par("usr")[3:4]), "(a)")

plot(NA, NA, xlim=range(coords$coordX), ylim=range(coords$coordY), asp=1,
     xlab="Plot X coordinate (m)", ylab="Plot Y coordinate (m)")

mtext("Post-invasion", cex=1, line=0.1)

for(ii in 2:length(plots)){
  for(jj in 1:ii){
    if(cormat.plantago.post[ii,jj] >= edgeMin2){
      lines(x=c(coords$coordX[ii], coords$coordX[jj]), y=c(coords$coordY[ii], coords$coordY[jj]))
    }
  }
}
points(coords$coordX, coords$coordY, pch=21, bg="darkgrey", cex=1.1)
text(par("usr")[1]+0.05*diff(par("usr")[1:2]),
     par("usr")[4]-0.05*diff(par("usr")[3:4]), "(b)")

dev.off()

