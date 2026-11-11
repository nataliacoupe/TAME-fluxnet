%Reads Harvard data. However, it will read any Fluxnet mat file
%Natalia Restrepo Coupe, at UTS
%Feb 5, 2014
%My beautiful Sydney
%% Giovanni -72.172,42.537,-72.171,42.538
%..........................................................................................****
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;
parpool;

FolderName = '/home/ncoupe/Documents/Fluxnet/';

[site_name_FN, lat_FN, lon_FN, site_long_FN, year_ini_FN, year_end_FN, siteelevation_FN, height_FN, ust_tresh_FN, sunrise_FN, sunset_FN, utm_FN, ust_min_FN, ust_max_FN, tree_height_FN, LAI_FN, Biome_FN] =...
    textread([FolderName 'sites_loc.txt'], '%s	%f	%f	%s	%f	%f	%f %f	%f	%f	%f	%f	%f	%f	%f  %f %f',...
    'headerlines',1);

ip = 13;
lat = lat_FN(ip);             lon = lon_FN(ip);             height = height_FN(ip);      
site_name = site_name_FN(ip); ust_tresh = ust_tresh_FN(ip); utm = utm_FN(ip);

% .........................................................................
%% TPD
% .........................................................................
opts = delimitedTextImportOptions("NumVariables", 78);
opts.DataLines = [4, Inf];          opts.Delimiter = ",";
opts.VariableNames = ["TIMESTAMP_START", "TIMESTAMP_END", "NEE_PI", "FC", "LE", "H", "USTAR", "SC", "CO2_1_1_1", "CO2_1_2_1", "LE_PI_F", "H_PI_F", "H2O_PI_F", "SH_PI_F", "G_PI_F_1", "NETRAD", "PPFD_IN", "PPFD_OUT", "PPFD_BC_IN", "SW_IN", "SW_OUT", "LW_IN", "LW_OUT", "TA", "RH", "WS", "WD", "PA", "P_RAIN", "D_SNOW", "TS_1_1_1", "TS_1_2_1", "TS_1_3_1", "TS_1_4_1", "TS_1_5_1", "TS_1_6_1", "TS_2_1_1", "TS_2_2_1", "TS_2_3_1", "TS_2_4_1", "TS_2_5_1", "TS_2_6_1", "SWC_1_1_1", "SWC_1_2_1", "SWC_1_3_1", "SWC_1_4_1", "SWC_1_5_1", "SWC_1_6_1", "SWC_2_1_1", "SWC_2_2_1", "SWC_2_3_1", "SWC_2_4_1", "SWC_2_5_1", "SWC_2_6_1", "G_1_1_1", "G_2_1_1", "G_3_1_1", "G_4_1_1", "TA_PI_F", "RH_PI_F", "PPFD_IN_PI_F", "WS_PI_F", "PA_PI_F", "NETRAD_PI_F", "SW_IN_PI_F", "TS_PI_F_1", "TS_PI_F_2", "TS_PI_F_3", "TS_PI_F_4", "TS_PI_F_5", "TS_PI_F_6", "P_PI_F", "W_SIGMA", "V_SIGMA", "GPP_PI_F", "RECO_PI_F", "NEE_PI_F", "VPD_PI_F"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";   opts.EmptyLineRule = "read";
TPDtable = readtable("/media/ncoupe/Backup/Data/Fluxnet/AMF_CA-TPD_BASE-BADM_3-5/AMF_CA-TPD_BASE_HH_3-5.csv", opts);
clear opts

Y = floor(TPDtable.TIMESTAMP_START./10^8);    M = floor((TPDtable.TIMESTAMP_START-Y.*10^8)./10^6);
D = floor((TPDtable.TIMESTAMP_START-(Y.*10^8)-(M.*10^6))./10^4);
HR = floor((TPDtable.TIMESTAMP_START-(Y.*10^8)-(M.*10^6)-(D.*10^4))./10^2);
TPDtable.dateloc = datetime(Y,M,D,HR,0,0);

for ik = 1:width(TPDtable)-1
    ij = TPDtable{:,ik};       ij(ij == -9999.)  = NaN;         ij(ij == 9999.)  = NaN;  
    % ij(ind) = NaN;
    ij(ismissing(ij)) = NaN;   TPDtable{:,ik}   = ij;
end

data = TPDtable;     [~, idx] = unique(data(:,"dateloc"),'stable');   TPDtable = data(idx,:);
data = sortrows( TPDtable, 'dateloc');                                

data = table2timetable(data);
TPDtable = retime(data, TPDtable.dateloc, 'mean');
% TPD = timetable2table(TPDtable);

% commonVars = intersect(TPDtable.Properties.VariableNames, TPDtable.Properties.VariableNames);
% TPDtable = removevars(TPDtable, commonVars);
% TPDtable.dateloc = TPDtable.dateloc;

% TPDjoin = join(TPDtable,TPDtable);
TPDjoin = TPDtable;

% figure('color','white')
% plot(TPDjoin.dateloc,TPDjoin.SWC_7_1_1);  hold on;
% plot(TPDjoin.dateloc,TPDjoin.SWC_7_2_1)
% plot(TPDjoin.dateloc,TPDjoin.SWC_7_3_1)
% plot(TPDjoin.dateloc,TPDjoin.SWC_7_4_1)

%% ..............................................................................................................................................
TPD.dateloc = TPDjoin.dateloc;    
[TPD.Y,TPD.M,TPD.D,TPD.HR,~,~] =datevec(TPD.dateloc);
TPD.dateloc_day = datetime(TPD.Y,TPD.M,TPD.D);
TPD.JD = day(TPD.dateloc,'dayofyear');

TPD.So = AM_solar_rad(TPD.JD,TPD.HR,lat,lon);

%% ......................................................................................
TPD.co2 = TPDjoin.CO2_1_1_1;
TPD.h2o = TPDjoin.H2O_PI_F;
TPD.VPD = TPDjoin.VPD_PI_F;

TPD.Fc = TPDjoin.FC;
TPD.Sco2 = TPDjoin.SC;
TPD.LE = TPDjoin.LE_PI_F;    %TPD.LE (TPDjoin.LE_F_MDS_QC>2) = NaN;
TPD.H = TPDjoin.H_PI_F;           %TPD.H (TPDjoin.H_F_MDS_QC>2) = NaN;
TPD.netrad = TPDjoin.NETRAD;      TPD.ustar = TPDjoin.USTAR;    
TPD.rain = TPDjoin.P_PI_F;        TPD.par = TPDjoin.PPFD_IN;        TPD.G = NaN(length(TPDjoin.dateloc),1);
TPD.tair = TPDjoin.TA;            TPD.ws = TPDjoin.WS;              TPD.VPD = TPDjoin.VPD_PI_F;
TPD.RH = TPDjoin.RH_PI_F;         TPD.pambKpa = TPDjoin.PA_PI_F;  
TPD.pambpa = TPD.pambKpa./1000;
TPD.fh2o = TPDjoin.SH_PI_F;       %TPD.fh2o (TPDjoin.LE_F_MDS_QC>2) = NaN;
TPD.h2ommolm = TPDjoin.H2O_PI_F;  
% TPD.nee = TPDjoin.NEE_CUT_REF;  TPD.nee(TPDjoin.NEE_CUT_REF_QC>2) = NaN;
% TPD.nee = TPDjoin.NEE_CUT_REF;  TPD.nee(TPDjoin.NEE_CUT_REF_QC>2) = NaN;
TPD.nee = TPD.Fc+TPD.Sco2;        %TPD.nee(TPDjoin.NEE_VUT_REF_QC>2) = NaN;
TPD.reco = TPDjoin.RECO_PI_F;     %TPD.gep(TPDjoin.NEE_VUT_REF_QC>2) = NaN;
% TPD.gep = TPDjoin.GPP_PI_F;     %TPD.gep(TPDjoin.NEE_VUT_REF_QC>2) = NaN;
TPD.gep  = -TPD.nee+TPD.reco;      TPD.gep(TPD.gep==0)=NaN;
TPD.gep((TPD.So==0)&(TPD.gep>5))=NaN; TPD.gep((TPD.So>0)&(TPD.gep<-3))=NaN;

TPD.nee(TPD.rain>0) = NaN;     TPD.reco(TPD.rain>0) = NaN;  TPD.gep(TPD.rain>0) = NaN;   
TPD.Fc(TPD.rain>0) = NaN;      TPD.LE(TPD.rain>0) = NaN;    TPD.H(TPD.rain>0) = NaN;   

ix = [NaN;diff(TPD.LE)];       TPD.LE(ix==0) = NaN;            TPD.LE(TPD.LE==0) = NaN;
TPD.LE(TPD.LE>900) = NaN;      TPD.H(TPD.H>900) = NaN;
TPD.LE(TPD.rain>0) = NaN;      TPD.H(TPD.rain>0) = NaN;
TPD.netrad((TPD.So<100)&(TPD.netrad>200)) = NaN;
TPD.netrad(TPD.netrad>800) = NaN;

%%
v1 = 0;         v2 = 800;      v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/26):v2;
figure('color','white');       hold on;
ik = TPD.Y(1);   count=1;      color_jet = jet(max(TPD.Y)-min(TPD.Y)+1);
while ik<TPD.Y(end)
    hl1  =  plot(TPD.par(TPD.Y == ik)./2,TPD.netrad(TPD.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TPD.par(TPD.Y == ik)./2,TPD.netrad(TPD.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('Rn');  xlabel ('PAR');

v1 = 0;         v2 = 800;      v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/26):v2;
figure('color','white');       hold on;
ik = TPD.Y(1);   count=1;      color_jet = jet(max(TPD.Y)-min(TPD.Y)+1);
while ik<TPD.Y(end)
    hl1  =  plot(TPD.netrad(TPD.Y == ik),TPD.LE(TPD.Y == ik)+TPD.H(TPD.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TPD.netrad(TPD.Y == ik),TPD.LE(TPD.Y == ik)+TPD.H(TPD.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('H+LE');  xlabel ('Rn');

% %% ......................................................................................
% ind = find((TPD.dateloc>=datetime(2009,4,10))&(TPD.dateloc<=datetime(2012,4,10)));      TPD.netrad(ind) = TPD.netrad(ind) -30;  %TPD.H(ind) = NaN;
% % ind = find((TPD.dateloc>=datetime(2010,4,10))&(TPD.dateloc<=datetime(2012,4,10)));      TPD.netrad(ind) = TPD.netrad(ind) -30;  %TPD.H(ind) = NaN;
% 
% ind = find((TPD.dateloc>=datetime(2006,8,24))&(TPD.dateloc<=datetime(2006,9,21)));      TPD.LE(ind) = NaN;  %TPD.H(ind) = NaN;
% ind = find((TPD.dateloc>=datetime(2008,6,25))&(TPD.dateloc<=datetime(2008,8,12)));      TPD.LE(ind) = NaN;  %TPD.H(ind) = NaN;
% ind = find((TPD.dateloc>=datetime(2009,6,22))&(TPD.dateloc<=datetime(2009,7,15)));      TPD.LE(ind) = NaN;  %TPD.H(ind) = NaN;
% ind = find((TPD.dateloc>=datetime(2009,7,19))&(TPD.dateloc<=datetime(2009,8,13)));      TPD.LE(ind) = NaN;  %TPD.H(ind) = NaN;
% 
% ind = find((TPD.dateloc>=datetime(2019,1,30))&(TPD.dateloc<=datetime(2019,2,2)));      TPD.H(ind) = NaN;  %TPD.H(ind) = NaN;
% 
% ind = find((TPD.dateloc>=datetime(2001,6,20))&(TPD.dateloc<=datetime(2001,6,28)));    TPD.netrad(ind) = NaN;  %TPD.H(ind) = NaN;
% ind = find((TPD.dateloc>=datetime(2004,10,5))&(TPD.dateloc<=datetime(2005,5,1)));      TPD.netrad(ind) = NaN;  %TPD.H(ind) = NaN;
% ind = find((TPD.dateloc>=datetime(2006,12,24))&(TPD.dateloc<=datetime(2006,12,28)));TPD.netrad(ind) = NaN;  %TPD.H(ind) = NaN;
% ind = find((TPD.dateloc>=datetime(2006,5,25))&(TPD.dateloc<=datetime(2006,8,25)));  TPD.netrad(ind) = NaN;  %TPD.H(ind) = NaN;
% ind = find((TPD.dateloc>=datetime(2009,5,24))&(TPD.dateloc<=datetime(2009,10,5)));  TPD.netrad(ind) = NaN;  %TPD.H(ind) = NaN;
% ind = find((TPD.dateloc>=datetime(2011,5,13))&(TPD.dateloc<=datetime(2011,5,23)));  TPD.netrad(ind) = NaN;  %TPD.H(ind) = NaN;
% ind = find((TPD.dateloc>=datetime(2009,7,19))&(TPD.dateloc<=datetime(2010,4,11)));  TPD.netrad(ind) = TPD.netrad(ind)-40;  %TPD.H(ind) = NaN;
% 
% TPD.netrad(TPD.netrad==3) = NaN;%

%%
numberY = TPD.Y(end) -TPD.Y(1);
v1 = 0;         v2 = 800;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/numberY):v2;
figure('color','white');            hold on;
ik = TPD.Y(1);   count=1;     color_jet = jet(max(TPD.Y)-min(TPD.Y)+5);
while ik<TPD.Y(end)
    hl1  =  plot(TPD.par(TPD.Y == ik)./2,TPD.netrad(TPD.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TPD.par(TPD.Y == ik)./2,TPD.netrad(TPD.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('Rn');  xlabel ('PAR');

v1 = 0;         v2 = 1000;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/26):v2;
figure('color','white');            hold on;
ik = TPD.Y(1);   count=1;             color_jet = jet(max(TPD.Y)-min(TPD.Y)+1);
while ik<TPD.Y(end)
    hl1  =  plot(TPD.par(TPD.Y == ik)./2,TPD.LE(TPD.Y == ik)+TPD.H(TPD.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(TPD.par(TPD.Y == ik)./2,TPD.LE(TPD.Y == ik)+TPD.H(TPD.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('H+LE (W m^-^2)');   xlabel ('Rn (W m^-^2)');
axis([v1 v2 v1 v2]); grid on; box on;

%%
color_jet = jet(7);
figure('color','white');
plot(TPD.dateloc,TPD.So./2,'Color', color_jet(1,:));      hold on
plot(TPD.dateloc,(TPD.par)./2,'Color', 'k');
plot(TPD.dateloc,TPD.netrad,'Color', color_jet(2,:));      hold on
plot(TPD.dateloc,TPD.H,'Color',color_jet(6,:));              plot(TPD.dateloc,TPD.LE,'Color',color_jet(4,:));
plot(TPD.dateloc,(TPD.H+TPD.LE),'Color', color_jet(6,:));
legend('TOA','par','net radiation','H','LE','turbulent');                                ylabel('energy flux (W m^-^2)');
%
% TPD.Bowen = TPD.H./TPD.LE;                              TPD.Bowen(abs(TPD.Bowen)>100) = NaN;
TPD.recurrent_nee = AM_cycle_repeat(TPD.nee,TPD.dateloc);
figure('color','white');
plot(TPD.dateloc,TPD.So./150,'Color', [.3 .2 .8]);
hold on
plot(TPD.dateloc,TPD.recurrent_nee,'Color', [.9 .0 .0]);
plot(TPD.dateloc,TPD.nee,'Color', [.8 .5 .2]);
[TPD.daytair,~,~,~,TPD.daydate] = AM_day(TPD.tair,TPD.dateloc,1);

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
scaled250m16daysEVI = readtable("/media/ncoupe/Backup/Data/Fluxnet/CA-TPD-MODIS/filtered_scaled_250m_16_days_EVI.csv", opts);
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
% % ROI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-TPD-phenocam/harvard_DB_1000_provisional_data/provisional_data/data_record_3/harvard_DB_1000_roistats.csv", opts);
opts = delimitedTextImportOptions("NumVariables", 49);
opts.DataLines = [26, Inf];           opts.Delimiter = ",";
opts.VariableNames = ["daydate", "year", "doy", "image_count", "midday_filename", "midday_r", "midday_g", "midday_b", "midday_gcc", "midday_rcc", "r_mean", "r_std", "g_mean", "g_std", "b_mean", "b_std", "gcc_mean", "gcc_std", "gcc_50", "gcc_75", "gcc_90", "rcc_mean", "rcc_std", "rcc_50", "rcc_75", "rcc_90", "max_solar_elev", "snow_flag", "outlierflag_gcc_mean", "outlierflag_gcc_50", "outlierflag_gcc_75", "outlierflag_gcc_90", "smooth_gcc_mean", "smooth_gcc_50", "smooth_gcc_75", "smooth_gcc_90", "smooth_rcc_mean", "smooth_rcc_50", "smooth_rcc_75", "smooth_rcc_90", "smooth_ci_gcc_mean", "smooth_ci_gcc_50", "smooth_ci_gcc_75", "smooth_ci_gcc_90", "smooth_ci_rcc_mean", "smooth_ci_rcc_50", "smooth_ci_rcc_75", "smooth_ci_rcc_90", "int_flag"];
opts.VariableTypes = ["datetime", "double", "double", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";     opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["midday_filename", "snow_flag"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "daydate", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
opts = setvaropts(opts, "int_flag", "TrimNonNumeric", true);
opts = setvaropts(opts, "int_flag", "ThousandsSeparator", ",");
ROItmp1 = readtable("/media/ncoupe/Backup/Data/Fluxnet/CA-TPD_phenocam/turkeypointdbf_DB_1000_provisional_data/provisional_data/data_record_4/turkeypointdbf_DB_1000_1day.csv", opts);

% ROItmp2 = readtable("/media/ncoupe/Backup/Data/Fluxnet/CA-TPD_phenocam/turkeypointdbf_DB_2000_provisional_data/provisional_data/data_record_4/turkeypointdbf_DB_2000_1day.csv", opts);
ROItmp2 = ROItmp1(end,:);

clear opts

data = ROItmp1;     
[~, idx] = unique(data(:,'daydate'),'stable');   ROItmp1 = data(idx,:);
data = sortrows( ROItmp1, 'daydate');
ROItmp1 = table2timetable(ROItmp1);

data = ROItmp2;     [~, idx] = unique(data(:,'daydate'),'stable');   ROItmp2 = data(idx,:);
data = sortrows( ROItmp2, 'daydate');
ROItmp2 = table2timetable(ROItmp2);

% commonVars = intersect(ROItmp1.Properties.VariableNames, ROItmp2.Properties.VariableNames);
% ROItmp2 = removevars(ROItmp2, commonVars);
ROItmp = [ROItmp1;ROItmp2];
ROItmp = sortrows(ROItmp, 'daydate');
fullTime = (ROItmp.daydate(1):days(1):ROItmp.daydate(end))';
ROI = retime(ROItmp, fullTime, 'fillwithmissing');

% Will remove the november-december 2011 and just leave the 2012 onwards
figure
plot(ROI.daydate,ROI.midday_r);          hold on
startDate = datetime(2011,1,1);          endDate   = datetime(2012,1,1);
toRemove = timerange(startDate,endDate); ROI(toRemove,:) = [];

plot(ROI.daydate,ROI.midday_r);          hold on
startDate = datetime(2017,11,12);        endDate   = datetime(2020,01,01);
toRemove = timerange(startDate,endDate); ROI(toRemove,:) = [];
startDate = datetime(2024,06,15);        endDate   = datetime(2024,09,05);
toRemove = timerange(startDate,endDate); ROI(toRemove,:) = [];
startDate = datetime(2025,08,01);        endDate   = datetime(2027,01,01);
toRemove = timerange(startDate,endDate); ROI(toRemove, :) = [];
plot(ROI.daydate,ROI.midday_r,'k');          ylabel('Red')

% ind = find(((ROI.daydate>=datetime(2018,5,23))&(ROI.daydate<=datetime(2018,7,7)))|...
%     ((ROI.daydate>=datetime(2018,8,27))&(ROI.daydate<=datetime(2018,11,10))));
% ROI.gcc_mean(ind) = NaN;
[ROI.dayY,ROI.dayM,ROI.dayD] = datevec(ROI.daydate);

% .........................................................................
%% Change of camera 
%% We will use only camera 1
% .........................................................................
figure
plot(ROI.daydate,ROI.midday_gcc);
 
% % display ('Achtung change of camera')
% % ind = find(ROI.daydate>datetime(2020,1,1), 1, 'first');
% % avgOld = mean(ROI.g_mean(1:ind),'omitmissing'); avgNew = mean(ROI.g_mean(ind:end),'omitmissing');
% % shiftAmount = avgOld - avgNew;
% % ix = ROI.g_mean;     ix(ind+1:end) = ROI.g_mean(ind+1:end) + shiftAmount;  ROI.g_mean = ix;
% % 
% % avgOld = mean(ROI.r_mean(1:ind),'omitmissing'); avgNew = mean(ROI.r_mean(ind:end),'omitmissing');
% % shiftAmount = avgOld - avgNew;
% % ix = ROI.r_mean;     ix(ind+1:end) = ROI.r_mean(ind+1:end) + shiftAmount;  ROI.r_mean = ix;
% % 
% % avgOld = mean(ROI.b_mean(1:ind),'omitmissing'); avgNew = mean(ROI.b_mean(ind:end),'omitmissing');
% % shiftAmount = avgOld - avgNew;
% % ix = ROI.b_mean;     ix(ind+1:end) = ROI.b_mean(ind+1:end) + shiftAmount;  ROI.b_mean = ix;
% % 
% % avgOld = mean(ROI.gcc_mean(1:ind),'omitmissing'); avgNew = mean(ROI.gcc_mean(ind:end),'omitmissing');
% % shiftAmount = avgOld - avgNew;
% % ix = ROI.gcc_mean;     ix(ind+1:end) = ROI.gcc_mean(ind+1:end) + shiftAmount;  ROI.gcc_mean = ix;
% % 
% % avgOld = mean(ROI.rcc_mean(1:ind),'omitmissing'); avgNew = mean(ROI.rcc_mean(ind:end),'omitmissing');
% % shiftAmount = avgOld - avgNew;
% % ix = ROI.rcc_mean;     ix(ind+1:end) = ROI.rcc_mean(ind+1:end) + shiftAmount;  ROI.rcc_mean = ix;
% % avgOld = mean(ROI.midday_rcc(1:ind),'omitmissing'); avgNew = mean(ROI.midday_rcc(ind:end),'omitmissing');
% % shiftAmount = avgOld - avgNew;
% % ix = ROI.midday_rcc;     ix(ind+1:end) = ROI.midday_rcc(ind+1:end) + shiftAmount;  ROI.midday_rcc = ix;
% % 
% % avgOld = mean(ROI.midday_g(1:ind),'omitmissing'); avgNew = mean(ROI.midday_g(ind:end),'omitmissing');
% % shiftAmount = avgOld - avgNew;
% % ix = ROI.midday_g;     ix(ind+1:end) = ROI.midday_g(ind+1:end) + shiftAmount;  ROI.midday_g = ix;
% % 
% % avgOld = mean(ROI.midday_r(1:ind),'omitmissing'); avgNew = mean(ROI.midday_r(ind:end),'omitmissing');
% % shiftAmount = avgOld - avgNew;
% % ix = ROI.midday_r;     ix(ind+1:end) = ROI.midday_r(ind+1:end) + shiftAmount;  ROI.midday_r = ix;
% % 
% % avgOld = mean(ROI.midday_b(1:ind),'omitmissing'); avgNew = mean(ROI.midday_b(ind:end),'omitmissing');
% % shiftAmount = avgOld - avgNew;
% % ix = ROI.midday_b;     ix(ind+1:end) = ROI.midday_b(ind+1:end) + shiftAmount;  ROI.midday_b = ix;
% % 
% % avgOld = mean(ROI.midday_gcc(1:ind),'omitmissing'); avgNew = mean(ROI.midday_gcc(ind:end),'omitmissing');
% % shiftAmount = avgOld - avgNew;
% % ix = ROI.midday_gcc;     ix(ind+1:end) = ROI.midday_gcc(ind+1:end) + shiftAmount;  ROI.midday_gcc = ix;

hold on; plot(ROI.daydate,ROI.midday_gcc);
% hold on; xline(ind, '--r', 'Instrument Change');
plot(ROI.daydate,ROI.gcc_mean);

ROI.GRRI_mean = ROI.g_mean./ROI.r_mean;
ROI.GRIVI_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
ROI.cci_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
ROI.exgreen_mean = ((2.*ROI.g_mean)-ROI.r_mean-ROI.b_mean);%./(ROI.g_mean+ROI.r_mean+ROI.b_mean);

% % dataOld = ROI.GRRI_mean(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
% % dataNew = ROI.GRRI_mean(ind:end);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
% % gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.GRRI_mean(ind:end) = (dataNew - p5_New) * gain + p5_Old;
% % 
% % dataOld = ROI.cci_mean(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
% % dataNew = ROI.cci_mean(ind:end);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
% % gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.cci_mean(ind:end) = (dataNew - p5_New) * gain + p5_Old;
% % 
% % dataOld = ROI.exgreen_mean(1:ind-1);   p5_Old = prctile(dataOld, 5);     p95_Old = prctile(dataOld, 95);
% % dataNew = ROI.exgreen_mean(ind:end);   p5_New = prctile(dataNew, 5);     p95_New = prctile(dataNew, 95);
% % gain = (p95_Old - p5_Old) / (p95_New - p5_New);    ROI.exgreen_mean(ind:end) = (dataNew - p5_New) * gain + p5_Old;


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
% % LAIlph = readtimetable("/home/ncoupe/Documents/Fluxnet/US-TPD/LAI/hf150-02-lph-lai.csv", opts, "RowTimes", "datetime");
% % 
% % opts = delimitedTextImportOptions("NumVariables", 8);
% % opts.DataLines = [2, Inf];           opts.Delimiter = ",";
% % opts.VariableNames = ["datetime", "dateloc", "doy", "time", "distance", "transect", "lai_masked", "sel"];
% % opts.VariableTypes = ["datetime", "datetime", "double", "datetime", "double", "double", "double", "double"];
% % opts.ExtraColumnsRule = "ignore";    opts.EmptyLineRule = "read";
% % opts = setvaropts(opts, "datetime", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "dateloc", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "time", "InputFormat", "hh:mm:ss.S");
% % LAIhem = readtimetable("/home/ncoupe/Documents/Fluxnet/US-TPD/LAI/hf150-01-hem-lai.csv", opts, "RowTimes", "datetime");
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
% % LAIsite = readtable("/home/ncoupe/Documents/Fluxnet/US-TPD/LAI/hf069-02-lai-site.csv", opts);
% % clear opts
% % 
% % ind = find(LAIlph.lai_masked==-9999.);                                     LAIlph.lai_masked(ind) = NaN;
% % ind = find(LAIlph.lai_unmasked==-9999.);                                 LAIlph.lai_unmasked(ind) = NaN;
% % [LAIlph.Y,LAIlph.M,LAIlph.D] = datevec(LAIlph.dateloc);           LAIlph.JD = day(LAIlph.dateloc,'dayofyear');
% % LAIlph.JD = day(LAIlph.dateloc,'dayofyear');                             LAIlph.So = AM_solar_rad(LAIlph.JD,12,lat,lon);
% % % ix = LAIlph.lai_masked;
% % 
% % ind = find(LAIhem.lai_masked==-9999.);                                   LAIhem.lai_masked(ind) = NaN;
% % % ind = find(LAIhem.lai_unmasked==-9999.);                               LAIhem.lai_unmasked(ind) = NaN;
% % [LAIhem.Y,LAIhem.M,LAIhem.D] = datevec(LAIhem.dateloc);  LAIhem.JD = day(LAIhem.dateloc,'dayofyear');
% % LAIhem.JD = day(LAIhem.dateloc,'dayofyear');                         LAIhem.So = AM_solar_rad(LAIhem.JD,12,lat,lon);
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
LAIsite.daydate = TPD.daydate;
LAIsite.all_mean = 4.*ones(length(TPD.daydate),1);

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
% NDVI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-TPD-geonex/NDVI.csv/NDVI.csv", opts);
% clear opts

save('TPD.mat','TPD');
save('matlabTPD.mat');


%%
figure
plot(TPD.dateloc,TPD.netrad); hold on
% plot(TPD.netradday); hold on
plot(TPD.dateloc,TPD.H); hold on
plot(TPD.dateloc,TPD.LE,'color',[0.45,0.45, 0.9 ]); hold on
plot(TPD.dateloc,TPD.LE+TPD.H,'color',[0.9,0.45, 0.0 ]); hold on
plot(TPD.dateloc,TPD.netrad-TPD.LE-TPD.H,'color',[0.9,0.0, 0.0 ]); hold on
%%
figure
plot(TPD.daydate,TPD.daynetrad); hold on
% plot(TPD.netradday); hold on
plot(TPD.daydate,TPD.dayH); hold on
plot(TPD.daydate,TPD.dayLE,'color',[0.45,0.45, 0.9 ]); hold on
plot(TPD.daydate,TPD.dayLE+dayTPD.H,'color',[0.9,0.45, 0.0 ]); hold on
plot(TPD.daydate,TPD.daynetrad-TPD.dayLE-TPD.dayH,'color',[0.9,0.0, 0.0 ]); hold on
%%
figure
plot(TPD.dateloc,TPD.co2); hold on

figure
plot(TPD.dateloc,TPD.h2o); hold on
