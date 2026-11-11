% Calculate seasonal values for ENSO event or other analysis
% Natalia Restrepo-Coupe
% Noisy PAR
% h2o mixing ratio improperly calculated
% u* improperly calculated
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;
FolderCERES = '/media/ncoupe/Backup/Data/Fluxnet/CERES/';
FolderDaymet = '/media/ncoupe/Backup/Data/Fluxnet/daymet/';
flag_ExtreameET = 10;

ix = datetime(0,0,(1:16:365)');    ind = find(ix>=datetime(0,7,1));   week_start_hydro = ind(1);
tresholdSo = 10;                   tresholdCycleDay = 6;              tresholdCycle = 22;
eight_avg  = (1:8:365)';           week_avg = (1:16:365)';

tresholdtair =5;
gC_m2_d1=60.*60.*24.*12.*(10.^-6);

polyorder = 2;      % Polynomial order (typically 2 or 3)
framesize = 3;     % Window size (must be odd)

%..........................................................................
%% Read day SW, tair, from Daymet extracted from google Earth Engine
%  note: tair is midrange temperature (the arithmetic mean of the daily maximum and minimum)
%..........................................................................
opts = delimitedTextImportOptions('NumVariables', 9);
opts.DataLines = [10, Inf];    opts.Delimiter = ',';
opts.VariableNames = ["year", "yday", "dayl_s", "prcp_mm_day", "srad_W_m_2", "swe_kg_m_2", "tmax_degC", "tmin_degC", "vp_Pa"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = 'ignore';    opts.EmptyLineRule = 'read';
% opts = setvaropts(opts, 'year', 'WhitespaceRule', 'preserve', 'EmptyFieldRule', 'auto');
INAdaymet = readtable([FolderDaymet 'INA_11567_lat_39.8273_lon_-86.179_2026-06-02_205619.csv'], opts);

% dateParts = split(INAdaymet.rawDate, '-');
% INAdaymet.daydate = datetime(str2double(dateParts(:,1)), 1, 1) + days(str2double(dateParts(:,3)) - 1);
% INAdaymet.rawDate = [];
% head(INAdaymet)
INAdaymet.daydate = datetime(INAdaymet.year,1,INAdaymet.yday);
clear opts
INAdaymet.dayPARday = INAdaymet.srad_W_m_2.*2;

INa.daySWin    = interp1(INAdaymet.daydate,INAdaymet.srad_W_m_2,INa.daydate);
INa.daytairmax = interp1(INAdaymet.daydate,INAdaymet.tmax_degC,INa.daydate);
INa.daytairmin = interp1(INAdaymet.daydate,INAdaymet.tmin_degC,INa.daydate);
INAdaymet.tairmid = (INAdaymet.tmax_degC+INAdaymet.tmin_degC)./2;
INa.daytairmid = interp1(INAdaymet.daydate,INAdaymet.tairmid,INa.daydate);
% INa.daytairavg = (INa.daytairmax +INa.daytairmin)./2;
INa.dayPARday = INa.daySWin.*2;

% % %% Add Daymet
% % % FolderDaymet = '/media/ncoupe/Backup/Data/Fluxnet/daymet/';
% % opts = delimitedTextImportOptions('NumVariables', 9);
% % opts.DataLines = [10, Inf];    opts.Delimiter = ',';
% % opts.VariableNames = ['year', 'yday', 'dayl_s', 'prcp_mm_day', 'srad_W_m_2', 'swe_kg_m_2', 'tmax_degC', 'tmin_degC', 'vp_Pa'];
% % opts.VariableTypes = ['double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'];
% % opts.ExtraColumnsRule = 'ignore';    opts.EmptyLineRule = 'read';
% % % opts = setvaropts(opts, ['year', 'yday', 'dayl_s', 'prcp_mm_day', 'srad_W_m_2', 'swe_kg_m_2', 'tmax_degC', 'tmin_degC', 'vp_Pa'], 'WhitespaceRule', 'preserve');
% % % opts = setvaropts(opts, ['year', 'yday', 'dayl_s', 'prcp_mm_day', 'srad_W_m_2', 'swe_kg_m_2', 'tmax_degC', 'vp_Pa'], 'EmptyFieldRule', 'auto');
% % daymet = readtable([FolderDaymet 'INA_11567_lat_39.8273_lon_-86.179_2026-06-02_205619.csv'], opts);
% % 
% % daymet.dayPARday = daymet.srad_W_m_2.*2;
% % daymet.daydate   = datetime(daymet.year,1,daymet.yday);
% % daymet.daytairday = (daymet.tmax_degC+daymet.tmin_degC)./2;
% % 
% % clear opts

% .........................................................................
%% CERES Create a structure to store imported netCDF data
% .........................................................................
CERES = struct();
filename = [FolderCERES 'INA_CERES_SYN1deg-Day_Terra-Aqua-NOAA20_Ed4.2_Subset_20000301-20251231.nc'];
fileInfo = ncinfo(filename);
variableNames = {fileInfo.Variables.Name}';
disp('*** Variable Names in CERES NetCDF File   ***');
disp(variableNames);
fprintf('***                                                   ***\n');

CERES.Variables(1).Name = 'time';
ix = ncread(filename, '/time');     %'days since 2000-03-01 00:00:00'
CERES.daydate = datetime(2000,03,01) + days(reshape(ix,[],1));

CERES.Variables(2).Name = 'adj_atmos_sw_up_all_toa_daily';
ix = ncread(filename, '/adj_atmos_sw_up_all_toa_daily');
CERES.SWupTOA = reshape(ix,[],1);

CERES.Variables(3).Name = 'adj_atmos_sw_up_all_surface_daily';
ix = ncread(filename, '/adj_atmos_sw_up_all_surface_daily');
CERES.SWup = reshape(ix,[],1);

CERES.Variables(4).Name = 'adj_atmos_sw_down_all_toa_daily';
ix = ncread(filename, '/adj_atmos_sw_down_all_toa_daily');
CERES.SWdownTOA = reshape(ix,[],1);

CERES.Variables(5).Name = 'adj_atmos_sw_down_all_surface_daily';
ix = ncread(filename, '/adj_atmos_sw_down_all_surface_daily');
CERES.SWdown = reshape(ix,[],1);

CERES.Variables(6).Name = 'adj_atmos_lw_up_all_toa_daily';
ix = ncread(filename, '/adj_atmos_lw_up_all_toa_daily');
CERES.LWupTOA = reshape(ix,[],1);

CERES.Variables(7).Name = 'adj_atmos_lw_up_all_surface_daily';
ix = ncread(filename, '/adj_atmos_lw_up_all_surface_daily');
CERES.LWup = reshape(ix,[],1);

CERES.Variables(8).Name = 'adj_atmos_lw_down_all_toa_daily';
ix = ncread(filename, '/adj_atmos_lw_down_all_toa_daily');
CERES.LWdownTOA = reshape(ix,[],1);

CERES.Variables(9).Name = 'adj_atmos_lw_down_all_surface_daily';
ix = ncread(filename, '/adj_atmos_lw_down_all_surface_daily');
CERES.LWdown = reshape(ix,[],1);

% CERES.Variables(10).Name = 'adj_sfc_sw_direct_all_daily';
% ix = ncread(filename, '/adj_sfc_sw_direct_all_daily');
% CERES.SWdirect = reshape(ix,[],1);
%
% CERES.Variables(11).Name = 'adj_sfc_sw_diff_all_daily';
% ix = ncread(filename, '/adj_sfc_sw_diff_all_daily');
% CERES.SWdiff = reshape(ix,[],1);
%
CERES.Variables(12).Name = 'adj_sfc_par_direct_all_daily';
ix = ncread(filename, '/adj_sfc_par_direct_all_daily');
CERES.PARdirect = reshape(ix,[],1);

CERES.Variables(13).Name = 'adj_sfc_par_diff_all_daily';
ix = ncread(filename, '/adj_sfc_par_diff_all_daily');
CERES.PARdiff = reshape(ix,[],1);

CERES.dayPAR = CERES.PARdiff+CERES.PARdirect;
clear filename

CERES.dayPAR = CERES.dayPAR.*4.75;     % from W m-2 to umol m-2 s-1
CERES.dayJD = day(CERES.daydate,'dayofyear');
[CERES.daySo,~,CERES.daylyDayLength] = AM_solar_rad(CERES.dayJD,(CERES.dayJD.*0)+12,lat,lon);
CERES.dayPARday = CERES.dayPAR.*24./CERES.daylyDayLength;

figure;
plot(CERES.daydate,CERES.dayPARday); hold on;
plot(INAdaymet.daydate,INAdaymet.dayPARday); 
legend('CERES','Daymet')
INa.CERESdayPARday = interp1(CERES.daydate,CERES.dayPARday,INa.daydate);
% % Daytime SW Flux = Daily Average SW Flux\Fraction of Day that is Sunlit

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
INa.e_sat   = 0.1.*(A0+INa.tair.*(A1+INa.tair.*(A2+INa.tair.*(A3+INa.tair.*(A4+INa.tair.*(A5+INa.tair*A6))))));
INa.delta   = 4098*INa.e_sat./((237.3+INa.tair).^2);                % slope of vapor pressure curve, kPa/C

% INa.rho_a = (INa.pambKpa./(0.28705*(INa.tair+273.15))).*(1-(0.378*INa.e_sat.*INa.RH./INa.pambKpa));

% % .........................................................................
INa.lambda = (2.50*10^6)-((2.386*10^3).*(INa.tair));                % 2.45 [MJ kg-1]     % Latent heat of vaporization, 2.45 [MJ kg-1],
INa.lambda = INa.lambda./10^6;
% % INa.delta    =  (4098.*INa.e_sat_fill)./(power((INa.tc_fill+237.3),2)); %[kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% % http://agsys.cra-cin.it/tools/evapotranspiration/help/Slope_of_saturation_vapour_pressure_curve.html
% % INa.delta   =  0.04145.*exp(0.06088.*INa.tc_fill);              % 0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% INa.delta   = 4098*INa.e_sat_fill./((237.3+INa.tc_fill).^2);      % slope of vapor pressure curve, kPa/C
% INa.sigma  = ((Cp.*INa.pambKpa)./(0.622.*INa.lambda));              % sigma psychrometric constant 0.054 [kPa C-1]

% %..........................................................................
% %% Cycles
% %..........................................................................
[INa.cycle_month_LE,INa.cycle_month_countLE,~,INa.cycle_month_stdLE] = ...
    AM_day_cycle_year(INa.LE,INa.dateloc);
% [INa.cycle_month_netrad,INa.cycle_month_countnetrad,~,INa.cycle_month_stdnetrad] = ...
%     AM_day_cycle_year(INa.netrad,INa.dateloc);
[INa.cycle_month_H,INa.cycle_month_countH,~,INa.cycle_month_stdH] = ...
    AM_day_cycle_year(INa.H,INa.dateloc);

%..........................................................................
%% Canopy conductance
%..........................................................................
canopy = tree_height_FN(ip);
z   = height;
d   = 2.*canopy./3;
zo  = 0.123*canopy;
zoh = 0.0123.*canopy;

INa.A = (INa.LE+INa.H);

%         ACHTUNG!!!!!!!!!!!!!
% ik Yebra it apears as INa.ga but looks like INa.ra!!!!!!!!!!!
% INa.ra = (log((height-d)./zo)).*(log((height-d)./zoh))./(k^2.*INa.ws_fill);
% Natalia's original I use both zo and zoh
Ra        = (log((z-d)./zo)).*(log((z-d)./zoh))./(k.^2.*INa.ws);
Ra(INa.So<tresholdSo) = NaN;        Ra = AM_rm_outlier(Ra,5);
INa.Ga        = 1./Ra;              INa.Ga = AM_rm_outlier(INa.Ga,5);
Ra_ustar  = INa.ws./(INa.ustar.^2);
Ra_ustar(INa.So<tresholdSo) = NaN;	Ra_ustar = AM_rm_outlier(Ra_ustar,5);
Ga_ustar  = 1./Ra_ustar;            Ga_ustar = AM_rm_outlier(Ga_ustar,5);

% lambda    =  2.45;                                                                 % [MJ kg-1] FAO latent heat of vaporization of water
INa.lambda = ((2.50*10^6)-((2.386*10^3).*(INa.tair)))./10^6; % 2.45 [MJ kg-1]     % Latent heat of vaporization, 2.45 [MJ kg-1],

INa.ET = INa.LE./INa.lambda;
INa.ET = INa.ET.*60.*60.*24/1000000;      % from s-1 to d-1 and from kg-1 to g-1 (mm)

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
INa.e      = INa.RH.*INa.e_sat./100;

% INa.delta =  (4098.*INa.e_sat_fill)./(power((INa.tc_fill+237.3),2));  %[kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
% http://agsys.cra-cin.it/tools/evapotranspiration/help/Slope_of_saturation_vapour_pressure_curve.html
% INa.delta =  0.04145.*exp(0.06088.*INa.tc_fill);     % 0.3 at 30degC [kPa C-1]	 % Slope of the saturation vapour pressure temperature relationship
INa.delta = 4098*INa.e_sat./((237.3+INa.tair).^2);     % slope of vapor pressure curve, kPa/C

INa.pambKpa = INa.lambda.*0 + 101;
INa.sigma = ((Cp.*INa.pambKpa)./(0.622.*INa.lambda));  % sigma psychrometric constant 0.054 [kPa C-1]
%INa.sigma   = smooth(INa.sigma);
%where epsilon ratio molecular weight of water vapour/dry air  =  0.622
INa.epsilon =  INa.delta./INa.sigma;                   % Unitless ~0.6219

INa.ET = INa.LE./INa.lambda;
INa.ET = INa.ET.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)

INa.Bowen = INa.H./INa.LE;
% ........................................................................
%% day
% ........................................................................
[INa.dayLE,~,x,~,INa.daydate,INa.dayLEmin,INa.dayLEmax]   = AM_day(INa.LE,INa.dateloc,0);
INa.dayLE(x<tresholdCycle) = NaN;         INa.dayLEmin(x<tresholdCycle) = NaN;        INa.dayLEmax(x<tresholdCycle) = NaN;
[INa.dayH,~,x,~,~,INa.dayHmin,INa.dayHmax]   = AM_day(INa.H,INa.dateloc,0);
INa.dayH(x<tresholdCycle) = NaN;         INa.dayHmin(x<tresholdCycle) = NaN;        INa.dayHmax(x<tresholdCycle) = NaN;
% [INa.daynetrad,~,x,~,~,INa.daynetradmin,INa.daynetradmax]   = AM_day(INa.netrad,INa.dateloc,0);
% INa.daynetrad(x<tresholdCycle) = NaN;         INa.daynetradmin(x<tresholdCycle) = NaN;        INa.daynetradmax(x<tresholdCycle) = NaN;
[INa.daytair,~,x,~,~,INa.daytairmin,INa.daytairmax]   = AM_day(INa.tair,INa.dateloc,0);
INa.daytair(x<tresholdCycle) = NaN;         INa.daytairmin(x<tresholdCycle) = NaN;        INa.daytairmax(x<tresholdCycle) = NaN;

[INa.eightH,~,~,~,~,INa.eight_stdH,INa.eight] = AM_eight2cycle_rs(INa.H,INa.dateloc,tresholdCycle,2,3);    INa.eightH = AM_fill(INa.eightH);
INa.eightLE = AM_eight2cycle_rs(INa.LE,INa.dateloc,tresholdCycle,2,3);    INa.eightLE = AM_fill(INa.eightLE);
% INa.eightnetrad = AM_eight2cycle_rs(INa.netrad,INa.dateloc,tresholdCycle,2,3);    INa.eightnetrad = AM_fill(INa.eightnetrad);
INa.eighttair = AM_eight2cycle_rs(INa.tair,INa.dateloc,tresholdCycle,2,3);    INa.eighttair = AM_fill(INa.eighttair);

[INa.weekH,~,~,~,~,INa.week_stdH] = AM_week2cycle_rs(INa.H,INa.dateloc,tresholdCycle,2,3);  INa.weekH  = AM_fill(INa.weekH);
[INa.weekLE,~,~,~,~,INa.week_stdLE] = AM_week2cycle_rs(INa.LE,INa.dateloc,tresholdCycle,2,3);  INa.weekLE  = AM_fill(INa.weekLE);
% [INa.weeknetrad,~,~,~,~,INa.week_stdnetrad] = AM_week2cycle_rs(INa.netrad,INa.dateloc,tresholdCycle,2,3);  INa.weeknetrad  = AM_fill(INa.weeknetrad);
[INa.weektair,~,~,~,~,INa.week_stdtair] = AM_week2cycle_rs(INa.tair,INa.dateloc,tresholdCycle,2,3);  INa.weektair  = AM_fill(INa.weektair);

[INa.monthH,~,~,INa.monthHmin,INa.monthHmax] = AM_month2cycle(INa.H,INa.dateloc,tresholdCycle,2,2);
INa.monthH = AM_fill(INa.monthH);
[INa.monthLE,~,~,INa.monthLEmin,INa.monthLEmax] = AM_month2cycle(INa.LE,INa.dateloc,tresholdCycle,2,2);
INa.monthLE = AM_fill(INa.monthLE);
% [INa.monthnetrad,~,~,INa.monthnetradmin,INa.monthnetradmax] = AM_month2cycle(INa.netrad,INa.dateloc,tresholdCycle,2,2);
% INa.monthnetrad = AM_fill(INa.monthnetrad);
[INa.monthtair,~,~,INa.monthtairmin,INa.monthtairmax] = AM_month2cycle(INa.tair,INa.dateloc,tresholdCycle,2,2);
INa.monthtair = AM_fill(INa.monthtair);

[INa.dayGEP,~,x,~,~,INa.dayGEPmin,INa.dayGEPmax] = AM_day(INa.gep.*gC_m2_d1,INa.dateloc,0);
INa.dayGEP(x<tresholdCycle) = NaN;                 INa.dayGEPmin(x<tresholdCycle) = NaN;
INa.dayGEPmax(x<tresholdCycle) = NaN;
INa.eightGEP = AM_eight2cycle_rs(INa.gep.*gC_m2_d1,INa.dateloc,tresholdCycle,2,3);
INa.eightGEP = AM_fill(INa.eightGEP);
[INa.weekGEP,~,~,~,~,INa.week_stdGEP,INa.week] = AM_week2cycle_rs(INa.gep.*gC_m2_d1,INa.dateloc,tresholdCycle,2,3);
INa.weekGEP  = AM_fill(INa.weekGEP);
[INa.monthGEP,~,~,INa.monthGEPmin,INa.monthGEPmax] = AM_month2cycle(INa.gep.*gC_m2_d1,INa.dateloc,tresholdCycle,2,2);
INa.monthGEP = AM_fill(INa.monthGEP);

[INa.dayRECO,~,x,~,~,INa.dayRECOmin,INa.dayRECOmax] = AM_day(INa.reco.*gC_m2_d1,INa.dateloc,0);
INa.dayRECO(x<tresholdCycle) = NaN;                INa.dayRECOmin(x<tresholdCycle) = NaN;
INa.dayRECOmax(x<tresholdCycle) = NaN;
INa.eightRECO = AM_eight2cycle_rs(INa.reco.*gC_m2_d1,INa.dateloc,tresholdCycle,2,3);
INa.eightRECO = AM_fill(INa.eightRECO);
[INa.weekRECO,~,~,~,~,INa.week_stdRECO,INa.week] = AM_week2cycle_rs(INa.reco.*gC_m2_d1,INa.dateloc,tresholdCycle,2,3);
INa.weekRECO  = AM_fill(INa.weekRECO);
[INa.monthRECO,~,~,INa.monthRECOmin,INa.monthRECOmax] = AM_month2cycle(INa.reco.*gC_m2_d1,INa.dateloc,tresholdCycle,2,2);
INa.monthRECO = AM_fill(INa.monthRECO);

[INa.dayNEE,~,x,~,~,INa.dayNEEmin,INa.dayNEEmax] = AM_day(INa.nee.*gC_m2_d1,INa.dateloc,0);
INa.dayNEE(x<tresholdCycle) = NaN;                                  INa.dayNEEmin(x<tresholdCycle) = NaN;
INa.dayNEEmax(x<tresholdCycle) = NaN;
INa.eightNEE = AM_eight2cycle_rs(INa.nee.*gC_m2_d1,INa.dateloc,tresholdCycle,2,3);
INa.eightNEE = AM_fill(INa.eightNEE);
[INa.weekNEE,~,~,~,~,INa.week_stdNEE,INa.week] = AM_week2cycle_rs(INa.nee.*gC_m2_d1,INa.dateloc,tresholdCycle,2,3);
INa.weekNEE  = AM_fill(INa.weekNEE);
[INa.monthNEE,~,~,INa.monthNEEmin,INa.monthNEEmax] = AM_month2cycle(INa.nee.*gC_m2_d1,INa.dateloc,tresholdCycle,2,2);
INa.monthNEE = AM_fill(INa.monthNEE);

%% ...........................................
INa.LEday = INa.LE;             INa.LEday(INa.So<tresholdSo) = NaN;
INa.Hday = INa.H;               INa.Hday(INa.So<tresholdSo) = NaN;
% INa.netradday = INa.netrad;     INa.netradday(INa.So<tresholdSo) = NaN;
INa.tairday = INa.tair;         INa.tairday(INa.So<tresholdSo) = NaN;
INa.ustarday = INa.ustar;     INa.ustarday(INa.So<tresholdSo);
INa.EF = AM_fill(INa.LE./(INa.LE+INa.H));
INa.EFday = AM_fill(INa.LE./(INa.LE+INa.H));         INa.EFday(INa.So<tresholdSo) = NaN;
INa.EFday((INa.EFday<0)|(INa.EFday>1)) = NaN;   INa.EFday = AM_rm_outlier(INa.EFday,3);
INa.Bowenday = INa.Bowen;     INa.Bowenday(INa.So<tresholdSo);

[INa.dayLEday,~,x,~,~,INa.dayLEdaymin,INa.dayLEdaymax] = AM_day(INa.LEday,INa.dateloc,0);
INa.dayLEday(x<tresholdCycleDay) = NaN;        INa.dayLEdaymin(x<tresholdCycleDay) = NaN;      INa.dayLEdaymax(x<tresholdCycleDay) = NaN;
[INa.dayHday,~,x,~,~,INa.dayHdaymin,INa.dayHdaymax] = AM_day(INa.H,INa.dateloc,0);
INa.dayHday(x<tresholdCycleDay) = NaN;         INa.dayHdaymin(x<tresholdCycleDay) = NaN;          INa.dayHdaymax(x<tresholdCycleDay) = NaN;
% [INa.daynetradday,~,x,~,~,INa.daynetraddaymin,INa.daynetraddaymax] = AM_day(INa.netradday,INa.dateloc,0);
% INa.daynetradday(x<tresholdCycleDay) = NaN;    INa.daynetraddaymin(x<tresholdCycleDay) = NaN; INa.daynetraddaymax(x<tresholdCycleDay) = NaN;
[INa.daytairday,~,x,~,~,INa.daytairdaymin,INa.daytairdaymax] = AM_day(INa.tairday,INa.dateloc,0);
INa.daytairday(x<tresholdCycleDay) = NaN;      INa.daytairdaymin(x<tresholdCycleDay) = NaN;         INa.daytairdaymax(x<tresholdCycleDay) = NaN;

[INa.eightHday,~,~,~,~,INa.eight_stdHday,INa.eight] = AM_eight2cycle_rs(INa.Hday,INa.dateloc,tresholdCycleDay,2,3);    INa.eightHday = AM_fill(INa.eightHday);
INa.eightLEday = AM_eight2cycle_rs(INa.LEday,INa.dateloc,tresholdCycleDay,2,3);   INa.eightLEday = AM_fill(INa.eightLEday);
% INa.eightnetradday = AM_eight2cycle_rs(INa.netradday,INa.dateloc,tresholdCycleDay,2,3); INa.eightnetradday = AM_fill(INa.eightnetradday);
INa.eighttairday = AM_eight2cycle_rs(INa.tairday,INa.dateloc,tresholdCycleDay,2,3);     INa.eighttairday = AM_fill(INa.eighttairday);

[INa.weekHday,~,~,~,~,INa.week_stdHday,INa.week] = AM_week2cycle_rs(INa.Hday,INa.dateloc,tresholdCycleDay,2,3);        INa.weekHday  = AM_fill(INa.weekHday);
[INa.weekLEday,~,~,~,~,INa.week_stdLEday] = AM_week2cycle_rs(INa.LEday,INa.dateloc,tresholdCycleDay,2,3);                   INa.weekLEday = AM_fill(INa.weekLEday);
% [INa.weeknetradday,~,~,~,~,INa.week_stdnetradday] = AM_week2cycle_rs(INa.netradday,INa.dateloc,tresholdCycleDay,2,3);  INa.weeknetradday  = AM_fill(INa.weeknetradday);
[INa.weektairday,~,~,~,~,INa.week_stdtairday] = AM_week2cycle_rs(INa.tairday,INa.dateloc,tresholdCycleDay,2,3);                 INa.weektairday = AM_fill(INa.weektairday);
[INa.weekustarday,~,~,~,~,INa.week_stdustarday] = AM_week2cycle_rs(INa.ustarday,INa.dateloc,tresholdCycleDay,2,3);        INa.weekustarday = AM_fill(INa.weekustarday);
[INa.weekBowen,~,~,~,~,INa.week_stdBowen] = AM_week2cycle_rs(INa.Bowen,INa.dateloc,tresholdCycleDay,2,3);                INa.weekBowen = AM_fill(INa.weekBowen);
[INa.weekEF,~,~,~,~,INa.week_stdEF] = AM_week2cycle_rs(INa.EF,INa.dateloc,tresholdCycleDay,2,3); INa.weekEF = AM_fill(INa.weekEF);
[INa.weekET,~,~,~,~,INa.week_stdET] = AM_week2cycle_rs(INa.ET,INa.dateloc,tresholdCycleDay,2,3); INa.weekET = AM_fill(INa.weekET);
% [INa.weekETdry,~,~,~,~,INa.week_stdETdry] = AM_week2cycle_rs(INa.ETdry,INa.dateloc,tresholdCycleDay,2,3);                     INa.weekETdry = AM_fill(INa.weekETdry);
% [INa.weekETdryday,~,~,~,~,INa.week_stdETdryday] = AM_week2cycle_rs(INa.ETdryday,INa.dateloc,tresholdCycleDay,2,3);    INa.weekETdryday = AM_fill(INa.weekETdryday);
% [INa.weekGsPMmmol,~,~,~,~,INa.week_stdGsPMmmol] = AM_week2cycle_rs(INa.GsPMmmol,INa.dateloc,tresholdCycleDay,2,3); INa.weekGsPMmmol = AM_fill(INa.weekGsPMmmol);
% [INa.weekLEdry,~,~,~,~,INa.week_stdLEdry] = AM_week2cycle_rs(INa.LEdry,INa.dateloc,tresholdCycleDay,2,3);    INa.weekLEdry = AM_fill(INa.weekLEdry);
[INa.weekEFday,~,~,~,~,INa.week_stdEFday] = AM_week2cycle_rs(INa.EFday,INa.dateloc,tresholdCycleDay,2,3); INa.weekEFday = AM_fill(INa.weekEFday);
[INa.weekBowenday,~,~,~,~,INa.week_stdBowenday] = AM_week2cycle_rs(INa.Bowenday,INa.dateloc,tresholdCycleDay,2,3); INa.weekBowenday = AM_fill(INa.weekBowenday);

INa.GEPday = AM_fill(INa.gep);                  INa.GEPday(INa.So<tresholdSo) = NaN;
[INa.dayGEPday,~,x,~,~,INa.dayGEPdaymin,INa.dayGEPdaymax] = AM_day(INa.GEPday,INa.dateloc,0);
INa.dayGEPday(x<tresholdCycleDay) = NaN;        INa.dayGEPdaymin(x<tresholdCycleDay) = NaN;      INa.dayGEPdaymax(x<tresholdCycleDay) = NaN;
INa.dayGEPday((INa.daydate==datetime(2018,12,18))|(INa.daydate==datetime(2019,3,19)))=NaN;
INa.dayGEPday((INa.daydate>datetime(2017,10,20))&(INa.daydate<datetime(2017,11,5)))=NaN;
INa.dayGEPday(INa.daydate==datetime(2019,3,29))=NaN;
INa.dayGEPday = AM_fill_plus(INa.dayGEPday);

% INa.dayGEPday01093 = INa.dayGEPday;
% INa.dayGEPday01293 = INa.dayGEPday;
% INa.dayGEPday00893 = INa.dayGEPday;
% figure
% plot(INa.daydate,INa.dayGEPday01093);  hold on;   plot(INa.daydate,INa.dayGEPday01293);
% plot(INa.daydate,INa.dayGEPday00893);

INa.eightGEPday = AM_eight2cycle_rs(INa.GEPday,INa.dateloc,tresholdCycleDay,2,3);   INa.eightGEPday = AM_fill(INa.eightGEPday);
[INa.weekGEPday,~,~,~,~,INa.week_stdGEPday] = AM_week2cycle_rs(INa.GEPday,INa.dateloc,tresholdCycleDay,2,3);       INa.weekGEPday  = AM_fill(INa.weekGEPday);
[INa.monthGEPday,~,~,~,~,INa.month_stdGEPday] = AM_month2cycle(INa.GEPday,INa.dateloc,tresholdCycleDay,2,3);       INa.monthGEPday  = AM_fill(INa.monthGEPday);

INa.RECOday = AM_fill(INa.reco);        INa.RECOday(INa.So<tresholdSo) = NaN;
[INa.dayRECOday,~,x,~,~,INa.dayRECOdaymin,INa.dayRECOdaymax] = AM_day(INa.RECOday,INa.dateloc,0);
INa.dayRECOday(x<tresholdCycleDay) = NaN;        INa.dayRECOdaymin(x<tresholdCycleDay) = NaN;      INa.dayRECOdaymax(x<tresholdCycleDay) = NaN;
INa.eightRECOday = AM_eight2cycle_rs(INa.RECOday,INa.dateloc,tresholdCycleDay,2,3);   INa.eightRECOday = AM_fill(INa.eightRECOday);
[INa.weekRECOday,~,~,~,~,INa.week_stdRECOday] = AM_week2cycle_rs(INa.RECOday,INa.dateloc,tresholdCycleDay,2,3);       INa.weekRECOday  = AM_fill(INa.weekRECOday);
[INa.monthRECOday,~,~,~,~,INa.month_stdRECOday] = AM_month2cycle(INa.RECOday,INa.dateloc,tresholdCycleDay,2,3);       INa.monthRECOday  = AM_fill(INa.monthRECOday);

INa.NEEday = AM_fill(INa.nee);        INa.NEEday(INa.So<tresholdSo) = NaN;
[INa.dayNEEday,~,x,~,~,INa.dayNEEdaymin,INa.dayNEEdaymax] = AM_day(INa.NEEday,INa.dateloc,0);
INa.dayNEEday(x<tresholdCycleDay) = NaN;        INa.dayNEEdaymin(x<tresholdCycleDay) = NaN;      INa.dayNEEdaymax(x<tresholdCycleDay) = NaN;
INa.eightNEEday = AM_eight2cycle_rs(INa.NEEday,INa.dateloc,tresholdCycleDay,2,3);   INa.eightNEEday = AM_fill(INa.eightNEEday);
[INa.weekNEEday,~,~,~,~,INa.week_stdNEEday] = AM_week2cycle_rs(INa.NEEday,INa.dateloc,tresholdCycleDay,2,3);       INa.weekNEEday  = AM_fill(INa.weekNEEday);
[INa.monthNEEday,~,~,~,~,INa.month_stdNEEday] = AM_month2cycle(INa.NEEday,INa.dateloc,tresholdCycleDay,2,3);       INa.monthNEEday  = AM_fill(INa.monthNEEday);

%%
% [INa.weekETref,~,~,~,~,INa.week_stdETref] = AM_week2cycle_rs(INa.ETref,INa.dateloc,tresholdCycleDay,2,3);      INa.weekETref = AM_fill(INa.weekETref);
% [INa.weekGsPM,~,~,~,~,INa.week_stdGsPM] = AM_week2cycle_rs(INa.GsPM,INa.dateloc,tresholdCycleDay,2,3);  INa.weekGsPM = AM_fill(INa.weekGsPM);
% [INa.weekGsPMmmol,~,~,~,~,INa.week_stdGsPMmmol] = AM_week2cycle_rs(INa.GsPMmmol,      INa.dateloc,tresholdCycleDay,2,3); INa.weekGsPMmmol = AM_fill(INa.weekGsPMmmol);
% [INa.weekLEdry,~,~,~,~,INa.week_stdLEdry] = AM_week2cycle_rs(INa.LEdry,INa.dateloc,tresholdCycleDay,2,3);    INa.weekLEdry = AM_fill(INa.weekLEdry);
% [INa.weekEFday,~,~,~,~,INa.week_stdEFday] = AM_week2cycle_rs(INa.EFday,INa.dateloc,tresholdCycleDay,2,3); INa.weekEFday = AM_fill(INa.weekEFday);
[INa.weekBowenday,~,~,~,~,INa.week_stdBowenday] = AM_week2cycle_rs(INa.Bowenday,INa.dateloc,tresholdCycleDay,2,3); INa.weekBowenday = AM_fill(INa.weekBowenday);
% [INa.weektairday,~,~,~,~,INa.week_stdtairday] = AM_week2cycle_rs(INa.tairday,INa.dateloc,tresholdCycleDay,2,3); INa.weektairday = AM_fill(INa.weektairday);

[INa.monthHday,~,~,INa.monthHdaymin,INa.monthHdaymax,~,INa.month] = AM_month2cycle(INa.Hday,INa.dateloc,tresholdCycleDay,2,2);
INa.monthHday = AM_fill(INa.monthHday);
[INa.monthLEday,~,~,INa.monthLEdaymin,INa.monthLEdaymax] = AM_month2cycle(INa.LEday,INa.dateloc,tresholdCycleDay,2,2);
INa.monthLEday = AM_fill(INa.monthLEday);
% [INa.monthnetradday,~,~,INa.monthnetraddaymin,INa.monthnetraddaymax] = AM_month2cycle(INa.netradday,INa.dateloc,tresholdCycleDay,2,2);
% INa.monthnetradday = AM_fill(INa.monthnetradday);
[INa.monthtairday,~,~,INa.monthtairdaymin,INa.monthtairdaymax] = AM_month2cycle(INa.tairday,INa.dateloc,tresholdCycleDay,2,2);
INa.monthtairday = AM_fill(INa.monthtairday);

%..........................................................................
%% Seasonality
%..........................................................................
[INa.week_avgHday,~,INa.week_avgstdHday]   = AM_week2_avg(INa.weekHday,INa.week);
[INa.week_avgLEday,~,INa.week_avgstdLEday] = AM_week2_avg(INa.weekLEday,INa.week);
% [INa.week_avgnetradday,~,INa.week_avgstdnetradday] = AM_week2_avg(INa.weeknetradday,INa.week);
[INa.week_avgtairday,~,INa.week_avgstdtairday] = AM_week2_avg(INa.weektairday,INa.week);

[INa.eight_avgLEday,~,INa.eight_stdLEday] = AM_eight_avg(INa.eightLEday,INa.eight);
[INa.eight_avgHday,~,INa.eight_stdHday]   = AM_eight_avg(INa.eightHday,INa.eight);
% [INa.eight_avgnetradday,~,INa.eight_stdnetradday] = AM_eight_avg(INa.eightnetradday,INa.eight);
[INa.eight_avgtairday,~,INa.eight_stdtairday] = AM_eight_avg(INa.eighttairday,INa.eight);

[INa.month_avgLEday,INa.month_avgstdLEday] = AM_month_avg(INa.monthLEday,INa.month);
[INa.month_avgHday,INa.month_avgstdHday]   = AM_month_avg(INa.monthHday,INa.month);
% [INa.month_avgnetradday,INa.month_avgstdnetradday] = AM_month_avg(INa.monthnetradday,INa.month);
[INa.month_avgtairday,INa.month_avgstdtairday] = AM_month_avg(INa.monthtairday,INa.month);

[INa.month_avgGEPday,INa.month_avgstdGEPday] = AM_month_avg(INa.monthGEPday,INa.month);
[INa.week_avgGEPday,~,INa.week_avgstdGEPday] = AM_week2_avg(INa.weekGEPday,INa.week);
[INa.eight_avgGEPday,~,INa.eight_stdGEPday]  = AM_eight_avg(INa.eightGEPday,INa.eight);

[INa.month_avgRECOday,INa.month_avgstdRECOday] = AM_month_avg(INa.monthRECOday,INa.month);
[INa.week_avgRECOday,~,INa.week_avgstdRECOday] = AM_week2_avg(INa.weekRECOday,INa.week);
[INa.eight_avgRECOday,~,INa.eight_stdRECOday]  = AM_eight_avg(INa.eightRECOday,INa.eight);

[INa.month_avgNEEday,INa.month_avgstdNEEday] = AM_month_avg(INa.monthNEEday,INa.month);
[INa.week_avgNEEday,~,INa.week_avgstdNEEday]  = AM_week2_avg(INa.weekNEEday,INa.week);
[INa.eight_avgNEEday,~,INa.eight_stdNEEday]  = AM_eight_avg(INa.eightNEEday,INa.eight);

%..........................................................................
%% Seasonality
%..........................................................................
[INa.week_avgustarday,~,INa.week_avgstdustarday] = AM_week2_avg(INa.weekustarday,INa.week);
[INa.week_avgBowen,~,INa.week_avgstdBowen] = AM_week2_avg(INa.weekBowen,INa.week);
[INa.week_avgEF,~,INa.week_avgstdEF] = AM_week2_avg(INa.weekEF,INa.week);
[INa.week_avgET,~,INa.week_avgstdET] = AM_week2_avg(INa.weekET,INa.week);

INa.eightPARday = AM_eightday_rs(INa.dayPARday,INa.daydate);
INa.weekPARday  = AM_week2day_rs(INa.dayPARday,INa.daydate);
INa.eightSo = AM_eightday_rs(INa.So,INa.dateloc);
INa.weekSo  = AM_week2day_rs(INa.So,INa.daydate);

[INa.week_avgEFday,~,INa.week_avgstdEFday]   = AM_week2_avg(INa.weekEFday,INa.week);
[INa.week_avgBowenday,~,INa.week_avgstdBowenday] = AM_week2_avg(INa.weekBowenday,INa.week);

[INa.recurrentLE,INa.recurrent_stdLE] = AM_hourAVG_recurrent(INa.LE,INa.dateloc);
[INa.recurrentET,INa.recurrent_stdET] = AM_hourAVG_recurrent(INa.ET,INa.dateloc);
[INa.day_recurrentLEday,INa.day_recurrent_stdLEday] = AM_dayAVG_recurrent(INa.dayLEday,INa.daydate);
[INa.recurrentLEday,INa.recurrent_stdLEday] = AM_hourAVG_recurrent(INa.LEday,INa.dateloc);

INa.recurrentH        = AM_hourAVG_recurrent(INa.H,INa.dateloc);
INa.day_recurrentHday = AM_dayAVG_recurrent(INa.dayHday,INa.daydate);

% INa.recurrentnetrad = AM_hourAVG_recurrent(INa.netrad,INa.dateloc);
% INa.day_recurrentnetradday = AM_dayAVG_recurrent(INa.daynetradday,INa.daydate);
INa.day_recurrentSWin = AM_dayAVG_recurrent(INa.daySWin,INa.daydate);
INa.recurrenttair = AM_hourAVG_recurrent(INa.tair,INa.dateloc);
INa.day_recurrenttairday = AM_dayAVG_recurrent(INa.daytairday,INa.daydate);

[INa.dayY,INa.dayM,INa.dayD] = datevec(INa.daydate);

figure
hold on
plot(INa.week,INa.weekSo);
plot(INa.week,INa.weekLEday);
plot(INa.week,INa.weekHday);

[INa.recurrentGEP,INa.recurrent_stdGEP] = AM_hourAVG_recurrent(INa.gep,INa.dateloc);
[INa.day_recurrentGEP,INa.day_recurrent_stdGEP] = AM_dayAVG_recurrent(INa.dayGEP,INa.daydate);
[INa.recurrentGEP,INa.recurrent_stdGEP] = AM_hourAVG_recurrent(INa.gep,INa.dateloc);
INa.day_recurrentGEPGoley = sgolayfilt(INa.day_recurrentGEP,polyorder,framesize);
INa.dayGEP_zscore = (INa.dayGEP - INa.day_recurrentGEPGoley)./INa.day_recurrent_stdGEP;

[INa.day_recurrentGEPday,INa.day_recurrent_stdGEPday] = AM_dayAVG_recurrent(INa.dayGEPday,INa.daydate);
[INa.recurrentGEPday,INa.recurrent_stdGEPday] = AM_hourAVG_recurrent(INa.GEPday,INa.dateloc);
INa.day_recurrentGEPdayGoley = sgolayfilt(INa.day_recurrentGEPday,polyorder,framesize);
INa.dayGEPday_zscore = (INa.dayGEPday - INa.day_recurrentGEPdayGoley)./INa.day_recurrent_stdGEPday;

[INa.recurrentRECO,INa.recurrent_stdRECO] = AM_hourAVG_recurrent(INa.reco,INa.dateloc);
[INa.day_recurrentRECOday,INa.day_recurrent_stdRECOday] = AM_dayAVG_recurrent(INa.dayRECOday,INa.daydate);
[INa.recurrentRECOday,INa.recurrent_stdRECOday] = AM_hourAVG_recurrent(INa.RECOday,INa.dateloc);
INa.day_recurrentRECOdayGoley = sgolayfilt(INa.day_recurrentRECOday,polyorder,framesize);
INa.dayRECOday_zscore = (INa.dayRECOday - INa.day_recurrentRECOdayGoley)./INa.day_recurrent_stdRECOday;

[INa.recurrentNEE,INa.recurrent_stdNEE] = AM_hourAVG_recurrent(INa.nee,INa.dateloc);
[INa.day_recurrentNEEday,INa.day_recurrent_stdNEEday] = AM_dayAVG_recurrent(INa.dayNEEday,INa.daydate);
[INa.recurrentNEEday,INa.recurrent_stdNEEday] = AM_hourAVG_recurrent(INa.NEEday,INa.dateloc);
INa.day_recurrentNEEdayGoley = sgolayfilt(INa.day_recurrentNEEday,polyorder,framesize);
INa.dayNEEday_zscore = (INa.dayNEEday - INa.day_recurrentNEEdayGoley)./INa.day_recurrent_stdNEEday;

%..........................................................................
%% PET
%..........................................................................
% no ground heat flux, originally (INa.netrad - INa.G)
% INa.PET = (0.408 .*INa.delta .* INa.netrad + INa.sigma .* (900 ./ (INa.tair + 273)) .* INa.ws .* (INa.e_sat - INa.e)) ./....
%     (INa.delta + INa.sigma .* (1 + 0.34 * INa.ws));
% INa.PET = INa.PET.*60.*60.*24/1000000;      %from s-1 to d-1 and from kg-1 to g-1 (mm)
% INa.PET(INa.PET<0.2) = NaN;   INa.PET(isinf(INa.PET)) = NaN;
% 
% INa.ETday = INa.ET;               INa.ETday(INa.So<tresholdSo) = NaN;
% INa.PETday = INa.PET;             INa.PETday(INa.So<tresholdSo) = NaN;
INa.tairday = INa.tair;           INa.tairday(INa.So<tresholdSo) = NaN;
% INa.netradday = INa.netrad;       INa.netradday(INa.So<tresholdSo) = NaN;

[INa.daytairday,~,x,~,~,INa.daytairdaymin,INa.daytairdaymax]   = AM_day(INa.tairday,INa.dateloc,0);
INa.daytairday(x<6) = NaN;         INa.daytairdaymin(x<6) = NaN;        INa.daytairdaymax(x<6) = NaN;
% [INa.dayETday,~,x,~,~,INa.dayETdaymin,INa.dayETdaymax]   = AM_day(INa.ETday,INa.dateloc,0);
% INa.dayETday(x<6) = NaN;         INa.dayETdaymin(x<6) = NaN;        INa.dayETdaymax(x<6) = NaN;
% [INa.day_recurrentETday,INa.day_recurrent_stdETday] = AM_dayAVG_recurrent(INa.dayETday,INa.daydate);
% [INa.dayPETday,~,x,~,~,INa.dayPETdaymin,INa.dayPETdaymax]   = AM_day(INa.PETday,INa.dateloc,0);
% INa.dayPETday(x<6) = NaN;         INa.dayPETdaymin(x<6) = NaN;        INa.dayPETdaymax(x<6) = NaN;
% [INa.day_recurrentPETday,INa.day_recurrent_stdPETday] = AM_dayAVG_recurrent(INa.dayPETday,INa.daydate);

%% .........................................................................................................
figure('color','white');
plot(EVI.dateloc,scaled250m16daysEVI.value_center); hold on
scaled250m16daysEVI.value_center(scaled250m16daysEVI.value_center<0.0) = NaN;
INa.dayEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,INa.daydate);
INa.dayEVI(INa.daytairdaymin<0) = NaN;
plot(INa.daydate,INa.dayEVI,'.')

INa.eightEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,INa.eight);
INa.weekEVI = interp1(EVI.dateloc,scaled250m16daysEVI.value_center,INa.week);
[INa.day_recurrentEVI,INa.day_recurrent_stdEVI] = AM_dayAVG_recurrent(INa.dayEVI,INa.daydate);

%% .........................................................................................................
figure('color','white');
plot(ROI.daydate,ROI.gcc_mean); hold on;  legend('GCC');
% ROI.gcc(ROI.gcc<0.0) = NaN;
% plot(ROI.daydate,ROI.gcc_50);       plot(ROI.daydate,ROI.gcc_75);

INa.ROIgcc = interp1(ROI.daydate,ROI.gcc_mean,INa.daydate);
% INa.ROIgcc((INa.So<tresholdSo)|(INa.ROIgcc<0.36)) = NaN;
% plot(INa.dateloc,INa.ROIgcc,'.')

[INa.weekROIgcc,~,~,~,INa.weekROIgccmin,INa.weekROIgccmax,INa.weekROIgccstd,INa.weekROI] = AM_week2day_rs(INa.ROIgcc,INa.daydate);
[INa.eightROIgcc,~,~,~,INa.eightROIgccmin,INa.eightROIgccmax,INa.eightROIgccstd,INa.eightROI] = AM_eightday_rs(INa.ROIgcc,INa.daydate);
[INa.day_recurrentROIgcc,INa.day_recurrent_stdROIgcc] = AM_dayAVG_recurrent(INa.ROIgcc,INa.daydate);

INa.ROIrcc = interp1(ROI.daydate,ROI.rcc_mean,INa.daydate);
[INa.weekROIrcc,~,~,~,INa.weekROIrccmin,INa.weekROIrccmax,INa.weekROIrccstd,INa.weekROI] = AM_week2day_rs(INa.ROIrcc,INa.daydate);
[INa.eightROIrcc,~,~,~,INa.eightROIrccmin,INa.eightROIrccmax,INa.eightROIrccstd,INa.eightROI] = AM_eightday_rs(INa.ROIrcc,INa.daydate);
[INa.day_recurrentROIrcc,INa.day_recurrent_stdROIrcc] = AM_dayAVG_recurrent(INa.ROIrcc,INa.daydate);

%%
figure('color','white');
plot(ROI.daydate,ROI.rcc_mean);       hold on;               ylabel('RCC');
% plot(ROI.daydate,ROI.rcc_50);       plot(ROI.daydate,ROI.rcc_75);
INa.ROIrcc = interp1(ROI.daydate,ROI.rcc_mean,INa.daydate);
[INa.weekROIrcc,~,~,~,INa.weekROIrccmin,INa.weekROIrccmax,INa.weekROIrccstd,INa.weekROI] = AM_week2day_rs(INa.ROIrcc,INa.daydate);
[INa.eightROIrcc,~,~,~,INa.eightROIrccmin,INa.eightROIrccmax,INa.eightROIrccstd,INa.eightROI] = AM_eightday_rs(INa.ROIrcc,INa.daydate);
[INa.day_recurrentROIrcc,INa.day_recurrent_stdROIrcc] = AM_dayAVG_recurrent(INa.ROIrcc,INa.daydate);

%%
INa.ROIGRRI = interp1(ROI.daydate,ROI.GRRI_mean,INa.daydate);
[INa.weekROIGRRI,~,~,~,INa.weekROIGRRImin,INa.weekROIGRRImax,INa.weekROIGRRIstd,INa.weekROI] = AM_week2day_rs(INa.ROIGRRI,INa.daydate);
[INa.eightROIGRRI,~,~,~,INa.eightROIGRRImin,INa.eightROIGRRImax,INa.eightROIGRRIstd,INa.eightROI] = AM_eightday_rs(INa.ROIGRRI,INa.daydate);
[INa.day_recurrentROIGRRI,INa.day_recurrent_stdROIGRRI] = AM_dayAVG_recurrent(INa.ROIGRRI,INa.daydate);

INa.ROIGRIVI = interp1(ROI.daydate,ROI.GRIVI_mean,INa.daydate);
[INa.weekROIGRIVI,~,~,~,INa.weekROIGRIVImin,INa.weekROIGRIVImax,INa.weekROIGRIVIstd,INa.weekROI] = AM_week2day_rs(INa.ROIGRIVI,INa.daydate);
[INa.eightROIGRIVI,~,~,~,INa.eightROIGRIVImin,INa.eightROIGRIVImax,INa.eightROIGRIVIstd,INa.eightROI] = AM_eightday_rs(INa.ROIGRIVI,INa.daydate);
[INa.day_recurrentROIGRIVI,INa.day_recurrent_stdROIGRIVI] = AM_dayAVG_recurrent(INa.ROIGRIVI,INa.daydate);

ROI.exgreen_mean = ((2.*ROI.g_mean)-ROI.r_mean-ROI.b_mean);%./(ROI.g_mean+ROI.r_mean+ROI.b_mean);
INa.ROIexgreen = interp1(ROI.daydate,ROI.exgreen_mean,INa.daydate);
[INa.weekROIexgreen,~,~,~,INa.weekROIexgreenmin,INa.weekROIexgreenmax,INa.weekROIexgreenstd,INa.weekROI] = AM_week2day_rs(INa.ROIexgreen,INa.daydate);
[INa.eightROIexgreen,~,~,~,INa.eightROIexgreenmin,INa.eightROIexgreenmax,INa.eightROIexgreenstd,INa.eightROI] = AM_eightday_rs(INa.ROIexgreen,INa.daydate);
[INa.day_recurrentROIexgreen,INa.day_recurrent_stdROIexgreen] = AM_dayAVG_recurrent(INa.ROIexgreen,INa.daydate);

INa.ROIcci = interp1(ROI.daydate,ROI.cci_mean,INa.daydate);
[INa.weekROIcci,~,~,~,INa.weekROIccimin,INa.weekROIccimax,INa.weekROIccistd,INa.weekROI] = AM_week2day_rs(INa.ROIcci,INa.daydate);
[INa.eightROIcci,~,~,~,INa.eightROIccimin,INa.eightROIccimax,INa.eightROIccistd,INa.eightROI] = AM_eightday_rs(INa.ROIcci,INa.daydate);
[INa.day_recurrentROIcci,INa.day_recurrent_stdROIcci] = AM_dayAVG_recurrent(INa.ROIcci,INa.daydate);

%%
figure('color','white');
plot(LAIsite.daydate,LAIsite.all_mean); hold on

LAIsite.all_mean(LAIsite.all_mean<0.0) = NaN;
INa.dayLAI = interp1(LAIsite.daydate,LAIsite.all_mean,INa.daydate);
% INa.LAI((INa.So<tresholdSo)|(INa.LAI<0.36)) = NaN;
plot(INa.daydate,INa.dayLAI)

[INa.dayLAIavg,~,~,~,~,INa.dayLAImin,INa.dayLAI]   = AM_day(INa.dayLAI,INa.daydate,0);
[INa.day_recurrentLAI,INa.day_recurrent_stdLAI] = AM_dayAVG_recurrent(INa.dayLAI,INa.daydate);
plot(INa.daydate,INa.day_recurrentLAI,'.')

INa.dayLAIfill = INa.dayLAI;      INa.dayLAIfill(isnan(INa.dayLAI)) = INa.day_recurrentLAI(isnan(INa.dayLAI));
INa.LAI = interp1(INa.daydate,INa.dayLAI,INa.dateloc);
[INa.weekLAI,~,~,~,~,INa.week_stdLAI]  = AM_week2cycle_rs(INa.LAI,INa.dateloc,tresholdCycleDay,4,2);
[INa.week_avgLAI,~,INa.week_avgstdLAI] = AM_week2_avg(INa.weekLAI,INa.week);

% .............................................
%% Extreme evaporation events
% .............................................
% Remove seasonality
% Seasonal Differencing (assuming yearly seasonality, s = 365)
if flag_ExtreameET==1
    INa.LEdryday = INa.LEdry;             INa.LEdryday(INa.So<tresholdSo) = NaN;
    [INa.dayLEdryday,~,x,~,~,INa.dayLEdrydaymin,INa.dayLEdrydaymax] = AM_day(INa.LEdryday,INa.dateloc,0);
    INa.dayLEdryday(x<6) = NaN;           INa.dayLEdrydaymin(x<6) = NaN;        INa.dayLEdrydaymax(x<6) = NaN;
    [INa.day_recurrentLEdryday,INa.day_recurrent_stdLEdryday] = AM_dayAVG_recurrent(INa.dayLEdryday,INa.daydate);

    INa.day_recurrentLEdayGoley = sgolayfilt(INa.day_recurrentLEday,polyorder,framesize);
    INa.day_recurrentLEdrydayGoley = sgolayfilt(INa.day_recurrentLEdryday,polyorder,framesize);
    INa.JDday = day(INa.daydate,'dayofyear');
    % INa.dayLEdryday_deseasoned = INa.dayLEdryday - INa.day_recurrentLEdryday(INa.JDday);
    % INa.dayLEday_deseasoned = (INa.dayLEday - INa.day_recurrentLEdayGoley(INa.JDday));
    INa.dayLEday_zscore = (INa.dayLEday - INa.day_recurrentLEdayGoley)./INa.day_recurrent_stdLEday;
    INa.dayLEdryday_zscore = (INa.dayLEdryday - INa.day_recurrentLEdrydayGoley)./INa.day_recurrent_stdLEdryday;

    figure('color','white','Position',[50 50 1800 400]);    hold on;
    plot(INa.daydate,INa.dayLEday);  plot(INa.daydate,INa.dayLEdryday);
    legend('days without rain in the previous 12 hours','dry days'); legend box off;
    ylabel('LE_{daytime}(W m^-^2)'); box on;
    figure('color','white');         plot(INa.daydate,INa.dayLEday_zscore);   hold on;
    plot(INa.daydate, INa.dayLEdryday_zscore);

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
    INa.dayLEdayARIMAzvalue = NaN(length(INa.daydate),1);                     INa.dayLEdayARIMAzvalueResidual = NaN(length(INa.daydate),1);
    INa.dayLEdayARIMAzvalueconstant = NaN(length(INa.daydate),1);       INa.dayLEdayARIMAzvalueSE = NaN(length(INa.daydate),1);

    INa.dayLEdrydayARIMAzscore = NaN(length(INa.daydate),1);                INa.dayLEdrydayARIMAzvalueResidual = NaN(length(INa.daydate),1);
    INa.dayLEdrydayARIMAzscoreconstant = NaN(length(INa.daydate),1);  INa.dayLEdrydayARIMAzvalueSE = NaN(length(INa.daydate),1);

    jet_color = gray(366);
    Mdl = arima(1,0,0); % AR(1) model

    ind = find(INa.dayY>1900);  % all data
    Y = INa.dayLEday_zscore(ind);       Z = INa.dayLEdryday_zscore(ind);
    im = 10;
    % ARIMAtimeMTX = NaN(366,im);
    figure('color','white');
    for ik = im+1:length(Y)-im
        X = Y(ik-im:ik+im);               W = Z(ik-im:ik+im);
        % Create and estimate the AR(1) model
        if (length(X(~isnan(X)))>3)&(~isnan(Y(ik)))
            EstMdl = estimate(Mdl,X); % Estimate using the first 9 days
            INa.dayLEdayARIMAzvalue(ik) = EstMdl.AR{1};
            INa.dayLEdayARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', X);
            INa.dayLEdayARIMAzvalue(ik) = YF(1);
            INa.dayLEdayARIMAzvaluelSE(ik) = YMSE(1);
            INa.dayLEdayARIMAzvalueResidual(ik) = YF(1)-X(im);
        end
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            EstMdl = estimate(Mdl, W); % Estimate using the first 9 days
            INa.dayLEdrydayARIMAzvalue(ik) = EstMdl.AR{1};
            INa.dayLEdrydayARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', W);
            INa.dayLEdrydayARIMAzvalue(ik) = YF(1);
            INa.dayLEdrydayARIMAzvalueSE(ik) = YMSE(1);
            INa.dayLEdrydayARIMAzvalueResidual(ik) = YF(1)-W(im);

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
    ind = find(INa.daytairday<tresholdtair);
    INa.dayLEdayGrowth = INa.dayLEday;     INa.dayLEdayGrowth(ind) = NaN;
    INa.dayLEdayARIMAzvalueResidualGrowth = INa.dayLEdayARIMAzvalueResidual;
    INa.dayLEdayARIMAzvalueResidualGrowth(ind) = NaN;
    INa.dayLEdayARIMAzvalueResidualGrowth(INa.dayLEdayARIMAzvalueResidualGrowth<0) = NaN;
    figure('color','white');
    histogram(INa.dayLEdayARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{growth season}')
    x = INa.dayLEdayARIMAzvalueResidualGrowth;
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
    ind = find(INa.daytairday<tresholdtair);
    INa.dayLEdrydayARIMAzvalueResidualGrowth = INa.dayLEdrydayARIMAzvalueResidual;
    INa.dayLEdrydayARIMAzvalueResidualGrowth(ind) = NaN;
    INa.dayLEdrydayARIMAzvalueResidualGrowth(INa.dayLEdrydayARIMAzvalueResidualGrowth<0) = NaN;
    figure('color','white');
    histogram(INa.dayLEdrydayARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{z-value growth season}')
    x = INa.dayLEdrydayARIMAzvalueResidualGrowth;
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
    INa.dayLEdayHURSTzvalue    = NaN(length(INa.daydate),1);
    INa.dayLEdayHURSTdryzvalue = NaN(length(INa.daydate),1);
    jet_color = gray(366);
    ind = find(INa.dayY>1900);  % all data
    im = 10;
    Y = INa.dayLEday_zscore(ind);       Z = INa.dayLEdryday_zscore(ind);
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
            INa.dayLEdayHURSTzvalue(ik) = RS;
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
            INa.dayLEdayHURSTdryzvalue(ik) = RS;
        end
    end
    % INa.dayLEdayHURST(INa.dayLEdayHURST<1) = NaN;

    % Plotting the Hurst Exponent over time (optional, but highly recommended)
    % long-term memory and fractal properties of a time series. Here's what the values mean:
    % H < 0.5: The time series is mean-reverting (it tends to revert to a long-term average).
    % H = 0.5: The time series is a random walk (no predictable patterns).
    % H > 0.5: The time series is persistent (it tends to follow trends).
    %%
    figure('color','white');
    plot(INa.daydate, INa.dayLEdayHURSTzvalue);  hold on
    plot(INa.daydate, INa.dayLEdayHURSTdryzvalue);
    xlabel('Time (Days)');
    ylabel('Hurst Exponent'); legend('ARIMA z-value','ARIMA LE_{daytime dry}')
    grid on;

    % .............................................
    %% Extreme greenup events
    % .............................................
    ind = find(INa.daytairday<tresholdtair);
    INa.dayROIgccGrowth = INa.ROIgcc;     INa.dayROIgccGrowth(ind) = NaN;

    % Remove seasonality
    [INa.day_recurrentROIgcc,INa.day_recurrent_stdROIgcc] = AM_dayAVG_recurrent(INa.ROIgcc,INa.daydate);

    polyorder = 2;     % Polynomial order (typically 2 or 3)
    framesize = 3;     % Window size (must be odd)
    INa.day_recurrentROIgccGoley = sgolayfilt(INa.day_recurrentROIgcc,polyorder,framesize);
    INa.dayROIgcc_zscore = (INa.ROIgcc - INa.day_recurrentROIgccGoley)./INa.day_recurrent_stdROIgcc;
    INa.dayROIgcc_zscore(isinf(INa.dayROIgcc_zscore)) = NaN;
    figure('color','white');                            plot(INa.daydate,INa.ROIgcc);   hold on;
    plot(INa.daydate, INa.dayROIgcc_zscore);

    % Fit an AR(1) model using arima function
    INa.dayROIgccARIMAzscore = NaN(length(INa.daydate),1);          INa.dayROIgccARIMAzvalueResidual = NaN(length(INa.daydate),1);
    INa.dayROIgccARIMAzscoreconstant = NaN(length(INa.daydate),1);  INa.dayROIgccARIMAzvalueSE = NaN(length(INa.daydate),1);
    jet_color = gray(366);
    Mdl = arima(1,0,0); % AR(1) model

    ind = find(INa.dayY>1900);  % all data
    Z = INa.dayROIgcc_zscore(ind);
    im = 10;
    figure('color','white');
    for ik = im+1:length(Y)-im
        W = Z(ik-im:ik+im);
        if (length(W(~isnan(W)))>3)&(~isnan(Z(ik)))
            EstMdl = estimate(Mdl, W); % Estimate using the first 9 days
            INa.dayROIgccARIMAzvalue(ik) = EstMdl.AR{1};
            INa.dayROIgccARIMAzvalueconstant(ik) = EstMdl.Constant;
            [YF, YMSE] = forecast(EstMdl, im, 'Y0', W);
            INa.dayROIgccARIMAzvalue(ik) = YF(1);
            INa.dayROIgccARIMAzvalueSE(ik) = YMSE(1);
            INa.dayROIgccARIMAzvalueResidual(ik) = YF(1)-W(im);
        end
    end
    % Extreame value theory
    ind = find(INa.daytairday<tresholdtair);
    INa.dayROIgccARIMAzvalueResidualGrowth = INa.dayROIgccARIMAzvalueResidual;
    INa.dayROIgccARIMAzvalueResidualGrowth(ind) = NaN;
    figure('color','white');
    histogram(INa.dayROIgccARIMAzvalueResidualGrowth,30)
    ylabel('frequency'); xlabel('LE_{obs} - ARIMA_{z-value growth season}')
    x = INa.dayROIgccARIMAzvalueResidualGrowth;
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
    INa.dayROIgccHURSTzvalue = NaN(length(INa.daydate),1);
    jet_color = gray(366);
    ind = find(INa.dayY>1900);  % all data
    im = 10;
    Z = INa.dayROIgcc_zscore(ind);

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
            INa.dayROIgccHURSTzvalue(ik) = RS;
        end
    end
    figure('color','white');
    plot(INa.daydate, INa.dayROIgccHURSTzvalue);  hold on
    xlabel('Time (Days)');
    ylabel('Hurst Exponent'); legend('ARIMA','ARIMA z-value')
    grid on;
end

%% .........................................................................
ind = find(INa.daytairday<tresholdtair);
INa.dayGEPdayGrowth  = INa.dayGEPday;       INa.dayGEPdayGrowth(ind) = NaN;
INa.dayRECOdayGrowth = INa.dayRECOday;      INa.dayRECOdayGrowth(ind) = NaN;
INa.dayNEEdayGrowth  = INa.dayNEEday;       INa.dayNEEdayGrowth(ind) = NaN;

INa.dayGEPgrowth = INa.dayGEP;        INa.dayGEPgrowth(ind) = NaN;
INa.dayRECOgrowth = INa.dayRECO;      INa.dayRECOgrowth(ind) = NaN;
INa.dayNEEgrowth = INa.dayNEE;        INa.dayNEEgrowth(ind) = NaN;

polyorder = 2;      % Polynomial order (typically 2 or 3)
framesize = 9;     % Window size (must be odd)
INa.dayGEPdayGoley = sgolayfilt(INa.dayGEPday,polyorder,framesize);
INa.dayGEPdayGrowthGoley = sgolayfilt(INa.dayGEPdayGrowth,polyorder,framesize);

[INa.monthY,INa.monthM,INa.monthD]= datevec(INa.month);
% year_tick = unique(INa.monthY);  year_tick = [year_tick;(year_tick(end)+1)];
% all_year_tick = (datetime(year_tick(1:4:end),1,1))';
[INa.weekY,INa.weekM,INa.weekD]= datevec(INa.week);
[INa.eightY,INa.eightM,INa.eightD]= datevec(INa.eight);

save('INa.mat','INa');
save('matlabINa.mat');
