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

polyorder = 2;     % Polynomial order (typically 2 or 3)
framesize = 3;     % Window size (must be odd)

% %..........................................................................
% %% Fill meteorology
% %..........................................................................
% opts.VariableNames = ["TIMESTAMP_START", "TIMESTAMP_END", "TA_F_MDS", "TA_F_MDS_QC", "TA_ERA", "TA_F", "TA_F_QC", "SW_IN_POT", "SW_IN_F_MDS", "SW_IN_F_MDS_QC", "SW_IN_ERA", "SW_IN_F", "SW_IN_F_QC", "LW_IN_F_MDS", "LW_IN_F_MDS_QC", "LW_IN_ERA", "LW_IN_F", "LW_IN_F_QC", "LW_IN_JSB", "LW_IN_JSB_QC", "LW_IN_JSB_ERA", "LW_IN_JSB_F", "LW_IN_JSB_F_QC", "VPD_F_MDS", "VPD_F_MDS_QC", "VPD_ERA", "VPD_F", "VPD_F_QC", "PA", "PA_ERA", "PA_F", "PA_F_QC", "P", "P_ERA", "P_F", "P_F_QC", "WS", "WS_ERA", "WS_F", "WS_F_QC", "WD", "USTAR", "RH", "NETRAD", "PPFD_IN", "PPFD_DIF", "CO2_F_MDS", "CO2_F_MDS_QC", "TS_F_MDS_1", "TS_F_MDS_2", "TS_F_MDS_3", "TS_F_MDS_4", "TS_F_MDS_1_QC", "TS_F_MDS_2_QC", "TS_F_MDS_3_QC", "TS_F_MDS_4_QC", "G_F_MDS", "G_F_MDS_QC", "LE_F_MDS", "LE_F_MDS_QC", "LE_CORR", "LE_CORR_25", "LE_CORR_75", "LE_RANDUNC", "LE_RANDUNC_METHOD", "LE_RANDUNC_N", "LE_CORR_JOINTUNC", "H_F_MDS", "H_F_MDS_QC", "H_CORR", "H_CORR_25", "H_CORR_75", "H_RANDUNC", "H_RANDUNC_METHOD", "H_RANDUNC_N", "H_CORR_JOINTUNC", "EBC_CF_N", "EBC_CF_METHOD", "NIGHT", "NEE_CUT_REF", "NEE_VUT_REF", "NEE_CUT_REF_QC", "NEE_VUT_REF_QC", "NEE_CUT_REF_RANDUNC", "NEE_VUT_REF_RANDUNC", "NEE_CUT_REF_RANDUNC_METHOD", "NEE_VUT_REF_RANDUNC_METHOD", "NEE_CUT_REF_RANDUNC_N", "NEE_VUT_REF_RANDUNC_N", "NEE_CUT_REF_JOINTUNC", "NEE_VUT_REF_JOINTUNC", "NEE_CUT_USTAR50", "NEE_VUT_USTAR50", "NEE_CUT_USTAR50_QC", "NEE_VUT_USTAR50_QC", "NEE_CUT_USTAR50_RANDUNC", "NEE_VUT_USTAR50_RANDUNC", "NEE_CUT_USTAR50_RANDUNC_METHOD", "NEE_VUT_USTAR50_RANDUNC_METHOD", "NEE_CUT_USTAR50_RANDUNC_N", "NEE_VUT_USTAR50_RANDUNC_N", "NEE_CUT_USTAR50_JOINTUNC", "NEE_VUT_USTAR50_JOINTUNC", "NEE_CUT_MEAN", "NEE_VUT_MEAN", "NEE_CUT_MEAN_QC", "NEE_VUT_MEAN_QC", "NEE_CUT_SE", "NEE_VUT_SE", "NEE_CUT_05", "NEE_CUT_16", "NEE_CUT_25", "NEE_CUT_50", "NEE_CUT_75", "NEE_CUT_84", "NEE_CUT_95", "NEE_VUT_05", "NEE_VUT_16", "NEE_VUT_25", "NEE_VUT_50", "NEE_VUT_75", "NEE_VUT_84", "NEE_VUT_95", "NEE_CUT_05_QC", "NEE_CUT_16_QC", "NEE_CUT_25_QC", "NEE_CUT_50_QC", "NEE_CUT_75_QC", "NEE_CUT_84_QC", "NEE_CUT_95_QC", "NEE_VUT_05_QC", "NEE_VUT_16_QC", "NEE_VUT_25_QC", "NEE_VUT_50_QC", "NEE_VUT_75_QC", "NEE_VUT_84_QC", "NEE_VUT_95_QC", "RECO_NT_VUT_REF", "RECO_NT_VUT_USTAR50", "RECO_NT_VUT_MEAN", "RECO_NT_VUT_SE", "RECO_NT_VUT_05", "RECO_NT_VUT_16", "RECO_NT_VUT_25", "RECO_NT_VUT_50", "RECO_NT_VUT_75", "RECO_NT_VUT_84", "RECO_NT_VUT_95", "RECO_NT_CUT_REF", "RECO_NT_CUT_USTAR50", "RECO_NT_CUT_MEAN", "RECO_NT_CUT_SE", "RECO_NT_CUT_05", "RECO_NT_CUT_16", "RECO_NT_CUT_25", "RECO_NT_CUT_50", "RECO_NT_CUT_75", "RECO_NT_CUT_84", "RECO_NT_CUT_95", "GPP_NT_VUT_REF", "GPP_NT_VUT_USTAR50", "GPP_NT_VUT_MEAN", "GPP_NT_VUT_SE", "GPP_NT_VUT_05", "GPP_NT_VUT_16", "GPP_NT_VUT_25", "GPP_NT_VUT_50", "GPP_NT_VUT_75", "GPP_NT_VUT_84", "GPP_NT_VUT_95", "GPP_NT_CUT_REF", "GPP_NT_CUT_USTAR50", "GPP_NT_CUT_MEAN", "GPP_NT_CUT_SE", "GPP_NT_CUT_05", "GPP_NT_CUT_16", "GPP_NT_CUT_25", "GPP_NT_CUT_50", "GPP_NT_CUT_75", "GPP_NT_CUT_84", "GPP_NT_CUT_95", "RECO_DT_VUT_REF", "RECO_DT_VUT_USTAR50", "RECO_DT_VUT_MEAN", "RECO_DT_VUT_SE", "RECO_DT_VUT_05", "RECO_DT_VUT_16", "RECO_DT_VUT_25", "RECO_DT_VUT_50", "RECO_DT_VUT_75", "RECO_DT_VUT_84", "RECO_DT_VUT_95", "RECO_DT_CUT_REF", "RECO_DT_CUT_USTAR50", "RECO_DT_CUT_MEAN", "RECO_DT_CUT_SE", "RECO_DT_CUT_05", "RECO_DT_CUT_16", "RECO_DT_CUT_25", "RECO_DT_CUT_50", "RECO_DT_CUT_75", "RECO_DT_CUT_84", "RECO_DT_CUT_95", "GPP_DT_VUT_REF", "GPP_DT_VUT_USTAR50", "GPP_DT_VUT_MEAN", "GPP_DT_VUT_SE", "GPP_DT_VUT_05", "GPP_DT_VUT_16", "GPP_DT_VUT_25", "GPP_DT_VUT_50", "GPP_DT_VUT_75", "GPP_DT_VUT_84", "GPP_DT_VUT_95", "GPP_DT_CUT_REF", "GPP_DT_CUT_USTAR50", "GPP_DT_CUT_MEAN", "GPP_DT_CUT_SE", "GPP_DT_CUT_05", "GPP_DT_CUT_16", "GPP_DT_CUT_25", "GPP_DT_CUT_50", "GPP_DT_CUT_75", "GPP_DT_CUT_84", "GPP_DT_CUT_95", "RECO_SR", "RECO_SR_N"];
% TP4.ws_fill = AM_rm_outlier(TP4.ws,4);
% TP4.ws_fill = AM_fill_month_cycle(TP4.ws_fill,TP4.dateloc,6,18);
% TP4.tc_fill   = AM_fill_day_cycle(TP4.tasp,TP4.dateloc,6,18);

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
TP4.e_sat   = 0.1.*(A0+TP4.tair.*(A1+TP4.tair.*(A2+TP4.tair.*(A3+TP4.tair.*(A4+TP4.tair.*(A5+TP4.tair*A6))))));
TP4.delta   = 4098*TP4.e_sat./((237.3+TP4.tair).^2);                % slope of vapor pressure curve, kPa/C
% TP4.h2o_gm3 =  (0.01802.*TP4.pambKpa)./((R.*TP4.tc_fill+T_0C_K).*((1./TP4.h2ommolm)+(0.01802/18)));

TP4.rho_a = (TP4.pambKpa./(0.28705*(TP4.tair+273.15))).*(1-(0.378*TP4.e_sat.*TP4.RH./TP4.pambKpa));
% TP4.rho_a = AM_fill_day_cycle(TP4.rho_a,TP4.dateloc,6,18);

