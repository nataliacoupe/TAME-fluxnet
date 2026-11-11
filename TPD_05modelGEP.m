% for TAME work
% Natalia Restrepo-Coupe
% Toronto, December 2025 cold and gloomy
%..........................................................................
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;

load('matlabTPD.mat');

flag_model = 1;    flag_read_timesat = 1;    flag_model_test_chromatic = 1;
flag_model_test_gatekeeper = 1;             flag_visualize = 10;
flag_gatewayFixMeteo = 10;                   flag_compare_gate_normal = 1; % 1 if we want to "fix" three of the meteo parameters on the LOYO
flag_normalize =10;
% Topt and Tamp, PARthresh
% (if not use 0)
flag_chromaticFixMeteo = 0;                  % This flag will "fix" two of the parameters Tmax and Tmin

TPD.dayJD = day(TPD.daydate,'dayofyear');
[~,~,TPD.dayLength,~,~,TPD.daySZA] = AM_solar_rad(TPD.dayJD,0,lat,lon);
TPD.SZArad = TPD.daySZA * (pi / 180);

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
    % ROITPD.dayGCC = [iw;iy;iz];
    % ROITPD.daydate = newTime;
    % plot( ROITPD.daydate, ROITPD.dayGCC);
    %
    % [ROITPD.day_recurrentGCC,ROITPD.day_recurrent_stdGCC]  = AM_dayAVG_recurrent(ROITPD.dayGCC,ROITPD.daydate);
    % ROITPD.day_recurrentGCCGoley = sgolayfilt(ROITPD.day_recurrentGCC,polyorder,framesize);
    %
    % ROITPD.dayJD = day(ROITPD.daydate,'dayofyear');
    % [ROITPD.dayY,ROITPD.dayM,ROITPD.dayD] = datevec(ROITPD.daydate);

    windowSmooth = 21;  %11;

    % Final QA for indices
    iy = TPD.ROIgcc;
    % indCamera = []; %find(TPD.daydate<datetime(2018,6,1));
    % iy(indCamera) = NaN;
    % ind = find(~isnan(iy));     ix = detrend(iy(ind))+mean(iy,'omitnan');
    TPD.ROIgccQA = iy;            %TPD.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(TPD.ROIgccQA,3);
    % TPD.ROIgccQA(TPD.daydate>=datetime(2023,1,1)) = NaN;
    TPD.ROIgccQA = FN_fillVI(TPD.daydate,iy);

    iy = TPD.ROIGRRI;
    TPD.ROIgrriQA = iy;            %TPD.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(TPD.ROIgrriQA,3);
    TPD.ROIgrriQA = FN_fillVI(TPD.daydate,iy);

    iy = TPD.ROIGRIVI;
    TPD.ROIgriviQA = iy;            %TPD.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(TPD.ROIgriviQA,3);
    TPD.ROIgriviQA = FN_fillVI(TPD.daydate,iy);

    iy = TPD.ROIexgreen;
    TPD.ROIexgreenQA = iy;            %TPD.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(TPD.ROIexgreenQA,3);
    TPD.ROIexgreenQA = FN_fillVI(TPD.daydate,iy);

    iy = TPD.ROIcci;
    TPD.ROIcciQA = iy;            %TPD.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(TPD.ROIcciQA,3);
    TPD.ROIcciQA = FN_fillVI(TPD.daydate,iy);

    iy = TPD.ROIrcc;
    iy(TPD.ROIrcc<0.35) = NaN;   %TPD.ROIrcc(TPD.daydate>datetime(2021,12,31)) = NaN;
    % iy(indCamera) = NaN;
    % ind = find(~isnan(iy));       ix = detrend(iy(ind))+mean(iy,'omitnan');
    TPD.ROIrccQA = iy;            %TPD.ROIrccQA(ind) = ix;
    [~,TPD.ROIrccQA] = AM_spike_detection(TPD.ROIrccQA,3);
    iy = smoothdata(TPD.ROIrccQA,'movmean',windowSmooth);
    % TPD.ROIrccQA(TPD.daydate>=datetime(2023,1,1)) = NaN;
    TPD.ROIrccQA = FN_fillVI(TPD.daydate,iy);

    %% GCC
    filename = 'timesat/TPDseasonalityGCC.txt';
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
        if ~isnan(GCC.BegTtemp(ix));   GCC.BegTdate(ix) = ROITPD.daydate(ceil(GCC.BegTtemp(ix)));   end
        if ~isnan(GCC.EndTtemp(ix));   GCC.EndTdate(ix) = ROITPD.daydate(floor(GCC.EndTtemp(ix)));  end
        if ~isnan(GCC.MaxTtemp(ix));   GCC.MaxTdate(ix) = ROITPD.daydate(floor(GCC.MaxTtemp(ix)));  end
    end

    GCC.BegTjd = day(GCC.BegTdate,'dayofyear');
    GCC.EndTjd = day(GCC.EndTdate,'dayofyear');
    GCC.MaxTjd = day(GCC.MaxTdate,'dayofyear');

    ind = find((GCC.BegTdate>=ROITPD.daydate(1))&(GCC.BegTdate<=ROITPD.daydate(end)));  GCC.BegT = GCC.BegTjd(ind);
    ind = find((GCC.EndTdate>=ROITPD.daydate(1))&(GCC.EndTdate<=ROITPD.daydate(end)));  GCC.EndT = GCC.EndTjd(ind);
    ind = find((GCC.MaxTdate>=ROITPD.daydate(1))&(GCC.MaxTdate<=ROITPD.daydate(end)));  GCC.MaxT = GCC.MaxTjd(ind);

    [ROITPD.daydateY,ROITPD.daydateM,ROITPD.daydateD] = datevec(ROITPD.daydate);
    GCC.daydateYears = unique(ROITPD.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% GRRI
    filename = 'timesat/TPDseasonalityGRRI.txt';
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
        if ~isnan(GRRI.BegTtemp(ix));   GRRI.BegTdate(ix) = ROITPD.daydate(ceil(GRRI.BegTtemp(ix)));   end
        if ~isnan(GRRI.EndTtemp(ix));   GRRI.EndTdate(ix) = ROITPD.daydate(floor(GRRI.EndTtemp(ix)));  end
        if ~isnan(GRRI.MaxTtemp(ix));   GRRI.MaxTdate(ix) = ROITPD.daydate(floor(GRRI.MaxTtemp(ix)));  end
    end

    GRRI.BegTjd = day(GRRI.BegTdate,'dayofyear');
    GRRI.EndTjd = day(GRRI.EndTdate,'dayofyear');
    GRRI.MaxTjd = day(GRRI.MaxTdate,'dayofyear');

    ind = find((GRRI.BegTdate>=ROITPD.daydate(1))&(GRRI.BegTdate<=ROITPD.daydate(end)));  GRRI.BegT = GRRI.BegTjd(ind);
    ind = find((GRRI.EndTdate>=ROITPD.daydate(1))&(GRRI.EndTdate<=ROITPD.daydate(end)));  GRRI.EndT = GRRI.EndTjd(ind);
    ind = find((GRRI.MaxTdate>=ROITPD.daydate(1))&(GRRI.MaxTdate<=ROITPD.daydate(end)));  GRRI.MaxT = GRRI.MaxTjd(ind);

    [ROITPD.daydateY,ROITPD.daydateM,ROITPD.daydateD] = datevec(ROITPD.daydate);
    GRRI.daydateYears = unique(ROITPD.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% RCC
    filename = 'timesat/TPDseasonalityRCC.txt';
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
        if ~isnan(RCC.BegTtemp(ix));   RCC.BegTdate(ix) = ROITPD.daydate(ceil(RCC.BegTtemp(ix)));   end
        if ~isnan(RCC.EndTtemp(ix));   RCC.EndTdate(ix) = ROITPD.daydate(floor(RCC.EndTtemp(ix)));  end
        if ~isnan(RCC.MaxTtemp(ix));   RCC.MaxTdate(ix) = ROITPD.daydate(floor(RCC.MaxTtemp(ix)));  end
    end

    RCC.BegTjd = day(RCC.BegTdate,'dayofyear');
    RCC.EndTjd = day(RCC.EndTdate,'dayofyear');
    RCC.MaxTjd = day(RCC.MaxTdate,'dayofyear');

    ind = find((RCC.BegTdate>=ROITPD.daydate(1))&(RCC.BegTdate<=ROITPD.daydate(end)));  RCC.BegT = RCC.BegTjd(ind);
    ind = find((RCC.EndTdate>=ROITPD.daydate(1))&(RCC.EndTdate<=ROITPD.daydate(end)));  RCC.EndT = RCC.EndTjd(ind);
    ind = find((RCC.MaxTdate>=ROITPD.daydate(1))&(RCC.MaxTdate<=ROITPD.daydate(end)));  RCC.MaxT = RCC.MaxTjd(ind);

    RCC.daydateYears = unique(ROITPD.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% RCCabs
    filename = 'timesat/TPDseasonalityRCCabs.txt';
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
    for ix = 1:length(RCCabs.BegTtemp)-2
        if ~isnan(RCCabs.BegTtemp(ix));   RCCabs.BegTdate(ix) = ROITPD.daydate(ceil(RCCabs.BegTtemp(ix)));   end
        if ~isnan(RCCabs.EndTtemp(ix));   RCCabs.EndTdate(ix) = ROITPD.daydate(floor(RCCabs.EndTtemp(ix)));  end
        if ~isnan(RCCabs.MaxTtemp(ix));   RCCabs.MaxTdate(ix) = ROITPD.daydate(floor(RCCabs.MaxTtemp(ix)));  end
    end

    RCCabs.BegTjd = day(RCCabs.BegTdate,'dayofyear');
    RCCabs.EndTjd = day(RCCabs.EndTdate,'dayofyear');
    RCCabs.MaxTjd = day(RCCabs.MaxTdate,'dayofyear');

    ind = find((RCCabs.BegTdate>=ROITPD.daydate(1))&(RCCabs.BegTdate<=ROITPD.daydate(end)));  RCCabs.BegT = RCCabs.BegTjd(ind);
    ind = find((RCCabs.EndTdate>=ROITPD.daydate(1))&(RCCabs.EndTdate<=ROITPD.daydate(end)));  RCCabs.EndT = RCCabs.EndTjd(ind);
    ind = find((RCCabs.MaxTdate>=ROITPD.daydate(1))&(RCCabs.MaxTdate<=ROITPD.daydate(end)));  RCCabs.MaxT = RCCabs.MaxTjd(ind);

    RCCabs.daydateYears = unique(ROITPD.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %%
    v1 = -1;         v2 = 10;          v1 = v1+1;      v3 = v1:((v2-v1)/4):v2;
    v4 = v1:((v2-v1)/(max(TPD.dayY)-min(ROI.dayY)+1)):v2;
    y1 = 0.3;      y2 = 0.45;         y3 = y1:((y2-y1)/4):y2;
    y4 = y1:((y2-y1)/(max(TPD.dayY)-min(ROI.dayY)+1)):y2;
    figure('color','white');           hold on;
    ik = ROI.dayY(1);   count=1;       color_jet = jet(max(TPD.dayY)-min(ROI.dayY)+1);
    while (ik<TPD.dayY(end))&(count<length(GCC.BegTdate))
        current_SGS = GCC.BegTdate(count);
        current_EGS = GCC.EndTdate(count);
        ind = find((TPD.daydate>=current_SGS)&(TPD.daydate<=current_EGS)&(TPD.dayY == ik));
        hl1  =  plot(TPD.ROIgccQA(ind),TPD.dayGEPday(ind).*100./TPD.dayPARday(ind),'.','MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
        AM_compute_regression(TPD.ROIgccQA(ind),TPD.dayGEPday(ind).*100./TPD.dayPARday(ind),color_jet(count,:),1);
        polyfit(TPD.ROIgccQA(ind),TPD.dayGEPday(ind).*100./TPD.dayPARday(ind),2); %color_jet(count,:),1
        plot(.33,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
        text (.34,v4(count),num2str(ik),'FontSize',8);
        ik = ik+1;  count = count+1;
    end
    ylabel ('GEP_{day}/PAR_{day}(\mumolC/\mmol)');              xlabel ('GCC');
    axis([y1 y2 v1 v2])

    %%
    v1 = -1;         v2 = 7;          v1 = v1+1;      v3 = v1:((v2-v1)/4):v2;
    v4 = v1:((v2-v1)/(max(TPD.dayY)-min(ROI.dayY))):v2;
    y1 = 0.3;      y2 = 0.4;         y3 = y1:((y2-y1)/4):y2;
    y4 = y1:((y2-y1)/(max(TPD.dayY)-min(ROI.dayY))):y2;
    figure('color','white');           hold on;
    ik = ROI.dayY(1);   count=1;       color_jet = jet(max(TPD.dayY)-min(ROI.dayY)+1);
    while ik<TPD.dayY(end)&(count<length(GCC.BegTdate))
        current_SGS = GCC.BegTdate(count)-days(15);
        current_EGS = GCC.EndTdate(count)+days(15);
        ind = find((TPD.eight>=current_SGS)&(TPD.eight<=current_EGS)&(TPD.eightY == ik));
        hl1  =  plot(TPD.eightROIgcc(ind),smoothdata(TPD.eightGEPday(ind).*100./TPD.eightPARday(ind),'movmedian'),'-',...
            'Color',color_jet(count,:)); hold on;
        plot(TPD.eightROIgcc(ind),TPD.eightGEPday(ind).*100./TPD.eightPARday(ind),'.',...
            'MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
        AM_compute_regression(TPD.eightROIgcc(ind),TPD.eightGEPday(ind).*100./TPD.eightPARday(ind),color_jet(count,:),0);
        % polyfit(TPD.eightROIgcc(ind),TPD.eightGEPday(ind).*100./TPD.eightPARday(ind),2); %color_jet(count,:),1
        plot(.33,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
        text (.34,v4(count),num2str(ik),'FontSize',8);
        ik = ik+1;  count = count+1;
    end
    ylabel ('GEP_{day}(gC m^-^2 d^-^2)');  xlabel ('GCC');
    axis([y1 y2 v1 v2])

    %% GRIVI
    filename = 'timesat/TPDseasonalityGRIVI.txt';
    GRIVI = readtable(filename, 'Delimiter', '\t');  GRIVI = table2struct(GRIVI, 'ToScalar', true);

    GRIVI.BegTjd = day(GRIVI.BegTdate, 'dayofyear');   % The start/first minima
    GRIVI.MaxTjd = day(GRIVI.MaxTdate, 'dayofyear');         % The peak
    GRIVI.EndTjd = day(GRIVI.EndTdate, 'dayofyear'); % The end/second minima
    % GRRI.Year = T.Year;[cite: 1]

    % GRIVI.BegT = [];            GRIVI.EndT = [];                GRIVI.MaxT = [];
    ind = find((GRIVI.BegTdate>=ROITPD.daydate(1))&(GRIVI.BegTdate<=ROITPD.daydate(end)));
    GRIVI.BegT = GRIVI.BegTjd(ind);
    ind = find((GRIVI.EndTdate>=ROITPD.daydate(1))&(GRIVI.EndTdate<=ROITPD.daydate(end)));  GRIVI.EndT = GRIVI.EndTjd(ind);
    ind = find((GRIVI.MaxTdate>=ROITPD.daydate(1))&(GRIVI.MaxTdate<=ROITPD.daydate(end)));  GRIVI.MaxT = GRIVI.MaxTjd(ind);

    [ROITPD.daydateY,ROITPD.daydateM,ROITPD.daydateD] = datevec(ROITPD.daydate);
    GRIVI.daydateYears = unique(ROITPD.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;
end

%% ........................................................................
if flag_model==1
    color_mtx = [ 255/255 127/255 20/255; 50/255 77/255 255/255; ...
        0.1020 0.5882 0.2549; 60/255 187/255 255/255; 245/255 55/255 58/255;...
        245/255 55/255 245/255; 245/255 255/255 45/255; 0.1020 0.5882 0.2549; 0.1020 0.5882 0.2549];
    color_mtx_dark = color_mtx.*0.99;
    color_mtx_light = color_mtx.*1.1; color_mtx_light(color_mtx_light>1) = 1;

    maxGEPday = prctile(TPD.dayGEPday,97);
    minGEPday = prctile(TPD.dayGEPday(TPD.dayM==12|TPD.dayM<=4),3);

    % Optimization options.... number of iterations can be > 5000
    opts = optimoptions('lsqnonlin', 'Display', 'final', 'MaxIterations', 10000,...  % , 'Display', 'iter'
        'MaxFunctionEvaluations', 10000, 'FunctionTolerance', 1e-15, ...             % Tighter tolerance for higher R2
        'StepTolerance', 1e-15, ...
        'OptimalityTolerance', 1e-15, ...
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
    params = [22, 0, 32, 1 ,1 ,1];

    % Lower and upper bounds for parameters
    lb = [18, -5, 30, .01, .01, .01];  % realistic lower bounds
    ub = [28, 8, 40, 6, 6, 6];  % realistic upper bounds

    % Seasonal modulation: greenup ramp up, browndown ramp down
    StartGrowing = days(GCC.BegTdate-TPD.daydate(1));   %-LagStart
    GreenupPeak  = days(GCC.MaxTdate-TPD.daydate(1));
    EndGrowing   = days(GCC.EndTdate-TPD.daydate(1));   %+LagStart

    counter = (1:1:(length(TPD.daydate)))';

    ind = find((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgccQA))&...
        (~isnan(TPD.daytairday))&(~isnan(TPD.dayPARday))&(TPD.dayGEPday>0)&...
        (isfinite(TPD.dayGEPday)));

    % + 0.25: acts as a "floor" for the uncertainty. Preventing th optimizer from over-fitting to days
    % with extremely low GEP while still allowing it to prioritize accuracy during high-productivity periods.
    residualFunction = @(params) (FN_computeGEPseasons(params,counter(ind),TPD.ROIgccQA(ind),...
        TPD.dayPARday(ind), TPD.daytairday(ind),....
        StartGrowing, GreenupPeak, EndGrowing, 1) - TPD.dayGEPday(ind)).*(sqrt(abs(TPD.dayGEPday(ind))) + 0.25);

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
    TPDmodelParameter(1).parameters = best_params;

    TPD.dayGEPdaymodel = FN_computeGEPseasons(best_params,counter,TPD.ROIgccQA,...
        TPD.dayPARday, TPD.daytairday,....
        StartGrowing, GreenupPeak, EndGrowing, 1);

    TPD.dayGEPdaymodel((isnan(TPD.ROIgccQA))|(TPD.dayGEPdaymodel==0)) = NaN;

    % Statistics
    valid = TPD.dayGEPday>0.1 & TPD.dayGEPdaymodel>0.1 & TPD.dayGEPday<maxGEPday &...
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    % r = corr(TPD.dayGEPdaymodel(ind), TPD.dayGEPday(ind), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    % SS_res = sum((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    % SS_tot = sum((TPD.dayGEPday(valid) - mean(TPD.dayGEPday(valid))).^2);
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    % yearSelect = 2019;
    ind = 1:length(TPD.dayY);       % ind = find(TPD.dayY==yearSelect);
    v1 = 0;                         v2 = 32;       %v3 = v1:((v2-v1)/4):v2;
    % figure('color','white','Position',[50 50 600 400],'units','inches');
    figure('color','white','Position',[50 50 1800 400],'units','inches');
    y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
    h = area(TPD.daydate(ind),y);     set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    hold on;
    hl1 = plot(TPD.daydate(ind),TPD.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    hl2 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);
    scatter(TPD.daydate(ind),TPD.dayGEPday(ind),10,'o','MarkerFaceColor',[.4 .4 .4],'MarkerEdgeColor',[.4 .4 .4],...
        'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);

    scatter(TPD.daydate(ind),TPD.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl3 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(1,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';
    ax2.XAxis.MinorTickValues = TPD.month(1:12:end);  ax2.XAxis.MinorTickValues = TPD.month;
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[ROITPD.daydate(ind(1)) TPD.daydate(ind(end))],...
        'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:12:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)
    legend([hl3,hl1],'model','observation'); legend box off;

    TPD.dayGEPdaymodelLeafStage = TPD.dayGEPdaymodel;
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
    StartGrowing = days(GCC.BegTdate-TPD.daydate(1))-LagStart;
    EndGrowing   = days(GCC.EndTdate-TPD.daydate(1))+LagStart;

    counter = (1:1:(length(TPD.daydate)))';

    ind = find((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgccQA))&...
        (~isnan(TPD.daytairday))&(~isnan(TPD.dayPARday))&(TPD.dayGEPday>0)&...
        (isfinite(TPD.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPleafage(params,counter(ind),...
        TPD.dayPARday(ind), TPD.daytairday(ind),....
        StartGrowing, EndGrowing) - TPD.dayGEPday(ind)) .* (sqrt(abs(TPD.dayGEPday(ind))) + 0.25);

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('Topt: %.3f\nTmin: %.3f\nTmax: %.3f\nAmaxTime: %.3f\nMaxValue: %.3f\n', best_params);

    % Display best-fit parameters
    TPDmodelParameter(2).parameters = best_params;

    TPD.dayGEPdaymodel = FN_computeGEPleafage(best_params,counter,...
        TPD.dayPARday, TPD.daytairday,....
        StartGrowing, EndGrowing);
    TPD.dayGEPdaymodel(TPD.dayGEPdaymodel==0) = NaN;

    % Statistics
    valid = TPD.dayGEPday>1  & TPD.dayGEPdaymodel>1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    % r = corr(TPD.dayGEPdaymodel(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    % SS_res = sum((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    % SS_tot = sum((TPD.dayGEPday(valid) - mean(TPD.dayGEPday(valid))).^2);
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    % % % yearSelect = 2019;
    % % ind = 1:length(TPD.dayY);       % ind = find(TPD.dayY==yearSelect);
    % % v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    % % % figure('color','white','Position',[50 50 600 400],'units','inches');
    % % figure('color','white','Position',[50 50 1800 400],'units','inches');
    % % y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
    % % h = area(TPD.daydate(ind),y);     set(gca,'Layer','top');
    % % set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    % % set(h,'BaseValue',0);
    % % hold on;
    % % hl2 = plot(TPD.daydate(ind),TPD.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    % % hl1 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);

    scatter(TPD.daydate,TPD.dayGEPdaymodel,10,'o','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl4 = plot(TPD.daydate,smoothdata(TPD.dayGEPdaymodel,'movmean',5),'-','Color',color_mtx_dark(2,:),'Linewidth',.5);

    % ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    % ax2.XAxis.MinorTick = 'on';
    % ax2.XAxis.MinorTickValues = TPD.month(1:12:end);  ax2.XAxis.MinorTickValues = TPD.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[ROITPD.daydate(ind(1)) TPD.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:12:end),'YColor','k');
    % ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    % text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl3,hl1],'model','observation'); legend box off;

    TPD.dayGEPdaymodelLeafAge = TPD.dayGEPdaymodel;
    RMSE2 = RMSE;    MAE2 = MAE;     Rsquared_2 = Rsquared;   MSRE2 = MSRE;

    % ........................................................................
    %% Chromatic index
    % ........................................................................
    %     % Initial guess: [Topt, Tmin, Tmax, alphaGCC, alphaRCC]
    params = [22, 0, 32, 1, 1];
    % Lower and upper bounds for parameters
    lb = [18, -5, 30, 0.01, 0.01];  % realistic lower bounds
    ub = [28, 8, 40, 6, 6];     % realistic upper bounds

    % From the GCC SGS to the EGS, it is the GCC that drives the photosyntesis model
    % during the growing season is the 1-RCC that does the job of
    % indicating how the vegetation phothosintetic capacity
    LagStart = 20;
    StartGrowing = days(GCC.BegTdate-TPD.daydate(1));%-LagStart;
    EndGrowing   = days(GCC.EndTdate-TPD.daydate(1));%+LagStart;

    % MaxGrowing   = days(RCC.MaxTdate-TPD.daydate(1)); %-LagStart7
    % StartGrowing = days(RCC.MaxTdate(1:2:end-1)-TPD.daydate(1))+LagStart;
    % EndGrowing   = days(RCC.MaxTdate(2:2:end)-TPD.daydate(1))-LagStart;

    counter = (1:1:(length(TPD.daydate)))';

    % opts = optimoptions('lsqnonlin', 'Display', 'iter', 'MaxIterations', 5000,...
    %     'MaxFunctionEvaluations', 10000, 'FunctionTolerance', 1e-10,...      % Tighter tolerance for higher R2
    % 'StepTolerance', 1e-10,'OptimalityTolerance', 1e-10, 'FiniteDifferenceType', 'central', ... % More accurate gradient estimation
    % 'UseParallel', true);

    ind = find((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgccQA))&(~isnan(TPD.ROIrccQA))&...
        (~isnan(TPD.daytairday))&(~isnan(TPD.dayPARday))&(TPD.dayGEPday>0)&...
        (isfinite(TPD.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPchromatic(params,counter(ind),...
        TPD.dayPARday(ind), TPD.daytairday(ind),TPD.ROIgccQA(ind), TPD.ROIrccQA(ind),....
        StartGrowing, EndGrowing, 1) - TPD.dayGEPday(ind)) .* (sqrt(abs(TPD.dayGEPday(ind))) + 0.25);

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('Topt: %.3f\nTmin: %.3f\nTmax: %.3f\nalphaGCC: %.3f\nalphaRCC: %.3f\n', best_params);

    % Display best-fit parameters
    TPDmodelParameter(3).parameters = best_params;

    [TPD.dayGEPdaymodel,TPD.dayGCCnorm,TPD.dayRCCnorm] = FN_computeGEPchromatic(best_params,counter,...
        TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, TPD.ROIrccQA,....
        StartGrowing, EndGrowing, 1);

    % Statistics
    valid = TPD.dayGEPday>0.1 & TPD.dayGEPdaymodel>0.1 & TPD.dayGEPday<maxGEPday &...
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    r = corr(TPD.dayGEPdaymodel(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    % yearSelect = 2019;
    % ind = find(TPD.dayY==yearSelect);
    % v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    % figure('color','white','Position',[50 50 600 400],'units','inches');
    % y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
    % h = area(TPD.daydate(ind),y);       set(gca,'Layer','top');
    % set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    % set(h,'BaseValue',0);
    % hold on;
    % hl2 = plot(TPD.daydate(ind),TPD.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    % hl1 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);

    scatter(TPD.daydate(ind),TPD.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl5 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(3,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = TPD.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    legend([hl3,hl4,hl5,hl1],'leaf seasons','leaf age', 'chromatic','observation'); legend box off;

    TPD.dayGEPdaymodelChromatic = TPD.dayGEPdaymodel;
    RMSE3 = RMSE;    MAE3 = MAE;     Rsquared_3 = Rsquared;   MSRE3 = MSRE;

    % .......................................................................
    %% SIGMOID
    % .......................................................................
    % Initial guess: [Topt, Tmin, Tmax, alpha_green]
    params = [22, 0, 32, 1];

    % Lower and upper bounds for parameters
    lb = [18, -5, 30, .01];  % realistic lower bounds
    ub = [28, 8, 40, 6];  % realistic upper bounds

    counter = (1:1:(length(TPD.daydate)))';

    % % opts = optimoptions('lsqnonlin', 'Display', 'iter', 'MaxIterations', 5000,...
    % %     'MaxFunctionEvaluations', 10000, 'FunctionTolerance', 1e-10,...      % Tighter tolerance for higher R2
    % % 'StepTolerance', 1e-10,'OptimalityTolerance', 1e-10, 'FiniteDifferenceType', 'central', ... % More accurate gradient estimation
    % % 'UseParallel', true);
    %
    % ind = find((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgccQA))&...
    %     (~isnan(TPD.daytairday))&(~isnan(TPD.dayPARday))&(TPD.dayGEPday>0)&...
    %     (isfinite(TPD.dayGEPday)));
    %
    % residualFunction = @(params) (FN_computeGEPsigmoidGCC(params,counter(ind),TPD.ROIgccQA(ind),...
    %     TPD.dayPARday(ind), TPD.daytairday(ind), 1) - TPD.dayGEPday(ind)) .* (sqrt(abs(TPD.dayGEPday(ind))) + 0.25);
    %
    ind = find((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgriviQA))&...
        (~isnan(TPD.daytairday))&(~isnan(TPD.dayPARday))&(TPD.dayGEPday>0)&...
        (isfinite(TPD.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPsigmoidGRIVI(params,counter(ind),TPD.ROIgriviQA(ind),...
        TPD.dayPARday(ind), TPD.daytairday(ind), 1) - TPD.dayGEPday(ind)) .* (sqrt(abs(TPD.dayGEPday(ind))) + 0.25);
    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('Topt: %.3f\nTmin: %.3f\nTmax: %.3f\nalpha: %.3f\n', best_params);

    % Display best-fit parameters
    TPDmodelParameter(4).parameters = best_params;

    % TPD.dayGEPdaymodel = FN_computeGEPsigmoidGCC(best_params,counter,TPD.ROIgccQA,...
    %     TPD.dayPARday, TPD.daytairday, 1);
    [TPD.dayGEPdaymodel,TPD.dayGRIVInorm] = FN_computeGEPsigmoidGRIVI(best_params,counter,TPD.ROIgriviQA,...
        TPD.dayPARday, TPD.daytairday, 1);

    TPD.dayGEPdaymodel(isnan(TPD.ROIgriviQA)) = NaN;   TPD.dayGEPdaymodel(TPD.dayGEPdaymodel==0) = NaN;

    % Statistics
    valid = TPD.dayGEPday>0.1 & TPD.dayGEPdaymodel>0.1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    r = corr(TPD.dayGEPdaymodel(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(TPD.daydate(ind),TPD.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(4,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl6 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(4,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';
    ax2.XAxis.MinorTickValues = TPD.month(1:12:end);  ax2.XAxis.MinorTickValues = TPD.month;
    set(ax2,'YTick',v3,'YLim',[v1 v2]);%,'XLim',[ROITPD.daydate TPD.daydate(ind(end))],...
    % 'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:12:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    % text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl3,hl1],'model','observation'); legend box off;
    % legend([hl1,hl2,hl3,hl4,hl5,hl6],'historical','obs','seasons','leaf age','chromatic','sigmoid')

    TPD.dayGEPdaymodelSigmoidGCC = TPD.dayGEPdaymodel;
    RMSE4 = RMSE;    MAE4 = MAE;     Rsquared_4 = Rsquared;   MSRE4 = MSRE;

    % .........................................................................
    %% Only GCC, no PAR, no Tair. Hockey stick
    % .....................................................................
    params = [3, 0.2];
    lb = [0.001, 0.00];  % Lowering beta to 0.0 allows no threshold
    ub = [500, 1];

    ind = find((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgccQA))&...
        (TPD.dayGEPday>-3)& (isfinite(TPD.dayGEPday))&...
        (TPD.ROIgccQA<prctile(TPD.ROIgccQA,97)));

    residualFunction = @(params) (FN_computeGEPhockeyGCC(params,counter(ind),...
        TPD.ROIgccQA(ind),1) - TPD.dayGEPday(ind)) .* (sqrt(abs(TPD.dayGEPday(ind))) + 0.25);

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('alphaGCC: %.3f\nwakeupGCC: %.3f\n', best_params);

    % Display best-fit parameters
    TPDmodelParameter(5).parameters = best_params;

    TPD.dayGEPdaymodel = FN_computeGEPhockeyGCC(best_params,counter,TPD.ROIgccQA,1);

    ind = find((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgccQA))&...
        (TPD.dayGEPday>-3)& (isfinite(TPD.dayGEPday)));

    % Statistics
    valid = TPD.dayGEPday>0.1 & TPD.dayGEPdaymodel>0.1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    r = corr(TPD.dayGEPdaymodel(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(TPD.daydate(ind),TPD.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(5,:),'MarkerEdgeColor',color_mtx_dark(5,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl7 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx(5,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = TPD.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    % legend([hl3,hl4,hl5,hl6,hl1],'leaf seasons','leaf age', 'chromatic','hockey','observation'); legend box off;

    TPD.dayGEPdaymodelHockey = TPD.dayGEPdaymodel;
    RMSE5 = RMSE;    MAE5 = MAE;     Rsquared_5 = Rsquared;   MSRE5 = MSRE;

    % ........................................................................
    %% GGC phenology as gatekeeper
    % ........................................................................
    % Linear relation between GEP v. GCC. Phenology modulated by temperature and PAR only after GCC threshold (a "wakeup" value)
    params = [prctile(TPD.dayGEPday, 97), 4.5, 0.5, 100, 22, 20];
    lb     = [prctile(TPD.dayGEPday, 95), 2, 0.1, 10, 18, 10];
    ub     = [max(TPD.dayGEPday,[],'omitnan'), 8, 1, 400, 28, 30];

    counter = (1:1:(length(TPD.daydate)))';

    ind = find((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgccQA))&...
        (~isnan(TPD.daytairday))&(~isnan(TPD.dayPARday))&(TPD.dayGEPday>0)&...
        (isfinite(TPD.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPgatekeeperGCCmeteo(params,counter(ind),...
        TPD.dayPARday(ind), TPD.daytairday(ind), TPD.ROIgccQA(ind),1)...
        - TPD.dayGEPday(ind));

    % tau = 0.75;
    % residualFunction = @(p) sqrt(abs(...
    %     FN_computeGEPgatekeeperGCC(p, counter(ind), ...
    %     TPD.daytairday(ind), TPD.dayPARday(ind), TPD.ROIgccQA(ind), 1) ...
    %     - TPD.dayGEPday(ind))) .* ...
    %     ( (TPD.dayGEPday(ind) > FN_computeGEPgatekeeperGCC(p, counter(ind), ...
    %     TPD.daytairday(ind), TPD.dayPARday(ind), TPD.ROIgccQA(ind), 1)) * tau + ...
    %     (TPD.dayGEPday(ind) <= FN_computeGEPgatekeeperGCC(p, counter(ind), ...
    %     TPD.daytairday(ind), TPD.dayPARday(ind), TPD.ROIgccQA(ind), 1)) * (1 - tau) );
    %
    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    fprintf('\nBest-fit parameters:\n');
    fprintf('GEP_{max}: %.3f\nSteeepness: %.3f\nSaturation: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    TPDmodelParameter(6).parameters = best_params;

    [TPD.dayGEPdaymodel,TPD.dayGCCnorm] = FN_computeGEPgatekeeperGCCmeteo(best_params, counter,...
        TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, 1);  %, TPD.dayLength

    % Statistics
    valid = TPD.dayGEPday>0.1 & TPD.dayGEPdaymodel>0.1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    r = corr(TPD.dayGEPdaymodel(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(TPD.daydate(ind),TPD.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(6,:),'MarkerEdgeColor',color_mtx_dark(6,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl8 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(6,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = TPD.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    legend([hl3,hl4,hl5,hl6,hl7,hl1],'leaf seasons','leaf age', 'chromatic','hockey','gatekeeper','observation'); legend box off;

    TPD.dayGEPdaymodelGate = TPD.dayGEPdaymodel;
    RMSE6 = RMSE;    MAE6 = MAE;     Rsquared_6 = Rsquared;   MSRE6 = MSRE;

    % ........................................................................
    %% GGC phenology as gatekeeper greenup & browndown segments
    % ........................................................................
    % Linear relation between GEP v. GCC. Phenology modulated by temperature and PAR only after GCC threshold (a "wakeup" value)
    params = [prctile(TPD.dayGEPday, 97), 4.5, 0.5,  4.5, 0.5, 100, 22, 20];
    lb     = [prctile(TPD.dayGEPday, 95), 2, 0.1, 2, 0.1, 10, 18, 10];
    ub     = [max(TPD.dayGEPday,[],'omitnan'), 8, 1, 8, 1, 400, 28, 30];

    counter = (1:1:(length(TPD.daydate)))';

    ind = find((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgccQA))&...
        (~isnan(TPD.daytairday))&(~isnan(TPD.dayPARday))&(TPD.dayGEPday>0)&...
        (isfinite(TPD.dayGEPday)));

    % tau = 0.75;
    % residualFunction = @(p) sqrt(abs(...
    %     1018(p, counter(ind), ...
    %     TPD.daytairday(ind), TPD.dayPARday(ind), TPD.ROIgccQA(ind), TPD.dayLength(ind), 1) ...
    %     - TPD.dayGEPday(ind))) .* ...
    %     ( (TPD.dayGEPday(ind) > FN_computeGEPgatekeeperGCCdaylength(p, counter(ind), ...
    %     TPD.daytairday(ind), TPD.dayPARday(ind), TPD.ROIgccQA(ind), TPD.dayLength(ind), 1)) * tau + ...
    %       (TPD.dayGEPday(ind) <= FN_computeGEPgatekeeperGCCdaylength(p, counter(ind), ...
    %     TPD.daytairday(ind), TPD.dayPARday(ind), TPD.ROIgccQA(ind), TPD.dayLength(ind),1)) * (1 - tau) );
    %
    % residualFunction = @(params) (FN_computeGEPgatekeeperGCCdaylength(params,counter(ind),...
    %     TPD.dayPARday(ind), TPD.daytairday(ind), TPD.ROIgccQA(ind), TPD.dayLength(ind), 1)...
    %     - TPD.dayGEPday(ind));
    residualFunction = @(params) (FN_computeGEPphotosynthesisGCCgn2br(params,counter(ind),...
        TPD.dayPARday(ind), TPD.daytairday(ind),TPD.ROIgccQA(ind), 1)...
        - TPD.dayGEPday(ind));

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    % fprintf('GEP_{max}: %.3f\nSteeepness: %.3f\nSaturation: %.3f\n', best_params);
    fprintf('GEP_{max}: %.3f\nSteeep1: %.3f\nSat1: %.3f\nSteeep2: %.3f\nSat2: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    TPDmodelParameter(7).parameters = best_params;

    % [TPD.dayGEPdaymodel] = FN_computeGEPgatekeeperGCCdaylength(best_params,counter,...
    %     TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, TPD.dayLength, 1);  %, TPD.dayLength
    [TPD.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params,counter,...
        TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, 1);

    % Statistics
    valid = TPD.dayGEPday>0.1 & TPD.dayGEPdaymodel>0.1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    r = corr(TPD.dayGEPdaymodel(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(TPD.daydate(ind),TPD.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(7,:),'MarkerEdgeColor',color_mtx_dark(7,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl9 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(7,:),'Linewidth',.5);
    % plot(TPD.daydate,TPD.dayLength*2,'-','Color','r','Linewidth',2);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = TPD.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',TPD.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    legend([hl3,hl4,hl5,hl6,hl7,hl8,hl9,hl1],'leaf seasons','leaf age', 'chromatic', 'sigmoid','hockey','gatekeeper','gatekeeper+gr&bw','observation'); legend box off;

    TPD.dayGEPdaymodelGateGnBw = TPD.dayGEPdaymodel;
    RMSE7 = RMSE;    MAE7 = MAE;     Rsquared_7 = Rsquared;   MSRE7 = MSRE;

    % ........................................................................
    %% Compare models
    % ........................................................................
    % Create arrays of results
    ModelNames = {'Model 1 (Leaf Stage GCC)'; ...
        'Model 2 (Leaf Age GCC)'; ...
        'Model 3 (Chromatic GCC+RCC)';...
        'Model 4 (Sigmoid)';...
        'Model 5 (Hockey)';...
        'Model 6 (Gate)';...
        'Model 7 (Gate+gn&bw)'};

    RMSE_values     = [RMSE1; RMSE2; RMSE3; RMSE4; RMSE5; RMSE6; RMSE7];
    MAE_values      = [MAE1; MAE2; MAE3; MAE4; MAE5; MAE6; MAE7];
    Rsquared_values = [Rsquared_1; Rsquared_2; Rsquared_3; Rsquared_4; Rsquared_5; Rsquared_6; Rsquared_7];
    MSRE_values     = [MSRE1; MSRE2; MSRE3; MSRE4; MSRE5; MSRE6; MSRE7];

    % Table
    ComparisonTable = table(ModelNames, RMSE_values, MAE_values, Rsquared_values, MSRE_values, ...
        'VariableNames', {'Model', 'RMSE', 'MAE', 'R_Squared', 'MSRE'});
    save ('modelResultsTPD.mat','ComparisonTable','-append')

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

    % Optional: Plot the results of the best model for visualization
    clear hl11 hl12 hl13 hl14 hl15 hl16
    fittypesArray = 2;
    y1=0;     y2=35;    y3 = (y1:(y2-y1)/4:y2)';  y4 = (y1:(y2-y1)/15:y2)';
    x1=0;     x2=35;    x3 = (x1:(x2-x1)/4:x2)';  x4 = (x1:(x2-x1)/15:x2)';
    figure('color','white','Position',[150 150 450 400]);   hold on;
    count = 1;
    plot(y4,y4,':k')
    scatter(TPD.dayGEPday,TPD.dayGEPdaymodelLeafStage,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    % Find x values for plotting the fit based on xlim
    x0 = linspace(min(TPD.dayGEPday,[],'omitnan'), max(TPD.dayGEPday,[],'omitnan'));
    valid = TPD.dayGEPday>1  & TPD.dayGEPdaymodelLeafStage>1 & TPD.dayGEPday<maxGEPday &...
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodelLeafStage);
    % check1 = TPD.dayGEPday > 10 & TPD.dayGEPdaymodelLeafAge < 1;
    fitResults = polyfit(TPD.dayGEPday(valid),TPD.dayGEPdaymodelLeafStage(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    text(x4(1),y4(end-count),['GEP_{leaf stage} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])
    [ix,iy] = AM_class_eq_size(TPD.dayGEPday(valid),TPD.dayGEPdaymodelLeafStage(valid),15);
    % [ix,iy] = AM_bin_noplot(TPD.dayGEPday(valid),TPD.dayGEPdaymodelLeafStage(valid),15,5);
    hl11 = scatter(ix(:,2),iy,50,'s','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    % fitResults = polyfit(ix(:,2),iy,fittypesArray-1);
    % iy = polyval(fitResults,ix);
    % plot(iy,iy,'-','Color',color_mtx(count,:));
    % text(x4(3),y4(end-2*count),['GEP_{leaf stage} = ', num2str(fitResults(1)),'GEP_{obs}+',num2str(fitResults(2))])

    count = 2;
    scatter(TPD.dayGEPday,TPD.dayGEPdaymodelLeafAge,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = TPD.dayGEPday > 1  & TPD.dayGEPdaymodelLeafAge>1 & TPD.dayGEPday<maxGEPday &...
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodelLeafAge);
    % check2 = TPD.dayGEPday > 10 & TPD.dayGEPdaymodelLeafAge < 1;
    fitResults = polyfit(TPD.dayGEPday(valid),TPD.dayGEPdaymodelLeafAge(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(TPD.dayGEPday(valid),TPD.dayGEPdaymodelLeafAge(valid),15);
    % [ix,iy] = AM_bin_noplot(TPD.dayGEPday(valid),TPD.dayGEPdaymodelLeafAge(valid),15,5);
    hl12 = scatter(ix(:,2),iy,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{leaf age} = ', num2str(fitResults(1),'%.2f'),' GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 3;
    scatter(TPD.dayGEPday,TPD.dayGEPdaymodelChromatic,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = TPD.dayGEPday>1  & TPD.dayGEPdaymodelChromatic>1 & TPD.dayGEPday<maxGEPday &...
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodelChromatic);
    % check3 = TPD.dayGEPday > 10 & TPD.dayGEPdaymodelChromatic < 1;
    fitResults = polyfit(TPD.dayGEPday(valid),TPD.dayGEPdaymodelChromatic(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(TPD.dayGEPday(valid),TPD.dayGEPdaymodelChromatic(valid),15);
    % [ix,iy] = AM_bin_noplot(TPD.dayGEPday(valid),TPD.dayGEPdaymodelChromatic(valid),15,5);
    hl13 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{chromatic} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 4;
    scatter(TPD.dayGEPday,TPD.dayGEPdaymodelSigmoidGCC,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = TPD.dayGEPday>1 & TPD.dayGEPdaymodelSigmoidGCC>1 & TPD.dayGEPday<maxGEPday &...
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodelSigmoidGCC);
    % check4 = TPD.dayGEPday > 10 & TPD.dayGEPdaymodelLeafAge < 1;
    fitResults = polyfit(TPD.dayGEPday(valid),TPD.dayGEPdaymodelSigmoidGCC(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(TPD.dayGEPday(valid),TPD.dayGEPdaymodelSigmoidGCC(valid),15);
    % [ix,iy] = AM_bin_noplot(TPD.dayGEPday(valid),TPD.dayGEPdaymodelSigmoidGCC(valid),15,5);
    hl14 = scatter(ix(:,2),iy,50,'^','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{sigmoid} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 5;
    scatter(TPD.dayGEPday,TPD.dayGEPdaymodelHockey,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = TPD.dayGEPday>1  & TPD.dayGEPdaymodelHockey>1 & TPD.dayGEPday<maxGEPday &...
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodelHockey);
    % check3 = TPD.dayGEPday > 10 & TPD.dayGEPdaymodelHockey < 1;
    fitResults = polyfit(TPD.dayGEPday(valid),TPD.dayGEPdaymodelHockey(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(TPD.dayGEPday(valid),TPD.dayGEPdaymodelHockey(valid),15);
    % [ix,iy] = AM_bin_noplot(TPD.dayGEPday(valid),TPD.dayGEPdaymodelHockey(valid),15,5);
    hl15 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{hockey} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 6;
    scatter(TPD.dayGEPday,TPD.dayGEPdaymodelGate,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = TPD.dayGEPday>1  & TPD.dayGEPdaymodelGate>1 & TPD.dayGEPday<maxGEPday &...
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodelGate);
    % check3 = TPD.dayGEPday > 10 & TPD.dayGEPdaymodelGate < 1;
    fitResults = polyfit(TPD.dayGEPday(valid),TPD.dayGEPdaymodelGate(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(TPD.dayGEPday(valid),TPD.dayGEPdaymodelGate(valid),15);
    % [ix,iy] = AM_bin_noplot(TPD.dayGEPday(valid),TPD.dayGEPdaymodelGate(valid),15,5);
    hl16 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{gate} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 7;
    scatter(TPD.dayGEPday,TPD.dayGEPdaymodelGateGnBw,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = TPD.dayGEPday>1  & TPD.dayGEPdaymodelGateGnBw>1 & TPD.dayGEPday<maxGEPday &...
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodelGateGnBw);
    % check3 = TPD.dayGEPday > 10 & TPD.dayGEPdaymodelGate < 1;
    fitResults = polyfit(TPD.dayGEPday(valid),TPD.dayGEPdaymodelGateGnBw(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(TPD.dayGEPday(valid),TPD.dayGEPdaymodelGateGnBw(valid),15);
    % [ix,iy] = AM_bin_noplot(TPD.dayGEPday(valid),TPD.dayGEPdaymodelGate(valid),15,5);
    hl17 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{gate+gn&bw} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

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
    y = [TPD.day_recurrentGEPday-TPD.day_recurrent_stdGEPday,2.*TPD.day_recurrent_stdGEPday];
    h = area(TPD.daydate,y);       set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    % set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
    hold on;
    hl2 = plot(TPD.daydate,TPD.day_recurrentGEPdayGoley,'-','LineWidth',1,'color',[0.5 0.5 0.5]); hold on;
    % hl3 = plot(TPD.daydate,TPD.dayGEPday,'-','LineWidth',1,'color',[0.3 0.3 0.3 ]); hold on;
    hl4 = scatter(TPD.daydate,smoothdata(TPD.dayGEPday,'movmean',1),10,'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.3 0.3 0.3],...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl6 = scatter(TPD.daydate,TPD.dayGEPdaymodelLeafStage,10,'MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    % hl5 = scatter(TPD.daydate(check),TPD.dayGEPdaymodelLeafStage(check),20,'MarkerFaceColor','r',...
    %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
    ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month(1:2:end);
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[ROI.daydate(1) TPD.daydate(end)],...
        'FontSize',12,'XMinorGrid','on','XTick',TPD.month(1:12:end));    %'XTickLabelColor',[0. 0. 0.7 ]
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',14);   xtickangle(0);   box on;   grid on;
    legend([hl2,hl4,hl6],'historical','obs','Leaf Stage')

    v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    figure('color','white','Position',[50 50 1600 400],'units','inches');
    y = [TPD.day_recurrentGEPday-TPD.day_recurrent_stdGEPday,2.*TPD.day_recurrent_stdGEPday];
    h = area(TPD.daydate,y);       set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    % set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
    hold on;
    hl2 = plot(TPD.daydate,TPD.day_recurrentGEPdayGoley,'-','LineWidth',1,'color',[0.5 0.5 0.5]); hold on;
    % hl3 = plot(TPD.daydate,TPD.dayGEPday,'-','LineWidth',1,'color',[0.3 0.3 0.3 ]); hold on;
    hl4 = scatter(TPD.daydate,smoothdata(TPD.dayGEPday,'movmean',1),10,'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.3 0.3 0.3],...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl6 = scatter(TPD.daydate,TPD.dayGEPdaymodelLeafAge,10,'MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    % hl3 = plot(TPD.daydate,TPD.dayGEPdaymodelLeafAge,'-','LineWidth',.5,'color',color_mtx(2,:)); hold on;
    hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
    ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month(1:2:end);
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[ROI.daydate(1) TPD.daydate(end)],...
        'FontSize',12,'XMinorGrid','on','XTick',TPD.month(1:12:end));    %'XTickLabelColor',[0. 0. 0.7 ]
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',14);   xtickangle(0);   box on;   grid on;
    legend([hl2,hl4,hl6],'historical','obs','Leaf Age')

    v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    figure('color','white','Position',[50 50 1600 400],'units','inches');
    y = [TPD.day_recurrentGEPday-TPD.day_recurrent_stdGEPday,2.*TPD.day_recurrent_stdGEPday];
    h = area(TPD.daydate,y);       set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    % set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
    hold on;
    hl2 = plot(TPD.daydate,TPD.day_recurrentGEPdayGoley,'-','LineWidth',1,'color',[0.5 0.5 0.5]); hold on;
    % hl3 = plot(TPD.daydate,TPD.dayGEPday,'-','LineWidth',1,'color',[0.3 0.3 0.3 ]); hold on;
    hl4 = scatter(TPD.daydate,smoothdata(TPD.dayGEPday,'movmean',1),10,'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.3 0.3 0.3],...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl5 = scatter(TPD.daydate,TPD.dayGEPdaymodelChromatic,10,'MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl6 = scatter(TPD.daydate,TPD.dayGEPdaymodelSigmoidGCC,10,'MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(4,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
    ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month(1:2:end);
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[ROI.daydate(1) TPD.daydate(end)],...
        'FontSize',12,'XMinorGrid','on','XTick',TPD.month(1:12:end));    %'XTickLabelColor',[0. 0. 0.7 ]
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',14);   xtickangle(0);   box on;   grid on;
    % legend([hl2,hl4,hl6],'historical','obs','Chromatic')

end
% close all

% .........................................................................
%% test
% .........................................................................
% % % trains the model on all years except one -iterates, and saves the parameters.
% % % looks at how the temperature and other parameters shift depending on which year is excluded.
if flag_model_test_chromatic == 1
    [TPD.daydateY,TPD.daydateM,TPD.daydateD] = datevec(TPD.daydate);
    TPD.years = unique(TPD.daydateY);
    modelResultsChromatic = struct();
    windowSmooth = 11;

    % Final QA for indices
    iy = TPD.ROIgcc;
    TPD.ROIgccQA = iy;            %TPD.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(TPD.ROIgccQA,3);
    TPD.ROIgccQA = FN_fillVI(TPD.daydate,iy);

    iy = TPD.ROIrcc;
    iy(TPD.ROIrcc<0.35) = NaN;   %TPD.ROIrcc(TPD.daydate>datetime(2021,12,31)) = NaN;
    % iy(indCamera) = NaN;
    % ind = find(~isnan(iy));       ix = detrend(iy(ind))+mean(iy,'omitnan');
    TPD.ROIrccQA = iy;            %TPD.ROIrccQA(ind) = ix;
    [~,TPD.ROIrccQA] = AM_spike_detection(TPD.ROIrccQA,3);
    iy = smoothdata(TPD.ROIrccQA,'movmean',windowSmooth);
    % TPD.ROIrccQA(TPD.daydate>=datetime(2023,1,1)) = NaN;
    TPD.ROIrccQA = FN_fillVI(TPD.daydate,iy);

    for ix = 1:length(TPD.years)
        currentYear = TPD.years(ix); display(currentYear);
        if flag_chromaticFixMeteo == 0
            params = [22, 0, 32, 1, 1];
            lb = [18, -5, 30, 0.01, 0.01];
            ub = [28, 8, 40, 6, 6];
        else
            params = [19, -5, 32, 1, 1];
            lb = [18, -5.01, 38.99, 0.01, 0.01];  % realistic lower bounds
            ub = [28, -4.99, 39.01, 6, 6];         % realistic upper bounds
        end

        StartGrowing = days(GCC.BegTdate-TPD.daydate(1));
        EndGrowing   = days(GCC.EndTdate-TPD.daydate(1));
        counter = (1:1:(length(TPD.daydate)))';

        commonFilters = isfinite(TPD.dayGEPday) & ...
            isfinite(TPD.ROIgccQA) & isfinite(TPD.ROIrccQA) & ...
            isfinite(TPD.daytairday) & isfinite(TPD.dayPARday) & (~isnan(TPD.dayGEPday)) & ...
            (TPD.dayPARday > 0) & (TPD.dayGEPday > 0);

        indTrain = find((TPD.daydateY ~= currentYear) & commonFilters);
        indTest  = find((TPD.daydateY == currentYear) & commonFilters);

        % Optimization
        if length(indTrain)>100 && length(indTest)>100
            foldObj = @(p) (FN_computeGEPchromatic(p, counter(indTrain), ...
                TPD.dayPARday(indTrain), TPD.daytairday(indTrain), TPD.ROIgccQA(indTrain), ...
                TPD.ROIrccQA(indTrain), StartGrowing, EndGrowing, 1) - TPD.dayGEPday(indTrain)) .* ...
                (sqrt(abs(TPD.dayGEPday(indTrain))) + 0.25);

            [best_params, ~, res_fold, ~, ~, ~, J_fold] = lsqnonlin(foldObj, params, lb, ub, opts);
            % to convert the jacobian here to avoid crash
            J_dense = full(J_fold);

            % Evaluation
            gepPredTest = FN_computeGEPchromatic(best_params, counter(indTest), ...
                TPD.dayPARday(indTest), TPD.daytairday(indTest), TPD.ROIgccQA(indTest), ...
                TPD.ROIrccQA(indTest), StartGrowing, EndGrowing, 1);

            SGStest = StartGrowing(year(GCC.BegTdate) == currentYear);
            SGStest(isnan(SGStest)) = days(datetime(currentYear,1,1)-TPD.daydate(1));
            EGStest = EndGrowing(year(GCC.EndTdate) == currentYear);
            EGStest(isnan(EGStest)) = days(datetime(currentYear,12,31)-TPD.daydate(1));

            % Calculate Prediction Uncertainty (Margin)
            % ci gives parameter bounds; we use nlpredci for prediction bounds
            [~, delta] = nlpredci(@(p, x) FN_computeGEPchromatic(p, counter(indTest), ...
                TPD.dayPARday(indTest), TPD.daytairday(indTest), TPD.ROIgccQA(indTest), ...
                TPD.ROIrccQA(indTest), SGStest, EGStest, 1), ...
                counter(indTest), best_params, res_fold, 'jacobian', J_dense);

            % Calculate 95% Confidence Intervals for the parameters
            % p_ci will be a 5x2 matrix: [lower_bound, upper_bound] for each of your 5 parameters
            p_ci = nlparci(best_params, res_fold, 'jacobian', J_dense);

            % Calculate the 'margin' or standard error for each parameter
            p_error = (p_ci(:,2) - p_ci(:,1)) / 2;

            % Store Results
            modelResultsChromatic(ix).year = currentYear;
            modelResultsChromatic(ix).obs  = TPD.dayGEPday(indTest);
            modelResultsChromatic(ix).pred = gepPredTest;
            modelResultsChromatic(ix).delta = delta; % This is your CI 'margin'
            modelResultsChromatic(ix).x = counter(indTest);
            modelResultsChromatic(ix).testRMSE = sqrt(mean((gepPredTest - TPD.dayGEPday(indTest)).^2));
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

        fill([xDate; flipud(xDate)], [yModel + margin; flipud(yModel - margin)], ...
            [0.85 0.85 0.85], 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        hold on;
        plot(xDate, yObs, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'k');
        scatter(xDate, yModel, 8, 'MarkerFaceColor', color_mtx(2,:), 'MarkerFaceAlpha', 0.5);
        % plot(1:365, TPD.dayGCCnorm(TPD.dayY==TPD.years(numYears)).*25, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'g');
        plot(1:365, TPD.dayRCCnorm(TPD.dayY==TPD.years(numYears)).*25, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'g');
        % plot(1:365, (TPD.daytairday(TPD.dayY==TPD.years(numYears))./2), 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'g');
        % plot(1:365, (TPD.dayPARday(TPD.dayY==TPD.years(numYears))./35), 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'g');

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

        if ix == 1, legend('95% CI', 'Observed', 'Predicted', 'Location', 'best'); end
    end

    %% Collect all results into two long vectors
    all_obs = cell2mat({modelResultsChromatic.obs}');                 all_pred = cell2mat({modelResultsChromatic.pred}');
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
    title(sprintf('TPD LOYO Validation (R^2 = %.2f, RMSE = %.2f)', ...
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
    [TPD.dayGEPdaymodelChromaticLOYO] = FN_computeGEPchromatic(avg_p_val,counter,...
        TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, TPD.ROIrccQA, StartGrowing, EndGrowing, 1);
    valid = TPD.dayGEPday>1 & TPD.dayGEPdaymodelChromaticLOYO>1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodelChromaticLOYO);
    r = corr(TPD.dayGEPdaymodelChromaticLOYO(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodelChromaticLOYO(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodelChromaticLOYO(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodelChromaticLOYO(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodelChromaticLOYO(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    save ('modelResultsTPD.mat','modelResultsChromatic','-append')
end

% ........................................................................
%% Gatekeeper
% ........................................................................
if flag_model_test_gatekeeper == 1
    [TPD.daydateY,TPD.daydateM,TPD.daydateD] = datevec(TPD.daydate);
    TPD.years = unique(TPD.daydateY);
    modelResults = struct();

    % Final QA for indices
    iy = TPD.ROIgcc;
    % % iy(TPD.ROIgcc<0.35) = NaN;   % TPD.ROIrcc(TPD.daydate>datetime(2021,12,31)) = NaN;
    TPD.ROIgccQA = iy;               % TPD.ROIrccQA(ind) = ix;    TPD.ROIgccQA = iy;            %TPD.ROIgccQA(ind) = ix;
    [~,TPD.ROIgccQA] = AM_spike_detection(TPD.ROIgccQA,3);
    % TPD.ROIgccQA = FN_fillVI(TPD.daydate,iy);

    for ix = 1:length(TPD.years)
        currentYear = TPD.years(ix); display(currentYear);
        % if currentYear==2018;   currentYear = currentYear+1;   ix = ix+1;  end
        if flag_gatewayFixMeteo == 0
            params = [prctile(TPD.dayGEPday, 97), 4.5, 0.5,  4.5, 0.5, 100, 20, 20];
            lb     = [prctile(TPD.dayGEPday, 95), 2, 0.1, 2, 0.1, 10, 15, 10];
            ub     = [max(TPD.dayGEPday,[],'omitnan'), 8, 1, 8, 1, 400, 25, 30];
        else
            % Here I am just "fixing" the parameters similar to the FN_computeGEPgatekeeperGCC
            params = [prctile(TPD.dayGEPday, 97), 4.5, 0.5,  4.5, 0.5, 273, 25, 18];
            lb     = [prctile(TPD.dayGEPday, 95), 2, 0.1, 2, 0.1, 272.99, 24.99, 17.99];
            ub     = [max(TPD.dayGEPday,[],'omitnan'), 8, 1, 8, 1, 273.01, 25.01, 18.01];
        end
        commonFilters = ((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgccQA))&...
            (~isnan(TPD.daytairday))&(~isnan(TPD.dayPARday))&(TPD.dayGEPday>0)&...
            (isfinite(TPD.dayGEPday)));

        indTrain = find((TPD.daydateY ~= currentYear) & commonFilters);
        indTest  = find((TPD.daydateY == currentYear) & commonFilters);

        % Optimization
        if length(indTrain)>100 && length(indTest)>100
            foldObj = @(p) (FN_computeGEPphotosynthesisGCCgn2br(p, counter(indTrain), ...
                TPD.dayPARday(indTrain),TPD.daytairday(indTrain),...
                TPD.ROIgccQA(indTrain),1) - TPD.dayGEPday(indTrain));

            [best_params, ~, res_fold, ~, ~, ~, J_fold] = lsqnonlin(foldObj, params, lb, ub, opts);
            % to convert the jacobian here to avoid crash
            J_dense = full(J_fold);

            % Evaluation
            gepPredTest = FN_computeGEPphotosynthesisGCCgn2br(best_params, counter(indTest), ...
                TPD.dayPARday(indTest),TPD.daytairday(indTest),TPD.ROIgccQA(indTest),1);

            SGStest = StartGrowing(year(GCC.BegTdate) == currentYear);
            SGStest(isnan(SGStest)) = days(datetime(currentYear,1,1)-TPD.daydate(1));
            EGStest = EndGrowing(year(GCC.EndTdate) == currentYear);
            EGStest(isnan(EGStest)) = days(datetime(currentYear,12,31)-TPD.daydate(1));
            % Calculate Prediction Uncertainty (Margin)
            % ci gives parameter bounds; we use nlpredci for prediction bounds
            [~, delta] = nlpredci(@(p, x) FN_computeGEPphotosynthesisGCCgn2br(p, counter(indTest), ...
                TPD.dayPARday(indTest), TPD.daytairday(indTest), TPD.ROIgccQA(indTest),1), ...
                counter(indTest), best_params, res_fold, 'jacobian', J_dense);

            % Calculate 95% Confidence Intervals for the parameters
            % p_ci will be a 5x2 matrix: [lower_bound, upper_bound] for each of your 5 parameters
            p_ci = nlparci(best_params, res_fold, 'jacobian', J_dense);

            % Calculate the 'margin' or standard error for each parameter
            p_error = (p_ci(:,2) - p_ci(:,1)) / 2;

            % Store Results
            modelResults(ix).year = currentYear;
            modelResults(ix).obs  = TPD.dayGEPday(indTest);
            modelResults(ix).pred = gepPredTest;
            modelResults(ix).delta = delta; % This is your CI 'margin'
            modelResults(ix).x = counter(indTest);
            modelResults(ix).testRMSE = sqrt(mean((gepPredTest - TPD.dayGEPday(indTest)).^2));
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

        yModel = modelResults(ix).pred;    yObs  = modelResults(ix).obs;
        margin = modelResults(ix).delta;

        fill([xDate; flipud(xDate)], [yModel + margin; flipud(yModel - margin)], ...
            [0.85 0.85 0.85], 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        hold on;
        plot(xDate, yObs, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'k');
        scatter(xDate, yModel, 8, 'MarkerFaceColor', color_mtx(1,:), 'MarkerFaceAlpha', 0.5);

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

        if ix == 1, legend('95% CI', 'Observed', 'Predicted', 'Location', 'best'); end
    end

    %% Collect all results into two long vectors
    all_obs = cell2mat({modelResults.obs}');  all_pred = cell2mat({modelResults.pred}');
    color_jet = flipud(jet(numYears)); rand_idx = randperm(numYears); color_jet = color_jet(rand_idx, :);
    x1 = 0;   x2 = 25;   x3 = (x1:(x2-x1)/4:x2)';

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
        scatter(1,x2-ix.*1.2+12,15,'MarkerFaceColor',color_jet(ix,:),'MarkerEdgeColor','none','MarkerFaceAlpha', 0.5);
        text(2,x2-ix.*1.2+12,sprintf('%.0f, R^2: %.2f, RMSE: %.2f', ...
            modelResults(ix).year, mdl.Rsquared.Ordinary, sqrt(mean((yObs-yModel).^2))));
    end

    plot([x1 x2], [x1 x2], 'k', 'LineWidth', 1);

    % Calculate Global Stats
    mdl = fitlm(all_obs, all_pred);
    text(2,x2-1,sprintf('TPD LOYO Validation (R^2 = %.2f, RMSE = %.2f)', ...
        mdl.Rsquared.Ordinary, sqrt(mean((all_obs-all_pred).^2))),'fontsize',10);

    xlabel('Observed GEP','FontSize',14);   ylabel('Predicted GEP','FontSize',14);
    grid on;               box on;          axis([x1 x2 x1 x2]);
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
    [TPD.dayGEPdaymodelGateLOYO] = FN_computeGEPphotosynthesisGCCgn2br(avg_p_val,counter,...
        TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, 1);
    valid = TPD.dayGEPday>1 & TPD.dayGEPdaymodelGateLOYO>1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodelGateLOYO);
    r = corr(TPD.dayGEPdaymodelGateLOYO(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodelGateLOYO(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodelGateLOYO(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodelGateLOYO(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodelGateLOYO(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    save ('modelResultsTPD.mat','modelResults','-append')
    save ('TPD.mat','TPD','-append')
end

% .........................................................................
%% visualize
% .........................................................................
if flag_visualize == 1
    [TPD.weekROIgccQA] = AM_week2day_rs(TPD.ROIgccQA,TPD.daydate);
    [TPD.eightROIgccQA] = AM_eightday_rs(TPD.ROIgccQA,TPD.daydate);
    figure;
    plot(TPD.weekROIgccQA,TPD.weekGEPday,'-');
    plot(TPD.weekROIgccQA,TPD.weekGEPday,'.');
    hold on; plot(TPD.weekROIgccQA(TPD.weekM<7),TPD.weekGEPday(TPD.weekM<7),'.r');
    hold on; plot(TPD.weekROIgccQA(TPD.weekY==2013),TPD.weekGEPday(TPD.weekY==2013),'-g');
    hold on; plot(TPD.weekROIgccQA(TPD.weekY==2016),TPD.weekGEPday(TPD.weekY==2016),'-k');

    % Hockey stick
    idx = ~isnan(TPD.eightROIgccQA) & ~isnan(TPD.eightGEPday);
    x_data = TPD.eightROIgccQA(idx);
    y_data = TPD.eightGEPday(idx);
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
    x_plot = linspace(0.20, max(x_data), 100);    y_plot = model(params, x_plot);
    plot(x_plot, y_plot, 'r', 'LineWidth', 2.5);
    xline(threshold_opt, '--', ['Threshold: ' num2str(threshold_opt, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .8]);
    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(min(TPD.eightROIgccQA,[],'omitnan'),15,site_name,'FontSize',16)

    %%
    % gatekeeper
    color_mtx = jet(12);
    TPD.eightGCCnorm = AM_eightday_rs(TPD.dayGCCnorm,TPD.daydate);
    % idx = ~isnan(TPD.eightGCCnorm) & ~isnan(TPD.eightGEPday);
    % x_data = TPD.eightGCCnorm(idx);
    % y_data = TPD.eightGEPday(idx);
    idx = ~isnan(TPD.dayGCCnorm) & ~isnan(TPD.dayGEPday);
    x_data = TPD.dayGCCnorm(idx);
    y_data = TPD.dayGEPday(idx);
    z_data = TPD.dayM(idx);

    x0 = TPDmodelParameter(6).parameters(3);

    fLight= 1;
    fTemp = 1;
    x_plot = linspace(0, 1, 200)';  iy = (1:200)';
    y_plot = FN_computeGEPgatekeeperGCCmeteo(TPDmodelParameter(6).parameters,iy,...
        (iy.*0+1300),(iy.*0+TPDmodelParameter(6).parameters(5)),...
        x_plot, 1);  %(iy.*0)+14,

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
    text(0.8,33,site_name,'FontSize',16,'Color','k')
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 35]);
    set(gca, 'FontSize', 14);
    % legend('Location', 'northwest'); legend boxoff;

    %%
    z_data = round(TPD.dayLength(idx));
    color_mtx = jet(length(unique(z_data))+1);
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    count = 1;
    for ix=(min(z_data)):round(max(z_data))
        ind = find(z_data==ix);
        scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        text(-0.05,35-ix.*1.5,['Day length: ' num2str(ix)]);
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

    z_data = round(TPD.daySZA(idx));
    color_mtx = jet(length(unique(z_data)));
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    count = 1;
    for ix=((min(z_data)):(max(z_data)))
        ind = find(z_data==ix);
        scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        text(-0.02,35-count,[ num2str(ix)],'FontSize',9);
        plot(-0.05,35-count,'o','MarkerFaceColor',color_mtx(count,:),...
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

    %% Two sigmoids
    z_data = round(TPD.dayM(idx));
    color_mtx = jet(length(unique(z_data))+1);
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    count = 1;
    for ix=(min(z_data)):round(max(z_data))
        ind = find(z_data==ix);
        scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        text(0.1,35-ix.*1.5,[ datestr(datetime(1,ix,1),'mmm')]);
        plot(0.05,35-ix.*1.5,'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:));
        count = count+1;
    end
    best_params = [TPDmodelParameter(7).parameters(1:3),TPDmodelParameter(7).parameters(6:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1300),...
        (iy.*0+TPDmodelParameter(7).parameters(7)),x_plot,1);
    x0 = TPDmodelParameter(7).parameters(3);
    plot(x_plot, y_plot, 'color',[0 0 0] ,'LineWidth', 2.5);
    xline(x0,'--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .0]);
    hold on;

    best_params = [TPDmodelParameter(7).parameters(1),TPDmodelParameter(7).parameters(4:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1300),...
        (iy.*0+TPDmodelParameter(7).parameters(7)),x_plot,1);
    x0 = TPDmodelParameter(7).parameters(5);
    plot(x_plot, y_plot, 'color',[0.5 0.5 .5], 'LineWidth', 2.5);
    xline(x0, '--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0.5 0.5 .5]);

    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(0.8,30,site_name,'FontSize',16)
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 35]);
    set(gca, 'FontSize', 14);

    % test_output = residualFunction(params);
    % bad_idx = find(~isfinite(test_output));
    % fprintf('There are %d non-finite values.\n', length(bad_idx));
    % disp('First few bad values are at indices:');

        %% Two sigmoids month
    z_data = round(TPD.dayM(idx));
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
    best_params = [TPDmodelParameter(7).parameters(1:3),TPDmodelParameter(7).parameters(6:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1000),...
        (iy.*0+TPDmodelParameter(7).parameters(7)),x_plot,1);
    x0 = TPDmodelParameter(7).parameters(3);
    plot(x_plot, y_plot, 'color',[0 0 0] ,'LineWidth', 2.5);
    xline(x0,'--', ['X_0 threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .0]);
    text(x_plot(100)+.05, y_plot(100),'green-up','Color','k','FontSize',10);
    hold on;

    best_params = [TPDmodelParameter(7).parameters(1),TPDmodelParameter(7).parameters(4:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1000),...
        (iy.*0+TPDmodelParameter(7).parameters(7)),x_plot,1);
    x0 = TPDmodelParameter(7).parameters(5);
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
    idx = ~isnan(TPD.dayGCCnorm) & ~isnan(TPD.dayNEEday);
    x_data = TPD.dayGCCnorm(idx);
    y_data = -TPD.dayNEEday(idx);
    z_data = round(TPD.dayM(idx));
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
    xlim([-0.1 1.1]); ylim([-5 15]);
    set(gca, 'FontSize', 14);

end

% .........................................................................
%% using fixed deciduous parameters
% .........................................................................
if flag_chromaticFixMeteo == 1
    params = [20.0,	-5.0,	39.7,	0.039,	0.025];
    StartGrowing = days(GCC.BegTdate-TPD.daydate(1));
    EndGrowing   = days(GCC.EndTdate-TPD.daydate(1));
    counter = (1:1:(length(TPD.daydate)))';
    gepPredTest = FN_computeGEPchromatic(params, counter, ...
        TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, ...
        TPD.ROIrccQA, StartGrowing, EndGrowing, 1);
    valid = TPD.dayGEPday>1 & gepPredTest>1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(gepPredTest);
    r = corr(gepPredTest(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((gepPredTest(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - gepPredTest(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - gepPredTest(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),gepPredTest(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nstats chromatic fixed [final] parameters:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);
end

if  flag_gatewayFixMeteo == 1
    params = [26.5,	2.252,	0.757,	5.068,	0.356,	249,	24.4,	15.5];
    gepPredTest = FN_computeGEPphotosynthesisGCCgn2br(params, counter, ...
        TPD.dayPARday,TPD.daytairday,TPD.ROIgccQA,1);
    valid = TPD.dayGEPday>1 & gepPredTest>1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(gepPredTest);
    r = corr(gepPredTest(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((gepPredTest(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - gepPredTest(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - gepPredTest(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),gepPredTest(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nstats gateway fixed [final] parameters:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);
end


if flag_compare_gate_normal ==1
    % ........................................................................
    %% GGC phenology as gatekeeper greenup & browndown segments
    % ........................................................................
    % best_params = [prctile(TPD.dayGEPday, 99), 4.5, 0.5,  4.5, 0.5, 100, 22, 20];
    best_params = [26.532,     2.252,     0.7567,     5.068,     0.356,     249.24,     24.413,     15.477];

    [TPD.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params,counter,...
        TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, 1);
    valid = TPD.dayGEPday>0.1 & TPD.dayGEPdaymodel>0.1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    r = corr(TPD.dayGEPdaymodel(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats normalize GCC year by year:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    figure('color','white','Position',[50 50 1800 400],'units','inches');
    y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
    h = area(TPD.daydate(ind),y);     set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    hold on;
    hl1 = plot(TPD.daydate(ind),TPD.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    hl2 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);
    scatter(TPD.daydate(ind),TPD.dayGEPday(ind),10,'o','MarkerFaceColor',[.4 .4 .4],'MarkerEdgeColor',[.4 .4 .4],...
        'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    scatter(TPD.daydate(ind),TPD.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(7,:),'MarkerEdgeColor',color_mtx_dark(7,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl3 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(7,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = TPD.month;
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)
    hold on;

    [TPD.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params,counter,...
        TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, 0);
    valid = TPD.dayGEPday>0.1 & TPD.dayGEPdaymodel>0.1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    r = corr(TPD.dayGEPdaymodel(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats normalize GCC timeseries:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(TPD.daydate(ind),TPD.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl4 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(2,:),'Linewidth',.5);
    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = TPD.month;
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)
    legend([hl3,hl4,hl1],'normalize annual cycle','normalize timeseries','observation'); legend box off;
end

% .....................................................................
%% GGC phenology as gatekeeper greenup & browndown segments
% .....................................................................
if flag_normalize==1
    % .....................................................................
    %% Year-by-year normalization
    % .....................................................................
    params = [prctile(TPD.dayGEPday, 97), 4.5, 0.5,  4.5, 0.5, 100, 22, 20];
    lb     = [prctile(TPD.dayGEPday, 95), 2, 0.1, 2, 0.1, 10, 18, 10];
    ub     = [max(TPD.dayGEPday,[],'omitnan'), 8, 1, 8, 1, 400, 28, 30];

    counter = (1:1:(length(TPD.daydate)))';

    ind = find((~isnan(TPD.dayGEPday))&(~isnan(TPD.ROIgccQA))&...
        (~isnan(TPD.daytairday))&(~isnan(TPD.dayPARday))&(TPD.dayGEPday>0)&...
        (isfinite(TPD.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPphotosynthesisGCCgn2br(params,counter(ind),...
        TPD.dayPARday(ind), TPD.daytairday(ind),TPD.ROIgccQA(ind), 1)...
        - TPD.dayGEPday(ind));

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    % fprintf('GEP_{max}: %.3f\nSteepness: %.3f\nSaturation: %.3f\n', best_params);
    fprintf('GEP_{max}: %.3f\nSteeep1: %.3f\nSat1: %.3f\nSteeep2: %.3f\nSat2: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    TPDmodelNormal(1).parameters = best_params;

    [TPD.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params,counter,...
        TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, 1);  %, TPD.dayLength

    % Statistics
    valid = TPD.dayGEPday>0.1 & TPD.dayGEPdaymodel>0.1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    r = corr(TPD.dayGEPdaymodel(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    figure('color','white','Position',[50 50 1800 400],'units','inches');
    y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
    h = area(TPD.daydate(ind),y);     set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    hold on;
    hl1 = plot(TPD.daydate(ind),TPD.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    hl2 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);
    scatter(TPD.daydate(ind),TPD.dayGEPday(ind),10,'o','MarkerFaceColor',[.4 .4 .4],'MarkerEdgeColor',[.4 .4 .4],...
        'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);

    scatter(TPD.daydate(ind),TPD.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl3 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(1,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = TPD.month;
    % TPD.dayGEPdaymodelGateGnBw = TPD.dayGEPdaymodel;

    %% Normalized
    residualFunction = @(params) (FN_computeGEPphotosynthesisGCCgn2br(params,counter(ind),...
        TPD.dayPARday(ind), TPD.daytairday(ind),TPD.ROIgccQA(ind), 0)...
        - TPD.dayGEPday(ind));

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    % fprintf('GEP_{max}: %.3f\nSteeepness: %.3f\nSaturation: %.3f\n', best_params);
    fprintf('GEP_{max}: %.3f\nSteeep1: %.3f\nSat1: %.3f\nSteeep2: %.3f\nSat2: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    TPDmodelNormal(2).parameters = best_params;

    [TPD.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params,counter,...
        TPD.dayPARday, TPD.daytairday, TPD.ROIgccQA, 0);  %, TPD.dayLength

    % Statistics
    valid = TPD.dayGEPday>0.1 & TPD.dayGEPdaymodel>0.1 & TPD.dayGEPday<maxGEPday &... %& TPD.dayGEPday < 30
        ~isnan(TPD.dayGEPday) & ~isnan(TPD.dayGEPdaymodel);
    r = corr(TPD.dayGEPdaymodel(valid), TPD.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((TPD.dayGEPdaymodel(valid) - TPD.dayGEPday(valid)) ./ TPD.dayGEPday(valid)).^2);
    MSE = mean((TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(TPD.dayGEPday(valid) - TPD.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(TPD.dayGEPday(valid),TPD.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(TPD.daydate(ind),TPD.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl4 = plot(TPD.daydate(ind),smoothdata(TPD.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(2,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = TPD.month;
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16,'Color','k');   xtickangle(0);   box on;   grid on;
    text(TPD.daydate(ind(20)),25,site_name,'FontSize',16)
    legend([hl3,hl4],'normalize year-to-year','normalize entire time series','observation'); legend box off;
    % TPD.dayGEPdaymodelGateGnBw = TPD.dayGEPdaymodel;

end