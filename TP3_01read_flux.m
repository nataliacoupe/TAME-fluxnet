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

ip = 14;
lat = lat_FN(ip);             lon = lon_FN(ip);             height = height_FN(ip);
site_name = site_name_FN(ip); ust_tresh = ust_tresh_FN(ip); utm = utm_FN(ip);

% .........................................................................
%% TP3
% .........................................................................
opts = delimitedTextImportOptions("NumVariables", 68);
opts.DataLines = [4, Inf];          opts.Delimiter = ",";
opts.VariableNames = ["TIMESTAMP_START", "TIMESTAMP_END", "NEE_PI", "FC", "LE", "H", "USTAR", "SC", "CO2_1_1_1", "CO2_1_2_1", "LE_PI_F", "H_PI_F", "H2O", "SH_PI_F", "G_PI_F_1", "NETRAD", "PPFD_IN", "PPFD_OUT", "PPFD_BC_IN", "TA", "RH", "WS", "WD", "PA", "TS_1_1_1", "TS_1_2_1", "TS_1_3_1", "TS_1_4_1", "TS_1_5_1", "TS_1_6_1", "TS_2_1_1", "TS_2_2_1", "TS_2_3_1", "TS_2_4_1", "TS_2_5_1", "TS_2_6_1", "SWC_1_1_1", "SWC_1_2_1", "SWC_1_3_1", "SWC_1_4_1", "SWC_1_5_1", "SWC_2_1_1", "SWC_2_2_1", "SWC_2_3_1", "SWC_2_4_1", "SWC_2_5_1", "G_1_1_1", "G_2_1_1", "TA_PI_F", "RH_PI_F", "PPFD_IN_PI_F", "WS_PI_F", "PA_PI_F", "NETRAD_PI_F", "SW_IN_PI_F", "TS_PI_F_1", "TS_PI_F_2", "TS_PI_F_3", "TS_PI_F_4", "TS_PI_F_5", "TS_PI_F_6", "P_PI_1", "W_SIGMA", "V_SIGMA", "GPP_PI_F", "RECO_PI_F", "NEE_PI_F", "VPD_PI_F"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";   opts.EmptyLineRule = "read";
TP3table = readtable("/media/ncoupe/Backup/Data/Fluxnet/AMF_CA-TP3_BASE-BADM_5-5/AMF_CA-TP3_BASE_HH_5-5.csv", opts);
clear opts

TP3table.Y = floor(TP3table.TIMESTAMP_START./10^8);    TP3table.M = floor((TP3table.TIMESTAMP_START-TP3table.Y.*10^8)./10^6);
TP3table.D = floor((TP3table.TIMESTAMP_START-(TP3table.Y.*10^8)-(TP3table.M.*10^6))./10^4);
TP3table.HR = floor((TP3table.TIMESTAMP_START-(TP3table.Y.*10^8)-(TP3table.M.*10^6)-(TP3table.D.*10^4))./10^2);
% TP3table.MI = floor((TP3table.TIMESTAMP_START-(TP3table.Y.*10^8)-(TP3table.M.*10^6)-(TP3table.D.*10^4)-(TP3table.HR.*10^2))./10^2);
TP3table = removevars(TP3table, 'TIMESTAMP_START');
TP3table = removevars(TP3table, 'TIMESTAMP_END');

TP3table.dateloc = datetime(TP3table.Y,TP3table.M,TP3table.D,TP3table.HR,0,0);

data = TP3table;     [~, idx] = unique(data(:,"dateloc"),'stable');   TP3table = data(idx,:);
data = sortrows( TP3table, 'dateloc');     
TP3table = data;

for ik = 1:width(TP3table)-1
    ij = TP3table{:,ik};       ij(ij == -9999.)  = NaN;         ij(ij == 9999.)  = NaN;
    % ij(ind) = NaN;
    ij(ismissing(ij)) = NaN;     TP3table{:,ik}   = ij;
end

data = TP3table;     [~, idx] = unique(data(:,"dateloc"),'stable');   TP3table = data(idx,:);
data = sortrows( TP3table, 'dateloc');

data = table2timetable(data);
TP3table = retime(data, TP3table.dateloc, 'mean');
% TP3 = timetable2table(TP3table);

% commonVars = intersect(TP3table.Properties.VariableNames, TP3table.Properties.VariableNames);
% TP3table = removevars(TP3table, commonVars);
% TP3table.dateloc = TP3table.datelocTMP;

% TP3join = join(TP3table,TP3table);
TP3join = TP3table;

% figure('color','white')
% plot(TP3join.dateloc,TP3join.SWC_7_1_1);  hold on;
% plot(TP3join.dateloc,TP3join.SWC_7_2_1)
% plot(TP3join.dateloc,TP3join.SWC_7_3_1)
% plot(TP3join.dateloc,TP3join.SWC_7_4_1)

%% ........................................................................
TP3.dateloc = TP3join.dateloc;
[TP3.Y,TP3.M,TP3.D,TP3.HR,~,~] =datevec(TP3.dateloc);
TP3.dateloc_day = datetime(TP3.Y,TP3.M,TP3.D);
TP3.JD = day(TP3.dateloc,'dayofyear');

TP3.So = AM_solar_rad(TP3.JD,TP3.HR,lat,lon);

%% ........................................................................
TP3.Fc = TP3join.FC;
TP3.Sco2 = TP3join.SC;
TP3.LE = TP3join.LE_PI_F;          %TP3.LE (TP3join.LE_F_MDS_QC>2) = NaN;
TP3.H = TP3join.H_PI_F;            %TP3.H (TP3join.H_F_MDS_QC>2) = NaN;
TP3.netrad = TP3join.NETRAD_PI_F;  TP3.ustar = TP3join.USTAR;
TP3.rain = TP3join.P_PI_1;         TP3.par = TP3join.PPFD_IN;     TP3.G = NaN(length(TP3join.dateloc),1);
TP3.tair = TP3join.TA_PI_F;        TP3.ws = TP3join.WS;           TP3.VPD = TP3join.VPD_PI_F;
TP3.RH = TP3join.RH_PI_F;    TP3.pambKpa = TP3join.PA_PI_F;
TP3.pambpa = TP3.pambKpa./1000;
TP3.fh2o = TP3join.SH_PI_F;     %TP3.fh2o (TP3join.LE_F_MDS_QC>2) = NaN;
TP3.h2ommolm = TP3join.H2O;
% TP3.nee = TP3join.NEE_CUT_REF;  TP3.nee(TP3join.NEE_CUT_REF_QC>2) = NaN;
TP3.nee = TP3.Fc+TP3.Sco2;        %TP3.nee(TP3join.NEE_VUT_REF_QC>2) = NaN;
TP3.reco = TP3join.RECO_PI_F;     %TP3.gep(TP3join.NEE_VUT_REF_QC>2) = NaN;
% TP3.gep = TP3join.GPP_PI_F;       %TP3.gep(TP3join.NEE_VUT_REF_QC>2) = NaN;
TP3.gep = -TP3.nee+TP3.reco;      TP3.gep(TP3.gep==0)=NaN;
TP3.gep((TP3.So==0)&(TP3.gep>5))=NaN; TP3.gep((TP3.So>0)&(TP3.gep<-3))=NaN;

TP3.nee(TP3.rain>0) = NaN;     TP3.reco(TP3.rain>0) = NaN;  TP3.gep(TP3.rain>0) = NaN;   
TP3.Fc(TP3.rain>0) = NaN;      TP3.LE(TP3.rain>0) = NaN;    TP3.H(TP3.rain>0) = NaN;   

ix = [NaN;diff(TP3.LE)];       TP3.LE(ix==0) = NaN;            TP3.LE(TP3.LE==0) = NaN;
TP3.LE(TP3.LE>900) = NaN;      TP3.H(TP3.H>900) = NaN;
TP3.LE(TP3.rain>0) = NaN;      TP3.H(TP3.rain>0) = NaN;
TP3.netrad((TP3.So<100)&(TP3.netrad>200)) = NaN;
TP3.netrad(TP3.netrad>800) = NaN;

%%
v1 = 0;         v2 = 800;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/26):v2;
figure('color','white');            hold on;
ik = TP3.Y(1);   count=1;            color_jet = jet(max(TP3.Y)-min(TP3.Y)+1);
while ik<TP3.Y(end)
    hl1  =  plot(TP3.par(TP3.Y == ik)./2,TP3.netrad(TP3.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TP3.par(TP3.Y == ik)./2,TP3.netrad(TP3.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('Rn');  xlabel ('PAR');

v1 = 0;         v2 = 800;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/26):v2;
figure('color','white');            hold on;
ik = TP3.Y(1);   count=1;             color_jet = jet(max(TP3.Y)-min(TP3.Y)+1);
while ik<TP3.Y(end)
    hl1  =  plot(TP3.netrad(TP3.Y == ik),TP3.LE(TP3.Y == ik)+TP3.H(TP3.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TP3.netrad(TP3.Y == ik),TP3.LE(TP3.Y == ik)+TP3.H(TP3.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('H+LE');  xlabel ('Rn');

% %% ......................................................................................
% ind = find((TP3.dateloc>=datetime(2009,4,10))&(TP3.dateloc<=datetime(2012,4,10)));      TP3.netrad(ind) = TP3.netrad(ind) -30;  %TP3.H(ind) = NaN;
% % ind = find((TP3.dateloc>=datetime(2010,4,10))&(TP3.dateloc<=datetime(2012,4,10)));      TP3.netrad(ind) = TP3.netrad(ind) -30;  %TP3.H(ind) = NaN;
%
% ind = find((TP3.dateloc>=datetime(2006,8,24))&(TP3.dateloc<=datetime(2006,9,21)));      TP3.LE(ind) = NaN;  %TP3.H(ind) = NaN;
% ind = find((TP3.dateloc>=datetime(2008,6,25))&(TP3.dateloc<=datetime(2008,8,12)));      TP3.LE(ind) = NaN;  %TP3.H(ind) = NaN;
% ind = find((TP3.dateloc>=datetime(2009,6,22))&(TP3.dateloc<=datetime(2009,7,15)));      TP3.LE(ind) = NaN;  %TP3.H(ind) = NaN;
% ind = find((TP3.dateloc>=datetime(2009,7,19))&(TP3.dateloc<=datetime(2009,8,13)));      TP3.LE(ind) = NaN;  %TP3.H(ind) = NaN;
%
% ind = find((TP3.dateloc>=datetime(2019,1,30))&(TP3.dateloc<=datetime(2019,2,2)));      TP3.H(ind) = NaN;  %TP3.H(ind) = NaN;
%
% ind = find((TP3.dateloc>=datetime(2001,6,20))&(TP3.dateloc<=datetime(2001,6,28)));    TP3.netrad(ind) = NaN;  %TP3.H(ind) = NaN;
% ind = find((TP3.dateloc>=datetime(2004,10,5))&(TP3.dateloc<=datetime(2005,5,1)));      TP3.netrad(ind) = NaN;  %TP3.H(ind) = NaN;
% ind = find((TP3.dateloc>=datetime(2006,12,24))&(TP3.dateloc<=datetime(2006,12,28)));TP3.netrad(ind) = NaN;  %TP3.H(ind) = NaN;
% ind = find((TP3.dateloc>=datetime(2006,5,25))&(TP3.dateloc<=datetime(2006,8,25)));  TP3.netrad(ind) = NaN;  %TP3.H(ind) = NaN;
% ind = find((TP3.dateloc>=datetime(2009,5,24))&(TP3.dateloc<=datetime(2009,10,5)));  TP3.netrad(ind) = NaN;  %TP3.H(ind) = NaN;
% ind = find((TP3.dateloc>=datetime(2011,5,13))&(TP3.dateloc<=datetime(2011,5,23)));  TP3.netrad(ind) = NaN;  %TP3.H(ind) = NaN;
% ind = find((TP3.dateloc>=datetime(2009,7,19))&(TP3.dateloc<=datetime(2010,4,11)));  TP3.netrad(ind) = TP3.netrad(ind)-40;  %TP3.H(ind) = NaN;
%
% TP3.netrad(TP3.netrad==3) = NaN;%

%%
numberY = TP3.Y(end) -TP3.Y(1);
v1 = 0;         v2 = 800;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/numberY):v2;
figure('color','white');            hold on;
ik = TP3.Y(1);   count=1;     color_jet = jet(max(TP3.Y)-min(TP3.Y)+5);
while ik<TP3.Y(end)
    hl1  =  plot(TP3.par(TP3.Y == ik)./2,TP3.netrad(TP3.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TP3.par(TP3.Y == ik)./2,TP3.netrad(TP3.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('Rn');  xlabel ('PAR');

v1 = 0;         v2 = 1000;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/26):v2;
figure('color','white');            hold on;
ik = TP3.Y(1);   count=1;             color_jet = jet(max(TP3.Y)-min(TP3.Y)+1);
while ik<TP3.Y(end)
    hl1  =  plot(TP3.par(TP3.Y == ik)./2,TP3.LE(TP3.Y == ik)+TP3.H(TP3.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TP3.par(TP3.Y == ik)./2,TP3.LE(TP3.Y == ik)+TP3.H(TP3.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('H+LE (W m^-^2)');   xlabel ('Rn (W m^-^2)');
axis([v1 v2 v1 v2]); grid on; box on;

%%
color_jet = jet(7);
figure('color','white');
plot(TP3.dateloc,TP3.So./2,'Color', color_jet(1,:));      hold on
plot(TP3.dateloc,(TP3.par)./2,'Color', 'k');
plot(TP3.dateloc,TP3.netrad,'Color', color_jet(2,:));      hold on
plot(TP3.dateloc,TP3.H,'Color',color_jet(6,:));            plot(TP3.dateloc,TP3.LE,'Color',color_jet(4,:));
plot(TP3.dateloc,(TP3.H+TP3.LE),'Color', color_jet(6,:));
legend('TOA','par','net radiation','H','LE','turbulent');                                ylabel('energy flux (W m^-^2)');

[TP3.daytair,~,~,~,TP3.daydate] = AM_day(TP3.tair,TP3.dateloc,1);
% TP3.Bowen = TP3.H./TP3.LE;                              TP3.Bowen(abs(TP3.Bowen)>100) = NaN;
% figure('color','white');
% plot(TP3.dateloc,TP3.Bowen,'Color', [.3 .8 .2]);
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
scaled250m16daysEVI = readtable("/media/ncoupe/Backup/Data/Fluxnet/CA-TP3-MODIS/statistics_250m_16_days_EVI.csv", opts);
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
% % ROI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-TP3-phenocam/harvard_DB_1000_provisional_data/provisional_data/data_record_3/harvard_DB_1000_roistats.csv", opts);
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
ROI = readtable("/media/ncoupe/Backup/Data/Fluxnet/CA-TP3_phenocam/turkeypointenf74_EN_join_provisional_data/provisional_data/data_record_4/turkeypointenf74_EN_join_1day.csv", opts);
clear opts

[ROI.dayY,ROI.dayM,ROI.dayD] = datevec(ROI.daydate);

figure
plot(ROI.daydate,ROI.midday_gcc);   hold on;

cols = varfun(@isnumeric, ROI, 'OutputFormat', 'uniform');
cols(1:5) = false;  % Ignore columns 1 to 5
% % ind = find(((ROI.daydate>=datetime(2016,6,24))&(ROI.daydate<=datetime(2016,8,17))));
% % ROI{ind, cols} = NaN;
% % ind = find(((ROI.daydate>=datetime(2018,3,1))&(ROI.daydate<=datetime(2018,11,01))));
% % ROI{ind, cols} = NaN;
% % ind = find(ROI.daydate==datetime(2023,01,13));
% % ROI{ind, cols} = NaN;
% % ind = find(((ROI.daydate>=datetime(2019,5,13))&(ROI.daydate<=datetime(2019,5,14))));
% % ROI{ind, cols} = NaN;
% % ind = find(((ROI.daydate>=datetime(2019,6,06))&(ROI.daydate<=datetime(2019,06,20))));
% % ROI{ind, cols} = NaN;
% % ind = find(((ROI.daydate>=datetime(2020,2,15))&(ROI.daydate<=datetime(2020,2,19))));
% % ROI{ind, cols} = NaN;
% % ind = find(((ROI.daydate>=datetime(2020,7,17))&(ROI.daydate<=datetime(2020,7,30))));
% % ROI{ind, cols} = NaN;
% % ind = find(((ROI.daydate>=datetime(2021,01,11))&(ROI.daydate<=datetime(2021,01,20))));
% % ROI{ind, cols} = NaN;
% % ind = find(((ROI.daydate>=datetime(2021,02,11))&(ROI.daydate<=datetime(2021,06,26))));
% % ROI{ind, cols} = NaN;
% % ind = find(((ROI.daydate>=datetime(2024,06,06))&(ROI.daydate<=datetime(2024,06,15))));
% % ROI{ind, cols} = NaN;
% % ind = find(ROI.daydate==datetime(2023,01,13));
% % ROI{ind, cols} = NaN;
% % 
% % 
% % % Will remove the start of the camera it is too high
% % ind = find(ROI.daydate<datetime(2013,07,14));
% % ROI{ind, cols} = NaN;

% %% ................camera hourly .........................................
% opts = delimitedTextImportOptions("NumVariables", 40);
% opts.DataLines = [19, Inf];        opts.Delimiter = ",";
% opts.VariableNames = ["dayloc", "local_std_time", "doy", "filename", "solar_elev", "exposure", "awbflag", "mask_index", "gcc", "rcc", "r_mean", "r_std", "r_5_qtl", "r_10_qtl", "r_25_qtl", "r_50_qtl", "r_75_qtl", "r_90_qtl", "r_95_qtl", "g_mean", "g_std", "g_5_qtl", "g_10_qtl", "g_25_qtl", "g_50_qtl", "g_75_qtl", "g_90_qtl", "g_95_qtl", "b_mean", "b_std", "b_5_qtl", "b_10_qtl", "b_25_qtl", "b_50_qtl", "b_75_qtl", "b_90_qtl", "b_95_qtl", "r_g_correl", "g_b_correl", "b_r_correl"];
% opts.VariableTypes = ["datetime", "duration", "double", "string", "double", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% opts.ExtraColumnsRule = "ignore";  opts.EmptyLineRule = "read";
% opts = setvaropts(opts, "filename", "WhitespaceRule", "preserve");
% opts = setvaropts(opts, ["filename", "exposure", "awbflag"], "EmptyFieldRule", "auto");
% opts = setvaropts(opts, "dayloc", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
% opts = setvaropts(opts, "local_std_time", "InputFormat", "hh:mm:ss.S");
% ROIhour = readtable("/media/ncoupe/Backup/Data/Fluxnet/CA-TP3_phenocam/turkeypointenf74_EN_join_provisional_data/provisional_data/data_record_3/turkeypointenf74_EN_1000_roistats.csv", opts);
% 
% ROIhour.dateloc = ROIhour.dayloc + ROIhour.local_std_time;  ROIhour.dateloc.Format = 'yyyy-MM-dd HH:mm:ss';
% disp(ROIhour.dateloc(1:5))
% [ROIhour.Y,ROIhour.M,ROIhour.D,ROIhour.HR,ROIhour.MI] = datevec(ROIhour.dateloc);
% 
% JD  = day(ROIhour.dateloc,'dayofyear');
% lat = lat_FN(ip);                           lon = lon_FN(ip);
% HRMI = round(ROIhour.HR+(ROIhour.MI/60),1);
% [ROIhour.So,~,~,~,~,SolarZenithAngleDeg] = AM_solar_rad(JD,HRMI,lat,lon);
% 
% splitDate = datetime(2017, 6, 1); 
% isAfter = ROIhour.dateloc >= splitDate; isBefore = ~isAfter;
% ix = prctile(ROIhour.r_mean(isBefore),5);   iy = prctile(ROIhour.r_mean(isAfter),5);
% ROIhour.r_mean(isBefore) = ROIhour.r_mean(isBefore)+(ix-iy);
% ix = prctile(ROIhour.g_mean(isBefore),5);   iy = prctile(ROIhour.g_mean(isAfter),5);
% ROIhour.g_mean(isBefore) = ROIhour.g_mean(isBefore)+(ix-iy);
% % ix = prctile(ROIhour.b_mean(isBefore),5);   iy = prctile(ROIhour.b_mean(isAfter),5);
% % ROIhour.b_mean(isBefore) = ROIhour.b_mean(isBefore)+(ix-iy);
% 
% ROI = [];
% ind = find((ROIhour.HR>13)|(ROIhour.HR<10)|(ROIhour.So<300)|(ROIhour.b_mean>65));
% ROIhour.r_mean(ind) = NaN;    ROIhour.b_mean(ind) = NaN;   ROIhour.g_mean(ind) = NaN;
% [ROI.r_mean,~,~,~,ROI.daydate] = AM_day(ROIhour.r_mean,ROIhour.dateloc,1);
% [ROI.g_mean] = AM_day(ROIhour.g_mean,ROIhour.dateloc,1);
% [ROI.b_mean] = AM_day(ROIhour.b_mean,ROIhour.dateloc,1);
% 
% [ROI.dayY,ROI.dayM,ROI.dayD] = datevec(ROI.daydate);
% 
% ROI.rcc_mean = ROI.r_mean./(ROI.r_mean+ROI.b_mean+ROI.g_mean);
% ROI.gcc_mean = ROI.g_mean./(ROI.r_mean+ROI.b_mean+ROI.g_mean);
% ROI.GRRI_mean = ROI.g_mean./ROI.r_mean;
% ROI.cci_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
% ROI.exgreen_mean = ((2.*ROI.g_mean)-ROI.r_mean-ROI.b_mean);%./(ROI.g_mean+ROI.r_mean+ROI.b_mean);

% .........................................................................
%% Change of camera 
% .........................................................................
ROI.GRRI_mean = ROI.g_mean./ROI.r_mean;
ROI.GRIVI_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
ROI.cci_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
ROI.exgreen_mean = ((2.*ROI.g_mean)-ROI.r_mean-ROI.b_mean);%./(ROI.g_mean+ROI.r_mean+ROI.b_mean);

A = 3;
disp('Achtung change of camera or something')
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
avgOld = mean(ROI.g_mean(1:ind(1)),'omitmissing'); avgNew = mean(ROI.g_mean(ind),'omitmissing');
shiftAmount = avgOld - avgNew;  ROI.g_mean(ind) = ROI.g_mean(ind) + shiftAmount;
% ix = ROI.g_mean;     ix(ind) = smoothdata(ROI.g_mean(ind),'movmean',A) + shiftAmount;  ROI.g_mean = ix;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
avgNew = mean(ROI.g_mean(ind),'omitmissing');
shiftAmount = avgOld - avgNew;  ROI.g_mean(ind) = ROI.g_mean(ind) + shiftAmount;
% ix = ROI.g_mean;     ix(ind) = smoothdata(ROI.g_mean(ind),'movmean',A) + shiftAmount;  ROI.g_mean = ix;

ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
avgOld = mean(ROI.r_mean(1:ind(1)),'omitmissing'); avgNew = mean(ROI.r_mean(ind),'omitmissing');
shiftAmount = avgOld - avgNew;  ROI.r_mean(ind) = ROI.r_mean(ind) + shiftAmount;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
avgNew = mean(ROI.r_mean(ind),'omitmissing');
shiftAmount = avgOld - avgNew;  ROI.r_mean(ind) = ROI.r_mean(ind) + shiftAmount;

ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
avgOld = mean(ROI.b_mean(1:ind(1)),'omitmissing'); avgNew = mean(ROI.b_mean(ind),'omitmissing');
shiftAmount = avgOld - avgNew;  ROI.b_mean(ind) = ROI.b_mean(ind) + shiftAmount;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
avgNew = mean(ROI.b_mean(ind),'omitmissing');
shiftAmount = avgOld - avgNew;  ROI.b_mean(ind) = ROI.b_mean(ind) + shiftAmount;

[~,ROI.gcc_mean] = AM_spike_detection(ROI.gcc_mean,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.gcc_mean(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
% dataNew = smoothdata(ROI.gcc_mean(ind),'movmean',A);   
dataNew = ROI.gcc_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.gcc_mean(ind) = (ROI.gcc_mean(ind) - p5_New) * gain + p5_Old;
plot(ROI.daydate,ROI.gcc_mean);   hold on;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
% dataNew = smoothdata(ROI.gcc_mean(ind),'movmean',A);   
dataNew = ROI.gcc_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.gcc_mean(ind) = (ROI.gcc_mean(ind) - p5_New) * gain + p5_Old;
plot(ROI.daydate,ROI.gcc_mean);   hold on;

[~,ROI.rcc_50] = AM_spike_detection(ROI.rcc_50,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.rcc_50(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.rcc_50(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.rcc_50(ind) = (ROI.rcc_50(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.rcc_50(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.rcc_50(ind) = (ROI.rcc_50(ind) - p5_New) * gain + p5_Old;

[~,ROI.rcc_75] = AM_spike_detection(ROI.rcc_75,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.rcc_75(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.rcc_75(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.rcc_75(ind) = (ROI.rcc_75(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.rcc_75(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.rcc_75(ind) = (ROI.rcc_75(ind) - p5_New) * gain + p5_Old;

[~,ROI.rcc_mean] = AM_spike_detection(ROI.rcc_mean,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.rcc_mean(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.rcc_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.rcc_mean(ind) = (ROI.rcc_mean(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.rcc_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.rcc_mean(ind) = (ROI.rcc_mean(ind) - p5_New) * gain + p5_Old;

[~,ROI.midday_g] = AM_spike_detection(ROI.midday_g,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.midday_g(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.midday_g(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.midday_g(ind) = (ROI.midday_g(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.midday_g(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.midday_g(ind) = (ROI.midday_g(ind) - p5_New) * gain + p5_Old;

[~,ROI.midday_r] = AM_spike_detection(ROI.midday_r,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.midday_r(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.midday_r(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.midday_r(ind) = (ROI.midday_r(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.midday_r(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.midday_r(ind) = (ROI.midday_r(ind) - p5_New) * gain + p5_Old;

[~,ROI.midday_b] = AM_spike_detection(ROI.midday_b,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.midday_b(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.midday_b(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.midday_b(ind) = (ROI.midday_b(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.midday_b(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.midday_b(ind) = (ROI.midday_b(ind) - p5_New) * gain + p5_Old;

[~,ROI.midday_gcc] = AM_spike_detection(ROI.midday_gcc,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.midday_gcc(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.midday_gcc(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.midday_gcc(ind) = (ROI.midday_gcc(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.midday_gcc(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.midday_gcc(ind) = (ROI.midday_gcc(ind) - p5_New) * gain + p5_Old;

[~,ROI.GRIVI_mean] = AM_spike_detection(ROI.GRIVI_mean,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.GRIVI_mean(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.GRIVI_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.GRIVI_mean(ind) = (ROI.GRIVI_mean(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.GRIVI_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.GRIVI_mean(ind) = (ROI.GRIVI_mean(ind) - p5_New) * gain + p5_Old;

ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
hold on; plot(ROI.daydate,ROI.gcc_50);
hold on; xline(ind(1), '--r', 'Instrument Change');
plot(ROI.daydate,ROI.gcc_mean,'k');
hold on; xline(ind(end), '--r', 'Instrument Change');

figure('color','white');
plot(ROI.daydate,ROI.GRRI_mean);   hold on;
[~,ROI.GRRI_mean] = AM_spike_detection(ROI.GRRI_mean,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.GRRI_mean(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.GRRI_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.GRRI_mean(ind) = (ROI.GRRI_mean(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.GRRI_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.GRRI_mean(ind) = (ROI.GRRI_mean(ind) - p5_New) * gain + p5_Old;
plot(ROI.daydate,ROI.GRRI_mean);   hold on;

figure('Color','white')
plot(ROI.daydate,ROI.cci_mean);   hold on;
[~,ROI.cci_mean] = AM_spike_detection(ROI.cci_mean,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.cci_mean(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.cci_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.cci_mean(ind) = (ROI.cci_mean(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.cci_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.cci_mean(ind) = (ROI.cci_mean(ind) - p5_New) * gain + p5_Old;
plot(ROI.daydate,ROI.cci_mean);   hold on;

[~,ROI.exgreen_mean] = AM_spike_detection(ROI.exgreen_mean,3);
ind = find((ROI.daydate>datetime(2017,07,1)) & (ROI.daydate<datetime(2018,07,1)));
dataOld = ROI.exgreen_mean(1:ind(1));      p5_Old = prctile(dataOld, 5);  p95_Old = prctile(dataOld, 95);
dataNew = ROI.exgreen_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.exgreen_mean(ind) = (ROI.exgreen_mean(ind) - p5_New) * gain + p5_Old;
ind = find((ROI.daydate>datetime(2018,07,1)) & (ROI.daydate<datetime(2025,07,1)));
dataNew = ROI.exgreen_mean(ind);           p5_New = prctile(dataNew, 5);  p95_New = prctile(dataNew, 95);
gain = (p95_Old - p5_Old) / (p95_New - p5_New);    
ROI.exgreen_mean(ind) = (ROI.exgreen_mean(ind) - p5_New) * gain + p5_Old;

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
% % LAIlph = readtimetable("/home/ncoupe/Documents/Fluxnet/US-TP3/LAI/hf150-02-lph-lai.csv", opts, "RowTimes", "datetime");
% %
% % opts = delimitedTextImportOptions("NumVariables", 8);
% % opts.DataLines = [2, Inf];           opts.Delimiter = ",";
% % opts.VariableNames = ["datetime", "dateloc", "doy", "time", "distance", "transect", "lai_masked", "sel"];
% % opts.VariableTypes = ["datetime", "datetime", "double", "datetime", "double", "double", "double", "double"];
% % opts.ExtraColumnsRule = "ignore";    opts.EmptyLineRule = "read";
% % opts = setvaropts(opts, "datetime", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "dateloc", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "time", "InputFormat", "hh:mm:ss.S");
% % LAIhem = readtimetable("/home/ncoupe/Documents/Fluxnet/US-TP3/LAI/hf150-01-hem-lai.csv", opts, "RowTimes", "datetime");
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
% % LAIsite = readtable("/home/ncoupe/Documents/Fluxnet/US-TP3/LAI/hf069-02-lai-site.csv", opts);
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
LAIsite.daydate = TP3.daydate;
LAIsite.all_mean = 4.*ones(length(TP3.daydate),1);

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
% NDVI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-TP3-geonex/NDVI.csv/NDVI.csv", opts);
% clear opts

%% Add Daymet
TP3.par_day = TP3.par;        TP3.par_day(TP3.So<tresholdSo) = NaN;
[TP3.dayPAR,~,ix,~,TP3.daydate] = AM_day(TP3.par,TP3.dateloc,0);   TP3.dayPAR(ix<21) = NaN;
[TP3.dayPARday,~,ix] = AM_day(TP3.par_day,TP3.dateloc,0);        TP3.dayPARday(ix<6) = NaN;

TP3.tairday = TP3.tair;      TP3.tairday(TP3.So<tresholdSo) = NaN;
[TP3.daytairday,~,ix,~,~,TP3.daytairdaymin,TP3.daytairdaymax] = AM_day(TP3.tairday,TP3.dateloc,0);
TP3.daytairday(ix<tresholdCycleDay) = NaN;      TP3.daytairdaymin(ix<tresholdCycleDay) = NaN;         TP3.daytairdaymax(ix<tresholdCycleDay) = NaN;
[TP3.dayY,TP3.dayM,~] = datevec(TP3.daydate);

%%
FolderDaymet = '/media/ncoupe/Backup/Data/Fluxnet/daymet/';
opts = delimitedTextImportOptions('NumVariables', 9);
opts.DataLines = [10, Inf];    opts.Delimiter = ',';
opts.VariableNames = ["year", "yday", "dayl_s", "prcp_mm_day", "srad_W_m_2", "swe_kg_m_2", "tmax_degC", "tmin_degC", "vp_Pa"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = 'ignore';    opts.EmptyLineRule = 'read';
% opts = setvaropts(opts, ['year', 'yday', 'dayl_s', 'prcp_mm_day', 'srad_W_m_2', 'swe_kg_m_2', 'tmax_degC', 'tmin_degC', 'vp_Pa'], 'WhitespaceRule', 'preserve');
% opts = setvaropts(opts, ['year', 'yday', 'dayl_s', 'prcp_mm_day', 'srad_W_m_2', 'swe_kg_m_2', 'tmax_degC', 'vp_Pa'], 'EmptyFieldRule', 'auto');
daymet = readtable([FolderDaymet 'TP3_11934_lat_42.5378_lon_-72.1715_2026-06-02_205736.csv'], opts);
clear opts

daymet.dayPARday = daymet.srad_W_m_2.*2;
daymet.daydate   = datetime(daymet.year,1,daymet.yday);
daymet.daytairday = (daymet.tmax_degC+daymet.tmin_degC)./2;

%% Add CERES
FolderCERES = '/media/ncoupe/Backup/Data/Fluxnet/CERES/';
    CERES = struct();
    filename = [FolderCERES 'TP3_CERES_SYN1deg-Day_Terra-Aqua-NOAA20_Ed4.2_Subset_20000301-20251231.nc'];
    fileInfo = ncinfo(filename);
    variableNames = {fileInfo.Variables.Name}';
    disp('*** Variable Names in CERES NetCDF File ***');
    disp(variableNames);
    fprintf('***                                                   ***\n');

    CERES.Variables(1).Name = "time";
    ix = ncread(filename, "/time");     %'days since 2000-03-01 00:00:00'
    CERES.daydate = datetime(2000,03,01) + days(reshape(ix,[],1));

    CERES.Variables(2).Name = "adj_atmos_sw_up_all_toa_daily";
    ix = ncread(filename, "/adj_atmos_sw_up_all_toa_daily");
    CERES.SWupTOA = reshape(ix,[],1);

    CERES.Variables(3).Name = "adj_atmos_sw_up_all_surface_daily";
    ix = ncread(filename, "/adj_atmos_sw_up_all_surface_daily");
    CERES.SWup = reshape(ix,[],1);

    CERES.Variables(4).Name = "adj_atmos_sw_down_all_toa_daily";
    ix = ncread(filename, "/adj_atmos_sw_down_all_toa_daily");
    CERES.SWdownTOA = reshape(ix,[],1);

    CERES.Variables(5).Name = "adj_atmos_sw_down_all_surface_daily";
    ix = ncread(filename, "/adj_atmos_sw_down_all_surface_daily");
    CERES.SWdown = reshape(ix,[],1);

    CERES.Variables(6).Name = "adj_atmos_lw_up_all_toa_daily";
    ix = ncread(filename, "/adj_atmos_lw_up_all_toa_daily");
    CERES.LWupTOA = reshape(ix,[],1);

    CERES.Variables(7).Name = "adj_atmos_lw_up_all_surface_daily";
    ix = ncread(filename, "/adj_atmos_lw_up_all_surface_daily");
    CERES.LWup = reshape(ix,[],1);

    CERES.Variables(8).Name = "adj_atmos_lw_down_all_toa_daily";
    ix = ncread(filename, "/adj_atmos_lw_down_all_toa_daily");
    CERES.LWdownTOA = reshape(ix,[],1);

    CERES.Variables(9).Name = "adj_atmos_lw_down_all_surface_daily";
    ix = ncread(filename, "/adj_atmos_lw_down_all_surface_daily");
    CERES.LWdown = reshape(ix,[],1);

    % CERES.Variables(10).Name = "adj_sfc_sw_direct_all_daily";
    % ix = ncread(filename, "/adj_sfc_sw_direct_all_daily");
    % CERES.SWdirect = reshape(ix,[],1);
    %
    % CERES.Variables(11).Name = "adj_sfc_sw_diff_all_daily";
    % ix = ncread(filename, "/adj_sfc_sw_diff_all_daily");
    % CERES.SWdiff = reshape(ix,[],1);
    %
    CERES.Variables(12).Name = "adj_sfc_par_direct_all_daily";
    ix = ncread(filename, "/adj_sfc_par_direct_all_daily");
    CERES.PARdirect = reshape(ix,[],1);

    CERES.Variables(13).Name = "adj_sfc_par_diff_all_daily";
    ix = ncread(filename, "/adj_sfc_par_diff_all_daily");
    CERES.PARdiff = reshape(ix,[],1);

    CERES.dayPAR = CERES.PARdiff+CERES.PARdirect;
    clear filename

    CERES.dayPAR = CERES.dayPAR.*4.75;     % from W m-2 to umol m-2 s-1
    CERES.dayJD = day(CERES.daydate,'dayofyear');
    [CERES.daySo,~,CERES.daylyDayLength] = AM_solar_rad(CERES.dayJD,(CERES.dayJD.*0)+12,lat,lon);
    % Daytime SW Flux = Daily Average SW Flux\Fraction of Day that is Sunlit
    CERES.dayPARday = CERES.dayPAR./(CERES.daylyDayLength./24);

    %%
    figure('color','white');
    subplot(1,2,1);plot(CERES.daydate,CERES.dayPARday);   hold on;
    plot(daymet.daydate,daymet.dayPARday);   
    plot(TP3.daydate,TP3.dayPARday,'c'); ylabel('PAR_{day}');
    legend('CERES','DAYMET','tower')
    subplot(1,2,2);plot(daymet.daydate,daymet.tmax_degC ,'k');  hold on;
    plot(daymet.daydate,daymet.daytairday ,'m');
    plot(TP3.daydate,TP3.daytairday,'b');
    legend('DAYMET_{max}','DAYMET','tower'); ylabel('T_{air}_{day}');
%%
TP3.METEOdaytairmax = interp1(daymet.daydate,daymet.tmax_degC,TP3.daydate);
TP3.METEOdaytairday = interp1(daymet.daydate,daymet.daytairday,TP3.daydate);
TP3.CERESdayPARday = interp1(CERES.daydate,CERES.dayPARday,TP3.daydate);
TP3.METEOdayPARday = interp1(daymet.daydate,daymet.dayPARday,TP3.daydate);

v1 = 0;         v2 = 1000;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/(max(TP3.Y)-min(TP3.Y)+1)):v2;
figure('color','white');
subplot(1,2,1); hold on;
ik = TP3.dayY(1);   count=1;          color_jet = jet(max(TP3.dayY)-min(TP3.dayY)+1);
while ik<TP3.dayY(end)
    hl1  =  plot(TP3.dayPARday(TP3.dayY == ik),TP3.CERESdayPARday(TP3.dayY == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    [r2] = AM_compute_regression(TP3.dayPARday(TP3.dayY == ik),TP3.CERESdayPARday(TP3.dayY == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(r2),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('PAR_{day} CERES');  xlabel ('PAR_{day} obs');

subplot(1,2,2);   hold on;
ik = TP3.dayY(1);   count=1;          color_jet = jet(max(TP3.dayY)-min(TP3.dayY)+1);
while ik<TP3.dayY(end)
    hl1  =  plot(TP3.dayPARday(TP3.dayY == ik),TP3.METEOdayPARday(TP3.dayY == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    [r2] = AM_compute_regression(TP3.dayPARday(TP3.dayY == ik),TP3.METEOdayPARday(TP3.dayY == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(r2),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('PAR_{day} Daymet');  xlabel ('PAR_{day} obs');

v1 = -10;         v2 = 30;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/(max(TP3.Y)-min(TP3.Y)+1)):v2;
figure('color','white');
subplot(1,2,1); hold on;
ik = TP3.dayY(1);   count=1;          color_jet = jet(max(TP3.dayY)-min(TP3.dayY)+1);
while ik<TP3.dayY(end)
    hl1  =  plot(TP3.daytairday(TP3.dayY == ik),TP3.METEOtairday(TP3.dayY == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    [r2] = AM_compute_regression(TP3.daytairday(TP3.dayY == ik),TP3.METEOtairday(TP3.dayY == ik),color_jet(count,:),1);
    plot(-25,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (-20,v4(count),num2str(r2),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('tair_{day} Daymet');  xlabel ('PAR_{day} obs');


% save('TP3.mat','TP3');
% save('matlabTP3.mat');