% %'Calculate water vapor pressure using IRGASON measurements
% TP4.e     =  (TP4.h2omix.*(TP4.pambKpa./100)./(TP4.h2omix+622)).*10^2; % vapor pressure (mb) then x10^6
% TP4.e     =  AM_rm_outlier(TP4.e,3);
% TP4.RH    =  TP4.e./TP4.e_sat;
% ix        =  TP4.e_sat.*(1-TP4.RH./100);                                    % vapour pressure deficit;
% TP4.VPD   =  TP4.e_sat.*(1-TP4.RHec./100);
% TP4.VPD((TP4.VPD<0)|(isnan(TP4.VPD))) = ix((TP4.VPD<0)|(isnan(TP4.VPD)));
% TP4.VPD(TP4.VPD<0) = 0;
% TP4.VPD = AM_fill_month_cycle(TP4.VPD,TP4.dateloc,6,18);
% TP4.VPD((TP4.VPD<0)|(isinf(TP4.VPD))) = 0;
%
% TP4.rho_d =  (TP4.pambKpa-TP4.e)./((TP4.tc_fill+T_0C_K).*Rd);          % 'g/m^3
% %TP4.rho_a =  (TP4.rho_d + TP4.h2o_gm3)./1000;       %Natalia          % 'kg/m^3
%
% % % %..........................................................................
% TP4.e_sat_fill = AM_fill_day_cycle(TP4.e_sat,TP4.dateloc,6,18);
% TP4.rho_a = AM_fill_day_cycle(TP4.rho_a,TP4.dateloc,6,18);
% TP4.e_fill     = AM_fill_day_cycle(TP4.e,TP4.dateloc,6,18);
%
% % .........................................................................
TP4.lambda = (2.50*10^6)-((2.386*10^3).*(TP4.tair));                % 2.45 [MJ kg-1]     % Latent heat of vaporization, 2.45 [MJ kg-1],
TP4.lambda = TP4.lambda./10^6;
% % TP4.delta    =  (4098.*TP4.e_sat_fill)./(power((TP4.tc_fill+237.3),2)); %[kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% % http://agsys.cra-cin.it/tools/evapotranspiration/help/Slope_of_saturation_vapour_pressure_curve.html
% % TP4.delta   =  0.04145.*exp(0.06088.*TP4.tc_fill);              % 0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% TP4.delta   = 4098*TP4.e_sat_fill./((237.3+TP4.tc_fill).^2);      % slope of vapor pressure curve, kPa/C
TP4.sigma  = ((Cp.*TP4.pambKpa)./(0.622.*TP4.lambda));              % sigma psychrometric constant 0.054 [kPa C-1]
% %TP4.sigma   = smooth(TP4.sigma);
% %where epsilon ratio molecular weight of water vapour/dry air  =  0.622
% TP4.epsilon =  TP4.delta./TP4.sigma;                              % Unitless ~0.6219
% % Rho_air: mean air density at constant pressure (Bruutsaet,p38)(kPa kg J-1)
% % % if ((nanmax(TP4.rho_air)>2)|(nanmin(TP4.rho_air)<0.5));   '\rho air inacurate calculation please check';    end;
% % % c = 1.01;                                                     % virtual absolute air temperature Tv = (c.*(TP4.tc_fill+273.15)
% % % TP4.rho_air = TP4.pambpa./((c.*(TP4.tc_fill+273.15)).*R);     % multiply by 10 so we can get the 1.2value??? http://www.fao.org/docrep/x0490e/x0490e06.htm [kg m-3]
% % % Qa  =  0.62197.*TP4.e./((TP4.pambpa./100)-(0.378030.*TP4.e)); % specific humidity (kg/kg)
% % %..........................................................................
% % % 2002-2005
% % %..........................................................................
% % [TP4.h_So]     = AM_solar_rad(TP4.h_JD,TP4.h_HR+1,lat,lon);
% % TP4.h_delta    =  0.04145.*exp(0.06088.*TP4.h_tc_fill);                       %0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% % TP4.h_lambda(isnan(TP4.h_lambda)) = 2.45;
% % TP4.h_sigma    =  ((Cp.*TP4.h_pambKpa)./(0.622.*TP4.h_lambda));                    %[kPa C-1]
% % TP4.h_sigma    =  smooth(TP4.h_sigma);
%
% %..........................................................................
% %% ET ref
% %..........................................................................
% TP4.LEref = AM_fill((TP4.LE+TP4.H).*(TP4.delta./(TP4.delta+(TP4.sigma))));
% % TP4.LEref = AM_fill((TP4.netrad).*(TP4.delta./(TP4.delta+(TP4.sigma))));
% TP4.LEref((TP4.So < 500)|(TP4.rain_fill>0)) = NaN;
% TP4.ETref = AM_fill_plus(TP4.LEref./TP4.lambda);
% TP4.ETref = TP4.ETref.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
%
% %..........................................................................
% TP4.eightETref = AM_eight2cycle_rs(TP4.ETref,TP4.dateloc,tresholdCycleDay,4,2);    TP4.eightETref = AM_fill(TP4.eightETref);
% [TP4.weekETref,~,~,~,~,TP4.week_stdETref]  = AM_week2cycle_rs(TP4.ETref,TP4.dateloc,tresholdCycleDay,4,2);     TP4.weekETref  = AM_fill(TP4.weekETref);
% TP4.monthETref = AM_month2cycle(TP4.ETref,TP4.dateloc,tresholdCycleDay,4,2);       TP4.monthETref = AM_fill(TP4.monthETref);
% TP4.monthETref = AM_month2cycle(TP4.ETref,TP4.dateloc,tresholdCycleDay,4,2);                      TP4.monthETref  = AM_fill(TP4.monthETref);
% TP4.monthETref = TP4.monthETref.*eomday(TP4.monthY,TP4.monthM);
%
% TP4.ETrefday = TP4.ETref;      TP4.ETrefday(TP4.So<=tresholdSo) = NaN;
% [TP4.weekETrefday,~,~,~,~,TP4.week_stdETrefday]  = AM_week2cycle_rs(TP4.ETrefday,TP4.dateloc,tresholdCycleDay,4,2);     TP4.weekETrefday  = AM_fill(TP4.weekETrefday);
% [TP4.monthETrefday,~,~,~,~,TP4.month_stdETrefday]= AM_month2cycle(TP4.ETrefday,TP4.dateloc,tresholdCycleDay,4,2);     TP4.monthETrefday  = AM_fill(TP4.monthETrefday);
%
% TP4.LErefday = TP4.LEref;      TP4.LErefday(TP4.So<=tresholdSo) = NaN;
% [TP4.weekLErefday,~,~,~,~,TP4.week_stdLErefday]  = AM_week2cycle_rs(TP4.LErefday,TP4.dateloc,tresholdCycleDay,4,2);     TP4.weekLErefday  = AM_fill(TP4.weekLErefday);
%
% %..........................................................................
% %% Rain
% %..........................................................................
% [~,~,TP4.eightRain] = AM_eightday_rs(TP4.rain,TP4.dateloc);                         TP4.eightRain = AM_fill(TP4.eightRain);
% [~,~,TP4.weekRain,~,~,TP4.week_stdRain]  = AM_week2day_rs(TP4.rain,TP4.dateloc);    TP4.weekRain  = AM_fill(TP4.weekRain);
% [~,TP4.monthRain] = AM_month(TP4.rain,TP4.dateloc);                                 TP4.monthRain = AM_fill(TP4.monthRain);
[TP4.cycle_month_LE,TP4.cycle_month_countLE,~,TP4.cycle_month_stdLE] = ...
    AM_day_cycle_year(TP4.LE,TP4.dateloc);
[TP4.cycle_month_netrad,TP4.cycle_month_countnetrad,~,TP4.cycle_month_stdnetrad] = ...
    AM_day_cycle_year(TP4.netrad,TP4.dateloc);
[TP4.cycle_month_H,TP4.cycle_month_countH,~,TP4.cycle_month_stdH] = ...
    AM_day_cycle_year(TP4.H,TP4.dateloc);

% [TP4.week_avgRain,~,TP4.week_avgstdRain] = AM_week2_avg(TP4.weekRain,TP4.week);
%
% % % [TP4.eightCWD] = AM_eightday_rs(TP4.dayTRMM1hCWD,TP4.day);                            TP4.eightCWD = AM_fill(TP4.eightCWD);
% % % [TP4.weekCWD,~,~,~,~,TP4.week_stdCWD]  = AM_week2day_rs(TP4.dayTRMM1hCWD,TP4.day);    TP4.weekCWD  = AM_fill(TP4.weekCWD);
% % % [TP4.week_avgCWD,~,TP4.week_avgstdCWD] = AM_week2_avg(TP4.weekCWD,TP4.week);
%
% [TP4.eightCWD] = AM_eightday_rs(TP4.dayTRMM1hCWD,TP4.day);                            TP4.eightCWD = AM_fill(TP4.eightCWD);
% [TP4.weekCWD,~,~,~,~,TP4.week_stdCWD]  = AM_week2day_rs(TP4.dayTRMM1hCWD,TP4.day);    TP4.weekCWD  = AM_fill(TP4.weekCWD);
% [TP4.week_avgCWD,~,TP4.week_avgstdCWD] = AM_week2_avg(TP4.weekCWD,TP4.week);
%
% %% ........................................................................
% if flag_Rick == 1
%     ind = find((TP4.dateloc>datetime(2004,12,10))&(TP4.dateloc<datetime(2004,12,20)));
%     ind = find((TP4.dateloc>datetime(2004,8,24))&(TP4.dateloc<datetime(2004,9,7)));
%     figure('color','white');
%     y1 = -.2;     y2 = 1;       y3 = y1:((y2-y1)/4):y2;
%     x1 = 0;       x2 = 2;       x3 = x1:((x2-x1)/4):x2;
%     subplot(2,2,1:2);           hold on;
%     hl1 = bar(TP4.dateloc(ind),TP4.rain(ind)./10,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.8 0.8 0.8]);
%     hl3 = plot(TP4.dateloc(ind),TP4.ET(ind)./24,'Color',[0. 0. .9],'LineWidth',1);
%     hl4 = plot(TP4.dateloc(ind),TP4.ETref(ind)./24,'Color',[0. 0.9 .5],'LineWidth',1);
%     legend ([hl3,hl4],'ET','ET_{ref}','EdgeColor','white')%,'position','southoutside');
%     set(gca,'XTick',TP4.day(1:1:end),'XTickLabel',[ '' '' ''],'YTick',y3,'YColor',[0. 0. .9]); hold on;
%     xlim([TP4.dateloc(ind(1)) TP4.dateloc(ind(end))]);            ylim([y1 y2]);
%     ylabel ({'ET (mm)'},'FontSize',12,'Color',[0. 0. .9]);
%     ax1 = gca;          ax1_pos = ax1.Position;
%     ax2 = axes('Position',ax1_pos,'YAxisLocation','right','Color','none'); hold on;
%     %     hl7 = plot(TP4.dateloc(ind),TP4.tasp(ind),'Parent',ax2,'Color',[0.4 0.4 0.4],'LineWidth',1);    hold on;
%     hl7 = plot(TP4.dateloc(ind),TP4.ustar(ind),'Parent',ax2,'Color',[0.4 0.4 0.4],'LineWidth',1);    hold on;
%     set(ax2,'XColor','k','YColor',[ 0.0 0.0 0.0]);
%     %     ylabel ({'netrad (W m^-^2)'},'FontSize',12,'Color',[0.2 0.2 .2]);
%     %     ylabel ({'T_{air} (\circC)'},'FontSize',12,'Color',[0.4 0.4 .4]);
%     ylabel ({'u_* (m s^-^1)'},'FontSize',12,'Color',[0.4 0.4 .4]);
%     set(ax2,'XTick',TP4.dateloc(ind(1):48:ind(end)),'XTickLabel',datestr(TP4.dateloc(ind(1):48:ind(end)),'yyyy/mm/dd'),'YTick',x3,'YColor',[0.4 0.4 .4]);
%     xlim([TP4.dateloc(ind(1)) TP4.dateloc(ind(end))]);            ylim([x1 x2]);
%     box on; grid on;	text(TP4.dateloc(ind(20)),x3(5),site_name,'FontSize',8)
%
%     ind = find(TP4.So>100);
%     subplot(2,2,3);     hold on;
%     AM_bin(TP4.netrad(ind),TP4.LE(ind),15,1,1,[0 0 0.8]);
%     xlabel({'Rn (W m^-^2)'},'FontSize',10);ylabel ({'LE (W m^-^2)'},'FontSize',10);
%     [p,r2,~,~,sm,sb] = AM_compute_regression(TP4.netrad(ind),TP4.LE(ind),[0.4,0.4,0.4],0);
%     y_model=polyval(p,TP4.netrad(ind));   hold on;
%     plot(TP4.netrad(ind),y_model,'-','color',[0.4,0.4,0.4]);
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

TP4.A = (TP4.LE+TP4.H);
% weekA = AM_week2cycle_rs(TP4.A,TP4.dateloc,20);  weekH = AM_week2cycle_rs(TP4.H,TP4.dateloc,20);  weekLE = AM_week2cycle_rs(TP4.LE,TP4.dateloc,3);
%%
%         ACHTUNG!!!!!!!!!!!!!
% ik Yebra it apears as TP4.ga but looks like TP4.ra!!!!!!!!!!!
% TP4.ra =
% (log((height-d)./zo)).*(log((height-d)./zoh))./(k^2.*TP4.ws_fill);
% Natalia's original I use both zo and zoh
Ra        = (log((z-d)./zo)).*(log((z-d)./zoh))./(k.^2.*TP4.ws);
Ra(TP4.So<tresholdSo) = NaN;        Ra = AM_rm_outlier(Ra,5);
TP4.Ga        = 1./Ra;              TP4.Ga = AM_rm_outlier(TP4.Ga,5);
Ra_ustar  = TP4.ws./(TP4.ustar.^2);
Ra_ustar(TP4.So<tresholdSo) = NaN;	Ra_ustar = AM_rm_outlier(Ra_ustar,5);
Ga_ustar  = 1./Ra_ustar;            Ga_ustar = AM_rm_outlier(Ga_ustar,5);

%..........................................................................
%% PET from PM equation
%..........................................................................
% rho_a 1.2 kg m-3  Cp = 1.013 10-3 [MJ kg-1 C-1] > [J kg-1 k-1]   >>> delta [kPa m-2]
% lambda 2.45 [MJ kg-1]
% TP4.LErefPM = ((AM_fill((TP4.LE+TP4.H).*TP4.delta)+(TP4.rho_a.*Cp.*10^6.*TP4.VPD.*TP4.Ga)))./(TP4.delta+TP4.sigma);
TP4.LErefPM = ((AM_fill((TP4.netrad).*TP4.delta)+(TP4.rho_a.*Cp.*10^6.*TP4.VPD.*TP4.Ga)))./(TP4.delta+TP4.sigma);
TP4.ETrefPM = TP4.LErefPM./TP4.lambda;
TP4.ETrefPM = TP4.ETrefPM.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
TP4.ETrefdayPM = TP4.ETrefPM;      TP4.ETrefdayPM(TP4.So<=tresholdSo) = NaN;

% lambda    =  2.45;                                                                 % [MJ kg-1] FAO latent heat of vaporization of water
TP4.lambda = ((2.50*10^6)-((2.386*10^3).*(TP4.tair)))./10^6; % 2.45 [MJ kg-1]     % Latent heat of vaporization, 2.45 [MJ kg-1],

TP4.ET = TP4.LE./TP4.lambda;
TP4.ET = TP4.ET.*60.*60.*24/1000000;      % from s-1 to d-1 and from kg-1 to g-1 (mm)

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
TP4.e      = TP4.RH.*TP4.e_sat./100;

% TP4.delta =  (4098.*TP4.e_sat_fill)./(power((TP4.tc_fill+237.3),2));  %[kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% http://agsys.cra-cin.it/tools/evapotranspiration/help/Slope_of_saturation_vapour_pressure_curve.html
% TP4.delta =  0.04145.*exp(0.06088.*TP4.tc_fill);     % 0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
TP4.delta = 4098*TP4.e_sat./((237.3+TP4.tair).^2);     % slope of vapor pressure curve, kPa/C

TP4.sigma = ((Cp.*TP4.pambKpa)./(0.622.*TP4.lambda));  % sigma psychrometric constant 0.054 [kPa C-1]
%TP4.sigma   = smooth(TP4.sigma);
%where epsilon ratio molecular weight of water vapour/dry air  =  0.622
TP4.epsilon =  TP4.delta./TP4.sigma;                   % Unitless ~0.6219

TP4.ET = TP4.LE./TP4.lambda;
TP4.ET = TP4.ET.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)

