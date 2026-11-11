% Calculate seasonal values for ENSO event or other analysis
% Natalia Restrepo-Coupe
% Noisy PAR
% h2o mixing ratio improperly calculated
% u* improperly calculated
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;

flag_ExtreameET = 10;

ix = datetime(0,0,(1:16:365)');    ind = find(ix>=datetime(0,7,1));   week_start_hydro = ind(1);
tresholdSo = 10;                   tresholdCycleDay = 6;              tresholdCycle = 22;
eight_avg  = (1:8:365)';           week_avg = (1:16:365)';

tresholdtair =5;
gC_m2_d1=60.*60.*24.*12.*(10.^-6);

polyorder = 2;      % Polynomial order (typically 2 or 3)
framesize = 3;     % Window size (must be odd)

% %..........................................................................
% %% Fill meteorology
% %..........................................................................
% opts.VariableNames = ["TIMESTAMP_START", "TIMESTAMP_END", "TA_F_MDS", "TA_F_MDS_QC", "TA_ERA", "TA_F", "TA_F_QC", "SW_IN_POT", "SW_IN_F_MDS", "SW_IN_F_MDS_QC", "SW_IN_ERA", "SW_IN_F", "SW_IN_F_QC", "LW_IN_F_MDS", "LW_IN_F_MDS_QC", "LW_IN_ERA", "LW_IN_F", "LW_IN_F_QC", "LW_IN_JSB", "LW_IN_JSB_QC", "LW_IN_JSB_ERA", "LW_IN_JSB_F", "LW_IN_JSB_F_QC", "VPD_F_MDS", "VPD_F_MDS_QC", "VPD_ERA", "VPD_F", "VPD_F_QC", "PA", "PA_ERA", "PA_F", "PA_F_QC", "P", "P_ERA", "P_F", "P_F_QC", "WS", "WS_ERA", "WS_F", "WS_F_QC", "WD", "USTAR", "RH", "NETRAD", "PPFD_IN", "PPFD_DIF", "CO2_F_MDS", "CO2_F_MDS_QC", "TS_F_MDS_1", "TS_F_MDS_2", "TS_F_MDS_3", "TS_F_MDS_4", "TS_F_MDS_1_QC", "TS_F_MDS_2_QC", "TS_F_MDS_3_QC", "TS_F_MDS_4_QC", "G_F_MDS", "G_F_MDS_QC", "LE_F_MDS", "LE_F_MDS_QC", "LE_CORR", "LE_CORR_25", "LE_CORR_75", "LE_RANDUNC", "LE_RANDUNC_METHOD", "LE_RANDUNC_N", "LE_CORR_JOINTUNC", "H_F_MDS", "H_F_MDS_QC", "H_CORR", "H_CORR_25", "H_CORR_75", "H_RANDUNC", "H_RANDUNC_METHOD", "H_RANDUNC_N", "H_CORR_JOINTUNC", "EBC_CF_N", "EBC_CF_METHOD", "NIGHT", "NEE_CUT_REF", "NEE_VUT_REF", "NEE_CUT_REF_QC", "NEE_VUT_REF_QC", "NEE_CUT_REF_RANDUNC", "NEE_VUT_REF_RANDUNC", "NEE_CUT_REF_RANDUNC_METHOD", "NEE_VUT_REF_RANDUNC_METHOD", "NEE_CUT_REF_RANDUNC_N", "NEE_VUT_REF_RANDUNC_N", "NEE_CUT_REF_JOINTUNC", "NEE_VUT_REF_JOINTUNC", "NEE_CUT_USTAR50", "NEE_VUT_USTAR50", "NEE_CUT_USTAR50_QC", "NEE_VUT_USTAR50_QC", "NEE_CUT_USTAR50_RANDUNC", "NEE_VUT_USTAR50_RANDUNC", "NEE_CUT_USTAR50_RANDUNC_METHOD", "NEE_VUT_USTAR50_RANDUNC_METHOD", "NEE_CUT_USTAR50_RANDUNC_N", "NEE_VUT_USTAR50_RANDUNC_N", "NEE_CUT_USTAR50_JOINTUNC", "NEE_VUT_USTAR50_JOINTUNC", "NEE_CUT_MEAN", "NEE_VUT_MEAN", "NEE_CUT_MEAN_QC", "NEE_VUT_MEAN_QC", "NEE_CUT_SE", "NEE_VUT_SE", "NEE_CUT_05", "NEE_CUT_16", "NEE_CUT_25", "NEE_CUT_50", "NEE_CUT_75", "NEE_CUT_84", "NEE_CUT_95", "NEE_VUT_05", "NEE_VUT_16", "NEE_VUT_25", "NEE_VUT_50", "NEE_VUT_75", "NEE_VUT_84", "NEE_VUT_95", "NEE_CUT_05_QC", "NEE_CUT_16_QC", "NEE_CUT_25_QC", "NEE_CUT_50_QC", "NEE_CUT_75_QC", "NEE_CUT_84_QC", "NEE_CUT_95_QC", "NEE_VUT_05_QC", "NEE_VUT_16_QC", "NEE_VUT_25_QC", "NEE_VUT_50_QC", "NEE_VUT_75_QC", "NEE_VUT_84_QC", "NEE_VUT_95_QC", "RECO_NT_VUT_REF", "RECO_NT_VUT_USTAR50", "RECO_NT_VUT_MEAN", "RECO_NT_VUT_SE", "RECO_NT_VUT_05", "RECO_NT_VUT_16", "RECO_NT_VUT_25", "RECO_NT_VUT_50", "RECO_NT_VUT_75", "RECO_NT_VUT_84", "RECO_NT_VUT_95", "RECO_NT_CUT_REF", "RECO_NT_CUT_USTAR50", "RECO_NT_CUT_MEAN", "RECO_NT_CUT_SE", "RECO_NT_CUT_05", "RECO_NT_CUT_16", "RECO_NT_CUT_25", "RECO_NT_CUT_50", "RECO_NT_CUT_75", "RECO_NT_CUT_84", "RECO_NT_CUT_95", "GPP_NT_VUT_REF", "GPP_NT_VUT_USTAR50", "GPP_NT_VUT_MEAN", "GPP_NT_VUT_SE", "GPP_NT_VUT_05", "GPP_NT_VUT_16", "GPP_NT_VUT_25", "GPP_NT_VUT_50", "GPP_NT_VUT_75", "GPP_NT_VUT_84", "GPP_NT_VUT_95", "GPP_NT_CUT_REF", "GPP_NT_CUT_USTAR50", "GPP_NT_CUT_MEAN", "GPP_NT_CUT_SE", "GPP_NT_CUT_05", "GPP_NT_CUT_16", "GPP_NT_CUT_25", "GPP_NT_CUT_50", "GPP_NT_CUT_75", "GPP_NT_CUT_84", "GPP_NT_CUT_95", "RECO_DT_VUT_REF", "RECO_DT_VUT_USTAR50", "RECO_DT_VUT_MEAN", "RECO_DT_VUT_SE", "RECO_DT_VUT_05", "RECO_DT_VUT_16", "RECO_DT_VUT_25", "RECO_DT_VUT_50", "RECO_DT_VUT_75", "RECO_DT_VUT_84", "RECO_DT_VUT_95", "RECO_DT_CUT_REF", "RECO_DT_CUT_USTAR50", "RECO_DT_CUT_MEAN", "RECO_DT_CUT_SE", "RECO_DT_CUT_05", "RECO_DT_CUT_16", "RECO_DT_CUT_25", "RECO_DT_CUT_50", "RECO_DT_CUT_75", "RECO_DT_CUT_84", "RECO_DT_CUT_95", "GPP_DT_VUT_REF", "GPP_DT_VUT_USTAR50", "GPP_DT_VUT_MEAN", "GPP_DT_VUT_SE", "GPP_DT_VUT_05", "GPP_DT_VUT_16", "GPP_DT_VUT_25", "GPP_DT_VUT_50", "GPP_DT_VUT_75", "GPP_DT_VUT_84", "GPP_DT_VUT_95", "GPP_DT_CUT_REF", "GPP_DT_CUT_USTAR50", "GPP_DT_CUT_MEAN", "GPP_DT_CUT_SE", "GPP_DT_CUT_05", "GPP_DT_CUT_16", "GPP_DT_CUT_25", "GPP_DT_CUT_50", "GPP_DT_CUT_75", "GPP_DT_CUT_84", "GPP_DT_CUT_95", "RECO_SR", "RECO_SR_N"];
% TPD.ws_fill = AM_rm_outlier(TPD.ws,4);
% TPD.ws_fill = AM_fill_month_cycle(TPD.ws_fill,TPD.dateloc,6,18);
% TPD.tc_fill   = AM_fill_day_cycle(TPD.tasp,TPD.dateloc,6,18);

%..........................................................................
%% Saturated and air water pressure
%..........................................................................
T_0C_K =  273.15;             %'Temperature in K when it is zero in C
R      =  8.3143e-3;          %'Universal gas constant [kPa m^3/(K mol)]
Rd     =  R/28.97;            %'Gas constant for dry air [kPa m^3/(K g)]
Cp     =  1.013*10^-3;        % Specific heat at constant pressure, 1.013 10-3 [MJ kg-1 �C-1];
k      =  0.41;               %'von Karman constant (Dyer & hicker 1970, Webb 1970)
A0 = 6.107799961;       A1 = 4.436518521e-1;        A2 = 1.428945805e-2;
A3 = 2.650648471e-4;    A4 = 3.031240396e-6;        A5 = 2.034080948e-8;
A6 = 6.136820929e-11;   RV = 0.0004615;             %Gas constant for water vapor [J/(mg K)]
TPD.e_sat   = 0.1.*(A0+TPD.tair.*(A1+TPD.tair.*(A2+TPD.tair.*(A3+TPD.tair.*(A4+TPD.tair.*(A5+TPD.tair*A6))))));
TPD.delta   = 4098*TPD.e_sat./((237.3+TPD.tair).^2);                % slope of vapor pressure curve, kPa/C
% TPD.h2o_gm3 =  (0.01802.*TPD.pambKpa)./((R.*TPD.tc_fill+T_0C_K).*((1./TPD.h2ommolm)+(0.01802/18)));

TPD.rho_a = (TPD.pambKpa./(0.28705*(TPD.tair+273.15))).*(1-(0.378*TPD.e_sat.*TPD.RH./TPD.pambKpa));
% TPD.rho_a = AM_fill_day_cycle(TPD.rho_a,TPD.dateloc,6,18);

% %'Calculate water vapor pressure using IRGASON measurements
% TPD.e     =  (TPD.h2omix.*(TPD.pambKpa./100)./(TPD.h2omix+622)).*10^2; % vapor pressure (mb) then x10^6
% TPD.e     =  AM_rm_outlier(TPD.e,3);
% TPD.RH    =  TPD.e./TPD.e_sat;
% ix        =  TPD.e_sat.*(1-TPD.RH./100);                                    % vapour pressure deficit;
% TPD.VPD   =  TPD.e_sat.*(1-TPD.RHec./100);
% TPD.VPD((TPD.VPD<0)|(isnan(TPD.VPD))) = ix((TPD.VPD<0)|(isnan(TPD.VPD)));
% TPD.VPD(TPD.VPD<0) = 0;
% TPD.VPD = AM_fill_month_cycle(TPD.VPD,TPD.dateloc,6,18);
% TPD.VPD((TPD.VPD<0)|(isinf(TPD.VPD))) = 0;
%
% TPD.rho_d =  (TPD.pambKpa-TPD.e)./((TPD.tc_fill+T_0C_K).*Rd);          % 'g/m^3
% %TPD.rho_a =  (TPD.rho_d + TPD.h2o_gm3)./1000;       %Natalia          % 'kg/m^3
%
% % % %..........................................................................
% TPD.e_sat_fill = AM_fill_day_cycle(TPD.e_sat,TPD.dateloc,6,18);
% TPD.rho_a = AM_fill_day_cycle(TPD.rho_a,TPD.dateloc,6,18);
% TPD.e_fill     = AM_fill_day_cycle(TPD.e,TPD.dateloc,6,18);
%
% % .........................................................................
TPD.lambda = (2.50*10^6)-((2.386*10^3).*(TPD.tair));                % 2.45 [MJ kg-1]     % Latent heat of vaporization, 2.45 [MJ kg-1],
TPD.lambda = TPD.lambda./10^6;
% % TPD.delta    =  (4098.*TPD.e_sat_fill)./(power((TPD.tc_fill+237.3),2)); %[kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% % http://agsys.cra-cin.it/tools/evapotranspiration/help/Slope_of_saturation_vapour_pressure_curve.html
% % TPD.delta   =  0.04145.*exp(0.06088.*TPD.tc_fill);              % 0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% TPD.delta   = 4098*TPD.e_sat_fill./((237.3+TPD.tc_fill).^2);      % slope of vapor pressure curve, kPa/C
TPD.sigma  = ((Cp.*TPD.pambKpa)./(0.622.*TPD.lambda));              % sigma psychrometric constant 0.054 [kPa C-1]
% %TPD.sigma   = smooth(TPD.sigma);
% %where epsilon ratio molecular weight of water vapour/dry air  =  0.622
% TPD.epsilon =  TPD.delta./TPD.sigma;                              % Unitless ~0.6219
% % Rho_air: mean air density at constant pressure (Bruutsaet,p38)(kPa kg J-1)
% % % if ((nanmax(TPD.rho_air)>2)|(nanmin(TPD.rho_air)<0.5));   '\rho air TPDcurate calculation please check';    end;
% % % c = 1.01;                                                     % virtual absolute air temperature Tv = (c.*(TPD.tc_fill+273.15)
% % % TPD.rho_air = TPD.pambpa./((c.*(TPD.tc_fill+273.15)).*R);     % multiply by 10 so we can get the 1.2value??? http://www.fao.org/docrep/x0490e/x0490e06.htm [kg m-3]
% % % Qa  =  0.62197.*TPD.e./((TPD.pambpa./100)-(0.378030.*TPD.e)); % specific humidity (kg/kg)
% % %..........................................................................
% % % 2002-2005
% % %..........................................................................
% % [TPD.h_So]     = AM_solar_rad(TPD.h_JD,TPD.h_HR+1,lat,lon);
% % TPD.h_delta    =  0.04145.*exp(0.06088.*TPD.h_tc_fill);                       %0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% % TPD.h_lambda(isnan(TPD.h_lambda)) = 2.45;
% % TPD.h_sigma    =  ((Cp.*TPD.h_pambKpa)./(0.622.*TPD.h_lambda));                    %[kPa C-1]
% % TPD.h_sigma    =  smooth(TPD.h_sigma);
%
% %..........................................................................
% %% ET ref
% %..........................................................................
% TPD.LEref = AM_fill((TPD.LE+TPD.H).*(TPD.delta./(TPD.delta+(TPD.sigma))));
% % TPD.LEref = AM_fill((TPD.netrad).*(TPD.delta./(TPD.delta+(TPD.sigma))));
% TPD.LEref((TPD.So < 500)|(TPD.rain_fill>0)) = NaN;
% TPD.ETref = AM_fill_plus(TPD.LEref./TPD.lambda);
% TPD.ETref = TPD.ETref.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
%
% %..........................................................................
% TPD.eightETref = AM_eight2cycle_rs(TPD.ETref,TPD.dateloc,tresholdCycleDay,4,2);    TPD.eightETref = AM_fill(TPD.eightETref);
% [TPD.weekETref,~,~,~,~,TPD.week_stdETref]  = AM_week2cycle_rs(TPD.ETref,TPD.dateloc,tresholdCycleDay,4,2);     TPD.weekETref  = AM_fill(TPD.weekETref);
% TPD.monthETref = AM_month2cycle(TPD.ETref,TPD.dateloc,tresholdCycleDay,4,2);       TPD.monthETref = AM_fill(TPD.monthETref);
% TPD.monthETref = AM_month2cycle(TPD.ETref,TPD.dateloc,tresholdCycleDay,4,2);                      TPD.monthETref  = AM_fill(TPD.monthETref);
% TPD.monthETref = TPD.monthETref.*eomday(TPD.monthY,TPD.monthM);
%
% TPD.ETrefday = TPD.ETref;      TPD.ETrefday(TPD.So<=tresholdSo) = NaN;
% [TPD.weekETrefday,~,~,~,~,TPD.week_stdETrefday]  = AM_week2cycle_rs(TPD.ETrefday,TPD.dateloc,tresholdCycleDay,4,2);     TPD.weekETrefday  = AM_fill(TPD.weekETrefday);
% [TPD.monthETrefday,~,~,~,~,TPD.month_stdETrefday]= AM_month2cycle(TPD.ETrefday,TPD.dateloc,tresholdCycleDay,4,2);     TPD.monthETrefday  = AM_fill(TPD.monthETrefday);
%
% TPD.LErefday = TPD.LEref;      TPD.LErefday(TPD.So<=tresholdSo) = NaN;
% [TPD.weekLErefday,~,~,~,~,TPD.week_stdLErefday]  = AM_week2cycle_rs(TPD.LErefday,TPD.dateloc,tresholdCycleDay,4,2);     TPD.weekLErefday  = AM_fill(TPD.weekLErefday);
%
% %..........................................................................
% %% Rain
% %..........................................................................
% [~,~,TPD.eightRain] = AM_eightday_rs(TPD.rain,TPD.dateloc);                         TPD.eightRain = AM_fill(TPD.eightRain);
% [~,~,TPD.weekRain,~,~,TPD.week_stdRain]  = AM_week2day_rs(TPD.rain,TPD.dateloc);    TPD.weekRain  = AM_fill(TPD.weekRain);
% [~,TPD.monthRain] = AM_month(TPD.rain,TPD.dateloc);                                 TPD.monthRain = AM_fill(TPD.monthRain);
[TPD.cycle_month_LE,TPD.cycle_month_countLE,~,TPD.cycle_month_stdLE] = ...
    AM_day_cycle_year(TPD.LE,TPD.dateloc);
[TPD.cycle_month_netrad,TPD.cycle_month_countnetrad,~,TPD.cycle_month_stdnetrad] = ...
    AM_day_cycle_year(TPD.netrad,TPD.dateloc);
[TPD.cycle_month_H,TPD.cycle_month_countH,~,TPD.cycle_month_stdH] = ...
    AM_day_cycle_year(TPD.H,TPD.dateloc);

% [TPD.week_avgRain,~,TPD.week_avgstdRain] = AM_week2_avg(TPD.weekRain,TPD.week);
%
% % % [TPD.eightCWD] = AM_eightday_rs(TPD.dayTRMM1hCWD,TPD.day);                            TPD.eightCWD = AM_fill(TPD.eightCWD);
% % % [TPD.weekCWD,~,~,~,~,TPD.week_stdCWD]  = AM_week2day_rs(TPD.dayTRMM1hCWD,TPD.day);    TPD.weekCWD  = AM_fill(TPD.weekCWD);
% % % [TPD.week_avgCWD,~,TPD.week_avgstdCWD] = AM_week2_avg(TPD.weekCWD,TPD.week);
%
% [TPD.eightCWD] = AM_eightday_rs(TPD.dayTRMM1hCWD,TPD.day);                            TPD.eightCWD = AM_fill(TPD.eightCWD);
% [TPD.weekCWD,~,~,~,~,TPD.week_stdCWD]  = AM_week2day_rs(TPD.dayTRMM1hCWD,TPD.day);    TPD.weekCWD  = AM_fill(TPD.weekCWD);
% [TPD.week_avgCWD,~,TPD.week_avgstdCWD] = AM_week2_avg(TPD.weekCWD,TPD.week);
%
% %% ........................................................................
% if flag_Rick == 1
%     ind = find((TPD.dateloc>datetime(2004,12,10))&(TPD.dateloc<datetime(2004,12,20)));
%     ind = find((TPD.dateloc>datetime(2004,8,24))&(TPD.dateloc<datetime(2004,9,7)));
%     figure('color','white');
%     y1 = -.2;     y2 = 1;       y3 = y1:((y2-y1)/4):y2;
%     x1 = 0;       x2 = 2;       x3 = x1:((x2-x1)/4):x2;
%     subplot(2,2,1:2);           hold on;
%     hl1 = bar(TPD.dateloc(ind),TPD.rain(ind)./10,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.8 0.8 0.8]);
%     hl3 = plot(TPD.dateloc(ind),TPD.ET(ind)./24,'Color',[0. 0. .9],'LineWidth',1);
%     hl4 = plot(TPD.dateloc(ind),TPD.ETref(ind)./24,'Color',[0. 0.9 .5],'LineWidth',1);
%     legend ([hl3,hl4],'ET','ET_{ref}','EdgeColor','white')%,'position','southoutside');
%     set(gca,'XTick',TPD.day(1:1:end),'XTickLabel',[ '' '' ''],'YTick',y3,'YColor',[0. 0. .9]); hold on;
%     xlim([TPD.dateloc(ind(1)) TPD.dateloc(ind(end))]);            ylim([y1 y2]);
%     ylabel ({'ET (mm)'},'FontSize',12,'Color',[0. 0. .9]);
%     ax1 = gca;          ax1_pos = ax1.Position;
%     ax2 = axes('Position',ax1_pos,'YAxisLocation','right','Color','none'); hold on;
%     %     hl7 = plot(TPD.dateloc(ind),TPD.tasp(ind),'Parent',ax2,'Color',[0.4 0.4 0.4],'LineWidth',1);    hold on;
%     hl7 = plot(TPD.dateloc(ind),TPD.ustar(ind),'Parent',ax2,'Color',[0.4 0.4 0.4],'LineWidth',1);    hold on;
%     set(ax2,'XColor','k','YColor',[ 0.0 0.0 0.0]);
%     %     ylabel ({'netrad (W m^-^2)'},'FontSize',12,'Color',[0.2 0.2 .2]);
%     %     ylabel ({'T_{air} (\circC)'},'FontSize',12,'Color',[0.4 0.4 .4]);
%     ylabel ({'u_* (m s^-^1)'},'FontSize',12,'Color',[0.4 0.4 .4]);
%     set(ax2,'XTick',TPD.dateloc(ind(1):48:ind(end)),'XTickLabel',datestr(TPD.dateloc(ind(1):48:ind(end)),'yyyy/mm/dd'),'YTick',x3,'YColor',[0.4 0.4 .4]);
%     xlim([TPD.dateloc(ind(1)) TPD.dateloc(ind(end))]);            ylim([x1 x2]);
%     box on; grid on;	text(TPD.dateloc(ind(20)),x3(5),site_name,'FontSize',8)
%
%     ind = find(TPD.So>100);
%     subplot(2,2,3);     hold on;
%     AM_bin(TPD.netrad(ind),TPD.LE(ind),15,1,1,[0 0 0.8]);
%     xlabel({'Rn (W m^-^2)'},'FontSize',10);ylabel ({'LE (W m^-^2)'},'FontSize',10);
%     [p,r2,~,~,sm,sb] = AM_compute_regression(TPD.netrad(ind),TPD.LE(ind),[0.4,0.4,0.4],0);
%     y_model=polyval(p,TPD.netrad(ind));   hold on;
%     plot(TPD.netrad(ind),y_model,'-','color',[0.4,0.4,0.4]);
%     xlim([-200 1200]);      ylim([-100 600]);
%     text (-50,350,site_name{:},'FontSize',10);
%     text (-50,300,{['LE=' num2str(p(1),'%6.4f') 'Rn+' num2str(p(2),'%6.4f')];...
%         ['std slope:' num2str(sm(1),'%3.4f')];['std int.:' num2str(sb(1),'%3.4f')];...
%         ['r^2:' num2str(r2(1),'%3.2f')]},'FontSize',10);         box on;
% end
%
%..........................................................................
%% Canopy conductance
%..........................................................................
canopy = tree_height_FN(ip);
z   = height;
d   = 2.*canopy./3;
zo  = 0.123*canopy;
zoh = 0.0123.*canopy;

TPD.A = (TPD.LE+TPD.H);
% weekA = AM_week2cycle_rs(TPD.A,TPD.dateloc,20);  weekH = AM_week2cycle_rs(TPD.H,TPD.dateloc,20);  weekLE = AM_week2cycle_rs(TPD.LE,TPD.dateloc,3);
%%
%         ACHTUNG!!!!!!!!!!!!!
% ik Yebra it apears as TPD.ga but looks like TPD.ra!!!!!!!!!!!
% TPD.ra =
% (log((height-d)./zo)).*(log((height-d)./zoh))./(k^2.*TPD.ws_fill);
% Natalia's origTPDl I use both zo and zoh
Ra        = (log((z-d)./zo)).*(log((z-d)./zoh))./(k.^2.*TPD.ws);
Ra(TPD.So<tresholdSo) = NaN;        Ra = AM_rm_outlier(Ra,5);
TPD.Ga        = 1./Ra;              TPD.Ga = AM_rm_outlier(TPD.Ga,5);
Ra_ustar  = TPD.ws./(TPD.ustar.^2);
Ra_ustar(TPD.So<tresholdSo) = NaN;	Ra_ustar = AM_rm_outlier(Ra_ustar,5);
Ga_ustar  = 1./Ra_ustar;            Ga_ustar = AM_rm_outlier(Ga_ustar,5);

%..........................................................................
%% PET from PM equation
%..........................................................................
% rho_a 1.2 kg m-3  Cp = 1.013 10-3 [MJ kg-1 C-1] > [J kg-1 k-1]   >>> delta [kPa m-2]
% lambda 2.45 [MJ kg-1]
% TPD.LErefPM = ((AM_fill((TPD.LE+TPD.H).*TPD.delta)+(TPD.rho_a.*Cp.*10^6.*TPD.VPD.*TPD.Ga)))./(TPD.delta+TPD.sigma);
TPD.LErefPM = ((AM_fill((TPD.netrad).*TPD.delta)+(TPD.rho_a.*Cp.*10^6.*TPD.VPD.*TPD.Ga)))./(TPD.delta+TPD.sigma);
TPD.ETrefPM = TPD.LErefPM./TPD.lambda;
TPD.ETrefPM = TPD.ETrefPM.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
TPD.ETrefdayPM = TPD.ETrefPM;      TPD.ETrefdayPM(TPD.So<=tresholdSo) = NaN;

% lambda    =  2.45;                                                                 % [MJ kg-1] FAO latent heat of vaporization of water
TPD.lambda = ((2.50*10^6)-((2.386*10^3).*(TPD.tair)))./10^6; % 2.45 [MJ kg-1]     % Latent heat of vaporization, 2.45 [MJ kg-1],

TPD.ET = TPD.LE./TPD.lambda;
TPD.ET = TPD.ET.*60.*60.*24/1000000;      % from s-1 to d-1 and from kg-1 to g-1 (mm)

%%
% PET = (0.408 * Δ * (Rn - G) + γ * (900 / (T + 273)) * u2 * (es - ea)) / (Δ + γ * (1 + 0.34 * u2))
% PET = Potential evapotranspiration (mm/day)
% Δ = Slope of the saturation vapor pressure curve (kPa/°C)
% Rn = Net radiation (MJ/m²/day)
% G = Soil heat flux (MJ/m²/day)
% γ = Psychrometric constant (kPa/°C)
% T = Air temperature (°C)
% u2 = Wind speed at 2 meters height (m/s)
% es = Saturation vapor pressure (kPa)
% ea = Actual vapor pressure (kPa)
TPD.e      = TPD.RH.*TPD.e_sat./100;

% TPD.delta =  (4098.*TPD.e_sat_fill)./(power((TPD.tc_fill+237.3),2));  %[kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% http://agsys.cra-cin.it/tools/evapotranspiration/help/Slope_of_saturation_vapour_pressure_curve.html
% TPD.delta =  0.04145.*exp(0.06088.*TPD.tc_fill);     % 0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
TPD.delta = 4098*TPD.e_sat./((237.3+TPD.tair).^2);     % slope of vapor pressure curve, kPa/C

TPD.sigma = ((Cp.*TPD.pambKpa)./(0.622.*TPD.lambda));  % sigma psychrometric constant 0.054 [kPa C-1]
%TPD.sigma   = smooth(TPD.sigma);
%where epsilon ratio molecular weight of water vapour/dry air  =  0.622
TPD.epsilon =  TPD.delta./TPD.sigma;                   % Unitless ~0.6219

TPD.ET = TPD.LE./TPD.lambda;
TPD.ET = TPD.ET.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)

% %..........................................................................
% %% ET dry conditions
% %..........................................................................
% ik = find(TPD.rain_fill>0);
% ij = zeros(length(TPD.rain_fill),1);
% ij(ik) = 1;                         indDry24 = ij;           im = 1;
% while im < length(ij)-25
%     if ij(im) == 1
%         for in = 1:24
%             indDry24(im+in) = 1;
%         end
%     end
%     im = im + 1;
% end
% TPD.LEdry24 = TPD.LE;             TPD.ETdry24 = TPD.ET;
% TPD.LEdry24(indDry24==1) = NaN;     TPD.ETdry24(indDry24==1) = NaN;
% TPD.ETdryday24 = TPD.ETdry24;     TPD.ETdryday24(TPD.So<tresholdSo) = NaN;
%
% TPD.ETrefdry24 = TPD.ETref;           TPD.ETrefdry24(indDry24==1) = NaN;
% TPD.ETrefdryday24 = TPD.ETrefdry24;   TPD.ETrefdryday24(TPD.So<tresholdSo) = NaN;
%
% TPD.LEwet24 = TPD.LE;               TPD.ETwet24 = TPD.ET;
% TPD.LEwet24(indDry24==0) = NaN;     TPD.ETwet24(indDry24==0) = NaN;
% TPD.ETwetday24 = TPD.ETwet24;       TPD.ETwetday24(TPD.So<tresholdSo) = NaN;
%
% TPD.ETrefwet24 = TPD.ETref;         TPD.ETrefwet24(indDry24==0) = NaN;
% TPD.ETrefwetday24 = TPD.ETrefwet24; TPD.ETrefwetday24(TPD.So<tresholdSo) = NaN;
%
%..........................................................................
%% ET dry conditions
%..........................................................................
% Remove 12h after precipitation
ik = find(TPD.rain>0);
ij = zeros(length(TPD.rain),1);
ij(ik) = 1;                         indDry = ij;           im = 1;
while im < length(ij)-13
    if ij(im) == 1
        for in = 1:12
            indDry(im+in) = 1;
        end
    end
    im = im + 1;
end
TPD.LEdry = TPD.LE;             TPD.ETdry = TPD.ET;
TPD.LEdry(indDry==1) = NaN;     TPD.ETdry(indDry==1) = NaN;
TPD.ETdryday = TPD.ETdry;       TPD.ETdryday(TPD.So<tresholdSo) = NaN;

% TPD.ETrefdry = TPD.ETref;       TPD.ETrefdry(indDry==1) = NaN;
% TPD.ETrefdryday = TPD.ETrefdry; TPD.ETrefdryday(TPD.So<tresholdSo) = NaN;

TPD.LEwet = TPD.LE;             TPD.ETwet = TPD.ET;
TPD.LEwet(indDry==0) = NaN;     TPD.ETwet(indDry==0) = NaN;
TPD.ETwetday = TPD.ETwet;       TPD.ETwetday(TPD.So<tresholdSo) = NaN;

% TPD.ETrefwet = TPD.ETref;         TPD.ETrefwet(indDry==0) = NaN;
% TPD.ETrefwetday = TPD.ETrefwet;   TPD.ETrefwetday(TPD.So<tresholdSo) = NaN;

ix = TPD.HR.*indDry; ix(indDry==0) = NaN;
figure ('color','white');       histogram(ix,24);
ylabel('Frequency time rainfall');
xlabel('Local time rainfall TPD');

%..................................................................
%%         As in Yebra
%..................................................................
A   = TPD.LE+TPD.H;
% A   = TPD.netrad;       ix = TPD.LE+TPD.H;              A(isnan(A)) = ix(isnan(A));
one = TPD.epsilon.*A;   two = (TPD.epsilon+1).*TPD.LE;	three = TPD.rho_a.*10^6.*Cp.*(TPD.e_sat-TPD.e).*TPD.Ga./TPD.sigma;
Gs_OptionY = TPD.LE.*TPD.Ga./(one-two+three);
Gs_OptionY = Gs_OptionY.*1000;              %m s-1 to mm s-1
Gs_OptionY((Gs_OptionY<=0)|(Gs_OptionY>200)) = NaN;
Gs_OptionY((TPD.So<tresholdSo)|(TPD.rain>0)) = NaN;         Gs_OptionY = AM_rm_outlier(Gs_OptionY,3);
%..................................................................
one = TPD.epsilon.*A;   two = (TPD.epsilon+1).*TPD.LE;
three = TPD.rho_a.*10^6.*Cp.*(TPD.e_sat-TPD.e).*Ga_ustar./TPD.sigma;    three = AM_rm_outlier(three,3);
Gs_OptionYustar = TPD.LE.*Ga_ustar./(one-two+three);
Gs_OptionYustar = Gs_OptionYustar.*1000;    %m s-1 to mm s-1
Gs_OptionYustar((Gs_OptionYustar<=0)|(Gs_OptionYustar>1000)) = NaN;
Gs_OptionYustar((TPD.So<tresholdSo)|(TPD.rain>0)) = NaN;    Gs_OptionYustar = AM_rm_outlier(Gs_OptionYustar,3);

%..................................................................
%%         As in Blanken & Black, 2004
%..................................................................
TPD.Bowen   = TPD.H./TPD.LE;
Rs_OptionBB = (((TPD.epsilon.*TPD.Bowen)-1).*Ra)+((TPD.rho_a.*Cp.*10^6.*TPD.VPD)./(TPD.sigma.*TPD.LE));
Gs_OptionBB = 1000./Rs_OptionBB;
Gs_OptionBB((Gs_OptionBB<=0)|(Gs_OptionBB>400)) = NaN;
Gs_OptionBB((TPD.So<tresholdSo)|(TPD.rain>0)) = NaN;        Gs_OptionBB = AM_rm_outlier(Gs_OptionBB,3);

Rs_OptionBB_ustar = (((TPD.epsilon.*TPD.Bowen)-1).*Ra_ustar)+((TPD.rho_a.*Cp.*10^6.*TPD.VPD)./(TPD.sigma.*TPD.LE));
Gs_OptionBB_ustar = 1000./Rs_OptionBB_ustar;
Gs_OptionBB_ustar((Gs_OptionBB_ustar<=0)|(Gs_OptionBB_ustar>200)) = NaN;
Gs_OptionBB_ustar((TPD.So<tresholdSo)|(TPD.rain>0)) = NaN;	Gs_OptionBB_ustar = AM_rm_outlier(Gs_OptionBB_ustar,3);

% .........................................................................
TPD.BowenDry = TPD.H./TPD.LEdry;
Rs_OptionBBdry = (((TPD.epsilon.*TPD.BowenDry)-1).*Ra)+((TPD.rho_a.*Cp.*10^6.*TPD.VPD)./(TPD.sigma.*TPD.LEdry));
Gs_OptionBBdry = 1000./Rs_OptionBBdry;
Gs_OptionBBdry((Gs_OptionBBdry<=0)|(Gs_OptionBBdry>400)) = NaN;
Gs_OptionBBdry((TPD.So<tresholdSo)|(TPD.rain>0)) = NaN;     Gs_OptionBBdry = AM_rm_outlier(Gs_OptionBBdry,3);

Rs_OptionBBdry_ustar = (((TPD.epsilon.*TPD.BowenDry)-1).*Ra_ustar)+((TPD.rho_a.*Cp.*10^6.*TPD.VPD)./(TPD.sigma.*TPD.LEdry));
Gs_OptionBBdry_ustar = 1000./Rs_OptionBBdry_ustar;
Gs_OptionBBdry_ustar((Gs_OptionBBdry_ustar<=0)|(Gs_OptionBBdry_ustar>200)) = NaN;
Gs_OptionBBdry_ustar((TPD.So<tresholdSo)|(TPD.rain>0)) = NaN;
Gs_OptionBBdry_ustar = AM_rm_outlier(Gs_OptionBBdry_ustar,3);

% %..................................................................
% % Climatological resistance
% %..................................................................
% TPD.Ri = (TPD.rho_a.*Cp.*10^6.*TPD.VPD)./(TPD.sigma.*(TPD.LE+TPD.H));
% %TPD.Ri = (TPD.rho_a.*Cp.*10^6.*TPD.VPD)./(TPD.sigma.*(TPD.netrad));
% TPD.Gi = 1000./TPD.Ri;
% TPD.Gi(TPD.So<tresholdSo) = NaN;        TPD.Gi(TPD.Gi<0) = NaN;
% TPD.Gi = AM_rm_outlier(TPD.Gi,3);
%
% % Equilibrium LE
% TPD.PTalpha = TPD.LE./TPD.LEref;

% .........................................................................
%% Gs units mm s-1
% .........................................................................
TPD.GsPMall   = Gs_OptionBB;
TPD.GsPM      = Gs_OptionBBdry;
TPD.GsPMustar = Gs_OptionBB_ustar;

% From Pearcy et all. Measurement of transpiration and leaf conductance
% P in kPa, tair in degC, Gs from cm/s to mol m-2s-1
% TPD.GsPMallmol = TPD.GsPMall.*0.446.*(273./(273+TPD.tasp_fill)).*((TPD.pambpa_fill./1000)./101.3);

% Gas ideal gas law Gs [m s-1] x Pa[kPa]/R [m3 Pa K-1 mol] x Ta [k]   % average sea-level pressure is 101.325 kPa
% R = 8.3144621 m3 Pa K−1 mol−1   8.3144621 m3 /1000 kPa-1 K-1 mol
% Gs mol m-2 s-1
TPD.GsPMmmol = (TPD.GsPM./1000).*TPD.pambKpa./(R.*(273+TPD.tair));
TPD.GsPMmmol = TPD.GsPMmmol.*1000;
% Typical values for irrigated trials are: 300-700 mmol m-2s-1;
% and for mildly water stressed trials are: 80-300 mmol m-2s-1
TPD.GsPMallmmol = (TPD.GsPMall./1000).*(TPD.pambpa./1000)./(R.*(273+TPD.tair));
TPD.GsPMallmmol = TPD.GsPMallmmol.*1000;

% ........................................................................
%% ETref
% ........................................................................
TPD.LEref = AM_fill((TPD.LE+TPD.H).*(TPD.delta./(TPD.delta+(TPD.sigma))));
% TPD.LEref = AM_fill((TPD.netrad).*(TPD.delta./(TPD.delta+(TPD.sigma))));
TPD.LEref(TPD.So < tresholdSo) = NaN;
TPD.ETref = AM_fill_plus(TPD.LEref./TPD.lambda);
TPD.ETref = TPD.ETref.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)

