% for TAME work
% Natalia Restrepo-Coupe
% Toronto, December 2025 cold and gloomy
%..........................................................................
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;

load('matlabINa.mat');

flag_model = 1;    flag_read_timesat = 10;   flag_model_test_chromatic = 1;
flag_model_test_gatekeeper = 1;              flag_visualize = 1;
flag_gatewayFixMeteo = 0;                    % 1 if we want to "fix" three of the meteo parameters on the LOYO
flag_chromaticFixMeteo = 0;                  % This flag will "fix" two of the parameters Tmax and Tmin
flag_Taylor = 10;                            flag_normalize = 1;

month_name = ['JAN';'FEB';'MAR';'APR';'MAY';'JUN';'JUL';'AUG';'SEP';'OCT';'NOV';'DEC'];

INa.dayJD = day(INa.daydate,'dayofyear');
[~,~,INa.dayLength,~,~,INa.daySZA] = AM_solar_rad(INa.dayJD,0,lat,lon);
INa.SZArad = INa.daySZA * (pi / 180);

%% ........................................................................
if flag_read_timesat==1
    %% GCC
    % .....................................................................
    % figure('color','white');
    % plot(ROI.daydate,ROI.gcc_mean); hold on
    % ROI.gcc_mean((ROI.gcc_mean<0.30)) = NaN;
    % plot(ROI.daydate,ROI.gcc_mean,'.')
    %
    % [iy,~,~,~,ix] = AM_day(ROI.gcc_mean,ROI.daydate,0);
    % plot(ix,iy)
    % [im,~,~] = datevec(ix);

    % newTime = (datetime(ROI.dayY(1),1,1):days(1):datetime(ROI.dayY(end)+1,12,31))';
    % in = find(newTime==ix(1));   im = find(newTime==ix(end));
    % iw = NaN(in-1,1);            iz = NaN(length(newTime)-im,1);
    % ROIINa.dayGCC = [iw;iy;iz];
    % ROIINa.daydate = newTime;
    % plot( ROIINa.daydate, ROIINa.dayGCC);
    %
    % [ROIINa.day_recurrentGCC,ROIINa.day_recurrent_stdGCC]  = AM_dayAVG_recurrent(ROIINa.dayGCC,ROIINa.daydate);
    % ROIINa.day_recurrentGCCGoley = sgolayfilt(ROIINa.day_recurrentGCC,polyorder,framesize);
    %
    % ROIINa.dayJD = day(ROIINa.daydate,'dayofyear');
    % [ROIINa.dayY,ROIINa.dayM,ROIINa.dayD] = datevec(ROIINa.daydate);

    windowSmooth = 21;

    % Final QA for indices
    iy = INa.ROIgcc;
    % indCamera = []; %find(INa.daydate<datetime(2018,6,1));
    % iy(indCamera) = NaN;
    % ind = find(~isnan(iy));     ix = detrend(iy(ind))+mean(iy,'omitnan');
    INa.ROIgccQA = iy;            %INa.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(INa.ROIgccQA,5);
    % INa.ROIgccQA(INa.daydate>=datetime(2023,1,1)) = NaN;
    INa.ROIgccQA = FN_fillVI(INa.daydate,iy);

    iy = INa.ROIGRRI;
    INa.ROIgrriQA = iy;            %INa.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(INa.ROIgrriQA,5);
    INa.ROIgrriQA = FN_fillVI(INa.daydate,iy);

    iy = INa.ROIGRIVI;
    INa.ROIgriviQA = iy;            %INa.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(INa.ROIgriviQA,5);
    INa.ROIgriviQA = FN_fillVI(INa.daydate,iy);

    iy = INa.ROIexgreen;
    INa.ROIexgreenQA = iy;            %INa.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(INa.ROIexgreenQA,5);
    INa.ROIexgreenQA = FN_fillVI(INa.daydate,iy);

    iy = INa.ROIcci;
    INa.ROIcciQA = iy;            %INa.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(INa.ROIcciQA,5);
    INa.ROIcciQA = FN_fillVI(INa.daydate,iy);

    iy = INa.ROIrcc;
    % iy(INa.ROIrcc<0.385) = NaN;   %INa.ROIrcc(INa.daydate>datetime(2021,12,31)) = NaN;
    % iy(indCamera) = NaN;
    % ind = find(~isnan(iy));       ix = detrend(iy(ind))+mean(iy,'omitnan');
    INa.ROIrccQA = iy;            %INa.ROIrccQA(ind) = ix;
    [~,INa.ROIrccQA] = AM_spike_detection(INa.ROIrccQA,5);
    % iy = smoothdata(INa.ROIrccQA,'movmean',windowSmooth);
    % INa.ROIrccQA(INa.daydate>=datetime(2023,1,1)) = NaN;
    INa.ROIrccQA = FN_fillVI(INa.daydate,iy);

    %% GCC
    filename = 'timesat/INAseasonalityGCC.txt';
    startRow = 2;
    formatSpec = '%5f%6f%6f%10f%9f%9f%9f%9f%9f%9f%10f%10f%9f%9f%9f%9f%C%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    GCC.Seas = dataArray{:, 3};     GCC.BegTtemp = dataArray{:, 4}; GCC.EndTtemp = dataArray{:, 5};
    GCC.LengthVal= dataArray{:, 6}; GCC.Baseval = dataArray{:, 7};  GCC.MaxTtemp = dataArray{:, 8};
    GCC.MaxVal = dataArray{:, 9};   GCC.Ampl = dataArray{:, 10};    GCC.Lder = dataArray{:, 11};
    GCC.Rder = dataArray{:, 12};    GCC.Linteg = dataArray{:, 13};  GCC.Sinteg = dataArray{:, 14};
    GCC.StartVal = dataArray{:, 15};GCC.EndVa = dataArray{:, 16};   GCC.lVal = dataArray{:, 17};

    GCC.BegTtemp(GCC.BegTtemp<=0) = NaN;    GCC.EndTtemp(GCC.EndTtemp<=0) = NaN;
    GCC.MaxTtemp(GCC.MaxTtemp<=0) = NaN;    GCC.LengthVal(GCC.LengthVal<=0) = NaN;
    GCC.LengthVal = AM_fill_plus(GCC.LengthVal);

    GCC.BegTdate = NaT(length(GCC.BegTtemp),1);     GCC.EndTdate = GCC.BegTdate;
    GCC.MaxTdate = GCC.BegTdate;
    for ix = 1:length(GCC.BegTtemp)
        if ~isnan(GCC.BegTtemp(ix));   GCC.BegTdate(ix) = ROIINa.daydate(ceil(GCC.BegTtemp(ix)));   end
        if ~isnan(GCC.EndTtemp(ix));   GCC.EndTdate(ix) = ROIINa.daydate(floor(GCC.EndTtemp(ix)));  end
        if ~isnan(GCC.MaxTtemp(ix));   GCC.MaxTdate(ix) = ROIINa.daydate(floor(GCC.MaxTtemp(ix)));  end
    end

    GCC.BegTjd = day(GCC.BegTdate,'dayofyear');
    GCC.EndTjd = day(GCC.EndTdate,'dayofyear');
    GCC.MaxTjd = day(GCC.MaxTdate,'dayofyear');

    ind = find((GCC.BegTdate>=ROIINa.daydate(1))&(GCC.BegTdate<=ROIINa.daydate(end)));  GCC.BegT = GCC.BegTjd(ind);
    ind = find((GCC.EndTdate>=ROIINa.daydate(1))&(GCC.EndTdate<=ROIINa.daydate(end)));  GCC.EndT = GCC.EndTjd(ind);
    ind = find((GCC.MaxTdate>=ROIINa.daydate(1))&(GCC.MaxTdate<=ROIINa.daydate(end)));  GCC.MaxT = GCC.MaxTjd(ind);

    [ROIINa.daydateY,ROIINa.daydateM,ROIINa.daydateD] = datevec(ROIINa.daydate);
    GCC.daydateYears = unique(ROIINa.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% GRRI
    filename = 'timesat/INAseasonalityGRRI.txt';
    startRow = 2;
    formatSpec = '%5f%6f%6f%10f%9f%9f%9f%9f%9f%9f%10f%10f%9f%9f%9f%9f%C%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    GRRI.Seas = dataArray{:, 3};     GRRI.BegTtemp = dataArray{:, 4}; GRRI.EndTtemp = dataArray{:, 5};
    GRRI.LengthVal= dataArray{:, 6}; GRRI.Baseval = dataArray{:, 7};  GRRI.MaxTtemp = dataArray{:, 8};
    GRRI.MaxVal = dataArray{:, 9};   GRRI.Ampl = dataArray{:, 10};    GRRI.Lder = dataArray{:, 11};
    GRRI.Rder = dataArray{:, 12};    GRRI.Linteg = dataArray{:, 13};  GRRI.Sinteg = dataArray{:, 14};
    GRRI.StartVal = dataArray{:, 15};GRRI.EndVa = dataArray{:, 16};   GRRI.lVal = dataArray{:, 17};

    GRRI.BegTtemp(GRRI.BegTtemp<=0) = NaN;    GRRI.EndTtemp(GRRI.EndTtemp<=0) = NaN;
    GRRI.MaxTtemp(GRRI.MaxTtemp<=0) = NaN;    GRRI.LengthVal(GRRI.LengthVal<=0) = NaN;
    GRRI.LengthVal = AM_fill_plus(GRRI.LengthVal);

    GRRI.BegTdate = NaT(length(GRRI.BegTtemp),1);     GRRI.EndTdate = GRRI.BegTdate;
    GRRI.MaxTdate = GRRI.BegTdate;
    for ix = 1:length(GRRI.BegTtemp)
        if ~isnan(GRRI.BegTtemp(ix));   GRRI.BegTdate(ix) = ROIINa.daydate(ceil(GRRI.BegTtemp(ix)));   end
        if ~isnan(GRRI.EndTtemp(ix));   GRRI.EndTdate(ix) = ROIINa.daydate(floor(GRRI.EndTtemp(ix)));  end
        if ~isnan(GRRI.MaxTtemp(ix));   GRRI.MaxTdate(ix) = ROIINa.daydate(floor(GRRI.MaxTtemp(ix)));  end
    end

    GRRI.BegTjd = day(GRRI.BegTdate,'dayofyear');
    GRRI.EndTjd = day(GRRI.EndTdate,'dayofyear');
    GRRI.MaxTjd = day(GRRI.MaxTdate,'dayofyear');

    ind = find((GRRI.BegTdate>=ROIINa.daydate(1))&(GRRI.BegTdate<=ROIINa.daydate(end)));  GRRI.BegT = GRRI.BegTjd(ind);
    ind = find((GRRI.EndTdate>=ROIINa.daydate(1))&(GRRI.EndTdate<=ROIINa.daydate(end)));  GRRI.EndT = GRRI.EndTjd(ind);
    ind = find((GRRI.MaxTdate>=ROIINa.daydate(1))&(GRRI.MaxTdate<=ROIINa.daydate(end)));  GRRI.MaxT = GRRI.MaxTjd(ind);

    [ROIINa.daydateY,ROIINa.daydateM,ROIINa.daydateD] = datevec(ROIINa.daydate);
    GRRI.daydateYears = unique(ROIINa.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% RCC
    filename = 'timesat/INAseasonalityRCC.txt';
    startRow = 2;
    formatSpec = '%5f%6f%6f%10f%9f%9f%9f%9f%9f%9f%10f%10f%9f%9f%9f%9f%C%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    RCC.Seas = dataArray{:, 3};     RCC.BegTtemp = dataArray{:, 4}; RCC.EndTtemp = dataArray{:, 5};
    RCC.LengthVal= dataArray{:, 6}; RCC.Baseval = dataArray{:, 7};  RCC.MaxTtemp = dataArray{:, 8};
    RCC.MaxVal = dataArray{:, 9};   RCC.Ampl = dataArray{:, 10};    RCC.Lder = dataArray{:, 11};
    RCC.Rder = dataArray{:, 12};    RCC.Linteg = dataArray{:, 13};  RCC.Sinteg = dataArray{:, 14};
    RCC.StartVal = dataArray{:, 15};RCC.EndVa = dataArray{:, 16};   RCC.lVal = dataArray{:, 17};

    RCC.BegTtemp(RCC.BegTtemp<=0) = NaN;    RCC.EndTtemp(RCC.EndTtemp<=0) = NaN;
    RCC.MaxTtemp(RCC.MaxTtemp<=0) = NaN;    RCC.LengthVal(RCC.LengthVal<=0) = NaN;
    RCC.LengthVal = AM_fill_plus(RCC.LengthVal);

    RCC.BegTdate = NaT(length(RCC.BegTtemp),1);     RCC.EndTdate = RCC.BegTdate;
    RCC.MaxTdate = RCC.BegTdate;
    for ix = 1:length(RCC.BegTtemp)-1
        if ~isnan(RCC.BegTtemp(ix));   RCC.BegTdate(ix) = ROIINa.daydate(ceil(RCC.BegTtemp(ix)));   end
        if ~isnan(RCC.EndTtemp(ix));   RCC.EndTdate(ix) = ROIINa.daydate(floor(RCC.EndTtemp(ix)));  end
        if ~isnan(RCC.MaxTtemp(ix));   RCC.MaxTdate(ix) = ROIINa.daydate(floor(RCC.MaxTtemp(ix)));  end
    end

    RCC.BegTjd = day(RCC.BegTdate,'dayofyear');
    RCC.EndTjd = day(RCC.EndTdate,'dayofyear');
    RCC.MaxTjd = day(RCC.MaxTdate,'dayofyear');

    ind = find((RCC.BegTdate>=ROIINa.daydate(1))&(RCC.BegTdate<=ROIINa.daydate(end)));  RCC.BegT = RCC.BegTjd(ind);
    ind = find((RCC.EndTdate>=ROIINa.daydate(1))&(RCC.EndTdate<=ROIINa.daydate(end)));  RCC.EndT = RCC.EndTjd(ind);
    ind = find((RCC.MaxTdate>=ROIINa.daydate(1))&(RCC.MaxTdate<=ROIINa.daydate(end)));  RCC.MaxT = RCC.MaxTjd(ind);

    RCC.daydateYears = unique(ROIINa.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% RCCabs
    filename = 'timesat/INAseasonalityRCCabs.txt';
    startRow = 2;
    formatSpec = '%5f%6f%6f%10f%9f%9f%9f%9f%9f%9f%10f%10f%9f%9f%9f%9f%C%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    RCCabs.Seas = dataArray{:, 3};     RCCabs.BegTtemp = dataArray{:, 4}; RCCabs.EndTtemp = dataArray{:, 5};
    RCCabs.LengthVal= dataArray{:, 6}; RCCabs.Baseval = dataArray{:, 7};  RCCabs.MaxTtemp = dataArray{:, 8};
    RCCabs.MaxVal = dataArray{:, 9};   RCCabs.Ampl = dataArray{:, 10};    RCCabs.Lder = dataArray{:, 11};
    RCCabs.Rder = dataArray{:, 12};    RCCabs.Linteg = dataArray{:, 13};  RCCabs.Sinteg = dataArray{:, 14};
    RCCabs.StartVal = dataArray{:, 15};RCCabs.EndVa = dataArray{:, 16};   RCCabs.lVal = dataArray{:, 17};

    RCCabs.BegTtemp(RCCabs.BegTtemp<=0) = NaN;    RCCabs.EndTtemp(RCCabs.EndTtemp<=0) = NaN;
    RCCabs.MaxTtemp(RCCabs.MaxTtemp<=0) = NaN;    RCCabs.LengthVal(RCCabs.LengthVal<=0) = NaN;
    RCCabs.LengthVal = AM_fill_plus(RCCabs.LengthVal);

    RCCabs.BegTdate = NaT(length(RCCabs.BegTtemp),1);     RCCabs.EndTdate = RCCabs.BegTdate;
    RCCabs.MaxTdate = RCCabs.BegTdate;
    for ix = 1:length(RCCabs.BegTtemp)
        if ~isnan(RCCabs.BegTtemp(ix));   RCCabs.BegTdate(ix) = ROIINa.daydate(ceil(RCCabs.BegTtemp(ix)));   end
        if ~isnan(RCCabs.EndTtemp(ix));   RCCabs.EndTdate(ix) = ROIINa.daydate(floor(RCCabs.EndTtemp(ix)));  end
        if ~isnan(RCCabs.MaxTtemp(ix));   RCCabs.MaxTdate(ix) = ROIINa.daydate(floor(RCCabs.MaxTtemp(ix)));  end
    end

    RCCabs.BegTjd = day(RCCabs.BegTdate,'dayofyear');
    RCCabs.EndTjd = day(RCCabs.EndTdate,'dayofyear');
    RCCabs.MaxTjd = day(RCCabs.MaxTdate,'dayofyear');

    ind = find((RCCabs.BegTdate>=ROIINa.daydate(1))&(RCCabs.BegTdate<=ROIINa.daydate(end)));  RCCabs.BegT = RCCabs.BegTjd(ind);
    ind = find((RCCabs.EndTdate>=ROIINa.daydate(1))&(RCCabs.EndTdate<=ROIINa.daydate(end)));  RCCabs.EndT = RCCabs.EndTjd(ind);
    ind = find((RCCabs.MaxTdate>=ROIINa.daydate(1))&(RCCabs.MaxTdate<=ROIINa.daydate(end)));  RCCabs.MaxT = RCCabs.MaxTjd(ind);

    RCCabs.daydateYears = unique(ROIINa.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %%
    v1 = -1;         v2 = 10;          v1 = v1+1;      v3 = v1:((v2-v1)/4):v2;
    v4 = v1:((v2-v1)/(max(INa.dayY)-min(ROI.dayY)+1)):v2;
    y1 = 0.3;      y2 = 0.45;         y3 = y1:((y2-y1)/4):y2;
    y4 = y1:((y2-y1)/(max(INa.dayY)-min(ROI.dayY)+1)):y2;
    figure('color','white');           hold on;
    ik = ROI.dayY(1);   count=1;       color_jet = jet(max(INa.dayY)-min(ROI.dayY)+1);
    while (ik<INa.dayY(end))&(count<length(GCC.BegTdate))
        current_SGS = GCC.BegTdate(count);
        current_EGS = GCC.EndTdate(count);
        ind = find((INa.daydate>=current_SGS)&(INa.daydate<=current_EGS)&(INa.dayY == ik));
        hl1  =  plot(INa.ROIgccQA(ind),INa.dayGEPday(ind).*100./INa.dayPARday(ind),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
        AM_compute_regression(INa.ROIgccQA(ind),INa.dayGEPday(ind).*100./INa.dayPARday(ind),color_jet(count,:),1);
        polyfit(INa.ROIgccQA(ind),INa.dayGEPday(ind).*100./INa.dayPARday(ind),2); %color_jet(count,:),1
        plot(.33,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
        text (.34,v4(count),num2str(ik),'FontSize',8);
        ik = ik+1;  count = count+1;
    end
    ylabel ('GEP_{day}/PAR_{day}(\mumolC/\mmol)');              xlabel ('GCC');
    axis([y1 y2 v1 v2])

    %%
    v1 = -1;         v2 = 7;          v1 = v1+1;      v3 = v1:((v2-v1)/4):v2;
    v4 = v1:((v2-v1)/(max(INa.dayY)-min(ROI.dayY))):v2;
    y1 = 0.3;      y2 = 0.4;         y3 = y1:((y2-y1)/4):y2;
    y4 = y1:((y2-y1)/(max(INa.dayY)-min(ROI.dayY))):y2;
    figure('color','white');           hold on;
    ik = ROI.dayY(1);   count=1;       color_jet = jet(max(INa.dayY)-min(ROI.dayY)+1);
    while ik<INa.dayY(end)&(count<length(GCC.BegTdate))
        current_SGS = GCC.BegTdate(count)-days(15);
        current_EGS = GCC.EndTdate(count)+days(15);
        ind = find((INa.eight>=current_SGS)&(INa.eight<=current_EGS)&(INa.eightY == ik));
        hl1  =  plot(INa.eightROIgcc(ind),smoothdata(INa.eightGEPday(ind).*100./INa.eightPARday(ind),'movmedian'),'-',...
            'Color',color_jet(count,:)); hold on;
        plot(INa.eightROIgcc(ind),INa.eightGEPday(ind).*100./INa.eightPARday(ind),'.',...
            'MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
        AM_compute_regression(INa.eightROIgcc(ind),INa.eightGEPday(ind).*100./INa.eightPARday(ind),color_jet(count,:),0);
        % polyfit(INa.eightROIgcc(ind),INa.eightGEPday(ind).*100./INa.eightPARday(ind),2); %color_jet(count,:),1
        plot(.33,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
        text (.34,v4(count),num2str(ik),'FontSize',8);
        ik = ik+1;  count = count+1;
    end
    ylabel ('GEP_{day}(gC m^-^2 d^-^2)');  xlabel ('GCC');
    axis([y1 y2 v1 v2])

    %% GRIVI
    filename = 'timesat/INaseasonalityGRIVI.txt';
    GRIVI = readtable(filename, 'Delimiter', '\t');  GRIVI = table2struct(GRIVI, 'ToScalar', true);

    GRIVI.BegTjd = day(GRIVI.BegTdate, 'dayofyear');   % The start/first minima
    GRIVI.MaxTjd = day(GRIVI.MaxTdate, 'dayofyear');         % The peak
    GRIVI.EndTjd = day(GRIVI.EndTdate, 'dayofyear'); % The end/second minima
    % GRRI.Year = T.Year;[cite: 1]

    % GRIVI.BegT = [];            GRIVI.EndT = [];                GRIVI.MaxT = [];
    ind = find((GRIVI.BegTdate>=ROIINa.daydate(1))&(GRIVI.BegTdate<=ROIINa.daydate(end)));
    GRIVI.BegT = GRIVI.BegTjd(ind);
    ind = find((GRIVI.EndTdate>=ROIINa.daydate(1))&(GRIVI.EndTdate<=ROIINa.daydate(end)));  GRIVI.EndT = GRIVI.EndTjd(ind);
    ind = find((GRIVI.MaxTdate>=ROIINa.daydate(1))&(GRIVI.MaxTdate<=ROIINa.daydate(end)));  GRIVI.MaxT = GRIVI.MaxTjd(ind);

    [ROIINa.daydateY,ROIINa.daydateM,ROIINa.daydateD] = datevec(ROIINa.daydate);
    GRIVI.daydateYears = unique(ROIINa.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;
end

%% ........................................................................
if flag_model==1
    color_mtx = [ 255/255 127/255 20/255; 50/255 77/255 255/255; ...
        0.1020 0.5882 0.2549; 60/255 187/255 255/255; 245/255 55/255 58/255;...
        245/255 55/255 245/255; 245/255 255/255 45/255; 0.1020 0.5882 0.2549; 0.1020 0.5882 0.2549];
    color_mtx_dark = color_mtx.*0.99;
    color_mtx_light = color_mtx.*1.1; color_mtx_light(color_mtx_light>1) = 1;
    v1 = 0;         v2 = 24;          v3 = v1:((v2-v1)/4):v2;

    maxGEPday = prctile(INa.dayGEPday,98);
    minGEPday = prctile(INa.dayGEPday,5);
    mintairday = prctile(INa.daytairday(INa.dayM==2),5);

    INa.dayGEPdayRECOMPOSED = INa.dayGEPday;
    INa.dayGEPdayRECOMPOSED(isnan(INa.dayGEPday)) = INa.day_recurrentGEPday(isnan(INa.dayGEPday));
    INa.dayGEPdayRECOMPOSED = AM_fill_plus(INa.dayGEPdayRECOMPOSED);

    % Optimization options.... number of iterations can be > 5000
    opts = optimoptions('lsqnonlin', 'Display', 'final', 'MaxIterations', 10000,... %, 'Display', 'iter'
        'MaxFunctionEvaluations', 10000, 'FunctionTolerance', 1e-15, ...            % Tighter tolerance for higher R2
        'StepTolerance', 1e-15,...
        'OptimalityTolerance', 1e-15,...
        'FiniteDifferenceType', 'central', ... % More accurate gradient estimation
        'UseParallel', true);

    % Parameters    LagStart = 30;
    % Topt   = params(1);   % Optimal temperature
    % Tmin   = params(2);   % Minimum temperature
    % Tmax   = params(3);   % Maximum temperature
    % LUEcam green = params(4);   % Light use efficiency greenup-peak
    % LUEcam peak  = params(5);   % Light use efficiency peak-end growing season
    % LUEcam brown = params(6);   % Light use efficiency end-start growing season

    % Initial guess: [Topt, Tmin, Tmax, alpha_green alpha_peak alpha_browndown]
    params = [20, 5, 40, 1, 1, 1];
    % Lower and upper bounds for parameters
    lb = [18, -5, 30, .01, .01, .01];  % realistic lower bounds
    ub = [28, 8, 40, 6, 6, 6];  % realistic upper bounds

    % Seasonal modulation: greenup ramp up, browndown ramp down
    StartGrowing = days(GCC.BegTdate-INa.daydate(1));   %-LagStart
    GreenupPeak  = days(GCC.MaxTdate-INa.daydate(1));
    EndGrowing   = days(GCC.EndTdate-INa.daydate(1));   %+LagStart

    counter = (1:1:(length(INa.daydate)))';

    ind = find((~isnan(INa.dayGEPdayRECOMPOSED))&(~isnan(INa.ROIgccQA))&...
        (~isnan(INa.daytairmid))&(~isnan(INa.dayPARday))&(INa.dayGEPdayRECOMPOSED>0)&...
        (isfinite(INa.dayGEPdayRECOMPOSED)));

    % + 0.25: acts as a "floor" for the uncertainty. Preventing th optimizer from over-fitting to days
    % with extremely low GEP while still allowing it to prioritize accuracy during high-productivity periods.
    residualFunction = @(params) (FN_computeGEPseasons(params,counter(ind),INa.ROIgccQA(ind),...
        INa.dayPARday(ind), INa.daytairmid(ind),....
        StartGrowing, GreenupPeak, EndGrowing, 0) - INa.dayGEPdayRECOMPOSED(ind)).*(sqrt(abs(INa.dayGEPdayRECOMPOSED(ind))) + 0.25);

    % Run optimization
    [best_params, resnorm, residual, exitflag, output, lambda, jacobian] =...
        lsqnonlin(residualFunction, params, lb, ub, opts);

    rank(full(jacobian))
    % Corrected line:
    ci = nlparci(best_params, residual, 'jacobian', jacobian);

    % Calculate Widths to see if any parameter is "lost"
    widths = diff(ci, [], 2);
    fprintf('Parameter Uncertainties:\n');
    disp(table({'Topt';'Tmin';'Tmax';'LUE_g';'LUE_p';'LUE_b'}, best_params', widths, ...
        'VariableNames', {'Parameter', 'Estimate', 'CI_Width'}));

    % Calculate the sensitivity of the total error to each parameter
    sensitivity = sum(abs(jacobian), 1);

    figure('color','white','Position',[50 50 600 400]);
    bar(sensitivity)
    set(gca, 'XTickLabel', {'Topt', 'Tmin', 'Tmax', 'LUE_g', 'LUE_p', 'LUE_b'})
    ylabel('Total Sensitivity (Sum of Jacobian Magnitudes)')
    title('Which parameters actually drive the model? model 1: computeGEP')

    test_output = residualFunction(params);
    bad_idx = find(~isfinite(test_output));
    fprintf('There are %d non-finite values.\n', length(bad_idx));
    disp('First few bad values are at indices:');
    disp(head(bad_idx));

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('Topt: %.3f\nTmin: %.3f\nTmax: %.3f\nLUE_{green}: %.3f\nLUE_{peak}: %.3f\nLUE_{brown}: %.3f\n', best_params);

    % Display best-fit parmeters
    INamodelParameter(1).parameters = best_params;

    INa.dayGEPdaymodel = FN_computeGEPseasons(best_params,counter,INa.ROIgccQA,...
        INa.dayPARday, INa.daytairmid,....
        StartGrowing, GreenupPeak, EndGrowing, 0);

    INa.dayGEPdaymodel((isnan(INa.ROIgccQA))|(INa.dayGEPdaymodel==0)) = NaN;

    % Statistics
    valid = INa.dayGEPday>0.1 & INa.dayGEPdaymodel>0.1 & INa.dayGEPday<maxGEPday &... % & INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodel);
    % r = corr(INa.dayGEPdaymodel(ind), INa.dayGEPday(ind), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodel(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    % SS_res = sum((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    % SS_tot = sum((INa.dayGEPday(valid) - mean(INa.dayGEPday(valid))).^2);
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    % yearSelect = 2019;
    ind = 1:length(INa.dayY);       % ind = find(INa.dayY==yearSelect);
    v1 = 0;                         v2 = 32;       %v3 = v1:((v2-v1)/4):v2;
    % figure('color','white','Position',[50 50 600 400],'units','inches');
    figure('color','white','Position',[50 50 1800 400],'units','inches');
    y = [INa.day_recurrentGEPday(ind)-INa.day_recurrent_stdGEPday(ind),2.*INa.day_recurrent_stdGEPday(ind)];
    h = area(INa.daydate(ind),y);     set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    hold on;
    hl1 = plot(INa.daydate(ind),INa.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    hl2 = plot(INa.daydate(ind),smoothdata(INa.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);
    scatter(INa.daydate(ind),INa.dayGEPday(ind),10,'o','MarkerFaceColor',[.4 .4 .4],'MarkerEdgeColor',[.4 .4 .4],...
        'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);

    scatter(INa.daydate(ind),INa.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl3 = plot(INa.daydate,smoothdata(INa.dayGEPdaymodel,'movmean',5),'-','Color',color_mtx_dark(1,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';
    ax2.XAxis.MinorTickValues = INa.month(1:12:end);  ax2.XAxis.MinorTickValues = INa.month;
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],...
        'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:12:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(INa.daydate(ind(20)),25,site_name,'FontSize',16)
    legend([hl3,hl1],'model','observation'); legend box off;

    INa.dayGEPdaymodelLeafStage = INa.dayGEPdaymodel;
    RMSE1 = RMSE;    MAE1 = MAE;     Rsquared_1 = Rsquared;   MSRE1 = MSRE;

    % .....................................................................
    %% Leaf age
    % .....................................................................
    % peakOffset = params(5);   % Days after GreenupPeak when Amax peaks
    % Initial guess: [Topt, Tmin, Tmax, timeMaxAmax, ValMaxAmax]
    LagStart = 15;
    params   = [22, 0, 32, 150, 1];
    % Lower and upper bounds for parameters
    lb = [18, -5, 30, 50, 0.01];  % realistic lower bounds
    ub = [28, 8, 40, 200, 6];  % realistic upper bounds

    % Seasonal modulation: greenup ramp up, browndown ramp down
    StartGrowing = days(GCC.BegTdate-INa.daydate(1))-LagStart;
    EndGrowing   = days(GCC.EndTdate-INa.daydate(1))+LagStart;

    counter = (1:1:(length(INa.daydate)))';

    ind = find((~isnan(INa.dayGEPdayRECOMPOSED))&(~isnan(INa.ROIgccQA))&...
        (~isnan(INa.daytairmid))&(~isnan(INa.dayPARday))&(INa.dayGEPdayRECOMPOSED>0)&...
        (isfinite(INa.dayGEPdayRECOMPOSED)));

    residualFunction = @(params) (FN_computeGEPleafage(params,counter(ind),...
        INa.dayPARday(ind), INa.daytairmid(ind),....
        StartGrowing, EndGrowing) - INa.dayGEPdayRECOMPOSED(ind));% .* (sqrt(abs(INa.dayGEPdayRECOMPOSED(ind))) + 0.25);

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('Topt: %.3f\nTmin: %.3f\nTmax: %.3f\nAmaxTime: %.3f\nMaxValue: %.3f\n', best_params);

    % Display best-fit parameters
    INamodelParameter(2).parameters = best_params;

    INa.dayGEPdaymodel = FN_computeGEPleafage(best_params,counter,...
        INa.dayPARday, INa.daytairmid,StartGrowing, EndGrowing);
    INa.dayGEPdaymodel(INa.dayGEPdaymodel==0) = NaN;

    % Statistics
    valid = INa.dayGEPday>1  & INa.dayGEPdaymodel>1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodel);
    % r = corr(INa.dayGEPdaymodel(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodel(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    % SS_res = sum((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    % SS_tot = sum((INa.dayGEPday(valid) - mean(INa.dayGEPday(valid))).^2);
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    % % % yearSelect = 2019;
    % % ind = 1:length(INa.dayY);       % ind = find(INa.dayY==yearSelect);
    % % v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    % % % figure('color','white','Position',[50 50 600 400],'units','inches');
    % % figure('color','white','Position',[50 50 1800 400],'units','inches');
    % % y = [INa.day_recurrentGEPday(ind)-INa.day_recurrent_stdGEPday(ind),2.*INa.day_recurrent_stdGEPday(ind)];
    % % h = area(INa.daydate(ind),y);     set(gca,'Layer','top');
    % % set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    % % set(h,'BaseValue',0);
    % % hold on;
    % % hl2 = plot(INa.daydate(ind),INa.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    % % hl1 = plot(INa.daydate(ind),smoothdata(INa.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);

    scatter(INa.daydate,INa.dayGEPdaymodel,10,'o','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl4 = plot(INa.daydate,smoothdata(INa.dayGEPdaymodel,'movmean',5),'-','Color',color_mtx_dark(2,:),'Linewidth',.5);

    % ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    % ax2.XAxis.MinorTick = 'on';
    % ax2.XAxis.MinorTickValues = INa.month(1:12:end);  ax2.XAxis.MinorTickValues = INa.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:12:end),'YColor','k');
    % ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    % text(INa.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl3,hl1],'model','observation'); legend box off;

    INa.dayGEPdaymodelLeafAge = INa.dayGEPdaymodel;
    RMSE2 = RMSE;    MAE2 = MAE;     Rsquared_2 = Rsquared;   MSRE2 = MSRE;

    % ........................................................................
    %% Chromatic index
    % ........................................................................
    %     % Initial guess: [Topt, Tmin, Tmax, alphaGCC, alphaRCC]
    params = [22, 0, 32, 1, 1];
    % Lower and upper bounds for parameters
    lb = [18, -5, 30, 0.01, 0.01];  % realistic lower bounds
    ub = [28, 8, 40, 6, 6];         % realistic upper bounds

    % From the GCC SGS to the EGS, it is the GCC that drives the photosyntesis model
    % during the growing season is the 1-RCC that does the job of
    % indicating how the vegetation phothosintetic capacity
    LagStart = 20;
    StartGrowing = days(GCC.BegTdate-INa.daydate(1));%-LagStart;
    EndGrowing   = days(GCC.EndTdate-INa.daydate(1));%+LagStart;

    % Two seasons RCC are difficult to identify in evergreen
    % MaxGrowing   = days(RCC.MaxTdate-INa.daydate(1)); %-LagStart7
    % StartGrowing = days(RCC.MaxTdate(1:2:end-1)-INa.daydate(1))+LagStart;
    % EndGrowing   = days(RCC.MaxTdate(2:2:end)-INa.daydate(1))-LagStart;

    counter = (1:1:(length(INa.daydate)))';

    % opts = optimoptions('lsqnonlin', 'Display', 'iter', 'MaxIterations', 5000,...
    %     'MaxFunctionEvaluations', 10000, 'FunctionTolerance', 1e-10,...      % Tighter tolerance for higher R2
    % 'StepTolerance', 1e-10,'OptimalityTolerance', 1e-10, 'FiniteDifferenceType', 'central', ... % More accurate gradient estimation
    % 'UseParallel', true);

    ind = find((~isnan(INa.dayGEPdayRECOMPOSED))&(~isnan(INa.ROIgccQA))&(~isnan(INa.ROIrccQA))&...
        (~isnan(INa.daytairmid))&(~isnan(INa.dayPARday))&(INa.dayGEPdayRECOMPOSED>0)&...
        (isfinite(INa.dayGEPdayRECOMPOSED)));

    residualFunction = @(params) (FN_computeGEPchromatic(params,counter(ind),...
        INa.dayPARday(ind), INa.daytairmid(ind),INa.ROIgccQA(ind), INa.ROIrccQA(ind),....
        StartGrowing, EndGrowing, 0) - INa.dayGEPdayRECOMPOSED(ind));% .* (sqrt(abs(INa.dayGEPdayRECOMPOSED(ind))) + 0.25);

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('Topt: %.3f\nTmin: %.3f\nTmax: %.3f\nalphaGCC: %.3f\nalphaRCC: %.3f\n', best_params);

    % Display best-fit parameters
    INamodelParameter(3).parameters = best_params;

    INa.dayGEPdaymodel = FN_computeGEPchromatic(best_params,counter,...
        INa.dayPARday, INa.daytairmid, INa.ROIgccQA, INa.ROIrccQA,....
        StartGrowing, EndGrowing, 0);

    % Statistics
    valid = INa.dayGEPday>0.1 & INa.dayGEPdaymodel>0.1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodel);
    r = corr(INa.dayGEPdaymodel(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodel(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    % yearSelect = 2019;
    % ind = find(INa.dayY==yearSelect);
    % v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    % figure('color','white','Position',[50 50 600 400],'units','inches');
    % y = [INa.day_recurrentGEPday(ind)-INa.day_recurrent_stdGEPday(ind),2.*INa.day_recurrent_stdGEPday(ind)];
    % h = area(INa.daydate(ind),y);       set(gca,'Layer','top');
    % set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    % set(h,'BaseValue',0);
    % hold on;
    % hl2 = plot(INa.daydate(ind),INa.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    % hl1 = plot(INa.daydate(ind),smoothdata(INa.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);

    scatter(INa.daydate,INa.dayGEPdaymodel,10,'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl5 = plot(INa.daydate,smoothdata(INa.dayGEPdaymodel,'movmean',5),'-','Color',color_mtx_dark(3,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = INa.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(INa.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    legend([hl3,hl4,hl5,hl1],'leaf seasons','leaf age', 'chromatic','observation'); legend box off;

    INa.dayGEPdaymodelChromatic = INa.dayGEPdaymodel;
    RMSE3 = RMSE;    MAE3 = MAE;     Rsquared_3 = Rsquared;   MSRE3 = MSRE;

    % .......................................................................
    %% SIGMOID
    % .......................................................................
    % Initial guess: [Topt, Tmin, Tmax, alpha_green]
    params = [22, 0, 32, 1];

    % Lower and upper bounds for parameters
    lb = [18, -5, 30, .01];  % realistic lower bounds
    ub = [28, 8, 40, 6];  % realistic upper bounds

    counter = (1:1:(length(INa.daydate)))';

    % % opts = optimoptions('lsqnonlin', 'Display', 'iter', 'MaxIterations', 5000,...
    % %     'MaxFunctionEvaluations', 10000, 'FunctionTolerance', 1e-10,...      % Tighter tolerance for higher R2
    % % 'StepTolerance', 1e-10,'OptimalityTolerance', 1e-10, 'FiniteDifferenceType', 'central', ... % More accurate gradient estimation
    % % 'UseParallel', true);
    %
    % ind = find((~isnan(INa.dayGEPdayRECOMPOSED))&(~isnan(INa.ROIgccQA))&...
    %     (~isnan(INa.daytairmid))&(~isnan(INa.dayPARday))&(INa.dayGEPdayRECOMPOSED>0)&...
    %     (isfinite(INa.dayGEPdayRECOMPOSED)));
    %
    % residualFunction = @(params) (FN_computeGEPsigmoidGCC(params,counter(ind),INa.ROIgccQA(ind),...
    %     INa.dayPARday(ind), INa.daytairmid(ind), 1) - INa.dayGEPdayRECOMPOSED(ind)) .* (sqrt(abs(INa.dayGEPdayRECOMPOSED(ind))) + 0.25);
    %
    ind = find((~isnan(INa.dayGEPdayRECOMPOSED))&(~isnan(INa.ROIgriviQA))&...
        (~isnan(INa.daytairmid))&(~isnan(INa.dayPARday))&(INa.dayGEPdayRECOMPOSED>0)&...
        (isfinite(INa.dayGEPdayRECOMPOSED)));

    residualFunction = @(params) (FN_computeGEPsigmoidGRIVI(params,counter(ind),INa.ROIgriviQA(ind),...
        INa.dayPARday(ind), INa.daytairmid(ind), 1) - INa.dayGEPdayRECOMPOSED(ind));% .* (sqrt(abs(INa.dayGEPdayRECOMPOSED(ind))) + 0.25);
    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('Topt: %.3f\nTmin: %.3f\nTmax: %.3f\nalpha: %.3f\n', best_params);

    % Display best-fit parameters
    INamodelParameter(4).parameters = best_params;

    % INa.dayGEPdaymodel = FN_computeGEPsigmoidGCC(best_params,counter,INa.ROIgccQA,...
    %     INa.dayPARday, INa.daytairmid, 1);
    [INa.dayGEPdaymodel,INa.dayGRIVInorm] = FN_computeGEPsigmoidGRIVI(best_params,counter,INa.ROIgriviQA,...
        INa.dayPARday, INa.daytairmid, 1);

    INa.dayGEPdaymodel(isnan(INa.ROIgriviQA)) = NaN;   INa.dayGEPdaymodel(INa.dayGEPdaymodel==0) = NaN;

    % Statistics
    valid = INa.dayGEPday>0.1 & INa.dayGEPdaymodel>0.1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodel) & INa.dayGEPdaymodel>0;
    r = corr(INa.dayGEPdaymodel(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodel(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(INa.daydate,INa.dayGEPdaymodel,10,'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(4,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl6 = plot(INa.daydate,smoothdata(INa.dayGEPdaymodel,'movmean',5),'-','Color',color_mtx_dark(4,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';
    ax2.XAxis.MinorTickValues = INa.month(1:12:end);  ax2.XAxis.MinorTickValues = INa.month;
    set(ax2,'YTick',v3,'YLim',[v1 v2]);%,'XLim',[ROIINa.daydate INa.daydate(ind(end))],...
    % 'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:12:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    % text(INa.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl3,hl1],'model','observation'); legend box off;
    % legend([hl1,hl2,hl3,hl4,hl5,hl6],'historical','obs','seasons','leaf age','chromatic','sigmoid')

    INa.dayGEPdaymodelSigmoidGRIVI = INa.dayGEPdaymodel;
    RMSE4 = RMSE;    MAE4 = MAE;     Rsquared_4 = Rsquared;   MSRE4 = MSRE;

    % .........................................................................
    %% Only GCC, no PAR, no Tair. Hockey stick
    % .....................................................................
    params = [3, 0.2];
    lb = [0.001, 0.00];  % Lowering beta to 0.0 allows no threshold
    ub = [500, 1];

    ind = find((~isnan(INa.dayGEPdayRECOMPOSED))&(~isnan(INa.ROIgccQA))&...
        (INa.dayGEPdayRECOMPOSED>-3)& (isfinite(INa.dayGEPdayRECOMPOSED))&...
        (INa.ROIgccQA<prctile(INa.ROIgccQA,95)));

    residualFunction = @(params) (FN_computeGEPhockeyGCC(params,counter(ind),...
        INa.ROIgccQA(ind),0) - INa.dayGEPdayRECOMPOSED(ind)) .* (sqrt(abs(INa.dayGEPdayRECOMPOSED(ind))) + 0.25);

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('alphaGCC: %.3f\nwakeupGCC: %.3f\n', best_params);

    % Display best-fit parameters
    INamodelParameter(5).parameters = best_params;

    INa.dayGEPdaymodel = FN_computeGEPhockeyGCC(best_params,counter,INa.ROIgccQA,0);

    % ind = find((~isnan(INa.dayGEPday))&(~isnan(INa.ROIgccQA))&...
    %     (INa.dayGEPday>-3)& (isfinite(INa.dayGEPday)));
    %
    % Statistics
    valid = INa.dayGEPday>0.1 & INa.dayGEPdaymodel>0.1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodel);
    r = corr(INa.dayGEPdaymodel(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodel(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(INa.daydate(ind),INa.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(5,:),'MarkerEdgeColor',color_mtx_dark(5,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl7 = plot(INa.daydate,smoothdata(INa.dayGEPdaymodel,'movmean',5),'-','Color',color_mtx(5,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = INa.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(INa.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    % legend([hl3,hl4,hl5,hl6,hl1],'leaf seasons','leaf age', 'chromatic','hockey','observation'); legend box off;

    INa.dayGEPdaymodelHockey = INa.dayGEPdaymodel;
    RMSE5 = RMSE;    MAE5 = MAE;     Rsquared_5 = Rsquared;   MSRE5 = MSRE;

    % ........................................................................
    %% GGC phenology as gatekeeper
    % ........................................................................
    % Linear relation between GEP v. GCC. Phenology modulated by temperature and PAR only after GCC threshold (a "wakeup" value)
    params = [prctile(INa.dayGEPday, 98), 4.5, 0.5, 100, 22, 20];
    lb     = [prctile(INa.dayGEPday, 95), 2, 0.1, 10, 18, 10];
    ub     = [max(INa.dayGEPday,[],'omitnan'), 8, 1, 400, 28, 30];

    counter = (1:1:(length(INa.daydate)))';

    ind = find((~isnan(INa.dayGEPdayRECOMPOSED))&(~isnan(INa.ROIgccQA))&...
        (~isnan(INa.daytairmid))&(~isnan(INa.dayPARday))&(INa.dayGEPdayRECOMPOSED>0)&...
        (isfinite(INa.dayGEPdayRECOMPOSED)));

    residualFunction = @(params) (FN_computeGEPgatekeeperGCCmeteo(params, counter(ind),...
        INa.dayPARday(ind), INa.daytairmid(ind), INa.ROIgccQA(ind),0)...
        - INa.dayGEPdayRECOMPOSED(ind));

    % tau = 0.75;
    % residualFunction = @(p) sqrt(abs(...
    %     FN_computeGEPgatekeeperGCC(p, counter(ind), ...
    %     INa.daytairmid(ind), INa.dayPARday(ind), INa.ROIgccQA(ind), 1) ...
    %     - INa.dayGEPdayRECOMPOSED(ind))) .* ...
    %     ( (INa.dayGEPdayRECOMPOSED(ind) > FN_computeGEPgatekeeperGCC(p, counter(ind), ...
    %     INa.daytairmid(ind), INa.dayPARday(ind), INa.ROIgccQA(ind), 1)) * tau + ...
    %     (INa.dayGEPdayRECOMPOSED(ind) <= FN_computeGEPgatekeeperGCC(p, counter(ind), ...
    %     INa.daytairmid(ind), INa.dayPARday(ind), INa.ROIgccQA(ind), 1)) * (1 - tau) );
    %
    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('\nBest-fit parameters:\n');
    fprintf('GEP_{max}: %.3f\nSteeepness: %.3f\nSaturation: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    INamodelParameter(6).parameters = best_params;

    [INa.dayGEPdaymodel,INa.dayGCCnorm] = FN_computeGEPgatekeeperGCCmeteo(best_params, counter,...
        INa.dayPARday, INa.daytairmid, INa.ROIgccQA, 0);  %, INa.dayLength

    % Statistics
    valid = INa.dayGEPday>0.1 & INa.dayGEPdaymodel>0.1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodel);
    r = corr(INa.dayGEPdaymodel(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodel(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(INa.daydate(ind),INa.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(6,:),'MarkerEdgeColor',color_mtx_dark(6,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl8 = plot(INa.daydate,smoothdata(INa.dayGEPdaymodel,'movmean',5),'-','Color',color_mtx_dark(6,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = INa.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(INa.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    legend([hl3,hl4,hl5,hl6,hl7,hl1],'leaf seasons','leaf age', 'chromatic','hockey','gatekeeper','observation'); legend box off;

    INa.dayGEPdaymodelGate = INa.dayGEPdaymodel;
    RMSE6 = RMSE;    MAE6 = MAE;     Rsquared_6 = Rsquared;   MSRE6 = MSRE;

    % ........................................................................
    %% GGC phenology as gatekeeper greenup & browndown segments
    % ........................................................................
    % Linear relation between GEP v. GCC. Phenology modulated by temperature and PAR only after GCC threshold (a "wakeup" value)
    params = [prctile(INa.dayGEPday, 98), 4.5, 0.5,  4.5, 0.5, 100, 22, 20];
    lb     = [prctile(INa.dayGEPday, 95), 2, 0.1, 2, 0.1, 10, 18, 10];
    ub     = [max(INa.dayGEPday,[],'omitnan'), 8, 1, 8, 1, 400, 28, 30];

    counter = (1:1:(length(INa.daydate)))';

    ind = find((~isnan(INa.dayGEPdayRECOMPOSED))&(~isnan(INa.ROIgccQA))&...
        (~isnan(INa.daytairmid))&(~isnan(INa.dayPARday))&(INa.dayGEPdayRECOMPOSED>0)&...
        (isfinite(INa.dayGEPdayRECOMPOSED)));

    % tau = 0.75;
    % residualFunction = @(p) sqrt(abs(...
    %     FN_computeGEPphotosynthesisGCCgn2br(p, counter(ind), ...
    %     INa.daytairmid(ind), INa.dayPARday(ind), INa.ROIgccQA(ind), INa.dayLength(ind), 1) ...
    %     - INa.dayGEPday(ind))) .* ...
    %     ( (INa.dayGEPday(ind) > FN_computeGEPphotosynthesisGCCgn2br(p, counter(ind), ...
    %     INa.daytairmid(ind), INa.dayPARday(ind), INa.ROIgccQA(ind), INa.dayLength(ind), 1)) * tau + ...
    %       (INa.dayGEPday(ind) <= FN_computeGEPphotosynthesisGCCgn2br(p, counter(ind), ...
    %     INa.daytairmid(ind), INa.dayPARday(ind), INa.ROIgccQA(ind), INa.dayLength(ind),1)) * (1 - tau) );

    % residualFunction = @(params) (FN_computeGEPphotosynthesisGCCgn2br(params,counter(ind),...
    %     INa.dayPARday(ind), INa.daytairmid(ind),INa.ROIgccQA(ind), INa.dayLength(ind), 1)...
    %     - INa.dayGEPday(ind));
    residualFunction = @(params) (FN_computeGEPphotosynthesisGCCgn2br(params, counter(ind),...
        INa.dayPARday(ind), INa.daytairmid(ind),INa.ROIgccQA(ind), 0)...
 - INa.dayGEPdayRECOMPOSED(ind)).*(sqrt(abs(INa.dayGEPdayRECOMPOSED(ind))) + 0.25);
    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('GEP_{max}: %.3f\nSteeep1: %.3f\nSat1: %.3f\nSteeep2: %.3f\nSat2: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    INamodelParameter(7).parameters = best_params;

    [INa.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params, counter,...
        INa.dayPARday, INa.daytairmid, INa.ROIgccQA, 1);  %, INa.dayLength

    % Statistics
    valid = INa.dayGEPday>0.1 & INa.dayGEPdaymodel>0.1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodel);
    r = corr(INa.dayGEPdaymodel(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodel(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(INa.daydate(ind),INa.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(7,:),'MarkerEdgeColor',color_mtx_dark(7,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl9 = plot(INa.daydate,smoothdata(INa.dayGEPdaymodel,'movmean',5),'-','Color',color_mtx_dark(7,:),'Linewidth',.5);
    % plot(INa.daydate,INa.dayLength*2,'-','Color','r','Linewidth',2);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = INa.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',INa.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(INa.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    legend([hl3,hl4,hl5,hl6,hl7,hl8,hl9,hl1],'leaf seasons','leaf age', 'chromatic', 'sigmoid','hockey','gatekeeper','gatekeeper+gr&bw','observation'); legend box off;

    INa.dayGEPdaymodelGateGnBw = INa.dayGEPdaymodel;
    RMSE7 = RMSE;    MAE7 = MAE;     Rsquared_7 = Rsquared;   MSRE7 = MSRE;

    % ........................................................................
    %% Compare models
    % ........................................................................
    % Create arrays of results
    ModelNames = {'Model 1 (Leaf Stage GCC)';...
        'Model 2 (Leaf Age GCC)';...
        'Model 3 (Chromatic GCC+RCC)';...
        'Model 4 (Sigmoid)';...
        'Model 5 (Hockey)';...
        'Model 6 (Gate)';...
        'Model 7 (Gate+gr&bw)'};

    RMSE_values     = [RMSE1; RMSE2; RMSE3; RMSE4; RMSE5; RMSE6; RMSE7];
    MAE_values      = [MAE1; MAE2; MAE3; MAE4; MAE5; MAE6; MAE7];
    Rsquared_values = [Rsquared_1; Rsquared_2; Rsquared_3; Rsquared_4; Rsquared_5; Rsquared_6; Rsquared_7];
    MSRE_values     = [MSRE1; MSRE2; MSRE3; MSRE4; MSRE5; MSRE6; MSRE7];

    % Table
    ComparisonTable = table(ModelNames, RMSE_values, MAE_values, Rsquared_values, MSRE_values, ...
        'VariableNames', {'Model', 'RMSE', 'MAE', 'R_Squared', 'MSRE'});
    save ('modelResultsINa','ComparisonTable','-append')

    % Display the table
    fprintf('*** GEP Model Performance Comparison ***\n');
    disp(ComparisonTable);
    fprintf('***                                                   ***\n');

    % Optional: Sort the table by R-Squared (descending)
    SortedTable = sortrows(ComparisonTable, 'R_Squared', 'descend');
    fprintf('\n*** Models Sorted by R-Squared (Best Fit) ***\n');
    disp(SortedTable);
    fprintf('***                                                   ***\n');

    fprintf('  ***R-squared: ***\n');
    find(Rsquared_values == max(Rsquared_values));
    fprintf('***                                                   ***\n');

    %% plot the results of the best model for visualization
    clear hl11 hl12 hl13 hl14 hl15 hl16
    fittypesArray = 2;
    y1=0;     y2=35;    y3 = (y1:(y2-y1)/4:y2)';  y4 = (y1:(y2-y1)/15:y2)';
    x1=0;     x2=35;    x3 = (x1:(x2-x1)/4:x2)';  x4 = (x1:(x2-x1)/15:x2)';
    figure('color','white','Position',[150 150 450 400]);   hold on;
    count = 1;
    plot(y4,y4,':k')
    scatter(INa.dayGEPday,INa.dayGEPdaymodelLeafStage,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    % Find x values for plotting the fit based on xlim
    x0 = linspace(min(INa.dayGEPday,[],'omitnan'), max(INa.dayGEPday,[],'omitnan'));
    valid = INa.dayGEPday>1  & INa.dayGEPdaymodelLeafStage>1 & INa.dayGEPday<maxGEPday &...
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodelLeafStage);
    % check1 = INa.dayGEPday > 10 & INa.dayGEPdaymodelLeafAge < 1;
    fitResults = polyfit(INa.dayGEPday(valid),INa.dayGEPdaymodelLeafStage(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    text(x4(1),y4(end-count),['GEP_{leaf stage} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])
    [ix,iy] = AM_class_eq_size(INa.dayGEPday(valid),INa.dayGEPdaymodelLeafStage(valid),15);
    % [ix,iy] = AM_bin_noplot(INa.dayGEPday(valid),INa.dayGEPdaymodelLeafStage(valid),15,5);
    hl11 = scatter(ix(:,2),iy,50,'s','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    % fitResults = polyfit(ix(:,2),iy,fittypesArray-1);
    % iy = polyval(fitResults,ix);
    % plot(iy,iy,'-','Color',color_mtx(count,:));
    % text(x4(3),y4(end-2*count),['GEP_{leaf stage} = ', num2str(fitResults(1)),'GEP_{obs}+',num2str(fitResults(2))])

    count = 2;
    scatter(INa.dayGEPday,INa.dayGEPdaymodelLeafAge,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = INa.dayGEPday > 1  & INa.dayGEPdaymodelLeafAge>1 & INa.dayGEPday<maxGEPday &...
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodelLeafAge);
    % check2 = INa.dayGEPday > 10 & INa.dayGEPdaymodelLeafAge < 1;
    fitResults = polyfit(INa.dayGEPday(valid),INa.dayGEPdaymodelLeafAge(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(INa.dayGEPday(valid),INa.dayGEPdaymodelLeafAge(valid),15);
    % [ix,iy] = AM_bin_noplot(INa.dayGEPday(valid),INa.dayGEPdaymodelLeafAge(valid),15,5);
    hl12 = scatter(ix(:,2),iy,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{leaf age} = ', num2str(fitResults(1),'%.2f'),' GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 3;
    scatter(INa.dayGEPday,INa.dayGEPdaymodelChromatic,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = INa.dayGEPday>1  & INa.dayGEPdaymodelChromatic>1 & INa.dayGEPday<maxGEPday &...
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodelChromatic);
    % check3 = INa.dayGEPday > 10 & INa.dayGEPdaymodelChromatic < 1;
    fitResults = polyfit(INa.dayGEPday(valid),INa.dayGEPdaymodelChromatic(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(INa.dayGEPday(valid),INa.dayGEPdaymodelChromatic(valid),15);
    % [ix,iy] = AM_bin_noplot(INa.dayGEPday(valid),INa.dayGEPdaymodelChromatic(valid),15,5);
    hl13 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{chromatic} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 4;
    scatter(INa.dayGEPday,INa.dayGEPdaymodelSigmoidGRIVI,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = INa.dayGEPday>1 & INa.dayGEPdaymodelSigmoidGRIVI>1 & INa.dayGEPday<maxGEPday &...
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodelSigmoidGRIVI);
    % check4 = INa.dayGEPday > 10 & INa.dayGEPdaymodelLeafAge < 1;
    fitResults = polyfit(INa.dayGEPday(valid),INa.dayGEPdaymodelSigmoidGRIVI(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(INa.dayGEPday(valid),INa.dayGEPdaymodelSigmoidGRIVI(valid),15);
    % [ix,iy] = AM_bin_noplot(INa.dayGEPday(valid),INa.dayGEPdaymodelSigmoidGRIVI(valid),15,5);
    hl14 = scatter(ix(:,2),iy,50,'^','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{sigmoid} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 5;
    scatter(INa.dayGEPday,INa.dayGEPdaymodelHockey,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = INa.dayGEPday>1  & INa.dayGEPdaymodelHockey>1 & INa.dayGEPday<maxGEPday &...
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodelHockey);
    % check3 = INa.dayGEPday > 10 & INa.dayGEPdaymodelHockey < 1;
    fitResults = polyfit(INa.dayGEPday(valid),INa.dayGEPdaymodelHockey(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(INa.dayGEPday(valid),INa.dayGEPdaymodelHockey(valid),15);
    % [ix,iy] = AM_bin_noplot(INa.dayGEPday(valid),INa.dayGEPdaymodelHockey(valid),15,5);
    hl15 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{hockey} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 6;
    scatter(INa.dayGEPday,INa.dayGEPdaymodelGate,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = INa.dayGEPday>1  & INa.dayGEPdaymodelGate>1 & INa.dayGEPday<maxGEPday &...
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodelGate);
    % check3 = INa.dayGEPday > 10 & INa.dayGEPdaymodelGate < 1;
    fitResults = polyfit(INa.dayGEPday(valid),INa.dayGEPdaymodelGate(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(INa.dayGEPday(valid),INa.dayGEPdaymodelGate(valid),15);
    % [ix,iy] = AM_bin_noplot(INa.dayGEPday(valid),INa.dayGEPdaymodelGate(valid),15,5);
    hl16 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{gate} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 7;
    scatter(INa.dayGEPday,INa.dayGEPdaymodelGateGnBw,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = INa.dayGEPday>1  & INa.dayGEPdaymodelGateGnBw>1 & INa.dayGEPday<maxGEPday &...
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodelGateGnBw);
    % check3 = INa.dayGEPday > 10 & INa.dayGEPdaymodelGate < 1;
    fitResults = polyfit(INa.dayGEPday(valid),INa.dayGEPdaymodelGateGnBw(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(INa.dayGEPday(valid),INa.dayGEPdaymodelGateGnBw(valid),15);
    % [ix,iy] = AM_bin_noplot(INa.dayGEPday(valid),INa.dayGEPdaymodelGate(valid),15,5);
    hl17 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{gate+gr&bw} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    ylabel('GEP_{model} (gC m^{-2} d^{-1})','FontSize',12);
    xlabel('GEP_{obs} (gC m^{-2} d^{-1})','FontSize',12);
    legend([hl11,hl12,hl13,hl14,hl15,hl16,hl17],'Leaf Stage', 'Leaf Age', 'Chromatic', 'Sigmoid',...
        'Hockey','Gate','Gate+GnBw','FontSize',12,'color','none','Location', 'southeast', 'Box', 'off')
    legend box off;
    grid on; axis([x1 x2 y1 y2])
    ax = gca;                     ax.FontSize = 12;     box on;
    text(x4(13),y4(end-2),site_name,'FontSize',12)

    %% ....................................................................
    v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    figure('color','white','Position',[50 50 1600 400],'units','inches');
    y = [INa.day_recurrentGEPday-INa.day_recurrent_stdGEPday,2.*INa.day_recurrent_stdGEPday];
    h = area(INa.daydate,y);       set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    % set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
    hold on;
    hl2 = plot(INa.daydate,INa.day_recurrentGEPdayGoley,'-','LineWidth',1,'color',[0.5 0.5 0.5]); hold on;
    % hl3 = plot(INa.daydate,INa.dayGEPday,'-','LineWidth',1,'color',[0.3 0.3 0.3 ]); hold on;
    hl4 = scatter(INa.daydate,smoothdata(INa.dayGEPday,'movmean',1),10,'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.3 0.3 0.3],...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl6 = scatter(INa.daydate,INa.dayGEPdaymodelLeafStage,10,'MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    % hl5 = scatter(INa.daydate(check),INa.dayGEPdaymodelLeafStage(check),20,'MarkerFaceColor','r',...
    %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
    ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.month(1:2:end);
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(1) INa.daydate(end)],...
        'FontSize',12,'XMinorGrid','on','XTick',INa.month(1:12:end));    %'XTickLabelColor',[0. 0. 0.7 ]
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',14);   xtickangle(0);   box on;   grid on;
    legend([hl2,hl4,hl6],'historical','obs','Leaf Stage')

    v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    figure('color','white','Position',[50 50 1600 400],'units','inches');
    y = [INa.day_recurrentGEPday-INa.day_recurrent_stdGEPday,2.*INa.day_recurrent_stdGEPday];
    h = area(INa.daydate,y);       set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    % set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
    hold on;
    hl2 = plot(INa.daydate,INa.day_recurrentGEPdayGoley,'-','LineWidth',1,'color',[0.5 0.5 0.5]); hold on;
    % hl3 = plot(INa.daydate,INa.dayGEPday,'-','LineWidth',1,'color',[0.3 0.3 0.3 ]); hold on;
    hl4 = scatter(INa.daydate,smoothdata(INa.dayGEPday,'movmean',1),10,'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.3 0.3 0.3],...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl6 = scatter(INa.daydate,INa.dayGEPdaymodelLeafAge,10,'MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    % hl3 = plot(INa.daydate,INa.dayGEPdaymodelLeafAge,'-','LineWidth',.5,'color',color_mtx(2,:)); hold on;
    hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
    ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.month(1:2:end);
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(1) INa.daydate(end)],...
        'FontSize',12,'XMinorGrid','on','XTick',INa.month(1:12:end));    %'XTickLabelColor',[0. 0. 0.7 ]
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',14);   xtickangle(0);   box on;   grid on;
    legend([hl2,hl4,hl6],'historical','obs','Leaf Age')

    v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    figure('color','white','Position',[50 50 1600 400],'units','inches');
    y = [INa.day_recurrentGEPday-INa.day_recurrent_stdGEPday,2.*INa.day_recurrent_stdGEPday];
    h = area(INa.daydate,y);       set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    % set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(ind(1)) INa.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
    hold on;
    hl2 = plot(INa.daydate,INa.day_recurrentGEPdayGoley,'-','LineWidth',1,'color',[0.5 0.5 0.5]); hold on;
    % hl3 = plot(INa.daydate,INa.dayGEPday,'-','LineWidth',1,'color',[0.3 0.3 0.3 ]); hold on;
    hl4 = scatter(INa.daydate,smoothdata(INa.dayGEPday,'movmean',1),10,'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.3 0.3 0.3],...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl5 = scatter(INa.daydate,INa.dayGEPdaymodelChromatic,10,'MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl6 = scatter(INa.daydate,INa.dayGEPdaymodelSigmoidGRIVI,10,'MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(4,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
    ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = INa.month(1:2:end);
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[INa.daydate(1) INa.daydate(end)],...
        'FontSize',12,'XMinorGrid','on','XTick',INa.month(1:12:end));    %'XTickLabelColor',[0. 0. 0.7 ]
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',14);   xtickangle(0);   box on;   grid on;
    % legend([hl2,hl4,hl6],'historical','obs','Chromatic')
end

% .........................................................................
%% test
% .........................................................................
% % % trains the model on all years except one -iterates, and saves the parameters.
% % % looks at how the temperature and other parameters shift depending on which year is excluded.
if flag_model_test_chromatic == 1
    [INa.daydateY,INa.daydateM,INa.daydateD] = datevec(INa.daydate);
    INa.years = unique(INa.daydateY);
    modelResultsChromatic = struct();
    windowSmooth = 11;

    % Final QA for indices
    iy = INa.ROIgcc;
    INa.ROIgccQA = iy;            %INa.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(INa.ROIgccQA,5);
    INa.ROIgccQA = FN_fillVI(INa.daydate,iy);

    iy = INa.ROIrcc;
    % iy(INa.ROIrcc<0.385) = NaN;   %INa.ROIrcc(INa.daydate>datetime(2021,12,31)) = NaN;
    INa.ROIrccQA = iy;            %INa.ROIrccQA(ind) = ix;
    [~,INa.ROIrccQA] = AM_spike_detection(INa.ROIrccQA,5);
    iy = smoothdata(INa.ROIrccQA,'movmean',windowSmooth);
    INa.ROIrccQA = FN_fillVI(INa.daydate,iy);

    for ix = 1:length(INa.years)
        currentYear = INa.years(ix); display(currentYear);
        % if currentYear==2018;   currentYear = currentYear+1;   ix = ix+1;  end
        if flag_chromaticFixMeteo == 0
            params = [22, 0, 32, 1, 1];
            lb = [18, -5, 30, 0.01, 0.01];
            ub = [28, 8, 40, 6, 6];
        else
            params = [19, -5, 32, 1, 1];
            lb = [18, -5.01, 38.99, 0.01, 0.01];  % realistic lower bounds
            ub = [28, -4.99, 39.01, 6, 6];         % realistic upper bounds
        end

        StartGrowing = days(GCC.BegTdate-INa.daydate(1));
        EndGrowing   = days(GCC.EndTdate-INa.daydate(1));
        counter = (1:1:(length(INa.daydate)))';

        commonFilters = isfinite(INa.dayGEPdayRECOMPOSED) & ...
            isfinite(INa.ROIgccQA) & isfinite(INa.ROIrccQA) & ...
            isfinite(INa.daytairmid) & isfinite(INa.dayPARday) & (~isnan(INa.dayGEPdayRECOMPOSED)) & ...
            (INa.dayPARday > 0) & (INa.dayGEPdayRECOMPOSED > 0);

        indTrain = find((INa.daydateY ~= currentYear) & commonFilters);
        indTest  = find((INa.daydateY == currentYear) & commonFilters);

        % Optimization
        if length(indTrain)>10 && length(indTest)>10
            foldObj = @(p) (FN_computeGEPchromatic(p, counter(indTrain), ...
                INa.dayPARday(indTrain), INa.daytairmid(indTrain), INa.ROIgccQA(indTrain), ...
                INa.ROIrccQA(indTrain), StartGrowing, EndGrowing, 0) - INa.dayGEPdayRECOMPOSED(indTrain));% .* ...
            % (sqrt(abs(INa.dayGEPdayRECOMPOSED(indTrain))) + 0.25);

            [best_params, ~, res_fold, ~, ~, ~, J_fold] = lsqnonlin(foldObj, params, lb, ub, opts);
            % to convert the jacobian here to avoid crash
            J_dense = full(J_fold);

            % Evaluation
            gepPredTest = FN_computeGEPchromatic(best_params, counter(indTest), ...
                INa.dayPARday(indTest), INa.daytairmid(indTest), INa.ROIgccQA(indTest), ...
                INa.ROIrccQA(indTest), StartGrowing, EndGrowing, 0);

            SGStest = StartGrowing(year(GCC.BegTdate) == currentYear);
            SGStest(isnan(SGStest)) = days(datetime(currentYear,1,1)-INa.daydate(1));
            EGStest = EndGrowing(year(GCC.EndTdate) == currentYear);
            EGStest(isnan(EGStest)) = days(datetime(currentYear,12,31)-INa.daydate(1));
            % Calculate Prediction Uncertainty (Margin)
            % ci gives parameter bounds; we use nlpredci for prediction bounds
            [~, delta] = nlpredci(@(p, x) FN_computeGEPchromatic(p, counter(indTest), ...
                INa.dayPARday(indTest), INa.daytairmid(indTest), INa.ROIgccQA(indTest), ...
                INa.ROIrccQA(indTest), SGStest, EGStest, 0), ...
                counter(indTest), best_params, res_fold, 'jacobian', J_dense);

            % Calculate 95% Confidence Intervals for the parameters
            % p_ci will be a 5x2 matrix: [lower_bound, upper_bound] for each of your 5 parameters
            p_ci = nlparci(best_params, res_fold, 'jacobian', J_dense);

            % Calculate the 'margin' or standard error for each parameter
            p_error = (p_ci(:,2) - p_ci(:,1)) / 2;

            % Store Results
            modelResultsChromatic(ix).year = currentYear;
            modelResultsChromatic(ix).obs  = INa.dayGEPday(indTest);
            modelResultsChromatic(ix).pred = gepPredTest;
            modelResultsChromatic(ix).delta = delta; % This is your CI 'margin'
            modelResultsChromatic(ix).x = counter(indTest);
            modelResultsChromatic(ix).testRMSE = sqrt(mean((gepPredTest - INa.dayGEPday(indTest)).^2));
            modelResultsChromatic(ix).p_val = best_params;     % The optimized parameters
            modelResultsChromatic(ix).p_ci  = p_ci;       % The [LB, UB] for each parameter
            modelResultsChromatic(ix).p_err = p_error;    % The +/- margin
        end
    end

    % Extracting while ignoring empty entries
    all_p_vals = vertcat(modelResultsChromatic.p_val);

    % Average and Standard Deviation
    avg_p_val = mean(all_p_vals, 1);
    std_p_val = std(all_p_vals, 0, 1);

    % Create a summary table for readability
    paramNames = {'Topt', 'Tmin', 'Tmax', 'alphaGCC', 'alphaRCC'};
    summaryTable = table(avg_p_val', std_p_val', 'VariableNames', {'Mean', 'StdDev'}, 'RowNames', paramNames);
    disp(summaryTable);

    %% Visualization: Summary Figure
    figure('Color', 'white', 'Name', 'LOYO Cross-Validation Results');
    numYears = length(modelResultsChromatic);
    cols = 6;
    rows = ceil(numYears/cols);

    for ix = 1:numYears
        if isempty(modelResultsChromatic) || ix > length(modelResultsChromatic) || isempty(modelResultsChromatic(ix).year)
            continue;
        end
        subplot(rows, cols, ix);
        % Convert absolute Day Index to relative Day of Year (1-365)
        xCounter  = modelResultsChromatic(ix).x;    xDate  = xCounter - min(xCounter) + 1;
        yModel = modelResultsChromatic(ix).pred;    yObs  = modelResultsChromatic(ix).obs;
        margin = modelResultsChromatic(ix).delta;

        hl1 = fill([xDate; flipud(xDate)], [yModel + margin; flipud(yModel - margin)], ...
            [0.85 0.85 0.85], 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        hold on;
        hl2 = plot(xDate, yObs, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'k');
        hl3 = scatter(xDate, yModel, 8, 'MarkerFaceColor', color_mtx(1,:), 'MarkerFaceAlpha', 0.5);

        title(sprintf('%d (RMSE: %.2f)', modelResultsChromatic(ix).year, modelResultsChromatic(ix).testRMSE));
        grid on;
        set(gca,'XLim',[1 365],'YLim',[-5 40],'XTick',[1 91 182 274],'YTick',[0,20,40],'YTickLabel',{''},'XTickLabel',{''});

        currentCol = mod(ix - 1, cols) + 1;
        if currentCol == 1
            ylabel('GEP (gC m^{-2}s^{-1})');
            set(gca,'YTick',[0,20,40],'YTickLabel',{'0','20','40'});
        end
        if ix > (numYears - cols)
            % xlabel('Day of Year');
            set(gca, 'XTick', [1 91 182 274], 'XTickLabel', {'Jan','Apr','Jul','Oct'});
        else
            set(gca, 'XTickLabel', []); % Remove labels for cleaner look on upper rows
        end

        if ix == 1, legend([hl1,hl2,hl3],'95% CI', 'Observed', 'Predicted', 'Location', 'best'); end
    end

    %% Collect all results into two long vectors
    all_obs = cell2mat({modelResultsChromatic.obs}');  all_pred = cell2mat({modelResultsChromatic.pred}');
    color_jet = flipud(jet(numYears)); rand_idx = randperm(numYears); color_jet = color_jet(rand_idx, :);
    x1 = 0;   x2 = 40;   x3 = (x1:(x2-x1)/4:x2)';

    figure('Color', 'white');
    for ix = 1:numYears
        if isempty(modelResultsChromatic) || ix > length(modelResultsChromatic) || isempty(modelResultsChromatic(ix).year)
            continue;
        end

        yModel = modelResultsChromatic(ix).pred;    yObs  = modelResultsChromatic(ix).obs;

        % quick type II regression
        std_x = std(yObs);                std_y = std(yModel);
        mean_x = mean(yObs);              mean_y = mean(yModel);
        r_mat = corrcoef(yObs, yModel);   r = r_mat(1,2);
        slope_ii = (std_y / std_x) * sign(r);
        intercept_ii = mean_y - slope_ii * mean_x;
        x_range = [x1, x2];
        y_line_ii = intercept_ii + slope_ii * x_range;

        plot(x_range, y_line_ii, 'Color', color_jet(ix,:), 'LineWidth', .5);

        % title(sprintf('%d: slope=%.2f', modelResultsChromatic(ix).year, slope_ii));
        scatter(yObs, yModel, 15, 'filled','MarkerFaceAlpha', 0.5,'MarkerFaceColor',color_jet(ix,:),'MarkerEdgeColor','none');
        hold on;

        mdl = fitlm(yObs, yModel);
        scatter(1,x1+2+ix.*1.2,15,'MarkerFaceColor',color_jet(ix,:),'MarkerEdgeColor','none','MarkerFaceAlpha', 0.5);
        text(2,x1+2+ix.*1.2,sprintf('Year: %.0f, R^2: %.2f, RMSE: %.2f', ...
            modelResultsChromatic(ix).year, mdl.Rsquared.Ordinary, sqrt(mean((yObs-yModel).^2))));
    end

    plot([x1 x2], [x1 x2], 'k', 'LineWidth', 1);

    % Calculate Global Stats
    mdl = fitlm(all_obs, all_pred);
    title(sprintf('INa LOYO Validation (R^2 = %.2f, RMSE = %.2f)', ...
        mdl.Rsquared.Ordinary, sqrt(mean((all_obs-all_pred).^2))),'fontsize',10);

    xlabel('Observed GEP','FontSize',14);   ylabel('Predicted GEP','FontSize',14);
    grid on;                                axis([x1 x2 x1 x2]);
    set(gca,'XLim',[x1 x2],'YLim',[x1 x2],'XTick',x3,'YTick',x3,'FontSize',14);

    %% Check parameter stability
    color_jet = bone(numYears+5);
    figure('Color', 'white');
    paramNames = {'T_{opt} (\circC)', 'T_{min} (\circC)', 'T_{max} (\circC)', '\alpha_{GCC}', '\alpha_{RCC}'};
    for ix = 1:numYears
        if isempty(modelResultsChromatic) || ix > length(modelResultsChromatic) || isempty(modelResultsChromatic(ix).year)
            continue;
        end
        for p_idx = 1:length(paramNames)
            ax = subplot(3, 3, p_idx);    hold on;
            years = [modelResultsChromatic(ix).year];
            vals  = arrayfun(@(s) s.p_val(p_idx), modelResultsChromatic(ix));
            errs  = arrayfun(@(s) s.p_err(p_idx), modelResultsChromatic(ix));

            % errorbar(years, vals, errs, 'o-', 'LineWidth', 1.2);
            errorbar(years, vals, errs, 'o-','Color',color_jet(ix,:),...
                'MarkerFaceColor',color_jet(ix,:), 'LineWidth', 1.2, 'CapSize', 10);
            set(ax, 'YTickMode', 'auto');
            ax.YAxis.TickValues = linspace(min(ylim), max(ylim), 4);
            ytickformat('%.0f'); % Use 3 decimals for alpha
            if p_idx > 3
                ytickformat('%.3f'); % Use 3 decimals for alpha
            end

            ylabel(paramNames{p_idx},'FontSize',14);            set(gca,'FontSize',14);
            xlim([min([modelResultsChromatic.year])-1 , max([modelResultsChromatic.year]) + 1;]);
            grid on;  box on;
        end
    end

    %% Last effort, lets check the R2 and rest of the stats
    [INa.dayGEPdaymodelChromaticLOYO] = FN_computeGEPchromatic(avg_p_val,counter,...
        INa.dayPARday, INa.daytairmid, INa.ROIgccQA, INa.ROIrccQA, StartGrowing, EndGrowing, 0);
    valid = INa.dayGEPday>1 & INa.dayGEPdaymodelChromaticLOYO>1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodelChromaticLOYO);
    r = corr(INa.dayGEPdaymodelChromaticLOYO(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodelChromaticLOYO(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodelChromaticLOYO(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodelChromaticLOYO(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodelChromaticLOYO(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    save ('modelResultsINa','modelResultsChromatic','-append')
end

% ........................................................................
%% Gatekeeper
% ........................................................................
if flag_model_test_gatekeeper == 1
    [INa.daydateY,INa.daydateM,INa.daydateD] = datevec(INa.daydate);
    INa.years = unique(INa.daydateY);
    modelResults = struct();

    % Final QA for indices
    iy = INa.ROIgcc;
    INa.ROIgccQA = iy;            %INa.ROIrccQA(ind) = ix;    INa.ROIgccQA = iy;            %INa.ROIgccQA(ind) = ix;
    [~,INa.ROIgccQA] = AM_spike_detection(INa.ROIgccQA,5);
    INa.ROIgccQA = FN_fillVI(INa.daydate,iy);

    for ix = 1:length(INa.years)
        currentYear = INa.years(ix); display(currentYear);
        if flag_gatewayFixMeteo == 0
            params = [prctile(INa.dayGEPdayRECOMPOSED, 98), 4.5, 0.5,  4.5, 0.5, 100, 20, 20];
            lb     = [prctile(INa.dayGEPdayRECOMPOSED, 95), 2, 0.1, 2, 0.1, 10, 15, 10];
            ub     = [max(INa.dayGEPdayRECOMPOSED,[],'omitnan'), 8, 1, 8, 1, 400, 25, 30];
        else
            % Here I am just "fixing" the parameters similar to the FN_computeGEPgatekeeperGCC
            params = [prctile(INa.dayGEPdayRECOMPOSED, 98), 4.5, 0.5,  4.5, 0.5, 273, 25, 18];
            lb     = [prctile(INa.dayGEPdayRECOMPOSED, 95), 2, 0.1, 2, 0.1, 272.99, 24.99, 17.99];
            ub     = [max(INa.dayGEPdayRECOMPOSED,[],'omitnan'), 8, 1, 8, 1, 273.01, 25.01, 18.01];
        end

        commonFilters = ((~isnan(INa.dayGEPdayRECOMPOSED))&(~isnan(INa.ROIgccQA))&...
            (~isnan(INa.daytairmid))&(~isnan(INa.dayPARday))&(INa.dayGEPdayRECOMPOSED>0)&...
            (isfinite(INa.dayGEPdayRECOMPOSED)));

        indTrain = find((INa.daydateY ~= currentYear) & commonFilters);
        indTest  = find((INa.daydateY == currentYear) & commonFilters);

        % Optimization
        if length(indTrain)>10 && length(indTest)>10
            foldObj = @(p) (FN_computeGEPphotosynthesisGCCgn2br(p, counter(indTrain), ...
                INa.dayPARday(indTrain), INa.daytairmid(indTrain), INa.ROIgccQA(indTrain),0) - INa.dayGEPdayRECOMPOSED(indTrain));

            [best_params, ~, res_fold, ~, ~, ~, J_fold] = lsqnonlin(foldObj, params, lb, ub, opts);
            % to convert the jacobian here to avoid crash
            J_dense = full(J_fold);

            % Evaluation
            gepPredTest = FN_computeGEPphotosynthesisGCCgn2br(best_params, counter(indTest), ...
                INa.dayPARday(indTest),INa.daytairmid(indTest),INa.ROIgccQA(indTest),0);

            SGStest = StartGrowing(year(GCC.BegTdate) == currentYear);
            SGStest(isnan(SGStest)) = days(datetime(currentYear,1,1)-INa.daydate(1));
            EGStest = EndGrowing(year(GCC.EndTdate) == currentYear);
            EGStest(isnan(EGStest)) = days(datetime(currentYear,12,31)-INa.daydate(1));
            % Calculate Prediction Uncertainty (Margin)
            % ci gives parameter bounds; we use nlpredci for prediction bounds
            [~, delta] = nlpredci(@(p, x) FN_computeGEPphotosynthesisGCCgn2br(p, counter(indTest), ...
                INa.dayPARday(indTest), INa.daytairmid(indTest), INa.ROIgccQA(indTest),0), ...
                counter(indTest), best_params, res_fold, 'jacobian', J_dense);

            % Calculate 95% Confidence Intervals for the parameters
            % p_ci will be a 5x2 matrix: [lower_bound, upper_bound] for each of your 5 parameters
            p_ci = nlparci(best_params, res_fold, 'jacobian', J_dense);

            % Calculate the 'margin' or standard error for each parameter
            p_error = (p_ci(:,2) - p_ci(:,1)) / 2;

            % Store Results
            modelResults(ix).year = currentYear;
            modelResults(ix).obs  = INa.dayGEPday(indTest);
            modelResults(ix).pred = gepPredTest;
            modelResults(ix).delta = delta; % This is your CI 'margin'
            modelResults(ix).x = counter(indTest);
            modelResults(ix).testRMSE = sqrt(mean((gepPredTest - INa.dayGEPday(indTest)).^2));
            modelResults(ix).p_val = best_params;     % The optimized parameters
            modelResults(ix).p_ci  = p_ci;       % The [LB, UB] for each parameter
            modelResults(ix).p_err = p_error;    % The +/- margin
        end
    end
    % Extracting while ignoring empty entries
    all_p_vals = vertcat(modelResults.p_val);

    % Average and Standard Deviation
    avg_p_val = mean(all_p_vals, 1);
    std_p_val = std(all_p_vals, 0, 1);

    % Create a summary table for readability
    paramNames = {'GEPmax', 'k_{gr}', 'x_{0}_{gr}', 'k_{bw}', 'x_{0}_{bw}', 'PARtresh', 'Topt', 'Tamp'};
    summaryTable = table(avg_p_val', std_p_val', 'VariableNames', {'Mean', 'StdDev'}, 'RowNames', paramNames);
    disp(summaryTable);

    %% Visualization: Summary Figure
    figure('Color', 'white', 'Name', 'LOYO Cross-Validation Results');
    numYears = length(modelResults);
    cols = 6;
    rows = ceil(numYears/cols);

    for ix = 1:numYears
        if isempty(modelResults) || ix > length(modelResults) || isempty(modelResults(ix).year)
            continue;
        end

        subplot(rows, cols, ix);

        % Convert absolute Day Index to relative Day of Year (1-365)
        xCounter  = modelResults(ix).x;       xDate  = xCounter - min(xCounter) + 1;

        yModel = modelResults(ix).pred;       yObs  = modelResults(ix).obs;
        margin = modelResults(ix).delta;

        hl1 = fill([xDate; flipud(xDate)], [yModel + margin; flipud(yModel - margin)], ...
            [0.85 0.85 0.85], 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        hold on;
        hl2 = plot(xDate, yObs, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'k');
        hl3 = scatter(xDate, yModel, 8, 'MarkerFaceColor', color_mtx(1,:), 'MarkerFaceAlpha', 0.5);

        title(sprintf('Year: %d (RMSE: %.2f)', modelResults(ix).year, modelResults(ix).testRMSE));
        grid on;
        set(gca,'XLim',[1 365],'YLim',[-5 40],'XTick',[1 91 182 274],'YTick',[0,20,40],'YTickLabel',{''},'XTickLabel',{''});

        currentCol = mod(ix - 1, cols) + 1;
        if currentCol == 1
            ylabel('GEP (gC m^{-2}s^{-1})');
            set(gca,'YTick',[0,20,40],'YTickLabel',{'0','20','40'});
        end
        if ix > (numYears - cols)
            % xlabel('Day of Year');
            set(gca, 'XTick', [1 91 182 274], 'XTickLabel', {'Jan','Apr','Jul','Oct'});
        else
            set(gca, 'XTickLabel', []); % Remove labels for cleaner look on upper rows
        end

        if ix == 1, legend([hl1,hl2,hl3],'95% CI', 'Observed', 'Predicted', 'Location', 'best'); end
    end

    %% Collect all results into two long vectors
    all_obs = cell2mat({modelResults.obs}');  all_pred = cell2mat({modelResults.pred}');
    color_jet = flipud(jet(numYears)); rand_idx = randperm(numYears); color_jet = color_jet(rand_idx, :);
    x1 = 0;   x2 = 40;   x3 = (x1:(x2-x1)/4:x2)';

    figure('Color', 'white');
    for ix = 1:numYears
        if isempty(modelResults) || ix > length(modelResults) || isempty(modelResults(ix).year)
            continue;
        end

        yModel = modelResults(ix).pred;    yObs  = modelResults(ix).obs;

        % quick type II regression
        std_x = std(yObs);                std_y = std(yModel);
        mean_x = mean(yObs);              mean_y = mean(yModel);
        r_mat = corrcoef(yObs, yModel);   r = r_mat(1,2);
        slope_ii = (std_y / std_x) * sign(r);
        intercept_ii = mean_y - slope_ii * mean_x;
        x_range = [x1, x2];
        y_line_ii = intercept_ii + slope_ii * x_range;

        plot(x_range, y_line_ii, 'Color', color_jet(ix,:), 'LineWidth', .5);

        % title(sprintf('%d: slope=%.2f', modelResults(ix).year, slope_ii));
        scatter(yObs, yModel, 15, 'filled','MarkerFaceAlpha', 0.5,'MarkerFaceColor',color_jet(ix,:),'MarkerEdgeColor','none');
        hold on;

        mdl = fitlm(yObs, yModel);
        scatter(1,x1+2+ix.*1.2,15,'MarkerFaceColor',color_jet(ix,:),'MarkerEdgeColor','none','MarkerFaceAlpha', 0.5);
        text(2,x1+2+ix.*1.2,sprintf('Year: %.0f, R^2: %.2f, RMSE: %.2f', ...
            modelResults(ix).year, mdl.Rsquared.Ordinary, sqrt(mean((yObs-yModel).^2))));
    end

    plot([x1 x2], [x1 x2], 'k', 'LineWidth', 1);

    % Calculate Global Stats
    mdl = fitlm(all_obs, all_pred);
    title(sprintf('INa LOYO Validation (R^2 = %.2f, RMSE = %.2f)', ...
        mdl.Rsquared.Ordinary, sqrt(mean((all_obs-all_pred).^2))),'fontsize',10);

    xlabel('Observed GEP','FontSize',14);   ylabel('Predicted GEP','FontSize',14);
    grid on;                                axis([x1 x2 x1 x2]);
    set(gca,'XLim',[x1 x2],'YLim',[x1 x2],'XTick',x3,'YTick',x3,'FontSize',14);

    %% Check parameter stability
    color_jet = bone(numYears+5);
    figure('Color', 'white');
    paramNames = {'GEPmax', 'k_{gr}', 'x_{0}_{gr}', 'k_{bw}', 'x_{0}_{bw}', 'PARtresh', 'Topt', 'Tamp'};
    for ix = 1:numYears
        if isempty(modelResults) || ix > length(modelResults) || isempty(modelResults(ix).year)
            continue;
        end
        for p_idx = 1:length(paramNames)
            ax = subplot(3, 3, p_idx);    hold on;
            years = [modelResults(ix).year];
            vals  = arrayfun(@(s) s.p_val(p_idx), modelResults(ix));
            errs  = arrayfun(@(s) s.p_err(p_idx), modelResults(ix));

            % errorbar(years, vals, errs, 'o-', 'LineWidth', 1.2);
            errorbar(years, vals, errs, 'o-','Color',color_jet(ix,:),...
                'MarkerFaceColor',color_jet(ix,:), 'LineWidth', 1.2, 'CapSize', 10);
            set(ax, 'YTickMode', 'auto');
            ax.YAxis.TickValues = linspace(min(ylim), max(ylim), 4);
            ytickformat('%.0f'); % Use 3 decimals for alpha
            if (p_idx==3)|(p_idx==2)
                ytickformat('%.3f'); % Use 3 decimals for alpha
            end

            ylabel(paramNames{p_idx},'FontSize',14);            set(gca,'FontSize',14);
            xlim([min([modelResults.year])-1 , max([modelResults.year]) + 1;]);
            grid on;  box on;
        end
    end

    %% Last effort, lets check the R2 and rest of the stats
    [INa.dayGEPdaymodelGateLOYO] = FN_computeGEPphotosynthesisGCCgn2br(avg_p_val,counter,...
        INa.dayPARday, INa.daytairmid, INa.ROIgccQA, 0);
    valid = INa.dayGEPday>1 & INa.dayGEPdaymodelGateLOYO>1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodelGateLOYO);
    r = corr(INa.dayGEPdaymodelGateLOYO(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodelGateLOYO(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodelGateLOYO(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodelGateLOYO(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodelGateLOYO(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    save ('modelResultsINa','modelResults','-append')
    save ('INa.mat','INa','-append')
end

% .........................................................................
%% visualize
% .........................................................................
if flag_visualize == 1
    [INa.weekROIgccQA] = AM_week2day_rs(INa.ROIgccQA,INa.daydate);
    [INa.eightROIgccQA] = AM_eightday_rs(INa.ROIgccQA,INa.daydate);
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    plot(INa.weekROIgccQA,INa.weekGEPday,'-');
    plot(INa.weekROIgccQA,INa.weekGEPday,'.');
    hold on; plot(INa.weekROIgccQA(INa.weekM<7),INa.weekGEPday(INa.weekM<7),'.r');
    hold on; plot(INa.weekROIgccQA(INa.weekY==2013),INa.weekGEPday(INa.weekY==2013),'-g');
    hold on; plot(INa.weekROIgccQA(INa.weekY==2016),INa.weekGEPday(INa.weekY==2016),'-k');

    % Hockey stick
    idx = ~isnan(INa.eightROIgccQA) & ~isnan(INa.eightGEPday);
    x_data = INa.eightROIgccQA(idx);
    y_data = INa.eightGEPday(idx);
    % Define the hockey model
    % params(1) is alpha (slope), params(2) is beta (threshold)
    model = @(params, x) params(1) * max(0, x - params(2));
    initial_guess = [200, 0.34];
    lower_bounds  = [0, 0.30];   % Slope must be positive, threshold at least 0.30
    upper_bounds  = [1000, 0.40]; % Threshold shouldn't exceed 0.40 for this data
    options = optimset('Display','off');
    params = lsqcurvefit(model, initial_guess, x_data, y_data, lower_bounds, upper_bounds, options);

    slope_opt = params(1);       threshold_opt  = params(2);
    yModel = model(params, x_data);
    rsquared = 1 - sum((y_data - yModel).^2) / sum((y_data - mean(y_data)).^2);
    fprintf('optimized slope (k): %.4f\n', slope_opt);
    fprintf('treshold (x0): %.2f\n', threshold_opt);
    fprintf('model R-squared:     %.4f\n', rsquared);
    figure('color','white'); hold on;
    scatter(x_data, y_data, 15, 'o','MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    x_plot = linspace(0.30, max(x_data), 100);    y_plot = model(params, x_plot);
    plot(x_plot, y_plot, 'r', 'LineWidth', 2.5);
    xline(threshold_opt, '--', ['Threshold: ' num2str(threshold_opt, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .8]);
    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(min(INa.eightROIgccQA,[],'omitnan'),15,site_name,'FontSize',16)

    % gatekeeper
    color_mtx = jet(12);
    INa.eightGCCnorm = AM_eightday_rs(INa.dayGCCnorm,INa.daydate);
    % idx = ~isnan(INa.eightGCCnorm) & ~isnan(INa.eightGEPday);
    % x_data = INa.eightGCCnorm(idx);
    % y_data = INa.eightGEPday(idx);
    idx = ~isnan(INa.dayGCCnorm) & ~isnan(INa.dayGEPday);
    x_data = INa.dayGCCnorm(idx);
    y_data = INa.dayGEPday(idx);
    z_data = INa.dayM(idx);

    x0 = INamodelParameter(6).parameters(3);

    fLight= 1;
    fTemp = 1;
    x_plot = linspace(0, 1, 200)';  iy = (1:200)';
    y_plot = FN_computeGEPgatekeeperGCCmeteo(INamodelParameter(6).parameters,iy,...
        (iy.*0+1300),(iy.*0+INamodelParameter(6).parameters(5)),...
        x_plot, 0);  %(iy.*0)+14,

    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    for ix=1:12
        ind = find(z_data==ix);
        scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(ix,:),...
            'MarkerEdgeColor',color_mtx(ix,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        text(-0.05,35-ix.*1.5,datestr(datetime(1,ix,1),'mmm'));
        plot(-0.08,35-ix.*1.5,'o','MarkerFaceColor',color_mtx(ix,:),...
            'MarkerEdgeColor',color_mtx(ix,:));
    end
    plot(x_plot, y_plot, 'k', 'LineWidth', 2.5);
    xline(x0, '--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 0]);
    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(0.8,30,site_name,'FontSize',16,'Color','k')
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 35]);
    set(gca, 'FontSize', 14);
    % legend('Location', 'northwest'); legend boxoff;

    %%
    z_data = round(INa.dayLength(idx));
    color_mtx = jet(length(unique(z_data))+1);
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    count = 1;
    for ix=(min(z_data)):round(max(z_data))
        ind = find(z_data==ix);
        scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        text(-0.05,35-ix.*1.5,['gn&bw: ' num2str(ix)]);
        plot(-0.08,35-ix.*1.5,'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:));
        count = count+1;
    end
    plot(x_plot, y_plot, 'b', 'LineWidth', 2.5);
    xline(x0, '--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .8]);
    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(0.8,30,site_name,'FontSize',16)
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 35]);
    set(gca, 'FontSize', 14);

    z_data = round(INa.daySZA(idx));
    color_mtx = jet(length(unique(z_data))+1);
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    count = 1;
    for ix=((min(z_data)):(max(z_data)))
        ind = find(z_data==ix);
        if length(ind)>2
            scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(count,:),...
                'MarkerEdgeColor',color_mtx(count,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
            text(-0.02,35-count,[ num2str(ix)],'FontSize',9);
            plot(-0.05,35-count,'o','MarkerFaceColor',color_mtx(count,:),...
                'MarkerEdgeColor',color_mtx(count,:));
        end
        count = count+1;
    end
    plot(x_plot, y_plot, 'b', 'LineWidth', 2.5);
    xline(x0, '--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .8]);
    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(0.8,30,site_name,'FontSize',16)
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 35]);
    set(gca, 'FontSize', 14);

    %% Two sigmoids
    z_data = round(INa.dayLength(idx));
    color_mtx = jet(length(unique(z_data))+1);
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    count = 1;
    for ix=(min(z_data)):round(max(z_data))
        ind = find(z_data==ix);
        if length(ind)>2
            scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(count,:),...
                'MarkerEdgeColor',color_mtx(count,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
            text(-0.05,35-ix.*1.5,['Day length: ' num2str(ix)]);
            plot(-0.08,35-ix.*1.5,'o','MarkerFaceColor',color_mtx(count,:),...
                'MarkerEdgeColor',color_mtx(count,:));
        end
        count = count+1;
    end
    best_params = [INamodelParameter(7).parameters(1:3),INamodelParameter(7).parameters(6:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1300),...
        (iy.*0+INamodelParameter(7).parameters(7)),x_plot,0);
    x0 = INamodelParameter(7).parameters(3);
    plot(x_plot, y_plot, 'color',[0 0 0] ,'LineWidth', 2.5);
    xline(x0,'--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .0]);
    hold on;

    best_params = [INamodelParameter(7).parameters(1),INamodelParameter(7).parameters(4:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1300),...
        (iy.*0+INamodelParameter(7).parameters(7)),x_plot,0);
    x0 = INamodelParameter(7).parameters(5);
    plot(x_plot, y_plot, 'color',[0.5 0.5 .5], 'LineWidth', 2.5);
    xline(x0, '--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0.5 0.5 .5]);

    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(0.9,33,site_name,'FontSize',16)
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 35]);
    set(gca, 'FontSize', 14);

    %% Two sigmoids month
    z_data = round(INa.dayM(idx));
    color_mtx = jet(length(unique(z_data))+1);
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    count = 1;
    for ix=(min(z_data)):round(max(z_data))
        ind = find(z_data==ix);
        scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        text(-0.05,30-ix.*1.2,(datestr(datetime(0,ix,1),'mmm')),'FontSize',12);
        plot(-0.08,30-ix.*1.2,'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:));
        count = count+1;
    end
    best_params = [INamodelParameter(7).parameters(1:3),INamodelParameter(7).parameters(6:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1000),...
        (iy.*0+INamodelParameter(7).parameters(7)),x_plot,1);
    x0 = INamodelParameter(7).parameters(3);
    plot(x_plot, y_plot, 'color',[0 0 0] ,'LineWidth', 2.5);
    xline(x0,'--', ['X_0 threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .0]);
    text(x_plot(100)+.05, y_plot(100),'green-up','Color','k','FontSize',10);
    hold on;

    best_params = [INamodelParameter(7).parameters(1),INamodelParameter(7).parameters(4:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1000),...
        (iy.*0+INamodelParameter(7).parameters(7)),x_plot,1);
    x0 = INamodelParameter(7).parameters(5);
    plot(x_plot, y_plot, 'color',[0.5 0.5 .5], 'LineWidth', 2.5);
    xline(x0, '--', ['X_0 threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0.5 0.5 .5]);
    text(x_plot(100)+.05, y_plot(100),'brown-down', 'Color',[0.5 0.5 .5],'FontSize',10);

    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(0.85,29,site_name,'FontSize',16)
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 30]);
    set(gca, 'FontSize', 14);

    % test_output = residualFunction(params);
    % bad_idx = find(~isfinite(test_output));
    % fprintf('There are %d non-finite values.\n', length(bad_idx));
    % disp('First few bad values are at indices:');
    
    %% Two sigmoids and NEE
    idx = ~isnan(INa.dayGCCnorm) & ~isnan(INa.dayGEPday);
    x_data = INa.dayGCCnorm(idx);
    y_data = -INa.dayNEE(idx);
    z_data = round(INa.dayM(idx));
    color_mtx = jet(length(unique(z_data))+1);
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    count = 1;
    for ix=(min(z_data)):round(max(z_data))
        ind = find(z_data==ix);
        scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        text(-0.05,15-ix,month_name(ix,:));
        plot(-0.08,15-ix,'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:));
        count = count+1;
    end
    hold on;
    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('NEP (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(0.8,13,site_name,'FontSize',16)
    grid on; box on;
    xlim([-0.1 1.1]); ylim([-10 15]);
    set(gca, 'FontSize', 14);

end

% .........................................................................
%% using fixed grasses parameters
% .........................................................................
if flag_chromaticFixMeteo == 1
    params = [18.0,	-5.0,	39.0,	0.067,	0.018];
    StartGrowing = days(GCC.BegTdate-INa.daydate(1));
    EndGrowing   = days(GCC.EndTdate-INa.daydate(1));
    counter = (1:1:(length(INa.daydate)))';
    gepPredTest = FN_computeGEPchromatic(params, counter, ...
        INa.dayPARday, INa.daytairmid, INa.ROIgccQA, ...
        INa.ROIrccQA, StartGrowing, EndGrowing, 1);
    valid = INa.dayGEPday>1 & gepPredTest>1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(gepPredTest);
    r = corr(gepPredTest(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((gepPredTest(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - gepPredTest(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - gepPredTest(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),gepPredTest(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nstats chromatic fixed [final] parameters:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);
end

if  flag_gatewayFixMeteo == 1
    params = [18,	6.332,	0.1,	3.756,	0.116,	273,	25,	18];
    gepPredTest = FN_computeGEPphotosynthesisGCCgn2br(params, counter, ...
        INa.dayPARday,INa.daytairmid,INa.ROIgccQA,1);
    valid = INa.dayGEPday>1 & gepPredTest>1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(gepPredTest);
    r = corr(gepPredTest(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((gepPredTest(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - gepPredTest(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - gepPredTest(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),gepPredTest(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nstats gateway fixed [final] parameters:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);
end

%% Taylor
if flag_Taylor==1
    INa.eightGEPdaymodelLeafStage = AM_eightday_rs(INa.dayGEPdaymodelLeafStage,INa.daydate);
    INa.eightGEPdaymodelLeafStage = AM_fill(INa.eightGEPdaymodelLeafStage);
    [INa.weekGEPdaymodelLeafStage,~,~,~,~,INa.week_stddayGEPdaymodelLeafStage]  = AM_week2day_rs(INa.dayGEPdaymodelLeafStage,INa.daydate);
    INa.weekGEPdaymodelLeafStage  = AM_fill(INa.weekGEPdaymodelLeafStage);
    INa.monthGEPdaymodelLeafStage = AM_month(INa.dayGEPdaymodelLeafStage,INa.daydate);
    INa.monthGEPdaymodelLeafStage = AM_fill(INa.monthGEPdaymodelLeafStage);

    INa.eightGEPdaymodelLeafAge = AM_eightday_rs(INa.dayGEPdaymodelLeafAge,INa.daydate);
    INa.eightGEPdaymodelLeafAge = AM_fill(INa.eightGEPdaymodelLeafAge);
    [INa.weekGEPdaymodelLeafAge,~,~,~,~,INa.week_stdGEPdaymodelLeafAge]  = AM_week2day_rs(INa.dayGEPdaymodelLeafAge,INa.daydate);
    INa.weekGEPdaymodelLeafAge  = AM_fill(INa.weekGEPdaymodelLeafAge);
    INa.monthGEPdaymodelLeafAge = AM_month(INa.dayGEPdaymodelLeafAge,INa.daydate);
    INa.monthGEPdaymodelLeafAge = AM_fill(INa.monthGEPdaymodelLeafAge);

    INa.eightGEPdaymodelChromatic = AM_eightday_rs(INa.dayGEPdaymodelChromatic,INa.daydate);
    INa.eightGEPdaymodelChromatic = AM_fill(INa.eightGEPdaymodelChromatic);
    [INa.weekGEPdaymodelChromatic,~,~,~,~,INa.week_stdGEPdaymodelChromatic]  = AM_week2day_rs(INa.dayGEPdaymodelChromatic,INa.daydate);
    INa.weekGEPdaymodelChromatic  = AM_fill(INa.weekGEPdaymodelChromatic);
    INa.monthGEPdaymodelChromatic = AM_month(INa.dayGEPdaymodelChromatic,INa.daydate);
    INa.monthGEPdaymodelChromatic = AM_fill(INa.monthGEPdaymodelChromatic);

    INa.eightGEPdaymodelSigmoidGRIVI = AM_eightday_rs(INa.dayGEPdaymodelSigmoidGRIVI,INa.daydate);
    INa.eightGEPdaymodelSigmoidGRIVI = AM_fill(INa.eightGEPdaymodelSigmoidGRIVI);
    [INa.weekGEPdaymodelSigmoidGRIVI,~,~,~,~,INa.week_stdGEPdaymodelSigmoidGRIVI]  = AM_week2day_rs(INa.dayGEPdaymodelSigmoidGRIVI,INa.daydate);
    INa.weekGEPdaymodelSigmoidGRIVI  = AM_fill(INa.weekGEPdaymodelSigmoidGRIVI);
    INa.monthGEPdaymodelSigmoidGRIVI = AM_month(INa.dayGEPdaymodelSigmoidGRIVI,INa.daydate);
    INa.monthGEPdaymodelSigmoidGRIVI = AM_fill(INa.monthGEPdaymodelSigmoidGRIVI);

    INa.eightGEPdaymodelHockey = AM_eightday_rs(INa.dayGEPdaymodelHockey,INa.daydate);
    INa.eightGEPdaymodelHockey = AM_fill(INa.eightGEPdaymodelHockey);
    [INa.weekGEPdaymodelHockey,~,~,~,~,INa.week_stdGEPdaymodelHockey]  = AM_week2day_rs(INa.dayGEPdaymodelHockey,INa.daydate);
    INa.weekGEPdaymodelHockey  = AM_fill(INa.weekGEPdaymodelHockey);
    INa.monthGEPdaymodelHockey = AM_month(INa.dayGEPdaymodelHockey,INa.daydate);
    INa.monthGEPdaymodelHockey = AM_fill(INa.monthGEPdaymodelHockey);

    INa.eightGEPdaymodelGate = AM_eightday_rs(INa.dayGEPdaymodelGate,INa.daydate);
    INa.eightGEPdaymodelGate = AM_fill(INa.eightGEPdaymodelGate);
    [INa.weekGEPdaymodelGate,~,~,~,~,INa.week_stdGEPdaymodelGate]  = AM_week2day_rs(INa.dayGEPdaymodelGate,INa.daydate);
    INa.weekGEPdaymodelGate  = AM_fill(INa.weekGEPdaymodelGate);
    INa.monthGEPdaymodelGate = AM_month(INa.dayGEPdaymodelGate,INa.daydate);
    INa.monthGEPdaymodelGate = AM_fill(INa.monthGEPdaymodelGate);

    INa.eightGEPdaymodelGateGnBw = AM_eightday_rs(INa.dayGEPdaymodelGateGnBw,INa.daydate);
    INa.eightGEPdaymodelGateGnBw = AM_fill(INa.eightGEPdaymodelGateGnBw);
    [INa.weekGEPdaymodelGateGnBw,~,~,~,~,INa.week_stdGEPdaymodelGateGnBw]  = AM_week2day_rs(INa.dayGEPdaymodelGateGnBw,INa.daydate);
    INa.weekGEPdaymodelGateGnBw  = AM_fill(INa.weekGEPdaymodelGateGnBw);
    INa.monthGEPdaymodelGateGnBw = AM_month(INa.dayGEPdaymodelGateGnBw,INa.daydate);
    INa.monthGEPdaymodelGateGnBw = AM_fill(INa.monthGEPdaymodelGateGnBw);

    % .........................................................................
    %% Taylor
    % .........................................................................
    INaday_R_taylor=NaN(7,1);       INaday_STD_taylor=NaN(7,1);       INaday_STD_obs=NaN(7,1);
    [INaday_R_taylor(1,1),INaday_STD_taylor(1,1),INaday_STD_obs(1,1)] = AM_Taylor_normalize(INa.dayGEPday,INa.dayGEPdaymodelLeafStage);
    [INaday_R_taylor(2,1),INaday_STD_taylor(2,1),INaday_STD_obs(2,1)] = AM_Taylor_normalize(INa.dayGEPday,INa.dayGEPdaymodelLeafAge);
    [INaday_R_taylor(3,1),INaday_STD_taylor(3,1),INaday_STD_obs(3,1)] = AM_Taylor_normalize(INa.dayGEPday,INa.dayGEPdaymodelChromatic);
    [INaday_R_taylor(4,1),INaday_STD_taylor(4,1),INaday_STD_obs(4,1)] = AM_Taylor_normalize(INa.dayGEPday,INa.dayGEPdaymodelSigmoidGRIVI);
    [INaday_R_taylor(5,1),INaday_STD_taylor(5,1),INaday_STD_obs(5,1)] = AM_Taylor_normalize(INa.dayGEPday,INa.dayGEPdaymodelHockey);
    [INaday_R_taylor(6,1),INaday_STD_taylor(6,1),INaday_STD_obs(6,1)] = AM_Taylor_normalize(INa.dayGEPday,INa.dayGEPdaymodelGate);
    [INaday_R_taylor(7,1),INaday_STD_taylor(7,1),INaday_STD_obs(7,1)] = AM_Taylor_normalize(INa.dayGEPday,INa.dayGEPdaymodelGateGnBw);

    INaeight_R_taylor=NaN(7,1);       INaeight_STD_taylor=NaN(7,1);       INaeight_STD_obs=NaN(7,1);
    [INaeight_R_taylor(1,1),INaeight_STD_taylor(1,1),INaeight_STD_obs(1,1)] = AM_Taylor_normalize(INa.eightGEPday,INa.eightGEPdaymodelLeafStage);
    [INaeight_R_taylor(2,1),INaeight_STD_taylor(2,1),INaeight_STD_obs(2,1)] = AM_Taylor_normalize(INa.eightGEPday,INa.eightGEPdaymodelLeafAge);
    [INaeight_R_taylor(3,1),INaeight_STD_taylor(3,1),INaeight_STD_obs(3,1)] = AM_Taylor_normalize(INa.eightGEPday,INa.eightGEPdaymodelChromatic);
    [INaeight_R_taylor(4,1),INaeight_STD_taylor(4,1),INaeight_STD_obs(4,1)] = AM_Taylor_normalize(INa.eightGEPday,INa.eightGEPdaymodelSigmoidGRIVI);
    [INaeight_R_taylor(5,1),INaeight_STD_taylor(5,1),INaeight_STD_obs(5,1)] = AM_Taylor_normalize(INa.eightGEPday,INa.eightGEPdaymodelHockey);
    [INaeight_R_taylor(6,1),INaeight_STD_taylor(6,1),INaeight_STD_obs(6,1)] = AM_Taylor_normalize(INa.eightGEPday,INa.eightGEPdaymodelGate);
    [INaeight_R_taylor(7,1),INaeight_STD_taylor(7,1),INaeight_STD_obs(7,1)] = AM_Taylor_normalize(INa.eightGEPday,INa.eightGEPdaymodelGateGnBw);

    INaweek_R_taylor=NaN(7,1);       INaweek_STD_taylor=NaN(7,1);       INaweek_STD_obs=NaN(7,1);
    [INaweek_R_taylor(1,1),INaweek_STD_taylor(1,1),INaweek_STD_obs(1,1)] = AM_Taylor_normalize(INa.weekGEPday,INa.weekGEPdaymodelLeafStage);
    [INaweek_R_taylor(2,1),INaweek_STD_taylor(2,1),INaweek_STD_obs(2,1)] = AM_Taylor_normalize(INa.weekGEPday,INa.weekGEPdaymodelLeafAge);
    [INaweek_R_taylor(3,1),INaweek_STD_taylor(3,1),INaweek_STD_obs(3,1)] = AM_Taylor_normalize(INa.weekGEPday,INa.weekGEPdaymodelChromatic);
    [INaweek_R_taylor(4,1),INaweek_STD_taylor(4,1),INaweek_STD_obs(4,1)] = AM_Taylor_normalize(INa.weekGEPday,INa.weekGEPdaymodelSigmoidGRIVI);
    [INaweek_R_taylor(5,1),INaweek_STD_taylor(5,1),INaweek_STD_obs(5,1)] = AM_Taylor_normalize(INa.weekGEPday,INa.weekGEPdaymodelHockey);
    [INaweek_R_taylor(6,1),INaweek_STD_taylor(6,1),INaweek_STD_obs(6,1)] = AM_Taylor_normalize(INa.weekGEPday,INa.weekGEPdaymodelGate);
    [INaweek_R_taylor(7,1),INaweek_STD_taylor(7,1),INaweek_STD_obs(7,1)] = AM_Taylor_normalize(INa.weekGEPday,INa.weekGEPdaymodelGateGnBw);

    INamonth_R_taylor=NaN(7,1);       INamonth_STD_taylor=NaN(7,1);       INamonth_STD_obs=NaN(7,1);
    [INamonth_R_taylor(1,1),INamonth_STD_taylor(1,1),INamonth_STD_obs(1,1)] = AM_Taylor_normalize(INa.monthGEPday,INa.monthGEPdaymodelLeafStage);
    [INamonth_R_taylor(2,1),INamonth_STD_taylor(2,1),INamonth_STD_obs(2,1)] = AM_Taylor_normalize(INa.monthGEPday,INa.monthGEPdaymodelLeafAge);
    [INamonth_R_taylor(3,1),INamonth_STD_taylor(3,1),INamonth_STD_obs(3,1)] = AM_Taylor_normalize(INa.monthGEPday,INa.monthGEPdaymodelChromatic);
    [INamonth_R_taylor(4,1),INamonth_STD_taylor(4,1),INamonth_STD_obs(4,1)] = AM_Taylor_normalize(INa.monthGEPday,INa.monthGEPdaymodelSigmoidGRIVI);
    [INamonth_R_taylor(5,1),INamonth_STD_taylor(5,1),INamonth_STD_obs(5,1)] = AM_Taylor_normalize(INa.monthGEPday,INa.monthGEPdaymodelHockey);
    [INamonth_R_taylor(6,1),INamonth_STD_taylor(6,1),INamonth_STD_obs(6,1)] = AM_Taylor_normalize(INa.monthGEPday,INa.monthGEPdaymodelGate);
    [INamonth_R_taylor(7,1),INamonth_STD_taylor(7,1),INamonth_STD_obs(7,1)] = AM_Taylor_normalize(INa.monthGEPday,INa.monthGEPdaymodelGateGnBw);
    %%
    figure('color','white','position',[300,300,500,500]);
    Name_Taylor={'sn';'la';'ch';'sg';'hk';'gk';'gkx'};   color_mtx = jet(7);
    subplot(2,2,1);
    AM_Taylor_plot_std2(Name_Taylor,INaday_R_taylor,INaday_STD_taylor,INaday_STD_obs,'daily GEP_{daytime} v. model ',color_mtx);
    subplot(2,2,2);
    AM_Taylor_plot_std2(Name_Taylor,INaeight_R_taylor,INaeight_STD_taylor,INaeight_STD_obs,'8-days',color_mtx);
    subplot(2,2,3);
    AM_Taylor_plot_std2(Name_Taylor,INaweek_R_taylor,INaweek_STD_taylor,INaweek_STD_obs,'16-days',color_mtx);
    subplot(2,2,4);
    AM_Taylor_plot_std2(Name_Taylor,INamonth_R_taylor,INamonth_STD_taylor,INamonth_STD_obs,'monthly',color_mtx);
end

% .....................................................................
%% GGC phenology as gatekeeper greenup & browndown segments
% .....................................................................
if flag_normalize==1
    % .....................................................................
    %% Year-by-year normalization
    % .....................................................................
    params = [prctile(INa.dayGEPday, 98), 4.5, 0.5,  4.5, 0.5, 100, 22, 20];
    lb     = [prctile(INa.dayGEPday, 95), 2, 0.1, 2, 0.1, 10, 18, 10];
    ub     = [max(INa.dayGEPday,[],'omitnan'), 8, 1, 8, 1, 400, 28, 30];

    counter = (1:1:(length(INa.daydate)))';

    ind = find((~isnan(INa.dayGEPday))&(~isnan(INa.ROIgccQA))&...
        (~isnan(INa.daytairday))&(~isnan(INa.dayPARday))&(INa.dayGEPday>0)&...
        (isfinite(INa.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPphotosynthesisGCCgn2br(params,counter(ind),...
        INa.dayPARday(ind), INa.daytairday(ind),INa.ROIgccQA(ind), 1)...
        - INa.dayGEPday(ind));

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    % fprintf('GEP_{max}: %.3f\nSteeepness: %.3f\nSaturation: %.3f\n', best_params);
    fprintf('GEP_{max}: %.3f\nSteeep1: %.3f\nSat1: %.3f\nSteeep2: %.3f\nSat2: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    INamodelNormal(1).parameters = best_params;

    [INa.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params,counter,...
        INa.dayPARday, INa.daytairday, INa.ROIgccQA, 1);  %, INa.dayLength

    % Statistics
    valid = INa.dayGEPday>0.1 & INa.dayGEPdaymodel>0.1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodel);
    r = corr(INa.dayGEPdaymodel(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodel(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    figure('color','white','Position',[50 50 1800 400],'units','inches');
    y = [INa.day_recurrentGEPday(ind)-INa.day_recurrent_stdGEPday(ind),2.*INa.day_recurrent_stdGEPday(ind)];
    h = area(INa.daydate(ind),y);     set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    hold on;
    hl1 = plot(INa.daydate(ind),INa.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    hl2 = plot(INa.daydate(ind),smoothdata(INa.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);
    scatter(INa.daydate(ind),INa.dayGEPday(ind),10,'o','MarkerFaceColor',[.4 .4 .4],'MarkerEdgeColor',[.4 .4 .4],...
        'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);

    scatter(INa.daydate(ind),INa.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(7,:),'MarkerEdgeColor',color_mtx_dark(7,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl3 = plot(INa.daydate(ind),smoothdata(INa.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(7,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = INa.month;
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(INa.daydate(ind(20)),25,site_name,'FontSize',16)
    % INa.dayGEPdaymodelGateGnBw = INa.dayGEPdaymodel;

    %% Normalized
    residualFunction = @(params) (FN_computeGEPphotosynthesisGCCgn2br(params,counter(ind),...
        INa.dayPARday(ind), INa.daytairday(ind),INa.ROIgccQA(ind), 0)...
        - INa.dayGEPday(ind));

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    % fprintf('GEP_{max}: %.3f\nSteeepness: %.3f\nSaturation: %.3f\n', best_params);
    fprintf('GEP_{max}: %.3f\nSteeep1: %.3f\nSat1: %.3f\nSteeep2: %.3f\nSat2: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    INamodelNormal(2).parameters = best_params;

    [INa.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params,counter,...
        INa.dayPARday, INa.daytairday, INa.ROIgccQA, 0);  %, INa.dayLength

    % Statistics
    valid = INa.dayGEPday>0.1 & INa.dayGEPdaymodel>0.1 & INa.dayGEPday<maxGEPday &... %& INa.dayGEPday < 30
        ~isnan(INa.dayGEPday) & ~isnan(INa.dayGEPdaymodel);
    r = corr(INa.dayGEPdaymodel(valid), INa.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((INa.dayGEPdaymodel(valid) - INa.dayGEPday(valid)) ./ INa.dayGEPday(valid)).^2);
    MSE = mean((INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(INa.dayGEPday(valid) - INa.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(INa.dayGEPday(valid),INa.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(INa.daydate(ind),INa.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl4 = plot(INa.daydate(ind),smoothdata(INa.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(2,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = INa.month;
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(INa.daydate(ind(20)),25,site_name,'FontSize',16)
    legend([hl3,hl4],'normalize year-to-year','normalize entire time series','observation'); legend box off;
    % INa.dayGEPdaymodelGateGnBw = INa.dayGEPdaymodel;

end