% %..........................................................................
% %% ET dry conditions
% %..........................................................................
% ik = find(TP4.rain_fill>0);
% ij = zeros(length(TP4.rain_fill),1);
% ij(ik) = 1;                         indDry24 = ij;           im = 1;
% while im < length(ij)-25
%     if ij(im) == 1
%         for in = 1:24
%             indDry24(im+in) = 1;
%         end
%     end
%     im = im + 1;
% end
% TP4.LEdry24 = TP4.LE;             TP4.ETdry24 = TP4.ET;
% TP4.LEdry24(indDry24==1) = NaN;     TP4.ETdry24(indDry24==1) = NaN;
% TP4.ETdryday24 = TP4.ETdry24;     TP4.ETdryday24(TP4.So<tresholdSo) = NaN;
%
% TP4.ETrefdry24 = TP4.ETref;           TP4.ETrefdry24(indDry24==1) = NaN;
% TP4.ETrefdryday24 = TP4.ETrefdry24;   TP4.ETrefdryday24(TP4.So<tresholdSo) = NaN;
%
% TP4.LEwet24 = TP4.LE;               TP4.ETwet24 = TP4.ET;
% TP4.LEwet24(indDry24==0) = NaN;     TP4.ETwet24(indDry24==0) = NaN;
% TP4.ETwetday24 = TP4.ETwet24;       TP4.ETwetday24(TP4.So<tresholdSo) = NaN;
%
% TP4.ETrefwet24 = TP4.ETref;         TP4.ETrefwet24(indDry24==0) = NaN;
% TP4.ETrefwetday24 = TP4.ETrefwet24; TP4.ETrefwetday24(TP4.So<tresholdSo) = NaN;
%
%..........................................................................
%% ET dry conditions
%..........................................................................
% Remove 12h after precipitation
ik = find(TP4.rain>0);
ij = zeros(length(TP4.rain),1);
ij(ik) = 1;                         indDry = ij;           im = 1;
while im < length(ij)-13
    if ij(im) == 1
        for in = 1:12
            indDry(im+in) = 1;
        end
    end
    im = im + 1;
end
TP4.LEdry = TP4.LE;             TP4.ETdry = TP4.ET;
TP4.LEdry(indDry==1) = NaN;     TP4.ETdry(indDry==1) = NaN;
TP4.ETdryday = TP4.ETdry;       TP4.ETdryday(TP4.So<tresholdSo) = NaN;

% TP4.ETrefdry = TP4.ETref;       TP4.ETrefdry(indDry==1) = NaN;
% TP4.ETrefdryday = TP4.ETrefdry; TP4.ETrefdryday(TP4.So<tresholdSo) = NaN;

TP4.LEwet = TP4.LE;             TP4.ETwet = TP4.ET;
TP4.LEwet(indDry==0) = NaN;     TP4.ETwet(indDry==0) = NaN;
TP4.ETwetday = TP4.ETwet;       TP4.ETwetday(TP4.So<tresholdSo) = NaN;

% TP4.ETrefwet = TP4.ETref;         TP4.ETrefwet(indDry==0) = NaN;
% TP4.ETrefwetday = TP4.ETrefwet;   TP4.ETrefwetday(TP4.So<tresholdSo) = NaN;

ix = TP4.HR.*indDry; ix(indDry==0) = NaN;
figure ('color','white');       histogram(ix,24);
ylabel('Frequency time rainfall');
xlabel('Local time rainfall TP4');

%..................................................................
%%         As in Yebra
%..................................................................
A   = TP4.LE+TP4.H;
% A   = TP4.netrad;       ix = TP4.LE+TP4.H;              A(isnan(A)) = ix(isnan(A));
one = TP4.epsilon.*A;   two = (TP4.epsilon+1).*TP4.LE;	three = TP4.rho_a.*10^6.*Cp.*(TP4.e_sat-TP4.e).*TP4.Ga./TP4.sigma;
Gs_OptionY = TP4.LE.*TP4.Ga./(one-two+three);
Gs_OptionY = Gs_OptionY.*1000;              %m s-1 to mm s-1
Gs_OptionY((Gs_OptionY<=0)|(Gs_OptionY>200)) = NaN;
Gs_OptionY((TP4.So<tresholdSo)|(TP4.rain>0)) = NaN;         Gs_OptionY = AM_rm_outlier(Gs_OptionY,3);
%..................................................................
one = TP4.epsilon.*A;   two = (TP4.epsilon+1).*TP4.LE;
three = TP4.rho_a.*10^6.*Cp.*(TP4.e_sat-TP4.e).*Ga_ustar./TP4.sigma;    three = AM_rm_outlier(three,3);
Gs_OptionYustar = TP4.LE.*Ga_ustar./(one-two+three);
Gs_OptionYustar = Gs_OptionYustar.*1000;    %m s-1 to mm s-1
Gs_OptionYustar((Gs_OptionYustar<=0)|(Gs_OptionYustar>1000)) = NaN;
Gs_OptionYustar((TP4.So<tresholdSo)|(TP4.rain>0)) = NaN;    Gs_OptionYustar = AM_rm_outlier(Gs_OptionYustar,3);

%..................................................................
%%         As in Blanken & Black, 2004
%..................................................................
TP4.Bowen   = TP4.H./TP4.LE;
Rs_OptionBB = (((TP4.epsilon.*TP4.Bowen)-1).*Ra)+((TP4.rho_a.*Cp.*10^6.*TP4.VPD)./(TP4.sigma.*TP4.LE));
Gs_OptionBB = 1000./Rs_OptionBB;
Gs_OptionBB((Gs_OptionBB<=0)|(Gs_OptionBB>400)) = NaN;
Gs_OptionBB((TP4.So<tresholdSo)|(TP4.rain>0)) = NaN;        Gs_OptionBB = AM_rm_outlier(Gs_OptionBB,3);

Rs_OptionBB_ustar = (((TP4.epsilon.*TP4.Bowen)-1).*Ra_ustar)+((TP4.rho_a.*Cp.*10^6.*TP4.VPD)./(TP4.sigma.*TP4.LE));
Gs_OptionBB_ustar = 1000./Rs_OptionBB_ustar;
Gs_OptionBB_ustar((Gs_OptionBB_ustar<=0)|(Gs_OptionBB_ustar>200)) = NaN;
Gs_OptionBB_ustar((TP4.So<tresholdSo)|(TP4.rain>0)) = NaN;	Gs_OptionBB_ustar = AM_rm_outlier(Gs_OptionBB_ustar,3);

% .........................................................................
TP4.BowenDry = TP4.H./TP4.LEdry;
Rs_OptionBBdry = (((TP4.epsilon.*TP4.BowenDry)-1).*Ra)+((TP4.rho_a.*Cp.*10^6.*TP4.VPD)./(TP4.sigma.*TP4.LEdry));
Gs_OptionBBdry = 1000./Rs_OptionBBdry;
Gs_OptionBBdry((Gs_OptionBBdry<=0)|(Gs_OptionBBdry>400)) = NaN;
Gs_OptionBBdry((TP4.So<tresholdSo)|(TP4.rain>0)) = NaN;     Gs_OptionBBdry = AM_rm_outlier(Gs_OptionBBdry,3);

Rs_OptionBBdry_ustar = (((TP4.epsilon.*TP4.BowenDry)-1).*Ra_ustar)+((TP4.rho_a.*Cp.*10^6.*TP4.VPD)./(TP4.sigma.*TP4.LEdry));
Gs_OptionBBdry_ustar = 1000./Rs_OptionBBdry_ustar;
Gs_OptionBBdry_ustar((Gs_OptionBBdry_ustar<=0)|(Gs_OptionBBdry_ustar>200)) = NaN;
Gs_OptionBBdry_ustar((TP4.So<tresholdSo)|(TP4.rain>0)) = NaN;
Gs_OptionBBdry_ustar = AM_rm_outlier(Gs_OptionBBdry_ustar,3);

% %..................................................................
% % Climatological resistance
% %..................................................................
% TP4.Ri = (TP4.rho_a.*Cp.*10^6.*TP4.VPD)./(TP4.sigma.*(TP4.LE+TP4.H));
% %TP4.Ri = (TP4.rho_a.*Cp.*10^6.*TP4.VPD)./(TP4.sigma.*(TP4.netrad));
% TP4.Gi = 1000./TP4.Ri;
% TP4.Gi(TP4.So<tresholdSo) = NaN;        TP4.Gi(TP4.Gi<0) = NaN;
% TP4.Gi = AM_rm_outlier(TP4.Gi,3);
%
% % Equilibrium LE
% TP4.PTalpha = TP4.LE./TP4.LEref;

% .........................................................................
%% Gs units mm s-1
% .........................................................................
TP4.GsPMall   = Gs_OptionBB;
TP4.GsPM      = Gs_OptionBBdry;
TP4.GsPMustar = Gs_OptionBB_ustar;

% From Pearcy et all. Measurement of transpiration and leaf conductance
% P in kPa, tair in degC, Gs from cm/s to mol m-2s-1
% TP4.GsPMallmol = TP4.GsPMall.*0.446.*(273./(273+TP4.tasp_fill)).*((TP4.pambpa_fill./1000)./101.3);

% Gas ideal gas law Gs [m s-1] x Pa[kPa]/R [m3 Pa K-1 mol] x Ta [k]   % average sea-level pressure is 101.325 kPa
% R = 8.3144621 m3 Pa K−1 mol−1   8.3144621 m3 /1000 kPa-1 K-1 mol
% Gs mol m-2 s-1
TP4.GsPMmmol = (TP4.GsPM./1000).*TP4.pambKpa./(R.*(273+TP4.tair));
TP4.GsPMmmol = TP4.GsPMmmol.*1000;
% Typical values for irrigated trials are: 300-700 mmol m-2s-1;
% and for mildly water stressed trials are: 80-300 mmol m-2s-1
TP4.GsPMallmmol = (TP4.GsPMall./1000).*(TP4.pambpa./1000)./(R.*(273+TP4.tair));
TP4.GsPMallmmol = TP4.GsPMallmmol.*1000;

% ........................................................................
%% ETref
% ........................................................................
TP4.LEref = AM_fill((TP4.LE+TP4.H).*(TP4.delta./(TP4.delta+(TP4.sigma))));
% TP4.LEref = AM_fill((TP4.netrad).*(TP4.delta./(TP4.delta+(TP4.sigma))));
TP4.LEref(TP4.So < tresholdSo) = NaN;
TP4.ETref = AM_fill_plus(TP4.LEref./TP4.lambda);
TP4.ETref = TP4.ETref.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)

% ........................................................................
%% day
% ........................................................................
[TP4.dayLE,~,x,~,TP4.daydate,TP4.dayLEmin,TP4.dayLEmax]   = AM_day(TP4.LE,TP4.dateloc,0);
TP4.dayLE(x<tresholdCycle) = NaN;         TP4.dayLEmin(x<tresholdCycle) = NaN;        TP4.dayLEmax(x<tresholdCycle) = NaN;
[TP4.dayH,~,x,~,~,TP4.dayHmin,TP4.dayHmax]   = AM_day(TP4.H,TP4.dateloc,0);
TP4.dayH(x<tresholdCycle) = NaN;         TP4.dayHmin(x<tresholdCycle) = NaN;        TP4.dayHmax(x<tresholdCycle) = NaN;
[TP4.daynetrad,~,x,~,~,TP4.daynetradmin,TP4.daynetradmax]   = AM_day(TP4.netrad,TP4.dateloc,0);
TP4.daynetrad(x<tresholdCycle) = NaN;         TP4.daynetradmin(x<tresholdCycle) = NaN;        TP4.daynetradmax(x<tresholdCycle) = NaN;
[TP4.daytair,~,x,~,~,TP4.daytairmin,TP4.daytairmax]   = AM_day(TP4.tair,TP4.dateloc,0);
TP4.daytair(x<tresholdCycle) = NaN;         TP4.daytairmin(x<tresholdCycle) = NaN;        TP4.daytairmax(x<tresholdCycle) = NaN;

[TP4.eightH,~,~,~,~,TP4.eight_stdH,TP4.eight] = AM_eight2cycle_rs(TP4.H,TP4.dateloc,tresholdCycle,2,3);    TP4.eightH = AM_fill(TP4.eightH);
TP4.eightLE = AM_eight2cycle_rs(TP4.LE,TP4.dateloc,tresholdCycle,2,3);    TP4.eightLE = AM_fill(TP4.eightLE);
TP4.eightnetrad = AM_eight2cycle_rs(TP4.netrad,TP4.dateloc,tresholdCycle,2,3);    TP4.eightnetrad = AM_fill(TP4.eightnetrad);
TP4.eighttair = AM_eight2cycle_rs(TP4.tair,TP4.dateloc,tresholdCycle,2,3);    TP4.eighttair = AM_fill(TP4.eighttair);

