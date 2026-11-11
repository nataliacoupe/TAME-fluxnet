% Rewriten from water and carbon manuscript to fit Harvard forest analysis
% for ExETs proposal and TAME work
% Natalia Restrepo-Coupe
% Toronto, May 2023
%..........................................................................
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;
FolderName = '/home/ncoupe/Documents/Fluxnet/';
load('matlabHa1.mat');

Ha1.dayJD = day(Ha1.daydate,'dayofyear');
[~,~,Ha1.dayLength,~,~,Ha1.daySZA] = AM_solar_rad(Ha1.dayJD,0,lat,lon);

% ........................................................................
%% Site
% ........................................................................
[site_name_FN, lat_FN, lon_FN, site_long_FN, year_ini_FN, year_end_FN, siteelevation_FN, height_FN, ust_tresh_FN, sunrise_FN, sunset_FN, utm_FN, ust_min_FN, ust_max_FN, tree_height_FN, LAI, Biome_FN] =...
    textread([FolderName 'sites_loc.txt'], '%s	%f	%f	%s	%f	%f	%f %f	%f	%f	%f	%f	%f	%f	%f  %f %f',...
    'headerlines',1);

ip = 1;
lat = lat_FN(ip);             lon = lon_FN(ip);      height = height_FN(ip);       utm = utm_FN(ip);
site_name = site_name_FN(ip); ust_tresh = ust_tresh_FN(ip);

%..........................................................................
%% Time vectors seasonality
%..........................................................................
dateloc_avg  = (datetime(0,1,1):days(16):datetime(0,12,1))';      
day_avg  = (datetime(0,1,1):days(1):datetime(0,12,1))';
month_avg = (datetime(0,1,1):calmonths(1):datetime(0,12,1))';
year_trmm = (1998:1:2024)';
ix = datetime(0,0,(1:16:365)');  ind = find(ix>=datetime(0,7,1));  week_start_hydro = ind(1);
tresholdSo    = 10;              tresholdCycleDay = 6;             tresholdCycle = 22;
eight_avg    = (1:8:365)';       week_avg = (1:16:365)';

month_avg_2year   = [month_avg;month_avg+366];
% all_yearENSO_dateloc = dateloc_avg+[(datetime(2015,1,1));(datetime(2016,1,1))];

gC_m2_d1=60.*60.*24.*12.*(10.^-6);

% .........................................................................
% color_mtx = [0.1020 0.5882 0.9549; 215/255  25/255 28/255; 0/255 0/255 186/255; ...
%     253/255 107/255 184/255; 65/255 26/255 140/255; 81/255 161/255 74/255;0.1020 0.5882 0.2549; 0.1020 0.5882 0.2549];
% color_mtx_dark = [0.1020 0.5882 0.9549; 165/255  0/255 0/255; 0/255 0/255 186/255; ...
%     253/255 97/255 174/255; 40/255 1/255 115/255; 81/255 161/255 74/255;0.1020 0.5882 0.2549; 0.1020 0.5882 0.2549];
color_mtx = [   0, 0, 211;   237, 56, 43;     247, 150, 247;    0, 158, 115;    0. 160 140; 204, 121, 167; 97, 199, 211; 50,  190,  130; 130,  190,  130] / 255;
color_mtx_dark = [    0, 0, 186;  211, 30, 17;    196, 74, 145;  0, 158, 115; 0. 140 100;   204, 121, 167; 96,  198,  211; 50,  190,  130; 130,  190,  130] / 255;
monthstr = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];