% ........................................................................
%% day
% ........................................................................
[TPD.dayLE,~,x,~,TPD.daydate,TPD.dayLEmin,TPD.dayLEmax]   = AM_day(TPD.LE,TPD.dateloc,0);
TPD.dayLE(x<tresholdCycle) = NaN;         TPD.dayLEmin(x<tresholdCycle) = NaN;        TPD.dayLEmax(x<tresholdCycle) = NaN;
[TPD.dayH,~,x,~,~,TPD.dayHmin,TPD.dayHmax]   = AM_day(TPD.H,TPD.dateloc,0);
TPD.dayH(x<tresholdCycle) = NaN;         TPD.dayHmin(x<tresholdCycle) = NaN;        TPD.dayHmax(x<tresholdCycle) = NaN;
[TPD.daynetrad,~,x,~,~,TPD.daynetradmin,TPD.daynetradmax]   = AM_day(TPD.netrad,TPD.dateloc,0);
TPD.daynetrad(x<tresholdCycle) = NaN;         TPD.daynetradmin(x<tresholdCycle) = NaN;        TPD.daynetradmax(x<tresholdCycle) = NaN;
[TPD.daytair,~,x,~,~,TPD.daytairmin,TPD.daytairmax]   = AM_day(TPD.tair,TPD.dateloc,0);
TPD.daytair(x<tresholdCycle) = NaN;         TPD.daytairmin(x<tresholdCycle) = NaN;        TPD.daytairmax(x<tresholdCycle) = NaN;

