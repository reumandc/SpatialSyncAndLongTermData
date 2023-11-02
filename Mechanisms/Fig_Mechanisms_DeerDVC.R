# Code for generating figure on deer and deer-vehicle collisions in the "Mechanisms.." section
# of the paper 
# Author: Thomas L. Anderson (thander@siue.edu)
# r version: 4.2.2
# required packages: cowplot_1.1.1; ggplot2_3.4.2

#load required packages
library(ggplot2)
library(cowplot)

#load data
deer<-read.csv("Fig_Mechanisms_DeerDVC_deer.csv")
dvc<-read.csv("Fig_Mechanisms_DeerDVC_dvc.csv")
abunsurr<-read.csv("Fig_Mechanisms_DeerDVC_abunsurrsum.csv")
dvcsurr<-read.csv("Fig_Mechanisms_DeerDVC_dvcsurrsum.csv")

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
  theme_bw()+
  scale_x_continuous(limits=c(1980,2016),breaks=seq(1980,2016,10),labels=c(rep("",4)))+
  labs(y="Deer abundance \n(Thousands)",x='')+
  theme(axis.title=element_text(size=16,color="black"),
        axis.text=element_text(size=14,color="black"),
        panel.grid=element_blank())

p2<-ggplot()+
  geom_ribbon(aes(x=seq(1987,2016,1),ymin=dvcsurrqt[1,]/1000,ymax=dvcsurrqt[2,]/1000),linetype=2,fill="gray")+
  geom_point(data=statedat,aes(x=Year,y=DVC/1000))+
  geom_line(data=statedat,aes(x=Year,y=DVC/1000))+
  theme_bw()+
  scale_x_continuous(limits=c(1980,2016),breaks=seq(1980,2016,10),labels=seq(1980,2016,10))+
  labs(y="Deer-vehicle collisions \n(Thousands)",x='Year')+
  theme(axis.title=element_text(size=16,color="black"),axis.text=element_text(size=14,color="black"),panel.grid=element_blank())

pdf('Fig_Mechanisms_DeerDVC.pdf',height=7,width=5)
#png('Results/deerfig.ecolettV2.png',res=600,height=7,width=3.5,units="in")
plot_grid(p1,p2,ncol=1,labels=c("(a)","(b)"),align="hv",hjust=-4.5,vjust=1.7)
dev.off()
