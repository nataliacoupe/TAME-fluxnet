% Water and carbon manuscript
% Natalia Restrepo-Coupe
%..........................................................................
%..........................................................................
% Seasonal figures/home/ncoupe/tapajos/process.u.az
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;
FolderName = '/home/ncoupe/Documents/Fluxnet/';
load('matlabTPD.mat');

% ........................................................................
%% Site
% ........................................................................
[site_name_FN, lat_FN, lon_FN, site_long_FN, year_ini_FN, year_end_FN, siteelevation_FN, height_FN, ust_tresh_FN, sunrise_FN, sunset_FN, utm_FN, ust_min_FN, ust_max_FN, tree_height_FN, LAI, Biome_FN] =...
    textread([FolderName 'sites_loc.txt'], '%s	%f	%f	%s	%f	%f	%f %f	%f	%f	%f	%f	%f	%f	%f  %f %f',...
    'headerlines',1);

ip = 13;
lat = lat_FN(ip);             lon = lon_FN(ip);               height = height_FN(ip);  
site_name = site_name_FN(ip); ust_tresh = ust_tresh_FN(ip);   utm = utm_FN(ip);

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
[TPD.monthY,TPD.monthM,TPD.monthD]= datevec(TPD.month);
% year_tick = unique(TPD.monthY);  year_tick = [year_tick;(year_tick(end)+1)];
% all_year_tick = (datetime(year_tick(1:4:end),1,1))';
[TPD.weekY,TPD.weekM,TPD.weekD]= datevec(TPD.week);

