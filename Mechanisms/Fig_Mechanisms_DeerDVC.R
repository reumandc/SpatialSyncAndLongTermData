# Code for generating figure on deer and deer-vehicle collisions in the "Mechanisms.." section
# of the paper 
# Author: Thomas L. Anderson (thander@siue.edu)
# r version: 4.2.2
# required packages: cowplot_1.1.1; ggplot2_3.4.2

#load required packages
library(ggplot2)
library(cowplot)

#load data
deer<-read.csv("Fig_Mechanism_DeerDVC_deer.csv")
dvc<-read.csv("Fig_Mechanism_DeerDVC_dvc.csv")
abunsurr<-read.csv("Fig_Mechanism_DeerDVC_abunsurrsum.csv")
dvcsurr<-read.csv("Fig_Mechanism_DeerDVC_dvcsurrsum.csv")

#get quantiles of surrogates
abunsurrqt<-apply(abunsurr,2,function(x){quantile(x,probs=c(0.025,0.975))})
dvcsurrqt<-apply(dvcsurr,2,function(x){quantile(x,probs=c(0.025,0.975))})

#aggregate data to get state totals
statedat<-data.frame(Year=1981:2016,Abun=colSums(deer[,-1]),DVC=colSums(dvc[,-1]))

#make plots
p1<-ggplot()+
  geom_ribbon(aes(x=seq(1981,2016,1),ymin=abunsurrqt[1,]/1000,ymax=abunsurrqt[2,]/1000),linetype=2,fill="gray")+
  geom_point(data=statedat,aes(x=Year,y=Abun/1000))+
  geom_line(data=statedat,aes(x=Year,y=Abun/1000))+
  theme_classic()+
  labs(y="Deer Abundance (Ks)",x='Year')+
  theme(axis.title=element_text(size=18),axis.text=element_text(size=16))
  #geom_line(aes(x=seq(1981,2016,1),abunsurrqt[1,]),linetype=2)+
  #geom_line(aes(x=seq(1981,2016,1),abunsurrqt[2,]),linetype=2)
p2<-ggplot()+
  geom_ribbon(aes(x=seq(1987,2016,1),ymin=dvcsurrqt[1,],ymax=dvcsurrqt[2,]),linetype=2,fill="gray")+
  geom_point(data=statedat,aes(x=Year,y=DVC))+
  geom_line(data=statedat,aes(x=Year,y=DVC))+
  theme_classic()+
  scale_x_continuous(limits=c(1986,2016),breaks=seq(1986,2016,4),labels=seq(1986,2016,4))+
  labs(y="Deer-Vehicle Collisions",x='Year')+
  theme(axis.title=element_text(size=18),axis.text=element_text(size=16))

pdf('Fig_Mechanisms_DeerDVC.pdf',height=7,width=3.5)
#png('Results/deerfig.ecolettV2.png',res=600,height=7,width=3.5,units="in")
plot_grid(p1,p2,ncol=1,labels=c("A)","B)"))
dev.off()
