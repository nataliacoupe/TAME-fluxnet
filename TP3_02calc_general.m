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
% TP3.ws_fill = AM_rm_outlier(TP3.ws,4);
% TP3.ws_fill = AM_fill_month_cycle(TP3.ws_fill,TP3.dateloc,6,18);
% TP3.tc_fill   = AM_fill_day_cycle(TP3.tasp,TP3.dateloc,6,18);

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
TP3.e_sat   = 0.1.*(A0+TP3.tair.*(A1+TP3.tair.*(A2+TP3.tair.*(A3+TP3.tair.*(A4+TP3.tair.*(A5+TP3.tair*A6))))));
TP3.delta   = 4098*TP3.e_sat./((237.3+TP3.tair).^2);                % slope of vapor pressure curve, kPa/C
% TP3.h2o_gm3 =  (0.01802.*TP3.pambKpa)./((R.*TP3.tc_fill+T_0C_K).*((1./TP3.h2ommolm)+(0.01802/18)));

TP3.rho_a = (TP3.pambKpa./(0.28705*(TP3.tair+273.15))).*(1-(0.378*TP3.e_sat.*TP3.RH./TP3.pambKpa));
% TP3.rho_a = AM_fill_day_cycle(TP3.rho_a,TP3.dateloc,6,18);

% %'Calculate water vapor pressure using IRGASON measurements
% TP3.e     =  (TP3.h2omix.*(TP3.pambKpa./100)./(TP3.h2omix+622)).*10^2; % vapor pressure (mb) then x10^6
% TP3.e     =  AM_rm_outlier(TP3.e,3);
% TP3.RH    =  TP3.e./TP3.e_sat;
% ix        =  TP3.e_sat.*(1-TP3.RH./100);                                    % vapour pressure deficit;
% TP3.VPD   =  TP3.e_sat.*(1-TP3.RHec./100);
% TP3.VPD((TP3.VPD<0)|(isnan(TP3.VPD))) = ix((TP3.VPD<0)|(isnan(TP3.VPD)));
% TP3.VPD(TP3.VPD<0) = 0;
% TP3.VPD = AM_fill_month_cycle(TP3.VPD,TP3.dateloc,6,18);
% TP3.VPD((TP3.VPD<0)|(isinf(TP3.VPD))) = 0;
%
% TP3.rho_d =  (TP3.pambKpa-TP3.e)./((TP3.tc_fill+T_0C_K).*Rd);          % 'g/m^3
% %TP3.rho_a =  (TP3.rho_d + TP3.h2o_gm3)./1000;       %Natalia          % 'kg/m^3
%
% % % %..........................................................................
% TP3.e_sat_fill = AM_fill_day_cycle(TP3.e_sat,TP3.dateloc,6,18);
% TP3.rho_a = AM_fill_day_cycle(TP3.rho_a,TP3.dateloc,6,18);
% TP3.e_fill     = AM_fill_day_cycle(TP3.e,TP3.dateloc,6,18);
%
% % .........................................................................
TP3.lambda = (2.50*10^6)-((2.386*10^3).*(TP3.tair));                % 2.45 [MJ kg-1]     % Latent heat of vaporization, 2.45 [MJ kg-1],
TP3.lambda = TP3.lambda./10^6;
% % TP3.delta    =  (4098.*TP3.e_sat_fill)./(power((TP3.tc_fill+237.3),2)); %[kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% % http://agsys.cra-cin.it/tools/evapotranspiration/help/Slope_of_saturation_vapour_pressure_curve.html
% % TP3.delta   =  0.04145.*exp(0.06088.*TP3.tc_fill);              % 0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% TP3.delta   = 4098*TP3.e_sat_fill./((237.3+TP3.tc_fill).^2);      % slope of vapor pressure curve, kPa/C
TP3.sigma  = ((Cp.*TP3.pambKpa)./(0.622.*TP3.lambda));              % sigma psychrometric constant 0.054 [kPa C-1]
% %TP3.sigma   = smooth(TP3.sigma);
% %where epsilon ratio molecular weight of water vapour/dry air  =  0.622
% TP3.epsilon =  TP3.delta./TP3.sigma;                              % Unitless ~0.6219
% % Rho_air: mean air density at constant pressure (Bruutsaet,p38)(kPa kg J-1)
% % % if ((nanmax(TP3.rho_air)>2)|(nanmin(TP3.rho_air)<0.5));   '\rho air inacurate calculation please check';    end;
% % % c = 1.01;                                                     % virtual absolute air temperature Tv = (c.*(TP3.tc_fill+273.15)
% % % TP3.rho_air = TP3.pambpa./((c.*(TP3.tc_fill+273.15)).*R);     % multiply by 10 so we can get the 1.2value??? http://www.fao.org/docrep/x0490e/x0490e06.htm [kg m-3]
% % % Qa  =  0.62197.*TP3.e./((TP3.pambpa./100)-(0.378030.*TP3.e)); % specific humidity (kg/kg)
% % %..........................................................................
% % % 2002-2005
% % %..........................................................................
% % [TP3.h_So]     = AM_solar_rad(TP3.h_JD,TP3.h_HR+1,lat,lon);
% % TP3.h_delta    =  0.04145.*exp(0.06088.*TP3.h_tc_fill);                       %0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% % TP3.h_lambda(isnan(TP3.h_lambda)) = 2.45;
% % TP3.h_sigma    =  ((Cp.*TP3.h_pambKpa)./(0.622.*TP3.h_lambda));                    %[kPa C-1]
% % TP3.h_sigma    =  smooth(TP3.h_sigma);
%
% %..........................................................................
% %% ET ref
% %..........................................................................
% TP3.LEref = AM_fill((TP3.LE+TP3.H).*(TP3.delta./(TP3.delta+(TP3.sigma))));
% % TP3.LEref = AM_fill((TP3.netrad).*(TP3.delta./(TP3.delta+(TP3.sigma))));
% TP3.LEref((TP3.So < 500)|(TP3.rain_fill>0)) = NaN;
% TP3.ETref = AM_fill_plus(TP3.LEref./TP3.lambda);
% TP3.ETref = TP3.ETref.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
%
% %..........................................................................
% TP3.eightETref = AM_eight2cycle_rs(TP3.ETref,TP3.dateloc,tresholdCycleDay,4,2);    TP3.eightETref = AM_fill(TP3.eightETref);
% [TP3.weekETref,~,~,~,~,TP3.week_stdETref]  = AM_week2cycle_rs(TP3.ETref,TP3.dateloc,tresholdCycleDay,4,2);     TP3.weekETref  = AM_fill(TP3.weekETref);
% TP3.monthETref = AM_month2cycle(TP3.ETref,TP3.dateloc,tresholdCycleDay,4,2);       TP3.monthETref = AM_fill(TP3.monthETref);
% TP3.monthETref = AM_month2cycle(TP3.ETref,TP3.dateloc,tresholdCycleDay,4,2);                      TP3.monthETref  = AM_fill(TP3.monthETref);
% TP3.monthETref = TP3.monthETref.*eomday(TP3.monthY,TP3.monthM);
%
% TP3.ETrefday = TP3.ETref;      TP3.ETrefday(TP3.So<=tresholdSo) = NaN;
% [TP3.weekETrefday,~,~,~,~,TP3.week_stdETrefday]  = AM_week2cycle_rs(TP3.ETrefday,TP3.dateloc,tresholdCycleDay,4,2);     TP3.weekETrefday  = AM_fill(TP3.weekETrefday);
% [TP3.monthETrefday,~,~,~,~,TP3.month_stdETrefday]= AM_month2cycle(TP3.ETrefday,TP3.dateloc,tresholdCycleDay,4,2);     TP3.monthETrefday  = AM_fill(TP3.monthETrefday);
%
% TP3.LErefday = TP3.LEref;      TP3.LErefday(TP3.So<=tresholdSo) = NaN;
% [TP3.weekLErefday,~,~,~,~,TP3.week_stdLErefday]  = AM_week2cycle_rs(TP3.LErefday,TP3.dateloc,tresholdCycleDay,4,2);     TP3.weekLErefday  = AM_fill(TP3.weekLErefday);
%
% %..........................................................................
% %% Rain
% %..........................................................................
% [~,~,TP3.eightRain] = AM_eightday_rs(TP3.rain,TP3.dateloc);                         TP3.eightRain = AM_fill(TP3.eightRain);
% [~,~,TP3.weekRain,~,~,TP3.week_stdRain]  = AM_week2day_rs(TP3.rain,TP3.dateloc);    TP3.weekRain  = AM_fill(TP3.weekRain);
% [~,TP3.monthRain] = AM_month(TP3.rain,TP3.dateloc);                                 TP3.monthRain = AM_fill(TP3.monthRain);
[TP3.cycle_month_LE,TP3.cycle_month_countLE,~,TP3.cycle_month_stdLE] = ...
    AM_day_cycle_year(TP3.LE,TP3.dateloc);
[TP3.cycle_month_netrad,TP3.cycle_month_countnetrad,~,TP3.cycle_month_stdnetrad] = ...
    AM_day_cycle_year(TP3.netrad,TP3.dateloc);
[TP3.cycle_month_H,TP3.cycle_month_countH,~,TP3.cycle_month_stdH] = ...
    AM_day_cycle_year(TP3.H,TP3.dateloc);

% [TP3.week_avgRain,~,TP3.week_avgstdRain] = AM_week2_avg(TP3.weekRain,TP3.week);
%
% % % [TP3.eightCWD] = AM_eightday_rs(TP3.dayTRMM1hCWD,TP3.day);                            TP3.eightCWD = AM_fill(TP3.eightCWD);
% % % [TP3.weekCWD,~,~,~,~,TP3.week_stdCWD]  = AM_week2day_rs(TP3.dayTRMM1hCWD,TP3.day);    TP3.weekCWD  = AM_fill(TP3.weekCWD);
% % % [TP3.week_avgCWD,~,TP3.week_avgstdCWD] = AM_week2_avg(TP3.weekCWD,TP3.week);
%
% [TP3.eightCWD] = AM_eightday_rs(TP3.dayTRMM1hCWD,TP3.day);                            TP3.eightCWD = AM_fill(TP3.eightCWD);
% [TP3.weekCWD,~,~,~,~,TP3.week_stdCWD]  = AM_week2day_rs(TP3.dayTRMM1hCWD,TP3.day);    TP3.weekCWD  = AM_fill(TP3.weekCWD);
% [TP3.week_avgCWD,~,TP3.week_avgstdCWD] = AM_week2_avg(TP3.weekCWD,TP3.week);
%
% %% ........................................................................
% if flag_Rick == 1
%     ind = find((TP3.dateloc>datetime(2004,12,10))&(TP3.dateloc<datetime(2004,12,20)));
%     ind = find((TP3.dateloc>datetime(2004,8,24))&(TP3.dateloc<datetime(2004,9,7)));
%     figure('color','white');
%     y1 = -.2;     y2 = 1;       y3 = y1:((y2-y1)/4):y2;
%     x1 = 0;       x2 = 2;       x3 = x1:((x2-x1)/4):x2;
%     subplot(2,2,1:2);           hold on;
%     hl1 = bar(TP3.dateloc(ind),TP3.rain(ind)./10,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.8 0.8 0.8]);
%     hl3 = plot(TP3.dateloc(ind),TP3.ET(ind)./24,'Color',[0. 0. .9],'LineWidth',1);
%     hl4 = plot(TP3.dateloc(ind),TP3.ETref(ind)./24,'Color',[0. 0.9 .5],'LineWidth',1);
%     legend ([hl3,hl4],'ET','ET_{ref}','EdgeColor','white')%,'position','southoutside');
%     set(gca,'XTick',TP3.day(1:1:end),'XTickLabel',[ '' '' ''],'YTick',y3,'YColor',[0. 0. .9]); hold on;
%     xlim([TP3.dateloc(ind(1)) TP3.dateloc(ind(end))]);            ylim([y1 y2]);
%     ylabel ({'ET (mm)'},'FontSize',12,'Color',[0. 0. .9]);
%     ax1 = gca;          ax1_pos = ax1.Position;
%     ax2 = axes('Position',ax1_pos,'YAxisLocation','right','Color','none'); hold on;
%     %     hl7 = plot(TP3.dateloc(ind),TP3.tasp(ind),'Parent',ax2,'Color',[0.4 0.4 0.4],'LineWidth',1);    hold on;
%     hl7 = plot(TP3.dateloc(ind),TP3.ustar(ind),'Parent',ax2,'Color',[0.4 0.4 0.4],'LineWidth',1);    hold on;
%     set(ax2,'XColor','k','YColor',[ 0.0 0.0 0.0]);
%     %     ylabel ({'netrad (W m^-^2)'},'FontSize',12,'Color',[0.2 0.2 .2]);
%     %     ylabel ({'T_{air} (\circC)'},'FontSize',12,'Color',[0.4 0.4 .4]);
%     ylabel ({'u_* (m s^-^1)'},'FontSize',12,'Color',[0.4 0.4 .4]);
%     set(ax2,'XTick',TP3.dateloc(ind(1):48:ind(end)),'XTickLabel',datestr(TP3.dateloc(ind(1):48:ind(end)),'yyyy/mm/dd'),'YTick',x3,'YColor',[0.4 0.4 .4]);
%     xlim([TP3.dateloc(ind(1)) TP3.dateloc(ind(end))]);            ylim([x1 x2]);
%     box on; grid on;	text(TP3.dateloc(ind(20)),x3(5),site_name,'FontSize',8)
%
%     ind = find(TP3.So>100);
%     subplot(2,2,3);     hold on;
%     AM_bin(TP3.netrad(ind),TP3.LE(ind),15,1,1,[0 0 0.8]);
%     xlabel({'Rn (W m^-^2)'},'FontSize',10);ylabel ({'LE (W m^-^2)'},'FontSize',10);
%     [p,r2,~,~,sm,sb] = AM_compute_regression(TP3.netrad(ind),TP3.LE(ind),[0.4,0.4,0.4],0);
%     y_model=polyval(p,TP3.netrad(ind));   hold on;
%     plot(TP3.netrad(ind),y_model,'-','color',[0.4,0.4,0.4]);
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

