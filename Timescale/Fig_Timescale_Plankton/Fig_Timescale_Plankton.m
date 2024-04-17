clear all; 

%Data
%
x=webread('https://dassh.ac.uk/downloads/mba_rdm/PCI_NEATl.xlsx') ;
% https://doi.mba.ac.uk/data/3152
% DOI:
% 10.17031/65705f59bc0eb
% 
% Preferred Citation:
% David Johns (Marine Biological Association) (2023): CPR PCI North Atlantic. The Archive for Marine Species and Habitats Data (DASSH). (Dataset). https://doi.org/10.17031/65705f59bc0eb

% Guidelines:
% 
% Figures in vector format (PDF or EPS). If that is not possible, a 600 DPI image in TIFF format is OK. JPEG is not accepted.
% All fonts san serif, preferably Arial, and black in color. Some of the axis fonts are currently dark grey.
% All axis labels in sentence case: e.g., â€œYearâ€? not â€œyearâ€?, and â€œDeer abundanceâ€? not â€œDeer Abundanceâ€?
% All wording clearly legible at the typical size you would view the figure in a paper (not zoomed in). If you have to ask whether the font is too small, it is probably too small. Err on the larger side.
% No text overlapping other text.
% All subpanels labeled with lowercase letters within full parentheses: (a), (b), (c), etc.
% All data plots with a full thin black border (i.e., lines on all four sides), rather than lines only on the x- and y-axes.
% All pictures of organisms with a thin black border.
% All heatmaps and wavelet plots in the â€œjetâ€? colors (https://rdocumentation.org/packages/mixOmics/versions/5.0-3/topics/jet.colors in R, or https://www.mathworks.com/help/matlab/ref/jet.html in Matlab).

pci=table2array(x(:,7));
year=table2array(x(:,5));
month=table2array(x(:,6));
lat=table2array(x(:,2));
long=table2array(x(:,3));

firstyearall(1)=1984;
lastyearall(1)=2013;
firstyearall(2)=1958;
lastyearall(2)=2013;
firstyearall(3)=1946;
lastyearall(3)=2021; %2022 is incomplete

% compile time-series in a standard way, for three different intervals,
% find transforms and mean fields
for yearlims=1:3
firstyear=firstyearall(yearlims);
lastyear=lastyearall(yearlims);

useindex=find((lat>=50).*(lat<60).*(long>=-10).*(long<10).*(year>=firstyear).*(year<=lastyear));

yearindex=year(useindex)+1-firstyear;
monthindex=month(useindex);
latindex=floor((lat(useindex)-50)/2)+1;
longindex=floor((long(useindex)+10)/2)+1;
pciindex=pci(useindex);

%set up empty datasets for each year/month/lat/long
clear dataset
for y=1:lastyear+1-firstyear
    for m=1:12
        for lat1=1:5
            for long1=1:10
                dataset{y,m,lat1,long1}=[];
            end
        end
    end
end

%fill in the avilable samples
for n=1:length(pciindex)
    dataset{yearindex(n),monthindex(n),latindex(n),longindex(n)}=[dataset{yearindex(n),monthindex(n),latindex(n),longindex(n)} pciindex(n)];
end

%timeseries with NaNs
clear pciseries
for y=1:lastyear+1-firstyear
    for m=1:12
        for lat1=1:5
            for long1=1:10
                pciseries{lat1,long1}((y-1)*12+m)=mean(dataset{y,m,lat1,long1},"omitnan");
            end
        end
    end
end

%monthly medians
clear mpciseries
for m=1:12
    for lat1=1:5
        for long1=1:10
            mpciseries{lat1,long1}(m)=median(pciseries{lat1,long1}(([1:lastyear+1-firstyear]-1)*12+m),"omitnan");
        end
    end
end

% fill timeseries
clear nnpciseries
for y=1:lastyear+1-firstyear
    for m=1:12
        for lat1=1:5
            for long1=1:10
                if isnan(pciseries{lat1,long1}((y-1)*12+m))
                    nnpciseries{lat1,long1}((y-1)*12+m)=mpciseries{lat1,long1}(m);
                else
                    nnpciseries{lat1,long1}((y-1)*12+m)=pciseries{lat1,long1}((y-1)*12+m);
                end
            end
        end
    end
end

% transform timeseries
parameters.wavelet.sigma=1.05;
parameters.wavelet.scale_min=2;
parameters.wavelet.scale_max=12*100;
f0=0.5;
sf1=sf_comments(parameters);
count=0;
clear wtresult
for lat1=1:5
    for long1=1:10
        if sum(isnan(pciseries{lat1,long1}))<0.5*length(pciseries{lat1,long1});
            count=count+1;
            [wtresult{count}] = mwt_comments(nnpciseries{lat1,long1}-mean(nnpciseries{lat1,long1}), parameters, f0)   ;
        end
    end
end
countall{yearlims}=count;
%mean fields
[wpmfresult1{yearlims}] = wpmf_comments(wtresult,count);

end

%%%an artificial decade of data:
seriesdecade=randn(1,120);
[wtresulttest] = mwt_comments(seriesdecade, parameters, f0)   ;


figure; 
subplot(3,1,1); hold on;
surf(firstyearall(1)+1/12:1/12:lastyearall(1)+1,12*sf1,abs(wpmfresult1{1})); view(2); shading interp; set(gca,'yscale','log'); colormap jet;
contour(firstyearall(3)+1/12:1/12:lastyearall(3)+1,12*sf1,isfinite(wpmfresult1{3}),[1 1],'k'); 
contour(firstyearall(2)+1/12:1/12:lastyearall(2)+1,12*sf1,isfinite(wpmfresult1{2}),[1 1],'k'); 
line([2015 2015],[0.25 0.5],[0 0],'Color','black', 'LineWidth', 10)
xlim([min(year) max(year)])
ylim([0.01 6])
ylabel('Cycles/yr')
yticks([0.01 0.02 0.1 0.2 1 2])
yticklabels([0.01 0.02 0.1 0.2 1 2])
text(1948, 0.03, 0, '(a)')
box on
caxis([0 1])
cb=colorbar;
set(cb,'Position',[0.25 0.75 0.1, 0.1])


subplot(3,1,2); hold on
surf(firstyearall(2)+1/12:1/12:lastyearall(2)+1,12*sf1,abs(wpmfresult1{2})); view(2); shading interp; set(gca,'yscale','log'); colormap jet;
contour3(1960+1/12:1/12:1970,12*sf1,isfinite(wtresulttest),[100 100],'k'); %comment out to restore reference ticklines to plot
line([1958 1958],[0.02 0.25],[0 0],'Color','red', 'LineWidth', 10)
line([2015 2015],[0.02 0.5],[0 0],'Color','blue', 'LineWidth', 10)
xlim([min(year) max(year)])
ylim([0.01 6])
ylabel('Cycles/yr')
yticks([0.01 0.02 0.1 0.2 1 2])
yticklabels([0.01 0.02 0.1 0.2 1 2])
text(1948, 0.03, 0, '(b)')
box on
caxis([0 1])

subplot(3,1,3); hold on;
surf(firstyearall(3)+1/12:1/12:lastyearall(3)+1,12*sf1,abs(wpmfresult1{3})); view(2); shading interp; set(gca,'yscale','log'); colormap jet;
contour3(1960+1/12:1/12:1970,12*sf1,isfinite(wtresulttest),[1 1],'k'); 
xlim([min(year) max(year)])
ylim([0.01 6])
ylabel('Cycles/yr')
yticks([0.01 0.02 0.1 0.2 1 2])
yticklabels([0.01 0.02 0.1 0.2 1 2])
xlabel('Year')
text(1948, 0.03, 0, '(c)')
box on
caxis([0 1])

axes('pos',[.85 .85 .1 .1])
imshow('echinoderm1b.jpg')
axes('pos',[.85 .75 .1 .1])
imshow('decapod1b.jpg')
axes('pos',[.85 .5 .1 .1])
imshow('Calfin1b.jpg')
axes('pos',[.17 .42 .1 .2])
imshow('thermometer.jpg')

set(gcf, 'paperpositionmode','manual','paperunits','inches','paperposition',[0 0 6 4],'papersize',[6 4])
print(gcf,'-dtiff', '-r600', ['Z_111223.tif'])
print(gcf,'-dpdf', '-r600', ['Z_111223.pdf'])
% 
% Figure Z. the wavelet phasor mean field magnitude of PCI variability in seas
% around the UK, using a) data from 1984 to 2013, b) data from 1958 to 2013,
% c) data from 1946 to 2021.   In Sheppard et al. (2019) data from 1958 to 2013 was 
% used to establish drivers of synchrony in the wavelet mean field; here half-length and extended time-series synchrony plots are presented for comparison. Echinoderm larvae and Decapod larvae abundances 
% predicted variation of PCI in the 2-4 year timescale band (band shown by 
% the black bar in panel a), SST predicted variation in the 4+ year
% timescale band (band shown by the red bar in panel b), and Cal. fin. abundance 
% predicted variation across both bands (shown by the blue bar in panel b).
% Although the short-timescale effects might be detectable in the
% short-duration data shown in panel a, the long-timescale effects could
% only be identified with the extensive long-timescale variation
% shown in panel b.   The synchronous feature in the 1980s in panel b is
% only apparent due to the extensive sampling and the extended PCI data in panel c reveals yet more synchronous events at
% long timescales.