[TP4.weekH,~,~,~,~,TP4.week_stdH] = AM_week2cycle_rs(TP4.H,TP4.dateloc,tresholdCycle,2,3);  TP4.weekH  = AM_fill(TP4.weekH);
[TP4.weekLE,~,~,~,~,TP4.week_stdLE] = AM_week2cycle_rs(TP4.LE,TP4.dateloc,tresholdCycle,2,3);  TP4.weekLE  = AM_fill(TP4.weekLE);
[TP4.weeknetrad,~,~,~,~,TP4.week_stdnetrad] = AM_week2cycle_rs(TP4.netrad,TP4.dateloc,tresholdCycle,2,3);  TP4.weeknetrad  = AM_fill(TP4.weeknetrad);
[TP4.weektair,~,~,~,~,TP4.week_stdtair] = AM_week2cycle_rs(TP4.tair,TP4.dateloc,tresholdCycle,2,3);  TP4.weektair  = AM_fill(TP4.weektair);

[TP4.monthH,~,~,TP4.monthHmin,TP4.monthHmax] = AM_month2cycle(TP4.H,TP4.dateloc,tresholdCycle,2,2);
TP4.monthH = AM_fill(TP4.monthH);
[TP4.monthLE,~,~,TP4.monthLEmin,TP4.monthLEmax] = AM_month2cycle(TP4.LE,TP4.dateloc,tresholdCycle,2,2);
TP4.monthLE = AM_fill(TP4.monthLE);
[TP4.monthnetrad,~,~,TP4.monthnetradmin,TP4.monthnetradmax] = AM_month2cycle(TP4.netrad,TP4.dateloc,tresholdCycle,2,2);
TP4.monthnetrad = AM_fill(TP4.monthnetrad);
[TP4.monthtair,~,~,TP4.monthtairmin,TP4.monthtairmax] = AM_month2cycle(TP4.tair,TP4.dateloc,tresholdCycle,2,2);
TP4.monthtair = AM_fill(TP4.monthtair);

[TP4.dayGEP,~,x,~,~,TP4.dayGEPmin,TP4.dayGEPmax] = AM_day(TP4.gep.*gC_m2_d1,TP4.dateloc,0);
TP4.dayGEP(x<tresholdCycle) = NaN;                 TP4.dayGEPmin(x<tresholdCycle) = NaN;
TP4.dayGEPmax(x<tresholdCycle) = NaN;
TP4.eightGEP = AM_eight2cycle_rs(TP4.gep.*gC_m2_d1,TP4.dateloc,tresholdCycle,2,3);
TP4.eightGEP = AM_fill(TP4.eightGEP);
[TP4.weekGEP,~,~,~,~,TP4.week_stdGEP,TP4.week] = AM_week2cycle_rs(TP4.gep.*gC_m2_d1,TP4.dateloc,tresholdCycle,2,3);
TP4.weekGEP  = AM_fill(TP4.weekGEP);
[TP4.monthGEP,~,~,TP4.monthGEPmin,TP4.monthGEPmax] = AM_month2cycle(TP4.gep.*gC_m2_d1,TP4.dateloc,tresholdCycle,2,2);
TP4.monthGEP = AM_fill(TP4.monthGEP);

[TP4.dayRECO,~,x,~,~,TP4.dayRECOmin,TP4.dayRECOmax] = AM_day(TP4.reco.*gC_m2_d1,TP4.dateloc,0);
TP4.dayRECO(x<tresholdCycle) = NaN;                TP4.dayRECOmin(x<tresholdCycle) = NaN;
TP4.dayRECOmax(x<tresholdCycle) = NaN;
TP4.eightRECO = AM_eight2cycle_rs(TP4.reco.*gC_m2_d1,TP4.dateloc,tresholdCycle,2,3);
TP4.eightRECO = AM_fill(TP4.eightRECO);
[TP4.weekRECO,~,~,~,~,TP4.week_stdRECO,TP4.week] = AM_week2cycle_rs(TP4.reco.*gC_m2_d1,TP4.dateloc,tresholdCycle,2,3);
TP4.weekRECO  = AM_fill(TP4.weekRECO);
[TP4.monthRECO,~,~,TP4.monthRECOmin,TP4.monthRECOmax] = AM_month2cycle(TP4.reco.*gC_m2_d1,TP4.dateloc,tresholdCycle,2,2);
TP4.monthRECO = AM_fill(TP4.monthRECO);

[TP4.dayNEE,~,x,~,~,TP4.dayNEEmin,TP4.dayNEEmax] = AM_day(TP4.nee.*gC_m2_d1,TP4.dateloc,0);
TP4.dayNEE(x<tresholdCycle) = NaN;                                  TP4.dayNEEmin(x<tresholdCycle) = NaN;
TP4.dayNEEmax(x<tresholdCycle) = NaN;
TP4.eightNEE = AM_eight2cycle_rs(TP4.nee.*gC_m2_d1,TP4.dateloc,tresholdCycle,2,3);
TP4.eightNEE = AM_fill(TP4.eightNEE);
[TP4.weekNEE,~,~,~,~,TP4.week_stdNEE,TP4.week] = AM_week2cycle_rs(TP4.nee.*gC_m2_d1,TP4.dateloc,tresholdCycle,2,3);
TP4.weekNEE  = AM_fill(TP4.weekNEE);
[TP4.monthNEE,~,~,TP4.monthNEEmin,TP4.monthNEEmax] = AM_month2cycle(TP4.nee.*gC_m2_d1,TP4.dateloc,tresholdCycle,2,2);
TP4.monthNEE = AM_fill(TP4.monthNEE);
%% ...........................................
TP4.LEday = TP4.LE;             TP4.LEday(TP4.So<tresholdSo) = NaN;
TP4.Hday = TP4.H;               TP4.Hday(TP4.So<tresholdSo) = NaN;
TP4.netradday = TP4.netrad;     TP4.netradday(TP4.So<tresholdSo) = NaN;
TP4.tairday = TP4.tair;         TP4.tairday(TP4.So<tresholdSo) = NaN;
TP4.ustarday = TP4.ustar;     TP4.ustarday(TP4.So<tresholdSo);
TP4.EF = AM_fill(TP4.LE./(TP4.LE+TP4.H));
TP4.EFday = AM_fill(TP4.LE./(TP4.LE+TP4.H));         TP4.EFday(TP4.So<tresholdSo) = NaN;
TP4.EFday((TP4.EFday<0)|(TP4.EFday>1)) = NaN;   TP4.EFday = AM_rm_outlier(TP4.EFday,3);
TP4.Bowenday = TP4.Bowen;     TP4.Bowenday(TP4.So<tresholdSo);

[TP4.dayLEday,~,x,~,~,TP4.dayLEdaymin,TP4.dayLEdaymax] = AM_day(TP4.LEday,TP4.dateloc,0);
TP4.dayLEday(x<tresholdCycleDay) = NaN;        TP4.dayLEdaymin(x<tresholdCycleDay) = NaN;      TP4.dayLEdaymax(x<tresholdCycleDay) = NaN;
[TP4.dayHday,~,x,~,~,TP4.dayHdaymin,TP4.dayHdaymax] = AM_day(TP4.H,TP4.dateloc,0);
TP4.dayHday(x<tresholdCycleDay) = NaN;         TP4.dayHdaymin(x<tresholdCycleDay) = NaN;          TP4.dayHdaymax(x<tresholdCycleDay) = NaN;
[TP4.daynetradday,~,x,~,~,TP4.daynetraddaymin,TP4.daynetraddaymax] = AM_day(TP4.netradday,TP4.dateloc,0);
TP4.daynetradday(x<tresholdCycleDay) = NaN;    TP4.daynetraddaymin(x<tresholdCycleDay) = NaN; TP4.daynetraddaymax(x<tresholdCycleDay) = NaN;
[TP4.daytairday,~,x,~,~,TP4.daytairdaymin,TP4.daytairdaymax] = AM_day(TP4.tairday,TP4.dateloc,0);
TP4.daytairday(x<tresholdCycleDay) = NaN;      TP4.daytairdaymin(x<tresholdCycleDay) = NaN;         TP4.daytairdaymax(x<tresholdCycleDay) = NaN;

[TP4.eightHday,~,~,~,~,TP4.eight_stdHday,TP4.eight] = AM_eight2cycle_rs(TP4.Hday,TP4.dateloc,tresholdCycleDay,2,3);    TP4.eightHday = AM_fill(TP4.eightHday);
TP4.eightLEday = AM_eight2cycle_rs(TP4.LEday,TP4.dateloc,tresholdCycleDay,2,3);   TP4.eightLEday = AM_fill(TP4.eightLEday);
TP4.eightnetradday = AM_eight2cycle_rs(TP4.netradday,TP4.dateloc,tresholdCycleDay,2,3); TP4.eightnetradday = AM_fill(TP4.eightnetradday);
TP4.eighttairday = AM_eight2cycle_rs(TP4.tairday,TP4.dateloc,tresholdCycleDay,2,3);     TP4.eighttairday = AM_fill(TP4.eighttairday);

[TP4.weekHday,~,~,~,~,TP4.week_stdHday,TP4.week] = AM_week2cycle_rs(TP4.Hday,TP4.dateloc,tresholdCycleDay,2,3);        TP4.weekHday  = AM_fill(TP4.weekHday);
[TP4.weekLEday,~,~,~,~,TP4.week_stdLEday] = AM_week2cycle_rs(TP4.LEday,TP4.dateloc,tresholdCycleDay,2,3);                   TP4.weekLEday = AM_fill(TP4.weekLEday);
[TP4.weeknetradday,~,~,~,~,TP4.week_stdnetradday] = AM_week2cycle_rs(TP4.netradday,TP4.dateloc,tresholdCycleDay,2,3);  TP4.weeknetradday  = AM_fill(TP4.weeknetradday);
[TP4.weektairday,~,~,~,~,TP4.week_stdtairday] = AM_week2cycle_rs(TP4.tairday,TP4.dateloc,tresholdCycleDay,2,3);                 TP4.weektairday = AM_fill(TP4.weektairday);
[TP4.weekustarday,~,~,~,~,TP4.week_stdustarday] = AM_week2cycle_rs(TP4.ustarday,TP4.dateloc,tresholdCycleDay,2,3);        TP4.weekustarday = AM_fill(TP4.weekustarday);
[TP4.weekBowen,~,~,~,~,TP4.week_stdBowen] = AM_week2cycle_rs(TP4.Bowen,TP4.dateloc,tresholdCycleDay,2,3);                TP4.weekBowen = AM_fill(TP4.weekBowen);
[TP4.weekEF,~,~,~,~,TP4.week_stdEF] = AM_week2cycle_rs(TP4.EF,TP4.dateloc,tresholdCycleDay,2,3); TP4.weekEF = AM_fill(TP4.weekEF);
[TP4.weekET,~,~,~,~,TP4.week_stdET] = AM_week2cycle_rs(TP4.ET,TP4.dateloc,tresholdCycleDay,2,3); TP4.weekET = AM_fill(TP4.weekET);
[TP4.weekETdry,~,~,~,~,TP4.week_stdETdry] = AM_week2cycle_rs(TP4.ETdry,TP4.dateloc,tresholdCycleDay,2,3);                     TP4.weekETdry = AM_fill(TP4.weekETdry);
[TP4.weekETdryday,~,~,~,~,TP4.week_stdETdryday] = AM_week2cycle_rs(TP4.ETdryday,TP4.dateloc,tresholdCycleDay,2,3);    TP4.weekETdryday = AM_fill(TP4.weekETdryday);
[TP4.weekGsPMmmol,~,~,~,~,TP4.week_stdGsPMmmol] = AM_week2cycle_rs(TP4.GsPMmmol,TP4.dateloc,tresholdCycleDay,2,3); TP4.weekGsPMmmol = AM_fill(TP4.weekGsPMmmol);
[TP4.weekLEdry,~,~,~,~,TP4.week_stdLEdry] = AM_week2cycle_rs(TP4.LEdry,TP4.dateloc,tresholdCycleDay,2,3);    TP4.weekLEdry = AM_fill(TP4.weekLEdry);
[TP4.weekEFday,~,~,~,~,TP4.week_stdEFday] = AM_week2cycle_rs(TP4.EFday,TP4.dateloc,tresholdCycleDay,2,3); TP4.weekEFday = AM_fill(TP4.weekEFday);
[TP4.weekBowenday,~,~,~,~,TP4.week_stdBowenday] = AM_week2cycle_rs(TP4.Bowenday,TP4.dateloc,tresholdCycleDay,2,3); TP4.weekBowenday = AM_fill(TP4.weekBowenday);

