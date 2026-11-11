%Reads Harvard data. However, it will read any Fluxnet mat file
%Natalia Restrepo Coupe, at UTS
%Feb 5, 2014
%My beautiful Sydney
%% Giovanni -72.172,42.537,-72.171,42.538
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;

FolderName = '/home/ncoupe/Documents/Fluxnet/';

[site_name_FN, lat_FN, lon_FN, site_long_FN, year_ini_FN, year_end_FN, siteelevation_FN, height_FN, ust_tresh_FN, sunrise_FN, sunset_FN, utm_FN, ust_min_FN, ust_max_FN, tree_height_FN, LAI_FN, Biome_FN] =...
    textread([FolderName 'sites_loc.txt'], '%s	%f	%f	%s	%f	%f	%f %f	%f	%f	%f	%f	%f	%f	%f  %f %f',...
    'headerlines',1);

ip = 12;
lat = lat_FN(ip);             lon = lon_FN(ip);             height = height_FN(ip);
site_name = site_name_FN(ip); ust_tresh = ust_tresh_FN(ip); utm = utm_FN(ip);

% .........................................................................
%% TP4
% .........................................................................
opts = delimitedTextImportOptions("NumVariables", 82);
opts.DataLines = [4, Inf];          opts.Delimiter = ",";
opts.VariableNames = ["TIMESTAMP_START", "TIMESTAMP_END", "NEE_PI", "FC", "LE", "H", "USTAR", "SC", "CO2_1_1_1", "CO2_1_2_1", "LE_PI_F", "H_PI_F", "CO2_1_3_1", "H2O", "SH_PI_F", "G_PI_F_1", "NETRAD_1_1_1", "NETRAD_1_2_1", "SW_IN", "SW_OUT", "LW_IN", "LW_OUT", "PPFD_IN", "PPFD_OUT", "PPFD_BC_IN", "TA_1_1_1", "TA_1_2_1", "TA_1_3_1", "RH_1_1_1", "RH_1_2_1", "RH_1_3_1", "WS", "WD", "PA", "TS_1_1_1", "TS_1_2_1", "TS_1_3_1", "TS_1_4_1", "TS_1_5_1", "TS_1_6_1", "TS_2_1_1", "TS_2_2_1", "TS_2_3_1", "TS_2_4_1", "TS_2_5_1", "TS_2_6_1", "SWC_1_1_1", "SWC_1_2_1", "SWC_1_3_1", "SWC_1_4_1", "SWC_1_5_1", "SWC_2_1_1", "SWC_2_2_1", "SWC_2_3_1", "SWC_2_4_1", "SWC_2_5_1", "G_1_1_1", "G_2_1_1", "TA_PI_F_1_1_1", "RH_PI_F_1_1_1", "PPFD_IN_PI_F", "WS_PI_F", "PA_PI_F", "NETRAD_PI_F", "SW_IN_PI_F", "TS_PI_F_1", "TS_PI_F_2", "TS_PI_F_3", "TS_PI_F_4", "TS_PI_F_5", "TS_PI_F_6", "P_PI_F", "LW_IN_PI_F", "D_SNOW", "WTD", "W_SIGMA", "V_SIGMA", "GPP_PI_F", "RECO_PI_F", "NEE_PI_F", "P_RAIN_PI_F", "VPD_PI_F"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";   opts.EmptyLineRule = "read";
TP4table = readtable("/media/ncoupe/Backup/Data/Fluxnet/AMF_CA-TP4_BASE-BADM_5-5/AMF_CA-TP4_BASE_HH_5-5.csv", opts);
clear opts

TP4table.Y = floor(TP4table.TIMESTAMP_START./10^8);    TP4table.M = floor((TP4table.TIMESTAMP_START-TP4table.Y.*10^8)./10^6);
TP4table.D = floor((TP4table.TIMESTAMP_START-(TP4table.Y.*10^8)-(TP4table.M.*10^6))./10^4);
TP4table.HR = floor((TP4table.TIMESTAMP_START-(TP4table.Y.*10^8)-(TP4table.M.*10^6)-(TP4table.D.*10^4))./10^2);
% TP4table.MI = floor((TP4table.TIMESTAMP_START-(TP4table.Y.*10^8)-(TP4table.M.*10^6)-(TP4table.D.*10^4)-(TP4table.HR.*10^2))./10^2);
TP4table = removevars(TP4table, 'TIMESTAMP_START');
TP4table = removevars(TP4table, 'TIMESTAMP_END');

TP4table.dateloc = datetime(TP4table.Y,TP4table.M,TP4table.D,TP4table.HR,0,0);

data = TP4table;     [~, idx] = unique(data(:,"dateloc"),'stable');   TP4table = data(idx,:);
data = sortrows( TP4table, 'dateloc');
TP4table = data;

for ik = 1:width(TP4table)-1
    ij = TP4table{:,ik};       ij(ij == -9999.)  = NaN;         ij(ij == 9999.)  = NaN;
    % ij(ind) = NaN;
    ij(ismissing(ij)) = NaN;     TP4table{:,ik}   = ij;
end

data = TP4table;     [~, idx] = unique(data(:,"dateloc"),'stable');   TP4table = data(idx,:);
data = sortrows( TP4table, 'dateloc');

data = table2timetable(data);
TP4table = retime(data, TP4table.dateloc, 'mean');
% TP4 = timetable2table(TP4table);

% commonVars = intersect(TP4table.Properties.VariableNames, TP4table.Properties.VariableNames);
% TP4table = removevars(TP4table, commonVars);
% TP4table.dateloc = TP4table.datelocTMP;

% TP4join = join(TP4table,TP4table);
TP4join = TP4table;

% figure('color','white')
% plot(TP4join.dateloc,TP4join.SWC_7_1_1);  hold on;
% plot(TP4join.dateloc,TP4join.SWC_7_2_1)
% plot(TP4join.dateloc,TP4join.SWC_7_3_1)
% plot(TP4join.dateloc,TP4join.SWC_7_4_1)

%% ........................................................................
TP4.dateloc = TP4join.dateloc;
[TP4.Y,TP4.M,TP4.D,TP4.HR,~,~] =datevec(TP4.dateloc);
TP4.dateloc_day = datetime(TP4.Y,TP4.M,TP4.D);
TP4.JD = day(TP4.dateloc,'dayofyear');

TP4.So = AM_solar_rad(TP4.JD,TP4.HR,lat,lon);

%% ........................................................................
TP4.Fc = TP4join.FC;
TP4.Sco2 = TP4join.SC;
TP4.LE = TP4join.LE_PI_F;          %TP4.LE (TP4join.LE_F_MDS_QC>2) = NaN;
TP4.H = TP4join.H_PI_F;            %TP4.H (TP4join.H_F_MDS_QC>2) = NaN;
TP4.netrad = TP4join.NETRAD_PI_F;  TP4.ustar = TP4join.USTAR;
TP4.rain = TP4join.P_PI_F;         TP4.par = TP4join.PPFD_IN;     TP4.G = NaN(length(TP4join.dateloc),1);
TP4.tair = TP4join.TA_PI_F_1_1_1;  TP4.ws = TP4join.WS;           TP4.VPD = TP4join.VPD_PI_F;
TP4.RH = TP4join.RH_PI_F_1_1_1;    TP4.pambKpa = TP4join.PA_PI_F;
TP4.pambpa = TP4.pambKpa./1000;
TP4.fh2o = TP4join.SH_PI_F;     %TP4.fh2o (TP4join.LE_F_MDS_QC>2) = NaN;
TP4.h2ommolm = TP4join.H2O;
% TP4.nee = TP4join.NEE_CUT_REF;  TP4.nee(TP4join.NEE_CUT_REF_QC>2) = NaN;
TP4.nee = TP4.Fc+TP4.Sco2;        %TP4.nee(TP4join.NEE_VUT_REF_QC>2) = NaN;
TP4.reco = TP4join.RECO_PI_F;     %TP4.gep(TP4join.NEE_VUT_REF_QC>2) = NaN;
% TP4.gep = TP4join.GPP_PI_F;       %TP4.gep(TP4join.NEE_VUT_REF_QC>2) = NaN;
TP4.gep = -TP4.nee+TP4.reco;      TP4.gep(TP4.gep==0)=NaN;
TP4.gep((TP4.So==0)&(TP4.gep>5))=NaN; TP4.gep((TP4.So>0)&(TP4.gep<-3))=NaN;

TP4.nee(TP4.rain>0) = NaN;     TP4.reco(TP4.rain>0) = NaN;  TP4.gep(TP4.rain>0) = NaN;
TP4.Fc(TP4.rain>0) = NaN;      TP4.LE(TP4.rain>0) = NaN;    TP4.H(TP4.rain>0) = NaN;

ix = [NaN;diff(TP4.LE)];       TP4.LE(ix==0) = NaN;         TP4.LE(TP4.LE==0) = NaN;
TP4.LE(TP4.LE>900) = NaN;      TP4.H(TP4.H>900) = NaN;
TP4.LE(TP4.rain>0) = NaN;      TP4.H(TP4.rain>0) = NaN;
TP4.netrad((TP4.So<100)&(TP4.netrad>200)) = NaN;
TP4.netrad(TP4.netrad>800) = NaN;

%%
v1 = 0;         v2 = 800;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/26):v2;
figure('color','white');            hold on;
ik = TP4.Y(1);   count=1;            color_jet = jet(max(TP4.Y)-min(TP4.Y)+1);
while ik<TP4.Y(end)
    hl1  =  plot(TP4.par(TP4.Y == ik)./2,TP4.netrad(TP4.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TP4.par(TP4.Y == ik)./2,TP4.netrad(TP4.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('Rn');  xlabel ('PAR');

v1 = 0;         v2 = 800;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/26):v2;
figure('color','white');            hold on;
ik = TP4.Y(1);   count=1;             color_jet = jet(max(TP4.Y)-min(TP4.Y)+1);
while ik<TP4.Y(end)
    hl1  =  plot(TP4.netrad(TP4.Y == ik),TP4.LE(TP4.Y == ik)+TP4.H(TP4.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TP4.netrad(TP4.Y == ik),TP4.LE(TP4.Y == ik)+TP4.H(TP4.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('H+LE');  xlabel ('Rn');

% %% ......................................................................................
% ind = find((TP4.dateloc>=datetime(2009,4,10))&(TP4.dateloc<=datetime(2012,4,10)));      TP4.netrad(ind) = TP4.netrad(ind) -30;  %TP4.H(ind) = NaN;
% % ind = find((TP4.dateloc>=datetime(2010,4,10))&(TP4.dateloc<=datetime(2012,4,10)));      TP4.netrad(ind) = TP4.netrad(ind) -30;  %TP4.H(ind) = NaN;
%
% ind = find((TP4.dateloc>=datetime(2006,8,24))&(TP4.dateloc<=datetime(2006,9,21)));      TP4.LE(ind) = NaN;  %TP4.H(ind) = NaN;
% ind = find((TP4.dateloc>=datetime(2008,6,25))&(TP4.dateloc<=datetime(2008,8,12)));      TP4.LE(ind) = NaN;  %TP4.H(ind) = NaN;
% ind = find((TP4.dateloc>=datetime(2009,6,22))&(TP4.dateloc<=datetime(2009,7,15)));      TP4.LE(ind) = NaN;  %TP4.H(ind) = NaN;
% ind = find((TP4.dateloc>=datetime(2009,7,19))&(TP4.dateloc<=datetime(2009,8,13)));      TP4.LE(ind) = NaN;  %TP4.H(ind) = NaN;
%
% ind = find((TP4.dateloc>=datetime(2019,1,30))&(TP4.dateloc<=datetime(2019,2,2)));      TP4.H(ind) = NaN;  %TP4.H(ind) = NaN;
%
% ind = find((TP4.dateloc>=datetime(2001,6,20))&(TP4.dateloc<=datetime(2001,6,28)));    TP4.netrad(ind) = NaN;  %TP4.H(ind) = NaN;
% ind = find((TP4.dateloc>=datetime(2004,10,5))&(TP4.dateloc<=datetime(2005,5,1)));      TP4.netrad(ind) = NaN;  %TP4.H(ind) = NaN;
% ind = find((TP4.dateloc>=datetime(2006,12,24))&(TP4.dateloc<=datetime(2006,12,28)));TP4.netrad(ind) = NaN;  %TP4.H(ind) = NaN;
% ind = find((TP4.dateloc>=datetime(2006,5,25))&(TP4.dateloc<=datetime(2006,8,25)));  TP4.netrad(ind) = NaN;  %TP4.H(ind) = NaN;
% ind = find((TP4.dateloc>=datetime(2009,5,24))&(TP4.dateloc<=datetime(2009,10,5)));  TP4.netrad(ind) = NaN;  %TP4.H(ind) = NaN;
% ind = find((TP4.dateloc>=datetime(2011,5,13))&(TP4.dateloc<=datetime(2011,5,23)));  TP4.netrad(ind) = NaN;  %TP4.H(ind) = NaN;
% ind = find((TP4.dateloc>=datetime(2009,7,19))&(TP4.dateloc<=datetime(2010,4,11)));  TP4.netrad(ind) = TP4.netrad(ind)-40;  %TP4.H(ind) = NaN;
%
% TP4.netrad(TP4.netrad==3) = NaN;%

%%
numberY = TP4.Y(end) -TP4.Y(1);
v1 = 0;         v2 = 800;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/numberY):v2;
figure('color','white');            hold on;
ik = TP4.Y(1);   count=1;     color_jet = jet(max(TP4.Y)-min(TP4.Y)+5);
while ik<TP4.Y(end)
    hl1  =  plot(TP4.par(TP4.Y == ik)./2,TP4.netrad(TP4.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TP4.par(TP4.Y == ik)./2,TP4.netrad(TP4.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('Rn');  xlabel ('PAR');

v1 = 0;         v2 = 1000;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/26):v2;
figure('color','white');            hold on;
ik = TP4.Y(1);   count=1;             color_jet = jet(max(TP4.Y)-min(TP4.Y)+1);
while ik<TP4.Y(end)
    hl1  =  plot(TP4.par(TP4.Y == ik)./2,TP4.LE(TP4.Y == ik)+TP4.H(TP4.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TP4.par(TP4.Y == ik)./2,TP4.LE(TP4.Y == ik)+TP4.H(TP4.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('H+LE (W m^-^2)');   xlabel ('Rn (W m^-^2)');
axis([v1 v2 v1 v2]); grid on; box on;

%%
color_jet = jet(7);
figure('color','white');
plot(TP4.dateloc,TP4.So./2,'Color', color_jet(1,:));      hold on
plot(TP4.dateloc,(TP4.par)./2,'Color', 'k');
plot(TP4.dateloc,TP4.netrad,'Color', color_jet(2,:));      hold on
plot(TP4.dateloc,TP4.H,'Color',color_jet(6,:));            plot(TP4.dateloc,TP4.LE,'Color',color_jet(4,:));
plot(TP4.dateloc,(TP4.H+TP4.LE),'Color', color_jet(6,:));
legend('TOA','par','net radiation','H','LE','turbulent');                                ylabel('energy flux (W m^-^2)');

[TP4.daytair,~,~,~,TP4.daydate] = AM_day(TP4.tair,TP4.dateloc,1);
% TP4.Bowen = TP4.H./TP4.LE;                              TP4.Bowen(abs(TP4.Bowen)>100) = NaN;
% figure('color','white');
% plot(TP4.dateloc,TP4.Bowen,'Color', [.3 .8 .2]);
% hold on

% .................................................................................................
%% Set up the Import Options and import the data
% .................................................................................................
opts = delimitedTextImportOptions("NumVariables", 16);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["product", "band", "modis_date", "dt", "value_min", "value_max", "value_sum", "value_range", "value_mean", "value_variance", "value_standard_deviation", "pixels_total", "pixels_pass_qa", "pixels_pass_qa_per_cent", "proc_date", "value_center"];
opts.VariableTypes = ["categorical", "categorical", "double", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["product", "band"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "dt", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
opts = setvaropts(opts, "modis_date", "TrimNonNumeric", true);
opts = setvaropts(opts, "modis_date", "ThousandsSeparator", ",");
scaled250m16daysEVI = readtable("/media/ncoupe/Backup/Data/Fluxnet/CA-TP4-MODIS/statistics_250m_16_days_EVI.csv", opts);
clear opts

EVI.Y = floor(scaled250m16daysEVI.modis_date./1000);
EVI.JD = floor(scaled250m16daysEVI.modis_date-EVI.Y.*1000);
EVI.dateloc = datetime(EVI.Y,1,EVI.JD);
figure;
plot(EVI.dateloc,scaled250m16daysEVI.value_center)

% .................................................................................................
%% Set up the Import Options and import the data
% .................................................................................................
% % opts = delimitedTextImportOptions("NumVariables", 40);
% % opts.DataLines = [19, Inf];
% % opts.Delimiter = ",";
% % opts.VariableNames = ["date", "local_std_time", "doy", "filename", "solar_elev", "exposure", "awbflag", "mask_index", "gcc", "rcc", "r_mean", "r_std", "r_5_qtl", "r_10_qtl", "r_25_qtl", "r_50_qtl", "r_75_qtl", "r_90_qtl", "r_95_qtl", "g_mean", "g_std", "g_5_qtl", "g_10_qtl", "g_25_qtl", "g_50_qtl", "g_75_qtl", "g_90_qtl", "g_95_qtl", "b_mean", "b_std", "b_5_qtl", "b_10_qtl", "b_25_qtl", "b_50_qtl", "b_75_qtl", "b_90_qtl", "b_95_qtl", "r_g_correl", "g_b_correl", "b_r_correl"];
% % opts.VariableTypes = ["datetime", "datetime", "double", "string", "double", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% % opts.ExtraColumnsRule = "ignore";
% % opts.EmptyLineRule = "read";
% % opts = setvaropts(opts, "filename", "WhitespaceRule", "preserve");
% % opts = setvaropts(opts, ["filename", "exposure", "awbflag"], "EmptyFieldRule", "auto");
% % opts = setvaropts(opts, "date", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "local_std_time", "InputFormat", "HH:mm:ss", "DatetimeFormat", "preserveinput");
% % ROI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-TP4-phenocam/harvard_DB_1000_provisional_data/provisional_data/data_record_3/harvard_DB_1000_roistats.csv", opts);
opts = delimitedTextImportOptions("NumVariables", 49);
opts.DataLines = [26, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["daydate", "year", "doy", "image_count", "midday_filename", "midday_r", "midday_g", "midday_b", "midday_gcc", "midday_rcc", "r_mean", "r_std", "g_mean", "g_std", "b_mean", "b_std", "gcc_mean", "gcc_std", "gcc_50", "gcc_75", "gcc_90", "rcc_mean", "rcc_std", "rcc_50", "rcc_75", "rcc_90", "max_solar_elev", "snow_flag", "outlierflag_gcc_mean", "outlierflag_gcc_50", "outlierflag_gcc_75", "outlierflag_gcc_90", "smooth_gcc_mean", "smooth_gcc_50", "smooth_gcc_75", "smooth_gcc_90", "smooth_rcc_mean", "smooth_rcc_50", "smooth_rcc_75", "smooth_rcc_90", "smooth_ci_gcc_mean", "smooth_ci_gcc_50", "smooth_ci_gcc_75", "smooth_ci_gcc_90", "smooth_ci_rcc_mean", "smooth_ci_rcc_50", "smooth_ci_rcc_75", "smooth_ci_rcc_90", "int_flag"];
opts.VariableTypes = ["datetime", "double", "double", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["midday_filename", "snow_flag"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "daydate", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
opts = setvaropts(opts, "int_flag", "TrimNonNumeric", true);
opts = setvaropts(opts, "int_flag", "ThousandsSeparator", ",");
ROI = readtable("/media/ncoupe/Backup/Data/Fluxnet/CA-TP4_phenocam/turkeypointenf39_EN_1000_provisional_data/provisional_data/data_record_4/turkeypointenf39_EN_1000_1day.csv", opts);
clear opts

[ROI.dayY,ROI.dayM,ROI.dayD] = datevec(ROI.daydate);
figure
plot(ROI.daydate,ROI.gcc_mean);   hold on;

cols = varfun(@isnumeric, ROI, 'OutputFormat', 'uniform');
cols(1:5) = false;  % Ignore columns 1 to 5
ind = find(((ROI.daydate>=datetime(2016,6,24))&(ROI.daydate<=datetime(2016,8,17))));
ROI{ind, cols} = NaN;
ind = find(((ROI.daydate>=datetime(2018,1,1))&(ROI.daydate<=datetime(2018,12,31))));
ROI{ind, cols} = NaN;
ind = find(ROI.daydate==datetime(2023,01,13));
ROI{ind, cols} = NaN;
ind = find(((ROI.daydate>=datetime(2019,5,13))&(ROI.daydate<=datetime(2019,5,14))));
ROI{ind, cols} = NaN;
ind = find(((ROI.daydate>=datetime(2019,6,06))&(ROI.daydate<=datetime(2019,06,20))));
ROI{ind, cols} = NaN;
ind = find(((ROI.daydate>=datetime(2020,2,15))&(ROI.daydate<=datetime(2020,2,19))));
ROI{ind, cols} = NaN;
ind = find(((ROI.daydate>=datetime(2020,7,17))&(ROI.daydate<=datetime(2020,7,30))));
ROI{ind, cols} = NaN;
ind = find(((ROI.daydate>=datetime(2021,01,11))&(ROI.daydate<=datetime(2021,01,20))));
ROI{ind, cols} = NaN;
ind = find(((ROI.daydate>=datetime(2021,02,11))&(ROI.daydate<=datetime(2021,06,26))));
ROI{ind, cols} = NaN;
ind = find(((ROI.daydate>=datetime(2024,06,06))&(ROI.daydate<=datetime(2024,06,15))));
ROI{ind, cols} = NaN;
ind = find(ROI.daydate==datetime(2023,01,13));
ROI{ind, cols} = NaN;
ind = find(((ROI.daydate>=datetime(2022,10,11))&(ROI.daydate<=datetime(2022,10,14))));
ROI{ind, cols} = NaN;
ind = find(ROI.daydate==datetime(2021,01,04));
ROI{ind, cols} = NaN;
ind = find(((ROI.daydate>=datetime(2024,08,25))&(ROI.daydate<=datetime(2024,08,28))));
ROI{ind, cols} = NaN;


% Will remove the start of the camera it is too high
ind = find(ROI.daydate<datetime(2013,07,14));
ROI{ind, cols} = NaN;

% .........................................................................
%% Change of camera
% .........................................................................
ROI.GRRI_mean = ROI.g_mean./ROI.r_mean;
ROI.GRIVI_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
ROI.cci_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
ROI.exgreen_mean = ((2.*ROI.g_mean)-ROI.r_mean-ROI.b_mean);%./(ROI.g_mean+ROI.r_mean+ROI.b_mean);

A = 3;
disp('Achtung change of camera or something')
ind = find(ROI.daydate>datetime(2018,10,1), 1, 'first');
avgOld = mean(ROI.g_mean(1:ind),'omitmissing'); avgNew = mean(ROI.g_mean(ind:end),'omitmissing');
shiftAmount = avgOld - avgNew;
ix = ROI.g_mean;     ix(ind+1:end) = smoothdata(ROI.g_mean(ind+1:end),'movmean',A) + shiftAmount;  ROI.g_mean = ix;

avgOld = mean(ROI.r_mean(1:ind),'omitmissing'); avgNew = mean(ROI.r_mean(ind:end),'omitmissing');
shiftAmount = avgOld - avgNew;
ix = ROI.r_mean;     ix(ind+1:end) = smoothdata(ROI.r_mean(ind+1:end),'movmean',A)  + shiftAmount;  ROI.r_mean = ix;

avgOld = mean(ROI.b_mean(1:ind),'omitmissing'); avgNew = mean(ROI.b_mean(ind:end),'omitmissing');
shiftAmount = avgOld - avgNew;
ix = ROI.b_mean;     ix(ind+1:end) = smoothdata(ROI.b_mean(ind+1:end),'movmean',A) + shiftAmount;  ROI.b_mean = ix;

dataOld = ROI.gcc_mean(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
dataNew = smoothdata(ROI.gcc_mean(ind:end),'movmean',A);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.gcc_mean(ind:end) = (dataNew - p5_New) * gain + p5_Old;
plot(ROI.daydate,ROI.gcc_mean);   hold on;

dataOld = ROI.rcc_50(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
dataNew = smoothdata(ROI.rcc_50(ind:end),'movmean',A);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.rcc_50(ind:end) = (dataNew - p5_New) * gain + p5_Old;

dataOld = ROI.rcc_75(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
dataNew = smoothdata(ROI.rcc_75(ind:end),'movmean',A);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.rcc_75(ind:end) = (dataNew - p5_New) * gain + p5_Old;

dataOld = ROI.rcc_mean(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
dataNew = smoothdata(ROI.rcc_mean(ind:end),'movmean',A);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.rcc_mean(ind:end) = (dataNew - p5_New) * gain + p5_Old;

avgOld = mean(ROI.midday_g(1:ind),'omitmissing'); avgNew = mean(ROI.midday_g(ind:end),'omitmissing');
shiftAmount = avgOld - avgNew;
ix = ROI.midday_g;     ix(ind+1:end) = smoothdata(ROI.midday_g(ind+1:end),'movmean',A) + shiftAmount;  ROI.midday_g = ix;

avgOld = mean(ROI.midday_r(1:ind),'omitmissing'); avgNew = mean(ROI.midday_r(ind:end),'omitmissing');
shiftAmount = avgOld - avgNew;
ix = ROI.midday_r;     ix(ind+1:end) = smoothdata(ROI.midday_r(ind+1:end),'movmean',A) + shiftAmount;  ROI.midday_r = ix;

avgOld = mean(ROI.midday_b(1:ind),'omitmissing'); avgNew = mean(ROI.midday_b(ind:end),'omitmissing');
shiftAmount = avgOld - avgNew;
ix = ROI.midday_b;     ix(ind+1:end) = smoothdata(ROI.midday_b(ind+1:end),'movmean',A) + shiftAmount;  ROI.midday_b = ix;

dataOld = ROI.midday_gcc(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
dataNew = smoothdata(ROI.midday_gcc(ind:end),'movmean',A);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.midday_gcc(ind:end) = (dataNew - p5_New) * gain + p5_Old;

dataOld = ROI.GRIVI_mean(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
dataNew = smoothdata(ROI.GRIVI_mean(ind:end),'movmean',A);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.GRIVI_mean(ind:end) = (dataNew - p5_New) * gain + p5_Old;
plot(ROI.daydate,ROI.GRIVI_mean);   hold on;

hold on; plot(ROI.daydate,ROI.midday_gcc);
hold on; xline(ind, '--r', 'Instrument Change');
plot(ROI.daydate,ROI.gcc_mean,'k');

dataOld = ROI.GRRI_mean(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
dataNew = smoothdata(ROI.GRRI_mean(ind:end),'movmean',A);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.GRRI_mean(ind:end) = (dataNew - p5_New) * gain + p5_Old;

dataOld = ROI.cci_mean(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
dataNew = smoothdata(ROI.cci_mean(ind:end),'movmean',A);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.cci_mean(ind:end) = (dataNew - p5_New) * gain + p5_Old;

dataOld = ROI.exgreen_mean(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
dataNew = smoothdata(ROI.exgreen_mean(ind:end),'movmean',A);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.exgreen_mean(ind:end) = (dataNew - p5_New) * gain + p5_Old;

ROI.GRRI_mean = AM_fill_plus(ROI.GRRI_mean);       ROI.gcc_mean = AM_fill_plus(ROI.gcc_mean);
ROI.rcc_mean = AM_fill_plus(ROI.rcc_mean);         ROI.GRIVI_mean = AM_fill_plus(ROI.GRIVI_mean);
ROI.exgreen_mean = AM_fill_plus(ROI.exgreen_mean); ROI.r_mean = AM_fill_plus(ROI.r_mean);
ROI.g_mean = AM_fill_plus(ROI.g_mean);             ROI.b_mean = AM_fill_plus(ROI.b_mean);
ROI.cci_mean = AM_fill_plus(ROI.cci_mean);

% % % .................................................................................................
% % %% Set up the Import Options and import the data
% % % .................................................................................................
% % opts = delimitedTextImportOptions("NumVariables", 10);
% % opts.DataLines = [2, Inf];         opts.Delimiter = ",";
% % opts.VariableNames = ["datetime", "dateloc", "doy", "time", "distance", "transect", "lai_unmasked", "sel_unmasked", "lai_masked", "sel_masked"];
% % opts.VariableTypes = ["datetime", "datetime", "double", "duration", "double", "double", "double", "double", "double", "categorical"];
% % opts.ExtraColumnsRule = "ignore";  opts.EmptyLineRule = "read";
% % opts = setvaropts(opts, "sel_masked", "EmptyFieldRule", "auto");
% % opts = setvaropts(opts, "datetime", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "dateloc", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "time", "InputFormat", "hh:mm:ss.S");
% % LAIlph = readtimetable("/home/ncoupe/Documents/Fluxnet/US-TP4/LAI/hf150-02-lph-lai.csv", opts, "RowTimes", "datetime");
% %
% % opts = delimitedTextImportOptions("NumVariables", 8);
% % opts.DataLines = [2, Inf];           opts.Delimiter = ",";
% % opts.VariableNames = ["datetime", "dateloc", "doy", "time", "distance", "transect", "lai_masked", "sel"];
% % opts.VariableTypes = ["datetime", "datetime", "double", "datetime", "double", "double", "double", "double"];
% % opts.ExtraColumnsRule = "ignore";    opts.EmptyLineRule = "read";
% % opts = setvaropts(opts, "datetime", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "dateloc", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "time", "InputFormat", "hh:mm:ss.S");
% % LAIhem = readtimetable("/home/ncoupe/Documents/Fluxnet/US-TP4/LAI/hf150-01-hem-lai.csv", opts, "RowTimes", "datetime");
% % clear opts
% %
% % opts = delimitedTextImportOptions("NumVariables", 11);
% % opts.DataLines = [2, Inf];
% % opts.Delimiter = ",";
% % opts.VariableNames = ["daydate", "year", "doy", "site", "n_plots", "all_mean", "all_stdev", "all_conf_int", "decid_mean", "decid_stdev", "decid_conf_int"];
% % opts.VariableTypes = ["datetime", "double", "double", "categorical", "double", "double", "double", "double", "double", "double", "double"];
% % opts.ExtraColumnsRule = "ignore";
% % opts.EmptyLineRule = "read";
% % opts = setvaropts(opts, "site", "EmptyFieldRule", "auto");
% % opts = setvaropts(opts, "daydate", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
% % LAIsite = readtable("/home/ncoupe/Documents/Fluxnet/US-TP4/LAI/hf069-02-lai-site.csv", opts);
% % clear opts
% %
% % ind = find(LAIlph.lai_masked==-9999.);                           LAIlph.lai_masked(ind) = NaN;
% % ind = find(LAIlph.lai_unmasked==-9999.);                         LAIlph.lai_unmasked(ind) = NaN;
% % [LAIlph.Y,LAIlph.M,LAIlph.D] = datevec(LAIlph.dateloc);          LAIlph.JD = day(LAIlph.dateloc,'dayofyear');
% % LAIlph.JD = day(LAIlph.dateloc,'dayofyear');                     LAIlph.So = AM_solar_rad(LAIlph.JD,12,lat,lon);
% % % ix = LAIlph.lai_masked;
% %
% % ind = find(LAIhem.lai_masked==-9999.);                           LAIhem.lai_masked(ind) = NaN;
% % % ind = find(LAIhem.lai_unmasked==-9999.);                       LAIhem.lai_unmasked(ind) = NaN;
% % [LAIhem.Y,LAIhem.M,LAIhem.D] = datevec(LAIhem.dateloc);  LAIhem.JD = day(LAIhem.dateloc,'dayofyear');
% % LAIhem.JD = day(LAIhem.dateloc,'dayofyear');                     LAIhem.So = AM_solar_rad(LAIhem.JD,12,lat,lon);
% % % ix = LAIlph.lai_masked;
% %
% % data = LAIsite;     [~, idx] = unique(data(:,"daydate"),'stable');   LAIsite = data(idx,:);
% % data = sortrows( LAIsite, 'daydate');                                           LAIsite = data;
% % LAIsite.all_mean(LAIsite.all_mean<1) = NaN;
% %
% % figure('Color','white');
% % plot(LAIlph.dateloc,LAIlph.lai_masked,'.'); hold on;      plot(LAIlph.dateloc,LAIlph.lai_unmasked,'.'); hold on
% % plot(LAIhem.dateloc,LAIhem.lai_masked,'.');
% % ind = find(LAIsite.site=='ems');                     plot(LAIsite.daydate(ind),LAIsite.all_mean(ind),'k'); hold on
% % ind = find(LAIsite.site=='harv');                     plot(LAIsite.daydate(ind),LAIsite.all_mean(ind),'m'); hold on
% %
% % LAIsite = LAIsite((LAIsite.site=='ems'),:);
% % LAIsite( (isnat(LAIsite.daydate)),:) = [];
LAIsite.daydate = TP4.daydate;
LAIsite.all_mean = 4.*ones(length(TP4.daydate),1);

%% % NIR
% opts = delimitedTextImportOptions("NumVariables", 37);
% opts.DataLines = [2, Inf];
% opts.Delimiter = ",";
% opts.VariableNames = ["x2019_04_0216_10", "x0_448", "x0_471", "x0_475", "x0_411", "x0_431", "x0_447", "x0_477", "x0_463", "x0_484", "x0_442", "x0_456", "x0_1", "x0_491", "x0_465", "x0_479", "x0_47", "x0_2", "x0_481", "x0_501", "x0_413", "x0_472", "x0_494", "x0_458", "x0_3", "x0_4", "x0_37", "x0_5", "x0_498", "x0_457", "x0_6", "x0_461", "x0_7", "x0_8", "x0_515", "x0_9", "x0_487"];
% opts.SelectedVariableNames = "x2019_04_0216_10";
% opts.VariableTypes = ["datetime", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];
% opts.ExtraColumnsRule = "ignore";
% opts.EmptyLineRule = "read";
% opts = setvaropts(opts, ["x0_448", "x0_471", "x0_475", "x0_411", "x0_431", "x0_447", "x0_477", "x0_463", "x0_484", "x0_442", "x0_456", "x0_1", "x0_491", "x0_465", "x0_479", "x0_47", "x0_2", "x0_481", "x0_501", "x0_413", "x0_472", "x0_494", "x0_458", "x0_3", "x0_4", "x0_37", "x0_5", "x0_498", "x0_457", "x0_6", "x0_461", "x0_7", "x0_8", "x0_515", "x0_9", "x0_487"], "WhitespaceRule", "preserve");
% opts = setvaropts(opts, ["x0_448", "x0_471", "x0_475", "x0_411", "x0_431", "x0_447", "x0_477", "x0_463", "x0_484", "x0_442", "x0_456", "x0_1", "x0_491", "x0_465", "x0_479", "x0_47", "x0_2", "x0_481", "x0_501", "x0_413", "x0_472", "x0_494", "x0_458", "x0_3", "x0_4", "x0_37", "x0_5", "x0_498", "x0_457", "x0_6", "x0_461", "x0_7", "x0_8", "x0_515", "x0_9", "x0_487"], "EmptyFieldRule", "auto");
% opts = setvaropts(opts, "x2019_04_0216_10", "InputFormat", "dd-MMM-yyyy HH:mm:ss", "DatetimeFormat", "preserveinput");
% NDVI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-TP4-geonex/NDVI.csv/NDVI.csv", opts);
% clear opts

save('TP4.mat','TP4');
save('matlabTP4.mat');