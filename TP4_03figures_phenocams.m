% Water and carbon manuscript
% Natalia Restrepo-Coupe
%..........................................................................
%..........................................................................
% Seasonal figures/home/ncoupe/tapajos/process.u.az
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;
FolderName = '/home/ncoupe/Documents/Fluxnet/';
load('matlabTP4.mat');

% ........................................................................
%% Site
% ........................................................................
[site_name_FN, lat_FN, lon_FN, site_long_FN, year_ini_FN, year_end_FN, siteelevation_FN, height_FN, ust_tresh_FN, sunrise_FN, sunset_FN, utm_FN, ust_min_FN, ust_max_FN, tree_height_FN, LAI, Biome_FN] =...
    textread([FolderName 'sites_loc.txt'], '%s	%f	%f	%s	%f	%f	%f %f	%f	%f	%f	%f	%f	%f	%f  %f %f',...
    'headerlines',1);

ip = 12;
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
all_yearENSO_dateloc = [(datetime(2015,1,dateloc_avg));(datetime(2016,1,dateloc_avg))];

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
[TP4.monthY,TP4.monthM,TP4.monthD]= datevec(TP4.month);
% year_tick = unique(TP4.monthY);  year_tick = [year_tick;(year_tick(end)+1)];
% all_year_tick = (datetime(year_tick(1:4:end),1,1))';
[TP4.weekY,TP4.weekM,TP4.weekD]= datevec(TP4.week);

