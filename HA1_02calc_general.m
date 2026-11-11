% Calculate seasonal values for ENSO event or other analysis
% Natalia Restrepo-Coupe
% h2o mixing ratio improperly calculated
% u* improperly calculated
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;

flag_ExtreameET = 10;

ix = datetime(0,0,(1:16:365)');     ind = find(ix>=datetime(0,7,1));     week_start_hydro = ind(1);
tresholdSo = 10;                    tresholdCycleDay = 6;                tresholdCycle = 22;
eight_avg  = (1:8:365)';            week_avg = (1:16:365)';

tresholdtair =5;
gC_m2_d1=60.*60.*24.*12.*(10.^-6);

polyorder = 2;      % Polynomial order (typically 2 or 3)
framesize = 3;     % Window size (must be odd)

% Calculate dayily values and use variable number of hours as treshold
ix = Ha1.So;                 ix(Ha1.So<tresholdSo) = NaN;
[~,~,countSo] = AM_day(ix,Ha1.dateloc,0);

% %..........................................................................
% %% Fill meteorology
% %..........................................................................
% opts.VariableNames = ["TIMESTAMP_START", "TIMESTAMP_END", "TA_F_MDS", "TA_F_MDS_QC", "TA_ERA", "TA_F", "TA_F_QC", "SW_IN_POT", "SW_IN_F_MDS", "SW_IN_F_MDS_QC", "SW_IN_ERA", "SW_IN_F", "SW_IN_F_QC", "LW_IN_F_MDS", "LW_IN_F_MDS_QC", "LW_IN_ERA", "LW_IN_F", "LW_IN_F_QC", "LW_IN_JSB", "LW_IN_JSB_QC", "LW_IN_JSB_ERA", "LW_IN_JSB_F", "LW_IN_JSB_F_QC", "VPD_F_MDS", "VPD_F_MDS_QC", "VPD_ERA", "VPD_F", "VPD_F_QC", "PA", "PA_ERA", "PA_F", "PA_F_QC", "P", "P_ERA", "P_F", "P_F_QC", "WS", "WS_ERA", "WS_F", "WS_F_QC", "WD", "USTAR", "RH", "NETRAD", "PPFD_IN", "PPFD_DIF", "CO2_F_MDS", "CO2_F_MDS_QC", "TS_F_MDS_1", "TS_F_MDS_2", "TS_F_MDS_3", "TS_F_MDS_4", "TS_F_MDS_1_QC", "TS_F_MDS_2_QC", "TS_F_MDS_3_QC", "TS_F_MDS_4_QC", "G_F_MDS", "G_F_MDS_QC", "LE_F_MDS", "LE_F_MDS_QC", "LE_CORR", "LE_CORR_25", "LE_CORR_75", "LE_RANDUNC", "LE_RANDUNC_METHOD", "LE_RANDUNC_N", "LE_CORR_JOINTUNC", "H_F_MDS", "H_F_MDS_QC", "H_CORR", "H_CORR_25", "H_CORR_75", "H_RANDUNC", "H_RANDUNC_METHOD", "H_RANDUNC_N", "H_CORR_JOINTUNC", "EBC_CF_N", "EBC_CF_METHOD", "NIGHT", "NEE_CUT_REF", "NEE_VUT_REF", "NEE_CUT_REF_QC", "NEE_VUT_REF_QC", "NEE_CUT_REF_RANDUNC", "NEE_VUT_REF_RANDUNC", "NEE_CUT_REF_RANDUNC_METHOD", "NEE_VUT_REF_RANDUNC_METHOD", "NEE_CUT_REF_RANDUNC_N", "NEE_VUT_REF_RANDUNC_N", "NEE_CUT_REF_JOINTUNC", "NEE_VUT_REF_JOINTUNC", "NEE_CUT_USTAR50", "NEE_VUT_USTAR50", "NEE_CUT_USTAR50_QC", "NEE_VUT_USTAR50_QC", "NEE_CUT_USTAR50_RANDUNC", "NEE_VUT_USTAR50_RANDUNC", "NEE_CUT_USTAR50_RANDUNC_METHOD", "NEE_VUT_USTAR50_RANDUNC_METHOD", "NEE_CUT_USTAR50_RANDUNC_N", "NEE_VUT_USTAR50_RANDUNC_N", "NEE_CUT_USTAR50_JOINTUNC", "NEE_VUT_USTAR50_JOINTUNC", "NEE_CUT_MEAN", "NEE_VUT_MEAN", "NEE_CUT_MEAN_QC", "NEE_VUT_MEAN_QC", "NEE_CUT_SE", "NEE_VUT_SE", "NEE_CUT_05", "NEE_CUT_16", "NEE_CUT_25", "NEE_CUT_50", "NEE_CUT_75", "NEE_CUT_84", "NEE_CUT_95", "NEE_VUT_05", "NEE_VUT_16", "NEE_VUT_25", "NEE_VUT_50", "NEE_VUT_75", "NEE_VUT_84", "NEE_VUT_95", "NEE_CUT_05_QC", "NEE_CUT_16_QC", "NEE_CUT_25_QC", "NEE_CUT_50_QC", "NEE_CUT_75_QC", "NEE_CUT_84_QC", "NEE_CUT_95_QC", "NEE_VUT_05_QC", "NEE_VUT_16_QC", "NEE_VUT_25_QC", "NEE_VUT_50_QC", "NEE_VUT_75_QC", "NEE_VUT_84_QC", "NEE_VUT_95_QC", "RECO_NT_VUT_REF", "RECO_NT_VUT_USTAR50", "RECO_NT_VUT_MEAN", "RECO_NT_VUT_SE", "RECO_NT_VUT_05", "RECO_NT_VUT_16", "RECO_NT_VUT_25", "RECO_NT_VUT_50", "RECO_NT_VUT_75", "RECO_NT_VUT_84", "RECO_NT_VUT_95", "RECO_NT_CUT_REF", "RECO_NT_CUT_USTAR50", "RECO_NT_CUT_MEAN", "RECO_NT_CUT_SE", "RECO_NT_CUT_05", "RECO_NT_CUT_16", "RECO_NT_CUT_25", "RECO_NT_CUT_50", "RECO_NT_CUT_75", "RECO_NT_CUT_84", "RECO_NT_CUT_95", "GPP_NT_VUT_REF", "GPP_NT_VUT_USTAR50", "GPP_NT_VUT_MEAN", "GPP_NT_VUT_SE", "GPP_NT_VUT_05", "GPP_NT_VUT_16", "GPP_NT_VUT_25", "GPP_NT_VUT_50", "GPP_NT_VUT_75", "GPP_NT_VUT_84", "GPP_NT_VUT_95", "GPP_NT_CUT_REF", "GPP_NT_CUT_USTAR50", "GPP_NT_CUT_MEAN", "GPP_NT_CUT_SE", "GPP_NT_CUT_05", "GPP_NT_CUT_16", "GPP_NT_CUT_25", "GPP_NT_CUT_50", "GPP_NT_CUT_75", "GPP_NT_CUT_84", "GPP_NT_CUT_95", "RECO_DT_VUT_REF", "RECO_DT_VUT_USTAR50", "RECO_DT_VUT_MEAN", "RECO_DT_VUT_SE", "RECO_DT_VUT_05", "RECO_DT_VUT_16", "RECO_DT_VUT_25", "RECO_DT_VUT_50", "RECO_DT_VUT_75", "RECO_DT_VUT_84", "RECO_DT_VUT_95", "RECO_DT_CUT_REF", "RECO_DT_CUT_USTAR50", "RECO_DT_CUT_MEAN", "RECO_DT_CUT_SE", "RECO_DT_CUT_05", "RECO_DT_CUT_16", "RECO_DT_CUT_25", "RECO_DT_CUT_50", "RECO_DT_CUT_75", "RECO_DT_CUT_84", "RECO_DT_CUT_95", "GPP_DT_VUT_REF", "GPP_DT_VUT_USTAR50", "GPP_DT_VUT_MEAN", "GPP_DT_VUT_SE", "GPP_DT_VUT_05", "GPP_DT_VUT_16", "GPP_DT_VUT_25", "GPP_DT_VUT_50", "GPP_DT_VUT_75", "GPP_DT_VUT_84", "GPP_DT_VUT_95", "GPP_DT_CUT_REF", "GPP_DT_CUT_USTAR50", "GPP_DT_CUT_MEAN", "GPP_DT_CUT_SE", "GPP_DT_CUT_05", "GPP_DT_CUT_16", "GPP_DT_CUT_25", "GPP_DT_CUT_50", "GPP_DT_CUT_75", "GPP_DT_CUT_84", "GPP_DT_CUT_95", "RECO_SR", "RECO_SR_N"];
% Ha1.ws_fill = AM_rm_outlier(Ha1.ws,4);
% Ha1.ws_fill = AM_fill_month_cycle(Ha1.ws_fill,Ha1.dateloc,6,18);
% Ha1.tc_fill   = AM_fill_day_cycle(Ha1.tasp,Ha1.dateloc,6,18);

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
Ha1.e_sat   = 0.1.*(A0+Ha1.tair.*(A1+Ha1.tair.*(A2+Ha1.tair.*(A3+Ha1.tair.*(A4+Ha1.tair.*(A5+Ha1.tair*A6))))));
Ha1.delta   = 4098*Ha1.e_sat./((237.3+Ha1.tair).^2);                % slope of vapor pressure curve, kPa/C
% Ha1.h2o_gm3 =  (0.01802.*Ha1.pambKpa)./((R.*Ha1.tc_fill+T_0C_K).*((1./Ha1.h2ommolm)+(0.01802/18)));

Ha1.rho_a = (Ha1.pambKpa./(0.28705*(Ha1.tair+273.15))).*(1-(0.378*Ha1.e_sat.*Ha1.RH./Ha1.pambKpa));
% Ha1.rho_a = AM_fill_day_cycle(Ha1.rho_a,Ha1.dateloc,6,18);

% %'Calculate water vapor pressure using IRGASON measurements
% Ha1.e     =  (Ha1.h2omix.*(Ha1.pambKpa./100)./(Ha1.h2omix+622)).*10^2; % vapor pressure (mb) then x10^6
% Ha1.e     =  AM_rm_outlier(Ha1.e,3);
% Ha1.RH    =  Ha1.e./Ha1.e_sat;
% ix        =  Ha1.e_sat.*(1-Ha1.RH./100);                                    % vapour pressure deficit;
% Ha1.VPD   =  Ha1.e_sat.*(1-Ha1.RHec./100);
% Ha1.VPD((Ha1.VPD<0)|(isnan(Ha1.VPD))) = ix((Ha1.VPD<0)|(isnan(Ha1.VPD)));
% Ha1.VPD(Ha1.VPD<0) = 0;
% Ha1.VPD = AM_fill_month_cycle(Ha1.VPD,Ha1.dateloc,6,18);
% Ha1.VPD((Ha1.VPD<0)|(isinf(Ha1.VPD))) = 0;
%
% Ha1.rho_d =  (Ha1.pambKpa-Ha1.e)./((Ha1.tc_fill+T_0C_K).*Rd);          % 'g/m^3
% %Ha1.rho_a =  (Ha1.rho_d + Ha1.h2o_gm3)./1000;       %Natalia          % 'kg/m^3
%
% % % %..........................................................................
% Ha1.e_sat_fill = AM_fill_day_cycle(Ha1.e_sat,Ha1.dateloc,6,18);
% Ha1.rho_a = AM_fill_day_cycle(Ha1.rho_a,Ha1.dateloc,6,18);
% Ha1.e_fill     = AM_fill_day_cycle(Ha1.e,Ha1.dateloc,6,18);
%
% % .........................................................................
Ha1.lambda = (2.50*10^6)-((2.386*10^3).*(Ha1.tair));                % 2.45 [MJ kg-1]     % Latent heat of vaporization, 2.45 [MJ kg-1],
Ha1.lambda = Ha1.lambda./10^6;
% % Ha1.delta    =  (4098.*Ha1.e_sat_fill)./(power((Ha1.tc_fill+237.3),2)); %[kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% % http://agsys.cra-cin.it/tools/evapotranspiration/help/Slope_of_saturation_vapour_pressure_curve.html
% % Ha1.delta   =  0.04145.*exp(0.06088.*Ha1.tc_fill);              % 0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% Ha1.delta   = 4098*Ha1.e_sat_fill./((237.3+Ha1.tc_fill).^2);      % slope of vapor pressure curve, kPa/C
Ha1.sigma  = ((Cp.*Ha1.pambKpa)./(0.622.*Ha1.lambda));              % sigma psychrometric constant 0.054 [kPa C-1]
% %Ha1.sigma   = smoothdata(Ha1.sigma,"movmean",5);
% %where epsilon ratio molecular weight of water vapour/dry air  =  0.622
% Ha1.epsilon =  Ha1.delta./Ha1.sigma;                              % Unitless ~0.6219
% % Rho_air: mean air density at constant pressure (Bruutsaet,p38)(kPa kg J-1)
% % % if ((nanmax(Ha1.rho_air)>2)|(nanmin(Ha1.rho_air)<0.5));   '\rho air inacurate calculation please check';    end;
% % % c = 1.01;                                                     % virtual absolute air temperature Tv = (c.*(Ha1.tc_fill+273.15)
% % % Ha1.rho_air = Ha1.pambpa./((c.*(Ha1.tc_fill+273.15)).*R);     % multiply by 10 so we can get the 1.2value??? http://www.fao.org/docrep/x0490e/x0490e06.htm [kg m-3]
% % % Qa  =  0.62197.*Ha1.e./((Ha1.pambpa./100)-(0.378030.*Ha1.e)); % specific humidity (kg/kg)
% % %..........................................................................
% % % 2002-2005
% % %..........................................................................
% % [Ha1.h_So]     = AM_solar_rad(Ha1.h_JD,Ha1.h_HR+1,lat,lon);
% % Ha1.h_delta    =  0.04145.*exp(0.06088.*Ha1.h_tc_fill);                       %0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% % Ha1.h_lambda(isnan(Ha1.h_lambda)) = 2.45;
% % Ha1.h_sigma    =  ((Cp.*Ha1.h_pambKpa)./(0.622.*Ha1.h_lambda));                    %[kPa C-1]
% % Ha1.h_sigma    =  smoothdata(Ha1.h_sigma,"movmean",5);
%
% %..........................................................................
% %% ET ref
% %..........................................................................
% Ha1.LEref = AM_fill((Ha1.LE+Ha1.H).*(Ha1.delta./(Ha1.delta+(Ha1.sigma))));
% % Ha1.LEref = AM_fill((Ha1.netrad).*(Ha1.delta./(Ha1.delta+(Ha1.sigma))));
% Ha1.LEref((Ha1.So < 500)|(Ha1.rain_fill>0)) = NaN;
% Ha1.ETref = AM_fill_plus(Ha1.LEref./Ha1.lambda);
% Ha1.ETref = Ha1.ETref.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
%
% %..........................................................................
% Ha1.eightETref = AM_eight2cycle_rs(Ha1.ETref,Ha1.dateloc,tresholdCycleDay,4,2);    Ha1.eightETref = AM_fill(Ha1.eightETref);
% [Ha1.weekETref,~,~,~,~,Ha1.week_stdETref]  = AM_week2cycle_rs(Ha1.ETref,Ha1.dateloc,tresholdCycleDay,4,2);     Ha1.weekETref  = AM_fill(Ha1.weekETref);
% Ha1.monthETref = AM_month2cycle(Ha1.ETref,Ha1.dateloc,tresholdCycleDay,4,2);       Ha1.monthETref = AM_fill(Ha1.monthETref);
% Ha1.monthETref = AM_month2cycle(Ha1.ETref,Ha1.dateloc,tresholdCycleDay,4,2);                      Ha1.monthETref  = AM_fill(Ha1.monthETref);
% Ha1.monthETref = Ha1.monthETref.*eomday(Ha1.monthY,Ha1.monthM);
%
% Ha1.ETrefday = Ha1.ETref;      Ha1.ETrefday(Ha1.So<=tresholdSo) = NaN;
% [Ha1.weekETrefday,~,~,~,~,Ha1.week_stdETrefday]  = AM_week2cycle_rs(Ha1.ETrefday,Ha1.dateloc,tresholdCycleDay,4,2);     Ha1.weekETrefday  = AM_fill(Ha1.weekETrefday);
% [Ha1.monthETrefday,~,~,~,~,Ha1.month_stdETrefday]= AM_month2cycle(Ha1.ETrefday,Ha1.dateloc,tresholdCycleDay,4,2);     Ha1.monthETrefday  = AM_fill(Ha1.monthETrefday);
%
% Ha1.LErefday = Ha1.LEref;      Ha1.LErefday(Ha1.So<=tresholdSo) = NaN;
% [Ha1.weekLErefday,~,~,~,~,Ha1.week_stdLErefday]  = AM_week2cycle_rs(Ha1.LErefday,Ha1.dateloc,tresholdCycleDay,4,2);     Ha1.weekLErefday  = AM_fill(Ha1.weekLErefday);
%
% %..........................................................................
% %% Rain
% %..........................................................................
% [~,~,Ha1.eightRain] = AM_eightday_rs(Ha1.rain,Ha1.dateloc);                         Ha1.eightRain = AM_fill(Ha1.eightRain);
% [~,~,Ha1.weekRain,~,~,Ha1.week_stdRain]  = AM_week2day_rs(Ha1.rain,Ha1.dateloc);    Ha1.weekRain  = AM_fill(Ha1.weekRain);
% [~,Ha1.monthRain] = AM_month(Ha1.rain,Ha1.dateloc);                                 Ha1.monthRain = AM_fill(Ha1.monthRain);
[Ha1.cycle_month_LE,Ha1.cycle_month_countLE,~,Ha1.cycle_month_stdLE] = ...
    AM_day_cycle_year(Ha1.LE,Ha1.dateloc);
[Ha1.cycle_month_netrad,Ha1.cycle_month_countnetrad,~,Ha1.cycle_month_stdnetrad] = ...
    AM_day_cycle_year(Ha1.netrad,Ha1.dateloc);
[Ha1.cycle_month_H,Ha1.cycle_month_countH,~,Ha1.cycle_month_stdH] = ...
    AM_day_cycle_year(Ha1.H,Ha1.dateloc);

% [Ha1.week_avgRain,~,Ha1.week_avgstdRain] = AM_week2_avg(Ha1.weekRain,Ha1.week);
%
% % % [Ha1.eightCWD] = AM_eightday_rs(Ha1.dayTRMM1hCWD,Ha1.day);                            Ha1.eightCWD = AM_fill(Ha1.eightCWD);
% % % [Ha1.weekCWD,~,~,~,~,Ha1.week_stdCWD]  = AM_week2day_rs(Ha1.dayTRMM1hCWD,Ha1.day);    Ha1.weekCWD  = AM_fill(Ha1.weekCWD);
% % % [Ha1.week_avgCWD,~,Ha1.week_avgstdCWD] = AM_week2_avg(Ha1.weekCWD,Ha1.week);
%
% [Ha1.eightCWD] = AM_eightday_rs(Ha1.dayTRMM1hCWD,Ha1.day);                            Ha1.eightCWD = AM_fill(Ha1.eightCWD);
% [Ha1.weekCWD,~,~,~,~,Ha1.week_stdCWD]  = AM_week2day_rs(Ha1.dayTRMM1hCWD,Ha1.day);    Ha1.weekCWD  = AM_fill(Ha1.weekCWD);
% [Ha1.week_avgCWD,~,Ha1.week_avgstdCWD] = AM_week2_avg(Ha1.weekCWD,Ha1.week);
%
% %% ........................................................................
% if flag_Rick == 1
%     ind = find((Ha1.dateloc>datetime(2004,12,10))&(Ha1.dateloc<datetime(2004,12,20)));
%     ind = find((Ha1.dateloc>datetime(2004,8,24))&(Ha1.dateloc<datetime(2004,9,7)));
%     figure('color','white');
%     y1 = -.2;     y2 = 1;       y3 = y1:((y2-y1)/4):y2;
%     x1 = 0;       x2 = 2;       x3 = x1:((x2-x1)/4):x2;
%     subplot(2,2,1:2);           hold on;
%     hl1 = bar(Ha1.dateloc(ind),Ha1.rain(ind)./10,1,'FaceColor',[ 0.9 0.9 0.9],'EdgeColor',[ 0.8 0.8 0.8]);
%     hl3 = plot(Ha1.dateloc(ind),Ha1.ET(ind)./24,'Color',[0. 0. .9],'LineWidth',1);
%     hl4 = plot(Ha1.dateloc(ind),Ha1.ETref(ind)./24,'Color',[0. 0.9 .5],'LineWidth',1);
%     legend ([hl3,hl4],'ET','ET_{ref}','EdgeColor','white')%,'position','southoutside');
%     set(gca,'XTick',Ha1.day(1:1:end),'XTickLabel',[ '' '' ''],'YTick',y3,'YColor',[0. 0. .9]); hold on;
%     xlim([Ha1.dateloc(ind(1)) Ha1.dateloc(ind(end))]);            ylim([y1 y2]);
%     ylabel ({'ET (mm)'},'FontSize',12,'Color',[0. 0. .9]);
%     ax1 = gca;          ax1_pos = ax1.Position;
%     ax2 = axes('Position',ax1_pos,'YAxisLocation','right','Color','none'); hold on;
%     %     hl7 = plot(Ha1.dateloc(ind),Ha1.tasp(ind),'Parent',ax2,'Color',[0.4 0.4 0.4],'LineWidth',1);    hold on;
%     hl7 = plot(Ha1.dateloc(ind),Ha1.ustar(ind),'Parent',ax2,'Color',[0.4 0.4 0.4],'LineWidth',1);    hold on;
%     set(ax2,'XColor','k','YColor',[ 0.0 0.0 0.0]);
%     %     ylabel ({'netrad (W m^-^2)'},'FontSize',12,'Color',[0.2 0.2 .2]);
%     %     ylabel ({'T_{air} (\circC)'},'FontSize',12,'Color',[0.4 0.4 .4]);
%     ylabel ({'u_* (m s^-^1)'},'FontSize',12,'Color',[0.4 0.4 .4]);
%     set(ax2,'XTick',Ha1.dateloc(ind(1):48:ind(end)),'XTickLabel',datestr(Ha1.dateloc(ind(1):48:ind(end)),'yyyy/mm/dd'),'YTick',x3,'YColor',[0.4 0.4 .4]);
%     xlim([Ha1.dateloc(ind(1)) Ha1.dateloc(ind(end))]);            ylim([x1 x2]);
%     box on; grid on;	text(Ha1.dateloc(ind(20)),x3(5),site_name,'FontSize',8)
%
%     ind = find(Ha1.So>100);
%     subplot(2,2,3);     hold on;
%     AM_bin(Ha1.netrad(ind),Ha1.LE(ind),15,1,1,[0 0 0.8]);
%     xlabel({'Rn (W m^-^2)'},'FontSize',10);ylabel ({'LE (W m^-^2)'},'FontSize',10);
%     [p,r2,~,~,sm,sb] = AM_compute_regression(Ha1.netrad(ind),Ha1.LE(ind),[0.4,0.4,0.4],0);
%     y_model=polyval(p,Ha1.netrad(ind));   hold on;
%     plot(Ha1.netrad(ind),y_model,'-','color',[0.4,0.4,0.4]);
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

Ha1.A = (Ha1.LE+Ha1.H);
% weekA = AM_week2cycle_rs(Ha1.A,Ha1.dateloc,20);  weekH = AM_week2cycle_rs(Ha1.H,Ha1.dateloc,20);  weekLE = AM_week2cycle_rs(Ha1.LE,Ha1.dateloc,3);
%%
%         ACHTUNG!!!!!!!!!!!!!
% ik Yebra it apears as Ha1.ga but looks like Ha1.ra!!!!!!!!!!!
% Ha1.ra =
% (log((height-d)./zo)).*(log((height-d)./zoh))./(k^2.*Ha1.ws_fill);
% Natalia's original I use both zo and zoh
Ra        = (log((z-d)./zo)).*(log((z-d)./zoh))./(k.^2.*Ha1.ws);
Ra(Ha1.So<tresholdSo) = NaN;        Ra = AM_rm_outlier(Ra,5);
Ha1.Ga        = 1./Ra;              Ha1.Ga = AM_rm_outlier(Ha1.Ga,5);
Ra_ustar  = Ha1.ws./(Ha1.ustar.^2);
Ra_ustar(Ha1.So<tresholdSo) = NaN;	Ra_ustar = AM_rm_outlier(Ra_ustar,5);
Ga_ustar  = 1./Ra_ustar;            Ga_ustar = AM_rm_outlier(Ga_ustar,5);

%..........................................................................
%% PET from PM equation
%..........................................................................
% rho_a 1.2 kg m-3  Cp = 1.013 10-3 [MJ kg-1 C-1] > [J kg-1 k-1]   >>> delta [kPa m-2]
% lambda 2.45 [MJ kg-1]
% Ha1.LErefPM = ((AM_fill((Ha1.LE+Ha1.H).*Ha1.delta)+(Ha1.rho_a.*Cp.*10^6.*Ha1.VPD.*Ha1.Ga)))./(Ha1.delta+Ha1.sigma);
Ha1.LErefPM = ((AM_fill((Ha1.netrad).*Ha1.delta)+(Ha1.rho_a.*Cp.*10^6.*Ha1.VPD.*Ha1.Ga)))./(Ha1.delta+Ha1.sigma);
Ha1.ETrefPM = Ha1.LErefPM./Ha1.lambda;
Ha1.ETrefPM = Ha1.ETrefPM.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
Ha1.ETrefdayPM = Ha1.ETrefPM;      Ha1.ETrefdayPM(Ha1.So<=tresholdSo) = NaN;

% lambda    =  2.45;                                                                 % [MJ kg-1] FAO latent heat of vaporization of water
Ha1.lambda = ((2.50*10^6)-((2.386*10^3).*(Ha1.tair)))./10^6; % 2.45 [MJ kg-1]     % Latent heat of vaporization, 2.45 [MJ kg-1],

Ha1.ET = Ha1.LE./Ha1.lambda;
Ha1.ET = Ha1.ET.*60.*60.*24/1000000;      % from s-1 to d-1 and from kg-1 to g-1 (mm)

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
Ha1.e      = Ha1.RH.*Ha1.e_sat./100;

% Ha1.delta =  (4098.*Ha1.e_sat_fill)./(power((Ha1.tc_fill+237.3),2));  %[kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% http://agsys.cra-cin.it/tools/evapotranspiration/help/Slope_of_saturation_vapour_pressure_curve.html
% Ha1.delta =  0.04145.*exp(0.06088.*Ha1.tc_fill);     % 0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
Ha1.delta = 4098*Ha1.e_sat./((237.3+Ha1.tair).^2);     % slope of vapor pressure curve, kPa/C

Ha1.sigma = ((Cp.*Ha1.pambKpa)./(0.622.*Ha1.lambda));  % sigma psychrometric constant 0.054 [kPa C-1]
%Ha1.sigma   = smoothdata(Ha1.sigma,"movmean",5);
%where epsilon ratio molecular weight of water vapour/dry air  =  0.622
Ha1.epsilon =  Ha1.delta./Ha1.sigma;                   % Unitless ~0.6219

Ha1.ET = Ha1.LE./Ha1.lambda;
Ha1.ET = Ha1.ET.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)

% %..........................................................................
% %% ET dry conditions
% %..........................................................................
% ik = find(Ha1.rain_fill>0);
% ij = zeros(length(Ha1.rain_fill),1);
% ij(ik) = 1;                         indDry24 = ij;           im = 1;
% while im < length(ij)-25
%     if ij(im) == 1
%         for in = 1:24
%             indDry24(im+in) = 1;
%         end
%     end
%     im = im + 1;
% end
% Ha1.LEdry24 = Ha1.LE;             Ha1.ETdry24 = Ha1.ET;
% Ha1.LEdry24(indDry24==1) = NaN;     Ha1.ETdry24(indDry24==1) = NaN;
% Ha1.ETdryday24 = Ha1.ETdry24;     Ha1.ETdryday24(Ha1.So<tresholdSo) = NaN;
%
% Ha1.ETrefdry24 = Ha1.ETref;           Ha1.ETrefdry24(indDry24==1) = NaN;
% Ha1.ETrefdryday24 = Ha1.ETrefdry24;   Ha1.ETrefdryday24(Ha1.So<tresholdSo) = NaN;
%
% Ha1.LEwet24 = Ha1.LE;               Ha1.ETwet24 = Ha1.ET;
% Ha1.LEwet24(indDry24==0) = NaN;     Ha1.ETwet24(indDry24==0) = NaN;
% Ha1.ETwetday24 = Ha1.ETwet24;       Ha1.ETwetday24(Ha1.So<tresholdSo) = NaN;
%
% Ha1.ETrefwet24 = Ha1.ETref;         Ha1.ETrefwet24(indDry24==0) = NaN;
% Ha1.ETrefwetday24 = Ha1.ETrefwet24; Ha1.ETrefwetday24(Ha1.So<tresholdSo) = NaN;
%
%..........................................................................
%% ET dry conditions
%..........................................................................
% Remove 12h after precipitation
ik = find(Ha1.rain>0);
ij = zeros(length(Ha1.rain),1);
ij(ik) = 1;                         indDry = ij;           im = 1;
while im < length(ij)-13
    if ij(im) == 1
        for in = 1:12
            indDry(im+in) = 1;
        end
    end
    im = im + 1;
end
Ha1.LEdry = Ha1.LE;             Ha1.ETdry = Ha1.ET;
Ha1.LEdry(indDry==1) = NaN;     Ha1.ETdry(indDry==1) = NaN;
Ha1.ETdryday = Ha1.ETdry;       Ha1.ETdryday(Ha1.So<tresholdSo) = NaN;

% Ha1.ETrefdry = Ha1.ETref;       Ha1.ETrefdry(indDry==1) = NaN;
% Ha1.ETrefdryday = Ha1.ETrefdry; Ha1.ETrefdryday(Ha1.So<tresholdSo) = NaN;

Ha1.LEwet = Ha1.LE;             Ha1.ETwet = Ha1.ET;
Ha1.LEwet(indDry==0) = NaN;     Ha1.ETwet(indDry==0) = NaN;
Ha1.ETwetday = Ha1.ETwet;       Ha1.ETwetday(Ha1.So<tresholdSo) = NaN;

% Ha1.ETrefwet = Ha1.ETref;         Ha1.ETrefwet(indDry==0) = NaN;
% Ha1.ETrefwetday = Ha1.ETrefwet;   Ha1.ETrefwetday(Ha1.So<tresholdSo) = NaN;

ix = Ha1.HR.*indDry; ix(indDry==0) = NaN;
figure ('color','white');       histogram(ix,24);
ylabel('Frequency time rainfall');
xlabel('Local time rainfall Ha1');

%..................................................................
%%         As in Yebra
%..................................................................
A   = Ha1.LE+Ha1.H;
% A   = Ha1.netrad;       ix = Ha1.LE+Ha1.H;              A(isnan(A)) = ix(isnan(A));
one = Ha1.epsilon.*A;   two = (Ha1.epsilon+1).*Ha1.LE;	three = Ha1.rho_a.*10^6.*Cp.*(Ha1.e_sat-Ha1.e).*Ha1.Ga./Ha1.sigma;
Gs_OptionY = Ha1.LE.*Ha1.Ga./(one-two+three);
Gs_OptionY = Gs_OptionY.*1000;              %m s-1 to mm s-1
Gs_OptionY((Gs_OptionY<=0)|(Gs_OptionY>200)) = NaN;
Gs_OptionY((Ha1.So<tresholdSo)|(Ha1.rain>0)) = NaN;         Gs_OptionY = AM_rm_outlier(Gs_OptionY,3);
%..................................................................
one = Ha1.epsilon.*A;   two = (Ha1.epsilon+1).*Ha1.LE;
three = Ha1.rho_a.*10^6.*Cp.*(Ha1.e_sat-Ha1.e).*Ga_ustar./Ha1.sigma;    three = AM_rm_outlier(three,3);
Gs_OptionYustar = Ha1.LE.*Ga_ustar./(one-two+three);
Gs_OptionYustar = Gs_OptionYustar.*1000;    %m s-1 to mm s-1
Gs_OptionYustar((Gs_OptionYustar<=0)|(Gs_OptionYustar>1000)) = NaN;
Gs_OptionYustar((Ha1.So<tresholdSo)|(Ha1.rain>0)) = NaN;    Gs_OptionYustar = AM_rm_outlier(Gs_OptionYustar,3);

%..................................................................
%%         As in Blanken & Black, 2004
%..................................................................
Ha1.Bowen   = Ha1.H./Ha1.LE;
Rs_OptionBB = (((Ha1.epsilon.*Ha1.Bowen)-1).*Ra)+((Ha1.rho_a.*Cp.*10^6.*Ha1.VPD)./(Ha1.sigma.*Ha1.LE));
Gs_OptionBB = 1000./Rs_OptionBB;
Gs_OptionBB((Gs_OptionBB<=0)|(Gs_OptionBB>400)) = NaN;
Gs_OptionBB((Ha1.So<tresholdSo)|(Ha1.rain>0)) = NaN;        Gs_OptionBB = AM_rm_outlier(Gs_OptionBB,3);

Rs_OptionBB_ustar = (((Ha1.epsilon.*Ha1.Bowen)-1).*Ra_ustar)+((Ha1.rho_a.*Cp.*10^6.*Ha1.VPD)./(Ha1.sigma.*Ha1.LE));
Gs_OptionBB_ustar = 1000./Rs_OptionBB_ustar;
Gs_OptionBB_ustar((Gs_OptionBB_ustar<=0)|(Gs_OptionBB_ustar>200)) = NaN;
Gs_OptionBB_ustar((Ha1.So<tresholdSo)|(Ha1.rain>0)) = NaN;	Gs_OptionBB_ustar = AM_rm_outlier(Gs_OptionBB_ustar,3);

% .........................................................................
Ha1.BowenDry = Ha1.H./Ha1.LEdry;
Rs_OptionBBdry = (((Ha1.epsilon.*Ha1.BowenDry)-1).*Ra)+((Ha1.rho_a.*Cp.*10^6.*Ha1.VPD)./(Ha1.sigma.*Ha1.LEdry));
Gs_OptionBBdry = 1000./Rs_OptionBBdry;
Gs_OptionBBdry((Gs_OptionBBdry<=0)|(Gs_OptionBBdry>400)) = NaN;
Gs_OptionBBdry((Ha1.So<tresholdSo)|(Ha1.rain>0)) = NaN;     Gs_OptionBBdry = AM_rm_outlier(Gs_OptionBBdry,3);

Rs_OptionBBdry_ustar = (((Ha1.epsilon.*Ha1.BowenDry)-1).*Ra_ustar)+((Ha1.rho_a.*Cp.*10^6.*Ha1.VPD)./(Ha1.sigma.*Ha1.LEdry));
Gs_OptionBBdry_ustar = 1000./Rs_OptionBBdry_ustar;
Gs_OptionBBdry_ustar((Gs_OptionBBdry_ustar<=0)|(Gs_OptionBBdry_ustar>200)) = NaN;
Gs_OptionBBdry_ustar((Ha1.So<tresholdSo)|(Ha1.rain>0)) = NaN;
Gs_OptionBBdry_ustar = AM_rm_outlier(Gs_OptionBBdry_ustar,3);

% %..................................................................
% % Climatological resistance
% %..................................................................
% Ha1.Ri = (Ha1.rho_a.*Cp.*10^6.*Ha1.VPD)./(Ha1.sigma.*(Ha1.LE+Ha1.H));
% %Ha1.Ri = (Ha1.rho_a.*Cp.*10^6.*Ha1.VPD)./(Ha1.sigma.*(Ha1.netrad));
% Ha1.Gi = 1000./Ha1.Ri;
% Ha1.Gi(Ha1.So<tresholdSo) = NaN;        Ha1.Gi(Ha1.Gi<0) = NaN;
% Ha1.Gi = AM_rm_outlier(Ha1.Gi,3);
%
% % Equilibrium LE
% Ha1.PTalpha = Ha1.LE./Ha1.LEref;

% .........................................................................
%% Gs units mm s-1
% .........................................................................
Ha1.GsPMall   = Gs_OptionBB;
Ha1.GsPM      = Gs_OptionBBdry;
Ha1.GsPMustar = Gs_OptionBB_ustar;

% From Pearcy et all. Measurement of transpiration and leaf conductance
% P in kPa, tair in degC, Gs from cm/s to mol m-2s-1
% Ha1.GsPMallmol = Ha1.GsPMall.*0.446.*(273./(273+Ha1.tasp_fill)).*((Ha1.pambpa_fill./1000)./101.3);

% Gas ideal gas law Gs [m s-1] ix Pa[kPa]/R [m3 Pa K-1 mol] ix Ta [k]   % average sea-level pressure is 101.325 kPa
% R = 8.3144621 m3 Pa K−1 mol−1   8.3144621 m3 /1000 kPa-1 K-1 mol
% Gs mol m-2 s-1
Ha1.GsPMmmol = (Ha1.GsPM./1000).*Ha1.pambKpa./(R.*(273+Ha1.tair));
Ha1.GsPMmmol = Ha1.GsPMmmol.*1000;
% Typical values for irrigated trials are: 300-700 mmol m-2s-1;
% and for mildly water stressed trials are: 80-300 mmol m-2s-1
Ha1.GsPMallmmol = (Ha1.GsPMall./1000).*(Ha1.pambpa./1000)./(R.*(273+Ha1.tair));
Ha1.GsPMallmmol = Ha1.GsPMallmmol.*1000;

% ........................................................................
%% ETref
% ........................................................................
Ha1.LEref = AM_fill((Ha1.LE+Ha1.H).*(Ha1.delta./(Ha1.delta+(Ha1.sigma))));
% Ha1.LEref = AM_fill((Ha1.netrad).*(Ha1.delta./(Ha1.delta+(Ha1.sigma))));
Ha1.LEref(Ha1.So < tresholdSo) = NaN;
Ha1.ETref = AM_fill_plus(Ha1.LEref./Ha1.lambda);
Ha1.ETref = Ha1.ETref.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)

% ........................................................................
%% day
% ........................................................................
[Ha1.dayLE,~,ix,~,Ha1.daydate,Ha1.dayLEmin,Ha1.dayLEmax]   = AM_day(Ha1.LE,Ha1.dateloc,0);
Ha1.dayLE(ix<tresholdCycle) = NaN;         Ha1.dayLEmin(ix<tresholdCycle) = NaN;        Ha1.dayLEmax(ix<tresholdCycle) = NaN;
[Ha1.dayH,~,ix,~,~,Ha1.dayHmin,Ha1.dayHmax]   = AM_day(Ha1.H,Ha1.dateloc,0);
Ha1.dayH(ix<tresholdCycle) = NaN;         Ha1.dayHmin(ix<tresholdCycle) = NaN;        Ha1.dayHmax(ix<tresholdCycle) = NaN;
[Ha1.daynetrad,~,ix,~,~,Ha1.daynetradmin,Ha1.daynetradmax]   = AM_day(Ha1.netrad,Ha1.dateloc,0);
Ha1.daynetrad(ix<tresholdCycle) = NaN;         Ha1.daynetradmin(ix<tresholdCycle) = NaN;        Ha1.daynetradmax(ix<tresholdCycle) = NaN;
[Ha1.daytair,~,ix,~,~,Ha1.daytairmin,Ha1.daytairmax]   = AM_day(Ha1.tair,Ha1.dateloc,0);
Ha1.daytair(ix<tresholdCycle) = NaN;         Ha1.daytairmin(ix<tresholdCycle) = NaN;        Ha1.daytairmax(ix<tresholdCycle) = NaN;

[Ha1.eightH,~,~,~,~,Ha1.eight_stdH,Ha1.eight] = AM_eight2cycle_rs(Ha1.H,Ha1.dateloc,tresholdCycle,2,3);    Ha1.eightH = AM_fill(Ha1.eightH);
Ha1.eightLE = AM_eight2cycle_rs(Ha1.LE,Ha1.dateloc,tresholdCycle,2,3);    Ha1.eightLE = AM_fill(Ha1.eightLE);
Ha1.eightnetrad = AM_eight2cycle_rs(Ha1.netrad,Ha1.dateloc,tresholdCycle,2,3);    Ha1.eightnetrad = AM_fill(Ha1.eightnetrad);
Ha1.eighttair = AM_eight2cycle_rs(Ha1.tair,Ha1.dateloc,tresholdCycle,2,3);    Ha1.eighttair = AM_fill(Ha1.eighttair);

[Ha1.weekH,~,~,~,~,Ha1.week_stdH] = AM_week2cycle_rs(Ha1.H,Ha1.dateloc,tresholdCycle,2,3);  Ha1.weekH  = AM_fill(Ha1.weekH);
[Ha1.weekLE,~,~,~,~,Ha1.week_stdLE] = AM_week2cycle_rs(Ha1.LE,Ha1.dateloc,tresholdCycle,2,3);  Ha1.weekLE  = AM_fill(Ha1.weekLE);
[Ha1.weeknetrad,~,~,~,~,Ha1.week_stdnetrad] = AM_week2cycle_rs(Ha1.netrad,Ha1.dateloc,tresholdCycle,2,3);  Ha1.weeknetrad  = AM_fill(Ha1.weeknetrad);
[Ha1.weektair,~,~,~,~,Ha1.week_stdtair] = AM_week2cycle_rs(Ha1.tair,Ha1.dateloc,tresholdCycle,2,3);  Ha1.weektair  = AM_fill(Ha1.weektair);

[Ha1.monthH,~,~,Ha1.monthHmin,Ha1.monthHmax] = AM_month2cycle(Ha1.H,Ha1.dateloc,tresholdCycle,2,2);
Ha1.monthH = AM_fill(Ha1.monthH);
[Ha1.monthLE,~,~,Ha1.monthLEmin,Ha1.monthLEmax] = AM_month2cycle(Ha1.LE,Ha1.dateloc,tresholdCycle,2,2);
Ha1.monthLE = AM_fill(Ha1.monthLE);
[Ha1.monthnetrad,~,~,Ha1.monthnetradmin,Ha1.monthnetradmax] = AM_month2cycle(Ha1.netrad,Ha1.dateloc,tresholdCycle,2,2);
Ha1.monthnetrad = AM_fill(Ha1.monthnetrad);
[Ha1.monthtair,~,~,Ha1.monthtairmin,Ha1.monthtairmax] = AM_month2cycle(Ha1.tair,Ha1.dateloc,tresholdCycle,2,2);
Ha1.monthtair = AM_fill(Ha1.monthtair);

Ha1.gep(Ha1.So==0) = 0;
[Ha1.dayGEP,~,ix,~,~,Ha1.dayGEPmin,Ha1.dayGEPmax] = AM_day(Ha1.gep.*gC_m2_d1,Ha1.dateloc,0);
Ha1.dayGEP(ix<tresholdCycle) = NaN;                 Ha1.dayGEPmin(ix<tresholdCycle) = NaN;
Ha1.dayGEPmax(ix<tresholdCycle) = NaN;
Ha1.dayGEP   = AM_fill_plus(Ha1.dayGEP);
Ha1.eightGEP = AM_eight2cycle_rs(Ha1.gep.*gC_m2_d1,Ha1.dateloc,tresholdCycle,2,3);
Ha1.eightGEP = AM_fill(Ha1.eightGEP);
[Ha1.weekGEP,~,~,~,~,Ha1.week_stdGEP,Ha1.week] = AM_week2cycle_rs(Ha1.gep.*gC_m2_d1,Ha1.dateloc,tresholdCycle,2,3);
Ha1.weekGEP  = AM_fill(Ha1.weekGEP);
[Ha1.monthGEP,~,~,Ha1.monthGEPmin,Ha1.monthGEPmax] = AM_month2cycle(Ha1.gep.*gC_m2_d1,Ha1.dateloc,tresholdCycle,2,2);
Ha1.monthGEP = AM_fill(Ha1.monthGEP);

[Ha1.dayRECO,~,ix,~,~,Ha1.dayRECOmin,Ha1.dayRECOmax] = AM_day(Ha1.reco.*gC_m2_d1,Ha1.dateloc,0);
Ha1.dayRECO(ix<tresholdCycle) = NaN;                Ha1.dayRECOmin(ix<tresholdCycle) = NaN;
Ha1.dayRECOmax(ix<tresholdCycle) = NaN;
Ha1.dayRECO   = AM_fill_plus(Ha1.dayRECO);
Ha1.eightRECO = AM_eight2cycle_rs(Ha1.reco.*gC_m2_d1,Ha1.dateloc,tresholdCycle,2,3);
Ha1.eightRECO = AM_fill(Ha1.eightRECO);
[Ha1.weekRECO,~,~,~,~,Ha1.week_stdRECO,Ha1.week] = AM_week2cycle_rs(Ha1.reco.*gC_m2_d1,Ha1.dateloc,tresholdCycle,2,3);
Ha1.weekRECO  = AM_fill(Ha1.weekRECO);
[Ha1.monthRECO,~,~,Ha1.monthRECOmin,Ha1.monthRECOmax] = AM_month2cycle(Ha1.reco.*gC_m2_d1,Ha1.dateloc,tresholdCycle,2,2);
Ha1.monthRECO = AM_fill(Ha1.monthRECO);

[Ha1.dayNEE,~,ix,~,~,Ha1.dayNEEmin,Ha1.dayNEEmax] = AM_day(Ha1.nee.*gC_m2_d1,Ha1.dateloc,0);
Ha1.dayNEE(ix<tresholdCycle) = NaN;                                  Ha1.dayNEEmin(ix<tresholdCycle) = NaN;
Ha1.dayNEEmax(ix<tresholdCycle) = NaN;
Ha1.dayNEE   = AM_fill_plus(Ha1.dayNEE);
Ha1.eightNEE = AM_eight2cycle_rs(Ha1.nee.*gC_m2_d1,Ha1.dateloc,tresholdCycle,2,3);
Ha1.eightNEE = AM_fill(Ha1.eightNEE);
[Ha1.weekNEE,~,~,~,~,Ha1.week_stdNEE,Ha1.week] = AM_week2cycle_rs(Ha1.nee.*gC_m2_d1,Ha1.dateloc,tresholdCycle,2,3);
Ha1.weekNEE  = AM_fill(Ha1.weekNEE);
[Ha1.monthNEE,~,~,Ha1.monthNEEmin,Ha1.monthNEEmax] = AM_month2cycle(Ha1.nee.*gC_m2_d1,Ha1.dateloc,tresholdCycle,2,2);
Ha1.monthNEE = AM_fill(Ha1.monthNEE);

%% ...........................................
Ha1.LEday = Ha1.LE;          Ha1.LEday(Ha1.So<tresholdSo) = NaN;
Ha1.Hday = Ha1.H;            Ha1.Hday(Ha1.So<tresholdSo) = NaN;
Ha1.netradday = Ha1.netrad;  Ha1.netradday(Ha1.So<tresholdSo) = NaN;
Ha1.tairday = Ha1.tair;      Ha1.tairday(Ha1.So<tresholdSo) = NaN;
Ha1.ustarday = Ha1.ustar;    Ha1.ustarday(Ha1.So<tresholdSo);
Ha1.EF = AM_fill(Ha1.LE./(Ha1.LE+Ha1.H));
Ha1.EFday = AM_fill(Ha1.LE./(Ha1.LE+Ha1.H));         Ha1.EFday(Ha1.So<tresholdSo) = NaN;
Ha1.EFday((Ha1.EFday<0)|(Ha1.EFday>1)) = NaN;   Ha1.EFday = AM_rm_outlier(Ha1.EFday,3);
Ha1.Bowenday = Ha1.Bowen;     Ha1.Bowenday(Ha1.So<tresholdSo);

[Ha1.dayLEday,~,ix,~,~,Ha1.dayLEdaymin,Ha1.dayLEdaymax] = AM_day(Ha1.LEday,Ha1.dateloc,0);
Ha1.dayLEday(ix<tresholdCycleDay) = NaN;        Ha1.dayLEdaymin(ix<tresholdCycleDay) = NaN;      Ha1.dayLEdaymax(ix<tresholdCycleDay) = NaN;
[Ha1.dayHday,~,ix,~,~,Ha1.dayHdaymin,Ha1.dayHdaymax] = AM_day(Ha1.H,Ha1.dateloc,0);
Ha1.dayHday(ix<tresholdCycleDay) = NaN;         Ha1.dayHdaymin(ix<tresholdCycleDay) = NaN;          Ha1.dayHdaymax(ix<tresholdCycleDay) = NaN;
[Ha1.daynetradday,~,ix,~,~,Ha1.daynetraddaymin,Ha1.daynetraddaymax] = AM_day(Ha1.netradday,Ha1.dateloc,0);
Ha1.daynetradday(ix<tresholdCycleDay) = NaN;    Ha1.daynetraddaymin(ix<tresholdCycleDay) = NaN; Ha1.daynetraddaymax(ix<tresholdCycleDay) = NaN;
[Ha1.daytairday,~,ix,~,~,Ha1.daytairdaymin,Ha1.daytairdaymax] = AM_day(Ha1.tairday,Ha1.dateloc,0);
Ha1.daytairday(ix<tresholdCycleDay) = NaN;      Ha1.daytairdaymin(ix<tresholdCycleDay) = NaN;         Ha1.daytairdaymax(ix<tresholdCycleDay) = NaN;

[Ha1.eightHday,~,~,~,~,Ha1.eight_stdHday,Ha1.eight] = AM_eight2cycle_rs(Ha1.Hday,Ha1.dateloc,tresholdCycleDay,2,3);    Ha1.eightHday = AM_fill(Ha1.eightHday);
Ha1.eightLEday = AM_eight2cycle_rs(Ha1.LEday,Ha1.dateloc,tresholdCycleDay,2,3);   Ha1.eightLEday = AM_fill(Ha1.eightLEday);
Ha1.eightnetradday = AM_eight2cycle_rs(Ha1.netradday,Ha1.dateloc,tresholdCycleDay,2,3); Ha1.eightnetradday = AM_fill(Ha1.eightnetradday);
Ha1.eighttairday = AM_eight2cycle_rs(Ha1.tairday,Ha1.dateloc,tresholdCycleDay,2,3);     Ha1.eighttairday = AM_fill(Ha1.eighttairday);

[Ha1.weekHday,~,~,~,~,Ha1.week_stdHday,Ha1.week] = AM_week2cycle_rs(Ha1.Hday,Ha1.dateloc,tresholdCycleDay,2,3);        Ha1.weekHday  = AM_fill(Ha1.weekHday);
[Ha1.weekLEday,~,~,~,~,Ha1.week_stdLEday] = AM_week2cycle_rs(Ha1.LEday,Ha1.dateloc,tresholdCycleDay,2,3);                   Ha1.weekLEday = AM_fill(Ha1.weekLEday);
[Ha1.weeknetradday,~,~,~,~,Ha1.week_stdnetradday] = AM_week2cycle_rs(Ha1.netradday,Ha1.dateloc,tresholdCycleDay,2,3);  Ha1.weeknetradday  = AM_fill(Ha1.weeknetradday);
[Ha1.weektairday,~,~,~,~,Ha1.week_stdtairday] = AM_week2cycle_rs(Ha1.tairday,Ha1.dateloc,tresholdCycleDay,2,3);                 Ha1.weektairday = AM_fill(Ha1.weektairday);
[Ha1.weekustarday,~,~,~,~,Ha1.week_stdustarday] = AM_week2cycle_rs(Ha1.ustarday,Ha1.dateloc,tresholdCycleDay,2,3);        Ha1.weekustarday = AM_fill(Ha1.weekustarday);
[Ha1.weekBowen,~,~,~,~,Ha1.week_stdBowen] = AM_week2cycle_rs(Ha1.Bowen,Ha1.dateloc,tresholdCycleDay,2,3);                Ha1.weekBowen = AM_fill(Ha1.weekBowen);
[Ha1.weekEF,~,~,~,~,Ha1.week_stdEF] = AM_week2cycle_rs(Ha1.EF,Ha1.dateloc,tresholdCycleDay,2,3); Ha1.weekEF = AM_fill(Ha1.weekEF);
[Ha1.weekET,~,~,~,~,Ha1.week_stdET] = AM_week2cycle_rs(Ha1.ET,Ha1.dateloc,tresholdCycleDay,2,3); Ha1.weekET = AM_fill(Ha1.weekET);
[Ha1.weekETdry,~,~,~,~,Ha1.week_stdETdry] = AM_week2cycle_rs(Ha1.ETdry,Ha1.dateloc,tresholdCycleDay,2,3);                     Ha1.weekETdry = AM_fill(Ha1.weekETdry);
[Ha1.weekETdryday,~,~,~,~,Ha1.week_stdETdryday] = AM_week2cycle_rs(Ha1.ETdryday,Ha1.dateloc,tresholdCycleDay,2,3);    Ha1.weekETdryday = AM_fill(Ha1.weekETdryday);
[Ha1.weekGsPMmmol,~,~,~,~,Ha1.week_stdGsPMmmol] = AM_week2cycle_rs(Ha1.GsPMmmol,Ha1.dateloc,tresholdCycleDay,2,3); Ha1.weekGsPMmmol = AM_fill(Ha1.weekGsPMmmol);
[Ha1.weekLEdry,~,~,~,~,Ha1.week_stdLEdry] = AM_week2cycle_rs(Ha1.LEdry,Ha1.dateloc,tresholdCycleDay,2,3);    Ha1.weekLEdry = AM_fill(Ha1.weekLEdry);
[Ha1.weekEFday,~,~,~,~,Ha1.week_stdEFday] = AM_week2cycle_rs(Ha1.EFday,Ha1.dateloc,tresholdCycleDay,2,3); Ha1.weekEFday = AM_fill(Ha1.weekEFday);
[Ha1.weekBowenday,~,~,~,~,Ha1.week_stdBowenday] = AM_week2cycle_rs(Ha1.Bowenday,Ha1.dateloc,tresholdCycleDay,2,3); Ha1.weekBowenday = AM_fill(Ha1.weekBowenday);

Ha1.GEPday = Ha1.gep;        Ha1.GEPday(Ha1.So==0) = 0;  Ha1.GEPday = AM_fill_plus(Ha1.GEPday);
Ha1.GEPday(Ha1.So<tresholdSo) = NaN;
[Ha1.dayGEPday,~,ix,~,~,Ha1.dayGEPdaymin,Ha1.dayGEPdaymax] = AM_day(Ha1.GEPday.*gC_m2_d1,Ha1.dateloc,0);
Ha1.dayGEPday(ix<floor(countSo.*0.75))    = NaN;          Ha1.dayGEPdaymin(ix<floor(countSo.*0.75)) = NaN;
Ha1.dayGEPdaymax(ix<floor(countSo.*0.75)) = NaN;
% Ha1.dayGEPday(isnan(Ha1.dayGEP)) = NaN;  %days with little data
Ha1.dayGEPday(Ha1.dayGEPday<-3) = NaN;
Ha1.dayGEPday = AM_fill_plus(Ha1.dayGEPday);
Ha1.eightGEPday = AM_eight2cycle_rs(Ha1.GEPday.*gC_m2_d1,Ha1.dateloc,tresholdCycleDay,2,3);
Ha1.eightGEPday = AM_fill(Ha1.eightGEPday);
[Ha1.weekGEPday,~,~,~,~,Ha1.week_stdGEPday,Ha1.week] = AM_week2cycle_rs(Ha1.GEPday.*gC_m2_d1,Ha1.dateloc,tresholdCycleDay,2,3);
Ha1.weekGEPday  = AM_fill(Ha1.weekGEPday);
[Ha1.monthGEPday,~,~,Ha1.monthGEPdaymin,Ha1.monthGEPdaymax] = AM_month2cycle(Ha1.GEPday.*gC_m2_d1,Ha1.dateloc,tresholdCycleDay,2,2);
Ha1.monthGEPday = AM_fill(Ha1.monthGEPday);

Ha1.RECOday = Ha1.reco;        Ha1.RECOday(Ha1.So<tresholdSo) = NaN;
[Ha1.dayRECOday,~,ix,~,~,Ha1.dayRECOdaymin,Ha1.dayRECOdaymax] = AM_day(Ha1.RECOday.*gC_m2_d1,Ha1.dateloc,0);
Ha1.dayRECOday(ix<tresholdCycleDay) = NaN;        Ha1.dayRECOdaymin(ix<tresholdCycleDay) = NaN;      Ha1.dayRECOdaymax(ix<tresholdCycleDay) = NaN;
Ha1.eightRECOday = AM_eight2cycle_rs(Ha1.RECOday.*gC_m2_d1,Ha1.dateloc,tresholdCycleDay,2,3);   Ha1.eightRECOday = AM_fill(Ha1.eightRECOday);
[Ha1.weekRECOday,~,~,~,~,Ha1.week_stdRECOday] = AM_week2cycle_rs(Ha1.RECOday.*gC_m2_d1,Ha1.dateloc,tresholdCycleDay,2,3);       Ha1.weekRECOday  = AM_fill(Ha1.weekRECOday);
[Ha1.monthRECOday,~,~,~,~,Ha1.month_stdRECOday] = AM_month2cycle(Ha1.RECOday.*gC_m2_d1,Ha1.dateloc,tresholdCycleDay,2,3);       Ha1.monthRECOday  = AM_fill(Ha1.monthRECOday);

Ha1.NEEday = Ha1.nee;        Ha1.NEEday(Ha1.So<tresholdSo) = NaN;
[Ha1.dayNEEday,~,ix,~,~,Ha1.dayNEEdaymin,Ha1.dayNEEdaymax] = AM_day(Ha1.NEEday,Ha1.dateloc,0);
Ha1.dayNEEday(ix<tresholdCycleDay) = NaN;        Ha1.dayNEEdaymin(ix<tresholdCycleDay) = NaN;      Ha1.dayNEEdaymax(ix<tresholdCycleDay) = NaN;
Ha1.eightNEEday = AM_eight2cycle_rs(Ha1.NEEday,Ha1.dateloc,tresholdCycleDay,2,3);   Ha1.eightNEEday = AM_fill(Ha1.eightNEEday);
[Ha1.weekNEEday,~,~,~,~,Ha1.week_stdNEEday] = AM_week2cycle_rs(Ha1.NEEday,Ha1.dateloc,tresholdCycleDay,2,3);       Ha1.weekNEEday  = AM_fill(Ha1.weekNEEday);
[Ha1.monthNEEday,~,~,~,~,Ha1.month_stdNEEday] = AM_month2cycle(Ha1.NEEday,Ha1.dateloc,tresholdCycleDay,2,3);       Ha1.monthNEEday  = AM_fill(Ha1.monthNEEday);

%%
[Ha1.weekETref,~,~,~,~,Ha1.week_stdETref] = AM_week2cycle_rs(Ha1.ETref,Ha1.dateloc,tresholdCycleDay,2,3);      Ha1.weekETref = AM_fill(Ha1.weekETref);
[Ha1.weekGsPM,~,~,~,~,Ha1.week_stdGsPM] = AM_week2cycle_rs(Ha1.GsPM,Ha1.dateloc,tresholdCycleDay,2,3);  Ha1.weekGsPM = AM_fill(Ha1.weekGsPM);
[Ha1.weekGsPMmmol,~,~,~,~,Ha1.week_stdGsPMmmol] = AM_week2cycle_rs(Ha1.GsPMmmol,      Ha1.dateloc,tresholdCycleDay,2,3); Ha1.weekGsPMmmol = AM_fill(Ha1.weekGsPMmmol);
[Ha1.weekLEdry,~,~,~,~,Ha1.week_stdLEdry] = AM_week2cycle_rs(Ha1.LEdry,Ha1.dateloc,tresholdCycleDay,2,3);    Ha1.weekLEdry = AM_fill(Ha1.weekLEdry);
[Ha1.weekEFday,~,~,~,~,Ha1.week_stdEFday] = AM_week2cycle_rs(Ha1.EFday,Ha1.dateloc,tresholdCycleDay,2,3); Ha1.weekEFday = AM_fill(Ha1.weekEFday);
[Ha1.weekBowenday,~,~,~,~,Ha1.week_stdBowenday] = AM_week2cycle_rs(Ha1.Bowenday,Ha1.dateloc,tresholdCycleDay,2,3); Ha1.weekBowenday = AM_fill(Ha1.weekBowenday);
% [Ha1.weektairday,~,~,~,~,Ha1.week_stdtairday] = AM_week2cycle_rs(Ha1.tairday,Ha1.dateloc,tresholdCycleDay,2,3); Ha1.weektairday = AM_fill(Ha1.weektairday);

[Ha1.monthHday,~,~,Ha1.monthHdaymin,Ha1.monthHdaymax,~,Ha1.month] = AM_month2cycle(Ha1.Hday,Ha1.dateloc,tresholdCycleDay,2,2);
Ha1.monthHday = AM_fill(Ha1.monthHday);
[Ha1.monthLEday,~,~,Ha1.monthLEdaymin,Ha1.monthLEdaymax] = AM_month2cycle(Ha1.LEday,Ha1.dateloc,tresholdCycleDay,2,2);
Ha1.monthLEday = AM_fill(Ha1.monthLEday);
[Ha1.monthnetradday,~,~,Ha1.monthnetraddaymin,Ha1.monthnetraddaymax] = AM_month2cycle(Ha1.netradday,Ha1.dateloc,tresholdCycleDay,2,2);
Ha1.monthnetradday = AM_fill(Ha1.monthnetradday);
[Ha1.monthtairday,~,~,Ha1.monthtairdaymin,Ha1.monthtairdaymax] = AM_month2cycle(Ha1.tairday,Ha1.dateloc,tresholdCycleDay,2,2);
Ha1.monthtairday = AM_fill(Ha1.monthtairday);

[Ha1.weekETrefPM,~,~,~,~,Ha1.week_stdETrefPM]  = AM_week2cycle_rs(Ha1.ETrefPM,Ha1.dateloc,tresholdCycleDay,4,2);
Ha1.weekETrefPM  = AM_fill(Ha1.weekETrefPM);
[Ha1.week_avgETrefPM,~,Ha1.week_avgstdETrefPM] = AM_week2_avg(Ha1.weekETrefPM,Ha1.week);

[Ha1.weekETrefdayPM,~,~,~,~,Ha1.week_stdETrefdayPM]  = AM_week2cycle_rs(Ha1.ETrefdayPM,Ha1.dateloc,tresholdCycleDay,4,2);
Ha1.weekETrefdayPM  = AM_fill(Ha1.weekETrefdayPM);
[Ha1.week_avgETrefdayPM,~,Ha1.week_avgstdETrefdayPM] = AM_week2_avg(Ha1.weekETrefdayPM,Ha1.week);

Ha1.eightGsPMall = AM_eight2cycle_rs(Ha1.GsPMall,Ha1.dateloc,tresholdCycleDay,2,3);    Ha1.eightGsPMall = AM_fill(Ha1.eightGsPMall);
[Ha1.weekGsPMall,~,~,~,~,Ha1.week_stdGsPMall] = AM_week2cycle_rs(Ha1.GsPMall,Ha1.dateloc,tresholdCycleDay,2,3);  Ha1.weekGsPMall  = AM_fill(Ha1.weekGsPMall);
[Ha1.monthGsPMall,~,~,Ha1.monthGsPMallmin,Ha1.monthGsPMallmax] = AM_month2cycle(Ha1.GsPMall,Ha1.dateloc,tresholdCycleDay,2,2);
Ha1.monthGsPMall = AM_fill(Ha1.monthGsPMall);                           Ha1.monthGsPMallmax = AM_fill(Ha1.monthGsPMallmax);
[Ha1.dayGsPMall,~,ix,~,~,Ha1.dayGsPMallmin,Ha1.dayGsPMallmax]   = AM_day(Ha1.GsPMall,Ha1.dateloc,0);
Ha1.dayGsPMall(ix<tresholdCycleDay) = NaN;         Ha1.dayGsPMallmin(ix<tresholdCycleDay) = NaN;        Ha1.dayGsPMallmax(ix<tresholdCycleDay) = NaN;

%..........................................................................
%% Seasonality
%..........................................................................
[Ha1.week_avgHday,~,Ha1.week_avgstdHday]      = AM_week2_avg(Ha1.weekHday,Ha1.week);
[Ha1.week_avgLEday,~,Ha1.week_avgstdLEday]  = AM_week2_avg(Ha1.weekLEday,Ha1.week);
[Ha1.week_avgnetradday,~,Ha1.week_avgstdnetradday] = AM_week2_avg(Ha1.weeknetradday,Ha1.week);
[Ha1.week_avgtairday,~,Ha1.week_avgstdtairday] = AM_week2_avg(Ha1.weektairday,Ha1.week);

[Ha1.eight_avgLEday,~,Ha1.eight_stdLEday]  = AM_eight_avg(Ha1.eightLEday,Ha1.eight);
[Ha1.eight_avgHday,~,Ha1.eight_stdHday]      = AM_eight_avg(Ha1.eightHday,Ha1.eight);
[Ha1.eight_avgnetradday,~,Ha1.eight_stdnetradday] = AM_eight_avg(Ha1.eightnetradday,Ha1.eight);
[Ha1.eight_avgtairday,~,Ha1.eight_stdtairday] = AM_eight_avg(Ha1.eighttairday,Ha1.eight);

[Ha1.month_avgLEday,Ha1.month_avgstdLEday] = AM_month_avg(Ha1.monthLEday,Ha1.month);
[Ha1.month_avgHday,Ha1.month_avgstdHday]     = AM_month_avg(Ha1.monthHday,Ha1.month);
[Ha1.month_avgnetradday,Ha1.month_avgstdnetradday] = AM_month_avg(Ha1.monthnetradday,Ha1.month);
[Ha1.month_avgtairday,Ha1.month_avgstdtairday] = AM_month_avg(Ha1.monthtairday,Ha1.month);

[Ha1.month_avgGEPday,Ha1.month_avgstdGEPday] = AM_month_avg(Ha1.monthGEPday,Ha1.month);
[Ha1.week_avgGEPday,~,Ha1.week_avgstdGEPday]  = AM_week2_avg(Ha1.weekGEPday,Ha1.week);
[Ha1.eight_avgGEPday,~,Ha1.eight_stdGEPday]  = AM_eight_avg(Ha1.eightGEPday,Ha1.eight);

[Ha1.month_avgRECOday,Ha1.month_avgstdRECOday] = AM_month_avg(Ha1.monthRECOday,Ha1.month);
[Ha1.week_avgRECOday,~,Ha1.week_avgstdRECOday]  = AM_week2_avg(Ha1.weekRECOday,Ha1.week);
[Ha1.eight_avgRECOday,~,Ha1.eight_stdRECOday]  = AM_eight_avg(Ha1.eightRECOday,Ha1.eight);

[Ha1.month_avgNEEday,Ha1.month_avgstdNEEday] = AM_month_avg(Ha1.monthNEEday,Ha1.month);
[Ha1.week_avgNEEday,~,Ha1.week_avgstdNEEday]  = AM_week2_avg(Ha1.weekNEEday,Ha1.week);
[Ha1.eight_avgNEEday,~,Ha1.eight_stdNEEday]  = AM_eight_avg(Ha1.eightNEEday,Ha1.eight);

%..........................................................................
%% Seasonality
%..........................................................................
[Ha1.week_avgustarday,~,Ha1.week_avgstdustarday] = AM_week2_avg(Ha1.weekustarday,Ha1.week);
[Ha1.week_avgBowen,~,Ha1.week_avgstdBowen] = AM_week2_avg(Ha1.weekBowen,Ha1.week);
[Ha1.week_avgEF,~,Ha1.week_avgstdEF] = AM_week2_avg(Ha1.weekEF,Ha1.week);
[Ha1.week_avgET,~,Ha1.week_avgstdET] = AM_week2_avg(Ha1.weekET,Ha1.week);
[Ha1.week_avgETref,~,Ha1.week_avgstdETref] = AM_week2_avg(Ha1.weekETref,Ha1.week);
[Ha1.week_avgGsPM,~,Ha1.week_avgstdGsPM]       = AM_week2_avg(Ha1.weekGsPM,Ha1.week);
[Ha1.week_avgGsPMall,~,Ha1.week_avgstdGsPMall] = AM_week2_avg(Ha1.weekGsPMall,Ha1.week);
[Ha1.week_avgETdry,~,Ha1.week_avgstdETdry]       = AM_week2_avg(Ha1.weekETdry,Ha1.week);
[Ha1.week_avgETdryday,~,Ha1.week_avgstdETdryday] = AM_week2_avg(Ha1.weekETdryday,Ha1.week);
% [Ha1.week_avgETref,~,Ha1.week_avgstdETref]       = AM_week2_avg(Ha1.weekETref,Ha1.week);
% [Ha1.week_avgETrefday,~,Ha1.week_avgstdETrefday] = AM_week2_avg(Ha1.weekETrefday,Ha1.week);
[Ha1.week_avgGsPMmmol,~,Ha1.week_avgstdGsPMmmol] = AM_week2_avg(Ha1.weekGsPMmmol,Ha1.week);
[Ha1.week_avgGsPM,~,Ha1.week_avgstdGsPM] = AM_week2_avg(Ha1.weekGsPM,Ha1.week);
[Ha1.week_avgGsPMall,~,Ha1.week_avgstdGsPMall] = AM_week2_avg(Ha1.weekGsPMall,Ha1.week);
% [Ha1.week_avgGiday,~,Ha1.week_avgstdGiday] = AM_week2_avg(Ha1.weekGiday,Ha1.week);
[Ha1.week_avgLEdry,~,Ha1.week_avgstdLEdry] = AM_week2_avg(Ha1.weekLEdry,Ha1.week);
% [Ha1.week_avgPTalphaday,~,Ha1.week_avgstdPTalphaday] = AM_week2_avg(Ha1.weekPTalphaday,Ha1.week);
% [Ha1.week_avgVPDday,~,Ha1.week_avgstdVPDday] = AM_week2_avg(Ha1.weekVPDday,Ha1.week);
[Ha1.week_avgEFday,~,Ha1.week_avgstdEFday]   = AM_week2_avg(Ha1.weekEFday,Ha1.week);
% [Ha1.week_avgEFdaydry,~,Ha1.week_avgstdEFdaydry] = AM_week2_avg(Ha1.weekEFdaydry,Ha1.week);
[Ha1.week_avgBowenday,~,Ha1.week_avgstdBowenday] = AM_week2_avg(Ha1.weekBowenday,Ha1.week);
% [Ha1.week_avgH2O,~,Ha1.week_avgstdH2O]   = AM_week2_avg(Ha1.weekH2O,Ha1.week);

% % % .........................................................................
% % %% Eight seasonality
% % % .........................................................................
% % [Ha1.eight_avgBowen,~,Ha1.eight_stdBowen] = AM_eight_avg(Ha1.eightBowen,Ha1.eight);
% % [Ha1.eight_avgEF,~,Ha1.eight_stdEF]       = AM_eight_avg(Ha1.eightEF,Ha1.eight);
% % [Ha1.eight_avgET,~,Ha1.eight_stdET]       = AM_eight_avg(Ha1.eightET,Ha1.eight);
% % [Ha1.eight_avgGs,~,Ha1.eight_stdGs]       = AM_eight_avg(Ha1.eightGsPMall,Ha1.eight);
% % [Ha1.eight_avgGsPM,~,Ha1.eight_stdGsPM]   = AM_eight_avg(Ha1.eightGsPM,Ha1.eight);
% % [Ha1.month_avgGsPMall,Ha1.month_avgstdGsPMall] = AM_month_avg(Ha1.monthGsPMall,Ha1.month);
% % [Ha1.eight_avgETdry,~,Ha1.eight_stdETdry] = AM_eight_avg(Ha1.eightETdry,Ha1.eight);
% % [Ha1.eight_avgETdryday,~,Ha1.eight_stdETdryday] = AM_eight_avg(Ha1.eightETdryday,Ha1.eight);
% % [Ha1.eight_avgETref,~,Ha1.eight_stdETref]       = AM_eight_avg(Ha1.eightETref,Ha1.eight);
% % [Ha1.eight_avgGsPMmmol,~,Ha1.eight_stdGsPMmmol] = AM_eight_avg(Ha1.eightGsPMmmol,Ha1.eight);
% % [Ha1.eight_avgGsPMallmmol,~,Ha1.eight_stdGsPMallmmol] = AM_eight_avg(Ha1.eightGsPMallmmol,Ha1.eight);
% % [Ha1.eight_avgPTalphaday,~,Ha1.eight_stdPTalphaday] = AM_eight_avg(Ha1.eightPTalphaday,Ha1.eight);
% % [Ha1.eight_avgVPDday,~,Ha1.eight_stdVPDday] = AM_eight_avg(Ha1.eightVPDday,Ha1.eight);
% % [Ha1.eight_avgLEdry,~,Ha1.eight_stdLEdry]   = AM_eight_avg(Ha1.eightLEdry,Ha1.eight);
% % [Ha1.eight_avgH,~,Ha1.eight_stdH]   = AM_eight_avg(Ha1.eightH,Ha1.eight);
% % [Ha1.eight_avgLE,~,Ha1.eight_stdLE] = AM_eight_avg(Ha1.eightLE,Ha1.eight);
% % [Ha1.eight_avgGiday,~,Ha1.eight_stdGiday] = AM_eight_avg(Ha1.eightGiday,Ha1.eight);
% % [Ha1.eight_avgEFday,~,Ha1.eight_stdEFday] = AM_eight_avg(Ha1.eightEFday,Ha1.eight);
% % [Ha1.eight_avgEFdaydry,~,Ha1.eight_stdEFdaydry] = AM_eight_avg(Ha1.eightEFdaydry,Ha1.eight);
% % [Ha1.eight_avgBowenday,~,Ha1.eight_stdBowenday] = AM_eight_avg(Ha1.eightBowenday,Ha1.eight);
% %
% % [Ha1.month_avgBowen,Ha1.month_avgstdBowen] = AM_month_avg(Ha1.monthBowen,Ha1.month);
% % [Ha1.month_avgEF,Ha1.month_avgstdEF] = AM_month_avg(Ha1.monthEF,Ha1.month);
% % [Ha1.month_avgET,Ha1.month_avgstdET] = AM_month_avg(Ha1.monthET,Ha1.month);
% % [Ha1.month_avgGs,Ha1.month_avgstdGs] = AM_month_avg(Ha1.monthGsPMall,Ha1.month);
% % [Ha1.month_avgGsPMmmol,Ha1.month_avgstdGsPMmmol] = AM_month_avg(Ha1.monthGsPMmmol,Ha1.month);
% % [Ha1.month_avgGsPMallmmol,Ha1.month_avgstdGsPMallmmol] = AM_month_avg(Ha1.monthGsPMallmmol,Ha1.month);
% % [Ha1.month_avgGsPM,Ha1.month_avgstdGsPM]   = AM_month_avg(Ha1.monthGsPM,Ha1.month);
% % [Ha1.month_avgGsPMall,Ha1.month_avgstdGsPMall]   = AM_month_avg(Ha1.monthGsPMall,Ha1.month);
% % [Ha1.month_avgETdry,Ha1.month_avgstdETdry]   = AM_month_avg(Ha1.monthETdry,Ha1.month);
% % [Ha1.month_avgETdryday,Ha1.month_avgstdETdryday] = AM_month_avg(Ha1.monthETdryday,Ha1.month);
% % [Ha1.month_avgETref,Ha1.month_avgstdETref]   = AM_month_avg(Ha1.monthETref,Ha1.month);
% % [Ha1.month_avgETday,Ha1.month_avgstdETday]   = AM_month_avg(Ha1.monthETday,Ha1.month);
% % [Ha1.month_avgGiday,Ha1.month_avgstdGiday]   = AM_month_avg(Ha1.monthGiday,Ha1.month);
% % [Ha1.month_avgLEdry,Ha1.month_avgstdLEdry]   = AM_month_avg(Ha1.monthLEdry,Ha1.month);
% % [Ha1.month_avgPTalphaday,Ha1.month_avgstdPTalphaday] = AM_month_avg(Ha1.monthPTalphaday,Ha1.month);
% % [Ha1.month_avgVPDday,Ha1.month_avgstdVPDday] = AM_month_avg(Ha1.monthVPDday,Ha1.month);
% % [Ha1.month_avgEFday,Ha1.month_avgstdEFday]   = AM_month_avg(Ha1.monthEFday,Ha1.month);
% % [Ha1.month_avgEFdaydry,Ha1.month_avgstdEFdaydry] = AM_month_avg(Ha1.monthEFdaydry,Ha1.month);
% % [Ha1.month_avgBowenday,Ha1.month_avgstdBowenday] = AM_month_avg(Ha1.monthBowenday,Ha1.month);
% %
% % ...................................................................................................................
% %% EB error
% % ...................................................................................................................
% Ha1.StorageLEday      = Ha1.StorageLE;        Ha1.StorageLEday(Ha1.So<=tresholdSo) = NaN;
% Ha1.EphotosyntesisDay = Ha1.Ephotosyntesis;   Ha1.EphotosyntesisDay(Ha1.So<=tresholdSo) = NaN;
% Ha1.StorageHeatDay    = Ha1.StorageHeat;      Ha1.StorageHeatday(Ha1.So<=tresholdSo) = NaN;
% Ha1.netradday         = Ha1.netrad;           Ha1.netradday(Ha1.So<=tresholdSo) = NaN;

Ha1.par_day = Ha1.par;   Ha1.par_day(Ha1.So<tresholdSo) = NaN;
[Ha1.dayPAR,~,ix]      = AM_day(Ha1.par,Ha1.dateloc,0);         Ha1.dayPAR(ix<21) = NaN;
[Ha1.dayPARday,~,ix]   = AM_day(Ha1.par_day,Ha1.dateloc,0);     Ha1.dayPARday(ix<6) = NaN;

 Ha1.eightPARday = AM_eight2cycle_rs(Ha1.par_day,Ha1.dateloc,tresholdCycleDay,4,2); 
Ha1.weekPARday = AM_week2cycle_rs(Ha1.par_day,Ha1.dateloc,tresholdCycleDay,4,2);
 % [Ha1.daynetradday,~,ix]  = AM_day(Ha1.netradday,Ha1.dateloc,0);  Ha1.daynetradday(ix<6) = NaN;
% [~,~,Ha1.netradday_fill] = AM_compute_regression(Ha1.par_day,Ha1.netradday,[.6 .6 .6],1);
% [Ha1.daynetradday_fill,~,ix]    = AM_day(Ha1.netradday_fill,Ha1.dateloc,0);    Ha1.daynetradday_fill(ix<6) = NaN;
% [Ha1.dayStorageHeatDay,~,ix]    = AM_day(Ha1.StorageHeatDay,Ha1.dateloc,0);    Ha1.dayStorageHeatDay(ix<6) = NaN;
% [Ha1.dayStorageLEday,~,ix]      = AM_day(Ha1.StorageLEday,Ha1.dateloc,0);      Ha1.dayStorageLEday(ix<6) = NaN;
% [Ha1.dayEphotosyntesisDay,~,ix] = AM_day(Ha1.EphotosyntesisDay,Ha1.dateloc,0); Ha1.dayEphotosyntesisDay(ix<6) = NaN;
%
% Ha1.dayStorageLEday_fill = AM_fill_day_cycle(Ha1.dayStorageLEday,Ha1.day,6,18);
% Ha1.dayEphotosyntesisDay_fill = AM_fill_day_cycle(Ha1.dayEphotosyntesisDay,Ha1.day,6,18);
%
% Ha1.dayerrorday = Ha1.daynetradday_fill - Ha1.dayLEday - Ha1.dayHday - Ha1.dayStorageHeatDay - ...
%     Ha1.dayStorageLEday_fill - Ha1.dayEphotosyntesisDay_fill;
%
[Ha1.recurrentLE,Ha1.recurrent_stdLE] = AM_hourAVG_recurrent(Ha1.LE,Ha1.dateloc);
[Ha1.recurrentET,Ha1.recurrent_stdET] = AM_hourAVG_recurrent(Ha1.ET,Ha1.dateloc);
[Ha1.day_recurrentLEday,Ha1.day_recurrent_stdLEday] = AM_dayAVG_recurrent(Ha1.dayLEday,Ha1.daydate);
[Ha1.recurrentLEday,Ha1.recurrent_stdLEday] = AM_hourAVG_recurrent(Ha1.LEday,Ha1.dateloc);

Ha1.recurrentH = AM_hourAVG_recurrent(Ha1.H,Ha1.dateloc);
Ha1.day_recurrentHday = AM_dayAVG_recurrent(Ha1.dayHday,Ha1.daydate);

Ha1.recurrentnetrad = AM_hourAVG_recurrent(Ha1.netrad,Ha1.dateloc);
Ha1.day_recurrentnetradday = AM_dayAVG_recurrent(Ha1.daynetradday,Ha1.daydate);
Ha1.recurrenttair = AM_hourAVG_recurrent(Ha1.tair,Ha1.dateloc);
Ha1.day_recurrenttairday = AM_dayAVG_recurrent(Ha1.daytairday,Ha1.daydate);

[Ha1.dayY,Ha1.dayM,Ha1.dayD] = datevec(Ha1.daydate);

figure
hold on
plot(Ha1.week,Ha1.weeknetradday);
plot(Ha1.week,Ha1.weekLEday);
plot(Ha1.week,Ha1.weekHday);

[Ha1.recurrentGEP,Ha1.recurrent_stdGEP] = AM_hourAVG_recurrent(Ha1.gep,Ha1.dateloc);
[Ha1.day_recurrentGEP,Ha1.day_recurrent_stdGEP] = AM_dayAVG_recurrent(Ha1.dayGEP,Ha1.daydate);
Ha1.day_recurrentGEPGoley = sgolayfilt(Ha1.day_recurrentGEP,polyorder,framesize);
Ha1.dayGEP_zscore = (Ha1.dayGEP - Ha1.day_recurrentGEPGoley)./Ha1.day_recurrent_stdGEP;

[Ha1.day_recurrentGEPday,Ha1.day_recurrent_stdGEPday] = AM_dayAVG_recurrent(Ha1.dayGEPday,Ha1.daydate);
[Ha1.recurrentGEPday,Ha1.recurrent_stdGEPday] = AM_hourAVG_recurrent(Ha1.GEPday,Ha1.dateloc);
Ha1.day_recurrentGEPdayGoley = sgolayfilt(Ha1.day_recurrentGEPday,polyorder,framesize);
Ha1.dayGEPday_zscore = (Ha1.dayGEPday - Ha1.day_recurrentGEPdayGoley)./Ha1.day_recurrent_stdGEPday;

[Ha1.recurrentRECO,Ha1.recurrent_stdRECO] = AM_hourAVG_recurrent(Ha1.reco,Ha1.dateloc);
[Ha1.day_recurrentRECO,Ha1.day_recurrent_stdRECO] = AM_dayAVG_recurrent(Ha1.dayRECO,Ha1.daydate);
[Ha1.day_recurrentRECOday,Ha1.day_recurrent_stdRECOday] = AM_dayAVG_recurrent(Ha1.dayRECOday,Ha1.daydate);
[Ha1.recurrentRECOday,Ha1.recurrent_stdRECOday] = AM_hourAVG_recurrent(Ha1.RECOday,Ha1.dateloc);
Ha1.day_recurrentRECOdayGoley = sgolayfilt(Ha1.day_recurrentRECOday,polyorder,framesize);
Ha1.dayRECOday_zscore = (Ha1.dayRECOday - Ha1.day_recurrentRECOdayGoley)./Ha1.day_recurrent_stdRECOday;

[Ha1.recurrentNEE,Ha1.recurrent_stdNEE] = AM_hourAVG_recurrent(Ha1.nee,Ha1.dateloc);
[Ha1.day_recurrentNEE,Ha1.day_recurrent_stdNEE] = AM_dayAVG_recurrent(Ha1.dayNEE,Ha1.daydate);
[Ha1.day_recurrentNEEday,Ha1.day_recurrent_stdNEEday] = AM_dayAVG_recurrent(Ha1.dayNEEday,Ha1.daydate);
[Ha1.recurrentNEEday,Ha1.recurrent_stdNEEday] = AM_hourAVG_recurrent(Ha1.NEEday,Ha1.dateloc);
Ha1.day_recurrentNEEdayGoley = sgolayfilt(Ha1.day_recurrentNEEday,polyorder,framesize);
Ha1.day_recurrentNEEGoley = sgolayfilt(Ha1.day_recurrentNEE,polyorder,framesize);
Ha1.dayNEEday_zscore = (Ha1.dayNEEday - Ha1.day_recurrentNEEdayGoley)./Ha1.day_recurrent_stdNEEday;

%..........................................................................
%% PET
%..........................................................................
% no ground heat flux, originally (Ha1.netrad - Ha1.G)
Ha1.PET = (0.408 .*Ha1.delta .* Ha1.netrad + Ha1.sigma .* (900 ./ (Ha1.tair + 273)) .* Ha1.ws .* (Ha1.e_sat - Ha1.e)) ./....
    (Ha1.delta + Ha1.sigma .* (1 + 0.34 * Ha1.ws));
Ha1.PET = Ha1.PET.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
Ha1.PET(Ha1.PET<0.2) = NaN;   Ha1.PET(isinf(Ha1.PET)) = NaN;

Ha1.ETday = Ha1.ET;                Ha1.ETday(Ha1.So<tresholdSo) = NaN;
Ha1.PETday = Ha1.PET;              Ha1.PETday(Ha1.So<tresholdSo) = NaN;
% Ha1.tairday = Ha1.tair;            Ha1.tairday(Ha1.So<tresholdSo) = NaN;
Ha1.netradday = Ha1.netrad;        Ha1.netradday(Ha1.So<tresholdSo) = NaN;

% [Ha1.daytairday,~,ix,~,~,Ha1.daytairdaymin,Ha1.daytairdaymax]   = AM_day(Ha1.tairday,Ha1.dateloc,0);
% Ha1.daytairday(ix<6) = NaN;         Ha1.daytairdaymin(ix<6) = NaN;        Ha1.daytairdaymax(ix<6) = NaN;
[Ha1.dayETday,~,ix,~,~,Ha1.dayETdaymin,Ha1.dayETdaymax]   = AM_day(Ha1.ETday,Ha1.dateloc,0);
Ha1.dayETday(ix<6) = NaN;         Ha1.dayETdaymin(ix<6) = NaN;        Ha1.dayETdaymax(ix<6) = NaN;
[Ha1.day_recurrentETday,Ha1.day_recurrent_stdETday] = AM_dayAVG_recurrent(Ha1.dayETday,Ha1.daydate);
[Ha1.dayPETday,~,ix,~,~,Ha1.dayPETdaymin,Ha1.dayPETdaymax]   = AM_day(Ha1.PETday,Ha1.dateloc,0);
Ha1.dayPETday(ix<6) = NaN;         Ha1.dayPETdaymin(ix<6) = NaN;        Ha1.dayPETdaymax(ix<6) = NaN;
[Ha1.day_recurrentPETday,Ha1.day_recurrent_stdPETday] = AM_dayAVG_recurrent(Ha1.dayPETday,Ha1.daydate);

%% .........................................................................................................
figure('color','white');
plot(EVI.dateloc,scaled250m16daysEVI.VarName6); hold on
scaled250m16daysEVI.VarName6(scaled250m16daysEVI.VarName6<0.0) = NaN;
Ha1.dayEVI = interp1(EVI.dateloc,scaled250m16daysEVI.VarName6,Ha1.daydate);
Ha1.dayEVI(Ha1.daytairdaymin<0) = NaN;
plot(Ha1.daydate,Ha1.dayEVI,'.')

Ha1.eightEVI = interp1(EVI.dateloc,scaled250m16daysEVI.VarName6,Ha1.eight);
Ha1.weekEVI = interp1(EVI.dateloc,scaled250m16daysEVI.VarName6,Ha1.week);
[Ha1.day_recurrentEVI,Ha1.day_recurrent_stdEVI] = AM_dayAVG_recurrent(Ha1.dayEVI,Ha1.daydate);

% .........................................................................................................
%% ROI 
% .........................................................................................................
figure('color','white');
plot(ROI.daydate,ROI.gcc_mean); hold on
% ROI.gcc(ROI.gcc<0.0) = NaN;
% plot(ROI.daydate,ROI.gcc_50);      % plot(ROI.daydate,ROI.gcc_75);
Ha1.ROIgcc = interp1(ROI.daydate,ROI.gcc_mean,Ha1.daydate);
% Ha1.ROIgcc((Ha1.So<tresholdSo)|(Ha1.ROIgcc<0.36)) = NaN;
% plot(Ha1.dateloc,Ha1.ROIgcc,'.')
[Ha1.weekROIgcc,~,~,~,Ha1.weekROIgccmin,Ha1.weekROIgccmax,Ha1.weekROIgccstd,Ha1.weekROI] = AM_week2day_rs(Ha1.ROIgcc,Ha1.daydate);
[Ha1.eightROIgcc,~,~,~,Ha1.eightROIgccmin,Ha1.eightROIgccmax,Ha1.eightROIgccstd,Ha1.eightROI] = AM_eightday_rs(Ha1.ROIgcc,Ha1.daydate);
[Ha1.day_recurrentROIgcc,Ha1.day_recurrent_stdROIgcc] = AM_dayAVG_recurrent(Ha1.ROIgcc,Ha1.daydate);

%%
figure('color','white');
plot(ROI.daydate,ROI.rcc_mean); hold on
% plot(ROI.daydate,ROI.rcc_50);       plot(ROI.daydate,ROI.rcc_75);
Ha1.ROIrcc = interp1(ROI.daydate,ROI.rcc_mean,Ha1.daydate);
[Ha1.weekROIrcc,~,~,~,Ha1.weekROIrccmin,Ha1.weekROIrccmax,Ha1.weekROIrccstd,Ha1.weekROI] = AM_week2day_rs(Ha1.ROIrcc,Ha1.daydate);
[Ha1.eightROIrcc,~,~,~,Ha1.eightROIrccmin,Ha1.eightROIrccmax,Ha1.eightROIrccstd,Ha1.eightROI] = AM_eightday_rs(Ha1.ROIrcc,Ha1.daydate);
[Ha1.day_recurrentROIrcc,Ha1.day_recurrent_stdROIrcc] = AM_dayAVG_recurrent(Ha1.ROIrcc,Ha1.daydate);

%%
Ha1.ROIGRRI = interp1(ROI.daydate,ROI.GRRI_mean,Ha1.daydate);
[Ha1.weekROIGRRI,~,~,~,Ha1.weekROIGRRImin,Ha1.weekROIGRRImax,Ha1.weekROIGRRIstd,Ha1.weekROI] = AM_week2day_rs(Ha1.ROIGRRI,Ha1.daydate);
[Ha1.eightROIGRRI,~,~,~,Ha1.eightROIGRRImin,Ha1.eightROIGRRImax,Ha1.eightROIGRRIstd,Ha1.eightROI] = AM_eightday_rs(Ha1.ROIGRRI,Ha1.daydate);
[Ha1.day_recurrentROIGRRI,Ha1.day_recurrent_stdROIGRRI] = AM_dayAVG_recurrent(Ha1.ROIGRRI,Ha1.daydate);

Ha1.ROIGRIVI = interp1(ROI.daydate,ROI.GRIVI_mean,Ha1.daydate);
[Ha1.weekROIGRIVI,~,~,~,Ha1.weekROIGRIVImin,Ha1.weekROIGRIVImax,Ha1.weekROIGRIVIstd,Ha1.weekROI] = AM_week2day_rs(Ha1.ROIGRIVI,Ha1.daydate);
[Ha1.eightROIGRIVI,~,~,~,Ha1.eightROIGRIVImin,Ha1.eightROIGRIVImax,Ha1.eightROIGRIVIstd,Ha1.eightROI] = AM_eightday_rs(Ha1.ROIGRIVI,Ha1.daydate);
[Ha1.day_recurrentROIGRIVI,Ha1.day_recurrent_stdROIGRIVI] = AM_dayAVG_recurrent(Ha1.ROIGRIVI,Ha1.daydate);

Ha1.ROIexgreen = interp1(ROI.daydate,ROI.exgreen_mean,Ha1.daydate);
[Ha1.weekROIexgreen,~,~,~,Ha1.weekROIexgreenmin,Ha1.weekROIexgreenmax,Ha1.weekROIexgreenstd,Ha1.weekROI] = AM_week2day_rs(Ha1.ROIexgreen,Ha1.daydate);
[Ha1.eightROIexgreen,~,~,~,Ha1.eightROIexgreenmin,Ha1.eightROIexgreenmax,Ha1.eightROIexgreenstd,Ha1.eightROI] = AM_eightday_rs(Ha1.ROIexgreen,Ha1.daydate);
[Ha1.day_recurrentROIexgreen,Ha1.day_recurrent_stdROIexgreen] = AM_dayAVG_recurrent(Ha1.ROIexgreen,Ha1.daydate);

Ha1.ROIcci = interp1(ROI.daydate,ROI.cci_mean,Ha1.daydate);
[Ha1.weekROIcci,~,~,~,Ha1.weekROIccimin,Ha1.weekROIccimax,Ha1.weekROIccistd,Ha1.weekROI] = AM_week2day_rs(Ha1.ROIcci,Ha1.daydate);
[Ha1.eightROIcci,~,~,~,Ha1.eightROIccimin,Ha1.eightROIccimax,Ha1.eightROIccistd,Ha1.eightROI] = AM_eightday_rs(Ha1.ROIcci,Ha1.daydate);
[Ha1.day_recurrentROIcci,Ha1.day_recurrent_stdROIcci] = AM_dayAVG_recurrent(Ha1.ROIcci,Ha1.daydate);

%%
figure('color','white');
plot(LAIsite.daydate,LAIsite.all_mean); hold on

LAIsite.all_mean(LAIsite.all_mean<0.0) = NaN;
Ha1.dayLAI = interp1(LAIsite.daydate,LAIsite.all_mean,Ha1.daydate);
% Ha1.LAI((Ha1.So<tresholdSo)|(Ha1.LAI<0.36)) = NaN;
plot(Ha1.daydate,Ha1.dayLAI)

[Ha1.dayLAIavg,~,~,~,~,Ha1.dayLAImin,Ha1.dayLAI]   = AM_day(Ha1.dayLAI,Ha1.daydate,0);
[Ha1.day_recurrentLAI,Ha1.day_recurrent_stdLAI] = AM_dayAVG_recurrent(Ha1.dayLAI,Ha1.daydate);
plot(Ha1.daydate,Ha1.day_recurrentLAI,'.')

Ha1.dayLAIfill = Ha1.dayLAI;      Ha1.dayLAIfill(isnan(Ha1.dayLAI)) = Ha1.day_recurrentLAI(isnan(Ha1.dayLAI));
Ha1.LAI = interp1(Ha1.daydate,Ha1.dayLAI,Ha1.dateloc);
[Ha1.weekLAI,~,~,~,~,Ha1.week_stdLAI]  = AM_week2cycle_rs(Ha1.LAI,Ha1.dateloc,tresholdCycleDay,4,2);
[Ha1.week_avgLAI,~,Ha1.week_avgstdLAI] = AM_week2_avg(Ha1.weekLAI,Ha1.week);

% .............................................
%% Extreme evaporation events
% .............................................
% Remove seasonality
% Seasonal Differencing (assuming yearly seasonality, s = 365)
if flag_ExtreameET==1
    Ha1.LEdryday = Ha1.LEdry;             Ha1.LEdryday(Ha1.So<tresholdSo) = NaN;
    [Ha1.dayLEdryday,~,ix,~,~,Ha1.dayLEdrydaymin,Ha1.dayLEdrydaymax] = AM_day(Ha1.LEdryday,Ha1.dateloc,0);
    Ha1.dayLEdryday(ix<6) = NaN;           Ha1.dayLEdrydaymin(ix<6) = NaN;        Ha1.dayLEdrydaymax(ix<6) = NaN;
    [Ha1.day_recurrentLEdryday,Ha1.day_recurrent_stdLEdryday] = AM_dayAVG_recurrent(Ha1.dayLEdryday,Ha1.daydate);

    Ha1.day_recurrentLEdayGoley = sgolayfilt(Ha1.day_recurrentLEday,polyorder,framesize);
    Ha1.day_recurrentLEdrydayGoley = sgolayfilt(Ha1.day_recurrentLEdryday,polyorder,framesize);
    Ha1.JDday = day(Ha1.daydate,'dayofyear');
    % Ha1.dayLEdryday_deseasoned = Ha1.dayLEdryday - Ha1.day_recurrentLEdryday(Ha1.JDday);
    % Ha1.dayLEday_deseasoned = (Ha1.dayLEday - Ha1.day_recurrentLEdayGoley(Ha1.JDday));
    Ha1.dayLEday_zscore = (Ha1.dayLEday - Ha1.day_recurrentLEdayGoley)./Ha1.day_recurrent_stdLEday;
    Ha1.dayLEdryday_zscore = (Ha1.dayLEdryday - Ha1.day_recurrentLEdrydayGoley)./Ha1.day_recurrent_stdLEdryday;

    figure('color','white','Position',[50 50 1800 400]);    hold on;
    plot(Ha1.daydate,Ha1.dayLEday);  plot(Ha1.daydate,Ha1.dayLEdryday);
    legend('days without rain in the previous 12 hours','dry days'); legend box off;
    ylabel('LE_{daytime}(W m^-^2)'); box on;
    figure('color','white');         plot(Ha1.daydate,Ha1.dayLEday_zscore);   hold on;
    plot(Ha1.daydate, Ha1.dayLEdryday_zscore);

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
    Ha1.dayLEdayARIMAzvalue = NaN(length(Ha1.daydate),1);                     Ha1.dayLEdayARIMAzvalueResidual = NaN(length(Ha1.daydate),1);
    Ha1.dayLEdayARIMAzvalueconstant = NaN(length(Ha1.daydate),1);       Ha1.dayLEdayARIMAzvalueSE = NaN(length(Ha1.daydate),1);

    Ha1.dayLEdrydayARIMAzscore = NaN(length(Ha1.daydate),1);                Ha1.dayLEdrydayARIMAzvalueResidual = NaN(length(Ha1.daydate),1);
    Ha1.dayLEdrydayARIMAzscoreconstant = NaN(length(Ha1.daydate),1);  Ha1.dayLEdrydayARIMAzvalueSE = NaN(length(Ha1.daydate),1);

    jet_color = gray(366);
    Mdl = arima(1,0,0); % AR(1) model

    ind = find(Ha1.dayY>1900);  % all data
    Y = Ha1.dayLEday_zscore(ind);       Z = Ha1.dayLEdryday_zscore(ind);
    im = 10;
    % ARIMAtimeMTX = NaN(366,im);
    figure('color','white');
    for ik = im+1:length(Y)-im
        ix = Y(ik-im:ik+im);               W = Z(ik-im:ik+im);
        % Create and estimate the AR(1) model
        if (length(ix(~isnan(ix)))>3)&(~isnan(Y(ik)))
            EstMdl = estimate(Mdl,ix); % Estimate using the first 9 days
            Ha1.dayLEdayARIMAzvalue(ik) = EstMdl.AR{1};
            Ha1.dayLEdayARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', ix);
            Ha1.dayLEdayARIMAzvalue(ik) = YF(1);
            Ha1.dayLEdayARIMAzvaluelSE(ik) = YMSE(1);
            Ha1.dayLEdayARIMAzvalueResidual(ik) = YF(1)-ix(im);
        end
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            EstMdl = estimate(Mdl, W); % Estimate using the first 9 days
            Ha1.dayLEdrydayARIMAzvalue(ik) = EstMdl.AR{1};
            Ha1.dayLEdrydayARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', W);
            Ha1.dayLEdrydayARIMAzvalue(ik) = YF(1);
            Ha1.dayLEdrydayARIMAzvalueSE(ik) = YMSE(1);
            Ha1.dayLEdrydayARIMAzvalueResidual(ik) = YF(1)-W(im);

            % check
            % ARIMAtime = NaN(im,1);    ix = (1:im)';
            % for ij = 1:im-1
            %     Xtmp = ix(im-ij:im);
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
    % plot(ix,smoothdata(fliplr(iz),"movmean",5),'-k','lineWidth',2); hold on;
    % xlim([0 20]);
    % ylabel('AR{1}'); xlabel('number of days before'); grid on;   box on;

    % % Calculate the residuals as the difference between the observed data and the fitted values.

    %% Extreame value theory
    ind = find(Ha1.daytairday<tresholdtair);
    Ha1.dayLEdayGrowth = Ha1.dayLEday;     Ha1.dayLEdayGrowth(ind) = NaN;
    Ha1.dayLEdayARIMAzvalueResidualGrowth = Ha1.dayLEdayARIMAzvalueResidual;
    Ha1.dayLEdayARIMAzvalueResidualGrowth(ind) = NaN;
    Ha1.dayLEdayARIMAzvalueResidualGrowth(Ha1.dayLEdayARIMAzvalueResidualGrowth<0) = NaN;
    figure('color','white');
    histogram(Ha1.dayLEdayARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{growth season}')
    ix = Ha1.dayLEdayARIMAzvalueResidualGrowth;
    % Set a high threshold (you'll need to choose this carefully)
    thresholdARIMAzvalue = quantile(ix, 0.95); % Example: 95th percentile

    % Find exceedances
    exceedancesARIMAzvalue = ix(ix > thresholdARIMAzvalue) - thresholdARIMAzvalue;

    % Fit a Generalized Pareto Distribution (GPD)
    % You'll need the Statistics and Machine Learning Toolbox for this
    pd = fitdist(exceedancesARIMAzvalue, 'GeneralizedPareto');

    % Analyze the fitted GPD
    % pd.k (shape parameter), pd.sigma (scale parameter), pd.theta (location parameter)
    % Use these parameters to estimate probabilities of extreme events

    % Example: Probability of exceeding an even higher level
    higher_levelARIMAzvalue = thresholdARIMAzvalue + 2 * std(ix,'omitnan'); % Example: two standard deviations above threshold
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
    ind = find(Ha1.daytairday<tresholdtair);
    Ha1.dayLEdrydayARIMAzvalueResidualGrowth = Ha1.dayLEdrydayARIMAzvalueResidual;
    Ha1.dayLEdrydayARIMAzvalueResidualGrowth(ind) = NaN;
    Ha1.dayLEdrydayARIMAzvalueResidualGrowth(Ha1.dayLEdrydayARIMAzvalueResidualGrowth<0) = NaN;
    figure('color','white');
    histogram(Ha1.dayLEdrydayARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{z-value growth season}')
    ix = Ha1.dayLEdrydayARIMAzvalueResidualGrowth;
    thresholdARIMAdryzvalue = quantile(ix, 0.95); % Example: 95th percentile
    exceedancesARIMAdryzvalue = ix(ix > thresholdARIMAdryzvalue) - thresholdARIMAdryzvalue;
    pd = fitdist(exceedancesARIMAdryzvalue, 'GeneralizedPareto');
    higher_levelARIMAdryzvalue = thresholdARIMAdryzvalue + 2 * std(ix,'omitnan'); % Example: two standard deviations above threshold
    prob_exceedingARIMAdryzvalue = 1 - cdf(pd, higher_levelARIMAdryzvalue - thresholdARIMAdryzvalue);
    disp(['Probability of exceeding ' num2str(higher_levelARIMAdryzvalue) ': ' num2str(prob_exceedingARIMAdryzvalue)]);
    figure('color','white');
    histogram(exceedancesARIMAdryzvalue,30, 'Normalization', 'pdf');                            hold on;
    x_gpd = linspace(min(exceedancesARIMAdryzvalue), max(exceedancesARIMAdryzvalue), 100);   plot(x_gpd, pdf(pd, x_gpd), 'r-', 'LineWidth', 2);
    hold off;  title('Exceedances and GPD Fit');        xlabel('Exceedance Value');          ylabel('Probability Density ARIMA LE_{dry} z-value');
    % legend('Exceedances', 'GPD Fit');

    %% Hurst Exponent
    Ha1.dayLEdayHURSTzvalue    = NaN(length(Ha1.daydate),1);
    Ha1.dayLEdayHURSTdryzvalue = NaN(length(Ha1.daydate),1);
    jet_color = gray(366);
    ind = find(Ha1.dayY>1900);  % all data
    im = 10;
    Y = Ha1.dayLEday_zscore(ind);       Z = Ha1.dayLEdryday_zscore(ind);
    for ik = im+1:length(Y)-im
        ix = Y(ik-im:ik+im);                W = Z(ik-im:ik+im);
        % Create and estimate the AR(1) model
        if (length(ix(~isnan(ix)))>3)&(~isnan(Y(ik)))
            meanValue = mean(ix,'omitnan');
            deviations = ix - meanValue;
            cumulativeDeviations = cumsum(deviations,'omitnan');
            R = max(cumulativeDeviations,[],'omitnan') - min(cumulativeDeviations,[],'omitnan');
            S = std(ix,'omitnan');
            if S == 0  % Handle cases where standard deviation is zero
                H = NaN;
                return;
            end
            RS = R./ S;
            Ha1.dayLEdayHURSTzvalue(ik) = RS;
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
            Ha1.dayLEdayHURSTdryzvalue(ik) = RS;
        end
    end
    % Ha1.dayLEdayHURST(Ha1.dayLEdayHURST<1) = NaN;

    % Plotting the Hurst Exponent over time (optional, but highly recommended)
    % long-term memory and fractal properties of a time series. Here's what the values mean:
    % H < 0.5: The time series is mean-reverting (it tends to revert to a long-term average).
    % H = 0.5: The time series is a random walk (no predictable patterns).
    % H > 0.5: The time series is persistent (it tends to follow trends).
    %%
    figure('color','white');
    plot(Ha1.daydate, Ha1.dayLEdayHURSTzvalue);  hold on
    plot(Ha1.daydate, Ha1.dayLEdayHURSTdryzvalue);
    xlabel('Time (Days)');
    ylabel('Hurst Exponent'); legend('ARIMA z-value','ARIMA LE_{daytime dry}')
    grid on;

    % .............................................
    %% Extreme greenup events
    % .............................................
    ind = find(Ha1.daytairday<tresholdtair);
    Ha1.dayROIgccGrowth = Ha1.ROIgcc;     Ha1.dayROIgccGrowth(ind) = NaN;

    % Remove seasonality
    [Ha1.day_recurrentROIgcc,Ha1.day_recurrent_stdROIgcc] = AM_dayAVG_recurrent(Ha1.ROIgcc,Ha1.daydate);

    polyorder = 2;     % Polynomial order (typically 2 or 3)
    framesize = 3;     % Window size (must be odd)
    Ha1.day_recurrentROIgccGoley = sgolayfilt(Ha1.day_recurrentROIgcc,polyorder,framesize);
    Ha1.dayROIgcc_zscore = (Ha1.ROIgcc - Ha1.day_recurrentROIgccGoley)./Ha1.day_recurrent_stdROIgcc;
    Ha1.dayROIgcc_zscore(isinf(Ha1.dayROIgcc_zscore)) = NaN;
    figure('color','white');                            plot(Ha1.daydate,Ha1.ROIgcc);   hold on;
    plot(Ha1.daydate, Ha1.dayROIgcc_zscore);

    % Fit an AR(1) model using arima function
    Ha1.dayROIgccARIMAzscore = NaN(length(Ha1.daydate),1);          Ha1.dayROIgccARIMAzvalueResidual = NaN(length(Ha1.daydate),1);
    Ha1.dayROIgccARIMAzscoreconstant = NaN(length(Ha1.daydate),1);  Ha1.dayROIgccARIMAzvalueSE = NaN(length(Ha1.daydate),1);
    jet_color = gray(366);
    Mdl = arima(1,0,0); % AR(1) model

    ind = find(Ha1.dayY>1900);  % all data
    Z = Ha1.dayROIgcc_zscore(ind);
    im = 10;
    figure('color','white');
    for ik = im+1:length(Y)-im
        W = Z(ik-im:ik+im);
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            EstMdl = estimate(Mdl, W); % Estimate using the first 9 days
            Ha1.dayROIgccARIMAzvalue(ik) = EstMdl.AR{1};
            Ha1.dayROIgccARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', W);
            Ha1.dayROIgccARIMAzvalue(ik) = YF(1);
            Ha1.dayROIgccARIMAzvalueSE(ik) = YMSE(1);
            Ha1.dayROIgccARIMAzvalueResidual(ik) = YF(1)-W(im);
        end
    end
    % Extreame value theory
    ind = find(Ha1.daytairday<tresholdtair);
    Ha1.dayROIgccARIMAzvalueResidualGrowth = Ha1.dayROIgccARIMAzvalueResidual;
    Ha1.dayROIgccARIMAzvalueResidualGrowth(ind) = NaN;
    figure('color','white');
    histogram(Ha1.dayROIgccARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{z-value growth season}')
    ix = Ha1.dayROIgccARIMAzvalueResidualGrowth;
    thresholdARIMAzvalue = quantile(ix, 0.95); % Example: 95th percentile
    exceedancesARIMAzvalue = ix(ix > thresholdARIMAzvalue) - thresholdARIMAzvalue;
    pd = fitdist(exceedancesARIMAzvalue, 'GeneralizedPareto');
    higher_levelARIMAzvalue = thresholdARIMAzvalue + 2 * std(ix,'omitnan'); % Example: two standard deviations above threshold
    prob_exceedingARIMAzvalue = 1 - cdf(pd, higher_levelARIMAzvalue - thresholdARIMAzvalue);
    disp(['Probability of exceeding ' num2str(higher_levelARIMAzvalue) ': ' num2str(prob_exceedingARIMAzvalue)]);
    figure('color','white');
    histogram(exceedancesARIMAzvalue, 'Normalization', 'pdf'); hold on;
    x_gpd = linspace(min(exceedancesARIMAzvalue,[],'omitnan'), max(exceedancesARIMAzvalue,[],'omitnan'), 100);
    plot(x_gpd, pdf(pd, x_gpd), 'r-', 'LineWidth', 2);    xlabel('Exceedance Value');
    hold off;  title('Exceedances and GPD Fit');          ylabel('Probability Density ARIMA z-value');

    % Hurst Exponent
    Ha1.dayROIgccHURSTzvalue = NaN(length(Ha1.daydate),1);
    jet_color = gray(366);
    ind = find(Ha1.dayY>1900);  % all data
    im = 10;
    Z = Ha1.dayROIgcc_zscore(ind);

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
            Ha1.dayROIgccHURSTzvalue(ik) = RS;
        end
    end

    figure('color','white');
    plot(Ha1.daydate, Ha1.dayROIgccHURSTzvalue);  hold on
    xlabel('Time (Days)');
    ylabel('Hurst Exponent'); legend('ARIMA','ARIMA z-value')
    grid on;

end

%% .........................................................................
ind = find(Ha1.daytairday<tresholdtair);
Ha1.dayGEPdayGrowth = Ha1.dayGEPday;    Ha1.dayGEPdayGrowth(ind) = NaN;
Ha1.dayRECOdayGrowth = Ha1.dayRECOday;  Ha1.dayRECOdayGrowth(ind) = NaN;
Ha1.dayNEEdayGrowth = Ha1.dayNEEday;    Ha1.dayNEEdayGrowth(ind) = NaN;

Ha1.dayGEPgrowth = Ha1.dayGEP;          Ha1.dayGEPgrowth(ind) = NaN;
Ha1.dayRECOgrowth = Ha1.dayRECO;        Ha1.dayRECOgrowth(ind) = NaN;
Ha1.dayNEEgrowth = Ha1.dayNEE;          Ha1.dayNEEgrowth(ind) = NaN;

polyorder = 2;      % Polynomial order (typically 2 or 3)
framesize = 9;      % Window size (must be odd)
Ha1.dayGEPdayGoley = sgolayfilt(Ha1.dayGEPday,polyorder,framesize);
Ha1.dayGEPdayGrowthGoley = sgolayfilt(Ha1.dayGEPdayGrowth,polyorder,framesize);

[Ha1.monthY,Ha1.monthM,Ha1.monthD] = datevec(Ha1.month);
% year_tick = unique(Ha1.monthY);  year_tick = [year_tick;(year_tick(end)+1)];
% all_year_tick = (datetime(year_tick(1:4:end),1,1))';
[Ha1.weekY,Ha1.weekM,Ha1.weekD] = datevec(Ha1.week);
[Ha1.eightY,Ha1.eightM,Ha1.eightD] = datevec(Ha1.eight);

save('Ha1.mat','Ha1');
save('matlabHa1.mat');