TP3.A = (TP3.LE+TP3.H);
% weekA = AM_week2cycle_rs(TP3.A,TP3.dateloc,20);  weekH = AM_week2cycle_rs(TP3.H,TP3.dateloc,20);  weekLE = AM_week2cycle_rs(TP3.LE,TP3.dateloc,3);
%%
%         ACHTUNG!!!!!!!!!!!!!
% ik Yebra it apears as TP3.ga but looks like TP3.ra!!!!!!!!!!!
% TP3.ra =
% (log((height-d)./zo)).*(log((height-d)./zoh))./(k^2.*TP3.ws_fill);
% Natalia's original I use both zo and zoh
Ra        = (log((z-d)./zo)).*(log((z-d)./zoh))./(k.^2.*TP3.ws);
Ra(TP3.So<tresholdSo) = NaN;        Ra = AM_rm_outlier(Ra,5);
TP3.Ga        = 1./Ra;              TP3.Ga = AM_rm_outlier(TP3.Ga,5);
Ra_ustar  = TP3.ws./(TP3.ustar.^2);
Ra_ustar(TP3.So<tresholdSo) = NaN;	Ra_ustar = AM_rm_outlier(Ra_ustar,5);
Ga_ustar  = 1./Ra_ustar;            Ga_ustar = AM_rm_outlier(Ga_ustar,5);

%..........................................................................
%% PET from PM equation
%..........................................................................
% rho_a 1.2 kg m-3  Cp = 1.013 10-3 [MJ kg-1 C-1] > [J kg-1 k-1]   >>> delta [kPa m-2]
% lambda 2.45 [MJ kg-1]
% TP3.LErefPM = ((AM_fill((TP3.LE+TP3.H).*TP3.delta)+(TP3.rho_a.*Cp.*10^6.*TP3.VPD.*TP3.Ga)))./(TP3.delta+TP3.sigma);
TP3.LErefPM = ((AM_fill((TP3.netrad).*TP3.delta)+(TP3.rho_a.*Cp.*10^6.*TP3.VPD.*TP3.Ga)))./(TP3.delta+TP3.sigma);
TP3.ETrefPM = TP3.LErefPM./TP3.lambda;
TP3.ETrefPM = TP3.ETrefPM.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
TP3.ETrefdayPM = TP3.ETrefPM;      TP3.ETrefdayPM(TP3.So<=tresholdSo) = NaN;

% lambda    =  2.45;                                                                 % [MJ kg-1] FAO latent heat of vaporization of water
TP3.lambda = ((2.50*10^6)-((2.386*10^3).*(TP3.tair)))./10^6; % 2.45 [MJ kg-1]     % Latent heat of vaporization, 2.45 [MJ kg-1],

TP3.ET = TP3.LE./TP3.lambda;
TP3.ET = TP3.ET.*60.*60.*24/1000000;      % from s-1 to d-1 and from kg-1 to g-1 (mm)

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
TP3.e      = TP3.RH.*TP3.e_sat./100;

% TP3.delta =  (4098.*TP3.e_sat_fill)./(power((TP3.tc_fill+237.3),2));  %[kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% http://agsys.cra-cin.it/tools/evapotranspiration/help/Slope_of_saturation_vapour_pressure_curve.html
% TP3.delta =  0.04145.*exp(0.06088.*TP3.tc_fill);     % 0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
TP3.delta = 4098*TP3.e_sat./((237.3+TP3.tair).^2);     % slope of vapor pressure curve, kPa/C

TP3.sigma = ((Cp.*TP3.pambKpa)./(0.622.*TP3.lambda));  % sigma psychrometric constant 0.054 [kPa C-1]
%TP3.sigma   = smooth(TP3.sigma);
%where epsilon ratio molecular weight of water vapour/dry air  =  0.622
TP3.epsilon =  TP3.delta./TP3.sigma;                   % Unitless ~0.6219

TP3.ET = TP3.LE./TP3.lambda;
TP3.ET = TP3.ET.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)

% %..........................................................................
% %% ET dry conditions
% %..........................................................................
% ik = find(TP3.rain_fill>0);
% ij = zeros(length(TP3.rain_fill),1);
% ij(ik) = 1;                         indDry24 = ij;           im = 1;
% while im < length(ij)-25
%     if ij(im) == 1
%         for in = 1:24
%             indDry24(im+in) = 1;
%         end
%     end
%     im = im + 1;
% end
% TP3.LEdry24 = TP3.LE;             TP3.ETdry24 = TP3.ET;
% TP3.LEdry24(indDry24==1) = NaN;     TP3.ETdry24(indDry24==1) = NaN;
% TP3.ETdryday24 = TP3.ETdry24;     TP3.ETdryday24(TP3.So<tresholdSo) = NaN;
%
% TP3.ETrefdry24 = TP3.ETref;           TP3.ETrefdry24(indDry24==1) = NaN;
% TP3.ETrefdryday24 = TP3.ETrefdry24;   TP3.ETrefdryday24(TP3.So<tresholdSo) = NaN;
%
% TP3.LEwet24 = TP3.LE;               TP3.ETwet24 = TP3.ET;
% TP3.LEwet24(indDry24==0) = NaN;     TP3.ETwet24(indDry24==0) = NaN;
% TP3.ETwetday24 = TP3.ETwet24;       TP3.ETwetday24(TP3.So<tresholdSo) = NaN;
%
% TP3.ETrefwet24 = TP3.ETref;         TP3.ETrefwet24(indDry24==0) = NaN;
% TP3.ETrefwetday24 = TP3.ETrefwet24; TP3.ETrefwetday24(TP3.So<tresholdSo) = NaN;
%
%..........................................................................
%% ET dry conditions
%..........................................................................
% Remove 12h after precipitation
ik = find(TP3.rain>0);
ij = zeros(length(TP3.rain),1);
ij(ik) = 1;                         indDry = ij;           im = 1;
while im < length(ij)-13
    if ij(im) == 1
        for in = 1:12
            indDry(im+in) = 1;
        end
    end
    im = im + 1;
end
TP3.LEdry = TP3.LE;             TP3.ETdry = TP3.ET;
TP3.LEdry(indDry==1) = NaN;     TP3.ETdry(indDry==1) = NaN;
TP3.ETdryday = TP3.ETdry;       TP3.ETdryday(TP3.So<tresholdSo) = NaN;

% TP3.ETrefdry = TP3.ETref;       TP3.ETrefdry(indDry==1) = NaN;
% TP3.ETrefdryday = TP3.ETrefdry; TP3.ETrefdryday(TP3.So<tresholdSo) = NaN;

TP3.LEwet = TP3.LE;             TP3.ETwet = TP3.ET;
TP3.LEwet(indDry==0) = NaN;     TP3.ETwet(indDry==0) = NaN;
TP3.ETwetday = TP3.ETwet;       TP3.ETwetday(TP3.So<tresholdSo) = NaN;

% TP3.ETrefwet = TP3.ETref;         TP3.ETrefwet(indDry==0) = NaN;
% TP3.ETrefwetday = TP3.ETrefwet;   TP3.ETrefwetday(TP3.So<tresholdSo) = NaN;

ix = TP3.HR.*indDry; ix(indDry==0) = NaN;
figure ('color','white');       histogram(ix,24);
ylabel('Frequency time rainfall');
xlabel('Local time rainfall TP3');

%..................................................................
%%         As in Yebra
%..................................................................
A   = TP3.LE+TP3.H;
% A   = TP3.netrad;       ix = TP3.LE+TP3.H;              A(isnan(A)) = ix(isnan(A));
one = TP3.epsilon.*A;   two = (TP3.epsilon+1).*TP3.LE;	three = TP3.rho_a.*10^6.*Cp.*(TP3.e_sat-TP3.e).*TP3.Ga./TP3.sigma;
Gs_OptionY = TP3.LE.*TP3.Ga./(one-two+three);
Gs_OptionY = Gs_OptionY.*1000;              %m s-1 to mm s-1
Gs_OptionY((Gs_OptionY<=0)|(Gs_OptionY>200)) = NaN;
Gs_OptionY((TP3.So<tresholdSo)|(TP3.rain>0)) = NaN;         Gs_OptionY = AM_rm_outlier(Gs_OptionY,3);
%..................................................................
one = TP3.epsilon.*A;   two = (TP3.epsilon+1).*TP3.LE;
three = TP3.rho_a.*10^6.*Cp.*(TP3.e_sat-TP3.e).*Ga_ustar./TP3.sigma;    three = AM_rm_outlier(three,3);
Gs_OptionYustar = TP3.LE.*Ga_ustar./(one-two+three);
Gs_OptionYustar = Gs_OptionYustar.*1000;    %m s-1 to mm s-1
Gs_OptionYustar((Gs_OptionYustar<=0)|(Gs_OptionYustar>1000)) = NaN;
Gs_OptionYustar((TP3.So<tresholdSo)|(TP3.rain>0)) = NaN;    Gs_OptionYustar = AM_rm_outlier(Gs_OptionYustar,3);

%..................................................................
%%         As in Blanken & Black, 2004
%..................................................................
TP3.Bowen   = TP3.H./TP3.LE;
Rs_OptionBB = (((TP3.epsilon.*TP3.Bowen)-1).*Ra)+((TP3.rho_a.*Cp.*10^6.*TP3.VPD)./(TP3.sigma.*TP3.LE));
Gs_OptionBB = 1000./Rs_OptionBB;
Gs_OptionBB((Gs_OptionBB<=0)|(Gs_OptionBB>400)) = NaN;
Gs_OptionBB((TP3.So<tresholdSo)|(TP3.rain>0)) = NaN;        Gs_OptionBB = AM_rm_outlier(Gs_OptionBB,3);

