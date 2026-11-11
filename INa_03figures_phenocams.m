% Water and carbon manuscript
% Natalia Restrepo-Coupe
%..........................................................................
%..........................................................................
% Seasonal figures/home/ncoupe/tapajos/process.u.az
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;
FolderName = '/home/ncoupe/Documents/Fluxnet/';
load('matlabINa.mat');

INa.dayJD = day(INa.daydate,'dayofyear');
[~,~,INa.dayLength,~,~,INa.daySZA] = AM_solar_rad(INa.dayJD,0,lat,lon);

% ........................................................................
%% Site
% ........................................................................
[site_name_FN, lat_FN, lon_FN, site_long_FN, year_ini_FN, year_end_FN, siteelevation_FN, height_FN, ust_tresh_FN, sunrise_FN, sunset_FN, utm_FN, ust_min_FN, ust_max_FN, tree_height_FN, LAI, Biome_FN] =...
    textread([FolderName 'sites_loc.txt'], '%s	%f	%f	%s	%f	%f	%f %f	%f	%f	%f	%f	%f	%f	%f  %f %f',...
    'headerlines',1);

ip = 10;
lat = lat_FN(ip);             lon = lon_FN(ip);      height = height_FN(ip);       
site_name = site_name_FN(ip); utm = utm_FN(ip);      ust_tresh = ust_tresh_FN(ip);

%..........................................................................
%% Time vectors seasonality
%..........................................................................
dateloc_avg  = (1:16:365)';      day_avg  = (1:1:365)';
month_avg = (1:1:365)';          [~,~,x] = datevec(month_avg);     month_avg(x~= 1) = [];
year_trmm = (1998:1:2024)';
ix = datetime(0,0,(1:16:365)');  ind = find(ix>=datetime(0,7,1));  week_start_hydro = ind(1);
tresholdSo    = 10;              tresholdCycleDay = 6;             tresholdCycle = 22;
eight_avg    = (1:8:365)';       week_avg = (1:16:365)';

month_avg_2year   = [month_avg;month_avg+366];
% all_yearENSO_dateloc = [(datetime(2015,1,dateloc_avg));(datetime(2016,1,dateloc_avg))];

gC_m2_d1=60.*60.*24.*12.*(10.^-6);

% .........................................................................
% color_mtx = [0.1020 0.5882 0.9549; 215/255  25/255 28/255; 0/255 0/255 186/255; ...
%     253/255 107/255 184/255; 65/255 26/255 140/255; 81/255 161/255 74/255;0.1020 0.5882 0.2549; 0.1020 0.5882 0.2549];
% color_mtx_dark = [0.1020 0.5882 0.9549; 165/255  0/255 0/255; 0/255 0/255 186/255; ...
%     253/255 97/255 174/255; 40/255 1/255 115/255; 81/255 161/255 74/255;0.1020 0.5882 0.2549; 0.1020 0.5882 0.2549];
color_mtx = [   0, 0, 211;   237, 56, 43;     247, 150, 247;    0, 158, 115;    0. 160 140; 204, 121, 167; 97, 199, 211] / 255;
color_mtx_dark = [    0, 0, 186;  211, 30, 17;    196, 74, 145;  0, 158, 115; 0. 140 100;   204, 121, 167; 96,  198,  211] / 255;
monthstr = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];

% .........................................................................
[INa.monthY,INa.monthM,INa.monthD]= datevec(INa.month);
% year_tick = unique(INa.monthY);  year_tick = [year_tick;(year_tick(end)+1)];
% all_year_tick = (datetime(year_tick(1:4:end),1,1))';
[INa.weekY,INa.weekM,INa.weekD]= datevec(INa.week);

