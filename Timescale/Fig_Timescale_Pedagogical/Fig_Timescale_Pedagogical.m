% The following script takes 10 synthesized timeseries and compares the
% applicaiton of non-timesclae specific techniques (correlaion) to
% timescale specific methods (wavelet mean fields). Example timeseries
% creation and correlation calculation included. Reproducible timeseries,
% correlaions, timescale vector, and wavelet mean field examples are
% performed using saved csv files.
% Written by Lawrence Sheppard, edited by Ethan Kadiyala, 10/18/2023
% Created in MATLAB R2021a

close all
clear all

a=1.6%0.5; %noise
b=1; %10yr
c=3; %4yr
t=[0.5:34.5];
f=0.1*[0.7:(0.6/34):1.3];

for n=1:10
 sig(n,:)=a*randn(1,35)+b*sin(2*pi*f.*t)+c*sin(2*pi*(rand+0.25*t));
end

rho=NaN(10,10);
for n1=1:10
    for n2=n1+1:10
        [rho(n1,n2),pval]=corr(sig(n1,:)',sig(n2,:)');  % corr() funciton requires the statistics and machine learning toolbox
    end                                        
end

s1=b*sin(2*pi*f.*t);
s2=c*sin(2*pi*(rand+0.25*t));
s3=a*randn(1,35);

% load saved timeseries, correlation, and wavelet mean field for figure
sig = csvread('Fig_Timescale_Pedagogical_Timeseries.csv');
rho = csvread('Fig_Timescale_Pedagogical_Correlation.csv');
scalefrequency1 = csvread('Fig_Timescale_Pedagogical_Frequencies.csv');
mf = readmatrix('Fig_Timescale_Pedagogical_WaveletMeanField.csv');

% example decomposition
 figure
 subplot(4,1,2)
 plot(t,s1)
ylim([-5 5])
 ylabel('low f signal')
xlim([0 35])
xlabel('year')

subplot(4,1,3)
 plot(t,s2)
ylim([-5 5])
xlim([0 35])
 ylabel('high f signal')
xlabel('year')

subplot(4,1,4)
  plot(t,s3)
ylim([-5 5])
xlim([0 35])
 ylabel('noise')
xlabel('year')

subplot(4,1,1)
 plot(t,s1+s2+s3)
ylim([-5 5])
xlim([0 35])
 ylabel('signal')
xlabel('year')
set(gcf, 'paperpositionmode','manual','paperunits','inches','paperposition',[0 0 3.25 4],'papersize',[3.25 4])
    eval(['print -dpdf -r600 Fig_Timescale_PedagogicalDecomposition'])   

% visualize timeseries 
figure;
% subplot(3,1,1); 
hold on
for n=1:10
    plot(t,sig(n,:)+2+6*n);
end
ylim([0 70])
xlim([0 35])
ylabel('Abundance')
xlabel('Time (years)')
set(gcf, 'paperpositionmode','manual','paperunits','inches','paperposition',[0 0 4 2],'papersize',[4 2])
    eval(['print -dpdf -r600 Fig_Timescale_PedagogicalTimseries'])   

% distribution of correlation between timeseries
    figure
hold on
hist(rho(:),[-0.9:0.2:0.9])
xlim([-1 1])
ylabel('Frequency')
xlabel('Pearson correlation coefficient (r)')
set(gcf, 'paperpositionmode','manual','paperunits','inches','paperposition',[0 0 4 2],'papersize',[4 2])
    eval(['print -dpdf -r600 Fig_Timescale_PedagogicalCorrelation'])   

% wavelet mean field
    figure
hold on
surf(1./scalefrequency1,t,abs(mf'),abs(mf'))
shading interp
colormap('jet')
contour3(1./scalefrequency1,t,abs(mf'),[5.8 5.8],'k', LineWidth = 1.5)
set(gca,'xscale','log','xtick',[2 5 10 20],'xticklabel',[2 5 10 20])
axis tight
ylabel('Year')
xlabel('    Timescale of \newline synchrony (years)')
set(gcf, 'paperpositionmode','manual','paperunits','inches','paperposition',[0 0 3.25 4],'papersize',[3.25 4])
    eval(['print -dpdf -r600 Fig_Timescale_PedagogicalWMF'])   