Rs_OptionBB_ustar = (((TP3.epsilon.*TP3.Bowen)-1).*Ra_ustar)+((TP3.rho_a.*Cp.*10^6.*TP3.VPD)./(TP3.sigma.*TP3.LE));
Gs_OptionBB_ustar = 1000./Rs_OptionBB_ustar;
Gs_OptionBB_ustar((Gs_OptionBB_ustar<=0)|(Gs_OptionBB_ustar>200)) = NaN;
Gs_OptionBB_ustar((TP3.So<tresholdSo)|(TP3.rain>0)) = NaN;	Gs_OptionBB_ustar = AM_rm_outlier(Gs_OptionBB_ustar,3);

% .........................................................................
TP3.BowenDry = TP3.H./TP3.LEdry;
Rs_OptionBBdry = (((TP3.epsilon.*TP3.BowenDry)-1).*Ra)+((TP3.rho_a.*Cp.*10^6.*TP3.VPD)./(TP3.sigma.*TP3.LEdry));
Gs_OptionBBdry = 1000./Rs_OptionBBdry;
Gs_OptionBBdry((Gs_OptionBBdry<=0)|(Gs_OptionBBdry>400)) = NaN;
Gs_OptionBBdry((TP3.So<tresholdSo)|(TP3.rain>0)) = NaN;     Gs_OptionBBdry = AM_rm_outlier(Gs_OptionBBdry,3);

Rs_OptionBBdry_ustar = (((TP3.epsilon.*TP3.BowenDry)-1).*Ra_ustar)+((TP3.rho_a.*Cp.*10^6.*TP3.VPD)./(TP3.sigma.*TP3.LEdry));
Gs_OptionBBdry_ustar = 1000./Rs_OptionBBdry_ustar;
Gs_OptionBBdry_ustar((Gs_OptionBBdry_ustar<=0)|(Gs_OptionBBdry_ustar>200)) = NaN;
Gs_OptionBBdry_ustar((TP3.So<tresholdSo)|(TP3.rain>0)) = NaN;
Gs_OptionBBdry_ustar = AM_rm_outlier(Gs_OptionBBdry_ustar,3);

% %..................................................................
% % Climatological resistance
% %..................................................................
% TP3.Ri = (TP3.rho_a.*Cp.*10^6.*TP3.VPD)./(TP3.sigma.*(TP3.LE+TP3.H));
% %TP3.Ri = (TP3.rho_a.*Cp.*10^6.*TP3.VPD)./(TP3.sigma.*(TP3.netrad));
% TP3.Gi = 1000./TP3.Ri;
% TP3.Gi(TP3.So<tresholdSo) = NaN;        TP3.Gi(TP3.Gi<0) = NaN;
% TP3.Gi = AM_rm_outlier(TP3.Gi,3);
%
% % Equilibrium LE
% TP3.PTalpha = TP3.LE./TP3.LEref;

% .........................................................................
%% Gs units mm s-1
% .........................................................................
TP3.GsPMall   = Gs_OptionBB;
TP3.GsPM      = Gs_OptionBBdry;
TP3.GsPMustar = Gs_OptionBB_ustar;

% From Pearcy et all. Measurement of transpiration and leaf conductance
% P in kPa, tair in degC, Gs from cm/s to mol m-2s-1
% TP3.GsPMallmol = TP3.GsPMall.*0.446.*(273./(273+TP3.tasp_fill)).*((TP3.pambpa_fill./1000)./101.3);

% Gas ideal gas law Gs [m s-1] x Pa[kPa]/R [m3 Pa K-1 mol] x Ta [k]   % average sea-level pressure is 101.325 kPa
% R = 8.3144621 m3 Pa K−1 mol−1   8.3144621 m3 /1000 kPa-1 K-1 mol
% Gs mol m-2 s-1
TP3.GsPMmmol = (TP3.GsPM./1000).*TP3.pambKpa./(R.*(273+TP3.tair));
TP3.GsPMmmol = TP3.GsPMmmol.*1000;
% Typical values for irrigated trials are: 300-700 mmol m-2s-1;
% and for mildly water stressed trials are: 80-300 mmol m-2s-1
TP3.GsPMallmmol = (TP3.GsPMall./1000).*(TP3.pambpa./1000)./(R.*(273+TP3.tair));
TP3.GsPMallmmol = TP3.GsPMallmmol.*1000;

% ........................................................................
%% ETref
% ........................................................................
TP3.LEref = AM_fill((TP3.LE+TP3.H).*(TP3.delta./(TP3.delta+(TP3.sigma))));
% TP3.LEref = AM_fill((TP3.netrad).*(TP3.delta./(TP3.delta+(TP3.sigma))));
TP3.LEref(TP3.So < tresholdSo) = NaN;
TP3.ETref = AM_fill_plus(TP3.LEref./TP3.lambda);
TP3.ETref = TP3.ETref.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)

% ........................................................................
%% day
% ........................................................................
[TP3.dayLE,~,x,~,TP3.daydate,TP3.dayLEmin,TP3.dayLEmax]   = AM_day(TP3.LE,TP3.dateloc,0);
TP3.dayLE(x<tresholdCycle) = NaN;         TP3.dayLEmin(x<tresholdCycle) = NaN;        TP3.dayLEmax(x<tresholdCycle) = NaN;
[TP3.dayH,~,x,~,~,TP3.dayHmin,TP3.dayHmax]   = AM_day(TP3.H,TP3.dateloc,0);
TP3.dayH(x<tresholdCycle) = NaN;         TP3.dayHmin(x<tresholdCycle) = NaN;        TP3.dayHmax(x<tresholdCycle) = NaN;
[TP3.daynetrad,~,x,~,~,TP3.daynetradmin,TP3.daynetradmax]   = AM_day(TP3.netrad,TP3.dateloc,0);
TP3.daynetrad(x<tresholdCycle) = NaN;         TP3.daynetradmin(x<tresholdCycle) = NaN;        TP3.daynetradmax(x<tresholdCycle) = NaN;
[TP3.daytair,~,x,~,~,TP3.daytairmin,TP3.daytairmax]   = AM_day(TP3.tair,TP3.dateloc,0);
TP3.daytair(x<tresholdCycle) = NaN;         TP3.daytairmin(x<tresholdCycle) = NaN;        TP3.daytairmax(x<tresholdCycle) = NaN;

[TP3.eightH,~,~,~,~,TP3.eight_stdH,TP3.eight] = AM_eight2cycle_rs(TP3.H,TP3.dateloc,tresholdCycle,2,3);    TP3.eightH = AM_fill(TP3.eightH);
TP3.eightLE = AM_eight2cycle_rs(TP3.LE,TP3.dateloc,tresholdCycle,2,3);    TP3.eightLE = AM_fill(TP3.eightLE);
TP3.eightnetrad = AM_eight2cycle_rs(TP3.netrad,TP3.dateloc,tresholdCycle,2,3);    TP3.eightnetrad = AM_fill(TP3.eightnetrad);
TP3.eighttair = AM_eight2cycle_rs(TP3.tair,TP3.dateloc,tresholdCycle,2,3);    TP3.eighttair = AM_fill(TP3.eighttair);

[TP3.weekH,~,~,~,~,TP3.week_stdH] = AM_week2cycle_rs(TP3.H,TP3.dateloc,tresholdCycle,2,3);  TP3.weekH  = AM_fill(TP3.weekH);
[TP3.weekLE,~,~,~,~,TP3.week_stdLE] = AM_week2cycle_rs(TP3.LE,TP3.dateloc,tresholdCycle,2,3);  TP3.weekLE  = AM_fill(TP3.weekLE);
[TP3.weeknetrad,~,~,~,~,TP3.week_stdnetrad] = AM_week2cycle_rs(TP3.netrad,TP3.dateloc,tresholdCycle,2,3);  TP3.weeknetrad  = AM_fill(TP3.weeknetrad);
[TP3.weektair,~,~,~,~,TP3.week_stdtair] = AM_week2cycle_rs(TP3.tair,TP3.dateloc,tresholdCycle,2,3);  TP3.weektair  = AM_fill(TP3.weektair);

[TP3.monthH,~,~,TP3.monthHmin,TP3.monthHmax] = AM_month2cycle(TP3.H,TP3.dateloc,tresholdCycle,2,2);
TP3.monthH = AM_fill(TP3.monthH);
[TP3.monthLE,~,~,TP3.monthLEmin,TP3.monthLEmax] = AM_month2cycle(TP3.LE,TP3.dateloc,tresholdCycle,2,2);
TP3.monthLE = AM_fill(TP3.monthLE);
[TP3.monthnetrad,~,~,TP3.monthnetradmin,TP3.monthnetradmax] = AM_month2cycle(TP3.netrad,TP3.dateloc,tresholdCycle,2,2);
TP3.monthnetrad = AM_fill(TP3.monthnetrad);
[TP3.monthtair,~,~,TP3.monthtairmin,TP3.monthtairmax] = AM_month2cycle(TP3.tair,TP3.dateloc,tresholdCycle,2,2);
TP3.monthtair = AM_fill(TP3.monthtair);

[TP3.dayGEP,~,x,~,~,TP3.dayGEPmin,TP3.dayGEPmax] = AM_day(TP3.gep.*gC_m2_d1,TP3.dateloc,0);
TP3.dayGEP(x<tresholdCycle) = NaN;                 TP3.dayGEPmin(x<tresholdCycle) = NaN;
TP3.dayGEPmax(x<tresholdCycle) = NaN;
TP3.eightGEP = AM_eight2cycle_rs(TP3.gep.*gC_m2_d1,TP3.dateloc,tresholdCycle,2,3);
TP3.eightGEP = AM_fill(TP3.eightGEP);
[TP3.weekGEP,~,~,~,~,TP3.week_stdGEP,TP3.week] = AM_week2cycle_rs(TP3.gep.*gC_m2_d1,TP3.dateloc,tresholdCycle,2,3);
TP3.weekGEP  = AM_fill(TP3.weekGEP);
[TP3.monthGEP,~,~,TP3.monthGEPmin,TP3.monthGEPmax] = AM_month2cycle(TP3.gep.*gC_m2_d1,TP3.dateloc,tresholdCycle,2,2);
TP3.monthGEP = AM_fill(TP3.monthGEP);

[TP3.dayRECO,~,x,~,~,TP3.dayRECOmin,TP3.dayRECOmax] = AM_day(TP3.reco.*gC_m2_d1,TP3.dateloc,0);
TP3.dayRECO(x<tresholdCycle) = NaN;                TP3.dayRECOmin(x<tresholdCycle) = NaN;
TP3.dayRECOmax(x<tresholdCycle) = NaN;
TP3.eightRECO = AM_eight2cycle_rs(TP3.reco.*gC_m2_d1,TP3.dateloc,tresholdCycle,2,3);
TP3.eightRECO = AM_fill(TP3.eightRECO);
[TP3.weekRECO,~,~,~,~,TP3.week_stdRECO,TP3.week] = AM_week2cycle_rs(TP3.reco.*gC_m2_d1,TP3.dateloc,tresholdCycle,2,3);
TP3.weekRECO  = AM_fill(TP3.weekRECO);
[TP3.monthRECO,~,~,TP3.monthRECOmin,TP3.monthRECOmax] = AM_month2cycle(TP3.reco.*gC_m2_d1,TP3.dateloc,tresholdCycle,2,2);
TP3.monthRECO = AM_fill(TP3.monthRECO);