[TPD.eightH,~,~,~,~,TPD.eight_stdH,TPD.eight] = AM_eight2cycle_rs(TPD.H,TPD.dateloc,tresholdCycle,2,3);    TPD.eightH = AM_fill(TPD.eightH);
TPD.eightLE = AM_eight2cycle_rs(TPD.LE,TPD.dateloc,tresholdCycle,2,3);    TPD.eightLE = AM_fill(TPD.eightLE);
TPD.eightnetrad = AM_eight2cycle_rs(TPD.netrad,TPD.dateloc,tresholdCycle,2,3);    TPD.eightnetrad = AM_fill(TPD.eightnetrad);
TPD.eighttair = AM_eight2cycle_rs(TPD.tair,TPD.dateloc,tresholdCycle,2,3);    TPD.eighttair = AM_fill(TPD.eighttair);

[TPD.weekH,~,~,~,~,TPD.week_stdH] = AM_week2cycle_rs(TPD.H,TPD.dateloc,tresholdCycle,2,3);  TPD.weekH  = AM_fill(TPD.weekH);
[TPD.weekLE,~,~,~,~,TPD.week_stdLE] = AM_week2cycle_rs(TPD.LE,TPD.dateloc,tresholdCycle,2,3);  TPD.weekLE  = AM_fill(TPD.weekLE);
[TPD.weeknetrad,~,~,~,~,TPD.week_stdnetrad] = AM_week2cycle_rs(TPD.netrad,TPD.dateloc,tresholdCycle,2,3);  TPD.weeknetrad  = AM_fill(TPD.weeknetrad);
[TPD.weektair,~,~,~,~,TPD.week_stdtair] = AM_week2cycle_rs(TPD.tair,TPD.dateloc,tresholdCycle,2,3);  TPD.weektair  = AM_fill(TPD.weektair);

[TPD.monthH,~,~,TPD.monthHmin,TPD.monthHmax] = AM_month2cycle(TPD.H,TPD.dateloc,tresholdCycle,2,2);
TPD.monthH = AM_fill(TPD.monthH);
[TPD.monthLE,~,~,TPD.monthLEmin,TPD.monthLEmax] = AM_month2cycle(TPD.LE,TPD.dateloc,tresholdCycle,2,2);
TPD.monthLE = AM_fill(TPD.monthLE);
[TPD.monthnetrad,~,~,TPD.monthnetradmin,TPD.monthnetradmax] = AM_month2cycle(TPD.netrad,TPD.dateloc,tresholdCycle,2,2);
TPD.monthnetrad = AM_fill(TPD.monthnetrad);
[TPD.monthtair,~,~,TPD.monthtairmin,TPD.monthtairmax] = AM_month2cycle(TPD.tair,TPD.dateloc,tresholdCycle,2,2);
TPD.monthtair = AM_fill(TPD.monthtair);