% .........................................................................
%% Figures
% .........................................................................
numberY = (max(TPD.weekY)-min(TPD.weekY))+3;
v1 = 0;         v2 = 30;         v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/numberY):v2;
figure('color','white');
subplot(3,1,1);                   hold on;
% x4=0.*month_avg;            x4((TPD.month_avgTRMM<105))=(v2);
% hl1 = bar(month_avg+15,x4,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.9 0.9 0.9]);
% hl2 = bar(month_avg+15,-x4,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.9 0.9 0.9]);
y = [TPD.week_avgGEPday-TPD.week_avgstdGEPday,2.*TPD.week_avgstdGEPday];
h = area(week_avg,y);             %set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);
set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
ik = TPD.weekY(1);   count=1;     color_jet = lines(numberY);
while ik<TPD.weekY(end)
    hl1  =  plot(week_avg,TPD.weekGEPday(TPD.weekY == ik),'s','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    hl2  =  plot(week_avg,smoothdata(TPD.weekGEPday(TPD.weekY == ik),'movmean',5),'LineWidth',1,'Color',color_jet(count,:)); hold on;
    ik = ik+1;         count = count+1;
    plot(week_avg(2),v4(count+2),'.','MarkerSize',14,'color',color_jet(count,:));
    text (week_avg(2)+4,v4(count+2),num2str(ik),'FontSize',8);
end
hl1 = plot(week_avg,TPD.week_avgGEPday,'Color',[0 0 0],'LineStyle','-','LineWidth',2);
% hl7 = plot(week_avg,TPD.weekGEPday(TPD.HY_weekY == 2002),'s','Color',color_mtx_dark(1,:),'MarkerFaceColor',color_mtx(1,:),'MarkerSize',8);
% hl7 = plot(week_avg,TPD.weekGEPday(TPD.HY_weekY == 2002),'Color',color_mtx(1,:),'LineWidth',2);
% hl4 = plot(week_avg,TPD.weekGEPday(TPD.HY_weekY == 2015),'s','Color',color_mtx_dark(2,:),'MarkerFaceColor',color_mtx(2,:),'MarkerSize',8);
% hl4 = plot(week_avg,TPD.weekGEPday(TPD.HY_weekY == 2015),'Color',color_mtx(2,:),'LineWidth',2);    xlim([week_avg(1) 365]);    ylim([v1 v2]);
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
% y = [TPD.day_recurrentGEPday-TPD.day_recurrent_stdGEPday,2.*TPD.day_recurrent_stdGEPday];
% h = area(TPD.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(TPD.daydate,TPD.dayGEPday,'LineWidth',1,'color',[0.74,0.45, 0.0 ]); hold on;
% hl1 = plot(TPD.daydate,TPD.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(TPD.daydate,TPD.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(TPD.daydate,zeros(length(TPD.daydate),1)+mean(TPD.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month(1:6:end);
set(ax2,'XTick',TPD.month(1:24:end),'XTickLabel',datestr(TPD.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[TPD.daydate(1) TPD.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(TPD.month(12),v3(2),site_name,'FontSize',16);


%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [TPD.day_recurrentGEPday-TPD.day_recurrent_stdGEPday,2.*TPD.day_recurrent_stdGEPday];
% h = area(TPD.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(TPD.daydate,TPD.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl1 = plot(TPD.daydate,TPD.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(TPD.daydate,TPD.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(TPD.daydate,zeros(length(TPD.daydate),1)+mean(TPD.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month(1:6:end);
set(ax2,'XTick',TPD.month(1:24:end),'XTickLabel',datestr(TPD.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[TPD.daydate(1) TPD.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(TPD.month(12),v3(2),site_name,'FontSize',16);

w1 = 0.26;                      w2 = .46;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(ROI.daydate,ROI.gcc_mean,'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(ROI.daydate,smoothdata(ROI.gcc_mean,'movmean',5),'-','Color',color_mtx_dark(3,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TPD.month(1) TPD.month(end)],'YTickLabel',w3,...
    'XTick',TPD.month(1:24:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(3,:); ax2.YAxis(2).Color = color_mtx_dark(3,:);
ylabel ('GCC_{phenocam}','FontSize',16,'color',color_mtx_dark(3,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(TPD.daydate(20),25,site_name,'FontSize',16)

%%
v1 = 0;                         v2 = 440;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% ix = find(TPD.monthTRMM<100);    iy = ones(length(TPD.month),1);	iy = iy.*v1;
% iz = iy;                        iz(ix) = (v2+v1);
% y  = [iy,iz];
% h  = bar(TPD.month',y, 'BarWidth', 4);          set(gca,'Layer','top');
% set(h(2),'FaceColor',[.9 .9 .9],'EdgeColor',[.9 .9 .9]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',v1);          hold on;
hold on;
hl2 = plot(TPD.daydate,TPD.day_recurrentnetradday,'LineWidth',1,'color',[0.6 0. 0.0 ]); hold on;
hl1 = plot(TPD.daydate,TPD.daynetradday,'LineWidth',1,'color',[0.4 0.4 0.8]); hold on;
hl3 = plot(TPD.daydate,(TPD.daynetradday.*0)+mean(TPD.daynetradday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hold on;         ax2 = gca;         set(ax2,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';         ax2.XAxis.MinorTickValues = TPD.daydate(1:90:end);
set(ax2,'XTick',TPD.month(1:36:end),'XTickLabel',datestr(TPD.month(1:36:end),'yyyy'),'YTick',v3,...
    'XLim',[TPD.daydate(1) TPD.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('Net Radiation_{daytime} (W m^-^2)','FontSize',16);   xtickangle(0);

%%
yearSelect = 2019;
ind = find(TPD.dayY==yearSelect);
v1 = 0;                         v2 = 30;       v3 = v1:((v2-v1)/3):v2;
w1 = 0;                         w2 = .68;       w3 = w1:((w2-w1)/4):w2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
h = area(TPD.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
hold on;
hl2 = plot(TPD.daydate(ind),TPD.day_recurrentGEPday(ind),'LineWidth',1,'color',[0. 0. 0.6 ]); hold on;
hl1 = plot(TPD.daydate(ind),TPD.dayGEPday(ind),'LineWidth',0.8,'color',[0.4 0.4 0.4]); hold on; alpha = 0.3;
hl3 = plot(TPD.daydate(ind),(TPD.dayGEPday(ind).*0)+mean(TPD.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;

ind = find((TPD.dayGEPday>(TPD.day_recurrentGEPday+(2.*TPD.day_recurrent_stdGEPday))));
scatter(TPD.daydate(ind),TPD.dayGEPday(ind),'MarkerFaceColor',[0.2 0.2 0.6],'MarkerEdgeColor',[0.28 0.28 0.28],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TPD.dayY==yearSelect);
hold on;         ax2 = gca;       set(ax2,'YColor','k');
ax2.XAxis.MinorTick = 'on';       ax2.XAxis.MinorTickValues = datetime(yearSelect,1:1:12,1);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'FontSize',16,'XMinorGrid','on','XTick',datetime(yearSelect,1:2:12,1)');    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',TPD.month(1:36:end),'XTickLabel',datestr(TPD.month(1:36:end),'yyyy')
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;

yyaxis right;
ind = find(TPD.eightY==yearSelect);
scatter(TPD.eight(ind),TPD.eightEVI(ind), 'o', 'filled', 'MarkerFaceAlpha', 0.7,...
    'MarkerEdgeColor', color_mtx_dark(7,:),'MarkerFaceColor', color_mtx_dark(7,:));
plot(TPD.eight(ind),smoothdata(TPD.eightEVI(ind),'movmean',5),'-','LineWidth',2,'Color',color_mtx_dark(7,:));
set(ax2,'YTick',w3,'YTickLabel',w3,'YLim',[w1 w2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'XTick',(datetime(yearSelect,1:2:12,1)'));  
ax2.YColor = color_mtx_dark(7,:);%'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('EVI','FontSize',16,'color',color_mtx_dark(7,:));   xtickangle(0);   box on;
text(TPD.daydate(ind(20)),250,site_name,'FontSize',16);

%%
yearSelect = 2015;
ind = find(TPD.dayY==yearSelect);
v1 = 0;                         v2 = 28;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
h = area(TPD.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(TPD.daydate(ind),TPD.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
hl1 = plot(TPD.daydate(ind),TPD.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(TPD.daydate(ind),(TPD.dayGEPday(ind).*0)+mean(TPD.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(TPD.daydate(ind),TPD.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayGrowth>(TPD.day_recurrentGEPdayGoley+(2.*TPD.day_recurrent_stdGEPday))));
hl5 = scatter(TPD.daydate(ind),TPD.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

hl6 = scatter(TPD.daydate(ind),TPD.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TPD.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

% pause(2)
w1 = 0.30;                      w2 = .42;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
ind = find(TPD.dayY==yearSelect);
scatter(TPD.daydate(ind),TPD.ROIgcc(ind),'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(TPD.daydate(ind),smoothdata(TPD.ROIgcc(ind),'movmean',5),'-','Color',color_mtx_dark(3,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',TPD.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(3,:); ax2.YAxis(2).Color = color_mtx_dark(3,:);
ylabel ('GCC_{phenocam}','FontSize',16,'color',color_mtx_dark(3,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)

%%
yearSelect = 2015;
ind = find(TPD.dayY==yearSelect);
v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
h = area(TPD.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(TPD.daydate(ind),TPD.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
hl1 = plot(TPD.daydate(ind),TPD.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(TPD.daydate(ind),(TPD.dayGEPday(ind).*0)+mean(TPD.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(TPD.daydate(ind),TPD.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayGrowth>(TPD.day_recurrentGEPdayGoley+(2.*TPD.day_recurrent_stdGEPday))));
hl5 = scatter(TPD.daydate(ind),TPD.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

hl6 = scatter(TPD.daydate(ind),TPD.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TPD.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

% pause(2)
w1 = 0.35;                      w2 = .55;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
ind = find(TPD.dayY==yearSelect);
scatter(TPD.daydate(ind),TPD.ROIrcc(ind),'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(TPD.daydate(ind),smoothdata(TPD.ROIrcc(ind),'movmean',5),'-','Color',color_mtx_dark(3,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',TPD.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(3,:); ax2.YAxis(2).Color = color_mtx_dark(3,:);
ylabel ('RCC_{phenocam}','FontSize',16,'color',color_mtx_dark(3,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)

%%
numberY = TPD.Y(end) -TPD.Y(1);
v1 = 0;         v2 = 32;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/(numberY+2)):v2;
x1 = 0.25;      x2 = .45;         x3 = x1:((x2-x1)/4):x2;     x4 = x1:((x2-x1)/(numberY+2)):x2;
figure('color','white');          hold on;
ik = ROI.dayY(1);                 count=1;     color_jet = jet(numberY+2);
while ik<TPD.dayY(end)
    scatter(TPD.ROIgcc(TPD.dayY == ik),TPD.dayGEPdayGrowthGoley(TPD.dayY == ik),'o','MarkerFaceColor',color_jet(count,:),...
        'MarkerEdgeColor',color_jet(count,:), 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5); hold on;
    AM_compute_regression(TPD.ROIgcc(TPD.dayY == ik),TPD.dayGEPdayGrowthGoley(TPD.dayY == ik),color_jet(count,:),1);
    plot(x4(2),v4(numberY+2-count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (x4(3),v4(numberY+2-count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[x1 x2],...
    'FontSize',16,'XMinorGrid','on','XTick',x3);    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
xlabel ('GCC');

%% Respiration
yearSelect = 2020;
ind = find(TPD.dayY==yearSelect);
v1 = 0;                         v2 = 16;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [TPD.day_recurrentGEP(ind)-TPD.day_recurrent_stdGEP(ind),2.*TPD.day_recurrent_stdGEP(ind)];
h = area(TPD.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(TPD.daydate(ind),TPD.day_recurrentGEPGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(TPD.daydate(ind),TPD.dayGEP(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(TPD.daydate(ind),(TPD.dayGEP(ind).*0)+mean(TPD.dayGEP,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(TPD.daydate(ind),TPD.dayGEPgrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPgrowth>(TPD.day_recurrentGEPGoley+(2.*TPD.day_recurrent_stdGEP))));
hl5 = scatter(TPD.daydate(ind),TPD.dayGEP(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TPD.dayGEPARIMAzvalueResidual,'omitnan');
% iy = std(TPD.dayGEPARIMAzvalueResidual,'omitnan');
% ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPARIMAzvalueResidualGrowth>thresholdARIMA)&(TPD.dayGEPGrowth>TPD.day_recurrentGEPGoley));
% zvalue value-mu/std
% ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(TPD.dayGEPGrowth>TPD.day_recurrentGEPGoley));
hl6 = scatter(TPD.daydate(ind),TPD.dayGEP(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TPD.dayGEPHURSTzvalue,'omitnan');
% iy = std(TPD.dayGEPHURSTzvalue,'omitnan');
% % ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPHURST>(ix+(1.5.*iy))));
% ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPHURSTzvalue<0.5)&(TPD.dayGEPGrowth>TPD.day_recurrentGEPGoley));
% hl7 = scatter(TPD.daydate(ind),TPD.dayGEP(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TPD.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

w1 = 0;                      w2 = 16;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(TPD.daydate(ind),TPD.dayRECO(ind),'o','MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(TPD.daydate(ind),smoothdata(TPD.dayRECO(ind),'movmean',5),'-','Color',color_mtx_dark(1,:),'Linewidth',2);

% % ind = find((TPD.dayY==yearSelect)&(TPD.dayRECOGrowth>(TPD.day_recurrentRECOGoley+(2.*TPD.day_recurrent_stdRECO))));
% % hl5 = scatter(TPD.daydate(ind),TPD.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % ind = find((TPD.dayY==yearSelect)&(TPD.dayRECOARIMAzvalueResidual>thresholdARIMAzvalue)&...
% %     (TPD.dayRECOGrowth>TPD.day_recurrentRECOGoley));
% % hl6 = scatter(TPD.daydate(ind),TPD.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% % ix = mean(TPD.dayRECOHURSTzvalue,'omitnan');
% % iy = std(TPD.dayRECOHURSTzvalue,'omitnan');
% % ind = find((TPD.dayY==yearSelect)&(TPD.dayRECOHURSTzvalue<0.5)&(TPD.dayRECOGrowth>TPD.day_recurrentRECOGoley));
% % hl7 = scatter(TPD.daydate(ind),TPD.dayRECOGrowth(ind),'s','MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
% %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TPD.dayY==yearSelect);
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'YTickLabel',w3,...
    'XTick',TPD.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(2,:); ax2.YAxis(2).Color = color_mtx_dark(1,:);
ylabel ('respiration (gC m^-^2 d^-^1)','FontSize',16,'color',color_mtx_dark(1,:));   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)

%%
yearSelect = 2019;
ind = find(TPD.dayY==yearSelect);
v1 = 0;                         v2 = 36;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
h = area(TPD.daydate(ind),y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
% set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl2 = plot(TPD.daydate(ind),TPD.day_recurrentGEPdayGoley(ind),'-','LineWidth',2,'color',[0.3 0.3 0.3 ]); hold on;
% hl1 = plot(TPD.daydate(ind),TPD.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0.6 0.6]); hold on; alpha = 0.3;
hl3 = plot(TPD.daydate(ind),(TPD.dayGEPday(ind).*0)+mean(TPD.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
hl4 = plot(TPD.daydate(ind),TPD.dayGEPdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayGrowth>(TPD.day_recurrentGEPdayGoley+(2.*TPD.day_recurrent_stdGEPday))));
hl5 = scatter(TPD.daydate(ind),TPD.dayGEPday(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TPD.dayGEPdayARIMAzvalueResidual,'omitnan');
% iy = std(TPD.dayGEPdayARIMAzvalueResidual,'omitnan');
% ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMA)&(TPD.dayGEPdayGrowth>TPD.day_recurrentGEPdayGoley));
% zvalue value-mu/std
% ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(TPD.dayGEPdayGrowth>TPD.day_recurrentGEPdayGoley));
hl6 = scatter(TPD.daydate(ind),TPD.dayGEPday(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TPD.dayGEPdayHURSTzvalue,'omitnan');
% iy = std(TPD.dayGEPdayHURSTzvalue,'omitnan');
% % ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayHURST>(ix+(1.5.*iy))));
% ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayHURSTzvalue<0.5)&(TPD.dayGEPdayGrowth>TPD.day_recurrentGEPdayGoley));
% hl7 = scatter(TPD.daydate(ind),TPD.dayGEPday(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TPD.dayY==yearSelect);
hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month;
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:2:end));    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',TPD.month(1:36:end),'XTickLabel',datestr(TPD.month(1:36:end),'yyyy')
ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
% text(TPD.daydate(ind(20)),250,site_name,'FontSize',16)

w1 = 0.;                      w2 = .42;       w3 = w1:((.4-w1)/4):.4;
yyaxis right;
% scatter(TPD.daydate(ind),TPD.dayEVI(ind),'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
%     'MarkerFaceAlpha',.7,'MarkerEdgeAlpha',.7);
% plot(TPD.daydate(ind),smoothdata(TPD.dayEVI(ind),'movmean',5),'-','Color',color_mtx_dark(4,:),'Linewidth',2);
ind = find(TPD.eightY==yearSelect);
scatter(TPD.eight(ind),TPD.eightEVI(ind), 'o', 'filled', 'MarkerFaceAlpha', 0.7, 'MarkerEdgeColor', color_mtx_dark(5,:),...
    'MarkerFaceColor', color_mtx_dark(5,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(TPD.eight(ind),(TPD.eightEVI(ind)),'-','LineWidth',2,'Color',color_mtx_dark(5,:));
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(yearSelect,1,1) datetime(yearSelect,12,31)],...
    'YTickLabel',w3,'XTick',(datetime(yearSelect,1:2:12,1)'));    %'XTickLabelColor',[0. 0. 0.7 ]
% ind = find(TPD.dayY==yearSelect);
% set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'YTickLabel',w3,...
%     'XTick',TPD.month(1:2:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(2,:); ax2.YAxis(2).Color = color_mtx_dark(5,:);
ylabel ('EVI','FontSize',16,'color',color_mtx_dark(5,:));   xtickangle(0);   box on;
text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)

%% hourly
% .....................................................................................
% close all;
cla;
indSelect = find((TPD.dateloc>=datetime(2019,6,24))&(TPD.dateloc<=datetime(2019,7,3)));
v1 = 0;                         v2 = 20;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 600 800],'units','inches');
subplot(2,1,1);
yyaxis left;
y = [TPD.recurrentET(indSelect)-TPD.recurrent_stdET(indSelect),2.*TPD.recurrent_stdET(indSelect)];
hl1 = area(days(TPD.dateloc(indSelect)-TPD.dateloc(indSelect(1))),y);
set(hl1(2),'FaceColor',[.8 .8 .9],'EdgeColor',[.8 .8 .9],'FaceAlpha',.5);
set(hl1(1),'FaceColor','none','EdgeColor','none');
set(hl1,'BaseValue',0);
hl2 = plot(TPD.dateloc(indSelect),TPD.PET(indSelect),'-','LineWidth',1,'color',[0.07,0.44,0.75]); hold on;
% set(gca,'YColor',[0.9 0.6 0.2]);
hold on;
% cla(gca, 'reset');
ax1 = gca;       %set(ax1,'YColor',[0.4 0.4 0.8]);
set(ax1,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.dateloc(indSelect(1)) TPD.dateloc(indSelect(end))],...
    'FontSize',16);%,'XTick',TPD.dateloc(indSelect(1:24:end)));
ylabel ('PET (mm s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;

yyaxis right;
y = [TPD.recurrentET(indSelect)-TPD.recurrent_stdET(indSelect),2.*TPD.recurrent_stdET(indSelect)];
hl3 = area(days(TPD.dateloc(indSelect)-TPD.dateloc(indSelect(1))),y);       set(gca,'Layer','top');
set(hl3(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'FaceAlpha',.5);
set(hl3(1),'FaceColor','none','EdgeColor','none');
set(hl3,'BaseValue',0);
% set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.dateloc(ind(1)) TPD.dateloc(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
hold on;
hl4 = plot(TPD.dateloc(indSelect),TPD.recurrentET(indSelect),'-','LineWidth',2,'color',[0.6 0.6 0.6 ]); hold on;
hl5 = plot(TPD.dateloc(indSelect),TPD.ET(indSelect),'-','LineWidth',2,'color',[0.9 0.6 0.2]); hold on;
% hl6 = plot(TPD.dateloc(indSelect),(TPD.ET(indSelect).*0)+mean(TPD.dayETday,'omitnan'),'--','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;

ax2 = gca;                     set(ax2,'YColor',[0.9 0.6 0.2]);
ax2.XAxis.MinorTick = 'on';    ax2.XAxis.MinorTickValues = TPD.daydate(1:1:end);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.dateloc(indSelect(1)) TPD.dateloc(indSelect(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TPD.dateloc(indSelect(1:48:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',TPD.month(1:36:end),'XTickLabel',datestr(TPD.month(1:36:end),'yyyy')
ylabel ('ET (mm s^-^1)','FontSize',16);  box on;   grid on;
text(TPD.dateloc(indSelect(20)),18,site_name,'FontSize',16)

% cla;
subplot(2,1,2);     hold on;
v1 = 0.3;           v2 = .46;       v3 = v1:((v2-v1)/4):v2;
indSelect = find((TPD.daydate>=datetime(2019,6,24))&(TPD.daydate<=datetime(2019,7,3)));
% yyaxis left;
y = [TPD.day_recurrentROIgcc(indSelect)-TPD.day_recurrent_stdROIgcc(indSelect),2.*TPD.day_recurrent_stdROIgcc(indSelect)];
h = area(TPD.daydate(indSelect),y);
% set(h,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'FaceAlpha',.5);
set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);          hold on;
hl1 = plot(TPD.daydate(indSelect),TPD.day_recurrentROIgcc(indSelect),'-k');
hl2 = scatter(TPD.daydate(indSelect),TPD.ROIgcc(indSelect),'.','MarkerFaceColor',[0.87 0.33 0.],'MarkerEdgeColor',[0.87 0.33 0.],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
hl3 = plot(TPD.daydate(indSelect),(TPD.ROIgcc(indSelect)),'-','Color',[0.87 0.33 0.]);
% cla;
ax1 = gca;                      set(ax1,'YColor',[0.9 0.6 0.2]);
ax1.XAxis.MinorTick = 'on';     ax1.XAxis.MinorTickValues = TPD.daydate(1:1:end);
set(ax1,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(indSelect(1)) TPD.daydate(indSelect(end))],...
    'FontSize',16,'XMinorGrid','on','XTick',TPD.daydate(indSelect(1:2:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GCC_{phenocam}','FontSize',16);
grid on;          box on;

% w1 = 0.29;                      w2 = .49;       w3 = w1:((w2-w1)/4):w2;
% yyaxis right;
% scatter(TPD.dateloc(ind),TPD.dayROIgcc(ind),'.','MarkerFaceColor',[0.87 0.33 0.],'MarkerEdgeColor',[0.87 0.33 0.],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% plot(TPD.dateloc(ind),smoothdata(TPD.dayROIgcc(ind),'movmean',5),'-','Color',[0.87 0.33 0.]);
%
% ind = find((TPD.dayY==yearSelect)&(TPD.dayROIgccGrowth>(TPD.day_recurrentROIgccGoley+(2.*TPD.day_recurrent_stdROIgcc))));
% hl5 = scatter(TPD.dateloc(ind),TPD.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% ind = find((TPD.dayY==yearSelect)&(TPD.dayROIgccARIMAzvalueResidual>thresholdARIMAzvalue)&...
%     (TPD.dayROIgccGrowth>TPD.day_recurrentROIgccGoley));
% hl6 = scatter(TPD.dateloc(ind),TPD.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
% ix = mean(TPD.dayROIgccHURSTzvalue,'omitnan');
% iy = std(H,'YTickLabel',w3a1.dayROIgccHURSTzvalue,'omitnan');
% ind = find((TPD.dayY==yearSelect)&(TPD.dayROIgccHURSTzvalue<0.5)&(TPD.dayROIgccGrowth>TPD.day_recurrentROIgccGoley));
% hl7 = scatter(TPD.dateloc(ind),TPD.dayROIgccGrowth(ind),'s','MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
ax2 =gca;
% ind = find(TPD.dayY==yearSelect);
% set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.dateloc(indSelect(1)) TPD.dateloc(indSelect(end))],...
%     'YTickLabel',v3,'XTick',TPD.dateloc(indSelect(1:2:end)));    %'XTickLabelColor',[0. 0. 0.7 ]
% ylabel ('GCC_{phenocam}','FontSize',16,'color',[0.87 0.33 0.]);   xtickangle(0);   box on;
% % legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5'); legend box off;


% .....................................................................................
%% deseasonalized  TPD.dayGEPday_zscore   dayGEPday_deseasoned
% .....................................................................................
yearSelect = 2019;
ind = find(TPD.dayY==yearSelect);
v1 = -10;                         v2 = 10;       v3 = v1:((v2-v1)/4):v2;
w1 = 0.34;                         w2 = .5;       w3 = w1:((w2-w1)/4):w2;
figure('color','white','Position',[50 50 600 400],'units','inches');
yyaxis left;
% y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
% h = area(TPD.daydate(ind),y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
% hl2 = plot(TPD.daydate(ind),TPD.day_recurrentGEPdayGoley(ind),'LineWidth',1,'color',[0. 0.6 0.6 ]); hold on;
hl1 = plot(TPD.daydate(ind),TPD.dayGEPday_zscore(ind),'LineWidth',0.8,'color',[0.5 0.5 0.5]); hold on; alpha = 0.3;
hl3 = plot(TPD.daydate(ind),(TPD.dayGEPday_zscore(ind).*0)+mean(TPD.dayGEPday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
% hl4 = plot(TPD.daydate(ind),TPD.dayGEPdayGrowth(ind),'LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;

ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayGrowth>(TPD.day_recurrentGEPdayGoley+(2.*TPD.day_recurrent_stdGEPday))));
hl5 = scatter(TPD.daydate(ind),TPD.dayGEPday_zscore(ind),'MarkerFaceColor',[0.9 0.6 0.2],'MarkerEdgeColor',[0.7 0.6 0.08],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TPD.dayGEPdayARIMAzvalueResidual,'omitnan');
% iy = std(TPD.dayGEPdayARIMAzvalueResidual,'omitnan');
% ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMA)&(TPD.dayGEPdayGrowth>TPD.day_recurrentGEPdayGoley));
% zvalue value-mu/std
% ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayARIMAzvalueResidualGrowth>thresholdARIMAzvalue)&(TPD.dayGEPdayGrowth>TPD.day_recurrentGEPdayGoley));
hl6 = scatter(TPD.daydate(ind),TPD.dayGEPday_zscore(ind),'MarkerFaceColor',[0.9 0.2 0.9],'MarkerEdgeColor',[0.7 0.08 0.7],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

% ix = mean(TPD.dayGEPdayHURSTzvalue,'omitnan');
% iy = std(TPD.dayGEPdayHURSTzvalue,'omitnan');
% % ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayHURST>(ix+(1.5.*iy))));
% ind = find((TPD.dayY==yearSelect)&(TPD.dayGEPdayHURSTzvalue<0.5)&(TPD.dayGEPdayGrowth>TPD.day_recurrentGEPdayGoley));
% hl7 = scatter(TPD.daydate(ind),TPD.dayGEPday_zscore(ind),'MarkerFaceColor',[0.3 0.9 0.6],'MarkerEdgeColor',[0.08 0.5 0.08],...
%     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);

ind = find(TPD.dayY==yearSelect);
hold on;           ax2 = gca;         set(ax2,'YColor',[0.3 0.3 0.5]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.daydate(1:90:end);
set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
% ,'XTick',TPD.month(1:36:end),'XTickLabel',datestr(TPD.month(1:36:end),'yyyy')
ylabel ('LE_{daytime} (W m^-^2)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(TPD.daydate(ind(20)),250,site_name,'FontSize',16)

yyaxis right;
scatter(TPD.daydate,TPD.ROIgcc,'.','MarkerFaceColor',[0.5 0.2 0.2],'MarkerEdgeColor',[0.6 0.1 0.1],...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(TPD.daydate,TPD.ROIgcc,'-','Color',[0.6 0.1 0.1]);
set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'YTickLabel',['']);    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GCC_{phenocam}','FontSize',16,'color',[0.6 0.2 0.2]);   xtickangle(0);   box on;
% legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;

%%
v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
y = [TPD.day_recurrentGEPday-TPD.day_recurrent_stdGEPday,2.*TPD.day_recurrent_stdGEPday];
h = area(TPD.daydate,y);       set(gca,'Layer','top');
set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
set(h,'BaseValue',0);
hold on;
hl1 = plot(TPD.daydate,TPD.day_recurrentGEPday,'LineWidth',.5,'color',[0.6,0.6, 0.6 ]); hold on;
hl2 = plot(TPD.daydate,TPD.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl4 = plot(TPD.daydate,TPD.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(TPD.daydate,zeros(length(TPD.daydate),1)+mean(TPD.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month(1:6:end);
set(ax2,'XTick',TPD.month(1:24:end),'XTickLabel',datestr(TPD.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[TPD.daydate(1) TPD.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(TPD.month(12),v3(2),site_name,'FontSize',16);

w1 = -.3;                      w2 = .1;       w3 = w1:((w2-w1)/4):w2;
yyaxis right;
scatter(ROI.daydate,ROI.GRIVI_mean,'o','MarkerFaceColor',color_mtx(5,:),'MarkerEdgeColor',color_mtx_dark(5,:),...
    'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
plot(ROI.daydate,smoothdata(ROI.GRIVI_mean,'movmean',5),'-','Color',color_mtx_dark(5,:),'Linewidth',2);

set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[TPD.month(1) TPD.month(end)],'YTickLabel',w3,...
    'XTick',TPD.month(1:24:end));
ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(5,:); ax2.YAxis(2).Color = color_mtx_dark(5,:);
ylabel ('GRIVI_{phenocam}','FontSize',16,'color',color_mtx_dark(5,:));   xtickangle(0);   box on;
text(TPD.daydate(20),25,site_name,'FontSize',16)


v1 = -5;                         v2 = 35;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [TPD.day_recurrentGEPday-TPD.day_recurrent_stdGEPday,2.*TPD.day_recurrent_stdGEPday];
% h = area(TPD.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(TPD.daydate,TPD.dayGEPday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
% hl1 = plot(TPD.daydate,TPD.dayGEPday_zscore,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
% hl4 = plot(TPD.daydate,TPD.dayGEPdayARIMAzscore,'LineWidth',1,'color',[0.74,0.,0.74]); hold on;

hl3 = plot(TPD.daydate,zeros(length(TPD.daydate),1)+mean(TPD.dayGEPday_zscore,'omitnan'),'--','LineWidth',1,'color',[ 0.2 0.2 0.2]); hold on;
ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month(1:6:end);
set(ax2,'XTick',TPD.month(1:24:end),'XTickLabel',datestr(TPD.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[TPD.daydate(1) TPD.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(TPD.month(12),v3(2),site_name,'FontSize',16);
%%

v1 = -50;                         v2 = 500;       v3 = v1:((v2-v1)/4):v2;
figure('color','white','Position',[50 50 1800 400],'units','inches');
% y = [TPD.day_recurrentGEPday-TPD.day_recurrent_stdGEPday,2.*TPD.day_recurrent_stdGEPday];
% h = area(TPD.daydate,y);       set(gca,'Layer','top');
% set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% set(h,'BaseValue',0);
hold on;
hl2 = plot(TPD.daydate,TPD.dayHday,'LineWidth',1,'color',[0.45,0.45, 0.45 ]); hold on;
hl1 = plot(TPD.daydate,TPD.dayLEday,'LineWidth',1,'color',[0.00,0.45,0.74]); hold on;
hl1 = plot(TPD.daydate,TPD.dayLEday+TPD.dayHday,'LineWidth',1,'color',[0.9,0.45,0.74]); hold on;
hl4 = plot(TPD.daydate,TPD.daynetradday,'LineWidth',1,'color',[0.9,0.,0.9]); hold on;

ax2 = gca;                            %set(h,'YColor',[0.4 0.4 0.8]);
ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month(1:6:end);
set(ax2,'XTick',TPD.month(1:24:end),'XTickLabel',datestr(TPD.month(1:24:end),'yyyy'),'YTick',v3,...
    'XLim',[TPD.daydate(1) TPD.daydate(end)],'YLim',[v1 v2],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
ylabel ('GEP_{daytime} (\mumol m^-^2 s^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
text(TPD.month(12),v3(2),site_name,'FontSize',16);