[TP3.dayNEE,~,x,~,~,TP3.dayNEEmin,TP3.dayNEEmax] = AM_day(TP3.nee.*gC_m2_d1,TP3.dateloc,0);
TP3.dayNEE(x<tresholdCycle) = NaN;                                  TP3.dayNEEmin(x<tresholdCycle) = NaN;
TP3.dayNEEmax(x<tresholdCycle) = NaN;
TP3.eightNEE = AM_eight2cycle_rs(TP3.nee.*gC_m2_d1,TP3.dateloc,tresholdCycle,2,3);
TP3.eightNEE = AM_fill(TP3.eightNEE);
[TP3.weekNEE,~,~,~,~,TP3.week_stdNEE,TP3.week] = AM_week2cycle_rs(TP3.nee.*gC_m2_d1,TP3.dateloc,tresholdCycle,2,3);
TP3.weekNEE  = AM_fill(TP3.weekNEE);
[TP3.monthNEE,~,~,TP3.monthNEEmin,TP3.monthNEEmax] = AM_month2cycle(TP3.nee.*gC_m2_d1,TP3.dateloc,tresholdCycle,2,2);
TP3.monthNEE = AM_fill(TP3.monthNEE);
%% ...........................................
TP3.LEday = TP3.LE;             TP3.LEday(TP3.So<tresholdSo) = NaN;
TP3.Hday = TP3.H;               TP3.Hday(TP3.So<tresholdSo) = NaN;
TP3.netradday = TP3.netrad;     TP3.netradday(TP3.So<tresholdSo) = NaN;
TP3.tairday = TP3.tair;         TP3.tairday(TP3.So<tresholdSo) = NaN;
TP3.ustarday = TP3.ustar;     TP3.ustarday(TP3.So<tresholdSo);
TP3.EF = AM_fill(TP3.LE./(TP3.LE+TP3.H));
TP3.EFday = AM_fill(TP3.LE./(TP3.LE+TP3.H));         TP3.EFday(TP3.So<tresholdSo) = NaN;
TP3.EFday((TP3.EFday<0)|(TP3.EFday>1)) = NaN;   TP3.EFday = AM_rm_outlier(TP3.EFday,3);
TP3.Bowenday = TP3.Bowen;     TP3.Bowenday(TP3.So<tresholdSo);

[TP3.dayLEday,~,x,~,~,TP3.dayLEdaymin,TP3.dayLEdaymax] = AM_day(TP3.LEday,TP3.dateloc,0);
TP3.dayLEday(x<tresholdCycleDay) = NaN;        TP3.dayLEdaymin(x<tresholdCycleDay) = NaN;      TP3.dayLEdaymax(x<tresholdCycleDay) = NaN;
[TP3.dayHday,~,x,~,~,TP3.dayHdaymin,TP3.dayHdaymax] = AM_day(TP3.H,TP3.dateloc,0);
TP3.dayHday(x<tresholdCycleDay) = NaN;         TP3.dayHdaymin(x<tresholdCycleDay) = NaN;          TP3.dayHdaymax(x<tresholdCycleDay) = NaN;
[TP3.daynetradday,~,x,~,~,TP3.daynetraddaymin,TP3.daynetraddaymax] = AM_day(TP3.netradday,TP3.dateloc,0);
TP3.daynetradday(x<tresholdCycleDay) = NaN;    TP3.daynetraddaymin(x<tresholdCycleDay) = NaN; TP3.daynetraddaymax(x<tresholdCycleDay) = NaN;
[TP3.daytairday,~,x,~,~,TP3.daytairdaymin,TP3.daytairdaymax] = AM_day(TP3.tairday,TP3.dateloc,0);
TP3.daytairday(x<tresholdCycleDay) = NaN;      TP3.daytairdaymin(x<tresholdCycleDay) = NaN;         TP3.daytairdaymax(x<tresholdCycleDay) = NaN;

[TP3.eightHday,~,~,~,~,TP3.eight_stdHday,TP3.eight] = AM_eight2cycle_rs(TP3.Hday,TP3.dateloc,tresholdCycleDay,2,3);    TP3.eightHday = AM_fill(TP3.eightHday);
TP3.eightLEday = AM_eight2cycle_rs(TP3.LEday,TP3.dateloc,tresholdCycleDay,2,3);   TP3.eightLEday = AM_fill(TP3.eightLEday);
TP3.eightnetradday = AM_eight2cycle_rs(TP3.netradday,TP3.dateloc,tresholdCycleDay,2,3); TP3.eightnetradday = AM_fill(TP3.eightnetradday);
TP3.eighttairday = AM_eight2cycle_rs(TP3.tairday,TP3.dateloc,tresholdCycleDay,2,3);     TP3.eighttairday = AM_fill(TP3.eighttairday);

[TP3.weekHday,~,~,~,~,TP3.week_stdHday,TP3.week] = AM_week2cycle_rs(TP3.Hday,TP3.dateloc,tresholdCycleDay,2,3);        TP3.weekHday  = AM_fill(TP3.weekHday);
[TP3.weekLEday,~,~,~,~,TP3.week_stdLEday] = AM_week2cycle_rs(TP3.LEday,TP3.dateloc,tresholdCycleDay,2,3);                   TP3.weekLEday = AM_fill(TP3.weekLEday);
[TP3.weeknetradday,~,~,~,~,TP3.week_stdnetradday] = AM_week2cycle_rs(TP3.netradday,TP3.dateloc,tresholdCycleDay,2,3);  TP3.weeknetradday  = AM_fill(TP3.weeknetradday);
[TP3.weektairday,~,~,~,~,TP3.week_stdtairday] = AM_week2cycle_rs(TP3.tairday,TP3.dateloc,tresholdCycleDay,2,3);                 TP3.weektairday = AM_fill(TP3.weektairday);
[TP3.weekustarday,~,~,~,~,TP3.week_stdustarday] = AM_week2cycle_rs(TP3.ustarday,TP3.dateloc,tresholdCycleDay,2,3);        TP3.weekustarday = AM_fill(TP3.weekustarday);
[TP3.weekBowen,~,~,~,~,TP3.week_stdBowen] = AM_week2cycle_rs(TP3.Bowen,TP3.dateloc,tresholdCycleDay,2,3);                TP3.weekBowen = AM_fill(TP3.weekBowen);
[TP3.weekEF,~,~,~,~,TP3.week_stdEF] = AM_week2cycle_rs(TP3.EF,TP3.dateloc,tresholdCycleDay,2,3); TP3.weekEF = AM_fill(TP3.weekEF);
[TP3.weekET,~,~,~,~,TP3.week_stdET] = AM_week2cycle_rs(TP3.ET,TP3.dateloc,tresholdCycleDay,2,3); TP3.weekET = AM_fill(TP3.weekET);
[TP3.weekETdry,~,~,~,~,TP3.week_stdETdry] = AM_week2cycle_rs(TP3.ETdry,TP3.dateloc,tresholdCycleDay,2,3);                     TP3.weekETdry = AM_fill(TP3.weekETdry);
[TP3.weekETdryday,~,~,~,~,TP3.week_stdETdryday] = AM_week2cycle_rs(TP3.ETdryday,TP3.dateloc,tresholdCycleDay,2,3);    TP3.weekETdryday = AM_fill(TP3.weekETdryday);
[TP3.weekGsPMmmol,~,~,~,~,TP3.week_stdGsPMmmol] = AM_week2cycle_rs(TP3.GsPMmmol,TP3.dateloc,tresholdCycleDay,2,3); TP3.weekGsPMmmol = AM_fill(TP3.weekGsPMmmol);
[TP3.weekLEdry,~,~,~,~,TP3.week_stdLEdry] = AM_week2cycle_rs(TP3.LEdry,TP3.dateloc,tresholdCycleDay,2,3);    TP3.weekLEdry = AM_fill(TP3.weekLEdry);
[TP3.weekEFday,~,~,~,~,TP3.week_stdEFday] = AM_week2cycle_rs(TP3.EFday,TP3.dateloc,tresholdCycleDay,2,3); TP3.weekEFday = AM_fill(TP3.weekEFday);
[TP3.weekBowenday,~,~,~,~,TP3.week_stdBowenday] = AM_week2cycle_rs(TP3.Bowenday,TP3.dateloc,tresholdCycleDay,2,3); TP3.weekBowenday = AM_fill(TP3.weekBowenday);

TP3.GEPday = TP3.gep;        TP3.GEPday(TP3.So<tresholdSo) = NaN;
[TP3.dayGEPday,~,x,~,~,TP3.dayGEPdaymin,TP3.dayGEPdaymax] = AM_day(TP3.GEPday,TP3.dateloc,0);
TP3.dayGEPday(x<tresholdCycleDay) = NaN;        TP3.dayGEPdaymin(x<tresholdCycleDay) = NaN;      TP3.dayGEPdaymax(x<tresholdCycleDay) = NaN;
TP3.eightGEPday = AM_eight2cycle_rs(TP3.GEPday,TP3.dateloc,tresholdCycleDay,2,3);   TP3.eightGEPday = AM_fill(TP3.eightGEPday);
[TP3.weekGEPday,~,~,~,~,TP3.week_stdGEPday] = AM_week2cycle_rs(TP3.GEPday,TP3.dateloc,tresholdCycleDay,2,3);       TP3.weekGEPday  = AM_fill(TP3.weekGEPday);
[TP3.monthGEPday,~,~,~,~,TP3.month_stdGEPday] = AM_month2cycle(TP3.GEPday,TP3.dateloc,tresholdCycleDay,2,3);       TP3.monthGEPday  = AM_fill(TP3.monthGEPday);

TP3.RECOday = TP3.reco;        TP3.RECOday(TP3.So<tresholdSo) = NaN;
[TP3.dayRECOday,~,x,~,~,TP3.dayRECOdaymin,TP3.dayRECOdaymax] = AM_day(TP3.RECOday,TP3.dateloc,0);
TP3.dayRECOday(x<tresholdCycleDay) = NaN;        TP3.dayRECOdaymin(x<tresholdCycleDay) = NaN;      TP3.dayRECOdaymax(x<tresholdCycleDay) = NaN;
TP3.eightRECOday = AM_eight2cycle_rs(TP3.RECOday,TP3.dateloc,tresholdCycleDay,2,3);   TP3.eightRECOday = AM_fill(TP3.eightRECOday);
[TP3.weekRECOday,~,~,~,~,TP3.week_stdRECOday] = AM_week2cycle_rs(TP3.RECOday,TP3.dateloc,tresholdCycleDay,2,3);       TP3.weekRECOday  = AM_fill(TP3.weekRECOday);
[TP3.monthRECOday,~,~,~,~,TP3.month_stdRECOday] = AM_month2cycle(TP3.RECOday,TP3.dateloc,tresholdCycleDay,2,3);       TP3.monthRECOday  = AM_fill(TP3.monthRECOday);

TP3.NEEday = TP3.nee;        TP3.NEEday(TP3.So<tresholdSo) = NaN;
[TP3.dayNEEday,~,x,~,~,TP3.dayNEEdaymin,TP3.dayNEEdaymax] = AM_day(TP3.NEEday,TP3.dateloc,0);
TP3.dayNEEday(x<tresholdCycleDay) = NaN;        TP3.dayNEEdaymin(x<tresholdCycleDay) = NaN;      TP3.dayNEEdaymax(x<tresholdCycleDay) = NaN;
TP3.eightNEEday = AM_eight2cycle_rs(TP3.NEEday,TP3.dateloc,tresholdCycleDay,2,3);   TP3.eightNEEday = AM_fill(TP3.eightNEEday);
[TP3.weekNEEday,~,~,~,~,TP3.week_stdNEEday] = AM_week2cycle_rs(TP3.NEEday,TP3.dateloc,tresholdCycleDay,2,3);       TP3.weekNEEday  = AM_fill(TP3.weekNEEday);
[TP3.monthNEEday,~,~,~,~,TP3.month_stdNEEday] = AM_month2cycle(TP3.NEEday,TP3.dateloc,tresholdCycleDay,2,3);       TP3.monthNEEday  = AM_fill(TP3.monthNEEday);