[TPD.dayGEP,~,x,~,~,TPD.dayGEPmin,TPD.dayGEPmax] = AM_day(TPD.gep.*gC_m2_d1,TPD.dateloc,0);
TPD.dayGEP(x<tresholdCycle) = NaN;                 TPD.dayGEPmin(x<tresholdCycle) = NaN;
TPD.dayGEPmax(x<tresholdCycle) = NaN;
TPD.eightGEP = AM_eight2cycle_rs(TPD.gep.*gC_m2_d1,TPD.dateloc,tresholdCycle,2,3);
TPD.eightGEP = AM_fill(TPD.eightGEP);
[TPD.weekGEP,~,~,~,~,TPD.week_stdGEP,TPD.week] = AM_week2cycle_rs(TPD.gep.*gC_m2_d1,TPD.dateloc,tresholdCycle,2,3);
TPD.weekGEP  = AM_fill(TPD.weekGEP);
[TPD.monthGEP,~,~,TPD.monthGEPmin,TPD.monthGEPmax] = AM_month2cycle(TPD.gep.*gC_m2_d1,TPD.dateloc,tresholdCycle,2,2);
TPD.monthGEP = AM_fill(TPD.monthGEP);

[TPD.dayRECO,~,x,~,~,TPD.dayRECOmin,TPD.dayRECOmax] = AM_day(TPD.reco.*gC_m2_d1,TPD.dateloc,0);
TPD.dayRECO(x<tresholdCycle) = NaN;                TPD.dayRECOmin(x<tresholdCycle) = NaN;
TPD.dayRECOmax(x<tresholdCycle) = NaN;
TPD.eightRECO = AM_eight2cycle_rs(TPD.reco.*gC_m2_d1,TPD.dateloc,tresholdCycle,2,3);
TPD.eightRECO = AM_fill(TPD.eightRECO);
[TPD.weekRECO,~,~,~,~,TPD.week_stdRECO,TPD.week] = AM_week2cycle_rs(TPD.reco.*gC_m2_d1,TPD.dateloc,tresholdCycle,2,3);
TPD.weekRECO  = AM_fill(TPD.weekRECO);
[TPD.monthRECO,~,~,TPD.monthRECOmin,TPD.monthRECOmax] = AM_month2cycle(TPD.reco.*gC_m2_d1,TPD.dateloc,tresholdCycle,2,2);
TPD.monthRECO = AM_fill(TPD.monthRECO);

[TPD.dayNEE,~,x,~,~,TPD.dayNEEmin,TPD.dayNEEmax] = AM_day(TPD.nee.*gC_m2_d1,TPD.dateloc,0);
TPD.dayNEE(x<tresholdCycle) = NaN;                                  TPD.dayNEEmin(x<tresholdCycle) = NaN;
TPD.dayNEEmax(x<tresholdCycle) = NaN;
TPD.eightNEE = AM_eight2cycle_rs(TPD.nee.*gC_m2_d1,TPD.dateloc,tresholdCycle,2,3);
TPD.eightNEE = AM_fill(TPD.eightNEE);
[TPD.weekNEE,~,~,~,~,TPD.week_stdNEE,TPD.week] = AM_week2cycle_rs(TPD.nee.*gC_m2_d1,TPD.dateloc,tresholdCycle,2,3);
TPD.weekNEE  = AM_fill(TPD.weekNEE);
[TPD.monthNEE,~,~,TPD.monthNEEmin,TPD.monthNEEmax] = AM_month2cycle(TPD.nee.*gC_m2_d1,TPD.dateloc,tresholdCycle,2,2);
TPD.monthNEE = AM_fill(TPD.monthNEE);
%% ...........................................
TPD.LEday = TPD.LE;             TPD.LEday(TPD.So<tresholdSo) = NaN;
TPD.Hday = TPD.H;               TPD.Hday(TPD.So<tresholdSo) = NaN;
TPD.netradday = TPD.netrad;     TPD.netradday(TPD.So<tresholdSo) = NaN;
TPD.tairday = TPD.tair;         TPD.tairday(TPD.So<tresholdSo) = NaN;
TPD.VPDday = TPD.VPD;         TPD.VPDday(TPD.So<tresholdSo) = NaN;
TPD.ustarday = TPD.ustar;     TPD.ustarday(TPD.So<tresholdSo);
TPD.EF = AM_fill(TPD.LE./(TPD.LE+TPD.H));
TPD.EFday = AM_fill(TPD.LE./(TPD.LE+TPD.H));         TPD.EFday(TPD.So<tresholdSo) = NaN;
TPD.EFday((TPD.EFday<0)|(TPD.EFday>1)) = NaN;   TPD.EFday = AM_rm_outlier(TPD.EFday,3);
TPD.Bowenday = TPD.Bowen;     TPD.Bowenday(TPD.So<tresholdSo);

[TPD.dayLEday,~,x,~,~,TPD.dayLEdaymin,TPD.dayLEdaymax] = AM_day(TPD.LEday,TPD.dateloc,0);
TPD.dayLEday(x<tresholdCycleDay) = NaN;        TPD.dayLEdaymin(x<tresholdCycleDay) = NaN;      TPD.dayLEdaymax(x<tresholdCycleDay) = NaN;
[TPD.dayHday,~,x,~,~,TPD.dayHdaymin,TPD.dayHdaymax] = AM_day(TPD.H,TPD.dateloc,0);
TPD.dayHday(x<tresholdCycleDay) = NaN;         TPD.dayHdaymin(x<tresholdCycleDay) = NaN;          TPD.dayHdaymax(x<tresholdCycleDay) = NaN;

[TPD.daynetradday,~,x,~,~,TPD.daynetraddaymin,TPD.daynetraddaymax] = AM_day(TPD.netradday,TPD.dateloc,0);
TPD.daynetradday(x<tresholdCycleDay) = NaN;    TPD.daynetraddaymin(x<tresholdCycleDay) = NaN; TPD.daynetraddaymax(x<tresholdCycleDay) = NaN;
[TPD.daytairday,~,x,~,~,TPD.daytairdaymin,TPD.daytairdaymax] = AM_day(TPD.tairday,TPD.dateloc,0);
TPD.daytairday(x<tresholdCycleDay) = NaN;      TPD.daytairdaymin(x<tresholdCycleDay) = NaN;         TPD.daytairdaymax(x<tresholdCycleDay) = NaN;
[TPD.dayVPDday,~,x,~,~,TPD.dayVPDdaymin,TPD.dayVPDdaymax] = AM_day(TPD.VPDday,TPD.dateloc,0);
TPD.dayVPDday(x<tresholdCycleDay) = NaN;      TPD.dayVPDdaymin(x<tresholdCycleDay) = NaN;         TPD.dayVPDdaymax(x<tresholdCycleDay) = NaN;

[TPD.eightHday,~,~,~,~,TPD.eight_stdHday,TPD.eight] = AM_eight2cycle_rs(TPD.Hday,TPD.dateloc,tresholdCycleDay,2,3);    TPD.eightHday = AM_fill(TPD.eightHday);
TPD.eightLEday = AM_eight2cycle_rs(TPD.LEday,TPD.dateloc,tresholdCycleDay,2,3);   TPD.eightLEday = AM_fill(TPD.eightLEday);
TPD.eightnetradday = AM_eight2cycle_rs(TPD.netradday,TPD.dateloc,tresholdCycleDay,2,3); TPD.eightnetradday = AM_fill(TPD.eightnetradday);
TPD.eighttairday = AM_eight2cycle_rs(TPD.tairday,TPD.dateloc,tresholdCycleDay,2,3);     TPD.eighttairday = AM_fill(TPD.eighttairday);
TPD.eightVPDday = AM_eight2cycle_rs(TPD.VPDday,TPD.dateloc,tresholdCycleDay,2,3);     TPD.eightVPDday = AM_fill(TPD.eightVPDday);

[TPD.weekHday,~,~,~,~,TPD.week_stdHday,TPD.week] = AM_week2cycle_rs(TPD.Hday,TPD.dateloc,tresholdCycleDay,2,3);        TPD.weekHday  = AM_fill(TPD.weekHday);
[TPD.weekLEday,~,~,~,~,TPD.week_stdLEday] = AM_week2cycle_rs(TPD.LEday,TPD.dateloc,tresholdCycleDay,2,3);                   TPD.weekLEday = AM_fill(TPD.weekLEday);
[TPD.weeknetradday,~,~,~,~,TPD.week_stdnetradday] = AM_week2cycle_rs(TPD.netradday,TPD.dateloc,tresholdCycleDay,2,3);  TPD.weeknetradday  = AM_fill(TPD.weeknetradday);
[TPD.weektairday,~,~,~,~,TPD.week_stdtairday] = AM_week2cycle_rs(TPD.tairday,TPD.dateloc,tresholdCycleDay,2,3);                 TPD.weektairday = AM_fill(TPD.weektairday);
[TPD.weekVPDday,~,~,~,~,TPD.week_stdVPDday] = AM_week2cycle_rs(TPD.VPDday,TPD.dateloc,tresholdCycleDay,2,3);                 TPD.weekVPDday = AM_fill(TPD.weekVPDday);
[TPD.weekustarday,~,~,~,~,TPD.week_stdustarday] = AM_week2cycle_rs(TPD.ustarday,TPD.dateloc,tresholdCycleDay,2,3);        TPD.weekustarday = AM_fill(TPD.weekustarday);
[TPD.weekBowen,~,~,~,~,TPD.week_stdBowen] = AM_week2cycle_rs(TPD.Bowen,TPD.dateloc,tresholdCycleDay,2,3);                TPD.weekBowen = AM_fill(TPD.weekBowen);
[TPD.weekEF,~,~,~,~,TPD.week_stdEF] = AM_week2cycle_rs(TPD.EF,TPD.dateloc,tresholdCycleDay,2,3); TPD.weekEF = AM_fill(TPD.weekEF);
[TPD.weekET,~,~,~,~,TPD.week_stdET] = AM_week2cycle_rs(TPD.ET,TPD.dateloc,tresholdCycleDay,2,3); TPD.weekET = AM_fill(TPD.weekET);
[TPD.weekETdry,~,~,~,~,TPD.week_stdETdry] = AM_week2cycle_rs(TPD.ETdry,TPD.dateloc,tresholdCycleDay,2,3);                     TPD.weekETdry = AM_fill(TPD.weekETdry);
[TPD.weekETdryday,~,~,~,~,TPD.week_stdETdryday] = AM_week2cycle_rs(TPD.ETdryday,TPD.dateloc,tresholdCycleDay,2,3);    TPD.weekETdryday = AM_fill(TPD.weekETdryday);
[TPD.weekGsPMmmol,~,~,~,~,TPD.week_stdGsPMmmol] = AM_week2cycle_rs(TPD.GsPMmmol,TPD.dateloc,tresholdCycleDay,2,3); TPD.weekGsPMmmol = AM_fill(TPD.weekGsPMmmol);
[TPD.weekLEdry,~,~,~,~,TPD.week_stdLEdry] = AM_week2cycle_rs(TPD.LEdry,TPD.dateloc,tresholdCycleDay,2,3);    TPD.weekLEdry = AM_fill(TPD.weekLEdry);
[TPD.weekEFday,~,~,~,~,TPD.week_stdEFday] = AM_week2cycle_rs(TPD.EFday,TPD.dateloc,tresholdCycleDay,2,3); TPD.weekEFday = AM_fill(TPD.weekEFday);
[TPD.weekBowenday,~,~,~,~,TPD.week_stdBowenday] = AM_week2cycle_rs(TPD.Bowenday,TPD.dateloc,tresholdCycleDay,2,3); TPD.weekBowenday = AM_fill(TPD.weekBowenday);

TPD.GEPday = TPD.gep;        TPD.GEPday(TPD.So<tresholdSo) = NaN;
[TPD.dayGEPday,~,x,~,~,TPD.dayGEPdaymin,TPD.dayGEPdaymax] = AM_day(TPD.GEPday,TPD.dateloc,0);
TPD.dayGEPday(x<tresholdCycleDay) = NaN;        TPD.dayGEPdaymin(x<tresholdCycleDay) = NaN;      TPD.dayGEPdaymax(x<tresholdCycleDay) = NaN;
TPD.eightGEPday = AM_eight2cycle_rs(TPD.GEPday,TPD.dateloc,tresholdCycleDay,2,3);   TPD.eightGEPday = AM_fill(TPD.eightGEPday);
[TPD.weekGEPday,~,~,~,~,TPD.week_stdGEPday] = AM_week2cycle_rs(TPD.GEPday,TPD.dateloc,tresholdCycleDay,2,3);       TPD.weekGEPday  = AM_fill(TPD.weekGEPday);
[TPD.monthGEPday,~,~,~,~,TPD.month_stdGEPday] = AM_month2cycle(TPD.GEPday,TPD.dateloc,tresholdCycleDay,2,3);       TPD.monthGEPday  = AM_fill(TPD.monthGEPday);

TPD.RECOday = TPD.reco;        TPD.RECOday(TPD.So<tresholdSo) = NaN;
[TPD.dayRECOday,~,x,~,~,TPD.dayRECOdaymin,TPD.dayRECOdaymax] = AM_day(TPD.RECOday,TPD.dateloc,0);
TPD.dayRECOday(x<tresholdCycleDay) = NaN;        TPD.dayRECOdaymin(x<tresholdCycleDay) = NaN;      TPD.dayRECOdaymax(x<tresholdCycleDay) = NaN;
TPD.eightRECOday = AM_eight2cycle_rs(TPD.RECOday,TPD.dateloc,tresholdCycleDay,2,3);   TPD.eightRECOday = AM_fill(TPD.eightRECOday);
[TPD.weekRECOday,~,~,~,~,TPD.week_stdRECOday] = AM_week2cycle_rs(TPD.RECOday,TPD.dateloc,tresholdCycleDay,2,3);       TPD.weekRECOday  = AM_fill(TPD.weekRECOday);
[TPD.monthRECOday,~,~,~,~,TPD.month_stdRECOday] = AM_month2cycle(TPD.RECOday,TPD.dateloc,tresholdCycleDay,2,3);       TPD.monthRECOday  = AM_fill(TPD.monthRECOday);

