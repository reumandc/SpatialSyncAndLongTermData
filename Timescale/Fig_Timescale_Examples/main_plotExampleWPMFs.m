% To run, you must run main_calculateExampleWPMFs.R first, to calculate the WPMFs
% in R.

% This script plots the outputs of that script, generating the panels used
% in the Example WPMFs figure.

fname = "PLANKTON"; % data 'name', as saved by Fig_Timescale_ExampleWPMFs_GenerateWPMFs.R
xl = [1960,2010]; % years to start & stop the plot
yticks_custom = 2:2:26; % set custom yticks for plotting
xticks_custom = 1960:5:2010; % set custom xticks for plotting
contline_width = 2; % contour line width
synchrony_timescale_plot(fname,xl,xticks_custom,yticks_custom,contline_width) % call function to plot it

fname = "DEER";
xl = [1984,2013]; 
yticks_custom = nan;
xticks_custom = 1980:5:2015;
contline_width = 2;
synchrony_timescale_plot(fname,xl,xticks_custom,yticks_custom,contline_width)

fname = "DENGUE";
xl = nan;
yticks_custom = 1:20;
xticks_custom = 1970:5:2015;
contline_width = 2;
synchrony_timescale_plot(fname,xl,xticks_custom,yticks_custom,contline_width)

fname = "APHIDS";
xl = nan;
yticks_custom = nan;
xticks_custom = 1980:5:2010;
contline_width = 2;
synchrony_timescale_plot(fname,xl,xticks_custom,yticks_custom,contline_width)

fname = "KELP";
xl = nan;
yticks_custom = 0:20;
xticks_custom = nan;
contline_width = 2;
synchrony_timescale_plot(fname,xl,xticks_custom,yticks_custom,contline_width)

fname = "SHOREBIRDS";
xl = nan;
yticks_custom = 0:0.5:10;
xticks_custom = 2009:2020;
contline_width=2;
synchrony_timescale_plot(fname,xl,xticks_custom,yticks_custom,contline_width)

fname = "CARACCIDENTS";
xl = nan;
yticks_custom = 1:20;
xticks_custom = nan;
contline_width = 2;
synchrony_timescale_plot(fname,xl,xticks_custom,yticks_custom,contline_width)

fname = "PILO";
xl = nan;
yticks_custom = nan;
xticks_custom = nan;
contline_width = 1;
synchrony_timescale_plot(fname,xl,xticks_custom,yticks_custom,contline_width)

function synchrony_timescale_plot(fname,xl,xticks_custom,yticks_custom,contline_width)
    fsize = 21; % font size

    dat = readmatrix(strcat(fname,'_wpmf.csv')); % WPMF magnitude data
    x = csvread(strcat(fname,'_times.csv')); % time points
    y = csvread(strcat(fname,'_timescales.csv')); % time scales
    synx = readmatrix(strcat(fname,'_syntime.csv')); % mean synchrony at each time point
    syny = csvread(strcat(fname,'_syntimescale.csv')); % mean synchrony at each time scale
    q = readmatrix(strcat(fname,'_q_95.csv')); % level of WPMF magnitude at which the synchrony is significant
    
 
    dat = dat'; 
    
    % plot WPMF magnitude to get plotting parameters
    surf(x,y,dat);
    view(2)
    set(gca,'yscale','log'); % make the y-axis a log scale
    hold on; 
    [C,h] = contour3(x,y,dat,[q q],'k'); % have to add contours because this determines limits...
    yl = ylim; % set yl to the automatically set ylimit of the plot
    if (isnan(xl)) % if xl not given when the function was called...
        xl = [min(x),max(x)]; % set xl to the automatically set xlimit of the plot
    end
    lw = 2; % line width
    
    tiledlayout(3,3)
    
    % plot mean synchrony vs. timescale 
    nexttile([2,1])
    plot(syny,y,'LineWidth',lw);
    set(gca,'yscale','log');
    ylim(yl)
    xlim([0,1])
    if ~isnan(yticks_custom)
        yticks(yticks_custom)
    end
    ax = gca;
    ax.FontSize = fsize;
    xlabel('Mean synchrony')
    ylabel('Timescale (years)')
    set(gca, 'YGrid', 'on', 'XGrid', 'off')
    ax.LineWidth = 2;
    xtickangle(45)
    grid minor % toggle on - can't figure out how to turn them off without first toggling them on?
    grid minor % toggle off 
    
    nexttile([2,2])
    surf(x,y,dat)
    view(2); 
    colormap 'jet';
    shading interp; 
    set(gca,'yscale','log');
    if ~isnan(yticks_custom)
        yticks(yticks_custom)
    end
    if ~isnan(xticks_custom)
        xticks(xticks_custom)
    end
    xlim(xl)
    %colorbar % will add a colorbar
    caxis([0, 1]); % set color range 
    hold on; 
    [C,h] = contour3(x,y,dat,[q q],'k');
    h.LineWidth = contline_width;
    set(gca,'xticklabels',[], 'yticklabels', [])
    grid minor % toggle on
    grid minor % toggle off
    ax = gca;
    ax.LineWidth = 2;
    
    
    nexttile % blank placeholder

    % plot mean synchrony vs. timescale 
    nexttile([1,2])
    plot(x,synx,'LineWidth',lw)
    xlim(xl)
    ylim([0,1])
    if ~isnan(xticks_custom)
        xticks(xticks_custom)
    end
    ax = gca;
    ax.FontSize = fsize;
    set(gca, 'YGrid', 'off', 'XGrid', 'on')
    xlabel('Year')
    ylabel('Mean synchrony')
    ax = gca;
    ax.LineWidth = 2;
    xtickangle(45)
    
    set(gcf, 'InvertHardcopy', 'off')
    
    fig = gcf;
    fig.Position = [0, 0, 665, 594];

    fsave = fname; % filename to save
    print(fsave,'-depsc','-vector'); % save eps
    print(fsave,'-dpng'); % save tiff
end