TP4.GEPday = TP4.gep;        TP4.GEPday(TP4.So<tresholdSo) = NaN;
[TP4.dayGEPday,~,x,~,~,TP4.dayGEPdaymin,TP4.dayGEPdaymax] = AM_day(TP4.GEPday,TP4.dateloc,0);
TP4.dayGEPday(x<tresholdCycleDay) = NaN;        TP4.dayGEPdaymin(x<tresholdCycleDay) = NaN;      TP4.dayGEPdaymax(x<tresholdCycleDay) = NaN;
TP4.eightGEPday = AM_eight2cycle_rs(TP4.GEPday,TP4.dateloc,tresholdCycleDay,2,3);   TP4.eightGEPday = AM_fill(TP4.eightGEPday);
[TP4.weekGEPday,~,~,~,~,TP4.week_stdGEPday] = AM_week2cycle_rs(TP4.GEPday,TP4.dateloc,tresholdCycleDay,2,3);       TP4.weekGEPday  = AM_fill(TP4.weekGEPday);
[TP4.monthGEPday,~,~,~,~,TP4.month_stdGEPday] = AM_month2cycle(TP4.GEPday,TP4.dateloc,tresholdCycleDay,2,3);       TP4.monthGEPday  = AM_fill(TP4.monthGEPday);

TP4.RECOday = TP4.reco;        TP4.RECOday(TP4.So<tresholdSo) = NaN;
[TP4.dayRECOday,~,x,~,~,TP4.dayRECOdaymin,TP4.dayRECOdaymax] = AM_day(TP4.RECOday,TP4.dateloc,0);
TP4.dayRECOday(x<tresholdCycleDay) = NaN;        TP4.dayRECOdaymin(x<tresholdCycleDay) = NaN;      TP4.dayRECOdaymax(x<tresholdCycleDay) = NaN;
TP4.eightRECOday = AM_eight2cycle_rs(TP4.RECOday,TP4.dateloc,tresholdCycleDay,2,3);   TP4.eightRECOday = AM_fill(TP4.eightRECOday);
[TP4.weekRECOday,~,~,~,~,TP4.week_stdRECOday] = AM_week2cycle_rs(TP4.RECOday,TP4.dateloc,tresholdCycleDay,2,3);       TP4.weekRECOday  = AM_fill(TP4.weekRECOday);
[TP4.monthRECOday,~,~,~,~,TP4.month_stdRECOday] = AM_month2cycle(TP4.RECOday,TP4.dateloc,tresholdCycleDay,2,3);       TP4.monthRECOday  = AM_fill(TP4.monthRECOday);

TP4.NEEday = TP4.nee;        TP4.NEEday(TP4.So<tresholdSo) = NaN;
[TP4.dayNEEday,~,x,~,~,TP4.dayNEEdaymin,TP4.dayNEEdaymax] = AM_day(TP4.NEEday,TP4.dateloc,0);
TP4.dayNEEday(x<tresholdCycleDay) = NaN;        TP4.dayNEEdaymin(x<tresholdCycleDay) = NaN;      TP4.dayNEEdaymax(x<tresholdCycleDay) = NaN;
TP4.eightNEEday = AM_eight2cycle_rs(TP4.NEEday,TP4.dateloc,tresholdCycleDay,2,3);   TP4.eightNEEday = AM_fill(TP4.eightNEEday);
[TP4.weekNEEday,~,~,~,~,TP4.week_stdNEEday] = AM_week2cycle_rs(TP4.NEEday,TP4.dateloc,tresholdCycleDay,2,3);       TP4.weekNEEday  = AM_fill(TP4.weekNEEday);
[TP4.monthNEEday,~,~,~,~,TP4.month_stdNEEday] = AM_month2cycle(TP4.NEEday,TP4.dateloc,tresholdCycleDay,2,3);       TP4.monthNEEday  = AM_fill(TP4.monthNEEday);

%%
[TP4.weekETref,~,~,~,~,TP4.week_stdETref] = AM_week2cycle_rs(TP4.ETref,TP4.dateloc,tresholdCycleDay,2,3);      TP4.weekETref = AM_fill(TP4.weekETref);
[TP4.weekGsPM,~,~,~,~,TP4.week_stdGsPM] = AM_week2cycle_rs(TP4.GsPM,TP4.dateloc,tresholdCycleDay,2,3);  TP4.weekGsPM = AM_fill(TP4.weekGsPM);
[TP4.weekGsPMmmol,~,~,~,~,TP4.week_stdGsPMmmol] = AM_week2cycle_rs(TP4.GsPMmmol,      TP4.dateloc,tresholdCycleDay,2,3); TP4.weekGsPMmmol = AM_fill(TP4.weekGsPMmmol);
[TP4.weekLEdry,~,~,~,~,TP4.week_stdLEdry] = AM_week2cycle_rs(TP4.LEdry,TP4.dateloc,tresholdCycleDay,2,3);    TP4.weekLEdry = AM_fill(TP4.weekLEdry);
[TP4.weekEFday,~,~,~,~,TP4.week_stdEFday] = AM_week2cycle_rs(TP4.EFday,TP4.dateloc,tresholdCycleDay,2,3); TP4.weekEFday = AM_fill(TP4.weekEFday);
[TP4.weekBowenday,~,~,~,~,TP4.week_stdBowenday] = AM_week2cycle_rs(TP4.Bowenday,TP4.dateloc,tresholdCycleDay,2,3); TP4.weekBowenday = AM_fill(TP4.weekBowenday);
% [TP4.weektairday,~,~,~,~,TP4.week_stdtairday] = AM_week2cycle_rs(TP4.tairday,TP4.dateloc,tresholdCycleDay,2,3); TP4.weektairday = AM_fill(TP4.weektairday);

[TP4.monthHday,~,~,TP4.monthHdaymin,TP4.monthHdaymax,~,TP4.month] = AM_month2cycle(TP4.Hday,TP4.dateloc,tresholdCycleDay,2,2);
TP4.monthHday = AM_fill(TP4.monthHday);
[TP4.monthLEday,~,~,TP4.monthLEdaymin,TP4.monthLEdaymax] = AM_month2cycle(TP4.LEday,TP4.dateloc,tresholdCycleDay,2,2);
TP4.monthLEday = AM_fill(TP4.monthLEday);
[TP4.monthnetradday,~,~,TP4.monthnetraddaymin,TP4.monthnetraddaymax] = AM_month2cycle(TP4.netradday,TP4.dateloc,tresholdCycleDay,2,2);
TP4.monthnetradday = AM_fill(TP4.monthnetradday);
[TP4.monthtairday,~,~,TP4.monthtairdaymin,TP4.monthtairdaymax] = AM_month2cycle(TP4.tairday,TP4.dateloc,tresholdCycleDay,2,2);
TP4.monthtairday = AM_fill(TP4.monthtairday);

[TP4.weekETrefPM,~,~,~,~,TP4.week_stdETrefPM]  = AM_week2cycle_rs(TP4.ETrefPM,TP4.dateloc,tresholdCycleDay,4,2);
TP4.weekETrefPM  = AM_fill(TP4.weekETrefPM);
[TP4.week_avgETrefPM,~,TP4.week_avgstdETrefPM] = AM_week2_avg(TP4.weekETrefPM,TP4.week);

[TP4.weekETrefdayPM,~,~,~,~,TP4.week_stdETrefdayPM]  = AM_week2cycle_rs(TP4.ETrefdayPM,TP4.dateloc,tresholdCycleDay,4,2);
TP4.weekETrefdayPM  = AM_fill(TP4.weekETrefdayPM);
[TP4.week_avgETrefdayPM,~,TP4.week_avgstdETrefdayPM] = AM_week2_avg(TP4.weekETrefdayPM,TP4.week);

TP4.eightGsPMall = AM_eight2cycle_rs(TP4.GsPMall,TP4.dateloc,tresholdCycleDay,2,3);    TP4.eightGsPMall = AM_fill(TP4.eightGsPMall);
[TP4.weekGsPMall,~,~,~,~,TP4.week_stdGsPMall] = AM_week2cycle_rs(TP4.GsPMall,TP4.dateloc,tresholdCycleDay,2,3);  TP4.weekGsPMall  = AM_fill(TP4.weekGsPMall);
[TP4.monthGsPMall,~,~,TP4.monthGsPMallmin,TP4.monthGsPMallmax] = AM_month2cycle(TP4.GsPMall,TP4.dateloc,tresholdCycleDay,2,2);
TP4.monthGsPMall = AM_fill(TP4.monthGsPMall);     TP4.monthGsPMallmax = AM_fill(TP4.monthGsPMallmax);
[TP4.dayGsPMall,~,x,~,~,TP4.dayGsPMallmin,TP4.dayGsPMallmax]   = AM_day(TP4.GsPMall,TP4.dateloc,0);
TP4.dayGsPMall(x<tresholdCycleDay) = NaN;         TP4.dayGsPMallmin(x<tresholdCycleDay) = NaN;        TP4.dayGsPMallmax(x<tresholdCycleDay) = NaN;

%..........................................................................
%% Seasonality
%..........................................................................
[TP4.week_avgHday,~,TP4.week_avgstdHday]   = AM_week2_avg(TP4.weekHday,TP4.week);
[TP4.week_avgLEday,~,TP4.week_avgstdLEday] = AM_week2_avg(TP4.weekLEday,TP4.week);
[TP4.week_avgnetradday,~,TP4.week_avgstdnetradday] = AM_week2_avg(TP4.weeknetradday,TP4.week);
[TP4.week_avgtairday,~,TP4.week_avgstdtairday] = AM_week2_avg(TP4.weektairday,TP4.week);

[TP4.eight_avgLEday,~,TP4.eight_stdLEday] = AM_eight_avg(TP4.eightLEday,TP4.eight);
[TP4.eight_avgHday,~,TP4.eight_stdHday]   = AM_eight_avg(TP4.eightHday,TP4.eight);
[TP4.eight_avgnetradday,~,TP4.eight_stdnetradday] = AM_eight_avg(TP4.eightnetradday,TP4.eight);
[TP4.eight_avgtairday,~,TP4.eight_stdtairday] = AM_eight_avg(TP4.eighttairday,TP4.eight);

[TP4.month_avgLEday,TP4.month_avgstdLEday] = AM_month_avg(TP4.monthLEday,TP4.month);
[TP4.month_avgHday,TP4.month_avgstdHday]   = AM_month_avg(TP4.monthHday,TP4.month);
[TP4.month_avgnetradday,TP4.month_avgstdnetradday] = AM_month_avg(TP4.monthnetradday,TP4.month);
[TP4.month_avgtairday,TP4.month_avgstdtairday] = AM_month_avg(TP4.monthtairday,TP4.month);

[TP4.month_avgGEPday,TP4.month_avgstdGEPday] = AM_month_avg(TP4.monthGEPday,TP4.month);
[TP4.week_avgGEPday,~,TP4.week_avgstdGEPday] = AM_week2_avg(TP4.weekGEPday,TP4.week);
[TP4.eight_avgGEPday,~,TP4.eight_stdGEPday]  = AM_eight_avg(TP4.eightGEPday,TP4.eight);

[TP4.month_avgRECOday,TP4.month_avgstdRECOday] = AM_month_avg(TP4.monthRECOday,TP4.month);
[TP4.week_avgRECOday,~,TP4.week_avgstdRECOday] = AM_week2_avg(TP4.weekRECOday,TP4.week);
[TP4.eight_avgRECOday,~,TP4.eight_stdRECOday]  = AM_eight_avg(TP4.eightRECOday,TP4.eight);

[TP4.month_avgNEEday,TP4.month_avgstdNEEday] = AM_month_avg(TP4.monthNEEday,TP4.month);
[TP4.week_avgNEEday,~,TP4.week_avgstdNEEday]  = AM_week2_avg(TP4.weekNEEday,TP4.week);
[TP4.eight_avgNEEday,~,TP4.eight_stdNEEday]  = AM_eight_avg(TP4.eightNEEday,TP4.eight);