%%
[TP3.weekETref,~,~,~,~,TP3.week_stdETref] = AM_week2cycle_rs(TP3.ETref,TP3.dateloc,tresholdCycleDay,2,3);      TP3.weekETref = AM_fill(TP3.weekETref);
[TP3.weekGsPM,~,~,~,~,TP3.week_stdGsPM] = AM_week2cycle_rs(TP3.GsPM,TP3.dateloc,tresholdCycleDay,2,3);  TP3.weekGsPM = AM_fill(TP3.weekGsPM);
[TP3.weekGsPMmmol,~,~,~,~,TP3.week_stdGsPMmmol] = AM_week2cycle_rs(TP3.GsPMmmol,      TP3.dateloc,tresholdCycleDay,2,3); TP3.weekGsPMmmol = AM_fill(TP3.weekGsPMmmol);
[TP3.weekLEdry,~,~,~,~,TP3.week_stdLEdry] = AM_week2cycle_rs(TP3.LEdry,TP3.dateloc,tresholdCycleDay,2,3);    TP3.weekLEdry = AM_fill(TP3.weekLEdry);
[TP3.weekEFday,~,~,~,~,TP3.week_stdEFday] = AM_week2cycle_rs(TP3.EFday,TP3.dateloc,tresholdCycleDay,2,3); TP3.weekEFday = AM_fill(TP3.weekEFday);
[TP3.weekBowenday,~,~,~,~,TP3.week_stdBowenday] = AM_week2cycle_rs(TP3.Bowenday,TP3.dateloc,tresholdCycleDay,2,3); TP3.weekBowenday = AM_fill(TP3.weekBowenday);
% [TP3.weektairday,~,~,~,~,TP3.week_stdtairday] = AM_week2cycle_rs(TP3.tairday,TP3.dateloc,tresholdCycleDay,2,3); TP3.weektairday = AM_fill(TP3.weektairday);

[TP3.monthHday,~,~,TP3.monthHdaymin,TP3.monthHdaymax,~,TP3.month] = AM_month2cycle(TP3.Hday,TP3.dateloc,tresholdCycleDay,2,2);
TP3.monthHday = AM_fill(TP3.monthHday);
[TP3.monthLEday,~,~,TP3.monthLEdaymin,TP3.monthLEdaymax] = AM_month2cycle(TP3.LEday,TP3.dateloc,tresholdCycleDay,2,2);
TP3.monthLEday = AM_fill(TP3.monthLEday);
[TP3.monthnetradday,~,~,TP3.monthnetraddaymin,TP3.monthnetraddaymax] = AM_month2cycle(TP3.netradday,TP3.dateloc,tresholdCycleDay,2,2);
TP3.monthnetradday = AM_fill(TP3.monthnetradday);
[TP3.monthtairday,~,~,TP3.monthtairdaymin,TP3.monthtairdaymax] = AM_month2cycle(TP3.tairday,TP3.dateloc,tresholdCycleDay,2,2);
TP3.monthtairday = AM_fill(TP3.monthtairday);

[TP3.weekETrefPM,~,~,~,~,TP3.week_stdETrefPM]  = AM_week2cycle_rs(TP3.ETrefPM,TP3.dateloc,tresholdCycleDay,4,2);
TP3.weekETrefPM  = AM_fill(TP3.weekETrefPM);
[TP3.week_avgETrefPM,~,TP3.week_avgstdETrefPM] = AM_week2_avg(TP3.weekETrefPM,TP3.week);

[TP3.weekETrefdayPM,~,~,~,~,TP3.week_stdETrefdayPM]  = AM_week2cycle_rs(TP3.ETrefdayPM,TP3.dateloc,tresholdCycleDay,4,2);
TP3.weekETrefdayPM  = AM_fill(TP3.weekETrefdayPM);
[TP3.week_avgETrefdayPM,~,TP3.week_avgstdETrefdayPM] = AM_week2_avg(TP3.weekETrefdayPM,TP3.week);

TP3.eightGsPMall = AM_eight2cycle_rs(TP3.GsPMall,TP3.dateloc,tresholdCycleDay,2,3);    TP3.eightGsPMall = AM_fill(TP3.eightGsPMall);
[TP3.weekGsPMall,~,~,~,~,TP3.week_stdGsPMall] = AM_week2cycle_rs(TP3.GsPMall,TP3.dateloc,tresholdCycleDay,2,3);  TP3.weekGsPMall  = AM_fill(TP3.weekGsPMall);
[TP3.monthGsPMall,~,~,TP3.monthGsPMallmin,TP3.monthGsPMallmax] = AM_month2cycle(TP3.GsPMall,TP3.dateloc,tresholdCycleDay,2,2);
TP3.monthGsPMall = AM_fill(TP3.monthGsPMall);     TP3.monthGsPMallmax = AM_fill(TP3.monthGsPMallmax);
[TP3.dayGsPMall,~,x,~,~,TP3.dayGsPMallmin,TP3.dayGsPMallmax]   = AM_day(TP3.GsPMall,TP3.dateloc,0);
TP3.dayGsPMall(x<tresholdCycleDay) = NaN;         TP3.dayGsPMallmin(x<tresholdCycleDay) = NaN;        TP3.dayGsPMallmax(x<tresholdCycleDay) = NaN;

%..........................................................................
%% Seasonality
%..........................................................................
[TP3.week_avgHday,~,TP3.week_avgstdHday]   = AM_week2_avg(TP3.weekHday,TP3.week);
[TP3.week_avgLEday,~,TP3.week_avgstdLEday] = AM_week2_avg(TP3.weekLEday,TP3.week);
[TP3.week_avgnetradday,~,TP3.week_avgstdnetradday] = AM_week2_avg(TP3.weeknetradday,TP3.week);
[TP3.week_avgtairday,~,TP3.week_avgstdtairday] = AM_week2_avg(TP3.weektairday,TP3.week);

[TP3.eight_avgLEday,~,TP3.eight_stdLEday] = AM_eight_avg(TP3.eightLEday,TP3.eight);
[TP3.eight_avgHday,~,TP3.eight_stdHday]   = AM_eight_avg(TP3.eightHday,TP3.eight);
[TP3.eight_avgnetradday,~,TP3.eight_stdnetradday] = AM_eight_avg(TP3.eightnetradday,TP3.eight);
[TP3.eight_avgtairday,~,TP3.eight_stdtairday] = AM_eight_avg(TP3.eighttairday,TP3.eight);

[TP3.month_avgLEday,TP3.month_avgstdLEday] = AM_month_avg(TP3.monthLEday,TP3.month);
[TP3.month_avgHday,TP3.month_avgstdHday]   = AM_month_avg(TP3.monthHday,TP3.month);
[TP3.month_avgnetradday,TP3.month_avgstdnetradday] = AM_month_avg(TP3.monthnetradday,TP3.month);
[TP3.month_avgtairday,TP3.month_avgstdtairday] = AM_month_avg(TP3.monthtairday,TP3.month);

[TP3.month_avgGEPday,TP3.month_avgstdGEPday] = AM_month_avg(TP3.monthGEPday,TP3.month);
[TP3.week_avgGEPday,~,TP3.week_avgstdGEPday] = AM_week2_avg(TP3.weekGEPday,TP3.week);
[TP3.eight_avgGEPday,~,TP3.eight_stdGEPday]  = AM_eight_avg(TP3.eightGEPday,TP3.eight);

[TP3.month_avgRECOday,TP3.month_avgstdRECOday] = AM_month_avg(TP3.monthRECOday,TP3.month);
[TP3.week_avgRECOday,~,TP3.week_avgstdRECOday] = AM_week2_avg(TP3.weekRECOday,TP3.week);
[TP3.eight_avgRECOday,~,TP3.eight_stdRECOday]  = AM_eight_avg(TP3.eightRECOday,TP3.eight);

[TP3.month_avgNEEday,TP3.month_avgstdNEEday] = AM_month_avg(TP3.monthNEEday,TP3.month);
[TP3.week_avgNEEday,~,TP3.week_avgstdNEEday]  = AM_week2_avg(TP3.weekNEEday,TP3.week);
[TP3.eight_avgNEEday,~,TP3.eight_stdNEEday]  = AM_eight_avg(TP3.eightNEEday,TP3.eight);

%..........................................................................
%% Seasonality
%..........................................................................
[TP3.week_avgustarday,~,TP3.week_avgstdustarday] = AM_week2_avg(TP3.weekustarday,TP3.week);
[TP3.week_avgBowen,~,TP3.week_avgstdBowen] = AM_week2_avg(TP3.weekBowen,TP3.week);
[TP3.week_avgEF,~,TP3.week_avgstdEF] = AM_week2_avg(TP3.weekEF,TP3.week);
[TP3.week_avgET,~,TP3.week_avgstdET] = AM_week2_avg(TP3.weekET,TP3.week);
[TP3.week_avgETref,~,TP3.week_avgstdETref] = AM_week2_avg(TP3.weekETref,TP3.week);
[TP3.week_avgGsPM,~,TP3.week_avgstdGsPM]       = AM_week2_avg(TP3.weekGsPM,TP3.week);
[TP3.week_avgGsPMall,~,TP3.week_avgstdGsPMall] = AM_week2_avg(TP3.weekGsPMall,TP3.week);
[TP3.week_avgETdry,~,TP3.week_avgstdETdry]       = AM_week2_avg(TP3.weekETdry,TP3.week);
[TP3.week_avgETdryday,~,TP3.week_avgstdETdryday] = AM_week2_avg(TP3.weekETdryday,TP3.week);
% [TP3.week_avgETref,~,TP3.week_avgstdETref]       = AM_week2_avg(TP3.weekETref,TP3.week);
% [TP3.week_avgETrefday,~,TP3.week_avgstdETrefday] = AM_week2_avg(TP3.weekETrefday,TP3.week);
[TP3.week_avgGsPMmmol,~,TP3.week_avgstdGsPMmmol] = AM_week2_avg(TP3.weekGsPMmmol,TP3.week);
[TP3.week_avgGsPM,~,TP3.week_avgstdGsPM] = AM_week2_avg(TP3.weekGsPM,TP3.week);
[TP3.week_avgGsPMall,~,TP3.week_avgstdGsPMall] = AM_week2_avg(TP3.weekGsPMall,TP3.week);
% [TP3.week_avgGiday,~,TP3.week_avgstdGiday] = AM_week2_avg(TP3.weekGiday,TP3.week);
[TP3.week_avgLEdry,~,TP3.week_avgstdLEdry] = AM_week2_avg(TP3.weekLEdry,TP3.week);
% [TP3.week_avgPTalphaday,~,TP3.week_avgstdPTalphaday] = AM_week2_avg(TP3.weekPTalphaday,TP3.week);
% [TP3.week_avgVPDday,~,TP3.week_avgstdVPDday] = AM_week2_avg(TP3.weekVPDday,TP3.week);
[TP3.week_avgEFday,~,TP3.week_avgstdEFday]   = AM_week2_avg(TP3.weekEFday,TP3.week);
% [TP3.week_avgEFdaydry,~,TP3.week_avgstdEFdaydry] = AM_week2_avg(TP3.weekEFdaydry,TP3.week);
[TP3.week_avgBowenday,~,TP3.week_avgstdBowenday] = AM_week2_avg(TP3.weekBowenday,TP3.week);
% [TP3.week_avgH2O,~,TP3.week_avgstdH2O]   = AM_week2_avg(TP3.weekH2O,TP3.week);