% .........................................................................
%% Figures
% .........................................................................
numberY = (max(TP4.weekY)-min(TP4.weekY))+3;
v1 = 0;         v2 = 30;      v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/numberY):v2;
figure('color','white');
subplot(3,1,1);               hold on;
% x4=0.*month_avg;            x4((TP4.month_avgTRMM<105))=(v2);
% hl1 = bar(month_avg+15,x4,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.9 0.9 0.9]);
% hl2 = bar(month_avg+15,-x4,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.9 0.9 0.9]);
y = [TP4.week_avgGEPday-TP4.week_avgstdGEPday,2.*TP4.week_avgstdGEPday];
h = area(week_avg,y);             %set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);
set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
ik = TP4.weekY(1);   count=1;     color_jet = lines(numberY);
while ik<TP4.weekY(end)
    hl1  =  plot(week_avg,TP4.weekGEPday(TP4.weekY == ik),'s','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    hl2  =  plot(week_avg,smoothdata(TP4.weekGEPday(TP4.weekY == ik),'movmean',3),'LineWidth',1,'Color',color_jet(count,:)); hold on;
    ik = ik+1;         count = count+1;
    plot(week_avg(2),v4(count+2),'.','MarkerSize',14,'color',color_jet(count,:));
    text (week_avg(2)+4,v4(count+2),num2str(ik),'FontSize',8);
end
hl1 = plot(week_avg,TP4.week_avgGEPday,'Color',[0 0 0],'LineStyle','-','LineWidth',2);
% hl7 = plot(week_avg,TP4.weekGEPday(TP4.HY_weekY == 2002),'s','Color',color_mtx_dark(1,:),'MarkerFaceColor',color_mtx(1,:),'MarkerSize',8);
% hl7 = plot(week_avg,TP4.weekGEPday(TP4.HY_weekY == 2002),'Color',color_mtx(1,:),'LineWidth',2);
% hl4 = plot(week_avg,TP4.weekGEPday(TP4.HY_weekY == 2015),'s','Color',color_mtx_dark(2,:),'MarkerFaceColor',color_mtx(2,:),'MarkerSize',8);
% hl4 = plot(week_avg,TP4.weekGEPday(TP4.HY_weekY == 2015),'Color',color_mtx(2,:),'LineWidth',2);    xlim([week_avg(1) 365]);    ylim([v1 v2]);
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
% y = [TP4.day_recurrentGEPday-TP4.day_recurrent_stdGEPday,2.*TP4.day_recurrent_stdGEPday];
% h = area(TP4.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(TP4.daydate,TP4.dayGEPday,'LineWidth',1,'color',[0.74,0.45, 0.0 ]); hold on;
% hl1 = plot(TP4.daydate,TP4.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(TP4.daydate,TP4.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(TP4.daydate,zeros(length(TP4.daydate),1)+mean(TP4.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TP4.month(1:6:end);
set(ax2,'XTick',TP4.month(1:24:end),'XTickLabel',datestr(TP4.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[TP4.daydate(1) TP4.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(TP4.month(12),v3(2),site_name,'FontSize',16);


%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [TP4.day_recurrentGEPday-TP4.day_recurrent_stdGEPday,2.*TP4.day_recurrent_stdGEPday];
% h = area(TP4.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(TP4.daydate,TP4.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl1 = plot(TP4.daydate,TP4.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(TP4.daydate,TP4.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(TP4.daydate,zeros(length(TP4.daydate),1)+mean(TP4.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TP4.month(1:6:end);
set(ax2,'XTick',TP4.month(1:24:end),'XTickLabel',datestr(TP4.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[TP4.daydate(1) TP4.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(TP4.month(12),v3(2),site_name,'FontSize',16);

w1 = 0.28;                      w2 = 0.38;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(ROI.daydate,ROI.gcc_mean,'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(ROI.daydate,smoothdata(ROI.gcc_mean,'movmean',3),'-','Color',color_mtx_dark(3,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TP4.month(1) TP4.month(end)],'YTickLabel',w3,...
    'XTick',TP4.month(1:24:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(3,:); ax2.YAxis(2).Color = color_mtx_dark(3,:);
ylabel ('GCC_{phenocam}','FontSize',16,'color',color_mtx_dark(3,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(TP4.daydate(20),25,site_name,'FontSize',16)

%%
v1 = 0;                         v2 = 440;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% ix = find(TP4.monthTRMM<100);    iy = ones(length(TP4.month),1);	iy = iy.*v1;
% iz = iy;                        iz(ix) = (v2+v1);
% y  = [iy,iz];
% h  = bar(TP4.month',y, 'BarWidth', 4);          set(gca,'Layer','top');
% set(h(2),'FaceColor',[.9 .9 .9],'EdgeColor',[.9 .9 .9]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',v1);          hold on;
hold on;
hl2 = plot(TP4.daydate,TP4.day_recurrentnetradday,'LineWidth',1,'color',[0.6 0. 0.0 ]); hold on;
hl1 = plot(TP4.daydate,TP4.daynetradday,'LineWidth',1,'color',[0.4 0.4 0.8]); hold on;
hl3 = plot(TP4.daydate,(TP4.daynetradday.*0)+mean(TP4.daynetradday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hold on;         ax2 = gca;         set(ax2,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';         ax2.XAxis.MinorTickValues = TP4.daydate(1:90:end);
set(ax2,'XTick',TP4.month(1:36:end),'XTickLabel',datestr(TP4.month(1:36:end),'yyyy'),'YTick',v3,...
    'XLim',[TP4.daydate(1) TP4.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('Net Radiation_{daytime} (W m^-^2)','FontSize',16);   xtickangle(0);

%%
yearSelect = 2015;
ind = find(TP4.dayY==yearSelect);
v1 = 0;                         v2 = 30;       v3 = v1:((v2-v1)/4):v2;
w1 = 0.2;                         w2 = .6;       w3 = w1:((w2-w1)/4):w2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [TP4.day_recurrentGEPday(ind)-TP4.day_recurrent_stdGEPday(ind),2.*TP4.day_recurrent_stdGEPday(ind)];
h = area(TP4.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
hold on;
hl2 = plot(TP4.daydate(ind),TP4.day_recurrentGEPday(ind),'LineWidth',1,'color',[0. 0. 0.6 ]); hold on;
hl1 = plot(TP4.daydate(ind),TP4.dayGEPday(ind),'LineWidth',0.8,'color',[0.4 0.4 0.4]); hold on; alpha = 0.3;
hl3 = plot(TP4.daydate(ind),(TP4.dayGEPday(ind).*0)+mean(TP4.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;

ind = find((TP4.dayGEPday>(TP4.day_recurrentGEPday+(2.*TP4.day_recurrent_stdGEPday))));
scatter(TP4.daydate(ind),TP4.dayGEPday(ind),'MarkerFaceColor',[0.2 0.2 0.6],'MarkerEdgeColor',[0.28 0.28 0.28],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TP4.dayY==yearSelect);
hold on;         ax2 = gca;       set(ax2,'YColor','k');
ax2.XAxis.MinorTick = 'on';       ax2.XAxis.MinorTickValues = datetime(yearSelect,1:1:12,1);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'FontSize',16,'XMinorGrid','on','XTick',datetime(yearSelect,1:2:12,1)');    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',TP4.month(1:36:end),'XTickLabel',datestr(TP4.month(1:36:end),'yyyy')
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;

yyaxis right;
ind = find(TP4.eightY==yearSelect);
scatter(TP4.eight(ind),TP4.eightEVI(ind), 'o', 'filled', 'MarkerFaceAlpha', 0.7,...
    'MarkerEdgeColor', color_mtx_dark(7,:),'MarkerFaceColor', color_mtx_dark(7,:));
plot(TP4.eight(ind),smoothdata(TP4.eightEVI(ind),'movmean',3),'-','LineWidth',2,'Color',color_mtx_dark(7,:));
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'XTick',(datetime(yearSelect,1:2:12,1)'));  ax2.YColor = color_mtx_dark(7,:);%'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('EVI','FontSize',16,'color',color_mtx_dark(7,:));   xtickangle(0);   box on;
text(TP4.daydate(ind(20)),250,site_name,'FontSize',16);

%%
yearSelect = 2015;
ind = find(TP4.dayY==yearSelect);
v1 = 0;                         v2 = 24;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [TP4.day_recurrentGEPday(ind)-TP4.day_recurrent_stdGEPday(ind),2.*TP4.day_recurrent_stdGEPday(ind)];
h = area(TP4.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(TP4.daydate(ind),TP4.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(TP4.daydate(ind),TP4.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(TP4.daydate(ind),(TP4.dayGEPday(ind).*0)+mean(TP4.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(TP4.daydate(ind),TP4.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayGrowth>(TP4.day_recurrentGEPdayGoley+(2.*TP4.day_recurrent_stdGEPday))));
hl5 = scatter(TP4.daydate(ind),TP4.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

hl6 = scatter(TP4.daydate(ind),TP4.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TP4.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TP4.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TP4.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

% pause(2)
w1 = 0.3;                      w2 = .38;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
ind = find(TP4.dayY==yearSelect);
scatter(TP4.daydate(ind),TP4.ROIgcc(ind),'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(4,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(TP4.daydate(ind),smoothdata(TP4.ROIgcc(ind),'movmean',3),'-','Color',color_mtx_dark(4,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',TP4.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(4,:); ax2.YAxis(2).Color = color_mtx_dark(4,:);
ylabel ('GCC_{phenocam}','FontSize',16,'color',color_mtx_dark(4,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(TP4.daydate(ind(20)),25,site_name,'FontSize',16)

%%
yearSelect = 2015;
ind = find(TP4.dayY==yearSelect);
v1 = 0;                         v2 = 24;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [TP4.day_recurrentGEPday(ind)-TP4.day_recurrent_stdGEPday(ind),2.*TP4.day_recurrent_stdGEPday(ind)];
h = area(TP4.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(TP4.daydate(ind),TP4.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(TP4.daydate(ind),TP4.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(TP4.daydate(ind),(TP4.dayGEPday(ind).*0)+mean(TP4.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(TP4.daydate(ind),TP4.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

% ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayGrowth>(TP4.day_recurrentGEPdayGoley+(2.*TP4.day_recurrent_stdGEPday))));
% hl5 = scatter(TP4.daydate(ind),TP4.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
%
% hl6 = scatter(TP4.daydate(ind),TP4.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TP4.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TP4.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TP4.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

% pause(2)
w1 = 0.36;                      w2 = .44;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
ind = find(TP4.dayY==yearSelect);
scatter(TP4.daydate(ind),TP4.ROIrcc(ind),'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(4,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(TP4.daydate(ind),smoothdata(TP4.ROIrcc(ind),'movmean',3),'-','Color',color_mtx_dark(4,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',TP4.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(4,:); ax2.YAxis(2).Color = color_mtx_dark(4,:);
ylabel ('RCC_{phenocam}','FontSize',16,'color',color_mtx_dark(4,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(TP4.daydate(ind(20)),25,site_name,'FontSize',16)

%%
numberY = TP4.Y(end) -TP4.Y(1);
v1 = 0;         v2 = 32;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/numberY):v2;
x1 = 0.3;       x2 = .38;         x3 = x1:((x2-x1)/4):x2;     x4 = x1:((x2-x1)/numberY):x2;
figure('color','white');          hold on;
ik = ROI.dayY(1);                 count=1;     color_jet = jet(max(TP4.dayY)-min(ROI.dayY)+1);
while ik<TP4.dayY(end)
    scatter(TP4.ROIgcc(TP4.dayY == ik),TP4.dayGEPdayGrowthGoley(TP4.dayY == ik),'o','MarkerFaceColor',color_jet(count,:),...
        'MarkerEdgeColor',color_jet(count,:), 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5); hold on;
    AM_compute_regression(TP4.ROIgcc(TP4.dayY == ik),TP4.dayGEPdayGrowthGoley(TP4.dayY == ik),color_jet(count,:),1);
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
yearSelect = 2019;
ind = find(TP4.dayY==yearSelect);
v1 = 0;                         v2 = 16;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [TP4.day_recurrentGEP(ind)-TP4.day_recurrent_stdGEP(ind),2.*TP4.day_recurrent_stdGEP(ind)];
h = area(TP4.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(TP4.daydate(ind),TP4.day_recurrentGEPGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(TP4.daydate(ind),TP4.dayGEP(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(TP4.daydate(ind),(TP4.dayGEP(ind).*0)+mean(TP4.dayGEP,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(TP4.daydate(ind),TP4.dayGEPgrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPgrowth>(TP4.day_recurrentGEPGoley+(2.*TP4.day_recurrent_stdGEP))));
hl5 = scatter(TP4.daydate(ind),TP4.dayGEP(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TP4.dayGEPARIMAzvalueResidual,'omitnan');
% iy = std(TP4.dayGEPARIMAzvalueResidual,'omitnan');
% ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPARIMAzvalueResidualGrowth>thresholdARIMA)&(TP4.dayGEPGrowth>TP4.day_recurrentGEPGoley));
% zvalue value-mu/std
% ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(TP4.dayGEPGrowth>TP4.day_recurrentGEPGoley));
hl6 = scatter(TP4.daydate(ind),TP4.dayGEP(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TP4.dayGEPHURSTzvalue,'omitnan');
% iy = std(TP4.dayGEPHURSTzvalue,'omitnan');
% % ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPHURST>(ix+(1.5.*iy))));
% ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPHURSTzvalue<0.5)&(TP4.dayGEPGrowth>TP4.day_recurrentGEPGoley));
% hl7 = scatter(TP4.daydate(ind),TP4.dayGEP(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TP4.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TP4.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TP4.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

w1 = 0;                      w2 = 16;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(TP4.daydate(ind),TP4.dayRECO(ind),'o','MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(TP4.daydate(ind),smoothdata(TP4.dayRECO(ind),'movmean',3),'-','Color',color_mtx_dark(1,:),'Linewidth',2);

% % ind = find((TP4.dayY==yearSelect)&(TP4.dayRECOGrowth>(TP4.day_recurrentRECOGoley+(2.*TP4.day_recurrent_stdRECO))));
% % hl5 = scatter(TP4.daydate(ind),TP4.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % ind = find((TP4.dayY==yearSelect)&(TP4.dayRECOARIMAzvalueResidual>thresholdARIMAzvalue)&...
% %     (TP4.dayRECOGrowth>TP4.day_recurrentRECOGoley));
% % hl6 = scatter(TP4.daydate(ind),TP4.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % ix = mean(TP4.dayRECOHURSTzvalue,'omitnan');
% % iy = std(TP4.dayRECOHURSTzvalue,'omitnan');
% % ind = find((TP4.dayY==yearSelect)&(TP4.dayRECOHURSTzvalue<0.5)&(TP4.dayRECOGrowth>TP4.day_recurrentRECOGoley));
% % hl7 = scatter(TP4.daydate(ind),TP4.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TP4.dayY==yearSelect);
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',TP4.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(2,:); ax2.YAxis(2).Color = color_mtx_dark(1,:);
ylabel ('respiration (gC m^-^2 d^-^1)','FontSize',16,'color',color_mtx_dark(1,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(TP4.daydate(ind(20)),25,site_name,'FontSize',16)

%%
yearSelect = 2019;
ind = find(TP4.dayY==yearSelect);
v1 = 0;                         v2 = 36;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [TP4.day_recurrentGEPday(ind)-TP4.day_recurrent_stdGEPday(ind),2.*TP4.day_recurrent_stdGEPday(ind)];
h = area(TP4.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(TP4.daydate(ind),TP4.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(TP4.daydate(ind),TP4.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(TP4.daydate(ind),(TP4.dayGEPday(ind).*0)+mean(TP4.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(TP4.daydate(ind),TP4.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayGrowth>(TP4.day_recurrentGEPdayGoley+(2.*TP4.day_recurrent_stdGEPday))));
hl5 = scatter(TP4.daydate(ind),TP4.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TP4.dayGEPdayARIMAzvalueResidual,'omitnan');
% iy = std(TP4.dayGEPdayARIMAzvalueResidual,'omitnan');
% ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMA)&(TP4.dayGEPdayGrowth>TP4.day_recurrentGEPdayGoley));
% zvalue value-mu/std
% ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(TP4.dayGEPdayGrowth>TP4.day_recurrentGEPdayGoley));
hl6 = scatter(TP4.daydate(ind),TP4.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TP4.dayGEPdayHURSTzvalue,'omitnan');
% iy = std(TP4.dayGEPdayHURSTzvalue,'omitnan');
% % ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayHURST>(ix+(1.5.*iy))));
% ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayHURSTzvalue<0.5)&(TP4.dayGEPdayGrowth>TP4.day_recurrentGEPdayGoley));
% hl7 = scatter(TP4.daydate(ind),TP4.dayGEPday(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TP4.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TP4.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TP4.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',TP4.month(1:36:end),'XTickLabel',datestr(TP4.month(1:36:end),'yyyy')
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
% text(TP4.daydate(ind(20)),250,site_name,'FontSize',16)

w1 = 0.;                      w2 = .42;       w3 = w1:((.4-w1)/4):.4;
yyaxis right;
% scatter(TP4.daydate(ind),TP4.dayEVI(ind),'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
%     'MarkerFaceAlpha',.7,'MarkerEdgeAlpha',.7);
% plot(TP4.daydate(ind),smoothdata(TP4.dayEVI(ind),'movmean',3),'-','Color',color_mtx_dark(4,:),'Linewidth',2);
ind = find(TP4.eightY==yearSelect);
scatter(TP4.eight(ind),TP4.eightEVI(ind), 'o', 'filled', 'MarkerFaceAlpha', 0.7, 'MarkerEdgeColor', color_mtx_dark(5,:),...
    'MarkerFaceColor', color_mtx_dark(5,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(TP4.eight(ind),(TP4.eightEVI(ind)),'-','LineWidth',2,'Color',color_mtx_dark(5,:));
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'YTickLabel',w3,'XTick',(datetime(yearSelect,1:2:12,1)'));    %'XTickLabelColor',[0. 0. 0.7 ]
% ind = find(TP4.dayY==yearSelect);
% set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],'YTickLabel',w3,...
%     'XTick',TP4.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(2,:); ax2.YAxis(2).Color = color_mtx_dark(5,:);
ylabel ('EVI','FontSize',16,'color',color_mtx_dark(5,:));   xtickangle(0);   box on;
text(TP4.daydate(ind(20)),25,site_name,'FontSize',16)

%% hourly
% .....................................................................................
% close all;
cla;
indSelect = find((TP4.dateloc>=datetime(2019,6,24))&(TP4.dateloc<=datetime(2019,7,3)));
v1 = 0;                         v2 = 20;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 800],'units','inches');
subplot(2,1,1);
yyaxis left;
y = [TP4.recurrentET(indSelect)-TP4.recurrent_stdET(indSelect),2.*TP4.recurrent_stdET(indSelect)];
hl1 = area(days(TP4.dateloc(indSelect)-TP4.dateloc(indSelect(1))),y);
set(hl1(2),'FaceColor',[.8 .8 .9],'EdgeColor',[.8 .8 .9],'FaceAlpha',.5);
set(hl1(1),'FaceColor','none','EdgeColor','none');
set(hl1,'BaseValue',0);
hl2 = plot(TP4.dateloc(indSelect),TP4.PET(indSelect),'-','LineWidth',1,'color',[0.07,0.44,0.75]); hold on;
% set(gca,'YColor',[0.9 0.6 0.2]);
hold on;
% cla(gca, 'reset');
ax1 = gca;       %set(ax1,'YColor',[0.4 0.4 0.8]);
set(ax1,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.dateloc(indSelect(1)) TP4.dateloc(indSelect(end))],...
    'FontSize',16);%,'XTick',TP4.dateloc(indSelect(1:24:end)));
ylabel ('PET (mm s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

yyaxis right;
y = [TP4.recurrentET(indSelect)-TP4.recurrent_stdET(indSelect),2.*TP4.recurrent_stdET(indSelect)];
hl3 = area(days(TP4.dateloc(indSelect)-TP4.dateloc(indSelect(1))),y);       set(gca,'Layer','top');
set(hl3(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'FaceAlpha',.5);
set(hl3(1),'FaceColor','none','EdgeColor','none');
set(hl3,'BaseValue',0);
% set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.dateloc(ind(1)) TP4.dateloc(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl4 = plot(TP4.dateloc(indSelect),TP4.recurrentET(indSelect),'-','LineWidth',2,'color',[0.6 0.6 0.6 ]); hold on;
hl5 = plot(TP4.dateloc(indSelect),TP4.ET(indSelect),'-','LineWidth',2,'color',[0.9 0.6 0.2]); hold on;
% hl6 = plot(TP4.dateloc(indSelect),(TP4.ET(indSelect).*0)+mean(TP4.dayETday,'omitnan'),'--','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;

ax2 = gca;                     set(ax2,'YColor',[0.9 0.6 0.2]);
ax2.XAxis.MinorTick = 'on';    ax2.XAxis.MinorTickValues = TP4.daydate(1:1:end);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.dateloc(indSelect(1)) TP4.dateloc(indSelect(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TP4.dateloc(indSelect(1:48:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',TP4.month(1:36:end),'XTickLabel',datestr(TP4.month(1:36:end),'yyyy')
ylabel ('ET (mm s^-^1)','FontSize',16);  box on;   grid on;
text(TP4.dateloc(indSelect(20)),18,site_name,'FontSize',16)

% cla;
subplot(2,1,2);     hold on;
v1 = 0.42;           v2 = .46;       v3 = v1:((v2-v1)/4):v2;
indSelect = find((TP4.daydate>=datetime(2019,6,24))&(TP4.daydate<=datetime(2019,7,3)));
% yyaxis left;
y = [TP4.day_recurrentROIgcc(indSelect)-TP4.day_recurrent_stdROIgcc(indSelect),2.*TP4.day_recurrent_stdROIgcc(indSelect)];
h = area(TP4.daydate(indSelect),y);
% set(h,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'FaceAlpha',.5);
set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);          hold on;
hl1 = plot(TP4.daydate(indSelect),TP4.day_recurrentROIgcc(indSelect),'-k');
hl2 = scatter(TP4.daydate(indSelect),TP4.ROIgcc(indSelect),'.','MarkerFaceColor',[0.87 0.33 0.],'MarkerEdgeColor',[0.87 0.33 0.],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
hl3 = plot(TP4.daydate(indSelect),(TP4.ROIgcc(indSelect)),'-','Color',[0.87 0.33 0.]);
% cla;
ax1 = gca;                      set(ax1,'YColor',[0.9 0.6 0.2]);
ax1.XAxis.MinorTick = 'on';     ax1.XAxis.MinorTickValues = TP4.daydate(1:1:end);
set(ax1,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.daydate(indSelect(1)) TP4.daydate(indSelect(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TP4.daydate(indSelect(1:2:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GCC_{phenocam}','FontSize',16);
grid on;          box on;

% w1 = 0.29;                      w2 = .49;       w3 = w1:((w2-w1)/4):w2;
% yyaxis right;
% scatter(TP4.dateloc(ind),TP4.dayROIgcc(ind),'.','MarkerFaceColor',[0.87 0.33 0.],'MarkerEdgeColor',[0.87 0.33 0.],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% plot(TP4.dateloc(ind),smoothdata(TP4.dayROIgcc(ind),'movmean',3),'-','Color',[0.87 0.33 0.]);
%
% ind = find((TP4.dayY==yearSelect)&(TP4.dayROIgccGrowth>(TP4.day_recurrentROIgccGoley+(2.*TP4.day_recurrent_stdROIgcc))));
% hl5 = scatter(TP4.dateloc(ind),TP4.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% ind = find((TP4.dayY==yearSelect)&(TP4.dayROIgccARIMAzvalueResidual>thresholdARIMAzvalue)&...
%     (TP4.dayROIgccGrowth>TP4.day_recurrentROIgccGoley));
% hl6 = scatter(TP4.dateloc(ind),TP4.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% ix = mean(TP4.dayROIgccHURSTzvalue,'omitnan');
% iy = std(H,'YTickLabel',w3a1.dayROIgccHURSTzvalue,'omitnan');
% ind = find((TP4.dayY==yearSelect)&(TP4.dayROIgccHURSTzvalue<0.5)&(TP4.dayROIgccGrowth>TP4.day_recurrentROIgccGoley));
% hl7 = scatter(TP4.dateloc(ind),TP4.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
ax2 =gca;
% ind = find(TP4.dayY==yearSelect);
% set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.dateloc(indSelect(1)) TP4.dateloc(indSelect(end))],...
%     'YTickLabel',v3,'XTick',TP4.dateloc(indSelect(1:2:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
% ylabel ('GCC_{phenocam}','FontSize',16,'color',[0.87 0.33 0.]);   xtickangle(0);   box on;
% % legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5'); legend box off;


% .....................................................................................
%% deseasonalized  TP4.dayGEPday_zscore   dayGEPday_deseasoned
% .....................................................................................
yearSelect = 2019;
ind = find(TP4.dayY==yearSelect);
v1 = -10;                         v2 = 10;       v3 = v1:((v2-v1)/4):v2;
w1 = 0.34;                         w2 = .5;       w3 = w1:((w2-w1)/4):w2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
% y = [TP4.day_recurrentGEPday(ind)-TP4.day_recurrent_stdGEPday(ind),2.*TP4.day_recurrent_stdGEPday(ind)];
% h = area(TP4.daydate(ind),y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
% hl2 = plot(TP4.daydate(ind),TP4.day_recurrentGEPdayGoley(ind),'LineWidth',1,'color',[0. 0.6 0.6 ]); hold on;
hl1 = plot(TP4.daydate(ind),TP4.dayGEPday_zscore(ind),'LineWidth',0.8,'color',[0.5 0.5 0.5]); hold on; alpha = 0.3;
hl3 = plot(TP4.daydate(ind),(TP4.dayGEPday_zscore(ind).*0)+mean(TP4.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
% hl4 = plot(TP4.daydate(ind),TP4.dayGEPdayGrowth(ind),'LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayGrowth>(TP4.day_recurrentGEPdayGoley+(2.*TP4.day_recurrent_stdGEPday))));
hl5 = scatter(TP4.daydate(ind),TP4.dayGEPday_zscore(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TP4.dayGEPdayARIMAzvalueResidual,'omitnan');
% iy = std(TP4.dayGEPdayARIMAzvalueResidual,'omitnan');
% ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMA)&(TP4.dayGEPdayGrowth>TP4.day_recurrentGEPdayGoley));
% zvalue value-mu/std
% ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(TP4.dayGEPdayGrowth>TP4.day_recurrentGEPdayGoley));
hl6 = scatter(TP4.daydate(ind),TP4.dayGEPday_zscore(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TP4.dayGEPdayHURSTzvalue,'omitnan');
% iy = std(TP4.dayGEPdayHURSTzvalue,'omitnan');
% % ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayHURST>(ix+(1.5.*iy))));
% ind = find((TP4.dayY==yearSelect)&(TP4.dayGEPdayHURSTzvalue<0.5)&(TP4.dayGEPdayGrowth>TP4.day_recurrentGEPdayGoley));
% hl7 = scatter(TP4.daydate(ind),TP4.dayGEPday_zscore(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TP4.dayY==yearSelect);
hold on;           ax2 = gca;         set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TP4.daydate(1:90:end);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',TP4.month(1:36:end),'XTickLabel',datestr(TP4.month(1:36:end),'yyyy')
ylabel ('LE_{daytime} (W m^-^2)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(TP4.daydate(ind(20)),250,site_name,'FontSize',16)

yyaxis right;
scatter(TP4.daydate(ind),TP4.ROIgcc(ind),'.','MarkerFaceColor',[0.5 0.2 0.2],'MarkerEdgeColor',[0.6 0.1 0.1],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(TP4.daydate(ind),TP4.ROIgcc(ind),'-','Color',[0.6 0.1 0.1]);
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TP4.daydate(ind(1)) TP4.daydate(ind(end))],'YTickLabel',['']);    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GCC_{phenocam}','FontSize',16,'color',[0.6 0.2 0.2]);   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;

%%
order = 5;   framelen = 9;
yearSelect = 2022;
ind = find(TP4.dayY==yearSelect);

z1 = 0;             z2 = 26;       z3 = ((z2-z1)/6);       z4 = z1:3*z3:z2;    z5 = z1:z3:z2;
y1 = -100;          y2 = 700;      y3 = ((y2-y1)/6);       y4 = y1:3*y3:y2;    y5 = y1:y3:y2;

x1 = TP4.daydate(ind);
x2 = TP4.daydate(ind);

y1 = TP4.ROIgcc(ind);     GCCgolay = sgolayfilt(TP4.ROIgcc(ind),order,framelen);
GCCgolay = smoothdata(TP4.ROIgcc(ind),'movmean',3);
y8 = GCCgolay;

y3 = TP4.dayGEPday(ind);
y4 = TP4.dayGEPday(ind);  GEPgolay = sgolayfilt(TP4.dayGEPday(ind),order,framelen);
y9 = GEPgolay;

y5 = TP4.dayPAR(ind);     %PARgolay = sgolayfilt(TP4.dayPAR(ind),order,framelen);
PARgolay = smoothdata(TP4.dayPAR(ind),'movmean',9);
y6 = TP4.dayPAR(ind);
y10 = PARgolay;

y7 = TP4.daytair(ind);    %Tairgolay = sgolayfilt(TP4.daytair(ind),order,framelen);
Tairgolay = smoothdata(TP4.daytairday(ind),'movmean',11);
y11 = TP4.daytair(ind);
y12 = Tairgolay;

y2 = 1-TP4.ROIrcc(ind);
y2((TP4.dayM(ind)<=2)|(TP4.dayM(ind)>=11)) = NaN;
y13 = smoothdata(y2,'movmean',3);

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
% ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1), T_{air} (/circC)';
ylabels{2} = 'GCC';
ylabels{3} = 'PAR_{day} (\mumol m^-^2 s^-^1)';
yaxisval   = [-.5,22,0.3,.4,-.5,800];
% [ax,hlines] = AM_multiplotyyyGEPday2annual({x2,y1,x2,y8},{x1,y3,x1,y9,x2,y12},{x1,y10,x1,y10},ylabels,yaxisval);
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y1,x2,y8},{x1,y10,x1,y10},ylabels,yaxisval,1);
% legend(cat(1,hlines{1,:}),'GEP','GCC','PAR','location','nw')

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'RCC';
ylabels{3} = 'PAR_{day} (\mumol m^-^2 s^-^1)';
yaxisval   = [-.5,22,0.5,.65,-.5,600];
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y2,x2,y13},{x1,y10,x1,y10},ylabels,yaxisval,1);

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'GCC';
ylabels{3} = 'RCC';
yaxisval   = [-.5,22,0.3,.38,0.5,.65];
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y1,x2,y8},{x2,y2,x2,y13},ylabels,yaxisval,2);

ylabels{1} = 'GEP_{day} (gC m^-^2 d^-^1)';
ylabels{2} = 'GCC';
ylabels{3} = 'T_{air} (\circC)';
yaxisval   = [-.5,22,0.3,.38,-5,30];
[ax,hlines] = AM_multiplotyyyGEPday2annual({x1,y3,x1,y9},{x2,y1,x2,y8},{x2,y7,x2,y12},ylabels,yaxisval,3);

%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [TP4.day_recurrentGEPday-TP4.day_recurrent_stdGEPday,2.*TP4.day_recurrent_stdGEPday];
% h = area(TP4.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(TP4.daydate,TP4.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl1 = plot(TP4.daydate,TP4.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(TP4.daydate,TP4.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(TP4.daydate,zeros(length(TP4.daydate),1)+mean(TP4.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TP4.month(1:6:end);
set(ax2,'XTick',TP4.month(1:24:end),'XTickLabel',datestr(TP4.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[TP4.daydate(1) TP4.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(TP4.month(12),v3(2),site_name,'FontSize',16);

w1 = -.15;                      w2 = .1;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(ROI.daydate,ROI.GRIVI_mean,'o','MarkerFaceColor',color_mtx(5,:),'MarkerEdgeColor',color_mtx_dark(5,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(ROI.daydate,smoothdata(ROI.GRIVI_mean,'movmean',5),'-','Color',color_mtx_dark(5,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TP4.month(1) TP4.month(end)],'YTickLabel',w3,...
    'XTick',TP4.month(1:24:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(5,:); ax2.YAxis(2).Color = color_mtx_dark(5,:);
ylabel ('GRIVI_{phenocam}','FontSize',16,'color',color_mtx_dark(5,:));   xtickangle(0);   box on;
text(TP4.daydate(20),25,site_name,'FontSize',16)