% .........................................................................
[Ha1.monthY,Ha1.monthM,Ha1.monthD]= datevec(Ha1.month);
% year_tick = unique(Ha1.monthY);  year_tick = [year_tick;(year_tick(end)+1)];
% all_year_tick = (datetime(year_tick(1:4:end),1,1))';
[Ha1.weekY,Ha1.weekM,Ha1.weekD]= datevec(Ha1.week);
% % 
% % % .........................................................................
% % %% Figures
% % % .........................................................................
% % numberY = (max(Ha1.weekY)-min(Ha1.weekY))+3;
% % v1 = 0;         v2 = 30;         v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/numberY):v2;
% % figure('color','white');
% % subplot(3,1,1);                   hold on;
% % % x4=0.*month_avg;            x4((Ha1.month_avgTRMM<105))=(v2);
% % % hl1 = bar(month_avg+15,x4,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.9 0.9 0.9]);
% % % hl2 = bar(month_avg+15,-x4,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.9 0.9 0.9]);
% % y = [Ha1.week_avgGEPday-Ha1.week_avgstdGEPday,2.*Ha1.week_avgstdGEPday];
% % h = area(week_avg,y);             %set(gca,'Layer','top');
% % set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);
% % set(h(1),'FaceColor','none','EdgeColor','none');
% % set(h,'BaseValue',0);
% % ik = Ha1.weekY(1);   count=1;     color_jet = lines(numberY);
% % while ik<Ha1.weekY(end)
% %     hl1  =  plot(week_avg,Ha1.weekGEPday(Ha1.weekY == ik),'s','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
% %     hl2  =  plot(week_avg,smoothdata(Ha1.weekGEPday(Ha1.weekY == ik),'movmean',3),'LineWidth',1,'Color',color_jet(count,:)); hold on;
% %     ik = ik+1;         count = count+1;
% %     plot(week_avg(2),v4(count+2),'.','MarkerSize',14,'color',color_jet(count,:));
% %     text (week_avg(2)+4,v4(count+2),num2str(ik),'FontSize',8);
% % end
% % hl1 = plot(week_avg,Ha1.week_avgGEPday,'Color',[0 0 0],'LineStyle','-','LineWidth',2);
% % % hl7 = plot(week_avg,Ha1.weekGEPday(Ha1.HY_weekY == 2002),'s','Color',color_mtx_dark(1,:),'MarkerFaceColor',color_mtx(1,:),'MarkerSize',8);
% % % hl7 = plot(week_avg,Ha1.weekGEPday(Ha1.HY_weekY == 2002),'Color',color_mtx(1,:),'LineWidth',2);
% % % hl4 = plot(week_avg,Ha1.weekGEPday(Ha1.HY_weekY == 2015),'s','Color',color_mtx_dark(2,:),'MarkerFaceColor',color_mtx(2,:),'MarkerSize',8);
% % % hl4 = plot(week_avg,Ha1.weekGEPday(Ha1.HY_weekY == 2015),'Color',color_mtx(2,:),'LineWidth',2);    xlim([week_avg(1) 365]);    ylim([v1 v2]);
% % % xlim([week_avg(1) 365]);                ylim([v1 v2]);
% % ax1 = gca;
% % set(ax1,'XTick',month_avg,'XTickLabel',[ '' '' ''],'YTick',v3,'XTickLabel',...
% %     datestr(month_avg,4),'FontSize',14,'XColor','k',...
% %     'YColor',[ 0.0 0.0 0.0],'Position',[0.17 0.3 0.70 0.60]);
% % ylabel ({'GEP_{daytime} (W m^-^2)'},'FontSize',14);        box on;  xtickangle(0);
% % %     text (week_avg(2),v1+40,site_name,'FontSize',08);
% % % legend([hl3,hl4,hl5],'Jul2002-Jun2003','Jul2015-Jun2016','Jul2016-Jun2017');    %%

%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [Ha1.day_recurrentGEPday-Ha1.day_recurrent_stdGEPday,2.*Ha1.day_recurrent_stdGEPday];
% h = area(Ha1.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(Ha1.daydate,Ha1.dayGEPday,'LineWidth',1,'color',color_mtx_dark(1,:)); hold on;
% hl1 = plot(Ha1.daydate,Ha1.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(Ha1.daydate,Ha1.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(Ha1.daydate,zeros(length(Ha1.daydate),1)+mean(Ha1.dayGEPday_zscore,'omitnan'),...
    '--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month(1:6:end);
set(ax2,'XTick',Ha1.month(1:24:end),'XTickLabel',datestr(Ha1.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[Ha1.daydate(1) Ha1.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(Ha1.month(12),v3(2),site_name,'FontSize',16);


%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [Ha1.day_recurrentGEPday-Ha1.day_recurrent_stdGEPday,2.*Ha1.day_recurrent_stdGEPday];
% h = area(Ha1.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(Ha1.daydate,Ha1.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl1 = plot(Ha1.daydate,Ha1.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(Ha1.daydate,Ha1.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(Ha1.daydate,zeros(length(Ha1.daydate),1)+mean(Ha1.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month(1:6:end);
set(ax2,'XTick',Ha1.month(1:24:end),'XTickLabel',datestr(Ha1.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[Ha1.daydate(1) Ha1.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(Ha1.month(12),v3(2),site_name,'FontSize',16);

w1 = 0.35;                      w2 = .49;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(ROI.daydate,ROI.gcc_mean,'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(ROI.daydate,smoothdata(ROI.gcc_mean,'movmean',3),'-','Color',color_mtx_dark(3,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.month(1) Ha1.month(end)],'YTickLabel',w3,...
    'XTick',Ha1.month(1:24:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(3,:); ax2.YAxis(2).Color = color_mtx_dark(3,:);
ylabel ('GCC_{phenocam}','FontSize',16,'color',color_mtx_dark(3,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(Ha1.daydate(20),25,site_name,'FontSize',16)


%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [Ha1.day_recurrentGEPday-Ha1.day_recurrent_stdGEPday,2.*Ha1.day_recurrent_stdGEPday];
% h = area(Ha1.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(Ha1.daydate,Ha1.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl1 = plot(Ha1.daydate,Ha1.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(Ha1.daydate,Ha1.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(Ha1.daydate,zeros(length(Ha1.daydate),1)+mean(Ha1.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month(1:6:end);
set(ax2,'XTick',Ha1.month(1:24:end),'XTickLabel',datestr(Ha1.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[Ha1.daydate(1) Ha1.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(Ha1.month(12),v3(2),site_name,'FontSize',16);

w1 = 0;                      w2 = 70;       w3 = w1:((w2-w1)/4):w2;
ROI.ExGREEN_mean = (2.*ROI.g_mean)-ROI.r_mean-ROI.b_mean;
yyaxis right;
scatter(ROI.daydate,ROI.ExGREEN_mean,'o','MarkerFaceColor',color_mtx(5,:),'MarkerEdgeColor',color_mtx_dark(5,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(ROI.daydate,smoothdata(ROI.ExGREEN_mean,'movmean',5),'-','Color',color_mtx_dark(5,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.month(1) Ha1.month(end)],'YTickLabel',w3,...
    'XTick',Ha1.month(1:24:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(5,:); ax2.YAxis(2).Color = color_mtx_dark(5,:);
ylabel ('ExGREEN_{phenocam}','FontSize',16,'color',color_mtx_dark(5,:));   xtickangle(0);   box on;
text(Ha1.daydate(20),25,site_name,'FontSize',16)

%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [Ha1.day_recurrentGEPday-Ha1.day_recurrent_stdGEPday,2.*Ha1.day_recurrent_stdGEPday];
% h = area(Ha1.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(Ha1.daydate,Ha1.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl1 = plot(Ha1.daydate,Ha1.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(Ha1.daydate,Ha1.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(Ha1.daydate,zeros(length(Ha1.daydate),1)+mean(Ha1.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month(1:6:end);
set(ax2,'XTick',Ha1.month(1:24:end),'XTickLabel',datestr(Ha1.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[Ha1.daydate(1) Ha1.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(Ha1.month(12),v3(2),site_name,'FontSize',16);

w1 = 0.7;                      w2 = 1.7;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(ROI.daydate,ROI.GRRI_mean,'o','MarkerFaceColor',color_mtx(5,:),'MarkerEdgeColor',color_mtx_dark(5,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(ROI.daydate,smoothdata(ROI.GRRI_mean,'movmean',5),'-','Color',color_mtx_dark(5,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.month(1) Ha1.month(end)],'YTickLabel',w3,...
    'XTick',Ha1.month(1:24:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(5,:); ax2.YAxis(2).Color = color_mtx_dark(5,:);
ylabel ('GRRI_{phenocam}','FontSize',16,'color',color_mtx_dark(5,:));   xtickangle(0);   box on;
text(Ha1.daydate(20),25,site_name,'FontSize',16)

%%
v1 = 0;                         v2 = 440;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% ix = find(Ha1.monthTRMM<100);    iy = ones(length(Ha1.month),1);	iy = iy.*v1;
% iz = iy;                        iz(ix) = (v2+v1);
% y  = [iy,iz];
% h  = bar(Ha1.month',y, 'BarWidth', 4);          set(gca,'Layer','top');
% set(h(2),'FaceColor',[.9 .9 .9],'EdgeColor',[.9 .9 .9]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',v1);          hold on;
hold on;
hl2 = plot(Ha1.daydate,Ha1.day_recurrentnetradday,'LineWidth',1,'color',[0.6 0. 0.0 ]); hold on;
hl1 = plot(Ha1.daydate,Ha1.daynetradday,'LineWidth',1,'color',[0.4 0.4 0.8]); hold on;
hl3 = plot(Ha1.daydate,(Ha1.daynetradday.*0)+mean(Ha1.daynetradday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hold on;         ax2 = gca;         set(ax2,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';         ax2.XAxis.MinorTickValues = Ha1.daydate(1:90:end);
set(ax2,'XTick',Ha1.month(1:36:end),'XTickLabel',datestr(Ha1.month(1:36:end),'yyyy'),'YTick',v3,...
    'XLim',[Ha1.daydate(1) Ha1.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('Net Radiation_{daytime} (W m^-^2)','FontSize',16);   xtickangle(0);

%%
yearSelect = 2020;
ind = find(Ha1.dayY==yearSelect);
v1 = 0;                         v2 = 27;       v3 = v1:((v2-v1)/3):v2;
w1 = 300.;                         w2 = 1100;       w3 = w1:((w2-w1)/4):w2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
h = area(Ha1.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
hold on;
hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPday(ind),'-','LineWidth',1,'color',[0.5 0.5 0.5 ]); hold on;
hl1 = plot(Ha1.daydate(ind),Ha1.dayGEPday(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.3]);  alpha = 0.3;
% hl3 = plot(Ha1.daydate(ind),(Ha1.dayGEPday(ind).*0)+mean(Ha1.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;

ind = find((Ha1.dayGEPday>(Ha1.day_recurrentGEPday+(2.*Ha1.day_recurrent_stdGEPday))));
scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[0.2 0.2 0.6],'MarkerEdgeColor',[0.28 0.28 0.28],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(Ha1.dayY==yearSelect);
hold on;         ax2 = gca;       set(ax2,'YColor','k');
ax2.XAxis.MinorTick = 'on';       ax2.XAxis.MinorTickValues = datetime(yearSelect,1:1:12,1);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'FontSize',16,'XMinorGrid','on','XTick',datetime(yearSelect,1:2:12,1)');    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',Ha1.month(1:36:end),'XTickLabel',datestr(Ha1.month(1:36:end),'yyyy')
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;
text(Ha1.daydate(ind(20)),23,site_name,'FontSize',16);

yyaxis right;
ind = find(Ha1.dayY==yearSelect);
scatter(Ha1.daydate(ind),Ha1.dayPARday(ind), 8,'o','filled', 'MarkerFaceAlpha', 0.7,...
    'MarkerEdgeColor', color_mtx_dark(9,:),'MarkerFaceColor', color_mtx_dark(9,:));
ind = find(Ha1.eightY==yearSelect);
plot(Ha1.eight(ind),smoothdata(Ha1.eightPARday(ind),'movmean',3),'-','LineWidth',2,'Color',color_mtx_dark(9,:));
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'YTickLabel',w3,'XTick',(datetime(yearSelect,1:2:12,1)'));  ax2.YColor = color_mtx_dark(9,:);%'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('PAR_{day} (\mumol m^-^2 s-^1)','FontSize',16,'color',color_mtx_dark(9,:));   xtickangle(0);   box on;

%%
yearSelect = 2020;
ind = find(Ha1.dayY==yearSelect);
v1 = 0;                         v2 = 27;       v3 = v1:((v2-v1)/3):v2;
w1 = 0.1;                         w2 = .4;       w3 = w1:((w2-w1)/3):w2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
h = area(Ha1.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
hold on;
hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPday(ind),'-','LineWidth',1,'color',[0.5 0.5 0.5 ]); hold on;
hl1 = plot(Ha1.daydate(ind),Ha1.dayGEPday(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.3]);  alpha = 0.3;
% hl3 = plot(Ha1.daydate(ind),(Ha1.dayGEPday(ind).*0)+mean(Ha1.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;

ind = find((Ha1.dayGEPday>(Ha1.day_recurrentGEPday+(2.*Ha1.day_recurrent_stdGEPday))));
scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[0.2 0.2 0.6],'MarkerEdgeColor',[0.28 0.28 0.28],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(Ha1.dayY==yearSelect);
hold on;         ax2 = gca;       set(ax2,'YColor','k');
ax2.XAxis.MinorTick = 'on';       ax2.XAxis.MinorTickValues = datetime(yearSelect,1:1:12,1);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'FontSize',16,'XMinorGrid','on','XTick',datetime(yearSelect,1:2:12,1)');    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',Ha1.month(1:36:end),'XTickLabel',datestr(Ha1.month(1:36:end),'yyyy')
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;
text(Ha1.daydate(ind(20)),23,site_name,'FontSize',16);

yyaxis right;
ind = find(Ha1.eightY==yearSelect);
scatter(Ha1.eight(ind),Ha1.eightEVI(ind), 'o', 'filled', 'MarkerFaceAlpha', 0.7,...
    'MarkerEdgeColor', color_mtx_dark(8,:),'MarkerFaceColor', color_mtx_dark(8,:));
plot(Ha1.eight(ind),smoothdata(Ha1.eightEVI(ind),'movmean',3),'-','LineWidth',2,'Color',color_mtx_dark(8,:));
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'YTickLabel',w3,'XTick',(datetime(yearSelect,1:2:12,1)'));  ax2.YColor = color_mtx_dark(8,:);%'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('EVI','FontSize',16,'color',color_mtx_dark(8,:));   xtickangle(0);   box on;

%%
yearSelect = 2019;
ind = find(Ha1.dayY==yearSelect);
v1 = -3.;                         v2 = 26;       v3 = 0:((v2-0)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
h = area(Ha1.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.9 .9 .9]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPdayGoley(ind),'-','LineWidth',.5,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(Ha1.daydate(ind),Ha1.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
% hl3 = plot(Ha1.daydate(ind),(Ha1.dayGEPday(ind).*0)+mean(Ha1.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
% hl4 = plot(Ha1.daydate(ind),Ha1.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

hl6 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[.6 .6 .6],'MarkerEdgeColor',[0.6 0.6 0.6],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
hl2 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPday(ind),'movmean',3),'-','LineWidth',.5,'color',[0. 0. 0. ]); hold on;

ind = find(Ha1.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

% pause(2)
w1 = 0.35;                      w2 = .48;       w3 = .36:((w2-.36)/3):w2;
yyaxis right;
ind = find(Ha1.dayY==yearSelect);
scatter(Ha1.daydate(ind),AM_fill(Ha1.ROIgcc(ind)),'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(Ha1.daydate(ind),smoothdata(AM_fill(Ha1.ROIgcc(ind)),'movmean',3),'-','Color',color_mtx_dark(3,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',Ha1.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(3,:); ax2.YAxis(2).Color = color_mtx_dark(3,:);
ylabel ('GCC_{phenocam}','FontSize',16,'color',color_mtx_dark(3,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)

%%
yearSelect = 2020;
ind = find(Ha1.dayY==yearSelect);
v1 = 0;                         v2 = 27;       v3 = v1:((v2-v1)/3):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
h = area(Ha1.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPdayGoley(ind),'-','LineWidth',.5,'color',[0.3 0.3 0.3 ]); hold on;
hl1 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),20,'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.9 0.6 0.2]);
hold on; alpha = 0.3;
% hl3 = plot(Ha1.daydate(ind),(Ha1.dayGEPday(ind).*0)+mean(Ha1.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
% hl4 = plot(Ha1.daydate(ind),Ha1.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayGrowth>(Ha1.day_recurrentGEPdayGoley+(2.*Ha1.day_recurrent_stdGEPday))));
hl5 = scatter(Ha1.daydate(ind),smoothdata(Ha1.dayGEPday(ind),'movmean',3),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

hl6 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(Ha1.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:2:end),'XColor',[0.9 0.6 0.2])
ylabel ('photosynthesis (gC m^-^2 d^-^1)','color',[0.9,0.6,0.2],'FontSize',16);   xtickangle(0);   box on;   grid on;

% pause(2)
w1 = 0;                      w2 = 70;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
ind = find(Ha1.dayY==yearSelect);
scatter(Ha1.daydate(ind),Ha1.ROIexgreen(ind),8,'o','MarkerFaceColor',color_mtx(7,:),'MarkerEdgeColor',color_mtx_dark(7,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(Ha1.daydate(ind),smoothdata(Ha1.ROIexgreen(ind),'movmean',3),'-','Color',color_mtx_dark(7,:),'Linewidth',1);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',Ha1.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(7,:); ax2.YAxis(2).Color = color_mtx_dark(7,:);
ylabel ('exgreen_{phenocam}','FontSize',16,'color',color_mtx_dark(7,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)

%%
yearSelect = 2019;
ind = find(Ha1.dayY==yearSelect);
v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
h = area(Ha1.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(Ha1.daydate(ind),Ha1.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(Ha1.daydate(ind),(Ha1.dayGEPday(ind).*0)+mean(Ha1.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(Ha1.daydate(ind),Ha1.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayGrowth>(Ha1.day_recurrentGEPdayGoley+(2.*Ha1.day_recurrent_stdGEPday))));
hl5 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

hl6 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(Ha1.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

% pause(2)
w1 = 1.2;                      w2 = 1.8;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
ind = find(Ha1.dayY==yearSelect);
scatter(Ha1.daydate(ind),Ha1.ROIGRRI(ind),'o','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(Ha1.daydate(ind),smoothdata(Ha1.ROIGRRI(ind),'movmean',3),'-','Color',color_mtx_dark(2,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',Ha1.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(2,:); ax2.YAxis(2).Color = color_mtx_dark(2,:);
ylabel ('GRRI_{phenocam}','FontSize',16,'color',color_mtx_dark(2,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)

%%
yearSelect = 2019;
ind = find(Ha1.dayY==yearSelect);
v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
h = area(Ha1.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
hl1 = plot(Ha1.daydate(ind),Ha1.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(Ha1.daydate(ind),(Ha1.dayGEPday(ind).*0)+mean(Ha1.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(Ha1.daydate(ind),Ha1.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayGrowth>(Ha1.day_recurrentGEPdayGoley+(2.*Ha1.day_recurrent_stdGEPday))));
hl5 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

hl6 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(Ha1.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

% pause(2)
w1 = 0.25;                      w2 = .45;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
ind = find(Ha1.dayY==yearSelect);
scatter(Ha1.daydate(ind),Ha1.ROIrcc(ind),'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(Ha1.daydate(ind),smoothdata(Ha1.ROIrcc(ind),'movmean',3),'-','Color',color_mtx_dark(3,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',Ha1.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(3,:); ax2.YAxis(2).Color = color_mtx_dark(3,:);
ylabel ('RCC_{phenocam}','FontSize',16,'color',color_mtx_dark(3,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)

%%
numberY = Ha1.Y(end) -Ha1.Y(1);
v1 = 0;         v2 = 32;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/numberY):v2;
x1 = 0.36;      x2 = .48;         x3 = x1:((x2-x1)/4):x2;     x4 = x1:((x2-x1)/numberY):x2;
figure('color','white');          hold on;
ik = ROI.dayY(1);                 count=1;     color_jet = jet(max(Ha1.dayY)-min(ROI.dayY)+1);
while ik<Ha1.dayY(end)
    plot(Ha1.eightROIgcc(Ha1.eightY == ik),smoothdata(Ha1.eightGEPday(Ha1.eightY == ik),'movmean',3),'-','Color',color_jet(count,:));
    scatter(Ha1.eightROIgcc(Ha1.eightY == ik),Ha1.eightGEPday(Ha1.eightY == ik),'o','MarkerFaceColor',color_jet(count,:),...
        'MarkerEdgeColor',color_jet(count,:), 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5); hold on;
    AM_compute_regression(Ha1.eightROIgcc(Ha1.eightY == ik),Ha1.eightGEPday(Ha1.eightY == ik),color_jet(count,:),1);
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
yearSelect = 2020;
ind = find(Ha1.dayY==yearSelect);
v1 = -10;                          v2 = 16;       v3 = v1:((15-v1)/5):15;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [Ha1.day_recurrentGEP(ind)-Ha1.day_recurrent_stdGEP(ind),2.*Ha1.day_recurrent_stdGEP(ind)];
h = area(Ha1.daydate(ind),y);     set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);

hold on;
hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPGoley(ind),'-','LineWidth',.5,'color',[0.3 0.3 0.3 ]); hold on;
% hl3 = plot(Ha1.daydate(ind),(Ha1.dayGEP(ind).*0)+mean(Ha1.dayGEP,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;

hl5 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind).*Ha1.dayLength(ind)./24,'MarkerFaceColor',[0.3 0.3 0.3 ],...
    'MarkerEdgeColor',[0.3 0.3 0.3],'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(Ha1.dayGEPARIMAzvalueResidual,'omitnan');
% iy = std(Ha1.dayGEPARIMAzvalueResidual,'omitnan');
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPARIMAzvalueResidualGrowth>thresholdARIMA)&(Ha1.dayGEPGrowth>Ha1.day_recurrentGEPGoley));
% zvalue value-mu/std
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(Ha1.dayGEPGrowth>Ha1.day_recurrentGEPGoley));
% hl6 = scatter(Ha1.daydate(ind),Ha1.dayGEP(ind).*Ha1.dayLength(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(Ha1.dayGEPHURSTzvalue,'omitnan');
% iy = std(Ha1.dayGEPHURSTzvalue,'omitnan');
% % ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPHURST>(ix+(1.5.*iy))));
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPHURSTzvalue<0.5)&(Ha1.dayGEPGrowth>Ha1.day_recurrentGEPGoley));
% hl7 = scatter(Ha1.daydate(ind),Ha1.dayGEP(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(Ha1.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16,'color',[0.3 0.3 0.3]);
xtickangle(0);   box on;   grid on;

w1 = -10;        w2 = 16;               w3 = w1:((15-w1)/5):15;
yyaxis right;
y = [Ha1.day_recurrentRECO(ind)-Ha1.day_recurrent_stdRECO(ind),2.*Ha1.day_recurrent_stdRECO(ind)];
h = area(Ha1.daydate(ind),-y);     set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);

hl6 = plot(Ha1.daydate(ind),-Ha1.day_recurrentRECO(ind),'-','LineWidth',.5,'color',[0.3 0.3 0.3 ]); hold on;
scatter(Ha1.daydate(ind),-Ha1.dayRECO(ind),'o','MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(Ha1.daydate(ind),-smoothdata(Ha1.dayRECO(ind),'movmean',3),'-','Color',color_mtx_dark(1,:),'Linewidth',2);

% % ind = find((Ha1.dayY==yearSelect)&(Ha1.dayRECOGrowth>(Ha1.day_recurrentRECOGoley+(2.*Ha1.day_recurrent_stdRECO))));
% % hl5 = scatter(Ha1.daydate(ind),Ha1.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % ind = find((Ha1.dayY==yearSelect)&(Ha1.dayRECOARIMAzvalueResidual>thresholdARIMAzvalue)&...
% %     (Ha1.dayRECOGrowth>Ha1.day_recurrentRECOGoley));
% % hl6 = scatter(Ha1.daydate(ind),Ha1.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % ix = mean(Ha1.dayRECOHURSTzvalue,'omitnan');
% % iy = std(Ha1.dayRECOHURSTzvalue,'omitnan');
% % ind = find((Ha1.dayY==yearSelect)&(Ha1.dayRECOHURSTzvalue<0.5)&(Ha1.dayRECOGrowth>Ha1.day_recurrentRECOGoley));
% % hl7 = scatter(Ha1.daydate(ind),Ha1.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(Ha1.dayY==yearSelect);
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',Ha1.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(2,:); ax2.YAxis(2).Color = color_mtx_dark(1,:);
ylabel ('respiration (gC m^-^2 d^-^1)','FontSize',16,'color',color_mtx_dark(1,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)

%% NEP
yearSelect = 2020;
ind = find(Ha1.dayY==yearSelect);
v1 = -5;                          v2 = 10;       v3 = v1:((v2-v1)/3):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
y = [Ha1.day_recurrentNEE(ind)-Ha1.day_recurrent_stdNEE(ind),2.*Ha1.day_recurrent_stdNEE(ind)];
h = area(Ha1.daydate(ind),-y);     set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);

hold on;
hl2 = plot(Ha1.daydate(ind),-Ha1.day_recurrentNEEGoley(ind),'-','LineWidth',.5,'color',[0.3 0.3 0.3 ]); hold on;
hl3 = plot(Ha1.daydate(ind),(Ha1.dayNEE(ind).*0)-mean(Ha1.dayNEE(ind),'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;

hl5 = scatter(Ha1.daydate(ind),-Ha1.dayNEEday(ind).*Ha1.dayLength(ind)./24,'MarkerFaceColor',[0.3 0.3 0.3 ],...
    'MarkerEdgeColor',[0.3 0.3 0.3],'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'YTickLabel',v3,...
    'XTick',Ha1.month(1:2:end),'FontSize',16);    grid on;
ylabel ('NEP (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)

%%
yearSelect = 2019;
ind = find(Ha1.dayY==yearSelect);
v1 = 0;                         v2 = 36;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
h = area(Ha1.daydate(ind),y);   set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(Ha1.daydate(ind),Ha1.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(Ha1.daydate(ind),(Ha1.dayGEPday(ind).*0)+mean(Ha1.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(Ha1.daydate(ind),Ha1.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayGrowth>(Ha1.day_recurrentGEPdayGoley+(2.*Ha1.day_recurrent_stdGEPday))));
hl5 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(Ha1.dayGEPdayARIMAzvalueResidual,'omitnan');
% iy = std(Ha1.dayGEPdayARIMAzvalueResidual,'omitnan');
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMA)&(Ha1.dayGEPdayGrowth>Ha1.day_recurrentGEPdayGoley));
% zvalue value-mu/std
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(Ha1.dayGEPdayGrowth>Ha1.day_recurrentGEPdayGoley));
hl6 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(Ha1.dayGEPdayHURSTzvalue,'omitnan');
% iy = std(Ha1.dayGEPdayHURSTzvalue,'omitnan');
% % ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayHURST>(ix+(1.5.*iy))));
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayHURSTzvalue<0.5)&(Ha1.dayGEPdayGrowth>Ha1.day_recurrentGEPdayGoley));
% hl7 = scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(Ha1.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',Ha1.month(1:36:end),'XTickLabel',datestr(Ha1.month(1:36:end),'yyyy')
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
% text(Ha1.daydate(ind(20)),250,site_name,'FontSize',16)

w1 = 0.1;               w2 = .42;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;           hold on;
% scatter(Ha1.daydate(ind),Ha1.dayEVI(ind),'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
%     'MarkerFaceAlpha',.7,'MarkerEdgeAlpha',.7);
% plot(Ha1.daydate(ind),smoothdata(Ha1.dayEVI(ind),'movmean',3),'-','Color',color_mtx_dark(4,:),'Linewidth',2);
ind = find(Ha1.eightY==yearSelect);
scatter(Ha1.eight(ind),Ha1.eightEVI(ind), 'o', 'filled', 'MarkerFaceAlpha', 0.7, 'MarkerEdgeColor', color_mtx_dark(5,:),...
    'MarkerFaceColor', color_mtx_dark(5,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(Ha1.eight(ind),smoothdata(Ha1.eightEVI(ind),'movmean',3),'-','LineWidth',2,'Color',color_mtx_dark(5,:));
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'YTickLabel',w3,'XTick',(datetime(yearSelect,1:2:12,1)'));    %'XTickLabelColor',[0. 0. 0.7 ]
% ind = find(Ha1.dayY==yearSelect);
% set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'YTickLabel',w3,...
%     'XTick',Ha1.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(2,:); ax2.YAxis(2).Color = color_mtx_dark(5,:);
ylabel ('EVI','FontSize',16,'color',color_mtx_dark(5,:));   xtickangle(0);   box on;
text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)

%% hourly
% .....................................................................................
% close all;
cla;
indSelect = find((Ha1.dateloc>=datetime(2019,6,24))&(Ha1.dateloc<=datetime(2019,7,3)));
v1 = 0;                         v2 = 20;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 800],'units','inches');
subplot(2,1,1);
yyaxis left;
y = [Ha1.recurrentET(indSelect)-Ha1.recurrent_stdET(indSelect),2.*Ha1.recurrent_stdET(indSelect)];
hl1 = area(days(Ha1.dateloc(indSelect)-Ha1.dateloc(indSelect(1))),y);
set(hl1(2),'FaceColor',[.8 .8 .9],'EdgeColor',[.8 .8 .9],'FaceAlpha',.5);
set(hl1(1),'FaceColor','none','EdgeColor','none');
set(hl1,'BaseValue',0);
hl2 = plot(Ha1.dateloc(indSelect),Ha1.PET(indSelect),'-','LineWidth',1,'color',[0.07,0.44,0.75]); hold on;
% set(gca,'YColor',[0.9 0.6 0.2]);
hold on;
% cla(gca, 'reset');
ax1 = gca;       %set(ax1,'YColor',[0.4 0.4 0.8]);
set(ax1,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.dateloc(indSelect(1)) Ha1.dateloc(indSelect(end))],...
    'FontSize',16);%,'XTick',Ha1.dateloc(indSelect(1:24:end)));
ylabel ('PET (mm s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

yyaxis right;
y = [Ha1.recurrentET(indSelect)-Ha1.recurrent_stdET(indSelect),2.*Ha1.recurrent_stdET(indSelect)];
hl3 = area(days(Ha1.dateloc(indSelect)-Ha1.dateloc(indSelect(1))),y);       set(gca,'Layer','top');
set(hl3(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'FaceAlpha',.5);
set(hl3(1),'FaceColor','none','EdgeColor','none');
set(hl3,'BaseValue',0);
% set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.dateloc(ind(1)) Ha1.dateloc(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl4 = plot(Ha1.dateloc(indSelect),Ha1.recurrentET(indSelect),'-','LineWidth',2,'color',[0.6 0.6 0.6 ]); hold on;
hl5 = plot(Ha1.dateloc(indSelect),Ha1.ET(indSelect),'-','LineWidth',2,'color',[0.9 0.6 0.2]); hold on;
% hl6 = plot(Ha1.dateloc(indSelect),(Ha1.ET(indSelect).*0)+mean(Ha1.dayETday,'omitnan'),'--','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;

ax2 = gca;                     set(ax2,'YColor',[0.9 0.6 0.2]);
ax2.XAxis.MinorTick = 'on';    ax2.XAxis.MinorTickValues = Ha1.daydate(1:1:end);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.dateloc(indSelect(1)) Ha1.dateloc(indSelect(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',Ha1.dateloc(indSelect(1:48:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',Ha1.month(1:36:end),'XTickLabel',datestr(Ha1.month(1:36:end),'yyyy')
ylabel ('ET (mm s^-^1)','FontSize',16);  box on;   grid on;
text(Ha1.dateloc(indSelect(20)),18,site_name,'FontSize',16)

% cla;
subplot(2,1,2);     hold on;
v1 = 0.42;           v2 = .46;       v3 = v1:((v2-v1)/4):v2;
indSelect = find((Ha1.daydate>=datetime(2019,6,24))&(Ha1.daydate<=datetime(2019,7,3)));
% yyaxis left;
y = [Ha1.day_recurrentROIgcc(indSelect)-Ha1.day_recurrent_stdROIgcc(indSelect),2.*Ha1.day_recurrent_stdROIgcc(indSelect)];
h = area(Ha1.daydate(indSelect),y);
% set(h,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'FaceAlpha',.5);
set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);          hold on;
hl1 = plot(Ha1.daydate(indSelect),Ha1.day_recurrentROIgcc(indSelect),'-k');
hl2 = scatter(Ha1.daydate(indSelect),Ha1.ROIgcc(indSelect),'.','MarkerFaceColor',[0.87 0.33 0.],'MarkerEdgeColor',[0.87 0.33 0.],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
hl3 = plot(Ha1.daydate(indSelect),(Ha1.ROIgcc(indSelect)),'-','Color',[0.87 0.33 0.]);
% cla;
ax1 = gca;                      set(ax1,'YColor',[0.9 0.6 0.2]);
ax1.XAxis.MinorTick = 'on';     ax1.XAxis.MinorTickValues = Ha1.daydate(1:1:end);
set(ax1,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(indSelect(1)) Ha1.daydate(indSelect(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',Ha1.daydate(indSelect(1:2:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GCC_{phenocam}','FontSize',16);
grid on;          box on;

% w1 = 0.29;                      w2 = .49;       w3 = w1:((w2-w1)/4):w2;
% yyaxis right;
% scatter(Ha1.dateloc(ind),Ha1.dayROIgcc(ind),'.','MarkerFaceColor',[0.87 0.33 0.],'MarkerEdgeColor',[0.87 0.33 0.],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% plot(Ha1.dateloc(ind),smoothdata(Ha1.dayROIgcc(ind),'movmean',3),'-','Color',[0.87 0.33 0.]);
%
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayROIgccGrowth>(Ha1.day_recurrentROIgccGoley+(2.*Ha1.day_recurrent_stdROIgcc))));
% hl5 = scatter(Ha1.dateloc(ind),Ha1.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayROIgccARIMAzvalueResidual>thresholdARIMAzvalue)&...
%     (Ha1.dayROIgccGrowth>Ha1.day_recurrentROIgccGoley));
% hl6 = scatter(Ha1.dateloc(ind),Ha1.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% ix = mean(Ha1.dayROIgccHURSTzvalue,'omitnan');
% iy = std(H,'YTickLabel',w3a1.dayROIgccHURSTzvalue,'omitnan');
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayROIgccHURSTzvalue<0.5)&(Ha1.dayROIgccGrowth>Ha1.day_recurrentROIgccGoley));
% hl7 = scatter(Ha1.dateloc(ind),Ha1.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
ax2 =gca;
% ind = find(Ha1.dayY==yearSelect);
% set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.dateloc(indSelect(1)) Ha1.dateloc(indSelect(end))],...
%     'YTickLabel',v3,'XTick',Ha1.dateloc(indSelect(1:2:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
% ylabel ('GCC_{phenocam}','FontSize',16,'color',[0.87 0.33 0.]);   xtickangle(0);   box on;
% % legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5'); legend box off;


% .....................................................................................
%% deseasonalized  Ha1.dayGEPday_zscore   dayGEPday_deseasoned
% .....................................................................................
order = 3;
framelen = 5;
yearSelect = 2019;
ind = find(Ha1.dayY==yearSelect);
v1 = -10;             v2 = 10;       v3 = v1:((v2-v1)/4):v2;
w1 = 0.34;            w2 = .5;       w3 = w1:((w2-w1)/4):w2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
% y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
% h = area(Ha1.daydate(ind),y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
% hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPdayGoley(ind),'LineWidth',1,'color',[0. 0.6 0.6 ]); hold on;
hl1 = plot(Ha1.daydate(ind),Ha1.dayGEPday_zscore(ind),'LineWidth',0.8,'color',[0.5 0.5 0.5]); hold on; alpha = 0.3;
hl3 = plot(Ha1.daydate(ind),(Ha1.dayGEPday_zscore(ind).*0)+mean(Ha1.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
% hl4 = plot(Ha1.daydate(ind),Ha1.dayGEPdayGrowth(ind),'LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayGrowth>(Ha1.day_recurrentGEPdayGoley+(2.*Ha1.day_recurrent_stdGEPday))));
hl5 = scatter(Ha1.daydate(ind),Ha1.dayGEPday_zscore(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(Ha1.dayGEPdayARIMAzvalueResidual,'omitnan');
% iy = std(Ha1.dayGEPdayARIMAzvalueResidual,'omitnan');
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMA)&(Ha1.dayGEPdayGrowth>Ha1.day_recurrentGEPdayGoley));
% zvalue value-mu/std
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(Ha1.dayGEPdayGrowth>Ha1.day_recurrentGEPdayGoley));
hl6 = scatter(Ha1.daydate(ind),Ha1.dayGEPday_zscore(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(Ha1.dayGEPdayHURSTzvalue,'omitnan');
% iy = std(Ha1.dayGEPdayHURSTzvalue,'omitnan');
% % ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayHURST>(ix+(1.5.*iy))));
% ind = find((Ha1.dayY==yearSelect)&(Ha1.dayGEPdayHURSTzvalue<0.5)&(Ha1.dayGEPdayGrowth>Ha1.day_recurrentGEPdayGoley));
% hl7 = scatter(Ha1.daydate(ind),Ha1.dayGEPday_zscore(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(Ha1.dayY==yearSelect);
hold on;           ax2 = gca;         set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.daydate(1:90:end);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',Ha1.month(1:36:end),'XTickLabel',datestr(Ha1.month(1:36:end),'yyyy')
ylabel ('LE_{daytime} (W m^-^2)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(Ha1.daydate(ind(20)),250,site_name,'FontSize',16)

yyaxis right;
scatter(Ha1.daydate(ind),Ha1.ROIgcc(ind),10,'.','MarkerFaceColor',[0.5 0.2 0.2],'MarkerEdgeColor',[0.6 0.1 0.1],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(Ha1.daydate(ind),AM_fill_plus(smoothdata(Ha1.ROIgcc(ind),'movmean',3)),'-','Color',[0.6 0.1 0.1]);
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'YTickLabel',['']);    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GCC_{phenocam}','FontSize',16,'color',[0.6 0.2 0.2]);   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;

%%
order = 5;   framelen = 9;
yearSelect = 2018;
ind = find(Ha1.dayY==yearSelect);

z1 = 0;             z2 = 26;       z3 = ((z2-z1)/6);       z4 = z1:3*z3:z2;    z5 = z1:z3:z2;
y1 = -100;          y2 = 700;      y3 = ((y2-y1)/6);       y4 = y1:3*y3:y2;    y5 = y1:y3:y2;

x1 = Ha1.daydate(ind);
x2 = Ha1.daydate(ind);

y1 = Ha1.ROIgcc(ind);     GCCgolay = sgolayfilt(Ha1.ROIgcc(ind),order,framelen);    
GCCgolay = smoothdata(Ha1.ROIgcc(ind),'movmean',3); 
y8 = GCCgolay;

y3 = Ha1.dayGEPday(ind);  
y4 = Ha1.dayGEPday(ind);  GEPgolay = sgolayfilt(Ha1.dayGEPday(ind),order,framelen); 
y9 = GEPgolay;

y5 = Ha1.dayPAR(ind);     %PARgolay = sgolayfilt(Ha1.dayPAR(ind),order,framelen);
PARgolay = smoothdata(Ha1.dayPAR(ind),'movmean',9); 
y6 = Ha1.dayPAR(ind);
y10 = PARgolay;

y7 = Ha1.daytair(ind);    %Tairgolay = sgolayfilt(Ha1.daytair(ind),order,framelen);
Tairgolay = smoothdata(Ha1.daytairday(ind),'movmean',11); 
y11 = Ha1.daytair(ind);
y12 = Tairgolay;

y2 = 1-Ha1.ROIrcc(ind);
y2((Ha1.dayM(ind)<=4)|(Ha1.dayM(ind)>=11)) = NaN;
y13 = smoothdata(y2,'movmean',3); 

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
% ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1), T_{air} (/circC)';
ylabels{2} = 'GCC';
ylabels{3} = 'PAR_{day} (\mumol m^-^2 s^-^1)';
yaxisval   = [-.5,25,0.36,.48,-.5,600];
% [ax,hlines] = AM_multiplotyyyGEPday2annual({x2,y1,x2,y8},{x1,y3,x1,y9,x2,y12},{x1,y10,x1,y10},ylabels,yaxisval);
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y1,x2,y8},{x1,y10,x1,y10},ylabels,yaxisval,1);
% legend(cat(1,hlines{1,:}),'GEP','GCC','PAR','location','nw')

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'RCC';
ylabels{3} = 'PAR_{day} (\mumol m^-^2 s^-^1)';
yaxisval   = [-.5,25,0.55,.8,-.5,600];
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y2,x2,y13},{x1,y10,x1,y10},ylabels,yaxisval,1);

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'GCC';
ylabels{3} = '1-RCC';
yaxisval   = [-.5,25,0.36,.48,0.55,.75];
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y1,x2,y8},{x2,y2,x2,y13},ylabels,yaxisval,3);

%%
order = 5;   framelen = 9;
yearSelect = 2018;
ind = find(Ha1.dayY==yearSelect);

z1 = 0;      z2 = 26;     z3 = ((z2-z1)/6);       z4 = z1:3*z3:z2;    z5 = z1:z3:z2;
y1 = 0;      y2 = 1;      y3 = ((y2-y1)/6);       y4 = y1:3*y3:y2;    y5 = y1:y3:y2;

x1 = Ha1.daydate(ind);
x2 = Ha1.daydate(ind);

y1 = Ha1.ROIgcc(ind);     GCCgolay = sgolayfilt(Ha1.ROIgcc(ind),order,framelen);    
GCCgolay = smoothdata(Ha1.ROIgcc(ind),'movmean',3); 
y8 = GCCgolay;

y3 = Ha1.dayGEPday(ind);  
y4 = Ha1.dayGEPday(ind);  GEPgolay = sgolayfilt(Ha1.dayGEPday(ind),order,framelen); 
y9 = GEPgolay;

y5 = Ha1.ROIGRRI(ind);     %PARgolay = sgolayfilt(Ha1.dayPAR(ind),order,framelen);
GRRIgolay = smoothdata(Ha1.ROIGRRI(ind),'movmean',9); 
y6 = Ha1.ROIGRRI(ind);
y10 = GRRIgolay;

y7 = Ha1.ROIexgreen(ind);    %Tairgolay = sgolayfilt(Ha1.daytair(ind),order,framelen);
ExGREENgolay = smoothdata(Ha1.ROIexgreen(ind),'movmean',11); 
y11 = Ha1.ROIexgreen(ind);
y12 = ExGREENgolay;

y2 = 1-Ha1.ROIrcc(ind);
y2((Ha1.dayM(ind)<=4)|(Ha1.dayM(ind)>=11)) = NaN;
y13 = smoothdata(y2,'movmean',3); 

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
% ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1), T_{air} (/circC)';
ylabels{2} = 'GCC';
ylabels{3} = 'ExGREEN';
yaxisval   = [-.5,25,0.36,.48,.6,2];
% [ax,hlines] = AM_multiplotyyyGEPday2annual({x2,y1,x2,y8},{x1,y3,x1,y9,x2,y12},{x1,y10,x1,y10},ylabels,yaxisval);
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y1,x2,y8},{x1,y10,x1,y10},ylabels,yaxisval,1);
% legend(cat(1,hlines{1,:}),'GEP','GCC','PAR','location','nw')

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = '1-RCC';
ylabels{3} = 'ExGREEN';
yaxisval   = [-.5,25,0.6,.74,1.2,1.6];
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y2,x2,y13},{x1,y10,x1,y10},ylabels,yaxisval,1);

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'GCC';
ylabels{3} = '1-RCC';
yaxisval   = [-.5,25,0.36,.48,0.55,.75];
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y1,x2,y8},{x2,y2,x2,y13},ylabels,yaxisval,3);


%%
order = 5;   
framelen = 9;
yearSelect = 2018;

% Filter indices for target year
ind = find(Ha1.dayY == yearSelect);

% Datetime vectors
x1 = Ha1.daydate(ind);    
x2 = Ha1.daydate(ind);

% --- Index 1: GEP ---
y1 = Ha1.dayGEPday(ind);  
% GEPgolay = sgolayfilt(Ha1.dayGEPday(ind), order, framelen); 
GEPgolay = smoothdata(Ha1.dayGEPday(ind), 'movmean', 3); 
y2 = GEPgolay;

% --- Index 2: GCC ---
y3 = Ha1.ROIgcc(ind);     
GCCgolay = smoothdata(Ha1.ROIgcc(ind), 'movmean', 3); 
y4 = GCCgolay;

% --- Index 3: ExGREEN ---
y5 = Ha1.ROIexgreen(ind);     
ExGREENgolay = smoothdata(Ha1.ROIexgreen(ind), 'movmean', 3); 
y6 = ExGREENgolay;

% --- Index 4: GRRI ---
y7 = Ha1.ROIGRRI(ind);     
GRRIgolay = smoothdata(Ha1.ROIGRRI(ind), 'movmean', 3); 
y8 = GRRIgolay;

% --- Index 5: 1-RCC ---
y9 = 1 - Ha1.ROIrcc(ind);
% Mask off-season winter values to NaN
y9((Ha1.dayM(ind) <= 4) | (Ha1.dayM(ind) >= 11)) = NaN; 
y10 = smoothdata(y9, 'movmean', 3); % FIXED: target y9 instead of y7

% --- Index 6: GRIVI ---
y11 = Ha1.ROIGRIVI(ind);     
GRIVIgolay = smoothdata(Ha1.ROIGRIVI(ind), 'movmean', 3); 
y12 = GRIVIgolay;

% Y-axis labels
ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'GCC';
ylabels{3} = 'ExGREEN';
ylabels{4} = 'GRRI';
ylabels{5} = '1-RCC';
ylabels{6} = 'GRIVI';

% [ymin, ymax] bounds for all 5 axes
yaxisval = [ -0.5, 26;    % GEP
    0.36, 0.48; % GCC
    -5, 80.0; % ExGREEN
    1.15, 1.70; % GRRI
    0.55, 0.75;% 1-RCC
    0.1, 0.25];% GRIVI

% Execute multiplot with 5 datasets
[ax, hlines] = AM_multiplotyGEP4VI({x1, y1, x1, y2}, ... % Set 1 (GEP)
    {x2, y3, x2, y4}, ... % Set 2 (GCC)
    {x1, y5, x1, y6}, ... % Set 3 (ExGREEN)
    {x1, y7, x1, y8}, ... % Set 4 (GRRI)
    {x1, y9, x1, y10}, ...% Set 5 (1-RCC)
    {x1, y11, x1, y12}, ...% Set 6 GRIVI
    ylabels, yaxisval, 1);

%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [Ha1.day_recurrentGEPday-Ha1.day_recurrent_stdGEPday,2.*Ha1.day_recurrent_stdGEPday];
% h = area(Ha1.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(Ha1.daydate,Ha1.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl1 = plot(Ha1.daydate,Ha1.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(Ha1.daydate,Ha1.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(Ha1.daydate,zeros(length(Ha1.daydate),1)+mean(Ha1.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month(1:6:end);
set(ax2,'XTick',Ha1.month(1:24:end),'XTickLabel',datestr(Ha1.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[Ha1.daydate(1) Ha1.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(Ha1.month(12),v3(2),site_name,'FontSize',16);

w1 = 0;                      w2 = .3;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(ROI.daydate,ROI.GRIVI_mean,'o','MarkerFaceColor',color_mtx(5,:),'MarkerEdgeColor',color_mtx_dark(5,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(ROI.daydate,smoothdata(ROI.GRIVI_mean,'movmean',5),'-','Color',color_mtx_dark(5,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[Ha1.month(1) Ha1.month(end)],'YTickLabel',w3,...
    'XTick',Ha1.month(1:24:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(5,:); ax2.YAxis(2).Color = color_mtx_dark(5,:);
ylabel ('GRIVI_{phenocam}','FontSize',16,'color',color_mtx_dark(5,:));   xtickangle(0);   box on;
text(Ha1.daydate(20),25,site_name,'FontSize',16)

%  ........................................................................
%% Save files
% .....................................................................
% took out the day
%         FileDayExGREENcomposite = FileDayExGREENcomposite(:,(2:end));
header = [num2str(floor(length(FileDayExGREENcomposite)./365)) ' 365 ' num2str(roiLength) ];
writematrix (FileDayExGREENcomposite',[FolderCHOnat01 'timesat' slash 'tabletimesatExGREEN.txt'],'Delimiter','tab');
S = fileread([FolderCHOnat01 'timesat' slash 'tabletimesatExGREEN.txt']);
S = [header, newline, S];
fid = fopen([FolderCHOnat01 'timesat' slash 'tabletimesatExGREEN.txt'], 'w');
if fid == -1, error('Cannot open file %s', FileName); end
fwrite(fid, S, 'char');
fclose(fid);

%  ........................................................................
%% GRRI
%  ........................................................................
dayGRRIroi = NaN(length(FileDay),width(TableGRRIroiAvgAll));
figure('color','white');
for ix = 1:width(TableGRRIroiAvgAll)
    iy = TableGRRIroiAvgAll(:,ix);
    iw = smoothdata(iy);    iw(isnan(iy)) = NaN;    iy = iw;
    plot(FileDateAll,iy);   hold on;
    [im,~,iz]      = AM_day(iw,FileDateAll,1);     im(iz<2) = NaN;
    dayGRRIroi(:,ix) = im;
end
ind0 = (datetime(Yday(1),1,1):1:datetime(Yday(1),Mday(1),Dday(1)-1))';
indX = (datetime(Yday(end),Mday(end),Dday(end)+1):1:datetime(Yday(end),12,31))';
FileDayFill = [ind0;FileDay;indX];
roiLength = width(TableGRRIroiAvgAll);
FileDayGRRIcomposite = [NaN(length(ind0),roiLength);dayGRRIroi;NaN(length(indX),roiLength)];
FileDayGRRIcomposite = [NaN(length(ind0),roiLength);dayGRRIroi;NaN(length(indX),roiLength)];
FlagFillTimesat = [ones(length(ind0),roiLength);(dayGRRIroi.*0);ones(length(indX),roiLength)];

% .................................................................
for ix = 1:roiLength
    iy = FileDayGRRIcomposite(:,ix);
    FileDayGRRIcomposite(:,ix) = AM_fill_day_avg(iy,FileDayFill);
end

% ....................................................................
v1 = 1.; v2 = 1.5;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1300 500],'units','inches');
plot(FileDayFill,FileDayGRRIcomposite)
set(gca,'YTick',v3,'YLim',[v1 v2],'FontSize',14);      xtickangle(0);
ylabel ({'GRRI_{normalized}'});     grid on;

% .....................................................................
header = [num2str(floor(length(FileDayGRRIcomposite)./365)) ' 365 ' num2str(roiLength) ];
writematrix (FileDayGRRIcomposite',[FolderCHOnat01 'timesat' slash 'tabletimesatGRRI.txt'],'Delimiter','tab');
S = fileread([FolderCHOnat01 'timesat' slash 'tabletimesatGRRI.txt']);
S = [header, newline, S];
fid = fopen([FolderCHOnat01 'timesat' slash 'tabletimesatGRRI.txt'], 'w');
if fid == -1, error('Cannot open file %s', FileName); end
fwrite(fid, S, 'char');
fclose(fid);

%  ........................................................................
%% GCC
%  ........................................................................
dayGCCroi = NaN(length(FileDay),width(TableGCCroiAvgAll));
figure('color','white');
for ix = 1:width(TableGCCroiAvgAll)
    iy = TableGCCroiAvgAll(:,ix);
    iw = smoothdata(iy);    iw(isnan(iy)) = NaN;    iy = iw;
    plot(FileDateAll,iy);   hold on;
    [im,~,iz]      = AM_day(iw,FileDateAll,1);     im(iz<2) = NaN;
    dayGCCroi(:,ix) = im;
end
ind0 = (datetime(Yday(1),1,1):1:datetime(Yday(1),Mday(1),Dday(1)-1))';
indX = (datetime(Yday(end),Mday(end),Dday(end)+1):1:datetime(Yday(end),12,31))';
FileDayFill = [ind0;FileDay;indX];
roiLength = width(TableGCCroiAvgAll);
FileDayGCCcomposite = [NaN(length(ind0),roiLength);dayGCCroi;NaN(length(indX),roiLength)];
FileDayGCCcomposite = [NaN(length(ind0),roiLength);dayGCCroi;NaN(length(indX),roiLength)];
FlagFillTimesat = [ones(length(ind0),roiLength);(dayGCCroi.*0);ones(length(indX),roiLength)];

%  ........................................................................
%% GCC
%  ........................................................................
dayGCCroi = NaN(length(FileDay),width(TableGCCroiAvgAll));
figure('color','white');
for ix = 1:width(TableGCCroiAvgAll)
    iy = TableGCCroiAvgAll(:,ix);
    iw = smoothdata(iy);    iw(isnan(iy)) = NaN;    iy = iw;
    plot(FileDateAll,iy);   hold on;
    [im,~,iz]      = AM_day(iw,FileDateAll,1);     im(iz<2) = NaN;
    dayGCCroi(:,ix) = im;
end
ind0 = (datetime(Yday(1),1,1):1:datetime(Yday(1),Mday(1),Dday(1)-1))';
indX = (datetime(Yday(end),Mday(end),Dday(end)+1):1:datetime(Yday(end),12,31))';
FileDayFill = [ind0;FileDay;indX];
roiLength = width(TableGCCroiAvgAll);
FileDayGCCcomposite = [NaN(length(ind0),roiLength);dayGCCroi;NaN(length(indX),roiLength)];
FileDayGCCcomposite = [NaN(length(ind0),roiLength);dayGCCroi;NaN(length(indX),roiLength)];
FlagFillTimesat = [ones(length(ind0),roiLength);(dayGCCroi.*0);ones(length(indX),roiLength)];

%% .................................................................
for ix = 1:roiLength
    %             dayGCCroi(:,ix) = AM_fill_plus(dayGCCroi(:,ix));
    iy = FileDayGCCcomposite(:,ix);
    iw = AM_fill_day_avg(iy,FileDayFill);
    FileDayGCCcomposite(:,ix) = iw;
    figure; hold on;   plot(FileDayFill,iw); 
    plot(FileDayFill,iy)
    close
end

%% .....................................................................
header = [num2str(floor(length(FileDayGCCcomposite)./365)) ' 365 ' num2str(roiLength) ];
formattedData = compose("%.4f", FileDayGCCcomposite');
writematrix (formattedData,[FolderCHOnat01 'timesat' slash 'tabletimesatGCC.txt'],'Delimiter','tab');
S = fileread([FolderCHOnat01 'timesat' slash 'tabletimesatGCC.txt']);
S = [header, newline, S];
fid = fopen([FolderCHOnat01 'timesat' slash 'tabletimesatGCC.txt'], 'w');
if fid == -1, error('Cannot open file %s', FileName); end
fwrite(fid, S, 'char');
fclose(fid);
%   