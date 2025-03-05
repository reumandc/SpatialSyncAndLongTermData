% The following script takes 10 synthesized timeseries and compares the
% applicaiton of non-timesclae specific techniques (correlation) to
% timescale specific methods (wavelet phasor mean fields). Reproducible timeseries,
% correlaions, timescale vector, and wavelet phasor mean field examples are
% performed using saved csv files produced by the Data Synthesis R script.
% Written by Lawrence Sheppard, edited by Ethan Kadiyala, 10/18/2023
% Created in MATLAB R2021a

close all
clear all

% load saved timeseries, correlation, and wavelet mean field for figure
sig = csvread('Fig_Timescale_Pedagogical_Timeseries.csv');
rho = readmatrix('Fig_Timescale_Pedagogical_Correlation.csv');
scalefrequency = csvread('Fig_Timescale_Pedagogical_Frequencies.csv');
mf = readmatrix('Fig_Timescale_Pedagogical_WaveletPhasorMeanField.csv');
q_value = csvread('Fig_Timescale_Pedagogical_SignificantValue.csv');
decomposition = csvread('Fig_Timescale_Pedagogical_Decomposition.csv');

t = 0.5:34.5; % vector of time for ploting

% example decomposition
 figure
 subplot(4,1,2)
 plot(t,decomposition(1,:))
ylim([-5 5])
 ylabel('low f signal')
xlim([0 35])
xlabel('year')

subplot(4,1,3)
 plot(t,decomposition(2,:))
ylim([-5 5])
xlim([0 35])
 ylabel('high f signal')
xlabel('year')

subplot(4,1,4)
  plot(t,decomposition(3,:))
ylim([-5 5])
xlim([0 35])
 ylabel('noise')
xlabel('year')

subplot(4,1,1)
 plot(t,(decomposition(1,:) + decomposition(2,:) + decomposition(3,:))*.9) % scale down by 10% to fit in margins
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
    eval(['print -dpdf -r600 Fig_Timescale_PedagogicalTimeseries'])   

% distribution of correlation between timeseries
    figure
hold on
hist(rho(:),[-0.9:0.2:0.9])
xlim([-1 1])
ylabel('Frequency')
xlabel('Pearson correlation coefficient (r)')
set(gcf, 'paperpositionmode','manual','paperunits','inches','paperposition',[0 0 4 2],'papersize',[4 2])
    eval(['print -dpdf -r600 Fig_Timescale_PedagogicalCorrelation'])   

% wavelet phasor mean field
    figure
hold on
surf(scalefrequency,t,abs(mf'),abs(mf'))
shading interp
colormap('jet')
contour3(scalefrequency,t,abs(mf'),[q_value   q_value],'k', LineWidth = 2)
set(gca,'xscale','log','xtick',[2 5 10 20],'xticklabel',[2 5 10 20])
axis tight
ylabel('Year')
xlabel('    Timescale of \newline synchrony (years)')
set(gcf, 'paperpositionmode','manual','paperunits','inches','paperposition',[0 0 3.25 4],'papersize',[3.25 4])
    eval(['print -dpdf -r600 Fig_Timescale_PedagogicalWPMF'])   