%..........................................................................
%% Seasonality
%..........................................................................
[TP4.week_avgustarday,~,TP4.week_avgstdustarday] = AM_week2_avg(TP4.weekustarday,TP4.week);
[TP4.week_avgBowen,~,TP4.week_avgstdBowen] = AM_week2_avg(TP4.weekBowen,TP4.week);
[TP4.week_avgEF,~,TP4.week_avgstdEF] = AM_week2_avg(TP4.weekEF,TP4.week);
[TP4.week_avgET,~,TP4.week_avgstdET] = AM_week2_avg(TP4.weekET,TP4.week);
[TP4.week_avgETref,~,TP4.week_avgstdETref] = AM_week2_avg(TP4.weekETref,TP4.week);
[TP4.week_avgGsPM,~,TP4.week_avgstdGsPM]       = AM_week2_avg(TP4.weekGsPM,TP4.week);
[TP4.week_avgGsPMall,~,TP4.week_avgstdGsPMall] = AM_week2_avg(TP4.weekGsPMall,TP4.week);
[TP4.week_avgETdry,~,TP4.week_avgstdETdry]       = AM_week2_avg(TP4.weekETdry,TP4.week);
[TP4.week_avgETdryday,~,TP4.week_avgstdETdryday] = AM_week2_avg(TP4.weekETdryday,TP4.week);
% [TP4.week_avgETref,~,TP4.week_avgstdETref]       = AM_week2_avg(TP4.weekETref,TP4.week);
% [TP4.week_avgETrefday,~,TP4.week_avgstdETrefday] = AM_week2_avg(TP4.weekETrefday,TP4.week);
[TP4.week_avgGsPMmmol,~,TP4.week_avgstdGsPMmmol] = AM_week2_avg(TP4.weekGsPMmmol,TP4.week);
[TP4.week_avgGsPM,~,TP4.week_avgstdGsPM] = AM_week2_avg(TP4.weekGsPM,TP4.week);
[TP4.week_avgGsPMall,~,TP4.week_avgstdGsPMall] = AM_week2_avg(TP4.weekGsPMall,TP4.week);
% [TP4.week_avgGiday,~,TP4.week_avgstdGiday] = AM_week2_avg(TP4.weekGiday,TP4.week);
[TP4.week_avgLEdry,~,TP4.week_avgstdLEdry] = AM_week2_avg(TP4.weekLEdry,TP4.week);
% [TP4.week_avgPTalphaday,~,TP4.week_avgstdPTalphaday] = AM_week2_avg(TP4.weekPTalphaday,TP4.week);
% [TP4.week_avgVPDday,~,TP4.week_avgstdVPDday] = AM_week2_avg(TP4.weekVPDday,TP4.week);
[TP4.week_avgEFday,~,TP4.week_avgstdEFday]   = AM_week2_avg(TP4.weekEFday,TP4.week);
% [TP4.week_avgEFdaydry,~,TP4.week_avgstdEFdaydry] = AM_week2_avg(TP4.weekEFdaydry,TP4.week);
[TP4.week_avgBowenday,~,TP4.week_avgstdBowenday] = AM_week2_avg(TP4.weekBowenday,TP4.week);
% [TP4.week_avgH2O,~,TP4.week_avgstdH2O]   = AM_week2_avg(TP4.weekH2O,TP4.week);

% % % .........................................................................
% % %% Eight seasonality
% % % .........................................................................
% % [TP4.eight_avgBowen,~,TP4.eight_stdBowen] = AM_eight_avg(TP4.eightBowen,TP4.eight);
% % [TP4.eight_avgEF,~,TP4.eight_stdEF]       = AM_eight_avg(TP4.eightEF,TP4.eight);
% % [TP4.eight_avgET,~,TP4.eight_stdET]       = AM_eight_avg(TP4.eightET,TP4.eight);
% % [TP4.eight_avgGs,~,TP4.eight_stdGs]       = AM_eight_avg(TP4.eightGsPMall,TP4.eight);
% % [TP4.eight_avgGsPM,~,TP4.eight_stdGsPM]   = AM_eight_avg(TP4.eightGsPM,TP4.eight);
% % [TP4.month_avgGsPMall,TP4.month_avgstdGsPMall] = AM_month_avg(TP4.monthGsPMall,TP4.month);
% % [TP4.eight_avgETdry,~,TP4.eight_stdETdry] = AM_eight_avg(TP4.eightETdry,TP4.eight);
% % [TP4.eight_avgETdryday,~,TP4.eight_stdETdryday] = AM_eight_avg(TP4.eightETdryday,TP4.eight);
% % [TP4.eight_avgETref,~,TP4.eight_stdETref]       = AM_eight_avg(TP4.eightETref,TP4.eight);
% % [TP4.eight_avgGsPMmmol,~,TP4.eight_stdGsPMmmol] = AM_eight_avg(TP4.eightGsPMmmol,TP4.eight);
% % [TP4.eight_avgGsPMallmmol,~,TP4.eight_stdGsPMallmmol] = AM_eight_avg(TP4.eightGsPMallmmol,TP4.eight);
% % [TP4.eight_avgPTalphaday,~,TP4.eight_stdPTalphaday] = AM_eight_avg(TP4.eightPTalphaday,TP4.eight);
% % [TP4.eight_avgVPDday,~,TP4.eight_stdVPDday] = AM_eight_avg(TP4.eightVPDday,TP4.eight);
% % [TP4.eight_avgLEdry,~,TP4.eight_stdLEdry]   = AM_eight_avg(TP4.eightLEdry,TP4.eight);
% % [TP4.eight_avgH,~,TP4.eight_stdH]   = AM_eight_avg(TP4.eightH,TP4.eight);
% % [TP4.eight_avgLE,~,TP4.eight_stdLE] = AM_eight_avg(TP4.eightLE,TP4.eight);
% % [TP4.eight_avgGiday,~,TP4.eight_stdGiday] = AM_eight_avg(TP4.eightGiday,TP4.eight);
% % [TP4.eight_avgEFday,~,TP4.eight_stdEFday] = AM_eight_avg(TP4.eightEFday,TP4.eight);
% % [TP4.eight_avgEFdaydry,~,TP4.eight_stdEFdaydry] = AM_eight_avg(TP4.eightEFdaydry,TP4.eight);
% % [TP4.eight_avgBowenday,~,TP4.eight_stdBowenday] = AM_eight_avg(TP4.eightBowenday,TP4.eight);
% %
% % [TP4.month_avgBowen,TP4.month_avgstdBowen] = AM_month_avg(TP4.monthBowen,TP4.month);
% % [TP4.month_avgEF,TP4.month_avgstdEF] = AM_month_avg(TP4.monthEF,TP4.month);
% % [TP4.month_avgET,TP4.month_avgstdET] = AM_month_avg(TP4.monthET,TP4.month);
% % [TP4.month_avgGs,TP4.month_avgstdGs] = AM_month_avg(TP4.monthGsPMall,TP4.month);
% % [TP4.month_avgGsPMmmol,TP4.month_avgstdGsPMmmol] = AM_month_avg(TP4.monthGsPMmmol,TP4.month);
% % [TP4.month_avgGsPMallmmol,TP4.month_avgstdGsPMallmmol] = AM_month_avg(TP4.monthGsPMallmmol,TP4.month);
% % [TP4.month_avgGsPM,TP4.month_avgstdGsPM]   = AM_month_avg(TP4.monthGsPM,TP4.month);
% % [TP4.month_avgGsPMall,TP4.month_avgstdGsPMall]   = AM_month_avg(TP4.monthGsPMall,TP4.month);
% % [TP4.month_avgETdry,TP4.month_avgstdETdry]   = AM_month_avg(TP4.monthETdry,TP4.month);
% % [TP4.month_avgETdryday,TP4.month_avgstdETdryday] = AM_month_avg(TP4.monthETdryday,TP4.month);
% % [TP4.month_avgETref,TP4.month_avgstdETref]   = AM_month_avg(TP4.monthETref,TP4.month);
% % [TP4.month_avgETday,TP4.month_avgstdETday]   = AM_month_avg(TP4.monthETday,TP4.month);
% % [TP4.month_avgGiday,TP4.month_avgstdGiday]   = AM_month_avg(TP4.monthGiday,TP4.month);
% % [TP4.month_avgLEdry,TP4.month_avgstdLEdry]   = AM_month_avg(TP4.monthLEdry,TP4.month);
% % [TP4.month_avgPTalphaday,TP4.month_avgstdPTalphaday] = AM_month_avg(TP4.monthPTalphaday,TP4.month);
% % [TP4.month_avgVPDday,TP4.month_avgstdVPDday] = AM_month_avg(TP4.monthVPDday,TP4.month);
% % [TP4.month_avgEFday,TP4.month_avgstdEFday]   = AM_month_avg(TP4.monthEFday,TP4.month);
% % [TP4.month_avgEFdaydry,TP4.month_avgstdEFdaydry] = AM_month_avg(TP4.monthEFdaydry,TP4.month);
% % [TP4.month_avgBowenday,TP4.month_avgstdBowenday] = AM_month_avg(TP4.monthBowenday,TP4.month);
% %
% % ...................................................................................................................
% %% EB error
% % ...................................................................................................................
% TP4.StorageLEday      = TP4.StorageLE;            TP4.StorageLEday(TP4.So<=tresholdSo) = NaN;
% TP4.EphotosyntesisDay = TP4.Ephotosyntesis; TP4.EphotosyntesisDay(TP4.So<=tresholdSo) = NaN;
% TP4.StorageHeatDay    = TP4.StorageHeat;       TP4.StorageHeatday(TP4.So<=tresholdSo) = NaN;
% TP4.netradday         = TP4.netrad;                      TP4.netradday(TP4.So<=tresholdSo) = NaN;
%
TP4.par_day = TP4.par;   TP4.par_day(TP4.So<tresholdSo) = NaN;
[TP4.dayPAR,~,ix]      = AM_day(TP4.par,TP4.dateloc,0);         TP4.dayPAR(ix<21) = NaN;
[TP4.dayPARday,~,ix]   = AM_day(TP4.par_day,TP4.dateloc,0);     TP4.dayPARday(ix<6) = NaN;

TP4.eightPARday = AM_eight2cycle_rs(TP4.par_day,TP4.dateloc,tresholdCycleDay,4,2);
TP4.weekPARday = AM_week2cycle_rs(TP4.par_day,TP4.dateloc,tresholdCycleDay,4,2);
% [TP4.daynetradday,~,ix]= AM_day(TP4.netradday,TP4.dateloc,0);  TP4.daynetradday(ix<6) = NaN;
% [~,~,TP4.netradday_fill] = AM_compute_regression(TP4.par_day,TP4.netradday,[.6 .6 .6],1);
% [TP4.daynetradday_fill,~,ix]    = AM_day(TP4.netradday_fill,TP4.dateloc,0);            TP4.daynetradday_fill(ix<6) = NaN;
% [TP4.dayStorageHeatDay,~,ix]    = AM_day(TP4.StorageHeatDay,TP4.dateloc,0);  TP4.dayStorageHeatDay(ix<6) = NaN;
% [TP4.dayStorageLEday,~,ix]      = AM_day(TP4.StorageLEday,TP4.dateloc,0);        TP4.dayStorageLEday(ix<6) = NaN;
% [TP4.dayEphotosyntesisDay,~,ix] = AM_day(TP4.EphotosyntesisDay,TP4.dateloc,0);	TP4.dayEphotosyntesisDay(ix<6) = NaN;
%
% TP4.dayStorageLEday_fill = AM_fill_day_cycle(TP4.dayStorageLEday,TP4.day,6,18);
% TP4.dayEphotosyntesisDay_fill = AM_fill_day_cycle(TP4.dayEphotosyntesisDay,TP4.day,6,18);
%
% TP4.dayerrorday = TP4.daynetradday_fill - TP4.dayLEday - TP4.dayHday - TP4.dayStorageHeatDay - ...
%     TP4.dayStorageLEday_fill - TP4.dayEphotosyntesisDay_fill;
%
[TP4.recurrentLE,TP4.recurrent_stdLE] = AM_hourAVG_recurrent(TP4.LE,TP4.dateloc);
[TP4.recurrentET,TP4.recurrent_stdET] = AM_hourAVG_recurrent(TP4.ET,TP4.dateloc);
[TP4.day_recurrentLEday,TP4.day_recurrent_stdLEday] = AM_dayAVG_recurrent(TP4.dayLEday,TP4.daydate);
[TP4.recurrentLEday,TP4.recurrent_stdLEday] = AM_hourAVG_recurrent(TP4.LEday,TP4.dateloc);

TP4.recurrentH = AM_hourAVG_recurrent(TP4.H,TP4.dateloc);
TP4.day_recurrentHday = AM_dayAVG_recurrent(TP4.dayHday,TP4.daydate);

TP4.recurrentnetrad = AM_hourAVG_recurrent(TP4.netrad,TP4.dateloc);
TP4.day_recurrentnetradday = AM_dayAVG_recurrent(TP4.daynetradday,TP4.daydate);
TP4.recurrenttair = AM_hourAVG_recurrent(TP4.tair,TP4.dateloc);
TP4.day_recurrenttairday = AM_dayAVG_recurrent(TP4.daytairday,TP4.daydate);

[TP4.dayY,TP4.dayM,TP4.dayD] = datevec(TP4.daydate);

figure
hold on
plot(TP4.week,TP4.weeknetradday);
plot(TP4.week,TP4.weekLEday);
plot(TP4.week,TP4.weekHday);

[TP4.recurrentGEP,TP4.recurrent_stdGEP] = AM_hourAVG_recurrent(TP4.gep,TP4.dateloc);
[TP4.day_recurrentGEP,TP4.day_recurrent_stdGEP] = AM_dayAVG_recurrent(TP4.dayGEP,TP4.daydate);
[TP4.recurrentGEP,TP4.recurrent_stdGEP] = AM_hourAVG_recurrent(TP4.gep,TP4.dateloc);
TP4.day_recurrentGEPGoley = sgolayfilt(TP4.day_recurrentGEP,polyorder,framesize);
TP4.dayGEP_zscore = (TP4.dayGEP - TP4.day_recurrentGEPGoley)./TP4.day_recurrent_stdGEP;

