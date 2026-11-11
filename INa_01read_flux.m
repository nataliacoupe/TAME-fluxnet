%Reads Indiana cementery turf data. However, it will read any Fluxnet mat file
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

ip = 10;
lat = lat_FN(ip);             lon = lon_FN(ip);             height = height_FN(ip);
site_name = site_name_FN(ip); ust_tresh = ust_tresh_FN(ip); utm = utm_FN(ip);

% .........................................................................
%% Read
% .........................................................................
opts = delimitedTextImportOptions("NumVariables", 68);
opts.DataLines = [4, Inf];          opts.Delimiter = ",";
opts.VariableNames = ["TIMESTAMP_START", "TIMESTAMP_END", "CO2", "CO2_MIXING_RATIO", "CO2_SIGMA", "H2O", "H2O_MIXING_RATIO", "H2O_SIGMA", "FETCH_70", "FETCH_90", "FETCH_MAX", "FC", "SC", "FH2O", "H", "SH", "LE", "SLE", "PA", "RH", "T_SONIC", "MO_LENGTH", "TAU", "USTAR", "U_SIGMA", "V_SIGMA", "W_SIGMA", "WD", "WS", "WS_MAX", "ZL"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";   opts.EmptyLineRule = "read";
INatable = readtable("/media/ncoupe/Backup/Data/Fluxnet/AMF_US-INa_BASE-BADM_2-5/AMF_US-INa_BASE_HH_2-5.csv", opts);
clear opts

INatable.Y = floor(INatable.TIMESTAMP_START./10^8);    INatable.M = floor((INatable.TIMESTAMP_START-INatable.Y.*10^8)./10^6);
INatable.D = floor((INatable.TIMESTAMP_START-(INatable.Y.*10^8)-(INatable.M.*10^6))./10^4);
INatable.HR = floor((INatable.TIMESTAMP_START-(INatable.Y.*10^8)-(INatable.M.*10^6)-(INatable.D.*10^4))./10^2);
% INatable.MI = floor((INatable.TIMESTAMP_START-(INatable.Y.*10^8)-(INatable.M.*10^6)-(INatable.D.*10^4)-(INatable.HR.*10^2))./10^2);
INatable = removevars(INatable, 'TIMESTAMP_START');
INatable = removevars(INatable, 'TIMESTAMP_END');

INatable.dateloc = datetime(INatable.Y,INatable.M,INatable.D,INatable.HR,0,0);

data = INatable;     [~, idx] = unique(data(:,"dateloc"),'stable');   INatable = data(idx,:);
data = sortrows( INatable, 'dateloc');
INatable = data;

for ik = 1:width(INatable)-1
    ij = INatable{:,ik};       ij(ij == -9999.)  = NaN;         ij(ij == 9999.)  = NaN;
    % ij(ind) = NaN;
    ij(ismissing(ij)) = NaN;     INatable{:,ik}   = ij;
end

data = INatable;     [~, idx] = unique(data(:,"dateloc"),'stable');   INatable = data(idx,:);
data = sortrows( INatable, 'dateloc');

data = table2timetable(data);
INatable = retime(data, INatable.dateloc, 'mean');
% INa = timetable2table(INatable);

% commonVars = intersect(INatable.Properties.VariableNames, INatable.Properties.VariableNames);
% INatable = removevars(INatable, commonVars);
% INatable.dateloc = INatable.datelocTMP;

% INajoin = join(INatable,INatable);
INajoin = INatable;

% figure('color','white')
% plot(INajoin.dateloc,INajoin.SWC_7_1_1);  hold on;
% plot(INajoin.dateloc,INajoin.SWC_7_2_1)
% plot(INajoin.dateloc,INajoin.SWC_7_3_1)
% plot(INajoin.dateloc,INajoin.SWC_7_4_1)

%% ........................................................................
INa.dateloc = INajoin.dateloc;
[INa.Y,INa.M,INa.D,INa.HR,~,~] = datevec(INa.dateloc);
INa.dateloc_day = datetime(INa.Y,INa.M,INa.D);
INa.JD = day(INa.dateloc,'dayofyear');

INa.So = AM_solar_rad(INa.JD,INa.HR,lat,lon);

%% ........................................................................
INa.Fc = INajoin.FC;
INa.Sco2 = INajoin.SC;
INa.LE = INajoin.LE;            %INa.LE (INajoin.LE_F_MDS_QC>2) = NaN;
INa.H = INajoin.H;              %INa.H (INajoin.H_F_MDS_QC>2) = NaN;
% INa.netrad = INajoin.NETRAD;  INa.ustar = INajoin.USTAR;
% INa.rain = INajoin.P_PI_1;    INa.par = INajoin.PPFD_IN;   INa.G = NaN(length(INajoin.dateloc),1);
% INa.tair = INajoin.TA;        INa.ws = INajoin.WS;         INa.VPD = INajoin.VPD;
% INa.RH = INajoin.RH;          INa.pambKpa = INajoin.PA;
% INa.pambpa = INa.pambKpa./1000;
INa.CO2  = INajoin.CO2;
INa.fh2o  = INajoin.SH;     %INa.fh2o (INajoin.LE_F_MDS_QC>2) = NaN;
INa.h2ommolm = INajoin.H2O;     INa.tair = INajoin.T_SONIC;
INa.ustar = INajoin.USTAR;      INa.ws   = INajoin.WS;
INa.w_sigma = INajoin.W_SIGMA;  INa.RH   = INajoin.RH;

% INa.nee = INajoin.NEE_CUT_REF; INa.nee(INajoin.NEE_CUT_REF_QC>2) = NaN;
INa.nee = INa.Fc+INa.Sco2;       %INa.nee(INajoin.NEE_VUT_REF_QC>2) = NaN;
% INa.nee(INa.rain>0) = NaN;     INa.reco(INa.rain>0) = NaN;  INa.gep(INa.rain>0) = NaN;
% INa.Fc(INa.rain>0) = NaN;      INa.LE(INa.rain>0) = NaN;    INa.H(INa.rain>0) = NaN;

ix = [NaN;diff(INa.LE)];         INa.LE(ix==0) = NaN;        INa.LE(INa.LE==0) = NaN;
INa.LE(INa.LE>900) = NaN;        INa.H(INa.H>900) = NaN;
% INa.LE(INa.rain>0) = NaN;      INa.H(INa.rain>0) = NaN;

[INa.daytair,~,~,~,INa.daydate] = AM_day(INa.tair,INa.dateloc,1);

%% quick calculation u* threshold, GEP
color_mtx = [0.70, 0.85, 0.50; 0.40, 0.75, 0.30; 0.10, 0.50, 0.10; 0.30, 0.40, 0.20];
figure('color','white');     subplot(2,2,1);  scatter(INa.ustar,INa.nee, 20, 'k', 'filled', 'MarkerFaceAlpha', 0.1);
xlabel('ustar (m s^-^2)');   ylabel('NEE (\mumol m^-^2 s^-^1)'); box on; grid on;

indNight = INa.So == 0;
u_data = INa.ustar(indNight);  nee_data = INa.nee(indNight);  tair_data = INa.tair(indNight);
numBins = 20;
[u_bins, bin_edges] = discretize(u_data, numBins);
bin_means_u   = zeros(numBins, 1);
bin_means_nee = zeros(numBins, 1);
for i = 1:numBins
    bin_means_u(i) = mean(u_data(u_bins == i), 'omitnan');
    bin_means_nee(i) = mean(nee_data(u_bins == i), 'omitnan');
end
threshold_ustar = NaN;
plateau_mean = mean(bin_means_nee(end-5:end)); % Average of the highest 5 bins
for i = 1:numBins
    if bin_means_nee(i) >= 0.95 * plateau_mean
        threshold_ustar = bin_means_u(i);
        break;
    end
end

subplot(2,2,2); scatter(tair_data,nee_data, 20, 'k', 'filled', 'MarkerFaceAlpha', 0.1);
xlabel('tair_{nighttme} (\circC)');   ylabel('NEE (\mumol m^-^2 s^-^1)'); box on; grid on;

figure('color','white','Position',[300,300,500,500]);
scatter(u_data, nee_data, 20, 'k', 'filled', 'MarkerFaceAlpha', 0.1, 'DisplayName', 'Obs'); hold on;
plot(bin_means_u, bin_means_nee, '-o','color',color_mtx(2,:),'MarkerFaceColor',color_mtx(2,:),'LineWidth', 2, 'DisplayName', 'Binned Means');
xline(threshold_ustar, '-b', 'LineWidth', 2, 'DisplayName', ['Threshold: ' num2mstr(threshold_ustar)]);
xlabel('u_{*} (m s^{-1})');
ylabel('Nighttime NEE (\mu mol m^{-2} s^{-1})');
grid on;    box on;
legend('Location', 'southeast');  legend boxoff;
fprintf('Detected u* threshold: %.3f m/s\n', threshold_ustar);

%%
seasons = zeros(length(INa.M), 1);
seasons(ismember(INa.M, [12, 1, 2])) = 1; % Winter
seasons(ismember(INa.M, [3, 4, 5])) = 2;   % Spring
seasons(ismember(INa.M, [6, 7, 8])) = 3;   % Summer
seasons(ismember(INa.M, [9, 10, 11])) = 4; % Fall
seasonName = {'Winter', 'Spring', 'Summer', 'Fall'};

figure('color','white','Position',[300,300,500,500]);
for s = 1:4
    subplot(2,2,s);
    indNight = (seasons == s) & (INa.So == 0);
    s_u = INa.ustar(indNight);    s_nee = INa.nee(indNight);
    scatter(s_u, s_nee, 8, [0.7 0.7 0.7], 'filled', 'MarkerFaceAlpha', 0.15);
    hold on;

    numBins = 20;   bin_u = zeros(numBins, 1);    bin_nee = zeros(numBins, 1);

    [sorted_u, sort_idx] = sort(s_u);  sorted_nee = s_nee(sort_idx);
    pts_per_bin = floor(length(sorted_u) / numBins);
    for b = 1:numBins
        range = ((b-1)*pts_per_bin + 1) : (b*pts_per_bin);
        bin_u(b) = mean(sorted_u(range), 'omitnan');
        bin_nee(b) = mean(sorted_nee(range), 'omitnan');
    end
    plot(bin_u, bin_nee, '-o', 'Color', color_mtx(2,:), 'LineWidth', 2.5, ...
        'MarkerFaceColor', color_mtx(2,:), 'MarkerSize', 4);
    title(seasonName{s});
    xlabel('u_{*} (m s^{-1})'); ylabel('Nighttime NEE');
    grid on;    box on;   ylim([-10 15]);         xlim([0 0.8]);
end

%% ........................................................................
% INa.nee = INa.Fc+INa.Sco2;
ind = find((INa.dateloc_day>=datetime(2018,3,24))&(INa.dateloc_day<=datetime(2018,3,27)));
INa.nee(ind) = NaN;        INa.H(ind) = NaN;        INa.LE(ind) = NaN;

ind = find((INa.ustar<0.1093)|(INa.ustar>0.8)|(INa.dateloc>datetime(2019,4,18)));
ust_tresh  = 0.1093;
% ind = find((INa.ustar<0.1293)|(INa.ustar>0.7)|(INa.dateloc>datetime(2019,4,18)));
% ust_tresh  = 0.1293;
% ind = find((INa.ustar<0.0893)|(INa.ustar>0.7)|(INa.dateloc>datetime(2019,4,18)));
% ust_tresh  = 0.1293;
INa.nee(ind) = NaN;       INa.H(ind) = NaN;        INa.LE(ind) = NaN;
max_neg_Re = -1;          max_neg_GEP = -1;

INa.nee((INa.nee<-40)|(INa.nee>20)) = NaN;    INa.nee = AM_fill(INa.nee);
[~,nee_spike7] = AM_spike_detection(INa.nee,5);
INa.nee = nee_spike7;

[~,~,INa.gep,~,~,INa.reco] =...
    AM_gep_ust_fourier(INa.nee,INa.So,INa.ustar,0,ust_tresh,0,lat,lon,INa.dateloc,utm,max_neg_Re,max_neg_GEP);

% INa.reco = INajoin.RECO;       %INa.gep(INajoin.NEE_VUT_REF_QC>2) = NaN;
% INa.gep = INajoin.GPP;         %INa.gep(INajoin.NEE_VUT_REF_QC>2) = NaN;
% INa.gep = -INa.nee+INa.reco;   INa.gep(INa.gep==0)=NaN;
INa.gep((INa.So==0)&(INa.gep>5))=NaN;   INa.gep((INa.So>0)&(INa.gep<-0.5))=NaN;
INa.gep = AM_fill(INa.gep);
% INa.gep(INa.gep>30) = NaN;
% INa.netrad((INa.So<100)&(INa.netrad>200)) = NaN;
% INa.netrad(INa.netrad>800) = NaN;

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
scaled250m16daysEVI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-INa-MODIS/statistics_250m_16_days_EVI.csv", opts);
clear opts

EVI.Y = floor(scaled250m16daysEVI.modis_date./1000);
EVI.JD = floor(scaled250m16daysEVI.modis_date-EVI.Y.*1000);
EVI.dateloc = datetime(EVI.Y,1,EVI.JD);
figure;
plot(EVI.dateloc,scaled250m16daysEVI.value_center);     ylabel('EVI');

% .................................................................................................
%% GCC from MCD43A1 downloaded using Earth Engine
% .................................................................................................
% Import as 'string' first to avoid the NaT error
opts = delimitedTextImportOptions("NumVariables", 4);
opts.DataLines = [2, Inf]; % Skip the header row
opts.VariableNames = ["rawDate", "r_mean", "g_mean", "b_mean"];
opts.VariableTypes = ["string", "double", "double", "double"];
% ROI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-INa-googleEE/ee-chart.csv", opts);
ROI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-INa-googleEE/INA_CEMENTERYee-chart.csv", opts);
dateParts = split(ROI.rawDate, "-");
ROI.daydate = datetime(str2double(dateParts(:,1)), 1, 1) + days(str2double(dateParts(:,3)) - 1);
ROI.rawDate = [];
head(ROI)
clear opts

ROI.r_mean((ROI.r_mean>0.2)|(ROI.b_mean>0.15)) = NaN;
ROI.g_mean((ROI.g_mean>0.2)|(ROI.b_mean>0.15)) = NaN;
ROI.b_mean(ROI.b_mean>0.15) = NaN;

[ROI.dayY,ROI.dayM,ROI.dayD] = datevec(ROI.daydate);

ROI.rcc_mean = ROI.r_mean./(ROI.r_mean+ROI.b_mean+ROI.g_mean);
ROI.gcc_mean = ROI.g_mean./(ROI.r_mean+ROI.b_mean+ROI.g_mean);
ROI.gcc_mean((ROI.gcc_mean<0.335)|(ROI.gcc_mean>0.49)) = NaN;
ROI.GRRI_mean = ROI.g_mean./ROI.r_mean;
ROI.GRIVI_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
ROI.cci_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
ROI.exgreen_mean = ((2.*ROI.g_mean)-ROI.r_mean-ROI.b_mean);%./(ROI.g_mean+ROI.r_mean+ROI.b_mean);

figure
plot(ROI.daydate,ROI.gcc_mean);  ylabel('GCC');   hold on;

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
% % LAIlph = readtimetable("/home/ncoupe/Documents/Fluxnet/US-INa/LAI/hf150-02-lph-lai.csv", opts, "RowTimes", "datetime");
% %
% % opts = delimitedTextImportOptions("NumVariables", 8);
% % opts.DataLines = [2, Inf];           opts.Delimiter = ",";
% % opts.VariableNames = ["datetime", "dateloc", "doy", "time", "distance", "transect", "lai_masked", "sel"];
% % opts.VariableTypes = ["datetime", "datetime", "double", "datetime", "double", "double", "double", "double"];
% % opts.ExtraColumnsRule = "ignore";    opts.EmptyLineRule = "read";
% % opts = setvaropts(opts, "datetime", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "dateloc", "InputFormat", "yyyy-MM-dd", "DatetimeFormat", "preserveinput");
% % opts = setvaropts(opts, "time", "InputFormat", "hh:mm:ss.S");
% % LAIhem = readtimetable("/home/ncoupe/Documents/Fluxnet/US-INa/LAI/hf150-01-hem-lai.csv", opts, "RowTimes", "datetime");
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
% % LAIsite = readtable("/home/ncoupe/Documents/Fluxnet/US-INa/LAI/hf069-02-lai-site.csv", opts);
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
% % ind = find(LAIsite.site=='ems');                          plot(LAIsite.daydate(ind),LAIsite.all_mean(ind),'k'); hold on
% % ind = find(LAIsite.site=='harv');                         plot(LAIsite.daydate(ind),LAIsite.all_mean(ind),'m'); hold on
% %
% % LAIsite = LAIsite((LAIsite.site=='ems'),:);
% % LAIsite( (isnat(LAIsite.daydate)),:) = [];
LAIsite.daydate = INa.daydate;
LAIsite.all_mean = 4.*ones(length(INa.daydate),1);

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
% NDVI = readtable("/media/ncoupe/Backup/Data/Fluxnet/US-INa-geonex/NDVI.csv/NDVI.csv", opts);
% clear opts

save('INa.mat','INa');
save('matlabINa.mat');