% % % .........................................................................
% % %% Eight seasonality
% % % .........................................................................
% % [TP3.eight_avgBowen,~,TP3.eight_stdBowen] = AM_eight_avg(TP3.eightBowen,TP3.eight);
% % [TP3.eight_avgEF,~,TP3.eight_stdEF]       = AM_eight_avg(TP3.eightEF,TP3.eight);
% % [TP3.eight_avgET,~,TP3.eight_stdET]       = AM_eight_avg(TP3.eightET,TP3.eight);
% % [TP3.eight_avgGs,~,TP3.eight_stdGs]       = AM_eight_avg(TP3.eightGsPMall,TP3.eight);
% % [TP3.eight_avgGsPM,~,TP3.eight_stdGsPM]   = AM_eight_avg(TP3.eightGsPM,TP3.eight);
% % [TP3.month_avgGsPMall,TP3.month_avgstdGsPMall] = AM_month_avg(TP3.monthGsPMall,TP3.month);
% % [TP3.eight_avgETdry,~,TP3.eight_stdETdry] = AM_eight_avg(TP3.eightETdry,TP3.eight);
% % [TP3.eight_avgETdryday,~,TP3.eight_stdETdryday] = AM_eight_avg(TP3.eightETdryday,TP3.eight);
% % [TP3.eight_avgETref,~,TP3.eight_stdETref]       = AM_eight_avg(TP3.eightETref,TP3.eight);
% % [TP3.eight_avgGsPMmmol,~,TP3.eight_stdGsPMmmol] = AM_eight_avg(TP3.eightGsPMmmol,TP3.eight);
% % [TP3.eight_avgGsPMallmmol,~,TP3.eight_stdGsPMallmmol] = AM_eight_avg(TP3.eightGsPMallmmol,TP3.eight);
% % [TP3.eight_avgPTalphaday,~,TP3.eight_stdPTalphaday] = AM_eight_avg(TP3.eightPTalphaday,TP3.eight);
% % [TP3.eight_avgVPDday,~,TP3.eight_stdVPDday] = AM_eight_avg(TP3.eightVPDday,TP3.eight);
% % [TP3.eight_avgLEdry,~,TP3.eight_stdLEdry]   = AM_eight_avg(TP3.eightLEdry,TP3.eight);
% % [TP3.eight_avgH,~,TP3.eight_stdH]   = AM_eight_avg(TP3.eightH,TP3.eight);
% % [TP3.eight_avgLE,~,TP3.eight_stdLE] = AM_eight_avg(TP3.eightLE,TP3.eight);
% % [TP3.eight_avgGiday,~,TP3.eight_stdGiday] = AM_eight_avg(TP3.eightGiday,TP3.eight);
% % [TP3.eight_avgEFday,~,TP3.eight_stdEFday] = AM_eight_avg(TP3.eightEFday,TP3.eight);
% % [TP3.eight_avgEFdaydry,~,TP3.eight_stdEFdaydry] = AM_eight_avg(TP3.eightEFdaydry,TP3.eight);
% % [TP3.eight_avgBowenday,~,TP3.eight_stdBowenday] = AM_eight_avg(TP3.eightBowenday,TP3.eight);
% %
% % [TP3.month_avgBowen,TP3.month_avgstdBowen] = AM_month_avg(TP3.monthBowen,TP3.month);
% % [TP3.month_avgEF,TP3.month_avgstdEF] = AM_month_avg(TP3.monthEF,TP3.month);
% % [TP3.month_avgET,TP3.month_avgstdET] = AM_month_avg(TP3.monthET,TP3.month);
% % [TP3.month_avgGs,TP3.month_avgstdGs] = AM_month_avg(TP3.monthGsPMall,TP3.month);
% % [TP3.month_avgGsPMmmol,TP3.month_avgstdGsPMmmol] = AM_month_avg(TP3.monthGsPMmmol,TP3.month);
% % [TP3.month_avgGsPMallmmol,TP3.month_avgstdGsPMallmmol] = AM_month_avg(TP3.monthGsPMallmmol,TP3.month);
% % [TP3.month_avgGsPM,TP3.month_avgstdGsPM]   = AM_month_avg(TP3.monthGsPM,TP3.month);
% % [TP3.month_avgGsPMall,TP3.month_avgstdGsPMall]   = AM_month_avg(TP3.monthGsPMall,TP3.month);
% % [TP3.month_avgETdry,TP3.month_avgstdETdry]   = AM_month_avg(TP3.monthETdry,TP3.month);
% % [TP3.month_avgETdryday,TP3.month_avgstdETdryday] = AM_month_avg(TP3.monthETdryday,TP3.month);
% % [TP3.month_avgETref,TP3.month_avgstdETref]   = AM_month_avg(TP3.monthETref,TP3.month);
% % [TP3.month_avgETday,TP3.month_avgstdETday]   = AM_month_avg(TP3.monthETday,TP3.month);
% % [TP3.month_avgGiday,TP3.month_avgstdGiday]   = AM_month_avg(TP3.monthGiday,TP3.month);
% % [TP3.month_avgLEdry,TP3.month_avgstdLEdry]   = AM_month_avg(TP3.monthLEdry,TP3.month);
% % [TP3.month_avgPTalphaday,TP3.month_avgstdPTalphaday] = AM_month_avg(TP3.monthPTalphaday,TP3.month);
% % [TP3.month_avgVPDday,TP3.month_avgstdVPDday] = AM_month_avg(TP3.monthVPDday,TP3.month);
% % [TP3.month_avgEFday,TP3.month_avgstdEFday]   = AM_month_avg(TP3.monthEFday,TP3.month);
% % [TP3.month_avgEFdaydry,TP3.month_avgstdEFdaydry] = AM_month_avg(TP3.monthEFdaydry,TP3.month);
% % [TP3.month_avgBowenday,TP3.month_avgstdBowenday] = AM_month_avg(TP3.monthBowenday,TP3.month);
% %
% % ...................................................................................................................
% %% EB error
% % ...................................................................................................................
% TP3.StorageLEday      = TP3.StorageLE;            TP3.StorageLEday(TP3.So<=tresholdSo) = NaN;
% TP3.EphotosyntesisDay = TP3.Ephotosyntesis; TP3.EphotosyntesisDay(TP3.So<=tresholdSo) = NaN;
% TP3.StorageHeatDay    = TP3.StorageHeat;       TP3.StorageHeatday(TP3.So<=tresholdSo) = NaN;
% TP3.netradday         = TP3.netrad;                      TP3.netradday(TP3.So<=tresholdSo) = NaN;
%
TP3.par_day = TP3.par;   TP3.par_day(TP3.So<tresholdSo) = NaN;
[TP3.dayPAR,~,ix]      = AM_day(TP3.par,TP3.dateloc,0);         TP3.dayPAR(ix<21) = NaN;
[TP3.dayPARday,~,ix]   = AM_day(TP3.par_day,TP3.dateloc,0);     TP3.dayPARday(ix<6) = NaN;

TP3.eightPARday = AM_eight2cycle_rs(TP3.par_day,TP3.dateloc,tresholdCycleDay,4,2);
TP3.weekPARday = AM_week2cycle_rs(TP3.par_day,TP3.dateloc,tresholdCycleDay,4,2);
% [TP3.daynetradday,~,ix]= AM_day(TP3.netradday,TP3.dateloc,0);  TP3.daynetradday(ix<6) = NaN;
% [~,~,TP3.netradday_fill] = AM_compute_regression(TP3.par_day,TP3.netradday,[.6 .6 .6],1);
% [TP3.daynetradday_fill,~,ix]    = AM_day(TP3.netradday_fill,TP3.dateloc,0);            TP3.daynetradday_fill(ix<6) = NaN;
% [TP3.dayStorageHeatDay,~,ix]    = AM_day(TP3.StorageHeatDay,TP3.dateloc,0);  TP3.dayStorageHeatDay(ix<6) = NaN;
% [TP3.dayStorageLEday,~,ix]      = AM_day(TP3.StorageLEday,TP3.dateloc,0);        TP3.dayStorageLEday(ix<6) = NaN;
% [TP3.dayEphotosyntesisDay,~,ix] = AM_day(TP3.EphotosyntesisDay,TP3.dateloc,0);	TP3.dayEphotosyntesisDay(ix<6) = NaN;
%
% TP3.dayStorageLEday_fill = AM_fill_day_cycle(TP3.dayStorageLEday,TP3.day,6,18);
% TP3.dayEphotosyntesisDay_fill = AM_fill_day_cycle(TP3.dayEphotosyntesisDay,TP3.day,6,18);
%
% TP3.dayerrorday = TP3.daynetradday_fill - TP3.dayLEday - TP3.dayHday - TP3.dayStorageHeatDay - ...
%     TP3.dayStorageLEday_fill - TP3.dayEphotosyntesisDay_fill;
%
[TP3.recurrentLE,TP3.recurrent_stdLE] = AM_hourAVG_recurrent(TP3.LE,TP3.dateloc);
[TP3.recurrentET,TP3.recurrent_stdET] = AM_hourAVG_recurrent(TP3.ET,TP3.dateloc);
[TP3.day_recurrentLEday,TP3.day_recurrent_stdLEday] = AM_dayAVG_recurrent(TP3.dayLEday,TP3.daydate);
[TP3.recurrentLEday,TP3.recurrent_stdLEday] = AM_hourAVG_recurrent(TP3.LEday,TP3.dateloc);

TP3.recurrentH = AM_hourAVG_recurrent(TP3.H,TP3.dateloc);
TP3.day_recurrentHday = AM_dayAVG_recurrent(TP3.dayHday,TP3.daydate);

TP3.recurrentnetrad = AM_hourAVG_recurrent(TP3.netrad,TP3.dateloc);
TP3.day_recurrentnetradday = AM_dayAVG_recurrent(TP3.daynetradday,TP3.daydate);
TP3.recurrenttair = AM_hourAVG_recurrent(TP3.tair,TP3.dateloc);
TP3.day_recurrenttairday = AM_dayAVG_recurrent(TP3.daytairday,TP3.daydate);

[TP3.dayY,TP3.dayM,TP3.dayD] = datevec(TP3.daydate);

figure
hold on
plot(TP3.week,TP3.weeknetradday);
plot(TP3.week,TP3.weekLEday);
plot(TP3.week,TP3.weekHday);

[TP3.recurrentGEP,TP3.recurrent_stdGEP] = AM_hourAVG_recurrent(TP3.gep,TP3.dateloc);
[TP3.day_recurrentGEP,TP3.day_recurrent_stdGEP] = AM_dayAVG_recurrent(TP3.dayGEP,TP3.daydate);
[TP3.recurrentGEP,TP3.recurrent_stdGEP] = AM_hourAVG_recurrent(TP3.gep,TP3.dateloc);
TP3.day_recurrentGEPGoley = sgolayfilt(TP3.day_recurrentGEP,polyorder,framesize);
TP3.dayGEP_zscore = (TP3.dayGEP - TP3.day_recurrentGEPGoley)./TP3.day_recurrent_stdGEP;

[TP3.day_recurrentGEPday,TP3.day_recurrent_stdGEPday] = AM_dayAVG_recurrent(TP3.dayGEPday,TP3.daydate);
[TP3.recurrentGEPday,TP3.recurrent_stdGEPday] = AM_hourAVG_recurrent(TP3.GEPday,TP3.dateloc);
TP3.day_recurrentGEPdayGoley = sgolayfilt(TP3.day_recurrentGEPday,polyorder,framesize);
TP3.dayGEPday_zscore = (TP3.dayGEPday - TP3.day_recurrentGEPdayGoley)./TP3.day_recurrent_stdGEPday;

[TP3.recurrentRECO,TP3.recurrent_stdRECO] = AM_hourAVG_recurrent(TP3.reco,TP3.dateloc);
[TP3.day_recurrentRECOday,TP3.day_recurrent_stdRECOday] = AM_dayAVG_recurrent(TP3.dayRECOday,TP3.daydate);
[TP3.recurrentRECOday,TP3.recurrent_stdRECOday] = AM_hourAVG_recurrent(TP3.RECOday,TP3.dateloc);
TP3.day_recurrentRECOdayGoley = sgolayfilt(TP3.day_recurrentRECOday,polyorder,framesize);
TP3.dayRECOday_zscore = (TP3.dayRECOday - TP3.day_recurrentRECOdayGoley)./TP3.day_recurrent_stdRECOday;