TPD.NEEday = TPD.nee;        TPD.NEEday(TPD.So<tresholdSo) = NaN;
[TPD.dayNEEday,~,x,~,~,TPD.dayNEEdaymin,TPD.dayNEEdaymax] = AM_day(TPD.NEEday,TPD.dateloc,0);
TPD.dayNEEday(x<tresholdCycleDay) = NaN;        TPD.dayNEEdaymin(x<tresholdCycleDay) = NaN;      TPD.dayNEEdaymax(x<tresholdCycleDay) = NaN;
TPD.eightNEEday = AM_eight2cycle_rs(TPD.NEEday,TPD.dateloc,tresholdCycleDay,2,3);   TPD.eightNEEday = AM_fill(TPD.eightNEEday);
[TPD.weekNEEday,~,~,~,~,TPD.week_stdNEEday] = AM_week2cycle_rs(TPD.NEEday,TPD.dateloc,tresholdCycleDay,2,3);       TPD.weekNEEday  = AM_fill(TPD.weekNEEday);
[TPD.monthNEEday,~,~,~,~,TPD.month_stdNEEday] = AM_month2cycle(TPD.NEEday,TPD.dateloc,tresholdCycleDay,2,3);       TPD.monthNEEday  = AM_fill(TPD.monthNEEday);

%%
[TPD.weekETref,~,~,~,~,TPD.week_stdETref] = AM_week2cycle_rs(TPD.ETref,TPD.dateloc,tresholdCycleDay,2,3);      TPD.weekETref = AM_fill(TPD.weekETref);
[TPD.weekGsPM,~,~,~,~,TPD.week_stdGsPM] = AM_week2cycle_rs(TPD.GsPM,TPD.dateloc,tresholdCycleDay,2,3);  TPD.weekGsPM = AM_fill(TPD.weekGsPM);
[TPD.weekGsPMmmol,~,~,~,~,TPD.week_stdGsPMmmol] = AM_week2cycle_rs(TPD.GsPMmmol,      TPD.dateloc,tresholdCycleDay,2,3); TPD.weekGsPMmmol = AM_fill(TPD.weekGsPMmmol);
[TPD.weekLEdry,~,~,~,~,TPD.week_stdLEdry] = AM_week2cycle_rs(TPD.LEdry,TPD.dateloc,tresholdCycleDay,2,3);    TPD.weekLEdry = AM_fill(TPD.weekLEdry);
[TPD.weekEFday,~,~,~,~,TPD.week_stdEFday] = AM_week2cycle_rs(TPD.EFday,TPD.dateloc,tresholdCycleDay,2,3); TPD.weekEFday = AM_fill(TPD.weekEFday);
[TPD.weekBowenday,~,~,~,~,TPD.week_stdBowenday] = AM_week2cycle_rs(TPD.Bowenday,TPD.dateloc,tresholdCycleDay,2,3); TPD.weekBowenday = AM_fill(TPD.weekBowenday);
% [TPD.weektairday,~,~,~,~,TPD.week_stdtairday] = AM_week2cycle_rs(TPD.tairday,TPD.dateloc,tresholdCycleDay,2,3); TPD.weektairday = AM_fill(TPD.weektairday);

[TPD.monthHday,~,~,TPD.monthHdaymin,TPD.monthHdaymax,~,TPD.month] = AM_month2cycle(TPD.Hday,TPD.dateloc,tresholdCycleDay,2,2);
TPD.monthHday = AM_fill(TPD.monthHday);
[TPD.monthLEday,~,~,TPD.monthLEdaymin,TPD.monthLEdaymax] = AM_month2cycle(TPD.LEday,TPD.dateloc,tresholdCycleDay,2,2);
TPD.monthLEday = AM_fill(TPD.monthLEday);
[TPD.monthnetradday,~,~,TPD.monthnetraddaymin,TPD.monthnetraddaymax] = AM_month2cycle(TPD.netradday,TPD.dateloc,tresholdCycleDay,2,2);
TPD.monthnetradday = AM_fill(TPD.monthnetradday);
[TPD.monthtairday,~,~,TPD.monthtairdaymin,TPD.monthtairdaymax] = AM_month2cycle(TPD.tairday,TPD.dateloc,tresholdCycleDay,2,2);
TPD.monthtairday = AM_fill(TPD.monthtairday);
[TPD.monthVPDday,~,~,TPD.monthVPDdaymin,TPD.monthVPDdaymax] = AM_month2cycle(TPD.VPDday,TPD.dateloc,tresholdCycleDay,2,2);
TPD.monthVPDday = AM_fill(TPD.monthVPDday);

[TPD.weekETrefPM,~,~,~,~,TPD.week_stdETrefPM]  = AM_week2cycle_rs(TPD.ETrefPM,TPD.dateloc,tresholdCycleDay,4,2);
TPD.weekETrefPM  = AM_fill(TPD.weekETrefPM);
[TPD.week_avgETrefPM,~,TPD.week_avgstdETrefPM] = AM_week2_avg(TPD.weekETrefPM,TPD.week);

[TPD.weekETrefdayPM,~,~,~,~,TPD.week_stdETrefdayPM]  = AM_week2cycle_rs(TPD.ETrefdayPM,TPD.dateloc,tresholdCycleDay,4,2);
TPD.weekETrefdayPM  = AM_fill(TPD.weekETrefdayPM);
[TPD.week_avgETrefdayPM,~,TPD.week_avgstdETrefdayPM] = AM_week2_avg(TPD.weekETrefdayPM,TPD.week);

TPD.eightGsPMall = AM_eight2cycle_rs(TPD.GsPMall,TPD.dateloc,tresholdCycleDay,2,3);    TPD.eightGsPMall = AM_fill(TPD.eightGsPMall);
[TPD.weekGsPMall,~,~,~,~,TPD.week_stdGsPMall] = AM_week2cycle_rs(TPD.GsPMall,TPD.dateloc,tresholdCycleDay,2,3);  TPD.weekGsPMall  = AM_fill(TPD.weekGsPMall);
[TPD.monthGsPMall,~,~,TPD.monthGsPMallmin,TPD.monthGsPMallmax] = AM_month2cycle(TPD.GsPMall,TPD.dateloc,tresholdCycleDay,2,2);
TPD.monthGsPMall = AM_fill(TPD.monthGsPMall);     TPD.monthGsPMallmax = AM_fill(TPD.monthGsPMallmax);
[TPD.dayGsPMall,~,x,~,~,TPD.dayGsPMallmin,TPD.dayGsPMallmax]   = AM_day(TPD.GsPMall,TPD.dateloc,0);
TPD.dayGsPMall(x<tresholdCycleDay) = NaN;         TPD.dayGsPMallmin(x<tresholdCycleDay) = NaN;        TPD.dayGsPMallmax(x<tresholdCycleDay) = NaN;

%..........................................................................
%% Seasonality
%..........................................................................
[TPD.week_avgHday,~,TPD.week_avgstdHday]   = AM_week2_avg(TPD.weekHday,TPD.week);
[TPD.week_avgLEday,~,TPD.week_avgstdLEday] = AM_week2_avg(TPD.weekLEday,TPD.week);
[TPD.week_avgnetradday,~,TPD.week_avgstdnetradday] = AM_week2_avg(TPD.weeknetradday,TPD.week);
[TPD.week_avgtairday,~,TPD.week_avgstdtairday] = AM_week2_avg(TPD.weektairday,TPD.week);
[TPD.week_avgVPDday,~,TPD.week_avgstdVPDday] = AM_week2_avg(TPD.weekVPDday,TPD.week);

[TPD.eight_avgLEday,~,TPD.eight_stdLEday] = AM_eight_avg(TPD.eightLEday,TPD.eight);
[TPD.eight_avgHday,~,TPD.eight_stdHday]   = AM_eight_avg(TPD.eightHday,TPD.eight);
[TPD.eight_avgnetradday,~,TPD.eight_stdnetradday] = AM_eight_avg(TPD.eightnetradday,TPD.eight);
[TPD.eight_avgtairday,~,TPD.eight_stdtairday] = AM_eight_avg(TPD.eighttairday,TPD.eight);
[TPD.eight_avgVPDday,~,TPD.eight_stdVPDday] = AM_eight_avg(TPD.eightVPDday,TPD.eight);

[TPD.month_avgLEday,TPD.month_avgstdLEday] = AM_month_avg(TPD.monthLEday,TPD.month);
[TPD.month_avgHday,TPD.month_avgstdHday]   = AM_month_avg(TPD.monthHday,TPD.month);
[TPD.month_avgnetradday,TPD.month_avgstdnetradday] = AM_month_avg(TPD.monthnetradday,TPD.month);
[TPD.month_avgtairday,TPD.month_avgstdtairday] = AM_month_avg(TPD.monthtairday,TPD.month);
[TPD.month_avgVPDday,TPD.month_avgstdVPDday] = AM_month_avg(TPD.monthVPDday,TPD.month);

[TPD.month_avgGEPday,TPD.month_avgstdGEPday] = AM_month_avg(TPD.monthGEPday,TPD.month);
[TPD.week_avgGEPday,~,TPD.week_avgstdGEPday] = AM_week2_avg(TPD.weekGEPday,TPD.week);
[TPD.eight_avgGEPday,~,TPD.eight_stdGEPday]  = AM_eight_avg(TPD.eightGEPday,TPD.eight);

[TPD.month_avgRECOday,TPD.month_avgstdRECOday] = AM_month_avg(TPD.monthRECOday,TPD.month);
[TPD.week_avgRECOday,~,TPD.week_avgstdRECOday] = AM_week2_avg(TPD.weekRECOday,TPD.week);
[TPD.eight_avgRECOday,~,TPD.eight_stdRECOday]  = AM_eight_avg(TPD.eightRECOday,TPD.eight);

[TPD.month_avgNEEday,TPD.month_avgstdNEEday] = AM_month_avg(TPD.monthNEEday,TPD.month);
[TPD.week_avgNEEday,~,TPD.week_avgstdNEEday]  = AM_week2_avg(TPD.weekNEEday,TPD.week);
[TPD.eight_avgNEEday,~,TPD.eight_stdNEEday]  = AM_eight_avg(TPD.eightNEEday,TPD.eight);

%..........................................................................
%% Seasonality
%..........................................................................
[TPD.week_avgustarday,~,TPD.week_avgstdustarday] = AM_week2_avg(TPD.weekustarday,TPD.week);
[TPD.week_avgBowen,~,TPD.week_avgstdBowen] = AM_week2_avg(TPD.weekBowen,TPD.week);
[TPD.week_avgEF,~,TPD.week_avgstdEF] = AM_week2_avg(TPD.weekEF,TPD.week);
[TPD.week_avgET,~,TPD.week_avgstdET] = AM_week2_avg(TPD.weekET,TPD.week);
[TPD.week_avgETref,~,TPD.week_avgstdETref] = AM_week2_avg(TPD.weekETref,TPD.week);
[TPD.week_avgGsPM,~,TPD.week_avgstdGsPM]       = AM_week2_avg(TPD.weekGsPM,TPD.week);
[TPD.week_avgGsPMall,~,TPD.week_avgstdGsPMall] = AM_week2_avg(TPD.weekGsPMall,TPD.week);
[TPD.week_avgETdry,~,TPD.week_avgstdETdry]       = AM_week2_avg(TPD.weekETdry,TPD.week);
[TPD.week_avgETdryday,~,TPD.week_avgstdETdryday] = AM_week2_avg(TPD.weekETdryday,TPD.week);
% [TPD.week_avgETref,~,TPD.week_avgstdETref]       = AM_week2_avg(TPD.weekETref,TPD.week);
% [TPD.week_avgETrefday,~,TPD.week_avgstdETrefday] = AM_week2_avg(TPD.weekETrefday,TPD.week);
[TPD.week_avgGsPMmmol,~,TPD.week_avgstdGsPMmmol] = AM_week2_avg(TPD.weekGsPMmmol,TPD.week);
[TPD.week_avgGsPM,~,TPD.week_avgstdGsPM] = AM_week2_avg(TPD.weekGsPM,TPD.week);
[TPD.week_avgGsPMall,~,TPD.week_avgstdGsPMall] = AM_week2_avg(TPD.weekGsPMall,TPD.week);
% [TPD.week_avgGiday,~,TPD.week_avgstdGiday] = AM_week2_avg(TPD.weekGiday,TPD.week);
[TPD.week_avgLEdry,~,TPD.week_avgstdLEdry] = AM_week2_avg(TPD.weekLEdry,TPD.week);
% [TPD.week_avgPTalphaday,~,TPD.week_avgstdPTalphaday] = AM_week2_avg(TPD.weekPTalphaday,TPD.week);
[TPD.week_avgVPDday,~,TPD.week_avgstdVPDday] = AM_week2_avg(TPD.weekVPDday,TPD.week);
[TPD.week_avgEFday,~,TPD.week_avgstdEFday]   = AM_week2_avg(TPD.weekEFday,TPD.week);
% [TPD.week_avgEFdaydry,~,TPD.week_avgstdEFdaydry] = AM_week2_avg(TPD.weekEFdaydry,TPD.week);
[TPD.week_avgBowenday,~,TPD.week_avgstdBowenday] = AM_week2_avg(TPD.weekBowenday,TPD.week);
% [TPD.week_avgH2O,~,TPD.week_avgstdH2O]   = AM_week2_avg(TPD.weekH2O,TPD.week);