% .........................................................................
%% Figures
% .........................................................................
numberY = (max(INa.weekY)-min(INa.weekY))+3;
v1 = 0;         v2 = 30;      v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/numberY):v2;
figure('color','white');
subplot(3,1,1);               hold on;
% x4=0.*month_avg;            x4((INa.month_avgTRMM<105))=(v2);
% hl1 = bar(month_avg+15,x4,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.9 0.9 0.9]);
% hl2 = bar(month_avg+15,-x4,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.9 0.9 0.9]);
y = [INa.week_avgGEPday-INa.week_avgstdGEPday,2.*INa.week_avgstdGEPday];
h = area(week_avg,y);             %set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);
set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
ik = INa.weekY(1);   count=1;     color_jet = lines(numberY);
while ik<INa.weekY(end)
    hl1  =  plot(week_avg,INa.weekGEPday(INa.weekY == ik),'s','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    hl2  =  plot(week_avg,smoothdata(INa.weekGEPday(INa.weekY == ik),'movmean',3),'LineWidth',1,'Color',color_jet(count,:)); hold on;
    ik = ik+1;         count = count+1;
    plot(week_avg(2),v4(count+2),'.','MarkerSize',14,'color',color_jet(count,:));
    text (week_avg(2)+4,v4(count+2),num2str(ik),'FontSize',8);
end
hl1 = plot(week_avg,INa.week_avgGEPday,'Color',[0 0 0],'LineStyle','-','LineWidth',2);
% hl7 = plot(week_avg,INa.weekGEPday(INa.HY_weekY == 2002),'s','Color',color_mtx_dark(1,:),'MarkerFaceColor',color_mtx(1,:),'MarkerSize',8);
% hl7 = plot(week_avg,INa.weekGEPday(INa.HY_weekY == 2002),'Color',color_mtx(1,:),'LineWidth',2);
% hl4 = plot(week_avg,INa.weekGEPday(INa.HY_weekY == 2015),'s','Color',color_mtx_dark(2,:),'MarkerFaceColor',color_mtx(2,:),'MarkerSize',8);
% hl4 = plot(week_avg,INa.weekGEPday(INa.HY_weekY == 2015),'Color',color_mtx(2,:),'LineWidth',2);    xlim([week_avg(1) 365]);    ylim([v1 v2]);
% xlim([week_avg(1) 365]);                ylim([v1 v2]);
ax1 = gca;
set(ax1,'XTick',month_avg,'XTickLabel',[ '' '' ''],'YTick',v3,'XTickLabel',...
    datestr(datetime(1,1,month_avg),4),'FontSize',14,'XColor','k',...
    'YColor',[ 0.0 0.0 0.0],'Position',[0.17 0.3 0.70 0.60]);
ylabel ({'GEP_{daytime} (W m^-^2)'},'FontSize',14);        box on;  xtickangle(0);
%     text (week_avg(2),v1+40,site_name,'FontSize',08);
% legend([hl3,hl4,hl5],'Jul2002-Jun2003','Jul2015-Jun2016','Jul2016-Jun2017');    %%

%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [INa.day_recurrentGEPday-INa.day_recurrent_stdGEPday,2.*INa.day_recurrent_stdGEPday];
% h = area(INa.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(INa.daydate,INa.dayGEPday,'LineWidth',1,'color',[0.74,0.45, 0.0 ]); hold on;
% hl1 = plot(INa.daydate,INa.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(INa.daydate,INa.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(INa.daydate,zeros(length(INa.daydate),1)+mean(INa.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.month(1:6:end);
set(ax2,'XTick',INa.month(1:24:end),'XTickLabel',datestr(INa.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[INa.daydate(1) INa.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(INa.month(12),v3(2),site_name,'FontSize',16);


%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [INa.day_recurrentGEPday-INa.day_recurrent_stdGEPday,2.*INa.day_recurrent_stdGEPday];
% h = area(INa.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(INa.daydate,INa.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl1 = plot(INa.daydate,INa.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(INa.daydate,INa.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(INa.daydate,zeros(length(INa.daydate),1)+mean(INa.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.month(1:6:end);
set(ax2,'XTick',INa.month(1:24:end),'XTickLabel',datestr(INa.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[INa.daydate(1) INa.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(INa.month(12),v3(2),site_name,'FontSize',16);

w1 = 0.0;                      w2 = 0.9;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(ROI.daydate,ROI.gcc_mean,'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(ROI.daydate,smoothdata(ROI.gcc_mean,'movmean',3),'-','Color',color_mtx_dark(3,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[INa.month(1) INa.month(end)],'YTickLabel',w3,...
    'XTick',INa.month(1:24:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(3,:); ax2.YAxis(2).Color = color_mtx_dark(3,:);
ylabel ('GCC_{phenocam}','FontSize',16,'color',color_mtx_dark(3,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(INa.daydate(20),25,site_name,'FontSize',16)

%%
v1 = 0;                         v2 = 600;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% ix = find(INa.monthTRMM<100);    iy = ones(length(INa.month),1);	iy = iy.*v1;
% iz = iy;                        iz(ix) = (v2+v1);
% y  = [iy,iz];
% h  = bar(INa.month',y, 'BarWidth', 4);          set(gca,'Layer','top');
% set(h(2),'FaceColor',[.9 .9 .9],'EdgeColor',[.9 .9 .9]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',v1);          hold on;
hold on;
hl2 = plot(INa.daydate,INa.day_recurrentSWin,'LineWidth',1,'color',[0.6 0. 0.0 ]); hold on;
hl1 = plot(INa.daydate,INa.daySWin,'LineWidth',1,'color',[0.4 0.4 0.8]); hold on;
hl3 = plot(INa.daydate,(INa.daySWin.*0)+mean(INa.daySWin,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hold on;         ax2 = gca;         set(ax2,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';         ax2.XAxis.MinorTickValues = INa.daydate(1:90:end);
set(ax2,'XTick',INa.month(1:36:end),'XTickLabel',datestr(INa.month(1:36:end),'yyyy'),'YTick',v3,...
    'XLim',[INa.daydate(1) INa.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('Net Radiation_{daytime} (W m^-^2)','FontSize',16);   xtickangle(0);

%%
yearSelect = 2017;
ind = find(INa.dayY==yearSelect);
v1 = 0;                         v2 = 30;       v3 = v1:((v2-v1)/4):v2;
w1 = 0.2;                         w2 = .6;       w3 = w1:((w2-w1)/4):w2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [INa.day_recurrentGEPday(ind)-INa.day_recurrent_stdGEPday(ind),2.*INa.day_recurrent_stdGEPday(ind)];
h = area(INa.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
hold on;
hl2 = plot(INa.daydate(ind),INa.day_recurrentGEPday(ind),'LineWidth',1,'color',[0. 0. 0.6 ]); hold on;
hl1 = plot(INa.daydate(ind),INa.dayGEPday(ind),'LineWidth',0.8,'color',[0.4 0.4 0.4]); hold on; alpha = 0.3;
hl3 = plot(INa.daydate(ind),(INa.dayGEPday(ind).*0)+mean(INa.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;

ind = find((INa.dayGEPday>(INa.day_recurrentGEPday+(2.*INa.day_recurrent_stdGEPday))));
scatter(INa.daydate(ind),INa.dayGEPday(ind),'MarkerFaceColor',[0.2 0.2 0.6],'MarkerEdgeColor',[0.28 0.28 0.28],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(INa.dayY==yearSelect);
hold on;         ax2 = gca;       set(ax2,'YColor','k');
ax2.XAxis.MinorTick = 'on';       ax2.XAxis.MinorTickValues = datetime(yearSelect,1:1:12,1);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'FontSize',16,'XMinorGrid','on','XTick',datetime(yearSelect,1:2:12,1)');    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',INa.month(1:36:end),'XTickLabel',datestr(INa.month(1:36:end),'yyyy')
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;

yyaxis right;
ind = find(INa.eightY==yearSelect);
scatter(INa.eight(ind),INa.eightEVI(ind), 'o', 'filled', 'MarkerFaceAlpha', 0.7,...
    'MarkerEdgeColor', color_mtx_dark(7,:),'MarkerFaceColor', color_mtx_dark(7,:));
plot(INa.eight(ind),smoothdata(INa.eightEVI(ind),'movmean',3),'-','LineWidth',2,'Color',color_mtx_dark(7,:));
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'XTick',(datetime(yearSelect,1:2:12,1)'));  ax2.YColor = color_mtx_dark(7,:);%'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('EVI','FontSize',16,'color',color_mtx_dark(7,:));   xtickangle(0);   box on;
text(INa.daydate(ind(5)),250,site_name,'FontSize',16);

%%
yearSelect = 2018;
ind = find(INa.dayY==yearSelect);
v1 = 0;                         v2 = 24;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [INa.day_recurrentGEPday(ind)-INa.day_recurrent_stdGEPday(ind),2.*INa.day_recurrent_stdGEPday(ind)];
h = area(INa.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(INa.daydate(ind),INa.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(INa.daydate(ind),INa.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(INa.daydate(ind),(INa.dayGEPday(ind).*0)+mean(INa.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(INa.daydate(ind),INa.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayGrowth>(INa.day_recurrentGEPdayGoley+(2.*INa.day_recurrent_stdGEPday))));
hl5 = scatter(INa.daydate(ind),INa.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

hl6 = scatter(INa.daydate(ind),INa.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(INa.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

% pause(2)
w1 = 0.3;                      w2 = .38;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
ind = find(INa.dayY==yearSelect);
scatter(INa.daydate(ind),INa.ROIgcc(ind),'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(4,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(INa.daydate(ind),smoothdata(INa.ROIgcc(ind),'movmean',3),'-','Color',color_mtx_dark(4,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',INa.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(4,:); ax2.YAxis(2).Color = color_mtx_dark(4,:);
ylabel ('GCC_{phenocam}','FontSize',16,'color',color_mtx_dark(4,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(INa.daydate(ind(20)),25,site_name,'FontSize',16)

%%
yearSelect = 2018;
ind = find(INa.dayY==yearSelect);
v1 = 0;                         v2 = 24;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [INa.day_recurrentGEPday(ind)-INa.day_recurrent_stdGEPday(ind),2.*INa.day_recurrent_stdGEPday(ind)];
h = area(INa.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(INa.daydate(ind),INa.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(INa.daydate(ind),INa.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(INa.daydate(ind),(INa.dayGEPday(ind).*0)+mean(INa.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(INa.daydate(ind),INa.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

% ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayGrowth>(INa.day_recurrentGEPdayGoley+(2.*INa.day_recurrent_stdGEPday))));
% hl5 = scatter(INa.daydate(ind),INa.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% 
% hl6 = scatter(INa.daydate(ind),INa.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(INa.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

% pause(2)
w1 = 0.32;      w2 = .44;              w3 = w1:((w2-w1)/4):w2;
yyaxis right;
ind = find(INa.dayY==yearSelect);
scatter(INa.daydate(ind),INa.ROIrcc(ind),'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(4,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(INa.daydate(ind),smoothdata(INa.ROIrcc(ind),'movmean',3),'-','Color',color_mtx_dark(4,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',INa.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(4,:); ax2.YAxis(2).Color = color_mtx_dark(4,:);
ylabel ('RCC_{phenocam}','FontSize',16,'color',color_mtx_dark(4,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(INa.daydate(ind(20)),25,site_name,'FontSize',16)

%%
numberY = INa.Y(end) -INa.Y(1);
v1 = 0;         v2 = 32;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/(numberY+7)):v2;
x1 = 0.3;       x2 = .50;         x3 = x1:((x2-x1)/4):x2;     x4 = x1:((x2-x1)/(numberY+7)):x2;
figure('color','white');          hold on;
ik = ROI.dayY(1);                 count=1;     color_jet = jet(max(INa.dayY)-min(ROI.dayY)+1);
while ik<INa.dayY(end)
    scatter(INa.ROIgcc(INa.dayY == ik),INa.dayGEPdayGrowthGoley(INa.dayY == ik),'o','MarkerFaceColor',color_jet(count,:),...
        'MarkerEdgeColor',color_jet(count,:), 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5); hold on;
    AM_compute_regression(INa.ROIgcc(INa.dayY == ik),INa.dayGEPdayGrowthGoley(INa.dayY == ik),color_jet(count,:),1);
    plot(x4(2),v4(end-count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (x4(3),v4(end-count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[x1 x2],...
    'FontSize',16,'XMinorGrid','on','XTick',x3);    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
xlabel ('GCC');

%% Respiration
yearSelect = 2017;
ind = find(INa.dayY==yearSelect);
v1 = 0;                         v2 = 16;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [INa.day_recurrentGEP(ind)-INa.day_recurrent_stdGEP(ind),2.*INa.day_recurrent_stdGEP(ind)];
h = area(INa.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(INa.daydate(ind),INa.day_recurrentGEPGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(INa.daydate(ind),INa.dayGEP(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(INa.daydate(ind),(INa.dayGEP(ind).*0)+mean(INa.dayGEP,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(INa.daydate(ind),INa.dayGEPgrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((INa.dayY==yearSelect)&(INa.dayGEPgrowth>(INa.day_recurrentGEPGoley+(2.*INa.day_recurrent_stdGEP))));
hl5 = scatter(INa.daydate(ind),INa.dayGEP(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(INa.dayGEPARIMAzvalueResidual,'omitnan');
% iy = std(INa.dayGEPARIMAzvalueResidual,'omitnan');
% ind = find((INa.dayY==yearSelect)&(INa.dayGEPARIMAzvalueResidualGrowth>thresholdARIMA)&(INa.dayGEPGrowth>INa.day_recurrentGEPGoley));
% zvalue value-mu/std
% ind = find((INa.dayY==yearSelect)&(INa.dayGEPARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(INa.dayGEPGrowth>INa.day_recurrentGEPGoley));
hl6 = scatter(INa.daydate(ind),INa.dayGEP(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(INa.dayGEPHURSTzvalue,'omitnan');
% iy = std(INa.dayGEPHURSTzvalue,'omitnan');
% % ind = find((INa.dayY==yearSelect)&(INa.dayGEPHURST>(ix+(1.5.*iy))));
% ind = find((INa.dayY==yearSelect)&(INa.dayGEPHURSTzvalue<0.5)&(INa.dayGEPGrowth>INa.day_recurrentGEPGoley));
% hl7 = scatter(INa.daydate(ind),INa.dayGEP(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(INa.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

w1 = 0;                      w2 = 16;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(INa.daydate(ind),INa.dayRECO(ind),'o','MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(INa.daydate(ind),smoothdata(INa.dayRECO(ind),'movmean',3),'-','Color',color_mtx_dark(1,:),'Linewidth',2);

% % ind = find((INa.dayY==yearSelect)&(INa.dayRECOGrowth>(INa.day_recurrentRECOGoley+(2.*INa.day_recurrent_stdRECO))));
% % hl5 = scatter(INa.daydate(ind),INa.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % ind = find((INa.dayY==yearSelect)&(INa.dayRECOARIMAzvalueResidual>thresholdARIMAzvalue)&...
% %     (INa.dayRECOGrowth>INa.day_recurrentRECOGoley));
% % hl6 = scatter(INa.daydate(ind),INa.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % ix = mean(INa.dayRECOHURSTzvalue,'omitnan');
% % iy = std(INa.dayRECOHURSTzvalue,'omitnan');
% % ind = find((INa.dayY==yearSelect)&(INa.dayRECOHURSTzvalue<0.5)&(INa.dayRECOGrowth>INa.day_recurrentRECOGoley));
% % hl7 = scatter(INa.daydate(ind),INa.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(INa.dayY==yearSelect);
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',INa.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(2,:); ax2.YAxis(2).Color = color_mtx_dark(1,:);
ylabel ('respiration (gC m^-^2 d^-^1)','FontSize',16,'color',color_mtx_dark(1,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(INa.daydate(ind(20)),25,site_name,'FontSize',16)

%%
yearSelect = 2019;
ind = find(INa.dayY==yearSelect);
v1 = 0;                         v2 = 36;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [INa.day_recurrentGEPday(ind)-INa.day_recurrent_stdGEPday(ind),2.*INa.day_recurrent_stdGEPday(ind)];
h = area(INa.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(INa.daydate(ind),INa.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(INa.daydate(ind),INa.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(INa.daydate(ind),(INa.dayGEPday(ind).*0)+mean(INa.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(INa.daydate(ind),INa.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayGrowth>(INa.day_recurrentGEPdayGoley+(2.*INa.day_recurrent_stdGEPday))));
hl5 = scatter(INa.daydate(ind),INa.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(INa.dayGEPdayARIMAzvalueResidual,'omitnan');
% iy = std(INa.dayGEPdayARIMAzvalueResidual,'omitnan');
% ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMA)&(INa.dayGEPdayGrowth>INa.day_recurrentGEPdayGoley));
% zvalue value-mu/std
% ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(INa.dayGEPdayGrowth>INa.day_recurrentGEPdayGoley));
hl6 = scatter(INa.daydate(ind),INa.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(INa.dayGEPdayHURSTzvalue,'omitnan');
% iy = std(INa.dayGEPdayHURSTzvalue,'omitnan');
% % ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayHURST>(ix+(1.5.*iy))));
% ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayHURSTzvalue<0.5)&(INa.dayGEPdayGrowth>INa.day_recurrentGEPdayGoley));
% hl7 = scatter(INa.daydate(ind),INa.dayGEPday(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(INa.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',INa.month(1:36:end),'XTickLabel',datestr(INa.month(1:36:end),'yyyy')
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
% text(INa.daydate(ind(20)),250,site_name,'FontSize',16)

w1 = 0.2;                      w2 = .6;       w3 = w1:((.4-w1)/4):.4;
yyaxis right;
% scatter(INa.daydate(ind),INa.dayEVI(ind),'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
%     'MarkerFaceAlpha',.7,'MarkerEdgeAlpha',.7);
% plot(INa.daydate(ind),smoothdata(INa.dayEVI(ind),'movmean',3),'-','Color',color_mtx_dark(4,:),'Linewidth',2);
ind = find(INa.eightY==yearSelect);
scatter(INa.eight(ind),INa.eightEVI(ind), 'o', 'filled', 'MarkerFaceAlpha', 0.7, 'MarkerEdgeColor', color_mtx_dark(5,:),...
    'MarkerFaceColor', color_mtx_dark(5,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(INa.eight(ind),(INa.eightEVI(ind)),'-','LineWidth',2,'Color',color_mtx_dark(5,:));
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'YTickLabel',w3,'XTick',(datetime(yearSelect,1:2:12,1)'));    %'XTickLabelColor',[0. 0. 0.7 ]
% ind = find(INa.dayY==yearSelect);
% set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'YTickLabel',w3,...
%     'XTick',INa.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(2,:); ax2.YAxis(2).Color = color_mtx_dark(5,:);
ylabel ('EVI','FontSize',16,'color',color_mtx_dark(5,:));   xtickangle(0);   box on;
text(INa.daydate(ind(20)),25,site_name,'FontSize',16)

%% hourly
% .....................................................................................
% close all;
% % cla;
% % indSelect = find((INa.dateloc>=datetime(2017,1,1))&(INa.dateloc<=datetime(2019,4,20)));
% % v1 = 0;                         v2 = 20;       v3 = v1:((v2-v1)/4):v2;
% % figure('color','white','Position',[50 50 600 800],'units','inches');
% % subplot(2,1,1);
% % yyaxis left;
% % y = [INa.recurrentET(indSelect)-INa.recurrent_stdET(indSelect),2.*INa.recurrent_stdET(indSelect)];
% % hl1 = area(days(INa.dateloc(indSelect)-INa.dateloc(indSelect(1))),y);
% % set(hl1(2),'FaceColor',[.8 .8 .9],'EdgeColor',[.8 .8 .9],'FaceAlpha',.5);
% % set(hl1(1),'FaceColor','none','EdgeColor','none');
% % set(hl1,'BaseValue',0);
% % % hl2 = plot(INa.dateloc(indSelect),INa.PET(indSelect),'-','LineWidth',1,'color',[0.07,0.44,0.75]); hold on;
% % % set(gca,'YColor',[0.9 0.6 0.2]);
% % hold on;
% % % cla(gca, 'reset');
% % ax1 = gca;       %set(ax1,'YColor',[0.4 0.4 0.8]);
% % set(ax1,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.dateloc(indSelect(1)) INa.dateloc(indSelect(end))],...
% %     'FontSize',16);%,'XTick',INa.dateloc(indSelect(1:24:end)));
% % ylabel ('PET (mm s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
% % 
% % yyaxis right;
% % y = [INa.recurrentET(indSelect)-INa.recurrent_stdET(indSelect),2.*INa.recurrent_stdET(indSelect)];
% % hl3 = area(days(INa.dateloc(indSelect)-INa.dateloc(indSelect(1))),y);       set(gca,'Layer','top');
% % set(hl3(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'FaceAlpha',.5);
% % set(hl3(1),'FaceColor','none','EdgeColor','none');
% % set(hl3,'BaseValue',0);
% % % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.dateloc(ind(1)) INa.dateloc(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
% % hold on;
% % hl4 = plot(INa.dateloc(indSelect),INa.recurrentET(indSelect),'-','LineWidth',2,'color',[0.6 0.6 0.6 ]); hold on;
% % hl5 = plot(INa.dateloc(indSelect),INa.ET(indSelect),'-','LineWidth',2,'color',[0.9 0.6 0.2]); hold on;
% % % hl6 = plot(INa.dateloc(indSelect),(INa.ET(indSelect).*0)+mean(INa.dayETday,'omitnan'),'--','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
% % 
% % ax2 = gca;                     set(ax2,'YColor',[0.9 0.6 0.2]);
% % ax2.XAxis.MinorTick = 'on';    ax2.XAxis.MinorTickValues = INa.daydate(1:1:end);
% % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.dateloc(indSelect(1)) INa.dateloc(indSelect(end))],...
% %     'FontSize',16,'XMinorGrid','on','XTick',INa.dateloc(indSelect(1:48:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
% % % ,'XTick',INa.month(1:36:end),'XTickLabel',datestr(INa.month(1:36:end),'yyyy')
% % ylabel ('ET (mm s^-^1)','FontSize',16);  box on;   grid on;
% % text(INa.dateloc(indSelect(20)),18,site_name,'FontSize',16)
% % 
% % % cla;
% % subplot(2,1,2);     hold on;
% % v1 = 0.42;           v2 = .46;       v3 = v1:((v2-v1)/4):v2;
% % indSelect = find((INa.daydate>=datetime(2019,6,24))&(INa.daydate<=datetime(2019,7,3)));
% % % yyaxis left;
% % y = [INa.day_recurrentROIgcc(indSelect)-INa.day_recurrent_stdROIgcc(indSelect),2.*INa.day_recurrent_stdROIgcc(indSelect)];
% % h = area(INa.daydate(indSelect),y);
% % % set(h,'Layer','top');
% % set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'FaceAlpha',.5);
% % set(h(1),'FaceColor','none','EdgeColor','none');
% % % set(h,'BaseValue',0);          hold on;
% % hl1 = plot(INa.daydate(indSelect),INa.day_recurrentROIgcc(indSelect),'-k');
% % hl2 = scatter(INa.daydate(indSelect),INa.ROIgcc(indSelect),'.','MarkerFaceColor',[0.87 0.33 0.],'MarkerEdgeColor',[0.87 0.33 0.],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % hl3 = plot(INa.daydate(indSelect),(INa.ROIgcc(indSelect)),'-','Color',[0.87 0.33 0.]);
% % % cla;
% % ax1 = gca;                      set(ax1,'YColor',[0.9 0.6 0.2]);
% % ax1.XAxis.MinorTick = 'on';     ax1.XAxis.MinorTickValues = INa.daydate(1:1:end);
% % set(ax1,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(indSelect(1)) INa.daydate(indSelect(end))],...
% %     'FontSize',16,'XMinorGrid','on','XTick',INa.daydate(indSelect(1:2:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
% % ylabel ('GCC_{phenocam}','FontSize',16);
% % grid on;          box on;
% % 
% % % w1 = 0.29;                      w2 = .49;       w3 = w1:((w2-w1)/4):w2;
% % % yyaxis right;
% % % scatter(INa.dateloc(ind),INa.dayROIgcc(ind),'.','MarkerFaceColor',[0.87 0.33 0.],'MarkerEdgeColor',[0.87 0.33 0.],...
% % %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % % plot(INa.dateloc(ind),smoothdata(INa.dayROIgcc(ind),'movmean',3),'-','Color',[0.87 0.33 0.]);
% % %
% % % ind = find((INa.dayY==yearSelect)&(INa.dayROIgccGrowth>(INa.day_recurrentROIgccGoley+(2.*INa.day_recurrent_stdROIgcc))));
% % % hl5 = scatter(INa.dateloc(ind),INa.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
% % %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % % ind = find((INa.dayY==yearSelect)&(INa.dayROIgccARIMAzvalueResidual>thresholdARIMAzvalue)&...
% % %     (INa.dayROIgccGrowth>INa.day_recurrentROIgccGoley));
% % % hl6 = scatter(INa.dateloc(ind),INa.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
% % %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % % ix = mean(INa.dayROIgccHURSTzvalue,'omitnan');
% % % iy = std(H,'YTickLabel',w3a1.dayROIgccHURSTzvalue,'omitnan');
% % % ind = find((INa.dayY==yearSelect)&(INa.dayROIgccHURSTzvalue<0.5)&(INa.dayROIgccGrowth>INa.day_recurrentROIgccGoley));
% % % hl7 = scatter(INa.dateloc(ind),INa.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
% % %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % ax2 =gca;
% % % ind = find(INa.dayY==yearSelect);
% % % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.dateloc(indSelect(1)) INa.dateloc(indSelect(end))],...
% % %     'YTickLabel',v3,'XTick',INa.dateloc(indSelect(1:2:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
% % % ylabel ('GCC_{phenocam}','FontSize',16,'color',[0.87 0.33 0.]);   xtickangle(0);   box on;
% % % % legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5'); legend box off;
% % 
% % 
% % % .....................................................................................
% % %% deseasonalized  INa.dayGEPday_zscore   dayGEPday_deseasoned
% % % .....................................................................................
% % yearSelect = 2019;
% % ind = find(INa.dayY==yearSelect);
% % v1 = -10;                         v2 = 10;       v3 = v1:((v2-v1)/4):v2;
% % w1 = 0.34;                         w2 = .5;       w3 = w1:((w2-w1)/4):w2;
% % figure('color','white','Position',[50 50 600 400],'units','inches');
% % yyaxis left;
% % % y = [INa.day_recurrentGEPday(ind)-INa.day_recurrent_stdGEPday(ind),2.*INa.day_recurrent_stdGEPday(ind)];
% % % h = area(INa.daydate(ind),y);       set(gca,'Layer','top');
% % % set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% % % set(h,'BaseValue',0);
% % hold on;
% % % hl2 = plot(INa.daydate(ind),INa.day_recurrentGEPdayGoley(ind),'LineWidth',1,'color',[0. 0.6 0.6 ]); hold on;
% % hl1 = plot(INa.daydate(ind),INa.dayGEPday_zscore(ind),'LineWidth',0.8,'color',[0.5 0.5 0.5]); hold on; alpha = 0.3;
% % hl3 = plot(INa.daydate(ind),(INa.dayGEPday_zscore(ind).*0)+mean(INa.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
% % % hl4 = plot(INa.daydate(ind),INa.dayGEPdayGrowth(ind),'LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;
% % 
% % ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayGrowth>(INa.day_recurrentGEPdayGoley+(2.*INa.day_recurrent_stdGEPday))));
% % hl5 = scatter(INa.daydate(ind),INa.dayGEPday_zscore(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % 
% % % ix = mean(INa.dayGEPdayARIMAzvalueResidual,'omitnan');
% % % iy = std(INa.dayGEPdayARIMAzvalueResidual,'omitnan');
% % % ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMA)&(INa.dayGEPdayGrowth>INa.day_recurrentGEPdayGoley));
% % % zvalue value-mu/std
% % % ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(INa.dayGEPdayGrowth>INa.day_recurrentGEPdayGoley));
% % hl6 = scatter(INa.daydate(ind),INa.dayGEPday_zscore(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % 
% % % ix = mean(INa.dayGEPdayHURSTzvalue,'omitnan');
% % % iy = std(INa.dayGEPdayHURSTzvalue,'omitnan');
% % % % ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayHURST>(ix+(1.5.*iy))));
% % % ind = find((INa.dayY==yearSelect)&(INa.dayGEPdayHURSTzvalue<0.5)&(INa.dayGEPdayGrowth>INa.day_recurrentGEPdayGoley));
% % % hl7 = scatter(INa.daydate(ind),INa.dayGEPday_zscore(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
% % %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % 
% % ind = find(INa.dayY==yearSelect);
% % hold on;           ax2 = gca;         set(ax2,'YColor',[0.3 0.3 0.5]);
% % ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.daydate(1:90:end);
% % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
% % % ,'XTick',INa.month(1:36:end),'XTickLabel',datestr(INa.month(1:36:end),'yyyy')
% % ylabel ('LE_{daytime} (W m^-^2)','FontSize',16);   xtickangle(0);   box on;   grid on;
% % text(INa.daydate(ind(20)),250,site_name,'FontSize',16)
% % 
% % yyaxis right;
% % scatter(INa.daydate(ind),INa.ROIgcc(ind),'.','MarkerFaceColor',[0.5 0.2 0.2],'MarkerEdgeColor',[0.6 0.1 0.1],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % plot(INa.daydate(ind),INa.ROIgcc(ind),'-','Color',[0.6 0.1 0.1]);
% % set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'YTickLabel',['']);    %'XTickLabelColor',[0. 0. 0.7 ]
% % ylabel ('GCC_{phenocam}','FontSize',16,'color',[0.6 0.2 0.2]);   xtickangle(0);   box on;
% % % legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;

%%
order = 5;   framelen = 9;
yearSelect = 2018;
ind = find(INa.dayY==yearSelect);

z1 = 0;             z2 = 26;       z3 = ((z2-z1)/6);       z4 = z1:3*z3:z2;    z5 = z1:z3:z2;
y1 = -100;          y2 = 700;      y3 = ((y2-y1)/6);       y4 = y1:3*y3:y2;    y5 = y1:y3:y2;

x1 = INa.daydate(ind);
x2 = INa.daydate(ind);

y1 = INa.ROIgcc(ind);     GCCgolay = sgolayfilt(INa.ROIgcc(ind),order,framelen);    
GCCgolay = smoothdata(INa.ROIgcc(ind),'movmean',3); 
y8 = GCCgolay;

y3 = INa.dayGEPday(ind);  
y4 = INa.dayGEPday(ind);  GEPgolay = sgolayfilt(INa.dayGEPday(ind),order,framelen); 
y9 = GEPgolay;

y5 = INa.dayPARday(ind);     %PARgolay = sgolayfilt(INa.dayPAR(ind),order,framelen);
PARgolay = smoothdata(INa.dayPARday(ind),'movmean',9); 
y6 = INa.dayPARday(ind);
y10 = PARgolay;

y7 = INa.daytair(ind);    %Tairgolay = sgolayfilt(INa.daytair(ind),order,framelen);
Tairgolay = smoothdata(INa.daytairday(ind),'movmean',11); 
y11 = INa.daytair(ind);
y12 = Tairgolay;

y2 = 1-INa.ROIrcc(ind);
y2((INa.dayM(ind)<=2)|(INa.dayM(ind)>=11)) = NaN;
y13 = smoothdata(y2,'movmean',3); 

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
% ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1), T_{air} (/circC)';
ylabels{2} = 'GCC';
ylabels{3} = 'PAR_{day} (\mumol m^-^2 s^-^1)';
yaxisval   = [-.5,20,0.3,.48,100,500];
% [ax,hlines] = AM_multiplotyyyGEPday2annual({x2,y1,x2,y8},{x1,y3,x1,y9,x2,y12},{x1,y10,x1,y10},ylabels,yaxisval);
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y1,x2,y8},{x1,y10,x1,y10},ylabels,yaxisval,1);
% legend(cat(1,hlines{1,:}),'GEP','GCC','PAR','location','nw')

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'RCC';
ylabels{3} = 'PAR_{day} (\mumol m^-^2 s^-^1)';
yaxisval   = [-.5,20,0.58,.68,10,500];
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y2,x2,y13},{x1,y10,x1,y10},ylabels,yaxisval,1);

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'GCC';
ylabels{3} = 'RCC';
yaxisval   = [-.5,20,0.32,.48,0.58,.68];
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y1,x2,y8},{x2,y2,x2,y13},ylabels,yaxisval,2);

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'GCC';
ylabels{3} = 'T_{air} (\circC)';
yaxisval   = [-.5,20,0.32,.46,-5,30];
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y1,x2,y8},{x2,y7,x2,y12},ylabels,yaxisval,3);

%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [INa.day_recurrentGEPday-INa.day_recurrent_stdGEPday,2.*INa.day_recurrent_stdGEPday];
% h = area(INa.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(INa.daydate,INa.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl1 = plot(INa.daydate,INa.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(INa.daydate,INa.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(INa.daydate,zeros(length(INa.daydate),1)+mean(INa.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.month(1:6:end);
set(ax2,'XTick',INa.month(1:24:end),'XTickLabel',datestr(INa.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[INa.daydate(1) INa.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(INa.month(12),v3(2),site_name,'FontSize',16);

w1 = -.1;                      w2 = .3;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(ROI.daydate,ROI.GRIVI_mean,'o','MarkerFaceColor',color_mtx(5,:),'MarkerEdgeColor',color_mtx_dark(5,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(ROI.daydate,smoothdata(ROI.GRIVI_mean,'movmean',5),'-','Color',color_mtx_dark(5,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[INa.month(1) INa.month(end)],'YTickLabel',w3,...
    'XTick',INa.month(1:24:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(5,:); ax2.YAxis(2).Color = color_mtx_dark(5,:);
ylabel ('GRIVI_{phenocam}','FontSize',16,'color',color_mtx_dark(5,:));   xtickangle(0);   box on;
text(INa.daydate(20),25,site_name,'FontSize',16)

%%
order = 5;   
framelen = 9;
yearSelect = 2018;

% Filter indices for target year
ind = find(INa.dayY == yearSelect);

% Datetime vectors
x1 = INa.daydate(ind);    
x2 = INa.daydate(ind);

% --- Index 1: GEP ---
y1 = AM_fill_plus(INa.dayGEPday(ind));  
% GEPgolay = sgolayfilt(INa.dayGEPday(ind), order, framelen); 
GEPgolay = smoothdata(INa.dayGEPday(ind), 'movmean', 3); 
y2 = GEPgolay;

% --- Index 2: GCC ---
y3 = INa.ROIgcc(ind);     
GCCgolay = smoothdata(INa.ROIgcc(ind), 'movmean', 3); 
y4 = GCCgolay;

% --- Index 3: ExGREEN ---
y5 = INa.ROIexgreen(ind);     
ExGREENgolay = smoothdata(INa.ROIexgreen(ind), 'movmean', 3); 
y6 = ExGREENgolay;

% --- Index 4: GRRI ---
y7 = INa.ROIGRRI(ind);     
GRRIgolay = smoothdata(INa.ROIGRRI(ind), 'movmean', 3); 
y8 = GRRIgolay;

% --- Index 5: 1-RCC ---
y9 = 1 - INa.ROIrcc(ind);
% Mask off-season winter values to NaN
y9((INa.dayM(ind) <= 4) | (INa.dayM(ind) >= 11)) = NaN; 
y10 = smoothdata(y9, 'movmean', 3); % FIXED: target y9 instead of y7

% --- Index 6: GRIVI ---
y11 = INa.ROIGRIVI(ind);     
GRIVIgolay = smoothdata(INa.ROIGRIVI(ind), 'movmean', 3); 
y12 = GRIVIgolay;

% Y-axis labels
ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'GCC';
ylabels{3} = 'ExGREEN';
ylabels{4} = 'GRRI';
ylabels{5} = '1-RCC';
ylabels{6} = 'GRIVI';

% [ymin, ymax] bounds for all 5 axes
yaxisval = [ -0.5, 20;    % GEP
    0.32, 0.5; % GCC
    .0, .07; % ExGREEN
    0.75, 1.4; % GRRI
    0.55, 0.7;% 1-RCC
    -.15, .2];% GRIVI

% Execute multiplot with 5 datasets
[ax, hlines] = AM_multiplotyGEP4VI({x1, y1, x1, y2}, ... % Set 1 (GEP)
    {x2, y3, x2, y4}, ... % Set 2 (GCC)
    {x1, y5, x1, y6}, ... % Set 3 (ExGREEN)
    {x1, y7, x1, y8}, ... % Set 4 (GRRI)
    {x1, y9, x1, y10}, ...% Set 5 (1-RCC)
    {x1, y11, x1, y12}, ...% Set 6 GRIVI
    ylabels, yaxisval, 1);