[TP3.recurrentNEE,TP3.recurrent_stdNEE] = AM_hourAVG_recurrent(TP3.nee,TP3.dateloc);
[TP3.day_recurrentNEEday,TP3.day_recurrent_stdNEEday] = AM_dayAVG_recurrent(TP3.dayNEEday,TP3.daydate);
[TP3.recurrentNEEday,TP3.recurrent_stdNEEday] = AM_hourAVG_recurrent(TP3.NEEday,TP3.dateloc);
TP3.day_recurrentNEEdayGoley = sgolayfilt(TP3.day_recurrentNEEday,polyorder,framesize);
TP3.dayNEEday_zscore = (TP3.dayNEEday - TP3.day_recurrentNEEdayGoley)./TP3.day_recurrent_stdNEEday;

%..........................................................................
%% PET
%..........................................................................
% no ground heat flux, originally (TP3.netrad - TP3.G)
TP3.PET = (0.408 .*TP3.delta .* TP3.netrad + TP3.sigma .* (900 ./ (TP3.tair + 273)) .* TP3.ws .* (TP3.e_sat - TP3.e)) ./....
    (TP3.delta + TP3.sigma .* (1 + 0.34 * TP3.ws));
TP3.PET = TP3.PET.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
TP3.PET(TP3.PET<0.2) = NaN;   TP3.PET(isinf(TP3.PET)) = NaN;

TP3.ETday = TP3.ET;               TP3.ETday(TP3.So<tresholdSo) = NaN;
TP3.PETday = TP3.PET;             TP3.PETday(TP3.So<tresholdSo) = NaN;
TP3.tairday = TP3.tair;           TP3.tairday(TP3.So<tresholdSo) = NaN;
TP3.netradday = TP3.netrad;       TP3.netradday(TP3.So<tresholdSo) = NaN;

[TP3.daytairday,~,x,~,~,TP3.daytairdaymin,TP3.daytairdaymax]   = AM_day(TP3.tairday,TP3.dateloc,0);
TP3.daytairday(x<6) = NaN;         TP3.daytairdaymin(x<6) = NaN;        TP3.daytairdaymax(x<6) = NaN;
[TP3.dayETday,~,x,~,~,TP3.dayETdaymin,TP3.dayETdaymax]   = AM_day(TP3.ETday,TP3.dateloc,0);
TP3.dayETday(x<6) = NaN;         TP3.dayETdaymin(x<6) = NaN;        TP3.dayETdaymax(x<6) = NaN;
[TP3.day_recurrentETday,TP3.day_recurrent_stdETday] = AM_dayAVG_recurrent(TP3.dayETday,TP3.daydate);
[TP3.dayPETday,~,x,~,~,TP3.dayPETdaymin,TP3.dayPETdaymax]   = AM_day(TP3.PETday,TP3.dateloc,0);
TP3.dayPETday(x<6) = NaN;         TP3.dayPETdaymin(x<6) = NaN;        TP3.dayPETdaymax(x<6) = NaN;
[TP3.day_recurrentPETday,TP3.day_recurrent_stdPETday] = AM_dayAVG_recurrent(TP3.dayPETday,TP3.daydate);

%% .........................................................................................................
figure('color','white');
plot(EVI.dateloc,scaled250m16daysEVI.value_center); hold on
scaled250m16daysEVI.value_center(scaled250m16daysEVI.value_center<0.0) = NaN;
TP3.dayEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,TP3.daydate);
TP3.dayEVI(TP3.daytairdaymin<0) = NaN;
plot(TP3.daydate,TP3.dayEVI,'.')

TP3.eightEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,TP3.eight);
TP3.weekEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,TP3.week);
[TP3.day_recurrentEVI,TP3.day_recurrent_stdEVI] = AM_dayAVG_recurrent(TP3.dayEVI,TP3.daydate);

%% .........................................................................................................
figure('color','white');
plot(ROI.daydate,ROI.gcc_mean); hold on
% ROI.gcc(ROI.gcc<0.0) = NaN;
plot(ROI.daydate,ROI.gcc_50);       plot(ROI.daydate,ROI.gcc_75);

TP3.ROIgcc = interp1(ROI.daydate,ROI.gcc_mean,TP3.daydate);
% TP3.ROIgcc((TP3.So<tresholdSo)|(TP3.ROIgcc<0.36)) = NaN;
% plot(TP3.dateloc,TP3.ROIgcc,'.')

[TP3.weekROIgcc,~,~,~,TP3.weekROIgccmin,TP3.weekROIgccmax,TP3.weekROIgccstd,TP3.weekROI] = AM_week2day_rs(TP3.ROIgcc,TP3.daydate);
[TP3.eightROIgcc,~,~,~,TP3.eightROIgccmin,TP3.eightROIgccmax,TP3.eightROIgccstd,TP3.eightROI] = AM_eightday_rs(TP3.ROIgcc,TP3.daydate);
[TP3.day_recurrentROIgcc,TP3.day_recurrent_stdROIgcc] = AM_dayAVG_recurrent(TP3.ROIgcc,TP3.daydate);

TP3.ROIrcc = interp1(ROI.daydate,ROI.rcc_mean,TP3.daydate);
[TP3.weekROIrcc,~,~,~,TP3.weekROIrccmin,TP3.weekROIrccmax,TP3.weekROIrccstd,TP3.weekROI] = AM_week2day_rs(TP3.ROIrcc,TP3.daydate);
[TP3.eightROIrcc,~,~,~,TP3.eightROIrccmin,TP3.eightROIrccmax,TP3.eightROIrccstd,TP3.eightROI] = AM_eightday_rs(TP3.ROIrcc,TP3.daydate);
[TP3.day_recurrentROIrcc,TP3.day_recurrent_stdROIrcc] = AM_dayAVG_recurrent(TP3.ROIrcc,TP3.daydate);

%%
figure('color','white');
plot(ROI.daydate,ROI.rcc_mean); hold on
plot(ROI.daydate,ROI.rcc_50);       plot(ROI.daydate,ROI.rcc_75);
TP3.ROIrcc = interp1(ROI.daydate,ROI.rcc_mean,TP3.daydate);
[TP3.weekROIrcc,~,~,~,TP3.weekROIrccmin,TP3.weekROIrccmax,TP3.weekROIrccstd,TP3.weekROI] = AM_week2day_rs(TP3.ROIrcc,TP3.daydate);
[TP3.eightROIrcc,~,~,~,TP3.eightROIrccmin,TP3.eightROIrccmax,TP3.eightROIrccstd,TP3.eightROI] = AM_eightday_rs(TP3.ROIrcc,TP3.daydate);
[TP3.day_recurrentROIrcc,TP3.day_recurrent_stdROIrcc] = AM_dayAVG_recurrent(TP3.ROIrcc,TP3.daydate);

%%
TP3.ROIGRRI = interp1(ROI.daydate,ROI.GRRI_mean,TP3.daydate);
[TP3.weekROIGRRI,~,~,~,TP3.weekROIGRRImin,TP3.weekROIGRRImax,TP3.weekROIGRRIstd,TP3.weekROI] = AM_week2day_rs(TP3.ROIGRRI,TP3.daydate);
[TP3.eightROIGRRI,~,~,~,TP3.eightROIGRRImin,TP3.eightROIGRRImax,TP3.eightROIGRRIstd,TP3.eightROI] = AM_eightday_rs(TP3.ROIGRRI,TP3.daydate);
[TP3.day_recurrentROIGRRI,TP3.day_recurrent_stdROIGRRI] = AM_dayAVG_recurrent(TP3.ROIGRRI,TP3.daydate);

TP3.ROIGRIVI = interp1(ROI.daydate,ROI.GRIVI_mean,TP3.daydate);
[TP3.weekROIGRIVI,~,~,~,TP3.weekROIGRIVImin,TP3.weekROIGRIVImax,TP3.weekROIGRIVIstd,TP3.weekROI] = AM_week2day_rs(TP3.ROIGRIVI,TP3.daydate);
[TP3.eightROIGRIVI,~,~,~,TP3.eightROIGRIVImin,TP3.eightROIGRIVImax,TP3.eightROIGRIVIstd,TP3.eightROI] = AM_eightday_rs(TP3.ROIGRIVI,TP3.daydate);
[TP3.day_recurrentROIGRIVI,TP3.day_recurrent_stdROIGRIVI] = AM_dayAVG_recurrent(TP3.ROIGRIVI,TP3.daydate);

ROI.exgreen_mean = ((2.*ROI.g_mean)-ROI.r_mean-ROI.b_mean);%./(ROI.g_mean+ROI.r_mean+ROI.b_mean);
TP3.ROIexgreen = interp1(ROI.daydate,ROI.exgreen_mean,TP3.daydate);
[TP3.weekROIexgreen,~,~,~,TP3.weekROIexgreenmin,TP3.weekROIexgreenmax,TP3.weekROIexgreenstd,TP3.weekROI] = AM_week2day_rs(TP3.ROIexgreen,TP3.daydate);
[TP3.eightROIexgreen,~,~,~,TP3.eightROIexgreenmin,TP3.eightROIexgreenmax,TP3.eightROIexgreenstd,TP3.eightROI] = AM_eightday_rs(TP3.ROIexgreen,TP3.daydate);
[TP3.day_recurrentROIexgreen,TP3.day_recurrent_stdROIexgreen] = AM_dayAVG_recurrent(TP3.ROIexgreen,TP3.daydate);

TP3.ROIcci = interp1(ROI.daydate,ROI.cci_mean,TP3.daydate);
[TP3.weekROIcci,~,~,~,TP3.weekROIccimin,TP3.weekROIccimax,TP3.weekROIccistd,TP3.weekROI] = AM_week2day_rs(TP3.ROIcci,TP3.daydate);
[TP3.eightROIcci,~,~,~,TP3.eightROIccimin,TP3.eightROIccimax,TP3.eightROIccistd,TP3.eightROI] = AM_eightday_rs(TP3.ROIcci,TP3.daydate);
[TP3.day_recurrentROIcci,TP3.day_recurrent_stdROIcci] = AM_dayAVG_recurrent(TP3.ROIcci,TP3.daydate);

%%
figure('color','white');
plot(LAIsite.daydate,LAIsite.all_mean); hold on

LAIsite.all_mean(LAIsite.all_mean<0.0) = NaN;
TP3.dayLAI = interp1(LAIsite.daydate,LAIsite.all_mean,TP3.daydate);
% TP3.LAI((TP3.So<tresholdSo)|(TP3.LAI<0.36)) = NaN;
plot(TP3.daydate,TP3.dayLAI)

[TP3.dayLAIavg,~,~,~,~,TP3.dayLAImin,TP3.dayLAI]   = AM_day(TP3.dayLAI,TP3.daydate,0);
[TP3.day_recurrentLAI,TP3.day_recurrent_stdLAI] = AM_dayAVG_recurrent(TP3.dayLAI,TP3.daydate);
plot(TP3.daydate,TP3.day_recurrentLAI,'.')

TP3.dayLAIfill = TP3.dayLAI;      TP3.dayLAIfill(isnan(TP3.dayLAI)) = TP3.day_recurrentLAI(isnan(TP3.dayLAI));
TP3.LAI = interp1(TP3.daydate,TP3.dayLAI,TP3.dateloc);
[TP3.weekLAI,~,~,~,~,TP3.week_stdLAI]  = AM_week2cycle_rs(TP3.LAI,TP3.dateloc,tresholdCycleDay,4,2);
[TP3.week_avgLAI,~,TP3.week_avgstdLAI] = AM_week2_avg(TP3.weekLAI,TP3.week);