[TP4.day_recurrentGEPday,TP4.day_recurrent_stdGEPday] = AM_dayAVG_recurrent(TP4.dayGEPday,TP4.daydate);
[TP4.recurrentGEPday,TP4.recurrent_stdGEPday] = AM_hourAVG_recurrent(TP4.GEPday,TP4.dateloc);
TP4.day_recurrentGEPdayGoley = sgolayfilt(TP4.day_recurrentGEPday,polyorder,framesize);
TP4.dayGEPday_zscore = (TP4.dayGEPday - TP4.day_recurrentGEPdayGoley)./TP4.day_recurrent_stdGEPday;

[TP4.recurrentRECO,TP4.recurrent_stdRECO] = AM_hourAVG_recurrent(TP4.reco,TP4.dateloc);
[TP4.day_recurrentRECOday,TP4.day_recurrent_stdRECOday] = AM_dayAVG_recurrent(TP4.dayRECOday,TP4.daydate);
[TP4.recurrentRECOday,TP4.recurrent_stdRECOday] = AM_hourAVG_recurrent(TP4.RECOday,TP4.dateloc);
TP4.day_recurrentRECOdayGoley = sgolayfilt(TP4.day_recurrentRECOday,polyorder,framesize);
TP4.dayRECOday_zscore = (TP4.dayRECOday - TP4.day_recurrentRECOdayGoley)./TP4.day_recurrent_stdRECOday;

[TP4.recurrentNEE,TP4.recurrent_stdNEE] = AM_hourAVG_recurrent(TP4.nee,TP4.dateloc);
[TP4.day_recurrentNEEday,TP4.day_recurrent_stdNEEday] = AM_dayAVG_recurrent(TP4.dayNEEday,TP4.daydate);
[TP4.recurrentNEEday,TP4.recurrent_stdNEEday] = AM_hourAVG_recurrent(TP4.NEEday,TP4.dateloc);
TP4.day_recurrentNEEdayGoley = sgolayfilt(TP4.day_recurrentNEEday,polyorder,framesize);
TP4.dayNEEday_zscore = (TP4.dayNEEday - TP4.day_recurrentNEEdayGoley)./TP4.day_recurrent_stdNEEday;

%..........................................................................
%% PET
%..........................................................................
% no ground heat flux, originally (TP4.netrad - TP4.G)
TP4.PET = (0.408 .*TP4.delta .* TP4.netrad + TP4.sigma .* (900 ./ (TP4.tair + 273)) .* TP4.ws .* (TP4.e_sat - TP4.e)) ./....
    (TP4.delta + TP4.sigma .* (1 + 0.34 * TP4.ws));
TP4.PET = TP4.PET.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
TP4.PET(TP4.PET<0.2) = NaN;   TP4.PET(isinf(TP4.PET)) = NaN;

TP4.ETday = TP4.ET;               TP4.ETday(TP4.So<tresholdSo) = NaN;
TP4.PETday = TP4.PET;             TP4.PETday(TP4.So<tresholdSo) = NaN;
TP4.tairday = TP4.tair;           TP4.tairday(TP4.So<tresholdSo) = NaN;
TP4.netradday = TP4.netrad;       TP4.netradday(TP4.So<tresholdSo) = NaN;

[TP4.daytairday,~,x,~,~,TP4.daytairdaymin,TP4.daytairdaymax]   = AM_day(TP4.tairday,TP4.dateloc,0);
TP4.daytairday(x<6) = NaN;         TP4.daytairdaymin(x<6) = NaN;        TP4.daytairdaymax(x<6) = NaN;
[TP4.dayETday,~,x,~,~,TP4.dayETdaymin,TP4.dayETdaymax]   = AM_day(TP4.ETday,TP4.dateloc,0);
TP4.dayETday(x<6) = NaN;         TP4.dayETdaymin(x<6) = NaN;        TP4.dayETdaymax(x<6) = NaN;
[TP4.day_recurrentETday,TP4.day_recurrent_stdETday] = AM_dayAVG_recurrent(TP4.dayETday,TP4.daydate);
[TP4.dayPETday,~,x,~,~,TP4.dayPETdaymin,TP4.dayPETdaymax]   = AM_day(TP4.PETday,TP4.dateloc,0);
TP4.dayPETday(x<6) = NaN;         TP4.dayPETdaymin(x<6) = NaN;        TP4.dayPETdaymax(x<6) = NaN;
[TP4.day_recurrentPETday,TP4.day_recurrent_stdPETday] = AM_dayAVG_recurrent(TP4.dayPETday,TP4.daydate);

%% .........................................................................................................
figure('color','white');
plot(EVI.dateloc,scaled250m16daysEVI.value_center); hold on
scaled250m16daysEVI.value_center(scaled250m16daysEVI.value_center<0.0) = NaN;
TP4.dayEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,TP4.daydate);
TP4.dayEVI(TP4.daytairdaymin<0) = NaN;
plot(TP4.daydate,TP4.dayEVI,'.')

TP4.eightEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,TP4.eight);
TP4.weekEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,TP4.week);
[TP4.day_recurrentEVI,TP4.day_recurrent_stdEVI] = AM_dayAVG_recurrent(TP4.dayEVI,TP4.daydate);

%% .........................................................................................................
figure('color','white');
plot(ROI.daydate,ROI.gcc_mean); hold on
% ROI.gcc(ROI.gcc<0.0) = NaN;
plot(ROI.daydate,ROI.gcc_50);       plot(ROI.daydate,ROI.gcc_75);

TP4.ROIgcc = interp1(ROI.daydate,ROI.gcc_mean,TP4.daydate);
% TP4.ROIgcc((TP4.So<tresholdSo)|(TP4.ROIgcc<0.36)) = NaN;
% plot(TP4.dateloc,TP4.ROIgcc,'.')

[TP4.weekROIgcc,~,~,~,TP4.weekROIgccmin,TP4.weekROIgccmax,TP4.weekROIgccstd,TP4.weekROI] = AM_week2day_rs(TP4.ROIgcc,TP4.daydate);
[TP4.eightROIgcc,~,~,~,TP4.eightROIgccmin,TP4.eightROIgccmax,TP4.eightROIgccstd,TP4.eightROI] = AM_eightday_rs(TP4.ROIgcc,TP4.daydate);
[TP4.day_recurrentROIgcc,TP4.day_recurrent_stdROIgcc] = AM_dayAVG_recurrent(TP4.ROIgcc,TP4.daydate);

TP4.ROIrcc = interp1(ROI.daydate,ROI.rcc_mean,TP4.daydate);
[TP4.weekROIrcc,~,~,~,TP4.weekROIrccmin,TP4.weekROIrccmax,TP4.weekROIrccstd,TP4.weekROI] = AM_week2day_rs(TP4.ROIrcc,TP4.daydate);
[TP4.eightROIrcc,~,~,~,TP4.eightROIrccmin,TP4.eightROIrccmax,TP4.eightROIrccstd,TP4.eightROI] = AM_eightday_rs(TP4.ROIrcc,TP4.daydate);
[TP4.day_recurrentROIrcc,TP4.day_recurrent_stdROIrcc] = AM_dayAVG_recurrent(TP4.ROIrcc,TP4.daydate);

%%
figure('color','white');
plot(ROI.daydate,ROI.rcc_mean); hold on
plot(ROI.daydate,ROI.rcc_50);       plot(ROI.daydate,ROI.rcc_75);
TP4.ROIrcc = interp1(ROI.daydate,ROI.rcc_mean,TP4.daydate);
[TP4.weekROIrcc,~,~,~,TP4.weekROIrccmin,TP4.weekROIrccmax,TP4.weekROIrccstd,TP4.weekROI] = AM_week2day_rs(TP4.ROIrcc,TP4.daydate);
[TP4.eightROIrcc,~,~,~,TP4.eightROIrccmin,TP4.eightROIrccmax,TP4.eightROIrccstd,TP4.eightROI] = AM_eightday_rs(TP4.ROIrcc,TP4.daydate);
[TP4.day_recurrentROIrcc,TP4.day_recurrent_stdROIrcc] = AM_dayAVG_recurrent(TP4.ROIrcc,TP4.daydate);

%%
TP4.ROIGRRI = interp1(ROI.daydate,ROI.GRRI_mean,TP4.daydate);
[TP4.weekROIGRRI,~,~,~,TP4.weekROIGRRImin,TP4.weekROIGRRImax,TP4.weekROIGRRIstd,TP4.weekROI] = AM_week2day_rs(TP4.ROIGRRI,TP4.daydate);
[TP4.eightROIGRRI,~,~,~,TP4.eightROIGRRImin,TP4.eightROIGRRImax,TP4.eightROIGRRIstd,TP4.eightROI] = AM_eightday_rs(TP4.ROIGRRI,TP4.daydate);
[TP4.day_recurrentROIGRRI,TP4.day_recurrent_stdROIGRRI] = AM_dayAVG_recurrent(TP4.ROIGRRI,TP4.daydate);

TP4.ROIGRIVI = interp1(ROI.daydate,ROI.GRIVI_mean,TP4.daydate);
[TP4.weekROIGRIVI,~,~,~,TP4.weekROIGRIVImin,TP4.weekROIGRIVImax,TP4.weekROIGRIVIstd,TP4.weekROI] = AM_week2day_rs(TP4.ROIGRIVI,TP4.daydate);
[TP4.eightROIGRIVI,~,~,~,TP4.eightROIGRIVImin,TP4.eightROIGRIVImax,TP4.eightROIGRIVIstd,TP4.eightROI] = AM_eightday_rs(TP4.ROIGRIVI,TP4.daydate);
[TP4.day_recurrentROIGRIVI,TP4.day_recurrent_stdROIGRIVI] = AM_dayAVG_recurrent(TP4.ROIGRIVI,TP4.daydate);

ROI.exgreen_mean = ((2.*ROI.g_mean)-ROI.r_mean-ROI.b_mean);%./(ROI.g_mean+ROI.r_mean+ROI.b_mean);
TP4.ROIexgreen = interp1(ROI.daydate,ROI.exgreen_mean,TP4.daydate);
[TP4.weekROIexgreen,~,~,~,TP4.weekROIexgreenmin,TP4.weekROIexgreenmax,TP4.weekROIexgreenstd,TP4.weekROI] = AM_week2day_rs(TP4.ROIexgreen,TP4.daydate);
[TP4.eightROIexgreen,~,~,~,TP4.eightROIexgreenmin,TP4.eightROIexgreenmax,TP4.eightROIexgreenstd,TP4.eightROI] = AM_eightday_rs(TP4.ROIexgreen,TP4.daydate);
[TP4.day_recurrentROIexgreen,TP4.day_recurrent_stdROIexgreen] = AM_dayAVG_recurrent(TP4.ROIexgreen,TP4.daydate);

TP4.ROIcci = interp1(ROI.daydate,ROI.cci_mean,TP4.daydate);
[TP4.weekROIcci,~,~,~,TP4.weekROIccimin,TP4.weekROIccimax,TP4.weekROIccistd,TP4.weekROI] = AM_week2day_rs(TP4.ROIcci,TP4.daydate);
[TP4.eightROIcci,~,~,~,TP4.eightROIccimin,TP4.eightROIccimax,TP4.eightROIccistd,TP4.eightROI] = AM_eightday_rs(TP4.ROIcci,TP4.daydate);
[TP4.day_recurrentROIcci,TP4.day_recurrent_stdROIcci] = AM_dayAVG_recurrent(TP4.ROIcci,TP4.daydate);

%%
figure('color','white');
plot(LAIsite.daydate,LAIsite.all_mean); hold on

LAIsite.all_mean(LAIsite.all_mean<0.0) = NaN;
TP4.dayLAI = interp1(LAIsite.daydate,LAIsite.all_mean,TP4.daydate);
% TP4.LAI((TP4.So<tresholdSo)|(TP4.LAI<0.36)) = NaN;
plot(TP4.daydate,TP4.dayLAI)

[TP4.dayLAIavg,~,~,~,~,TP4.dayLAImin,TP4.dayLAI]   = AM_day(TP4.dayLAI,TP4.daydate,0);
[TP4.day_recurrentLAI,TP4.day_recurrent_stdLAI] = AM_dayAVG_recurrent(TP4.dayLAI,TP4.daydate);
plot(TP4.daydate,TP4.day_recurrentLAI,'.')