% % % .........................................................................
% % %% Eight seasonality
% % % .........................................................................
% % [TPD.eight_avgBowen,~,TPD.eight_stdBowen] = AM_eight_avg(TPD.eightBowen,TPD.eight);
% % [TPD.eight_avgEF,~,TPD.eight_stdEF]       = AM_eight_avg(TPD.eightEF,TPD.eight);
% % [TPD.eight_avgET,~,TPD.eight_stdET]       = AM_eight_avg(TPD.eightET,TPD.eight);
% % [TPD.eight_avgGs,~,TPD.eight_stdGs]       = AM_eight_avg(TPD.eightGsPMall,TPD.eight);
% % [TPD.eight_avgGsPM,~,TPD.eight_stdGsPM]   = AM_eight_avg(TPD.eightGsPM,TPD.eight);
% % [TPD.month_avgGsPMall,TPD.month_avgstdGsPMall] = AM_month_avg(TPD.monthGsPMall,TPD.month);
% % [TPD.eight_avgETdry,~,TPD.eight_stdETdry] = AM_eight_avg(TPD.eightETdry,TPD.eight);
% % [TPD.eight_avgETdryday,~,TPD.eight_stdETdryday] = AM_eight_avg(TPD.eightETdryday,TPD.eight);
% % [TPD.eight_avgETref,~,TPD.eight_stdETref]       = AM_eight_avg(TPD.eightETref,TPD.eight);
% % [TPD.eight_avgGsPMmmol,~,TPD.eight_stdGsPMmmol] = AM_eight_avg(TPD.eightGsPMmmol,TPD.eight);
% % [TPD.eight_avgGsPMallmmol,~,TPD.eight_stdGsPMallmmol] = AM_eight_avg(TPD.eightGsPMallmmol,TPD.eight);
% % [TPD.eight_avgPTalphaday,~,TPD.eight_stdPTalphaday] = AM_eight_avg(TPD.eightPTalphaday,TPD.eight);
[TPD.eight_avgVPDday,~,TPD.eight_stdVPDday] = AM_eight_avg(TPD.eightVPDday,TPD.eight);
% % [TPD.eight_avgLEdry,~,TPD.eight_stdLEdry]   = AM_eight_avg(TPD.eightLEdry,TPD.eight);
% % [TPD.eight_avgH,~,TPD.eight_stdH]   = AM_eight_avg(TPD.eightH,TPD.eight);
% % [TPD.eight_avgLE,~,TPD.eight_stdLE] = AM_eight_avg(TPD.eightLE,TPD.eight);
% % [TPD.eight_avgGiday,~,TPD.eight_stdGiday] = AM_eight_avg(TPD.eightGiday,TPD.eight);
% % [TPD.eight_avgEFday,~,TPD.eight_stdEFday] = AM_eight_avg(TPD.eightEFday,TPD.eight);
% % [TPD.eight_avgEFdaydry,~,TPD.eight_stdEFdaydry] = AM_eight_avg(TPD.eightEFdaydry,TPD.eight);
% % [TPD.eight_avgBowenday,~,TPD.eight_stdBowenday] = AM_eight_avg(TPD.eightBowenday,TPD.eight);
% %
% % [TPD.month_avgBowen,TPD.month_avgstdBowen] = AM_month_avg(TPD.monthBowen,TPD.month);
% % [TPD.month_avgEF,TPD.month_avgstdEF] = AM_month_avg(TPD.monthEF,TPD.month);
% % [TPD.month_avgET,TPD.month_avgstdET] = AM_month_avg(TPD.monthET,TPD.month);
% % [TPD.month_avgGs,TPD.month_avgstdGs] = AM_month_avg(TPD.monthGsPMall,TPD.month);
% % [TPD.month_avgGsPMmmol,TPD.month_avgstdGsPMmmol] = AM_month_avg(TPD.monthGsPMmmol,TPD.month);
% % [TPD.month_avgGsPMallmmol,TPD.month_avgstdGsPMallmmol] = AM_month_avg(TPD.monthGsPMallmmol,TPD.month);
% % [TPD.month_avgGsPM,TPD.month_avgstdGsPM]   = AM_month_avg(TPD.monthGsPM,TPD.month);
% % [TPD.month_avgGsPMall,TPD.month_avgstdGsPMall]   = AM_month_avg(TPD.monthGsPMall,TPD.month);
% % [TPD.month_avgETdry,TPD.month_avgstdETdry]   = AM_month_avg(TPD.monthETdry,TPD.month);
% % [TPD.month_avgETdryday,TPD.month_avgstdETdryday] = AM_month_avg(TPD.monthETdryday,TPD.month);
% % [TPD.month_avgETref,TPD.month_avgstdETref]   = AM_month_avg(TPD.monthETref,TPD.month);
% % [TPD.month_avgETday,TPD.month_avgstdETday]   = AM_month_avg(TPD.monthETday,TPD.month);
% % [TPD.month_avgGiday,TPD.month_avgstdGiday]   = AM_month_avg(TPD.monthGiday,TPD.month);
% % [TPD.month_avgLEdry,TPD.month_avgstdLEdry]   = AM_month_avg(TPD.monthLEdry,TPD.month);
% % [TPD.month_avgPTalphaday,TPD.month_avgstdPTalphaday] = AM_month_avg(TPD.monthPTalphaday,TPD.month);
[TPD.month_avgVPDday,TPD.month_avgstdVPDday] = AM_month_avg(TPD.monthVPDday,TPD.month);
% % [TPD.month_avgEFday,TPD.month_avgstdEFday]   = AM_month_avg(TPD.monthEFday,TPD.month);
% % [TPD.month_avgEFdaydry,TPD.month_avgstdEFdaydry] = AM_month_avg(TPD.monthEFdaydry,TPD.month);
% % [TPD.month_avgBowenday,TPD.month_avgstdBowenday] = AM_month_avg(TPD.monthBowenday,TPD.month);
% %
% % ...................................................................................................................
% %% EB error
% % ...................................................................................................................
% TPD.StorageLEday      = TPD.StorageLE;            TPD.StorageLEday(TPD.So<=tresholdSo) = NaN;
% TPD.EphotosyntesisDay = TPD.Ephotosyntesis; TPD.EphotosyntesisDay(TPD.So<=tresholdSo) = NaN;
% TPD.StorageHeatDay    = TPD.StorageHeat;       TPD.StorageHeatday(TPD.So<=tresholdSo) = NaN;
% TPD.netradday         = TPD.netrad;                      TPD.netradday(TPD.So<=tresholdSo) = NaN;
%
TPD.par_day = TPD.par;   TPD.par_day(TPD.So<tresholdSo) = NaN;
[TPD.dayPAR,~,ix]      = AM_day(TPD.par,TPD.dateloc,0);         TPD.dayPAR(ix<21) = NaN;
[TPD.dayPARday,~,ix]   = AM_day(TPD.par_day,TPD.dateloc,0);     TPD.dayPARday(ix<6) = NaN;

TPD.eightPARday = AM_eight2cycle_rs(TPD.par_day,TPD.dateloc,tresholdCycleDay,4,2);
TPD.weekPARday = AM_week2cycle_rs(TPD.par_day,TPD.dateloc,tresholdCycleDay,4,2);
% [TPD.daynetradday,~,ix]= AM_day(TPD.netradday,TPD.dateloc,0);  TPD.daynetradday(ix<6) = NaN;
% [~,~,TPD.netradday_fill] = AM_compute_regression(TPD.par_day,TPD.netradday,[.6 .6 .6],1);
% [TPD.daynetradday_fill,~,ix]    = AM_day(TPD.netradday_fill,TPD.dateloc,0);            TPD.daynetradday_fill(ix<6) = NaN;
% [TPD.dayStorageHeatDay,~,ix]    = AM_day(TPD.StorageHeatDay,TPD.dateloc,0);  TPD.dayStorageHeatDay(ix<6) = NaN;
% [TPD.dayStorageLEday,~,ix]      = AM_day(TPD.StorageLEday,TPD.dateloc,0);        TPD.dayStorageLEday(ix<6) = NaN;
% [TPD.dayEphotosyntesisDay,~,ix] = AM_day(TPD.EphotosyntesisDay,TPD.dateloc,0);	TPD.dayEphotosyntesisDay(ix<6) = NaN;
%
% TPD.dayStorageLEday_fill = AM_fill_day_cycle(TPD.dayStorageLEday,TPD.day,6,18);
% TPD.dayEphotosyntesisDay_fill = AM_fill_day_cycle(TPD.dayEphotosyntesisDay,TPD.day,6,18);
%
% TPD.dayerrorday = TPD.daynetradday_fill - TPD.dayLEday - TPD.dayHday - TPD.dayStorageHeatDay - ...
%     TPD.dayStorageLEday_fill - TPD.dayEphotosyntesisDay_fill;
%
[TPD.recurrentLE,TPD.recurrent_stdLE] = AM_hourAVG_recurrent(TPD.LE,TPD.dateloc);
[TPD.recurrentET,TPD.recurrent_stdET] = AM_hourAVG_recurrent(TPD.ET,TPD.dateloc);
[TPD.day_recurrentLEday,TPD.day_recurrent_stdLEday] = AM_dayAVG_recurrent(TPD.dayLEday,TPD.daydate);
[TPD.recurrentLEday,TPD.recurrent_stdLEday] = AM_hourAVG_recurrent(TPD.LEday,TPD.dateloc);

TPD.recurrentH = AM_hourAVG_recurrent(TPD.H,TPD.dateloc);
TPD.day_recurrentHday = AM_dayAVG_recurrent(TPD.dayHday,TPD.daydate);

TPD.recurrentnetrad = AM_hourAVG_recurrent(TPD.netrad,TPD.dateloc);
TPD.day_recurrentnetradday = AM_dayAVG_recurrent(TPD.daynetradday,TPD.daydate);
TPD.recurrenttair = AM_hourAVG_recurrent(TPD.tair,TPD.dateloc);
TPD.day_recurrenttairday = AM_dayAVG_recurrent(TPD.daytairday,TPD.daydate);
TPD.recurrentVPD = AM_hourAVG_recurrent(TPD.VPD,TPD.dateloc);
TPD.day_recurrentVPDday = AM_dayAVG_recurrent(TPD.dayVPDday,TPD.daydate);

[TPD.dayY,TPD.dayM,TPD.dayD] = datevec(TPD.daydate);

figure
hold on
plot(TPD.week,TPD.weeknetradday);
plot(TPD.week,TPD.weekLEday);
plot(TPD.week,TPD.weekHday);

[TPD.recurrentGEP,TPD.recurrent_stdGEP] = AM_hourAVG_recurrent(TPD.gep,TPD.dateloc);
[TPD.day_recurrentGEP,TPD.day_recurrent_stdGEP] = AM_dayAVG_recurrent(TPD.dayGEP,TPD.daydate);
[TPD.recurrentGEP,TPD.recurrent_stdGEP] = AM_hourAVG_recurrent(TPD.gep,TPD.dateloc);
TPD.day_recurrentGEPGoley = sgolayfilt(TPD.day_recurrentGEP,polyorder,framesize);
TPD.dayGEP_zscore = (TPD.dayGEP - TPD.day_recurrentGEPGoley)./TPD.day_recurrent_stdGEP;

[TPD.day_recurrentGEPday,TPD.day_recurrent_stdGEPday] = AM_dayAVG_recurrent(TPD.dayGEPday,TPD.daydate);
[TPD.recurrentGEPday,TPD.recurrent_stdGEPday] = AM_hourAVG_recurrent(TPD.GEPday,TPD.dateloc);
TPD.day_recurrentGEPdayGoley = sgolayfilt(TPD.day_recurrentGEPday,polyorder,framesize);
TPD.dayGEPday_zscore = (TPD.dayGEPday - TPD.day_recurrentGEPdayGoley)./TPD.day_recurrent_stdGEPday;

[TPD.recurrentRECO,TPD.recurrent_stdRECO] = AM_hourAVG_recurrent(TPD.reco,TPD.dateloc);
[TPD.day_recurrentRECOday,TPD.day_recurrent_stdRECOday] = AM_dayAVG_recurrent(TPD.dayRECOday,TPD.daydate);
[TPD.recurrentRECOday,TPD.recurrent_stdRECOday] = AM_hourAVG_recurrent(TPD.RECOday,TPD.dateloc);
TPD.day_recurrentRECOdayGoley = sgolayfilt(TPD.day_recurrentRECOday,polyorder,framesize);
TPD.dayRECOday_zscore = (TPD.dayRECOday - TPD.day_recurrentRECOdayGoley)./TPD.day_recurrent_stdRECOday;

[TPD.recurrentNEE,TPD.recurrent_stdNEE] = AM_hourAVG_recurrent(TPD.nee,TPD.dateloc);
[TPD.day_recurrentNEEday,TPD.day_recurrent_stdNEEday] = AM_dayAVG_recurrent(TPD.dayNEEday,TPD.daydate);
[TPD.recurrentNEEday,TPD.recurrent_stdNEEday] = AM_hourAVG_recurrent(TPD.NEEday,TPD.dateloc);
TPD.day_recurrentNEEdayGoley = sgolayfilt(TPD.day_recurrentNEEday,polyorder,framesize);
TPD.dayNEEday_zscore = (TPD.dayNEEday - TPD.day_recurrentNEEdayGoley)./TPD.day_recurrent_stdNEEday;

%..........................................................................
%% PET
%..........................................................................
% no ground heat flux, originally (TPD.netrad - TPD.G)
TPD.PET = (0.408 .*TPD.delta .* TPD.netrad + TPD.sigma .* (900 ./ (TPD.tair + 273)) .* TPD.ws .* (TPD.e_sat - TPD.e)) ./....
    (TPD.delta + TPD.sigma .* (1 + 0.34 * TPD.ws));
TPD.PET = TPD.PET.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
TPD.PET(TPD.PET<0.2) = NaN;   TPD.PET(isinf(TPD.PET)) = NaN;

TPD.ETday = TPD.ET;                   TPD.ETday(TPD.So<tresholdSo) = NaN;
TPD.PETday = TPD.PET;                   TPD.PETday(TPD.So<tresholdSo) = NaN;
TPD.tairday = TPD.tair;                   TPD.tairday(TPD.So<tresholdSo) = NaN;
TPD.VPDday = TPD.VPD;                   TPD.VPDday(TPD.So<tresholdSo) = NaN;
TPD.netradday = TPD.netrad;        TPD.netradday(TPD.So<tresholdSo) = NaN;

[TPD.daytairday,~,x,~,~,TPD.daytairdaymin,TPD.daytairdaymax]   = AM_day(TPD.tairday,TPD.dateloc,0);
TPD.daytairday(x<6) = NaN;         TPD.daytairdaymin(x<6) = NaN;        TPD.daytairdaymax(x<6) = NaN;
[TPD.dayVPDday,~,x,~,~,TPD.dayVPDdaymin,TPD.dayVPDdaymax]   = AM_day(TPD.VPDday,TPD.dateloc,0);
TPD.dayVPDday(x<6) = NaN;         TPD.dayVPDdaymin(x<6) = NaN;        TPD.dayVPDdaymax(x<6) = NaN;
[TPD.dayETday,~,x,~,~,TPD.dayETdaymin,TPD.dayETdaymax]   = AM_day(TPD.ETday,TPD.dateloc,0);
TPD.dayETday(x<6) = NaN;         TPD.dayETdaymin(x<6) = NaN;        TPD.dayETdaymax(x<6) = NaN;
[TPD.day_recurrentETday,TPD.day_recurrent_stdETday] = AM_dayAVG_recurrent(TPD.dayETday,TPD.daydate);
[TPD.dayPETday,~,x,~,~,TPD.dayPETdaymin,TPD.dayPETdaymax]   = AM_day(TPD.PETday,TPD.dateloc,0);
TPD.dayPETday(x<6) = NaN;         TPD.dayPETdaymin(x<6) = NaN;        TPD.dayPETdaymax(x<6) = NaN;
[TPD.day_recurrentPETday,TPD.day_recurrent_stdPETday] = AM_dayAVG_recurrent(TPD.dayPETday,TPD.daydate);