% .............................................
%% Extreme evaporation events
% .............................................
% Remove seasonality
% Seasonal Differencing (assuming yearly seasonality, s = 365)
if flag_ExtreameET==1
    TP3.LEdryday = TP3.LEdry;             TP3.LEdryday(TP3.So<tresholdSo) = NaN;
    [TP3.dayLEdryday,~,x,~,~,TP3.dayLEdrydaymin,TP3.dayLEdrydaymax] = AM_day(TP3.LEdryday,TP3.dateloc,0);
    TP3.dayLEdryday(x<6) = NaN;           TP3.dayLEdrydaymin(x<6) = NaN;        TP3.dayLEdrydaymax(x<6) = NaN;
    [TP3.day_recurrentLEdryday,TP3.day_recurrent_stdLEdryday] = AM_dayAVG_recurrent(TP3.dayLEdryday,TP3.daydate);

    TP3.day_recurrentLEdayGoley = sgolayfilt(TP3.day_recurrentLEday,polyorder,framesize);
    TP3.day_recurrentLEdrydayGoley = sgolayfilt(TP3.day_recurrentLEdryday,polyorder,framesize);
    TP3.JDday = day(TP3.daydate,'dayofyear');
    % TP3.dayLEdryday_deseasoned = TP3.dayLEdryday - TP3.day_recurrentLEdryday(TP3.JDday);
    % TP3.dayLEday_deseasoned = (TP3.dayLEday - TP3.day_recurrentLEdayGoley(TP3.JDday));
    TP3.dayLEday_zscore = (TP3.dayLEday - TP3.day_recurrentLEdayGoley)./TP3.day_recurrent_stdLEday;
    TP3.dayLEdryday_zscore = (TP3.dayLEdryday - TP3.day_recurrentLEdrydayGoley)./TP3.day_recurrent_stdLEdryday;

    figure('color','white','Position',[50 50 1800 400]);    hold on;
    plot(TP3.daydate,TP3.dayLEday);  plot(TP3.daydate,TP3.dayLEdryday);
    legend('days without rain in the previous 12 hours','dry days'); legend box off;
    ylabel('LE_{daytime}(W m^-^2)'); box on;
    figure('color','white');         plot(TP3.daydate,TP3.dayLEday_zscore);   hold on;
    plot(TP3.daydate, TP3.dayLEdryday_zscore);

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
    TP3.dayLEdayARIMAzvalue = NaN(length(TP3.daydate),1);                     TP3.dayLEdayARIMAzvalueResidual = NaN(length(TP3.daydate),1);
    TP3.dayLEdayARIMAzvalueconstant = NaN(length(TP3.daydate),1);       TP3.dayLEdayARIMAzvalueSE = NaN(length(TP3.daydate),1);

    TP3.dayLEdrydayARIMAzscore = NaN(length(TP3.daydate),1);                TP3.dayLEdrydayARIMAzvalueResidual = NaN(length(TP3.daydate),1);
    TP3.dayLEdrydayARIMAzscoreconstant = NaN(length(TP3.daydate),1);  TP3.dayLEdrydayARIMAzvalueSE = NaN(length(TP3.daydate),1);

    jet_color = gray(366);
    Mdl = arima(1,0,0); % AR(1) model

    ind = find(TP3.dayY>1900);  % all data
    Y = TP3.dayLEday_zscore(ind);       Z = TP3.dayLEdryday_zscore(ind);
    im = 10;
    % ARIMAtimeMTX = NaN(366,im);
    figure('color','white');
    for ik = im+1:length(Y)-im
        X = Y(ik-im:ik+im);               W = Z(ik-im:ik+im);
        % Create and estimate the AR(1) model
        if (length(X(~isnan(X)))>3)&(~isnan(Y(ik)))
            EstMdl = estimate(Mdl,X); % Estimate using the first 9 days
            TP3.dayLEdayARIMAzvalue(ik) = EstMdl.AR{1};
            TP3.dayLEdayARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', X);
            TP3.dayLEdayARIMAzvalue(ik) = YF(1);
            TP3.dayLEdayARIMAzvaluelSE(ik) = YMSE(1);
            TP3.dayLEdayARIMAzvalueResidual(ik) = YF(1)-X(im);
        end
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            EstMdl = estimate(Mdl, W); % Estimate using the first 9 days
            TP3.dayLEdrydayARIMAzvalue(ik) = EstMdl.AR{1};
            TP3.dayLEdrydayARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', W);
            TP3.dayLEdrydayARIMAzvalue(ik) = YF(1);
            TP3.dayLEdrydayARIMAzvalueSE(ik) = YMSE(1);
            TP3.dayLEdrydayARIMAzvalueResidual(ik) = YF(1)-W(im);

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
    ind = find(TP3.daytairday<tresholdtair);
    TP3.dayLEdayGrowth = TP3.dayLEday;     TP3.dayLEdayGrowth(ind) = NaN;
    TP3.dayLEdayARIMAzvalueResidualGrowth = TP3.dayLEdayARIMAzvalueResidual;
    TP3.dayLEdayARIMAzvalueResidualGrowth(ind) = NaN;
    TP3.dayLEdayARIMAzvalueResidualGrowth(TP3.dayLEdayARIMAzvalueResidualGrowth<0) = NaN;
    figure('color','white');
    histogram(TP3.dayLEdayARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{growth season}')
    x = TP3.dayLEdayARIMAzvalueResidualGrowth;
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
    ind = find(TP3.daytairday<tresholdtair);
    TP3.dayLEdrydayARIMAzvalueResidualGrowth = TP3.dayLEdrydayARIMAzvalueResidual;
    TP3.dayLEdrydayARIMAzvalueResidualGrowth(ind) = NaN;
    TP3.dayLEdrydayARIMAzvalueResidualGrowth(TP3.dayLEdrydayARIMAzvalueResidualGrowth<0) = NaN;
    figure('color','white');
    histogram(TP3.dayLEdrydayARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{z-value growth season}')
    x = TP3.dayLEdrydayARIMAzvalueResidualGrowth;
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
    TP3.dayLEdayHURSTzvalue    = NaN(length(TP3.daydate),1);
    TP3.dayLEdayHURSTdryzvalue = NaN(length(TP3.daydate),1);
    jet_color = gray(366);
    ind = find(TP3.dayY>1900);  % all data
    im = 10;
    Y = TP3.dayLEday_zscore(ind);       Z = TP3.dayLEdryday_zscore(ind);
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
            TP3.dayLEdayHURSTzvalue(ik) = RS;
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
            TP3.dayLEdayHURSTdryzvalue(ik) = RS;
        end
    end
    % TP3.dayLEdayHURST(TP3.dayLEdayHURST<1) = NaN;

    % Plotting the Hurst Exponent over time (optional, but highly recommended)
    % long-term memory and fractal properties of a time series. Here's what the values mean:
    % H < 0.5: The time series is mean-reverting (it tends to revert to a long-term average).
    % H = 0.5: The time series is a random walk (no predictable patterns).
    % H > 0.5: The time series is persistent (it tends to follow trends).
    %%
    figure('color','white');
    plot(TP3.daydate, TP3.dayLEdayHURSTzvalue);  hold on
    plot(TP3.daydate, TP3.dayLEdayHURSTdryzvalue);
    xlabel('Time (Days)');
    ylabel('Hurst Exponent'); legend('ARIMA z-value','ARIMA LE_{daytime dry}')
    grid on;

    % .............................................
    %% Extreme greenup events
    % .............................................
    ind = find(TP3.daytairday<tresholdtair);
    TP3.dayROIgccGrowth = TP3.ROIgcc;     TP3.dayROIgccGrowth(ind) = NaN;

    % Remove seasonality
    [TP3.day_recurrentROIgcc,TP3.day_recurrent_stdROIgcc] = AM_dayAVG_recurrent(TP3.ROIgcc,TP3.daydate);

    polyorder = 2;     % Polynomial order (typically 2 or 3)
    framesize = 3;     % Window size (must be odd)
    TP3.day_recurrentROIgccGoley = sgolayfilt(TP3.day_recurrentROIgcc,polyorder,framesize);
    TP3.dayROIgcc_zscore = (TP3.ROIgcc - TP3.day_recurrentROIgccGoley)./TP3.day_recurrent_stdROIgcc;
    TP3.dayROIgcc_zscore(isinf(TP3.dayROIgcc_zscore)) = NaN;
    figure('color','white');                            plot(TP3.daydate,TP3.ROIgcc);   hold on;
    plot(TP3.daydate, TP3.dayROIgcc_zscore);

    % Fit an AR(1) model using arima function
    TP3.dayROIgccARIMAzscore = NaN(length(TP3.daydate),1);          TP3.dayROIgccARIMAzvalueResidual = NaN(length(TP3.daydate),1);
    TP3.dayROIgccARIMAzscoreconstant = NaN(length(TP3.daydate),1);  TP3.dayROIgccARIMAzvalueSE = NaN(length(TP3.daydate),1);
    jet_color = gray(366);
    Mdl = arima(1,0,0); % AR(1) model

    ind = find(TP3.dayY>1900);  % all data
    Z = TP3.dayROIgcc_zscore(ind);
    im = 10;
    figure('color','white');
    for ik = im+1:length(Y)-im
        W = Z(ik-im:ik+im);
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            EstMdl = estimate(Mdl, W); % Estimate using the first 9 days
            TP3.dayROIgccARIMAzvalue(ik) = EstMdl.AR{1};
            TP3.dayROIgccARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', W);
            TP3.dayROIgccARIMAzvalue(ik) = YF(1);
            TP3.dayROIgccARIMAzvalueSE(ik) = YMSE(1);
            TP3.dayROIgccARIMAzvalueResidual(ik) = YF(1)-W(im);
        end
    end
    % Extreame value theory
    ind = find(TP3.daytairday<tresholdtair);
    TP3.dayROIgccARIMAzvalueResidualGrowth = TP3.dayROIgccARIMAzvalueResidual;
    TP3.dayROIgccARIMAzvalueResidualGrowth(ind) = NaN;
    figure('color','white');
    histogram(TP3.dayROIgccARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{z-value growth season}')
    x = TP3.dayROIgccARIMAzvalueResidualGrowth;
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
    TP3.dayROIgccHURSTzvalue = NaN(length(TP3.daydate),1);
    jet_color = gray(366);
    ind = find(TP3.dayY>1900);  % all data
    im = 10;
    Z = TP3.dayROIgcc_zscore(ind);

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
            TP3.dayROIgccHURSTzvalue(ik) = RS;
        end
    end

    figure('color','white');
    plot(TP3.daydate, TP3.dayROIgccHURSTzvalue);  hold on
    xlabel('Time (Days)');
    ylabel('Hurst Exponent'); legend('ARIMA','ARIMA z-value')
    grid on;

end

%% .........................................................................
ind = find(TP3.daytairday<tresholdtair);
TP3.dayGEPdayGrowth  = TP3.dayGEPday;       TP3.dayGEPdayGrowth(ind) = NaN;
TP3.dayRECOdayGrowth = TP3.dayRECOday;      TP3.dayRECOdayGrowth(ind) = NaN;
TP3.dayNEEdayGrowth  = TP3.dayNEEday;       TP3.dayNEEdayGrowth(ind) = NaN;

TP3.dayGEPgrowth = TP3.dayGEP;        TP3.dayGEPgrowth(ind) = NaN;
TP3.dayRECOgrowth = TP3.dayRECO;      TP3.dayRECOgrowth(ind) = NaN;
TP3.dayNEEgrowth = TP3.dayNEE;        TP3.dayNEEgrowth(ind) = NaN;

polyorder = 2;      % Polynomial order (typically 2 or 3)
framesize = 9;     % Window size (must be odd)
TP3.dayGEPdayGoley = sgolayfilt(TP3.dayGEPday,polyorder,framesize);
TP3.dayGEPdayGrowthGoley = sgolayfilt(TP3.dayGEPdayGrowth,polyorder,framesize);

[TP3.monthY,TP3.monthM,TP3.monthD]= datevec(TP3.month);
% year_tick = unique(TP3.monthY);  year_tick = [year_tick;(year_tick(end)+1)];
% all_year_tick = (datetime(year_tick(1:4:end),1,1))';
[TP3.weekY,TP3.weekM,TP3.weekD]= datevec(TP3.week);
[TP3.eightY,TP3.eightM,TP3.eightD]= datevec(TP3.eight);

save('TP3.mat','TP3');
save('matlabTP3.mat');