TP4.dayLAIfill = TP4.dayLAI;      TP4.dayLAIfill(isnan(TP4.dayLAI)) = TP4.day_recurrentLAI(isnan(TP4.dayLAI));
TP4.LAI = interp1(TP4.daydate,TP4.dayLAI,TP4.dateloc);
[TP4.weekLAI,~,~,~,~,TP4.week_stdLAI]  = AM_week2cycle_rs(TP4.LAI,TP4.dateloc,tresholdCycleDay,4,2);
[TP4.week_avgLAI,~,TP4.week_avgstdLAI] = AM_week2_avg(TP4.weekLAI,TP4.week);

% .............................................
%% Extreme evaporation events
% .............................................
% Remove seasonality
% Seasonal Differencing (assuming yearly seasonality, s = 365)
if flag_ExtreameET==1
    TP4.LEdryday = TP4.LEdry;             TP4.LEdryday(TP4.So<tresholdSo) = NaN;
    [TP4.dayLEdryday,~,x,~,~,TP4.dayLEdrydaymin,TP4.dayLEdrydaymax] = AM_day(TP4.LEdryday,TP4.dateloc,0);
    TP4.dayLEdryday(x<6) = NaN;           TP4.dayLEdrydaymin(x<6) = NaN;        TP4.dayLEdrydaymax(x<6) = NaN;
    [TP4.day_recurrentLEdryday,TP4.day_recurrent_stdLEdryday] = AM_dayAVG_recurrent(TP4.dayLEdryday,TP4.daydate);

    TP4.day_recurrentLEdayGoley = sgolayfilt(TP4.day_recurrentLEday,polyorder,framesize);
    TP4.day_recurrentLEdrydayGoley = sgolayfilt(TP4.day_recurrentLEdryday,polyorder,framesize);
    TP4.JDday = day(TP4.daydate,'dayofyear');
    % TP4.dayLEdryday_deseasoned = TP4.dayLEdryday - TP4.day_recurrentLEdryday(TP4.JDday);
    % TP4.dayLEday_deseasoned = (TP4.dayLEday - TP4.day_recurrentLEdayGoley(TP4.JDday));
    TP4.dayLEday_zscore = (TP4.dayLEday - TP4.day_recurrentLEdayGoley)./TP4.day_recurrent_stdLEday;
    TP4.dayLEdryday_zscore = (TP4.dayLEdryday - TP4.day_recurrentLEdrydayGoley)./TP4.day_recurrent_stdLEdryday;

    figure('color','white','Position',[50 50 1800 400]);    hold on;
    plot(TP4.daydate,TP4.dayLEday);  plot(TP4.daydate,TP4.dayLEdryday);
    legend('days without rain in the previous 12 hours','dry days'); legend box off;
    ylabel('LE_{daytime}(W m^-^2)'); box on;
    figure('color','white');         plot(TP4.daydate,TP4.dayLEday_zscore);   hold on;
    plot(TP4.daydate, TP4.dayLEdryday_zscore);

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
    TP4.dayLEdayARIMAzvalue = NaN(length(TP4.daydate),1);                     TP4.dayLEdayARIMAzvalueResidual = NaN(length(TP4.daydate),1);
    TP4.dayLEdayARIMAzvalueconstant = NaN(length(TP4.daydate),1);       TP4.dayLEdayARIMAzvalueSE = NaN(length(TP4.daydate),1);

    TP4.dayLEdrydayARIMAzscore = NaN(length(TP4.daydate),1);                TP4.dayLEdrydayARIMAzvalueResidual = NaN(length(TP4.daydate),1);
    TP4.dayLEdrydayARIMAzscoreconstant = NaN(length(TP4.daydate),1);  TP4.dayLEdrydayARIMAzvalueSE = NaN(length(TP4.daydate),1);

    jet_color = gray(366);
    Mdl = arima(1,0,0); % AR(1) model

    ind = find(TP4.dayY>1900);  % all data
    Y = TP4.dayLEday_zscore(ind);       Z = TP4.dayLEdryday_zscore(ind);
    im = 10;
    % ARIMAtimeMTX = NaN(366,im);
    figure('color','white');
    for ik = im+1:length(Y)-im
        X = Y(ik-im:ik+im);               W = Z(ik-im:ik+im);
        % Create and estimate the AR(1) model
        if (length(X(~isnan(X)))>3)&(~isnan(Y(ik)))
            EstMdl = estimate(Mdl,X); % Estimate using the first 9 days
            TP4.dayLEdayARIMAzvalue(ik) = EstMdl.AR{1};
            TP4.dayLEdayARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', X);
            TP4.dayLEdayARIMAzvalue(ik) = YF(1);
            TP4.dayLEdayARIMAzvaluelSE(ik) = YMSE(1);
            TP4.dayLEdayARIMAzvalueResidual(ik) = YF(1)-X(im);
        end
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            EstMdl = estimate(Mdl, W); % Estimate using the first 9 days
            TP4.dayLEdrydayARIMAzvalue(ik) = EstMdl.AR{1};
            TP4.dayLEdrydayARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', W);
            TP4.dayLEdrydayARIMAzvalue(ik) = YF(1);
            TP4.dayLEdrydayARIMAzvalueSE(ik) = YMSE(1);
            TP4.dayLEdrydayARIMAzvalueResidual(ik) = YF(1)-W(im);

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
    ind = find(TP4.daytairday<tresholdtair);
    TP4.dayLEdayGrowth = TP4.dayLEday;     TP4.dayLEdayGrowth(ind) = NaN;
    TP4.dayLEdayARIMAzvalueResidualGrowth = TP4.dayLEdayARIMAzvalueResidual;
    TP4.dayLEdayARIMAzvalueResidualGrowth(ind) = NaN;
    TP4.dayLEdayARIMAzvalueResidualGrowth(TP4.dayLEdayARIMAzvalueResidualGrowth<0) = NaN;
    figure('color','white');
    histogram(TP4.dayLEdayARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{growth season}')
    x = TP4.dayLEdayARIMAzvalueResidualGrowth;
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
    ind = find(TP4.daytairday<tresholdtair);
    TP4.dayLEdrydayARIMAzvalueResidualGrowth = TP4.dayLEdrydayARIMAzvalueResidual;
    TP4.dayLEdrydayARIMAzvalueResidualGrowth(ind) = NaN;
    TP4.dayLEdrydayARIMAzvalueResidualGrowth(TP4.dayLEdrydayARIMAzvalueResidualGrowth<0) = NaN;
    figure('color','white');
    histogram(TP4.dayLEdrydayARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{z-value growth season}')
    x = TP4.dayLEdrydayARIMAzvalueResidualGrowth;
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
    TP4.dayLEdayHURSTzvalue    = NaN(length(TP4.daydate),1);
    TP4.dayLEdayHURSTdryzvalue = NaN(length(TP4.daydate),1);
    jet_color = gray(366);
    ind = find(TP4.dayY>1900);  % all data
    im = 10;
    Y = TP4.dayLEday_zscore(ind);       Z = TP4.dayLEdryday_zscore(ind);
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
            TP4.dayLEdayHURSTzvalue(ik) = RS;
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
            TP4.dayLEdayHURSTdryzvalue(ik) = RS;
        end
    end
    % TP4.dayLEdayHURST(TP4.dayLEdayHURST<1) = NaN;

    % Plotting the Hurst Exponent over time (optional, but highly recommended)
    % long-term memory and fractal properties of a time series. Here's what the values mean:
    % H < 0.5: The time series is mean-reverting (it tends to revert to a long-term average).
    % H = 0.5: The time series is a random walk (no predictable patterns).
    % H > 0.5: The time series is persistent (it tends to follow trends).
    %%
    figure('color','white');
    plot(TP4.daydate, TP4.dayLEdayHURSTzvalue);  hold on
    plot(TP4.daydate, TP4.dayLEdayHURSTdryzvalue);
    xlabel('Time (Days)');
    ylabel('Hurst Exponent'); legend('ARIMA z-value','ARIMA LE_{daytime dry}')
    grid on;

    % .............................................
    %% Extreme greenup events
    % .............................................
    ind = find(TP4.daytairday<tresholdtair);
    TP4.dayROIgccGrowth = TP4.ROIgcc;     TP4.dayROIgccGrowth(ind) = NaN;

    % Remove seasonality
    [TP4.day_recurrentROIgcc,TP4.day_recurrent_stdROIgcc] = AM_dayAVG_recurrent(TP4.ROIgcc,TP4.daydate);

    polyorder = 2;     % Polynomial order (typically 2 or 3)
    framesize = 3;     % Window size (must be odd)
    TP4.day_recurrentROIgccGoley = sgolayfilt(TP4.day_recurrentROIgcc,polyorder,framesize);
    TP4.dayROIgcc_zscore = (TP4.ROIgcc - TP4.day_recurrentROIgccGoley)./TP4.day_recurrent_stdROIgcc;
    TP4.dayROIgcc_zscore(isinf(TP4.dayROIgcc_zscore)) = NaN;
    figure('color','white');                            plot(TP4.daydate,TP4.ROIgcc);   hold on;
    plot(TP4.daydate, TP4.dayROIgcc_zscore);

    % Fit an AR(1) model using arima function
    TP4.dayROIgccARIMAzscore = NaN(length(TP4.daydate),1);          TP4.dayROIgccARIMAzvalueResidual = NaN(length(TP4.daydate),1);
    TP4.dayROIgccARIMAzscoreconstant = NaN(length(TP4.daydate),1);  TP4.dayROIgccARIMAzvalueSE = NaN(length(TP4.daydate),1);
    jet_color = gray(366);
    Mdl = arima(1,0,0); % AR(1) model

    ind = find(TP4.dayY>1900);  % all data
    Z = TP4.dayROIgcc_zscore(ind);
    im = 10;
    figure('color','white');
    for ik = im+1:length(Y)-im
        W = Z(ik-im:ik+im);
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            EstMdl = estimate(Mdl, W); % Estimate using the first 9 days
            TP4.dayROIgccARIMAzvalue(ik) = EstMdl.AR{1};
            TP4.dayROIgccARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', W);
            TP4.dayROIgccARIMAzvalue(ik) = YF(1);
            TP4.dayROIgccARIMAzvalueSE(ik) = YMSE(1);
            TP4.dayROIgccARIMAzvalueResidual(ik) = YF(1)-W(im);
        end
    end
    % Extreame value theory
    ind = find(TP4.daytairday<tresholdtair);
    TP4.dayROIgccARIMAzvalueResidualGrowth = TP4.dayROIgccARIMAzvalueResidual;
    TP4.dayROIgccARIMAzvalueResidualGrowth(ind) = NaN;
    figure('color','white');
    histogram(TP4.dayROIgccARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{z-value growth season}')
    x = TP4.dayROIgccARIMAzvalueResidualGrowth;
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
    TP4.dayROIgccHURSTzvalue = NaN(length(TP4.daydate),1);
    jet_color = gray(366);
    ind = find(TP4.dayY>1900);  % all data
    im = 10;
    Z = TP4.dayROIgcc_zscore(ind);

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
            TP4.dayROIgccHURSTzvalue(ik) = RS;
        end
    end

    figure('color','white');
    plot(TP4.daydate, TP4.dayROIgccHURSTzvalue);  hold on
    xlabel('Time (Days)');
    ylabel('Hurst Exponent'); legend('ARIMA','ARIMA z-value')
    grid on;

end

%% .........................................................................
ind = find(TP4.daytairday<tresholdtair);
TP4.dayGEPdayGrowth = TP4.dayGEPday;           TP4.dayGEPdayGrowth(ind) = NaN;
TP4.dayRECOdayGrowth = TP4.dayRECOday;      TP4.dayRECOdayGrowth(ind) = NaN;
TP4.dayNEEdayGrowth = TP4.dayNEEday;            TP4.dayNEEdayGrowth(ind) = NaN;

TP4.dayGEPgrowth = TP4.dayGEP;           TP4.dayGEPgrowth(ind) = NaN;
TP4.dayRECOgrowth = TP4.dayRECO;      TP4.dayRECOgrowth(ind) = NaN;
TP4.dayNEEgrowth = TP4.dayNEE;            TP4.dayNEEgrowth(ind) = NaN;

polyorder = 2;      % Polynomial order (typically 2 or 3)
framesize = 9;     % Window size (must be odd)
TP4.dayGEPdayGoley = sgolayfilt(TP4.dayGEPday,polyorder,framesize);
TP4.dayGEPdayGrowthGoley = sgolayfilt(TP4.dayGEPdayGrowth,polyorder,framesize);

[TP4.monthY,TP4.monthM,TP4.monthD]= datevec(TP4.month);
% year_tick = unique(TP4.monthY);  year_tick = [year_tick;(year_tick(end)+1)];
% all_year_tick = (datetime(year_tick(1:4:end),1,1))';
[TP4.weekY,TP4.weekM,TP4.weekD]= datevec(TP4.week);
[TP4.eightY,TP4.eightM,TP4.eightD]= datevec(TP4.eight);

save('TP4.mat','TP4');
save('matlabTP4.mat');