%% .........................................................................................................
figure('color','white');
plot(EVI.dateloc,scaled250m16daysEVI.value_center); hold on
scaled250m16daysEVI.value_center(scaled250m16daysEVI.value_center<0.0) = NaN;
TPD.dayEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,TPD.daydate);
TPD.dayEVI(TPD.daytairdaymin<0) = NaN;
plot(TPD.daydate,TPD.dayEVI,'.')

TPD.eightEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,TPD.eight);
TPD.weekEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,TPD.week);
[TPD.day_recurrentEVI,TPD.day_recurrent_stdEVI] = AM_dayAVG_recurrent(TPD.dayEVI,TPD.daydate);

%% .........................................................................................................
figure('color','white');
plot(ROI.daydate,ROI.gcc_mean); hold on
% ROI.gcc(ROI.gcc<0.0) = NaN;
plot(ROI.daydate,ROI.gcc_50);       plot(ROI.daydate,ROI.gcc_75);

TPD.ROIgcc = interp1(ROI.daydate,ROI.gcc_mean,TPD.daydate);
% TPD.ROIgcc((TPD.So<tresholdSo)|(TPD.ROIgcc<0.36)) = NaN;
% plot(TPD.dateloc,TPD.ROIgcc,'.')

[TPD.weekROIgcc,~,~,~,TPD.weekROIgccmin,TPD.weekROIgccmax,TPD.weekROIgccstd,TPD.weekROI] = AM_week2day_rs(TPD.ROIgcc,TPD.daydate);
[TPD.eightROIgcc,~,~,~,TPD.eightROIgccmin,TPD.eightROIgccmax,TPD.eightROIgccstd,TPD.eightROI] = AM_eightday_rs(TPD.ROIgcc,TPD.daydate);
[TPD.day_recurrentROIgcc,TPD.day_recurrent_stdROIgcc] = AM_dayAVG_recurrent(TPD.ROIgcc,TPD.daydate);

TPD.ROIrcc = interp1(ROI.daydate,ROI.rcc_mean,TPD.daydate);
[TPD.weekROIrcc,~,~,~,TPD.weekROIrccmin,TPD.weekROIrccmax,TPD.weekROIrccstd,TPD.weekROI] = AM_week2day_rs(TPD.ROIrcc,TPD.daydate);
[TPD.eightROIrcc,~,~,~,TPD.eightROIrccmin,TPD.eightROIrccmax,TPD.eightROIrccstd,TPD.eightROI] = AM_eightday_rs(TPD.ROIrcc,TPD.daydate);
[TPD.day_recurrentROIrcc,TPD.day_recurrent_stdROIrcc] = AM_dayAVG_recurrent(TPD.ROIrcc,TPD.daydate);

%%
figure('color','white');
plot(ROI.daydate,ROI.rcc_mean); hold on
plot(ROI.daydate,ROI.rcc_50);       plot(ROI.daydate,ROI.rcc_75);
TPD.ROIrcc = interp1(ROI.daydate,ROI.rcc_mean,TPD.daydate);
[TPD.weekROIrcc,~,~,~,TPD.weekROIrccmin,TPD.weekROIrccmax,TPD.weekROIrccstd,TPD.weekROI] = AM_week2day_rs(TPD.ROIrcc,TPD.daydate);
[TPD.eightROIrcc,~,~,~,TPD.eightROIrccmin,TPD.eightROIrccmax,TPD.eightROIrccstd,TPD.eightROI] = AM_eightday_rs(TPD.ROIrcc,TPD.daydate);
[TPD.day_recurrentROIrcc,TPD.day_recurrent_stdROIrcc] = AM_dayAVG_recurrent(TPD.ROIrcc,TPD.daydate);

%%
TPD.ROIGRRI = interp1(ROI.daydate,ROI.GRRI_mean,TPD.daydate);
[TPD.weekROIGRRI,~,~,~,TPD.weekROIGRRImin,TPD.weekROIGRRImax,TPD.weekROIGRRIstd,TPD.weekROI] = AM_week2day_rs(TPD.ROIGRRI,TPD.daydate);
[TPD.eightROIGRRI,~,~,~,TPD.eightROIGRRImin,TPD.eightROIGRRImax,TPD.eightROIGRRIstd,TPD.eightROI] = AM_eightday_rs(TPD.ROIGRRI,TPD.daydate);
[TPD.day_recurrentROIGRRI,TPD.day_recurrent_stdROIGRRI] = AM_dayAVG_recurrent(TPD.ROIGRRI,TPD.daydate);

TPD.ROIGRIVI = interp1(ROI.daydate,ROI.GRIVI_mean,TPD.daydate);
[TPD.weekROIGRIVI,~,~,~,TPD.weekROIGRIVImin,TPD.weekROIGRIVImax,TPD.weekROIGRIVIstd,TPD.weekROI] = AM_week2day_rs(TPD.ROIGRIVI,TPD.daydate);
[TPD.eightROIGRIVI,~,~,~,TPD.eightROIGRIVImin,TPD.eightROIGRIVImax,TPD.eightROIGRIVIstd,TPD.eightROI] = AM_eightday_rs(TPD.ROIGRIVI,TPD.daydate);
[TPD.day_recurrentROIGRIVI,TPD.day_recurrent_stdROIGRIVI] = AM_dayAVG_recurrent(TPD.ROIGRIVI,TPD.daydate);

TPD.ROIexgreen = interp1(ROI.daydate,ROI.exgreen_mean,TPD.daydate);
[TPD.weekROIexgreen,~,~,~,TPD.weekROIexgreenmin,TPD.weekROIexgreenmax,TPD.weekROIexgreenstd,TPD.weekROI] = AM_week2day_rs(TPD.ROIexgreen,TPD.daydate);
[TPD.eightROIexgreen,~,~,~,TPD.eightROIexgreenmin,TPD.eightROIexgreenmax,TPD.eightROIexgreenstd,TPD.eightROI] = AM_eightday_rs(TPD.ROIexgreen,TPD.daydate);
[TPD.day_recurrentROIexgreen,TPD.day_recurrent_stdROIexgreen] = AM_dayAVG_recurrent(TPD.ROIexgreen,TPD.daydate);

TPD.ROIcci = interp1(ROI.daydate,ROI.cci_mean,TPD.daydate);
[TPD.weekROIcci,~,~,~,TPD.weekROIccimin,TPD.weekROIccimax,TPD.weekROIccistd,TPD.weekROI] = AM_week2day_rs(TPD.ROIcci,TPD.daydate);
[TPD.eightROIcci,~,~,~,TPD.eightROIccimin,TPD.eightROIccimax,TPD.eightROIccistd,TPD.eightROI] = AM_eightday_rs(TPD.ROIcci,TPD.daydate);
[TPD.day_recurrentROIcci,TPD.day_recurrent_stdROIcci] = AM_dayAVG_recurrent(TPD.ROIcci,TPD.daydate);

%%
figure('color','white');
plot(LAIsite.daydate,LAIsite.all_mean); hold on

LAIsite.all_mean(LAIsite.all_mean<0.0) = NaN;
TPD.dayLAI = interp1(LAIsite.daydate,LAIsite.all_mean,TPD.daydate);
% TPD.LAI((TPD.So<tresholdSo)|(TPD.LAI<0.36)) = NaN;
plot(TPD.daydate,TPD.dayLAI)

[TPD.dayLAIavg,~,~,~,~,TPD.dayLAImin,TPD.dayLAI]   = AM_day(TPD.dayLAI,TPD.daydate,0);
[TPD.day_recurrentLAI,TPD.day_recurrent_stdLAI] = AM_dayAVG_recurrent(TPD.dayLAI,TPD.daydate);
plot(TPD.daydate,TPD.day_recurrentLAI,'.')

TPD.dayLAIfill = TPD.dayLAI;      TPD.dayLAIfill(isnan(TPD.dayLAI)) = TPD.day_recurrentLAI(isnan(TPD.dayLAI));
TPD.LAI = interp1(TPD.daydate,TPD.dayLAI,TPD.dateloc);
[TPD.weekLAI,~,~,~,~,TPD.week_stdLAI]  = AM_week2cycle_rs(TPD.LAI,TPD.dateloc,tresholdCycleDay,4,2);
[TPD.week_avgLAI,~,TPD.week_avgstdLAI] = AM_week2_avg(TPD.weekLAI,TPD.week);

