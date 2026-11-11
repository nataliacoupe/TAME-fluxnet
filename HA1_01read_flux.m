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

ip = 1;
lat = lat_FN(ip);             lon = lon_FN(ip);             height = height_FN(ip);
site_name = site_name_FN(ip); ust_tresh = ust_tresh_FN(ip); utm = utm_FN(ip);

opts = delimitedTextImportOptions("NumVariables", 227);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["TIMESTAMP_START", "TIMESTAMP_END", "TA_F_MDS", "TA_F_MDS_QC", "TA_ERA", "TA_F", "TA_F_QC", "SW_IN_POT", "SW_IN_F_MDS", "SW_IN_F_MDS_QC", "SW_IN_ERA", "SW_IN_F", "SW_IN_F_QC", "LW_IN_F_MDS", "LW_IN_F_MDS_QC", "LW_IN_ERA", "LW_IN_F", "LW_IN_F_QC", "LW_IN_JSB", "LW_IN_JSB_QC", "LW_IN_JSB_ERA", "LW_IN_JSB_F", "LW_IN_JSB_F_QC", "VPD_F_MDS", "VPD_F_MDS_QC", "VPD_ERA", "VPD_F", "VPD_F_QC", "PA", "PA_ERA", "PA_F", "PA_F_QC", "P", "P_ERA", "P_F", "P_F_QC", "WS", "WS_ERA", "WS_F", "WS_F_QC", "WD", "USTAR", "RH", "NETRAD", "PPFD_IN", "PPFD_DIF", "CO2_F_MDS", "CO2_F_MDS_QC", "TS_F_MDS_1", "TS_F_MDS_2", "TS_F_MDS_3", "TS_F_MDS_4", "TS_F_MDS_1_QC", "TS_F_MDS_2_QC", "TS_F_MDS_3_QC", "TS_F_MDS_4_QC", "G_F_MDS", "G_F_MDS_QC", "LE_F_MDS", "LE_F_MDS_QC", "LE_CORR", "LE_CORR_25", "LE_CORR_75", "LE_RANDUNC", "LE_RANDUNC_METHOD", "LE_RANDUNC_N", "LE_CORR_JOINTUNC", "H_F_MDS", "H_F_MDS_QC", "H_CORR", "H_CORR_25", "H_CORR_75", "H_RANDUNC", "H_RANDUNC_METHOD", "H_RANDUNC_N", "H_CORR_JOINTUNC", "EBC_CF_N", "EBC_CF_METHOD", "NIGHT", "NEE_CUT_REF", "NEE_VUT_REF", "NEE_CUT_REF_QC", "NEE_VUT_REF_QC", "NEE_CUT_REF_RANDUNC", "NEE_VUT_REF_RANDUNC", "NEE_CUT_REF_RANDUNC_METHOD", "NEE_VUT_REF_RANDUNC_METHOD", "NEE_CUT_REF_RANDUNC_N", "NEE_VUT_REF_RANDUNC_N", "NEE_CUT_REF_JOINTUNC", "NEE_VUT_REF_JOINTUNC", "NEE_CUT_USTAR50", "NEE_VUT_USTAR50", "NEE_CUT_USTAR50_QC", "NEE_VUT_USTAR50_QC", "NEE_CUT_USTAR50_RANDUNC", "NEE_VUT_USTAR50_RANDUNC", "NEE_CUT_USTAR50_RANDUNC_METHOD", "NEE_VUT_USTAR50_RANDUNC_METHOD", "NEE_CUT_USTAR50_RANDUNC_N", "NEE_VUT_USTAR50_RANDUNC_N", "NEE_CUT_USTAR50_JOINTUNC", "NEE_VUT_USTAR50_JOINTUNC", "NEE_CUT_MEAN", "NEE_VUT_MEAN", "NEE_CUT_MEAN_QC", "NEE_VUT_MEAN_QC", "NEE_CUT_SE", "NEE_VUT_SE", "NEE_CUT_05", "NEE_CUT_16", "NEE_CUT_25", "NEE_CUT_50", "NEE_CUT_75", "NEE_CUT_84", "NEE_CUT_95", "NEE_VUT_05", "NEE_VUT_16", "NEE_VUT_25", "NEE_VUT_50", "NEE_VUT_75", "NEE_VUT_84", "NEE_VUT_95", "NEE_CUT_05_QC", "NEE_CUT_16_QC", "NEE_CUT_25_QC", "NEE_CUT_50_QC", "NEE_CUT_75_QC", "NEE_CUT_84_QC", "NEE_CUT_95_QC", "NEE_VUT_05_QC", "NEE_VUT_16_QC", "NEE_VUT_25_QC", "NEE_VUT_50_QC", "NEE_VUT_75_QC", "NEE_VUT_84_QC", "NEE_VUT_95_QC", "RECO_NT_VUT_REF", "RECO_NT_VUT_USTAR50", "RECO_NT_VUT_MEAN", "RECO_NT_VUT_SE", "RECO_NT_VUT_05", "RECO_NT_VUT_16", "RECO_NT_VUT_25", "RECO_NT_VUT_50", "RECO_NT_VUT_75", "RECO_NT_VUT_84", "RECO_NT_VUT_95", "RECO_NT_CUT_REF", "RECO_NT_CUT_USTAR50", "RECO_NT_CUT_MEAN", "RECO_NT_CUT_SE", "RECO_NT_CUT_05", "RECO_NT_CUT_16", "RECO_NT_CUT_25", "RECO_NT_CUT_50", "RECO_NT_CUT_75", "RECO_NT_CUT_84", "RECO_NT_CUT_95", "GPP_NT_VUT_REF", "GPP_NT_VUT_USTAR50", "GPP_NT_VUT_MEAN", "GPP_NT_VUT_SE", "GPP_NT_VUT_05", "GPP_NT_VUT_16", "GPP_NT_VUT_25", "GPP_NT_VUT_50", "GPP_NT_VUT_75", "GPP_NT_VUT_84", "GPP_NT_VUT_95", "GPP_NT_CUT_REF", "GPP_NT_CUT_USTAR50", "GPP_NT_CUT_MEAN", "GPP_NT_CUT_SE", "GPP_NT_CUT_05", "GPP_NT_CUT_16", "GPP_NT_CUT_25", "GPP_NT_CUT_50", "GPP_NT_CUT_75", "GPP_NT_CUT_84", "GPP_NT_CUT_95", "RECO_DT_VUT_REF", "RECO_DT_VUT_USTAR50", "RECO_DT_VUT_MEAN", "RECO_DT_VUT_SE", "RECO_DT_VUT_05", "RECO_DT_VUT_16", "RECO_DT_VUT_25", "RECO_DT_VUT_50", "RECO_DT_VUT_75", "RECO_DT_VUT_84", "RECO_DT_VUT_95", "RECO_DT_CUT_REF", "RECO_DT_CUT_USTAR50", "RECO_DT_CUT_MEAN", "RECO_DT_CUT_SE", "RECO_DT_CUT_05", "RECO_DT_CUT_16", "RECO_DT_CUT_25", "RECO_DT_CUT_50", "RECO_DT_CUT_75", "RECO_DT_CUT_84", "RECO_DT_CUT_95", "GPP_DT_VUT_REF", "GPP_DT_VUT_USTAR50", "GPP_DT_VUT_MEAN", "GPP_DT_VUT_SE", "GPP_DT_VUT_05", "GPP_DT_VUT_16", "GPP_DT_VUT_25", "GPP_DT_VUT_50", "GPP_DT_VUT_75", "GPP_DT_VUT_84", "GPP_DT_VUT_95", "GPP_DT_CUT_REF", "GPP_DT_CUT_USTAR50", "GPP_DT_CUT_MEAN", "GPP_DT_CUT_SE", "GPP_DT_CUT_05", "GPP_DT_CUT_16", "GPP_DT_CUT_25", "GPP_DT_CUT_50", "GPP_DT_CUT_75", "GPP_DT_CUT_84", "GPP_DT_CUT_95", "RECO_SR", "RECO_SR_N"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
xopts.EmptyLineRule = "read";
Ha1table = readtable("/media/ncoupe/Backup/Data/Fluxnet/AMF_US-Ha1_FLUXNET_FULLSET_1991-2020_3-5/AMF_US-Ha1_FLUXNET_FULLSET_HR_1991-2020_3-5.csv", opts);
clear opts

Ha1table.Y = floor(Ha1table.TIMESTAMP_START./10^8);    Ha1table.M = floor((Ha1table.TIMESTAMP_START-Ha1table.Y.*10^8)./10^6);
Ha1table.D = floor((Ha1table.TIMESTAMP_START-(Ha1table.Y.*10^8)-(Ha1table.M.*10^6))./10^4);
Ha1table.HR = floor((Ha1table.TIMESTAMP_START-(Ha1table.Y.*10^8)-(Ha1table.M.*10^6)-(Ha1table.D.*10^4))./10^2);
% Ha1table.MI = floor((Ha1table.TIMESTAMP_START-(Ha1table.Y.*10^8)-(Ha1table.M.*10^6)-(Ha1table.D.*10^4)-(Ha1table.HR.*10^2))./10^2);
Ha1table = removevars(Ha1table, 'TIMESTAMP_START');
Ha1table = removevars(Ha1table, 'TIMESTAMP_END');

Ha1table.dateloc = datetime(Ha1table.Y,Ha1table.M,Ha1table.D,Ha1table.HR,0,0);

data = Ha1table;     [~, idx] = unique(data(:,"dateloc"),'stable');   Ha1table = data(idx,:);
data = sortrows( Ha1table, 'dateloc');
Ha1table = data;

% Ha1table = addvars(Ha1table, [Ha1table.dateloc], 'NewVariableNames', 'dateloc');
% disp(Ha1table.Properties.VariableNames);
ind = find(Ha1table.dateloc<datetime(1992,2,6));

for ik = 2:width(Ha1table)-1
    ij = Ha1table{:,ik};          ij(ij == -9999.)  = NaN;         ij(ij == 9999.)  = NaN;
    ij(ind) = NaN;
    ij(ismissing(ij)) = NaN;                       Ha1table{:,ik}   = ij;
end

%% QAQC
ind = find(Ha1table.dateloc<datetime(1992,2,6));
Ha1table.LE_F_MDS(ind) = NaN;

%% Ha1AM
opts = delimitedTextImportOptions("NumVariables", 124);
opts.DataLines = [4, Inf];   opts.Delimiter = ",";
opts.VariableNames = ["TIMESTAMP_START", "TIMESTAMP_END", "WS_PI_F", "WS", "WD", "T_SONIC", "H2O_1_1_1", "FH2O_1_1_1", "LE_1_1_1", "FC_1_1_1", "CO2_1_1_1", "TAU", "USTAR", "SC", "H", "NETRAD_PI_F", "NETRAD", "PPFD_IN_1_1_1", "PPFD_IN_1_2_1", "PPFD_IN_PI_F_1_1_1", "PPFD_DIR", "PPFD_DIF", "RH_1_1_1", "RH_1_2_1", "RH_1_3_1", "RH_1_4_1", "RH_1_5_1", "RH_PI_F_1_1_1", "RH_PI_F_1_2_1", "TA_1_1_1", "TA_1_2_1", "TA_1_3_1", "TA_1_4_1", "TA_1_5_1", "TA_PI_F_1_1_1", "TA_PI_F_1_2_1", "TA_PI_F_1_3_1", "TA_PI_F_1_4_1", "TA_PI_F_1_5_1", "TS_PI_1_1_A", "TS_2_1_1", "TS_3_1_1", "TS_4_1_1", "TS_4_2_1", "TS_4_3_1", "TS_4_4_1", "TS_5_1_1", "TS_5_2_1", "TS_5_3_1", "TS_6_1_1", "TS_6_1_2", "TS_6_2_1", "TS_6_3_1", "PA", "PA_PI_F", "P", "FC_1_1_2", "CO2_1_1_2", "FH2O_1_1_2", "H2O_1_1_2", "LE_1_1_2", "PPFD_OUT_1_1_1", "U_SIGMA_1_1_1", "V_SIGMA_1_1_1", "W_SIGMA_1_1_1", "T_SONIC_SIGMA_1_1_1", "TS_7_1_1", "TS_7_2_1", "TS_7_3_1", "TS_7_4_1", "SWC_7_1_1", "SWC_7_2_1", "SWC_7_3_1", "SWC_7_4_1", "TS_8_1_1", "TS_8_2_1", "TS_8_3_1", "TS_8_4_1", "SWC_8_1_1", "SWC_8_2_1", "SWC_8_3_1", "SWC_8_4_1", "TS_9_1_1", "TS_9_2_1", "TS_9_3_1", "TS_9_4_1", "TS_9_5_1", "TS_9_6_1", "TS_9_7_1", "TS_9_8_1", "TS_9_9_1", "TS_10_1_1", "TS_10_2_1", "TS_10_3_1", "TS_10_4_1", "TS_10_5_1", "TS_10_6_1", "TS_11_1_1", "TS_11_2_1", "TS_11_3_1", "TS_11_4_1", "TS_11_5_1", "TS_11_6_1", "SWC_9_1_1", "SWC_9_2_1", "SWC_9_3_1", "SWC_9_4_1", "SWC_9_5_1", "SWC_9_6_1", "SWC_9_7_1", "SWC_9_8_1", "SWC_9_9_1", "SWC_10_1_1", "SWC_10_2_1", "SWC_10_3_1", "SWC_10_4_1", "SWC_10_5_1", "SWC_10_6_1", "SWC_11_1_1", "SWC_11_2_1", "SWC_11_3_1", "SWC_11_4_1", "SWC_11_5_1", "SWC_11_6_1"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";     opts.EmptyLineRule = "read";
Ha1AMtable = readtable("/home/ncoupe/Documents/Fluxnet/US-Ha1/AMF_US-Ha1_BASE-BADM_24-5/AMF_US-Ha1_BASE_HR_24-5.csv", opts);
clear opts

Y = floor(Ha1AMtable.TIMESTAMP_START./10^8);    M = floor((Ha1AMtable.TIMESTAMP_START-Y.*10^8)./10^6);
D = floor((Ha1AMtable.TIMESTAMP_START-(Y.*10^8)-(M.*10^6))./10^4);
HR = floor((Ha1AMtable.TIMESTAMP_START-(Y.*10^8)-(M.*10^6)-(D.*10^4))./10^2);
Ha1AMtable.datelocTMP = datetime(Y,M,D,HR,0,0);

for ik = 2:width(Ha1AMtable)-1
    ij = Ha1AMtable{:,ik};       ij(ij == -9999.)  = NaN;
    ij(ij == 9999.)  = NaN;
    ij(ind) = NaN;
    ij(ismissing(ij)) = NaN;     Ha1AMtable{:,ik}   = ij;
end

data = Ha1AMtable;     [~, idx] = unique(data(:,"datelocTMP"),'stable');   Ha1AMtable = data(idx,:);
data = sortrows( Ha1AMtable, 'datelocTMP');

data = table2timetable(data);
Ha1AMtable = retime(data, Ha1table.dateloc, 'mean');
% Ha1AM = timetable2table(Ha1AMtable);

commonVars = intersect(Ha1table.Properties.VariableNames, Ha1AMtable.Properties.VariableNames);
Ha1AMtable = removevars(Ha1AMtable, commonVars);
Ha1AMtable.dateloc = Ha1AMtable.datelocTMP;

Ha1join = join(Ha1table,Ha1AMtable);

figure('color','white')
plot(Ha1join.dateloc,Ha1join.SWC_7_1_1);  hold on;
plot(Ha1join.dateloc,Ha1join.SWC_7_2_1)
plot(Ha1join.dateloc,Ha1join.SWC_7_3_1)
plot(Ha1join.dateloc,Ha1join.SWC_7_4_1)

%% ..............................................................................................................................................
Ha1.dateloc = Ha1join.dateloc;
[Ha1.Y,Ha1.M,Ha1.D,Ha1.HR,~,~] =datevec(Ha1.dateloc);
Ha1.dateloc_day = datetime(Ha1.Y,Ha1.M,Ha1.D);
Ha1.JD = day(Ha1.dateloc,'dayofyear');

Ha1.So = AM_solar_rad(Ha1.JD,Ha1.HR,lat,lon);

%% ......................................................................................
Ha1.LE = Ha1join.LE_F_MDS;    Ha1.LE (Ha1join.LE_F_MDS_QC>2) = NaN;
Ha1.H = Ha1join.H_F_MDS;      Ha1.H (Ha1join.H_F_MDS_QC>2) = NaN;
Ha1.netrad = Ha1join.NETRAD;  Ha1.ustar = Ha1join.USTAR;
Ha1.rain = Ha1join.P_F;       Ha1.par = Ha1join.PPFD_IN;     Ha1.G = Ha1join.G_F_MDS;
Ha1.tair = Ha1join.TA_F_MDS;  Ha1.ws = Ha1join.WS;           Ha1.VPD = Ha1join.VPD_F_MDS;
Ha1.RH = Ha1join.RH;          Ha1.pambKpa = Ha1join.PA;
Ha1.pambpa = Ha1.pambKpa./1000;
Ha1.fh2o = Ha1join.FH2O_1_1_2;       Ha1.fh2o (Ha1join.LE_F_MDS_QC>1) = NaN;
Ha1.h2ommolm = Ha1join.H2O_1_1_2;
% Ha1.nee = Ha1join.NEE_CUT_REF;     Ha1.nee(Ha1join.NEE_CUT_REF_QC>0) = NaN;
Ha1.nee = Ha1join.NEE_VUT_REF;       Ha1.nee(Ha1join.NEE_VUT_MEAN_QC>1) = NaN;
Ha1.reco = Ha1join.RECO_NT_VUT_REF;  Ha1.reco(Ha1join.NEE_VUT_MEAN_QC>1) = NaN;
% this GEP is too noisy: Ha1.gep = Ha1join.GPP_NT_VUT_REF;    Ha1.gep(Ha1join.NEE_VUT_REF_QC>1) = NaN;
Ha1.gep = Ha1join.GPP_DT_VUT_MEAN;    Ha1.gep(Ha1join.NEE_VUT_MEAN_QC>=1) = NaN;
% Ha1AMtable.FC = Ha1AMtable.FC_1_1_1; Ha1AMtable.FC(isnan(Ha1AMtable.FC)) = Ha1AMtable.FC_1_1_2(isnan(Ha1AMtable.FC));
% ind = find (isnan(-(Ha1AMtable.FC+Ha1AMtable.SC))); Ha1.gep(ind) = NaN;

ix = [NaN;diff(Ha1.LE)];     Ha1.LE(ix==0) = NaN;     Ha1.LE(Ha1.LE==0) = NaN;
Ha1.LE(Ha1.LE>900) = NaN;    Ha1.H(Ha1.H>900) = NaN;
Ha1.LE(Ha1.rain>0) = NaN;    Ha1.H(Ha1.rain>0) = NaN;
Ha1.netrad((Ha1.So<100)&(Ha1.netrad>200)) = NaN;
Ha1.netrad(Ha1.netrad>800) = NaN;

Ha1.tair(Ha1.tair==-9999.) = NaN;
%%
v1 = 0;         v2 = 800;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/(max(Ha1.Y)-min(Ha1.Y)+1)):v2;
figure('color','white');           hold on;
ik = Ha1.Y(1);   count=1;          color_jet = jet(max(Ha1.Y)-min(Ha1.Y)+1);
while ik<Ha1.Y(end)
    hl1  =  plot(Ha1.par(Ha1.Y == ik)./2,Ha1.netrad(Ha1.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(Ha1.par(Ha1.Y == ik)./2,Ha1.netrad(Ha1.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('Rn');  xlabel ('PAR');

v1 = 0;         v2 = 800;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/(max(Ha1.Y)-min(Ha1.Y)+1)):v2;
figure('color','white');            hold on;
ik = Ha1.Y(1);   count=1;             color_jet = jet(max(Ha1.Y)-min(Ha1.Y)+1);
while ik<Ha1.Y(end)
    hl1  =  plot(Ha1.netrad(Ha1.Y == ik),Ha1.LE(Ha1.Y == ik)+Ha1.H(Ha1.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(Ha1.netrad(Ha1.Y == ik),Ha1.LE(Ha1.Y == ik)+Ha1.H(Ha1.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('H+LE');  xlabel ('Rn');

%% ......................................................................................
ind = find((Ha1.dateloc>=datetime(2009,4,10))&(Ha1.dateloc<=datetime(2012,4,10)));  Ha1.netrad(ind) = Ha1.netrad(ind) -30;  %Ha1.H(ind) = NaN;
% ind = find((Ha1.dateloc>=datetime(2010,4,10))&(Ha1.dateloc<=datetime(2012,4,10)));  Ha1.netrad(ind) = Ha1.netrad(ind) -30;  %Ha1.H(ind) = NaN;

ind = find((Ha1.dateloc>=datetime(2006,8,24))&(Ha1.dateloc<=datetime(2006,9,21)));  Ha1.LE(ind) = NaN;  %Ha1.H(ind) = NaN;
ind = find((Ha1.dateloc>=datetime(2008,6,25))&(Ha1.dateloc<=datetime(2008,8,12)));  Ha1.LE(ind) = NaN;  %Ha1.H(ind) = NaN;
ind = find((Ha1.dateloc>=datetime(2009,6,22))&(Ha1.dateloc<=datetime(2009,7,15)));  Ha1.LE(ind) = NaN;  %Ha1.H(ind) = NaN;
ind = find((Ha1.dateloc>=datetime(2009,7,19))&(Ha1.dateloc<=datetime(2009,8,13)));  Ha1.LE(ind) = NaN;  %Ha1.H(ind) = NaN;

ind = find((Ha1.dateloc>=datetime(2019,1,30))&(Ha1.dateloc<=datetime(2019,2,2)));   Ha1.H(ind) = NaN;  %Ha1.H(ind) = NaN;

ind = find((Ha1.dateloc>=datetime(2001,6,20))&(Ha1.dateloc<=datetime(2001,6,28)));  Ha1.netrad(ind) = NaN;  %Ha1.H(ind) = NaN;
ind = find((Ha1.dateloc>=datetime(2004,10,5))&(Ha1.dateloc<=datetime(2005,5,1)));   Ha1.netrad(ind) = NaN;  %Ha1.H(ind) = NaN;
ind = find((Ha1.dateloc>=datetime(2006,12,24))&(Ha1.dateloc<=datetime(2006,12,28)));Ha1.netrad(ind) = NaN;  %Ha1.H(ind) = NaN;
ind = find((Ha1.dateloc>=datetime(2006,5,25))&(Ha1.dateloc<=datetime(2006,8,25)));  Ha1.netrad(ind) = NaN;  %Ha1.H(ind) = NaN;
ind = find((Ha1.dateloc>=datetime(2009,5,24))&(Ha1.dateloc<=datetime(2009,10,5)));  Ha1.netrad(ind) = NaN;  %Ha1.H(ind) = NaN;
ind = find((Ha1.dateloc>=datetime(2009,7,19))&(Ha1.dateloc<=datetime(2010,4,11)));  Ha1.netrad(ind) = Ha1.netrad(ind)-40;  %Ha1.H(ind) = NaN;
ind = find((Ha1.dateloc>=datetime(2011,5,13))&(Ha1.dateloc<=datetime(2011,5,23)));  Ha1.netrad(ind) = NaN;  %Ha1.H(ind) = NaN;

Ha1.netrad(Ha1.netrad==3) = NaN;%

ind = find((Ha1.dateloc>=datetime(2014,01,15))&(Ha1.dateloc<=datetime(2014,03,04)));
Ha1.gep(ind) = NaN; % winter very high values

%%
numberY = Ha1.Y(end) -Ha1.Y(1);
v1 = 0;         v2 = 800;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/numberY):v2;
figure('color','white');            hold on;
ik = Ha1.Y(1);   count=1;     color_jet = jet(max(Ha1.Y)-min(Ha1.Y)+5);
while ik<Ha1.Y(end)
    hl1  =  plot(Ha1.par(Ha1.Y == ik)./2,Ha1.netrad(Ha1.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(Ha1.par(Ha1.Y == ik)./2,Ha1.netrad(Ha1.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('Rn');  xlabel ('PAR');

v1 = 0;         v2 = 1000;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/(Ha1.Y(end)-Ha1.Y(1))):v2;
figure('color','white');            hold on;
ik = Ha1.Y(1);   count=1;      color_jet = jet(max(Ha1.Y)-min(Ha1.Y)+1);
while ik<Ha1.Y(end)
    hl1  =  plot(Ha1.par(Ha1.Y == ik)./2,Ha1.LE(Ha1.Y == ik)+Ha1.H(Ha1.Y == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    AM_compute_regression(Ha1.par(Ha1.Y == ik)./2,Ha1.LE(Ha1.Y == ik)+Ha1.H(Ha1.Y == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(ik),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('H+LE (W m^-^2)');   xlabel ('Rn (W m^-^2)');
axis([v1 v2 v1 v2]); grid on; box on;

%%
color_jet = jet(7);
figure('color','white');
plot(Ha1.dateloc,Ha1.So./2,'Color', color_jet(1,:));      hold on
plot(Ha1.dateloc,(Ha1.par)./2,'Color', 'k');
plot(Ha1.dateloc,Ha1.netrad,'Color', color_jet(2,:));      hold on
plot(Ha1.dateloc,Ha1.H,'Color',color_jet(6,:));              plot(Ha1.dateloc,Ha1.LE,'Color',color_jet(4,:));
plot(Ha1.dateloc,(Ha1.H+Ha1.LE),'Color', color_jet(6,:));
legend('TOA','par','net radiation','H','LE','turbulent');                                ylabel('energy flux (W m^-^2)');
%
% Ha1.Bowen = Ha1.H./Ha1.LE;                              Ha1.Bowen(abs(Ha1.Bowen)>100) = NaN;
% figure('color','white');
% plot(Ha1.dateloc,Ha1.Bowen,'Color', [.3 .8 .2]);
% hold on

% .................................................................................................
%% Set up the Import Options and import the data
% .................................................................................................
opts = delimitedTextImportOptions("NumVariables", 1094);
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "Var2", "Tile", "LatLon", "YYYYMMDD", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40", "VarName41", "VarName42", "VarName43", "VarName44", "VarName45", "VarName46", "VarName47", "VarName48", "VarName49", "VarName50", "VarName51", "VarName52", "VarName53", "VarName54", "VarName55", "VarName56", "VarName57", "VarName58", "VarName59", "VarName60", "VarName61", "VarName62", "VarName63", "VarName64", "VarName65", "VarName66", "VarName67", "VarName68", "VarName69", "VarName70", "VarName71", "VarName72", "VarName73", "VarName74", "VarName75", "VarName76", "VarName77", "VarName78", "VarName79", "VarName80", "VarName81", "VarName82", "VarName83", "VarName84", "VarName85", "VarName86", "VarName87", "VarName88", "VarName89", "VarName90", "VarName91", "VarName92", "VarName93", "VarName94", "VarName95", "VarName96", "VarName97", "VarName98", "VarName99", "VarName100", "VarName101", "VarName102", "VarName103", "VarName104", "VarName105", "VarName106", "VarName107", "VarName108", "VarName109", "VarName110", "VarName111", "VarName112", "VarName113", "VarName114", "VarName115", "VarName116", "VarName117", "VarName118", "VarName119", "VarName120", "VarName121", "VarName122", "VarName123", "VarName124", "VarName125", "VarName126", "VarName127", "VarName128", "VarName129", "VarName130", "VarName131", "VarName132", "VarName133", "VarName134", "VarName135", "VarName136", "VarName137", "VarName138", "VarName139", "VarName140", "VarName141", "VarName142", "VarName143", "VarName144", "VarName145", "VarName146", "VarName147", "VarName148", "VarName149", "VarName150", "VarName151", "VarName152", "VarName153", "VarName154", "VarName155", "VarName156", "VarName157", "VarName158", "VarName159", "VarName160", "VarName161", "VarName162", "VarName163", "VarName164", "VarName165", "VarName166", "VarName167", "VarName168", "VarName169", "VarName170", "VarName171", "VarName172", "VarName173", "VarName174", "VarName175", "VarName176", "VarName177", "VarName178", "VarName179", "VarName180", "VarName181", "VarName182", "VarName183", "VarName184", "VarName185", "VarName186", "VarName187", "VarName188", "VarName189", "VarName190", "VarName191", "VarName192", "VarName193", "VarName194", "VarName195", "VarName196", "VarName197", "VarName198", "VarName199", "VarName200", "VarName201", "VarName202", "VarName203", "VarName204", "VarName205", "VarName206", "VarName207", "VarName208", "VarName209", "VarName210", "VarName211", "VarName212", "VarName213", "VarName214", "VarName215", "VarName216", "VarName217", "VarName218", "VarName219", "VarName220", "VarName221", "VarName222", "VarName223", "VarName224", "VarName225", "VarName226", "VarName227", "VarName228", "VarName229", "VarName230", "VarName231", "VarName232", "VarName233", "VarName234", "VarName235", "VarName236", "VarName237", "VarName238", "VarName239", "VarName240", "VarName241", "VarName242", "VarName243", "VarName244", "VarName245", "VarName246", "VarName247", "VarName248", "VarName249", "VarName250", "VarName251", "VarName252", "VarName253", "VarName254", "VarName255", "VarName256", "VarName257", "VarName258", "VarName259", "VarName260", "VarName261", "VarName262", "VarName263", "VarName264", "VarName265", "VarName266", "VarName267", "VarName268", "VarName269", "VarName270", "VarName271", "VarName272", "VarName273", "VarName274", "VarName275", "VarName276", "VarName277", "VarName278", "VarName279", "VarName280", "VarName281", "VarName282", "VarName283", "VarName284", "VarName285", "VarName286", "VarName287", "VarName288", "VarName289", "VarName290", "VarName291", "VarName292", "VarName293", "VarName294", "VarName295", "VarName296", "VarName297", "VarName298", "VarName299", "VarName300", "VarName301", "VarName302", "VarName303", "VarName304", "VarName305", "VarName306", "VarName307", "VarName308", "VarName309", "VarName310", "VarName311", "VarName312", "VarName313", "VarName314", "VarName315", "VarName316", "VarName317", "VarName318", "VarName319", "VarName320", "VarName321", "VarName322", "VarName323", "VarName324", "VarName325", "VarName326", "VarName327", "VarName328", "VarName329", "VarName330", "VarName331", "VarName332", "VarName333", "VarName334", "VarName335", "VarName336", "VarName337", "VarName338", "VarName339", "VarName340", "VarName341", "VarName342", "VarName343", "VarName344", "VarName345", "VarName346", "VarName347", "VarName348", "VarName349", "VarName350", "VarName351", "VarName352", "VarName353", "VarName354", "VarName355", "VarName356", "VarName357", "VarName358", "VarName359", "VarName360", "VarName361", "VarName362", "VarName363", "VarName364", "VarName365", "VarName366", "VarName367", "VarName368", "VarName369", "VarName370", "VarName371", "VarName372", "VarName373", "VarName374", "VarName375", "VarName376", "VarName377", "VarName378", "VarName379", "VarName380", "VarName381", "VarName382", "VarName383", "VarName384", "VarName385", "VarName386", "VarName387", "VarName388", "VarName389", "VarName390", "VarName391", "VarName392", "VarName393", "VarName394", "VarName395", "VarName396", "VarName397", "VarName398", "VarName399", "VarName400", "VarName401", "VarName402", "VarName403", "VarName404", "VarName405", "VarName406", "VarName407", "VarName408", "VarName409", "VarName410", "VarName411", "VarName412", "VarName413", "VarName414", "VarName415", "VarName416", "VarName417", "VarName418", "VarName419", "VarName420", "VarName421", "VarName422", "VarName423", "VarName424", "VarName425", "VarName426", "VarName427", "VarName428", "VarName429", "VarName430", "VarName431", "VarName432", "VarName433", "VarName434", "VarName435", "VarName436", "VarName437", "VarName438", "VarName439", "VarName440", "VarName441", "VarName442", "VarName443", "VarName444", "VarName445", "VarName446", "VarName447", "VarName448", "VarName449", "VarName450", "VarName451", "VarName452", "VarName453", "VarName454", "VarName455", "VarName456", "VarName457", "VarName458", "VarName459", "VarName460", "VarName461", "VarName462", "VarName463", "VarName464", "VarName465", "VarName466", "VarName467", "VarName468", "VarName469", "VarName470", "VarName471", "VarName472", "VarName473", "VarName474", "VarName475", "VarName476", "VarName477", "VarName478", "VarName479", "VarName480", "VarName481", "VarName482", "VarName483", "VarName484", "VarName485", "VarName486", "VarName487", "VarName488", "VarName489", "VarName490", "VarName491", "VarName492", "VarName493", "VarName494", "VarName495", "VarName496", "VarName497", "VarName498", "VarName499", "VarName500", "VarName501", "VarName502", "VarName503", "VarName504", "VarName505", "VarName506", "VarName507", "VarName508", "VarName509", "VarName510", "VarName511", "VarName512", "VarName513", "VarName514", "VarName515", "VarName516", "VarName517", "VarName518", "VarName519", "VarName520", "VarName521", "VarName522", "VarName523", "VarName524", "VarName525", "VarName526", "VarName527", "VarName528", "VarName529", "VarName530", "VarName531", "VarName532", "VarName533", "VarName534", "VarName535", "VarName536", "VarName537", "VarName538", "VarName539", "VarName540", "VarName541", "VarName542", "VarName543", "VarName544", "VarName545", "VarName546", "VarName547", "VarName548", "VarName549", "VarName550", "VarName551", "VarName552", "VarName553", "VarName554", "VarName555", "VarName556", "VarName557", "VarName558", "VarName559", "VarName560", "VarName561", "VarName562", "VarName563", "VarName564", "VarName565", "VarName566", "VarName567", "VarName568", "VarName569", "VarName570", "VarName571", "VarName572", "VarName573", "VarName574", "VarName575", "VarName576", "VarName577", "VarName578", "VarName579", "VarName580", "VarName581", "VarName582", "VarName583", "VarName584", "VarName585", "VarName586", "VarName587", "VarName588", "VarName589", "VarName590", "VarName591", "VarName592", "VarName593", "VarName594", "VarName595", "VarName596", "VarName597", "VarName598", "VarName599", "VarName600", "VarName601", "VarName602", "VarName603", "VarName604", "VarName605", "VarName606", "VarName607", "VarName608", "VarName609", "VarName610", "VarName611", "VarName612", "VarName613", "VarName614", "VarName615", "VarName616", "VarName617", "VarName618", "VarName619", "VarName620", "VarName621", "VarName622", "VarName623", "VarName624", "VarName625", "VarName626", "VarName627", "VarName628", "VarName629", "VarName630", "VarName631", "VarName632", "VarName633", "VarName634", "VarName635", "VarName636", "VarName637", "VarName638", "VarName639", "VarName640", "VarName641", "VarName642", "VarName643", "VarName644", "VarName645", "VarName646", "VarName647", "VarName648", "VarName649", "VarName650", "VarName651", "VarName652", "VarName653", "VarName654", "VarName655", "VarName656", "VarName657", "VarName658", "VarName659", "VarName660", "VarName661", "VarName662", "VarName663", "VarName664", "VarName665", "VarName666", "VarName667", "VarName668", "VarName669", "VarName670", "VarName671", "VarName672", "VarName673", "VarName674", "VarName675", "VarName676", "VarName677", "VarName678", "VarName679", "VarName680", "VarName681", "VarName682", "VarName683", "VarName684", "VarName685", "VarName686", "VarName687", "VarName688", "VarName689", "VarName690", "VarName691", "VarName692", "VarName693", "VarName694", "VarName695", "VarName696", "VarName697", "VarName698", "VarName699", "VarName700", "VarName701", "VarName702", "VarName703", "VarName704", "VarName705", "VarName706", "VarName707", "VarName708", "VarName709", "VarName710", "VarName711", "VarName712", "VarName713", "VarName714", "VarName715", "VarName716", "VarName717", "VarName718", "VarName719", "VarName720", "VarName721", "VarName722", "VarName723", "VarName724", "VarName725", "VarName726", "VarName727", "VarName728", "VarName729", "VarName730", "VarName731", "VarName732", "VarName733", "VarName734", "VarName735", "VarName736", "VarName737", "VarName738", "VarName739", "VarName740", "VarName741", "VarName742", "VarName743", "VarName744", "VarName745", "VarName746", "VarName747", "VarName748", "VarName749", "VarName750", "VarName751", "VarName752", "VarName753", "VarName754", "VarName755", "VarName756", "VarName757", "VarName758", "VarName759", "VarName760", "VarName761", "VarName762", "VarName763", "VarName764", "VarName765", "VarName766", "VarName767", "VarName768", "VarName769", "VarName770", "VarName771", "VarName772", "VarName773", "VarName774", "VarName775", "VarName776", "VarName777", "VarName778", "VarName779", "VarName780", "VarName781", "VarName782", "VarName783", "VarName784", "VarName785", "VarName786", "VarName787", "VarName788", "VarName789", "VarName790", "VarName791", "VarName792", "VarName793", "VarName794", "VarName795", "VarName796", "VarName797", "VarName798", "VarName799", "VarName800", "VarName801", "VarName802", "VarName803", "VarName804", "VarName805", "VarName806", "VarName807", "VarName808", "VarName809", "VarName810", "VarName811", "VarName812", "VarName813", "VarName814", "VarName815", "VarName816", "VarName817", "VarName818", "VarName819", "VarName820", "VarName821", "VarName822", "VarName823", "VarName824", "VarName825", "VarName826", "VarName827", "VarName828", "VarName829", "VarName830", "VarName831", "VarName832", "VarName833", "VarName834", "VarName835", "VarName836", "VarName837", "VarName838", "VarName839", "VarName840", "VarName841", "VarName842", "VarName843", "VarName844", "VarName845", "VarName846", "VarName847", "VarName848", "VarName849", "VarName850", "VarName851", "VarName852", "VarName853", "VarName854", "VarName855", "VarName856", "VarName857", "VarName858", "VarName859", "VarName860", "VarName861", "VarName862", "VarName863", "VarName864", "VarName865", "VarName866", "VarName867", "VarName868", "VarName869", "VarName870", "VarName871", "VarName872", "VarName873", "VarName874", "VarName875", "VarName876", "VarName877", "VarName878", "VarName879", "VarName880", "VarName881", "VarName882", "VarName883", "VarName884", "VarName885", "VarName886", "VarName887", "VarName888", "VarName889", "VarName890", "VarName891", "VarName892", "VarName893", "VarName894", "VarName895", "VarName896", "VarName897", "VarName898", "VarName899", "VarName900", "VarName901", "VarName902", "VarName903", "VarName904", "VarName905", "VarName906", "VarName907", "VarName908", "VarName909", "VarName910", "VarName911", "VarName912", "VarName913", "VarName914", "VarName915", "VarName916", "VarName917", "VarName918", "VarName919", "VarName920", "VarName921", "VarName922", "VarName923", "VarName924", "VarName925", "VarName926", "VarName927", "VarName928", "VarName929", "VarName930", "VarName931", "VarName932", "VarName933", "VarName934", "VarName935", "VarName936", "VarName937", "VarName938", "VarName939", "VarName940", "VarName941", "VarName942", "VarName943", "VarName944", "VarName945", "VarName946", "VarName947", "VarName948", "VarName949", "VarName950", "VarName951", "VarName952", "VarName953", "VarName954", "VarName955", "VarName956", "VarName957", "VarName958", "VarName959", "VarName960", "VarName961", "VarName962", "VarName963", "VarName964", "VarName965", "VarName966", "VarName967", "VarName968", "VarName969", "VarName970", "VarName971", "VarName972", "VarName973", "VarName974", "VarName975", "VarName976", "VarName977", "VarName978", "VarName979", "VarName980", "VarName981", "VarName982", "VarName983", "VarName984", "VarName985", "VarName986", "VarName987", "VarName988", "VarName989", "VarName990", "VarName991", "VarName992", "VarName993", "VarName994", "VarName995", "VarName996", "VarName997", "VarName998", "VarName999", "VarName1000", "VarName1001", "VarName1002", "VarName1003", "VarName1004", "VarName1005", "VarName1006", "VarName1007", "VarName1008", "VarName1009", "VarName1010", "VarName1011", "VarName1012", "VarName1013", "VarName1014", "VarName1015", "VarName1016", "VarName1017", "VarName1018", "VarName1019", "VarName1020", "VarName1021", "VarName1022", "VarName1023", "VarName1024", "VarName1025", "VarName1026", "VarName1027", "VarName1028", "VarName1029", "VarName1030", "VarName1031", "VarName1032", "VarName1033", "VarName1034", "VarName1035", "VarName1036", "VarName1037", "VarName1038", "VarName1039", "VarName1040", "VarName1041", "VarName1042", "VarName1043", "VarName1044", "VarName1045", "VarName1046", "VarName1047", "VarName1048", "VarName1049", "VarName1050", "VarName1051", "VarName1052", "VarName1053", "VarName1054", "VarName1055", "VarName1056", "VarName1057", "VarName1058", "VarName1059", "VarName1060", "VarName1061", "VarName1062", "VarName1063", "VarName1064", "VarName1065", "VarName1066", "VarName1067", "VarName1068", "VarName1069", "VarName1070", "VarName1071", "VarName1072", "VarName1073", "VarName1074", "VarName1075", "VarName1076", "VarName1077", "VarName1078", "VarName1079", "VarName1080", "VarName1081", "VarName1082", "VarName1083", "VarName1084", "VarName1085", "VarName1086", "VarName1087", "VarName1088", "VarName1089", "VarName1090", "VarName1091", "VarName1092", "VarName1093", "VarName1094"];
opts.SelectedVariableNames = ["Tile", "LatLon", "YYYYMMDD", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40", "VarName41", "VarName42", "VarName43", "VarName44", "VarName45", "VarName46", "VarName47", "VarName48", "VarName49", "VarName50", "VarName51", "VarName52", "VarName53", "VarName54", "VarName55", "VarName56", "VarName57", "VarName58", "VarName59", "VarName60", "VarName61", "VarName62", "VarName63", "VarName64", "VarName65", "VarName66", "VarName67", "VarName68", "VarName69", "VarName70", "VarName71", "VarName72", "VarName73", "VarName74", "VarName75", "VarName76", "VarName77", "VarName78", "VarName79", "VarName80", "VarName81", "VarName82", "VarName83", "VarName84", "VarName85", "VarName86", "VarName87", "VarName88", "VarName89", "VarName90", "VarName91", "VarName92", "VarName93", "VarName94", "VarName95", "VarName96", "VarName97", "VarName98", "VarName99", "VarName100", "VarName101", "VarName102", "VarName103", "VarName104", "VarName105", "VarName106", "VarName107", "VarName108", "VarName109", "VarName110", "VarName111", "VarName112", "VarName113", "VarName114", "VarName115", "VarName116", "VarName117", "VarName118", "VarName119", "VarName120", "VarName121", "VarName122", "VarName123", "VarName124", "VarName125", "VarName126", "VarName127", "VarName128", "VarName129", "VarName130", "VarName131", "VarName132", "VarName133", "VarName134", "VarName135", "VarName136", "VarName137", "VarName138", "VarName139", "VarName140", "VarName141", "VarName142", "VarName143", "VarName144", "VarName145", "VarName146", "VarName147", "VarName148", "VarName149", "VarName150", "VarName151", "VarName152", "VarName153", "VarName154", "VarName155", "VarName156", "VarName157", "VarName158", "VarName159", "VarName160", "VarName161", "VarName162", "VarName163", "VarName164", "VarName165", "VarName166", "VarName167", "VarName168", "VarName169", "VarName170", "VarName171", "VarName172", "VarName173", "VarName174", "VarName175", "VarName176", "VarName177", "VarName178", "VarName179", "VarName180", "VarName181", "VarName182", "VarName183", "VarName184", "VarName185", "VarName186", "VarName187", "VarName188", "VarName189", "VarName190", "VarName191", "VarName192", "VarName193", "VarName194", "VarName195", "VarName196", "VarName197", "VarName198", "VarName199", "VarName200", "VarName201", "VarName202", "VarName203", "VarName204", "VarName205", "VarName206", "VarName207", "VarName208", "VarName209", "VarName210", "VarName211", "VarName212", "VarName213", "VarName214", "VarName215", "VarName216", "VarName217", "VarName218", "VarName219", "VarName220", "VarName221", "VarName222", "VarName223", "VarName224", "VarName225", "VarName226", "VarName227", "VarName228", "VarName229", "VarName230", "VarName231", "VarName232", "VarName233", "VarName234", "VarName235", "VarName236", "VarName237", "VarName238", "VarName239", "VarName240", "VarName241", "VarName242", "VarName243", "VarName244", "VarName245", "VarName246", "VarName247", "VarName248", "VarName249", "VarName250", "VarName251", "VarName252", "VarName253", "VarName254", "VarName255", "VarName256", "VarName257", "VarName258", "VarName259", "VarName260", "VarName261", "VarName262", "VarName263", "VarName264", "VarName265", "VarName266", "VarName267", "VarName268", "VarName269", "VarName270", "VarName271", "VarName272", "VarName273", "VarName274", "VarName275", "VarName276", "VarName277", "VarName278", "VarName279", "VarName280", "VarName281", "VarName282", "VarName283", "VarName284", "VarName285", "VarName286", "VarName287", "VarName288", "VarName289", "VarName290", "VarName291", "VarName292", "VarName293", "VarName294", "VarName295", "VarName296", "VarName297", "VarName298", "VarName299", "VarName300", "VarName301", "VarName302", "VarName303", "VarName304", "VarName305", "VarName306", "VarName307", "VarName308", "VarName309", "VarName310", "VarName311", "VarName312", "VarName313", "VarName314", "VarName315", "VarName316", "VarName317", "VarName318", "VarName319", "VarName320", "VarName321", "VarName322", "VarName323", "VarName324", "VarName325", "VarName326", "VarName327", "VarName328", "VarName329", "VarName330", "VarName331", "VarName332", "VarName333", "VarName334", "VarName335", "VarName336", "VarName337", "VarName338", "VarName339", "VarName340", "VarName341", "VarName342", "VarName343", "VarName344", "VarName345", "VarName346", "VarName347", "VarName348", "VarName349", "VarName350", "VarName351", "VarName352", "VarName353", "VarName354", "VarName355", "VarName356", "VarName357", "VarName358", "VarName359", "VarName360", "VarName361", "VarName362", "VarName363", "VarName364", "VarName365", "VarName366", "VarName367", "VarName368", "VarName369", "VarName370", "VarName371", "VarName372", "VarName373", "VarName374", "VarName375", "VarName376", "VarName377", "VarName378", "VarName379", "VarName380", "VarName381", "VarName382", "VarName383", "VarName384", "VarName385", "VarName386", "VarName387", "VarName388", "VarName389", "VarName390", "VarName391", "VarName392", "VarName393", "VarName394", "VarName395", "VarName396", "VarName397", "VarName398", "VarName399", "VarName400", "VarName401", "VarName402", "VarName403", "VarName404", "VarName405", "VarName406", "VarName407", "VarName408", "VarName409", "VarName410", "VarName411", "VarName412", "VarName413", "VarName414", "VarName415", "VarName416", "VarName417", "VarName418", "VarName419", "VarName420", "VarName421", "VarName422", "VarName423", "VarName424", "VarName425", "VarName426", "VarName427", "VarName428", "VarName429", "VarName430", "VarName431", "VarName432", "VarName433", "VarName434", "VarName435", "VarName436", "VarName437", "VarName438", "VarName439", "VarName440", "VarName441", "VarName442", "VarName443", "VarName444", "VarName445", "VarName446", "VarName447", "VarName448", "VarName449", "VarName450", "VarName451", "VarName452", "VarName453", "VarName454", "VarName455", "VarName456", "VarName457", "VarName458", "VarName459", "VarName460", "VarName461", "VarName462", "VarName463", "VarName464", "VarName465", "VarName466", "VarName467", "VarName468", "VarName469", "VarName470", "VarName471", "VarName472", "VarName473", "VarName474", "VarName475", "VarName476", "VarName477", "VarName478", "VarName479", "VarName480", "VarName481", "VarName482", "VarName483", "VarName484", "VarName485", "VarName486", "VarName487", "VarName488", "VarName489", "VarName490", "VarName491", "VarName492", "VarName493", "VarName494", "VarName495", "VarName496", "VarName497", "VarName498", "VarName499", "VarName500", "VarName501", "VarName502", "VarName503", "VarName504", "VarName505", "VarName506", "VarName507", "VarName508", "VarName509", "VarName510", "VarName511", "VarName512", "VarName513", "VarName514", "VarName515", "VarName516", "VarName517", "VarName518", "VarName519", "VarName520", "VarName521", "VarName522", "VarName523", "VarName524", "VarName525", "VarName526", "VarName527", "VarName528", "VarName529", "VarName530", "VarName531", "VarName532", "VarName533", "VarName534", "VarName535", "VarName536", "VarName537", "VarName538", "VarName539", "VarName540", "VarName541", "VarName542", "VarName543", "VarName544", "VarName545", "VarName546", "VarName547", "VarName548", "VarName549", "VarName550", "VarName551", "VarName552", "VarName553", "VarName554", "VarName555", "VarName556", "VarName557", "VarName558", "VarName559", "VarName560", "VarName561", "VarName562", "VarName563", "VarName564", "VarName565", "VarName566", "VarName567", "VarName568", "VarName569", "VarName570", "VarName571", "VarName572", "VarName573", "VarName574", "VarName575", "VarName576", "VarName577", "VarName578", "VarName579", "VarName580", "VarName581", "VarName582", "VarName583", "VarName584", "VarName585", "VarName586", "VarName587", "VarName588", "VarName589", "VarName590", "VarName591", "VarName592", "VarName593", "VarName594", "VarName595", "VarName596", "VarName597", "VarName598", "VarName599", "VarName600", "VarName601", "VarName602", "VarName603", "VarName604", "VarName605", "VarName606", "VarName607", "VarName608", "VarName609", "VarName610", "VarName611", "VarName612", "VarName613", "VarName614", "VarName615", "VarName616", "VarName617", "VarName618", "VarName619", "VarName620", "VarName621", "VarName622", "VarName623", "VarName624", "VarName625", "VarName626", "VarName627", "VarName628", "VarName629", "VarName630", "VarName631", "VarName632", "VarName633", "VarName634", "VarName635", "VarName636", "VarName637", "VarName638", "VarName639", "VarName640", "VarName641", "VarName642", "VarName643", "VarName644", "VarName645", "VarName646", "VarName647", "VarName648", "VarName649", "VarName650", "VarName651", "VarName652", "VarName653", "VarName654", "VarName655", "VarName656", "VarName657", "VarName658", "VarName659", "VarName660", "VarName661", "VarName662", "VarName663", "VarName664", "VarName665", "VarName666", "VarName667", "VarName668", "VarName669", "VarName670", "VarName671", "VarName672", "VarName673", "VarName674", "VarName675", "VarName676", "VarName677", "VarName678", "VarName679", "VarName680", "VarName681", "VarName682", "VarName683", "VarName684", "VarName685", "VarName686", "VarName687", "VarName688", "VarName689", "VarName690", "VarName691", "VarName692", "VarName693", "VarName694", "VarName695", "VarName696", "VarName697", "VarName698", "VarName699", "VarName700", "VarName701", "VarName702", "VarName703", "VarName704", "VarName705", "VarName706", "VarName707", "VarName708", "VarName709", "VarName710", "VarName711", "VarName712", "VarName713", "VarName714", "VarName715", "VarName716", "VarName717", "VarName718", "VarName719", "VarName720", "VarName721", "VarName722", "VarName723", "VarName724", "VarName725", "VarName726", "VarName727", "VarName728", "VarName729", "VarName730", "VarName731", "VarName732", "VarName733", "VarName734", "VarName735", "VarName736", "VarName737", "VarName738", "VarName739", "VarName740", "VarName741", "VarName742", "VarName743", "VarName744", "VarName745", "VarName746", "VarName747", "VarName748", "VarName749", "VarName750", "VarName751", "VarName752", "VarName753", "VarName754", "VarName755", "VarName756", "VarName757", "VarName758", "VarName759", "VarName760", "VarName761", "VarName762", "VarName763", "VarName764", "VarName765", "VarName766", "VarName767", "VarName768", "VarName769", "VarName770", "VarName771", "VarName772", "VarName773", "VarName774", "VarName775", "VarName776", "VarName777", "VarName778", "VarName779", "VarName780", "VarName781", "VarName782", "VarName783", "VarName784", "VarName785", "VarName786", "VarName787", "VarName788", "VarName789", "VarName790", "VarName791", "VarName792", "VarName793", "VarName794", "VarName795", "VarName796", "VarName797", "VarName798", "VarName799", "VarName800", "VarName801", "VarName802", "VarName803", "VarName804", "VarName805", "VarName806", "VarName807", "VarName808", "VarName809", "VarName810", "VarName811", "VarName812", "VarName813", "VarName814", "VarName815", "VarName816", "VarName817", "VarName818", "VarName819", "VarName820", "VarName821", "VarName822", "VarName823", "VarName824", "VarName825", "VarName826", "VarName827", "VarName828", "VarName829", "VarName830", "VarName831", "VarName832", "VarName833", "VarName834", "VarName835", "VarName836", "VarName837", "VarName838", "VarName839", "VarName840", "VarName841", "VarName842", "VarName843", "VarName844", "VarName845", "VarName846", "VarName847", "VarName848", "VarName849", "VarName850", "VarName851", "VarName852", "VarName853", "VarName854", "VarName855", "VarName856", "VarName857", "VarName858", "VarName859", "VarName860", "VarName861", "VarName862", "VarName863", "VarName864", "VarName865", "VarName866", "VarName867", "VarName868", "VarName869", "VarName870", "VarName871", "VarName872", "VarName873", "VarName874", "VarName875", "VarName876", "VarName877", "VarName878", "VarName879", "VarName880", "VarName881", "VarName882", "VarName883", "VarName884", "VarName885", "VarName886", "VarName887", "VarName888", "VarName889", "VarName890", "VarName891", "VarName892", "VarName893", "VarName894", "VarName895", "VarName896", "VarName897", "VarName898", "VarName899", "VarName900", "VarName901", "VarName902", "VarName903", "VarName904", "VarName905", "VarName906", "VarName907", "VarName908", "VarName909", "VarName910", "VarName911", "VarName912", "VarName913", "VarName914", "VarName915", "VarName916", "VarName917", "VarName918", "VarName919", "VarName920", "VarName921", "VarName922", "VarName923", "VarName924", "VarName925", "VarName926", "VarName927", "VarName928", "VarName929", "VarName930", "VarName931", "VarName932", "VarName933", "VarName934", "VarName935", "VarName936", "VarName937", "VarName938", "VarName939", "VarName940", "VarName941", "VarName942", "VarName943", "VarName944", "VarName945", "VarName946", "VarName947", "VarName948", "VarName949", "VarName950", "VarName951", "VarName952", "VarName953", "VarName954", "VarName955", "VarName956", "VarName957", "VarName958", "VarName959", "VarName960", "VarName961", "VarName962", "VarName963", "VarName964", "VarName965", "VarName966", "VarName967", "VarName968", "VarName969", "VarName970", "VarName971", "VarName972", "VarName973", "VarName974", "VarName975", "VarName976", "VarName977", "VarName978", "VarName979", "VarName980", "VarName981", "VarName982", "VarName983", "VarName984", "VarName985", "VarName986", "VarName987", "VarName988", "VarName989", "VarName990", "VarName991", "VarName992", "VarName993", "VarName994", "VarName995", "VarName996", "VarName997", "VarName998", "VarName999", "VarName1000", "VarName1001", "VarName1002", "VarName1003", "VarName1004", "VarName1005", "VarName1006", "VarName1007", "VarName1008", "VarName1009", "VarName1010", "VarName1011", "VarName1012", "VarName1013", "VarName1014", "VarName1015", "VarName1016", "VarName1017", "VarName1018", "VarName1019", "VarName1020", "VarName1021", "VarName1022", "VarName1023", "VarName1024", "VarName1025", "VarName1026", "VarName1027", "VarName1028", "VarName1029", "VarName1030", "VarName1031", "VarName1032", "VarName1033", "VarName1034", "VarName1035", "VarName1036", "VarName1037", "VarName1038", "VarName1039", "VarName1040", "VarName1041", "VarName1042", "VarName1043", "VarName1044", "VarName1045", "VarName1046", "VarName1047", "VarName1048", "VarName1049", "VarName1050", "VarName1051", "VarName1052", "VarName1053", "VarName1054", "VarName1055", "VarName1056", "VarName1057", "VarName1058", "VarName1059", "VarName1060", "VarName1061", "VarName1062", "VarName1063", "VarName1064", "VarName1065", "VarName1066", "VarName1067", "VarName1068", "VarName1069", "VarName1070", "VarName1071", "VarName1072", "VarName1073", "VarName1074", "VarName1075", "VarName1076", "VarName1077", "VarName1078", "VarName1079", "VarName1080", "VarName1081", "VarName1082", "VarName1083", "VarName1084", "VarName1085", "VarName1086", "VarName1087", "VarName1088", "VarName1089", "VarName1090", "VarName1091", "VarName1092", "VarName1093", "VarName1094"];
opts.VariableTypes = ["string", "string", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "LatLon"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Tile", "TrimNonNumeric", true);
opts = setvaropts(opts, "Tile", "ThousandsSeparator", ",");
scaled250m16daysEVI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-Ha1-MODIS/filtered_scaled_250m_16_days_EVI.csv", opts);
clear opts

EVI.Y = floor(scaled250m16daysEVI.Tile./1000);
EVI.JD = floor(scaled250m16daysEVI.Tile-EVI.Y.*1000);
EVI.dateloc = datetime(EVI.Y,1,EVI.JD);
EVI.meanEVI = mean([scaled250m16daysEVI.VarName6,scaled250m16daysEVI.VarName7,...
    scaled250m16daysEVI.VarName8,scaled250m16daysEVI.VarName9,...
    scaled250m16daysEVI.VarName10,scaled250m16daysEVI.VarName11],2,'omitnan');
figure;
plot(EVI.dateloc,scaled250m16daysEVI.VarName6); hold on;
plot(EVI.dateloc,scaled250m16daysEVI.VarName7); plot(EVI.dateloc,scaled250m16daysEVI.VarName8)
plot(EVI.dateloc,scaled250m16daysEVI.VarName9)

% .................................................................................................
%% Set up the Import Options and import the data
% .................................................................................................
% % opts = delimitedTextImportOptions("NumVariables", 40);
% % opts.DataLines = [19, Inf];
% % opts.Delimiter = ",";
% % opts.VariableNames = ["daydate", "local_std_time", "doy", "filename", "solar_elev", "exposure", "awbflag", "mask_index", "gcc", "rcc", "r_mean", "r_std", "r_5_qtl", "r_10_qtl", "r_25_qtl", "r_50_qtl", "r_75_qtl", "r_90_qtl", "r_95_qtl", "g_mean", "g_std", "g_5_qtl", "g_10_qtl", "g_25_qtl", "g_50_qtl", "g_75_qtl", "g_90_qtl", "g_95_qtl", "b_mean", "b_std", "b_5_qtl", "b_10_qtl", "b_25_qtl", "b_50_qtl", "b_75_qtl", "b_90_qtl", "b_95_qtl", "r_g_correl", "g_b_correl", "b_r_correl"];
% % opts.VariableTypes = ["datetime", "datetime", "double", "string", "double", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% % opts.ExtraColumnsRule = "ignore";
% % opts.EmptyLineRule = "read";
% % opts = setvaropts(opts, "filename", "WhitespaceRule", "preserve");
% % opts = setvaropts(opts, ["filename", "exposure", "awbflag"], "EmptyFieldRule", "auto");
% % opts = setvaropts(opts, "daydate", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "local_std_time", "InputFormat", "HH:mm:ss", "DatetimeFormat", "preserveinput");
% % ROIoriginal = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-Ha1-phenocam/harvard_DB_1000_provisional_data/provisional_data/data_record_3/harvard_DB_1000_roistats.csv", opts);
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
ROIoriginal = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-Ha1-phenocam/harvard_DB_1000_provisional_data/provisional_data/data_record_4/harvard_DB_1000_1day.csv", opts);
clear opts

% % [ROI.dayY,ROI.dayM,ROI.dayD] = datevec(ROI.daydate);
% % window_size = 365 * 3;
% % ROI.gcc_mean = AM_rm_trend(ROI.gcc_mean,window_size); ROI.gcc_50 = AM_rm_trend(ROI.gcc_50,window_size);
% % ROI.gcc_75 = AM_rm_trend(ROI.gcc_75,window_size);     ROI.gcc_90 = AM_rm_trend(ROI.gcc_90,window_size);
% % ROI.rcc_mean = AM_rm_trend(ROI.rcc_mean,window_size); ROI.rcc_50 = AM_rm_trend(ROI.rcc_50,window_size);
% % ROI.rcc_75 = AM_rm_trend(ROI.rcc_75,window_size);     ROI.rcc_90 = AM_rm_trend(ROI.rcc_90,window_size);
% % ROI.r_mean = AM_rm_trend(ROI.r_mean,window_size);     ROI.g_mean = AM_rm_trend(ROI.g_mean,window_size);
% % ROI.b_mean = AM_rm_trend(ROI.b_mean,window_size);
% % ROI.midday_r = AM_rm_trend(ROI.midday_r,window_size); ROI.midday_g = AM_rm_trend(ROI.midday_g,window_size);
% % ROI.midday_b = AM_rm_trend(ROI.midday_b,window_size);
ROIoriginal.GRRI_mean = ROIoriginal.g_mean./ROIoriginal.r_mean;
ROIoriginal.cci_mean = (ROIoriginal.g_mean-ROIoriginal.r_mean)./(ROIoriginal.g_mean+ROIoriginal.r_mean);
ROIoriginal.exgreen_mean = ((2.*ROIoriginal.g_mean)-ROIoriginal.r_mean-ROIoriginal.b_mean);%./(ROI.g_mean+ROI.r_mean+ROI.b_mean);

%% ................camera hourly .........................................
opts = delimitedTextImportOptions("NumVariables", 40);
opts.DataLines = [19, Inf];       opts.Delimiter = ",";
opts.VariableNames = ["dayloc", "local_std_time", "doy", "filename", "solar_elev", "exposure", "awbflag", "mask_index", "gcc", "rcc", "r_mean", "r_std", "r_5_qtl", "r_10_qtl", "r_25_qtl", "r_50_qtl", "r_75_qtl", "r_90_qtl", "r_95_qtl", "g_mean", "g_std", "g_5_qtl", "g_10_qtl", "g_25_qtl", "g_50_qtl", "g_75_qtl", "g_90_qtl", "g_95_qtl", "b_mean", "b_std", "b_5_qtl", "b_10_qtl", "b_25_qtl", "b_50_qtl", "b_75_qtl", "b_90_qtl", "b_95_qtl", "r_g_correl", "g_b_correl", "b_r_correl"];
opts.VariableTypes = ["datetime", "duration", "double", "string", "double", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";    opts.EmptyLineRule = "read";
opts = setvaropts(opts, "filename", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["filename", "exposure", "awbflag"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "dayloc", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
opts = setvaropts(opts, "local_std_time", "InputFormat", "hh:mm:ss.S");
ROIhour = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-Ha1-phenocam/harvard_DB_1000_provisional_data/provisional_data/data_record_3/harvard_DB_1000_roistats.csv", opts);

ROIhour.dateloc = ROIhour.dayloc+ROIhour.local_std_time;
[ROIhour.Y,ROIhour.M,ROIhour.D,ROIhour.HR,ROIhour.MI] = datevec(ROIhour.dateloc);

JD  = day(ROIhour.dateloc,'dayofyear');
lat = lat_FN(ip);                           lon = lon_FN(ip);
HRMI = round(ROIhour.HR+(ROIhour.MI/60),1);
[ROIhour.So,~,~,~,~,SolarZenithAngleDeg] = AM_solar_rad(JD,HRMI,lat,lon);

ROI = [];
ind = find((ROIhour.HR>13)|(ROIhour.HR<10)|(ROIhour.So<300)|(ROIhour.Y>2024));
ROIhour.r_mean(ind) = NaN;    ROIhour.b_mean(ind) = NaN;   ROIhour.g_mean(ind) = NaN;
[ROI.r_mean,~,~,~,ROI.daydate] = AM_day(ROIhour.r_mean,ROIhour.dateloc,1);
[ROI.g_mean] = AM_day(ROIhour.g_mean,ROIhour.dateloc,1);
[ROI.b_mean] = AM_day(ROIhour.b_mean,ROIhour.dateloc,1);

[ROI.dayY,ROI.dayM,ROI.dayD] = datevec(ROI.daydate);
ROI.year = unique(ROI.dayY);

ROI.rcc_mean = ROI.r_mean./(ROI.r_mean+ROI.b_mean+ROI.g_mean);
ROI.gcc_mean = ROI.g_mean./(ROI.r_mean+ROI.b_mean+ROI.g_mean);
ROI.GRRI_mean = ROI.g_mean./ROI.r_mean;
ROI.GRIVI_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
ROI.cci_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
ROI.exgreen_mean = ((2.*ROI.g_mean)-ROI.r_mean-ROI.b_mean);%./(ROI.g_mean+ROI.r_mean+ROI.b_mean);

% .................................................................................................
%% Set up the Import Options and import the data
% .................................................................................................
opts = delimitedTextImportOptions("NumVariables", 10);
opts.DataLines = [2, Inf];         opts.Delimiter = ",";
opts.VariableNames = ["datetime", "dateloc", "doy", "time", "distance", "transect", "lai_unmasked", "sel_unmasked", "lai_masked", "sel_masked"];
opts.VariableTypes = ["datetime", "datetime", "double", "duration", "double", "double", "double", "double", "double", "categorical"];
opts.ExtraColumnsRule = "ignore";  opts.EmptyLineRule = "read";
opts = setvaropts(opts, "sel_masked", "EmptyFieldRule", "auto");
opts = setvaropts(opts, "datetime", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss", "DatetimeFormat", "preserveinput");
opts = setvaropts(opts, "dateloc", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
opts = setvaropts(opts, "time", "InputFormat", "hh:mm:ss.S");
LAIlph = readtimetable("/home/ncoupe/Documents/Fluxnet/US-Ha1/LAI/hf150-02-lph-lai.csv", opts, "RowTimes", "datetime");

opts = delimitedTextImportOptions("NumVariables", 8);
opts.DataLines = [2, Inf];           opts.Delimiter = ",";
opts.VariableNames = ["datetime", "dateloc", "doy", "time", "distance", "transect", "lai_masked", "sel"];
opts.VariableTypes = ["datetime", "datetime", "double", "datetime", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";    opts.EmptyLineRule = "read";
opts = setvaropts(opts, "datetime", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss", "DatetimeFormat", "preserveinput");
opts = setvaropts(opts, "dateloc", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
opts = setvaropts(opts, "time", "InputFormat", "hh:mm:ss.S");
LAIhem = readtimetable("/home/ncoupe/Documents/Fluxnet/US-Ha1/LAI/hf150-01-hem-lai.csv", opts, "RowTimes", "datetime");
clear opts

opts = delimitedTextImportOptions("NumVariables", 11);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["daydate", "year", "doy", "site", "n_plots", "all_mean", "all_stdev", "all_conf_int", "decid_mean", "decid_stdev", "decid_conf_int"];
opts.VariableTypes = ["datetime", "double", "double", "categorical", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, "site", "EmptyFieldRule", "auto");
opts = setvaropts(opts, "daydate", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
LAIsite = readtable("/home/ncoupe/Documents/Fluxnet/US-Ha1/LAI/hf069-02-lai-site.csv", opts);
clear opts

ind = find(LAIlph.lai_masked==-9999.);                                     LAIlph.lai_masked(ind) = NaN;
ind = find(LAIlph.lai_unmasked==-9999.);                                 LAIlph.lai_unmasked(ind) = NaN;
[LAIlph.Y,LAIlph.M,LAIlph.D] = datevec(LAIlph.dateloc);           LAIlph.JD = day(LAIlph.dateloc,'dayofyear');
LAIlph.JD = day(LAIlph.dateloc,'dayofyear');                             LAIlph.So = AM_solar_rad(LAIlph.JD,12,lat,lon);
% ix = LAIlph.lai_masked;

ind = find(LAIhem.lai_masked==-9999.);                                   LAIhem.lai_masked(ind) = NaN;
% ind = find(LAIhem.lai_unmasked==-9999.);                               LAIhem.lai_unmasked(ind) = NaN;
[LAIhem.Y,LAIhem.M,LAIhem.D] = datevec(LAIhem.dateloc);  LAIhem.JD = day(LAIhem.dateloc,'dayofyear');
LAIhem.JD = day(LAIhem.dateloc,'dayofyear');                         LAIhem.So = AM_solar_rad(LAIhem.JD,12,lat,lon);
% ix = LAIlph.lai_masked;

data = LAIsite;     [~, idx] = unique(data(:,"daydate"),'stable');   LAIsite = data(idx,:);
data = sortrows( LAIsite, 'daydate');                                           LAIsite = data;
LAIsite.all_mean(LAIsite.all_mean<1) = NaN;

figure('Color','white');
plot(LAIlph.dateloc,LAIlph.lai_masked,'.'); hold on;      plot(LAIlph.dateloc,LAIlph.lai_unmasked,'.'); hold on
plot(LAIhem.dateloc,LAIhem.lai_masked,'.');
ind = find(LAIsite.site=='ems');                     plot(LAIsite.daydate(ind),LAIsite.all_mean(ind),'k'); hold on
ind = find(LAIsite.site=='harv');                     plot(LAIsite.daydate(ind),LAIsite.all_mean(ind),'m'); hold on

LAIsite = LAIsite((LAIsite.site=='ems'),:);
LAIsite( (isnat(LAIsite.daydate)),:) = [];

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
% NDVI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-Ha1-geonex/NDVI.csv/NDVI.csv", opts);
% clear opts


%% Add Daymet
Ha1.par_day = Ha1.par;        Ha1.par_day(Ha1.So<tresholdSo) = NaN;
[Ha1.dayPAR,~,ix,~,Ha1.daydate] = AM_day(Ha1.par,Ha1.dateloc,0);   Ha1.dayPAR(ix<21) = NaN;
[Ha1.dayPARday,~,ix] = AM_day(Ha1.par_day,Ha1.dateloc,0);        Ha1.dayPARday(ix<6) = NaN;

Ha1.tairday = Ha1.tair;      Ha1.tairday(Ha1.So<tresholdSo) = NaN;
[Ha1.daytairday,~,ix,~,~,Ha1.daytairdaymin,Ha1.daytairdaymax] = AM_day(Ha1.tairday,Ha1.dateloc,0);
Ha1.daytairday(ix<tresholdCycleDay) = NaN;      Ha1.daytairdaymin(ix<tresholdCycleDay) = NaN;         Ha1.daytairdaymax(ix<tresholdCycleDay) = NaN;
[Ha1.dayY,Ha1.dayM,~] = datevec(Ha1.daydate);

%%
FolderDaymet = '/media/ncoupe/Backup/Data/Fluxnet/daymet/';
opts = delimitedTextImportOptions('NumVariables', 9);
opts.DataLines = [10, Inf];    opts.Delimiter = ',';
opts.VariableNames = ["year", "yday", "dayl_s", "prcp_mm_day", "srad_W_m_2", "swe_kg_m_2", "tmax_degC", "tmin_degC", "vp_Pa"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = 'ignore';    opts.EmptyLineRule = 'read';
% opts = setvaropts(opts, ['year', 'yday', 'dayl_s', 'prcp_mm_day', 'srad_W_m_2', 'swe_kg_m_2', 'tmax_degC', 'tmin_degC', 'vp_Pa'], 'WhitespaceRule', 'preserve');
% opts = setvaropts(opts, ['year', 'yday', 'dayl_s', 'prcp_mm_day', 'srad_W_m_2', 'swe_kg_m_2', 'tmax_degC', 'vp_Pa'], 'EmptyFieldRule', 'auto');
daymet = readtable([FolderDaymet 'HA1_11934_lat_42.5378_lon_-72.1715_2026-06-02_205736.csv'], opts);
clear opts

daymet.dayPARday = daymet.srad_W_m_2.*2;
daymet.daydate   = datetime(daymet.year,1,daymet.yday);
daymet.daytairday = (daymet.tmax_degC+daymet.tmin_degC)./2;

%% Add CERES
FolderCERES = '/media/ncoupe/Backup/Data/Fluxnet/CERES/';
    CERES = struct();
    filename = [FolderCERES 'HA1_CERES_SYN1deg-Day_Terra-Aqua-NOAA20_Ed4.2_Subset_20000301-20251231.nc'];
    fileInfo = ncinfo(filename);
    variableNames = {fileInfo.Variables.Name}';
    disp('*** Variable Names in CERES NetCDF File ***');
    disp(variableNames);

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
    plot(Ha1.daydate,Ha1.dayPARday,'c'); ylabel('PAR_{day}');
    legend('CERES','DAYMET','tower')
    subplot(1,2,2);plot(daymet.daydate,daymet.tmax_degC ,'k');  hold on;
    plot(daymet.daydate,daymet.daytairday ,'m');
    plot(Ha1.daydate,Ha1.daytairday,'b');
    legend('DAYMET_{max}','DAYMET','tower'); ylabel('T_{air}_{day}');
%%
Ha1.METEOdaytairmax = interp1(daymet.daydate,daymet.tmax_degC,Ha1.daydate);
Ha1.METEOdaytairday = interp1(daymet.daydate,daymet.daytairday,Ha1.daydate);
Ha1.CERESdayPARday = interp1(CERES.daydate,CERES.dayPARday,Ha1.daydate);
Ha1.METEOdayPARday = interp1(daymet.daydate,daymet.dayPARday,Ha1.daydate);

v1 = 0;         v2 = 1000;          v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/(max(Ha1.Y)-min(Ha1.Y)+1)):v2;
figure('color','white');
subplot(1,2,1); hold on;
ik = Ha1.dayY(1);   count=1;          color_jet = jet(max(Ha1.dayY)-min(Ha1.dayY)+1);
while ik<Ha1.dayY(end)
    hl1  =  plot(Ha1.dayPARday(Ha1.dayY == ik),Ha1.CERESdayPARday(Ha1.dayY == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    [r2] = AM_compute_regression(Ha1.dayPARday(Ha1.dayY == ik),Ha1.CERESdayPARday(Ha1.dayY == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(r2),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('PAR_{day} CERES');  xlabel ('PAR_{day} obs');

subplot(1,2,2);   hold on;
ik = Ha1.dayY(1);   count=1;          color_jet = jet(max(Ha1.dayY)-min(Ha1.dayY)+1);
while ik<Ha1.dayY(end)
    hl1  =  plot(Ha1.dayPARday(Ha1.dayY == ik),Ha1.METEOdayPARday(Ha1.dayY == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    [r2] = AM_compute_regression(Ha1.dayPARday(Ha1.dayY == ik),Ha1.METEOdayPARday(Ha1.dayY == ik),color_jet(count,:),1);
    plot(10,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (14,v4(count),num2str(r2),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('PAR_{day} Daymet');  xlabel ('PAR_{day} obs');

v1 = -10;           v2 = 30;  v3 = v1:((v2-v1)/4):v2;     v4 = v1:((v2-v1)/(max(Ha1.Y)-min(Ha1.Y)+1)):v2;
figure('color','white');
subplot(1,2,1); hold on;
ik = Ha1.dayY(1);   count=1;  color_jet = jet(max(Ha1.dayY)-min(Ha1.dayY)+1);
while ik<Ha1.dayY(end)
    hl1  =  plot(Ha1.daytairday(Ha1.dayY == ik),Ha1.METEOtairday(Ha1.dayY == ik),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
    [r2] = AM_compute_regression(Ha1.daytairday(Ha1.dayY == ik),Ha1.METEOtairday(Ha1.dayY == ik),color_jet(count,:),1);
    plot(-25,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
    text (-20,v4(count),num2str(r2),'FontSize',8);
    ik = ik+1;         count = count+1;
end
ylabel ('tair_{day} Daymet');  xlabel ('PAR_{day} obs');

% save('Ha1.mat','Ha1');
% save('matlabHa1.mat');