% .............................................
%% Extreme evaporation events
% .............................................
% Remove seasonality
% Seasonal Differencing (assuming yearly seasonality, s = 365)
if flag_ExtreameET==1
    TPD.LEdryday = TPD.LEdry;             TPD.LEdryday(TPD.So<tresholdSo) = NaN;
    [TPD.dayLEdryday,~,x,~,~,TPD.dayLEdrydaymin,TPD.dayLEdrydaymax] = AM_day(TPD.LEdryday,TPD.dateloc,0);
    TPD.dayLEdryday(x<6) = NaN;           TPD.dayLEdrydaymin(x<6) = NaN;        TPD.dayLEdrydaymax(x<6) = NaN;
    [TPD.day_recurrentLEdryday,TPD.day_recurrent_stdLEdryday] = AM_dayAVG_recurrent(TPD.dayLEdryday,TPD.daydate);

    TPD.day_recurrentLEdayGoley = sgolayfilt(TPD.day_recurrentLEday,polyorder,framesize);
    TPD.day_recurrentLEdrydayGoley = sgolayfilt(TPD.day_recurrentLEdryday,polyorder,framesize);
    TPD.JDday = day(TPD.daydate,'dayofyear');
    % TPD.dayLEdryday_deseasoned = TPD.dayLEdryday - TPD.day_recurrentLEdryday(TPD.JDday);
    % TPD.dayLEday_deseasoned = (TPD.dayLEday - TPD.day_recurrentLEdayGoley(TPD.JDday));
    TPD.dayLEday_zscore = (TPD.dayLEday - TPD.day_recurrentLEdayGoley)./TPD.day_recurrent_stdLEday;
    TPD.dayLEdryday_zscore = (TPD.dayLEdryday - TPD.day_recurrentLEdrydayGoley)./TPD.day_recurrent_stdLEdryday;

    figure('color','white','Position',[50 50 1800 400]);    hold on;
    plot(TPD.daydate,TPD.dayLEday);  plot(TPD.daydate,TPD.dayLEdryday);
    legend('days without rain in the previous 12 hours','dry days'); legend box off;
    ylabel('LE_{daytime}(W m^-^2)'); box on;
    figure('color','white');         plot(TPD.daydate,TPD.dayLEday_zscore);   hold on;
    plot(TPD.daydate, TPD.dayLEdryday_zscore);

    %% Fit an AR(1) model using arima function
    % Yt = c + φYt-1 + εt
    % where:
    % Yt is the value of the variable at time t
    % c is a constant (intercept)
    % φ (phi) is the autoregressive coefficient (how much the previous value influences the current value)
    % εt is a random error term (white noise) at time t
    % Stationarity: A crucial condition for an AR(1) model to be stable is that the absolute value of the autoregressive coefficient (φ) must be less than 1 (|φ| < 1). This ensures that the model doesn't explode into infinite values over time.
    % Interpreting the Autoregressive Coefficient (φ):
    % Magnitude: The magnitude of φ indicates the strength of the relationship between consecutive values. A value closer to 1 implies a strong positive relationship, while a value closer to -1 suggests a strong negative relationship.
    % Sign: The sign of φ reveals the direction of the relationship:
    % Positive φ: Indicates that Yt tends to move in the same direction as Yt-1.
    % Negative φ: Suggests that Yt tends to move in the opposite direction of Yt-1
    TPD.dayLEdayARIMAzvalue = NaN(length(TPD.daydate),1);                     TPD.dayLEdayARIMAzvalueResidual = NaN(length(TPD.daydate),1);
    TPD.dayLEdayARIMAzvalueconstant = NaN(length(TPD.daydate),1);       TPD.dayLEdayARIMAzvalueSE = NaN(length(TPD.daydate),1);

    TPD.dayLEdrydayARIMAzscore = NaN(length(TPD.daydate),1);                TPD.dayLEdrydayARIMAzvalueResidual = NaN(length(TPD.daydate),1);
    TPD.dayLEdrydayARIMAzscoreconstant = NaN(length(TPD.daydate),1);  TPD.dayLEdrydayARIMAzvalueSE = NaN(length(TPD.daydate),1);

    jet_color = gray(366);
    Mdl = arima(1,0,0); % AR(1) model

    ind = find(TPD.dayY>1900);  % all data
    Y = TPD.dayLEday_zscore(ind);       Z = TPD.dayLEdryday_zscore(ind);
    im = 10;
    % ARIMAtimeMTX = NaN(366,im);
    figure('color','white');
    for ik = im+1:length(Y)-im
        X = Y(ik-im:ik+im);               W = Z(ik-im:ik+im);
        % Create and estimate the AR(1) model
        if (length(X(~isnan(X)))>3)&(~isnan(Y(ik)))
            EstMdl = estimate(Mdl,X); % Estimate using the first 9 days
            TPD.dayLEdayARIMAzvalue(ik) = EstMdl.AR{1};
            TPD.dayLEdayARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', X);
            TPD.dayLEdayARIMAzvalue(ik) = YF(1);
            TPD.dayLEdayARIMAzvaluelSE(ik) = YMSE(1);
            TPD.dayLEdayARIMAzvalueResidual(ik) = YF(1)-X(im);
        end
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            EstMdl = estimate(Mdl, W); % Estimate using the first 9 days
            TPD.dayLEdrydayARIMAzvalue(ik) = EstMdl.AR{1};
            TPD.dayLEdrydayARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', W);
            TPD.dayLEdrydayARIMAzvalue(ik) = YF(1);
            TPD.dayLEdrydayARIMAzvalueSE(ik) = YMSE(1);
            TPD.dayLEdrydayARIMAzvalueResidual(ik) = YF(1)-W(im);

            % check
            % ARIMAtime = NaN(im,1);    ix = (1:im)';
            % for ij = 1:im-1
            %     Xtmp = X(im-ij:im);
            %     if length(Xtmp(~isnan(Xtmp)))>3
            %         EstMdlTMP = estimate(Mdl, Xtmp); % Estimate using the first 9 days
            %         ARIMAtime(ij) = EstMdlTMP.AR{1};
            %     end
            % end
            % % iy = ARIMAtime;
            % plot(ix,flipud(ARIMAtime),'-','color',jet_color(ik,:)); hold on;
            % ARIMAtimeMTX(ik,:) = flipud(ARIMAtime);
        end
    end
    % iz = mean(abs(ARIMAtimeMTX),'omitnan');
    % % iz = mean((ARIMAtimeMTX),'omitnan');
    % figure('color','white');hold on;
    % for ik=1:366
    %     plot(ix,fliplr(abs(ARIMAtimeMTX(ik,:))),'-','color',jet_color(ik,:)); hold on;
    %     % plot(ix,fliplr((ARIMAtimeMTX(ik,:))),'-','color',jet_color(ik,:)); hold on;
    % end
    % plot(ix,smooth(fliplr(iz)),'-k','lineWidth',2); hold on;
    % xlim([0 20]);
    % ylabel('AR{1}'); xlabel('number of days before'); grid on;   box on;

    % % Calculate the residuals as the difference between the observed data and the fitted values.

    %% Extreame value theory
    ind = find(TPD.daytairday<tresholdtair);
    TPD.dayLEdayGrowth = TPD.dayLEday;     TPD.dayLEdayGrowth(ind) = NaN;
    TPD.dayLEdayARIMAzvalueResidualGrowth = TPD.dayLEdayARIMAzvalueResidual;
    TPD.dayLEdayARIMAzvalueResidualGrowth(ind) = NaN;
    TPD.dayLEdayARIMAzvalueResidualGrowth(TPD.dayLEdayARIMAzvalueResidualGrowth<0) = NaN;
    figure('color','white');
    histogram(TPD.dayLEdayARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{growth season}')
    x = TPD.dayLEdayARIMAzvalueResidualGrowth;
    % Set a high threshold (you'll need to choose this carefully)
    thresholdARIMAzvalue = quantile(x, 0.95); % Example: 95th percentile

    % Find exceedances
    exceedancesARIMAzvalue = x(x > thresholdARIMAzvalue) - thresholdARIMAzvalue;

    % Fit a Generalized Pareto Distribution (GPD)
    % You'll need the Statistics and Machine Learning Toolbox for this
    pd = fitdist(exceedancesARIMAzvalue, 'GeneralizedPareto');

    % Analyze the fitted GPD
    % pd.k (shape parameter), pd.sigma (scale parameter), pd.theta (location parameter)
    % Use these parameters to estimate probabilities of extreme events

    % Example: Probability of exceeding an even higher level
    higher_levelARIMAzvalue = thresholdARIMAzvalue + 2 * std(x,'omitnan'); % Example: two standard deviations above threshold
    prob_exceedingARIMAzvalue = 1 - cdf(pd, higher_levelARIMAzvalue - thresholdARIMAzvalue);
    disp(['Probability of exceeding ' num2str(higher_levelARIMAzvalue) ': ' num2str(prob_exceedingARIMAzvalue)]);

    %% Plot the exceedances and the GPD fit (optional)
    figure('color','white');
    histogram(exceedancesARIMAzvalue,30, 'Normalization', 'pdf');
    hold on;
    x_gpd = linspace(min(exceedancesARIMAzvalue), max(exceedancesARIMAzvalue), 100);
    plot(x_gpd, pdf(pd, x_gpd), 'r-', 'LineWidth', 2);
    hold off;
    title('Exceedances and GPD Fit');
    xlabel('Exceedance Value');
    ylabel('Probability Density ARIMAzvalue');
    legend('Exceedances', 'GPD Fit');

    %% for the dry zvalue ...........................................................
    ind = find(TPD.daytairday<tresholdtair);
    TPD.dayLEdrydayARIMAzvalueResidualGrowth = TPD.dayLEdrydayARIMAzvalueResidual;
    TPD.dayLEdrydayARIMAzvalueResidualGrowth(ind) = NaN;
    TPD.dayLEdrydayARIMAzvalueResidualGrowth(TPD.dayLEdrydayARIMAzvalueResidualGrowth<0) = NaN;
    figure('color','white');
    histogram(TPD.dayLEdrydayARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{z-value growth season}')
    x = TPD.dayLEdrydayARIMAzvalueResidualGrowth;
    thresholdARIMAdryzvalue = quantile(x, 0.95); % Example: 95th percentile
    exceedancesARIMAdryzvalue = x(x > thresholdARIMAdryzvalue) - thresholdARIMAdryzvalue;
    pd = fitdist(exceedancesARIMAdryzvalue, 'GeneralizedPareto');
    higher_levelARIMAdryzvalue = thresholdARIMAdryzvalue + 2 * std(x,'omitnan'); % Example: two standard deviations above threshold
    prob_exceedingARIMAdryzvalue = 1 - cdf(pd, higher_levelARIMAdryzvalue - thresholdARIMAdryzvalue);
    disp(['Probability of exceeding ' num2str(higher_levelARIMAdryzvalue) ': ' num2str(prob_exceedingARIMAdryzvalue)]);
    figure('color','white');
    histogram(exceedancesARIMAdryzvalue,30, 'Normalization', 'pdf');                            hold on;
    x_gpd = linspace(min(exceedancesARIMAdryzvalue), max(exceedancesARIMAdryzvalue), 100);   plot(x_gpd, pdf(pd, x_gpd), 'r-', 'LineWidth', 2);
    hold off;  title('Exceedances and GPD Fit');        xlabel('Exceedance Value');          ylabel('Probability Density ARIMA LE_{dry} z-value');
    % legend('Exceedances', 'GPD Fit');

    %% Hurst Exponent
    TPD.dayLEdayHURSTzvalue    = NaN(length(TPD.daydate),1);
    TPD.dayLEdayHURSTdryzvalue = NaN(length(TPD.daydate),1);
    jet_color = gray(366);
    ind = find(TPD.dayY>1900);  % all data
    im = 10;
    Y = TPD.dayLEday_zscore(ind);       Z = TPD.dayLEdryday_zscore(ind);
    for ik = im+1:length(Y)-im
        X = Y(ik-im:ik+im);                W = Z(ik-im:ik+im);
        % Create and estimate the AR(1) model
        if (length(X(~isnan(X)))>3)&(~isnan(Y(ik)))
            meanValue = mean(X,'omitnan');
            deviations = X - meanValue;
            cumulativeDeviations = cumsum(deviations,'omitnan');
            R = max(cumulativeDeviations,[],'omitnan') - min(cumulativeDeviations,[],'omitnan');
            S = std(X,'omitnan');
            if S == 0  % Handle cases where standard deviation is zero
                H = NaN;
                return;
            end
            RS = R./ S;
            TPD.dayLEdayHURSTzvalue(ik) = RS;
        end
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            meanValue = mean(W,'omitnan');
            deviations = W - meanValue;
            cumulativeDeviations = cumsum(deviations,'omitnan');
            R = max(cumulativeDeviations,[],'omitnan') - min(cumulativeDeviations,[],'omitnan');
            S = std(W,'omitnan');
            if S == 0  % Handle cases where standard deviation is zero
                H = NaN;
                return;
            end
            RS = R./ S;
            TPD.dayLEdayHURSTdryzvalue(ik) = RS;
        end
    end
    % TPD.dayLEdayHURST(TPD.dayLEdayHURST<1) = NaN;

    % Plotting the Hurst Exponent over time (optional, but highly recommended)
    % long-term memory and fractal properties of a time series. Here's what the values mean:
    % H < 0.5: The time series is mean-reverting (it tends to revert to a long-term average).
    % H = 0.5: The time series is a random walk (no predictable patterns).
    % H > 0.5: The time series is persistent (it tends to follow trends).
    %%
    figure('color','white');
    plot(TPD.daydate, TPD.dayLEdayHURSTzvalue);  hold on
    plot(TPD.daydate, TPD.dayLEdayHURSTdryzvalue);
    xlabel('Time (Days)');
    ylabel('Hurst Exponent'); legend('ARIMA z-value','ARIMA LE_{daytime dry}')
    grid on;

    % .............................................
    %% Extreme greenup events
    % .............................................
    ind = find(TPD.daytairday<tresholdtair);
    TPD.dayROIgccGrowth = TPD.ROIgcc;     TPD.dayROIgccGrowth(ind) = NaN;

    % Remove seasonality
    [TPD.day_recurrentROIgcc,TPD.day_recurrent_stdROIgcc] = AM_dayAVG_recurrent(TPD.ROIgcc,TPD.daydate);

    polyorder = 2;     % Polynomial order (typically 2 or 3)
    framesize = 3;     % Window size (must be odd)
    TPD.day_recurrentROIgccGoley = sgolayfilt(TPD.day_recurrentROIgcc,polyorder,framesize);
    TPD.dayROIgcc_zscore = (TPD.ROIgcc - TPD.day_recurrentROIgccGoley)./TPD.day_recurrent_stdROIgcc;
    TPD.dayROIgcc_zscore(isinf(TPD.dayROIgcc_zscore)) = NaN;
    figure('color','white');                            plot(TPD.daydate,TPD.ROIgcc);   hold on;
    plot(TPD.daydate, TPD.dayROIgcc_zscore);

    % Fit an AR(1) model using arima function
    TPD.dayROIgccARIMAzscore = NaN(length(TPD.daydate),1);          TPD.dayROIgccARIMAzvalueResidual = NaN(length(TPD.daydate),1);
    TPD.dayROIgccARIMAzscoreconstant = NaN(length(TPD.daydate),1);  TPD.dayROIgccARIMAzvalueSE = NaN(length(TPD.daydate),1);
    jet_color = gray(366);
    Mdl = arima(1,0,0); % AR(1) model

    ind = find(TPD.dayY>1900);  % all data
    Z = TPD.dayROIgcc_zscore(ind);
    im = 10;
    figure('color','white');
    for ik = im+1:length(Y)-im
        W = Z(ik-im:ik+im);
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            EstMdl = estimate(Mdl, W); % Estimate using the first 9 days
            TPD.dayROIgccARIMAzvalue(ik) = EstMdl.AR{1};
            TPD.dayROIgccARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', W);
            TPD.dayROIgccARIMAzvalue(ik) = YF(1);
            TPD.dayROIgccARIMAzvalueSE(ik) = YMSE(1);
            TPD.dayROIgccARIMAzvalueResidual(ik) = YF(1)-W(im);
        end
    end
    % Extreame value theory
    ind = find(TPD.daytairday<tresholdtair);
    TPD.dayROIgccARIMAzvalueResidualGrowth = TPD.dayROIgccARIMAzvalueResidual;
    TPD.dayROIgccARIMAzvalueResidualGrowth(ind) = NaN;
    figure('color','white');
    histogram(TPD.dayROIgccARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{z-value growth season}')
    x = TPD.dayROIgccARIMAzvalueResidualGrowth;
    thresholdARIMAzvalue = quantile(x, 0.95); % Example: 95th percentile
    exceedancesARIMAzvalue = x(x > thresholdARIMAzvalue) - thresholdARIMAzvalue;
    pd = fitdist(exceedancesARIMAzvalue, 'GeneralizedPareto');
    higher_levelARIMAzvalue = thresholdARIMAzvalue + 2 * std(x,'omitnan'); % Example: two standard deviations above threshold
    prob_exceedingARIMAzvalue = 1 - cdf(pd, higher_levelARIMAzvalue - thresholdARIMAzvalue);
    disp(['Probability of exceeding ' num2str(higher_levelARIMAzvalue) ': ' num2str(prob_exceedingARIMAzvalue)]);
    figure('color','white');
    histogram(exceedancesARIMAzvalue, 'Normalization', 'pdf'); hold on;
    x_gpd = linspace(min(exceedancesARIMAzvalue,[],'omitnan'), max(exceedancesARIMAzvalue,[],'omitnan'), 100);
    plot(x_gpd, pdf(pd, x_gpd), 'r-', 'LineWidth', 2);    xlabel('Exceedance Value');
    hold off;  title('Exceedances and GPD Fit');          ylabel('Probability Density ARIMA z-value');

    % Hurst Exponent
    TPD.dayROIgccHURSTzvalue = NaN(length(TPD.daydate),1);
    jet_color = gray(366);
    ind = find(TPD.dayY>1900);  % all data
    im = 10;
    Z = TPD.dayROIgcc_zscore(ind);

    for ik = im+1:length(Y)-im
        W = Z(ik-im:ik+im);
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            meanValue = mean(W,'omitnan');
            deviations = W - meanValue;
            cumulativeDeviations = cumsum(deviations);
            R = max(cumulativeDeviations,[],'omitnan') - min(cumulativeDeviations,[],'omitnan');
            S = std(W,'omitnan');
            if S == 0  % Handle cases where standard deviation is zero
                H = NaN;
                return;
            end
            RS = R./ S;
            TPD.dayROIgccHURSTzvalue(ik) = RS;
        end
    end

    figure('color','white');
    plot(TPD.daydate, TPD.dayROIgccHURSTzvalue);  hold on
    xlabel('Time (Days)');
    ylabel('Hurst Exponent'); legend('ARIMA','ARIMA z-value')
    grid on;

end

%% .........................................................................
ind = find(TPD.daytairday<tresholdtair);
TPD.dayGEPdayGrowth = TPD.dayGEPday;           TPD.dayGEPdayGrowth(ind) = NaN;
TPD.dayRECOdayGrowth = TPD.dayRECOday;      TPD.dayRECOdayGrowth(ind) = NaN;
TPD.dayNEEdayGrowth = TPD.dayNEEday;            TPD.dayNEEdayGrowth(ind) = NaN;

TPD.dayGEPgrowth = TPD.dayGEP;        TPD.dayGEPgrowth(ind) = NaN;
TPD.dayRECOgrowth = TPD.dayRECO;      TPD.dayRECOgrowth(ind) = NaN;
TPD.dayNEEgrowth = TPD.dayNEE;        TPD.dayNEEgrowth(ind) = NaN;

polyorder = 2;      % Polynomial order (typically 2 or 3)
framesize = 9;     % Window size (must be odd)
TPD.dayGEPdayGoley = sgolayfilt(TPD.dayGEPday,polyorder,framesize);
TPD.dayGEPdayGrowthGoley = sgolayfilt(TPD.dayGEPdayGrowth,polyorder,framesize);

[TPD.monthY,TPD.monthM,TPD.monthD]= datevec(TPD.month);
% year_tick = unique(TPD.monthY);  year_tick = [year_tick;(year_tick(end)+1)];
% all_year_tick = (datetime(year_tick(1:4:end),1,1))';
[TPD.weekY,TPD.weekM,TPD.weekD] = datevec(TPD.week);
[TPD.eightY,TPD.eightM,TPD.eightD] = datevec(TPD.eight);

save('TPD.mat','TPD');
save('matlabTPD.mat');
