% for TAME work
% Natalia Restrepo-Coupe
% Toronto, December 2025 cold and gloomy winter
%..........................................................................
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;

load('matlabHa1.mat');

flag_model = 1;    flag_read_timesat = 1;   flag_model_test_chromatic = 1;
flag_model_test_gatekeeper = 1;             flag_visualize = 10;
flag_gatewayFixMeteo = 0;                   flag_figurePaper = 1;% 1 if we want to "fix" three of the meteo parameters on the LOYO
flag_Taylor = 10;                           flag_normalize = 1;
% Topt and Tamp, PARthresh
% (if not use 0)
flag_chromaticFixMeteo = 0;                  % This flag will "fix" two of the parameters Tmax and Tmin

Ha1.dayJD = day(Ha1.daydate,'dayofyear');
[~,~,Ha1.dayLength,~,~,Ha1.daySZA] = AM_solar_rad(Ha1.dayJD,0,lat,lon);

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

    % newTime = (datetime(ROI.dayY(1),1,1):days(1):datetime(ROI.dayY(end),12,31))';
    % in = find(newTime==ix(1));   im = find(newTime==ix(end));
    % iw = NaN(in-1,1);            iz = NaN(length(newTime)-im,1);
    % ROIHa1.dayGCC = [iw;iy;iz];
    % ROIHa1.daydate = newTime;
    % plot( ROIHa1.daydate, ROIHa1.dayGCC);
    %
    % [ROIHa1.day_recurrentGCC,ROIHa1.day_recurrent_stdGCC]  = AM_dayAVG_recurrent(ROIHa1.dayGCC,ROIHa1.daydate);
    % ROIHa1.day_recurrentGCCGoley = sgolayfilt(ROIHa1.day_recurrentGCC,polyorder,framesize);
    %
    % ROIHa1.dayJD = day(ROIHa1.daydate,'dayofyear');
    % [ROIHa1.dayY,ROIHa1.dayM,ROIHa1.dayD] = datevec(ROIHa1.daydate);

    windowSmooth = 21; %11

    % Final QA for indices
    iy = Ha1.ROIgcc;
    iy(Ha1.ROIgcc<0.35) = NaN;   %Ha1.ROIrcc(Ha1.daydate>datetime(2021,12,31)) = NaN;
    Ha1.ROIgccQA = iy;            %Ha1.ROIrccQA(ind) = ix;    Ha1.ROIgccQA = iy;            %Ha1.ROIgccQA(ind) = ix;
    [~,Ha1.ROIgccQA] = AM_spike_detection(Ha1.ROIgccQA,3);
    % Ha1.ROIgccQA = FN_fillVI(Ha1.daydate,iy);

    iy = Ha1.ROIGRRI;
    Ha1.ROIgrriQA = iy;            %Ha1.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(Ha1.ROIgrriQA,3);
    Ha1.ROIgrriQA = FN_fillVI(Ha1.daydate,iy);
    iy = Ha1.ROIGRRI;

    iy = Ha1.ROIGRIVI;
    Ha1.ROIgriviQA = iy;            %Ha1.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(Ha1.ROIgriviQA,3);
    Ha1.ROIgriviQA = FN_fillVI(Ha1.daydate,iy);

    iy = Ha1.ROIexgreen;
    Ha1.ROIexgreenQA = iy;            %Ha1.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(Ha1.ROIexgreenQA,3);
    Ha1.ROIexgreenQA = FN_fillVI(Ha1.daydate,iy);

    iy = Ha1.ROIcci;
    Ha1.ROIcciQA = iy;            %Ha1.ROIgccQA(ind) = ix;
    [~,iy] = AM_spike_detection(Ha1.ROIcciQA,3);
    Ha1.ROIcciQA = FN_fillVI(Ha1.daydate,iy);

    iy = Ha1.ROIrcc;
    iy(Ha1.ROIrcc<0.28) = NaN;   %Ha1.ROIrcc(Ha1.daydate>datetime(2021,12,31)) = NaN;
    Ha1.ROIrccQA = iy;            %Ha1.ROIrccQA(ind) = ix;
    [~,Ha1.ROIrccQA] = AM_spike_detection(Ha1.ROIrccQA,3);
    iy = smoothdata(Ha1.ROIrccQA,'movmean',windowSmooth);
    Ha1.ROIrccQA = FN_fillVI(Ha1.daydate,iy);

    %% GCC
    filename = 'timesat/HA1seasonalityGCC.txt';
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
        if ~isnan(GCC.BegTtemp(ix));   GCC.BegTdate(ix) = ROIHa1.daydate(ceil(GCC.BegTtemp(ix)));   end
        if ~isnan(GCC.EndTtemp(ix));   GCC.EndTdate(ix) = ROIHa1.daydate(floor(GCC.EndTtemp(ix)));  end
        if ~isnan(GCC.MaxTtemp(ix));   GCC.MaxTdate(ix) = ROIHa1.daydate(floor(GCC.MaxTtemp(ix)));  end
    end

    GCC.BegTjd = day(GCC.BegTdate,'dayofyear');
    GCC.EndTjd = day(GCC.EndTdate,'dayofyear');
    GCC.MaxTjd = day(GCC.MaxTdate,'dayofyear');

    ind = find((GCC.BegTdate>=ROIHa1.daydate(1))&(GCC.BegTdate<=ROIHa1.daydate(end)));  GCC.BegT = GCC.BegTjd(ind);
    ind = find((GCC.EndTdate>=ROIHa1.daydate(1))&(GCC.EndTdate<=ROIHa1.daydate(end)));  GCC.EndT = GCC.EndTjd(ind);
    ind = find((GCC.MaxTdate>=ROIHa1.daydate(1))&(GCC.MaxTdate<=ROIHa1.daydate(end)));  GCC.MaxT = GCC.MaxTjd(ind);

    [ROIHa1.daydateY,ROIHa1.daydateM,ROIHa1.daydateD] = datevec(ROIHa1.daydate);
    GCC.daydateYears = unique(ROIHa1.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% GRRI
    filename = 'timesat/HA1seasonalityGRRI.txt';
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
        if ~isnan(GRRI.BegTtemp(ix));   GRRI.BegTdate(ix) = ROIHa1.daydate(ceil(GRRI.BegTtemp(ix)));   end
        if ~isnan(GRRI.EndTtemp(ix));   GRRI.EndTdate(ix) = ROIHa1.daydate(floor(GRRI.EndTtemp(ix)));  end
        if ~isnan(GRRI.MaxTtemp(ix));   GRRI.MaxTdate(ix) = ROIHa1.daydate(floor(GRRI.MaxTtemp(ix)));  end
    end

    GRRI.BegTjd = day(GRRI.BegTdate,'dayofyear');
    GRRI.EndTjd = day(GRRI.EndTdate,'dayofyear');
    GRRI.MaxTjd = day(GRRI.MaxTdate,'dayofyear');

    ind = find((GRRI.BegTdate>=ROIHa1.daydate(1))&(GRRI.BegTdate<=ROIHa1.daydate(end)));  GRRI.BegT = GRRI.BegTjd(ind);
    ind = find((GRRI.EndTdate>=ROIHa1.daydate(1))&(GRRI.EndTdate<=ROIHa1.daydate(end)));  GRRI.EndT = GRRI.EndTjd(ind);
    ind = find((GRRI.MaxTdate>=ROIHa1.daydate(1))&(GRRI.MaxTdate<=ROIHa1.daydate(end)));  GRRI.MaxT = GRRI.MaxTjd(ind);

    [ROIHa1.daydateY,ROIHa1.daydateM,ROIHa1.daydateD] = datevec(ROIHa1.daydate);
    GRRI.daydateYears = unique(ROIHa1.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% RCC
    filename = 'timesat/HA1seasonalityRCC.txt';
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
    for ix = 1:length(RCC.BegTtemp)
        if ~isnan(RCC.BegTtemp(ix));   RCC.BegTdate(ix) = ROIHa1.daydate(ceil(RCC.BegTtemp(ix)));   end
        if ~isnan(RCC.EndTtemp(ix));   RCC.EndTdate(ix) = ROIHa1.daydate(floor(RCC.EndTtemp(ix)));  end
        if ~isnan(RCC.MaxTtemp(ix));   RCC.MaxTdate(ix) = ROIHa1.daydate(floor(RCC.MaxTtemp(ix)));  end
    end

    RCC.BegTjd = day(RCC.BegTdate,'dayofyear');
    RCC.EndTjd = day(RCC.EndTdate,'dayofyear');
    RCC.MaxTjd = day(RCC.MaxTdate,'dayofyear');

    ind = find((RCC.BegTdate>=ROIHa1.daydate(1))&(RCC.BegTdate<=ROIHa1.daydate(end)));  RCC.BegT = RCC.BegTjd(ind);
    ind = find((RCC.EndTdate>=ROIHa1.daydate(1))&(RCC.EndTdate<=ROIHa1.daydate(end)));  RCC.EndT = RCC.EndTjd(ind);
    ind = find((RCC.MaxTdate>=ROIHa1.daydate(1))&(RCC.MaxTdate<=ROIHa1.daydate(end)));  RCC.MaxT = RCC.MaxTjd(ind);

    RCC.daydateYears = unique(ROIHa1.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% RCCabs
    filename = 'timesat/HA1seasonalityRCCabs.txt';
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
        if ~isnan(RCCabs.BegTtemp(ix));   RCCabs.BegTdate(ix) = ROIHa1.daydate(ceil(RCCabs.BegTtemp(ix)));   end
        if ~isnan(RCCabs.EndTtemp(ix));   RCCabs.EndTdate(ix) = ROIHa1.daydate(floor(RCCabs.EndTtemp(ix)));  end
        if ~isnan(RCCabs.MaxTtemp(ix));   RCCabs.MaxTdate(ix) = ROIHa1.daydate(floor(RCCabs.MaxTtemp(ix)));  end
    end

    RCCabs.BegTjd = day(RCCabs.BegTdate,'dayofyear');
    RCCabs.EndTjd = day(RCCabs.EndTdate,'dayofyear');
    RCCabs.MaxTjd = day(RCCabs.MaxTdate,'dayofyear');

    ind = find((RCCabs.BegTdate>=ROIHa1.daydate(1))&(RCCabs.BegTdate<=ROIHa1.daydate(end)));  RCCabs.BegT = RCCabs.BegTjd(ind);
    ind = find((RCCabs.EndTdate>=ROIHa1.daydate(1))&(RCCabs.EndTdate<=ROIHa1.daydate(end)));  RCCabs.EndT = RCCabs.EndTjd(ind);
    ind = find((RCCabs.MaxTdate>=ROIHa1.daydate(1))&(RCCabs.MaxTdate<=ROIHa1.daydate(end)));  RCCabs.MaxT = RCCabs.MaxTjd(ind);

    RCCabs.daydateYears = unique(ROIHa1.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %%
    v1 = -1;         v2 = 10;          v1 = v1+1;      %v3 = v1:((v2-v1)/4):v2;
    v4 = v1:((v2-v1)/(max(Ha1.dayY)-min(ROI.dayY)+1)):v2;
    y1 = 0.38;      y2 = 0.48;         y3 = y1:((y2-y1)/4):y2;
    y4 = y1:((y2-y1)/(max(Ha1.dayY)-min(ROI.dayY)+1)):y2;
    figure('color','white');           hold on;
    ik = ROI.dayY(1);   count=1;       color_jet = jet(max(Ha1.dayY)-min(ROI.dayY)+1);
    while (ik<Ha1.dayY(end))&(count<length(GCC.BegTdate))
        current_SGS = GCC.BegTdate(count);
        current_EGS = GCC.EndTdate(count);
        ind = find((Ha1.daydate>=current_SGS)&(Ha1.daydate<=current_EGS)&(Ha1.dayY == ik));
        hl1  =  plot(Ha1.ROIgccQA(ind),Ha1.dayGEPday(ind).*100./Ha1.dayPARday(ind),'.',...
            'MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
        AM_compute_regression(Ha1.ROIgccQA(ind),Ha1.dayGEPday(ind).*100./Ha1.dayPARday(ind),color_jet(count,:),1);
        polyfit(Ha1.ROIgccQA(ind),Ha1.dayGEPday(ind).*100./Ha1.dayPARday(ind),2); %color_jet(count,:),1
        plot(.33,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
        text (.34,v4(count),num2str(ik),'FontSize',8);
        ik = ik+1;  count = count+1;
    end
    ylabel ('GEP_{day}/PAR_{day}(\mumolC/\mmol)');              xlabel ('GCC');
    axis([y1 y2 v1 v2])

    %%
    v1 = -1;         v2 = 7;          v1 = v1+1;      %v3 = v1:((v2-v1)/4):v2;
    v4 = v1:((v2-v1)/(max(Ha1.dayY)-min(ROI.dayY))):v2;
    y1 = 0.38;      y2 = 0.48;         y3 = y1:((y2-y1)/4):y2;
    y4 = y1:((y2-y1)/(max(Ha1.dayY)-min(ROI.dayY))):y2;
    figure('color','white');           hold on;
    ik = ROI.dayY(1);   count=1;       color_jet = jet(max(Ha1.dayY)-min(ROI.dayY)+1);
    while (ik<Ha1.dayY(end))&(count<length(GCC.BegTdate))
        current_SGS = GCC.BegTdate(count)-days(15);
        current_EGS = GCC.EndTdate(count)+days(15);
        ind = find((Ha1.eight>=current_SGS)&(Ha1.eight<=current_EGS)&(Ha1.eightY == ik));
        hl1  =  plot(Ha1.eightROIgcc(ind),smoothdata(Ha1.eightGEPday(ind).*100./Ha1.eightPARday(ind),'movmedian'),'-',...
            'Color',color_jet(count,:)); hold on;
        plot(Ha1.eightROIgcc(ind),Ha1.eightGEPday(ind).*100./Ha1.eightPARday(ind),'.',...
            'MarkerFaceColor',color_jet(count,:),'MarkerEdgeColor',color_jet(count,:)); hold on;
        AM_compute_regression(Ha1.eightROIgcc(ind),Ha1.eightGEPday(ind).*100./Ha1.eightPARday(ind),color_jet(count,:),0);
        % polyfit(Ha1.eightROIgcc(ind),Ha1.eightGEPday(ind).*100./Ha1.eightPARday(ind),2); %color_jet(count,:),1
        plot(.33,v4(count),'.','MarkerSize',14,'color',color_jet(count,:));
        text (.34,v4(count),num2str(ik),'FontSize',8);
        ik = ik+1;  count = count+1;
    end
    ylabel ('GEP_{day}(gC m^-^2 d^-^2)');  xlabel ('GCC');
    axis([y1 y2 v1 v2])

    %% GRIVI
    filename = 'timesat/HA1seasonalityGRIVI.txt';
    GRIVI = readtable(filename, 'Delimiter', '\t');  GRIVI = table2struct(GRIVI, 'ToScalar', true);

    GRIVI.BegTjd = day(GRIVI.BegTdate, 'dayofyear');   % The start/first minima
    GRIVI.MaxTjd = day(GRIVI.MaxTdate, 'dayofyear');   % The peak
    GRIVI.EndTjd = day(GRIVI.EndTdate, 'dayofyear');   % The end/second minima
    % GRRI.Year = T.Year;[cite: 1]

    % GRIVI.BegT = [];            GRIVI.EndT = [];                GRIVI.MaxT = [];
    ind = find((GRIVI.BegTdate>=ROIHa1.daydate(1))&(GRIVI.BegTdate<=ROIHa1.daydate(end)));
    GRIVI.BegT = GRIVI.BegTjd(ind);
    ind = find((GRIVI.EndTdate>=ROIHa1.daydate(1))&(GRIVI.EndTdate<=ROIHa1.daydate(end)));  GRIVI.EndT = GRIVI.EndTjd(ind);
    ind = find((GRIVI.MaxTdate>=ROIHa1.daydate(1))&(GRIVI.MaxTdate<=ROIHa1.daydate(end)));  GRIVI.MaxT = GRIVI.MaxTjd(ind);

    [ROIHa1.daydateY,ROIHa1.daydateM,ROIHa1.daydateD] = datevec(ROIHa1.daydate);
    GRIVI.daydateYears = unique(ROIHa1.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

end

%% ........................................................................
if flag_model==1
    color_mtx = [ 255/255 127/255 20/255; 50/255 77/255 255/255; ...
        0.1020 0.5882 0.2549; 60/255 187/255 255/255; 245/255 55/255 58/255;...
        245/255 55/255 245/255; 245/255 255/255 45/255; 0.1020 0.5882 0.2549; 0.1020 0.5882 0.2549];
    color_mtx_dark = color_mtx.*0.99;
    color_mtx_light = color_mtx.*1.1; color_mtx_light(color_mtx_light>1) = 1;

    % maxGEPday = prctile(Ha1.dayGEPday,97);
    maxGEPday = prctile(Ha1.dayGEPday,99);
    minGEPday = prctile(Ha1.dayGEPday(Ha1.dayM==12|Ha1.dayM<=4),95);

    % Optimization options.... number of iterations can be > 5000
    opts = optimoptions('lsqnonlin', 'Display', 'final', 'MaxIterations', 10000,... %, 'Display', 'iter'
        'MaxFunctionEvaluations', 10000, 'FunctionTolerance', 1e-15,...
        'StepTolerance', 1e-15,...
        'OptimalityTolerance', 1e-15,...
        'FiniteDifferenceType', 'central',... % More accurate gradient estimation
        'UseParallel', true);

    % Parameters    LagStart = 30;
    % Topt   = params(1);   % Optimal temperature
    % Tmin   = params(2);   % Minimum temperature
    % Tmax   = params(3);   % Maximum temperature
    % LUEcam green = params(4);   % Light use efficiency greenup-peak
    % LUEcam peak  = params(5);   % Light use efficiency peak-end growing season
    % LUEcam brown = params(6);   % Light use efficiency end-start growing season

    % Initial guess: [Topt, Tmin, Tmax, alpha_green alpha_peak alpha_browndown]
    params = [22, 0, 32, 1, 1, 1];

    % Lower and upper bounds for parameters
    lb = [18, -5, 30, .01, .01, .01];  % realistic lower bounds
    ub = [28, 8, 40, 6, 6, 6];  % realistic upper bounds

    % Seasonal modulation: greenup ramp up, browndown ramp down
    StartGrowing = days(GCC.BegTdate-Ha1.daydate(1));   %-LagStart
    GreenupPeak  = days(GCC.MaxTdate-Ha1.daydate(1));
    EndGrowing   = days(GCC.EndTdate-Ha1.daydate(1));   %+LagStart

    counter = (1:1:(length(Ha1.daydate)))';

    ind = find((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgccQA))&...
        (~isnan(Ha1.daytairday))&(~isnan(Ha1.dayPARday))&(Ha1.dayGEPday>0)&...
        (isfinite(Ha1.dayGEPday)));

    % + 0.25: acts as a "floor" for the uncertainty. Preventing th optimizer from over-fitting to days
    % with extremely low GEP while still allowing it to prioritize accuracy during high-productivity periods.
    residualFunction = @(params) (FN_computeGEPseasons(params,counter(ind),Ha1.ROIgccQA(ind),...
        Ha1.dayPARday(ind), Ha1.daytairday(ind),....
        StartGrowing, GreenupPeak, EndGrowing, 1) - Ha1.dayGEPday(ind)).*(sqrt(abs(Ha1.dayGEPday(ind))) + 0.25);

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
    Ha1modelParameter(1).parameters = best_params;

    Ha1.dayGEPdaymodel = FN_computeGEPseasons(best_params,counter,Ha1.ROIgccQA,...
        Ha1.dayPARday, Ha1.daytairday,....
        StartGrowing, GreenupPeak, EndGrowing, 1);

    Ha1.dayGEPdaymodel((isnan(Ha1.ROIgccQA))|(Ha1.dayGEPdaymodel==0)) = NaN;

    % Statistics
    valid = Ha1.dayGEPday>0.1 & Ha1.dayGEPdaymodel>0.1 & Ha1.dayGEPday<maxGEPday & ... % & Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodel);
    % r = corr(Ha1.dayGEPdaymodel(ind), Ha1.dayGEPday(ind), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodel(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    % SS_res = sum((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    % SS_tot = sum((Ha1.dayGEPday(valid) - mean(Ha1.dayGEPday(valid))).^2);
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    % yearSelect = 2019;
    ind = 1:length(Ha1.dayY);       % ind = find(Ha1.dayY==yearSelect);
    v1 = 0;                         v2 = 32;       %v3 = v1:((v2-v1)/4):v2;
    % figure('color','white','Position',[50 50 600 400],'units','inches');
    figure('color','white','Position',[50 50 1800 400],'units','inches');
    y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
    h = area(Ha1.daydate(ind),y);     set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    hold on;
    hl1 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    hl2 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);
    scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),10,'o','MarkerFaceColor',[.4 .4 .4],'MarkerEdgeColor',[.4 .4 .4],...
        'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);

    scatter(Ha1.daydate(ind),Ha1.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl3 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(1,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';
    ax2.XAxis.MinorTickValues = Ha1.month(1:12:end);  ax2.XAxis.MinorTickValues = Ha1.month;
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[ROIHa1.daydate(ind(1)) Ha1.daydate(ind(end))],...
        'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:12:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl3,hl1],'model','observation'); legend box off;

    Ha1.dayGEPdaymodelLeafStage = Ha1.dayGEPdaymodel;
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
    StartGrowing = days(GCC.BegTdate-Ha1.daydate(1))-LagStart;
    EndGrowing   = days(GCC.EndTdate-Ha1.daydate(1))+LagStart;

    counter = (1:1:(length(Ha1.daydate)))';

    ind = find((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgccQA))&...
        (~isnan(Ha1.daytairday))&(~isnan(Ha1.dayPARday))&(Ha1.dayGEPday>0)&...
        (isfinite(Ha1.dayGEPday)));

    % here I am trying to make higher errors more significant (sqrt + 0.25)
    % as is where we do have issues
    residualFunction = @(params) (FN_computeGEPleafage(params,counter(ind),...
        Ha1.dayPARday(ind), Ha1.daytairday(ind),....
        StartGrowing, EndGrowing) - Ha1.dayGEPday(ind)) .* (sqrt(abs(Ha1.dayGEPday(ind))) + 0.25);

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('Topt: %.3f\nTmin: %.3f\nTmax: %.3f\nAmaxTime: %.3f\nMaxValue: %.3f\n', best_params);

    % Display best-fit parameters
    Ha1modelParameter(2).parameters = best_params;

    Ha1.dayGEPdaymodel = FN_computeGEPleafage(best_params,counter,...
        Ha1.dayPARday, Ha1.daytairday,....
        StartGrowing, EndGrowing);
    Ha1.dayGEPdaymodel(Ha1.dayGEPdaymodel==0) = NaN;

    % Statistics
    valid = Ha1.dayGEPday>1  & Ha1.dayGEPdaymodel>1 & Ha1.dayGEPday<maxGEPday &...
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodel);
    % r = corr(Ha1.dayGEPdaymodel(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodel(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    % SS_res = sum((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    % SS_tot = sum((Ha1.dayGEPday(valid) - mean(Ha1.dayGEPday(valid))).^2);
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    % % % yearSelect = 2019;
    % % ind = 1:length(Ha1.dayY);       % ind = find(Ha1.dayY==yearSelect);
    % % v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    % % % figure('color','white','Position',[50 50 600 400],'units','inches');
    % % figure('color','white','Position',[50 50 1800 400],'units','inches');
    % % y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
    % % h = area(Ha1.daydate(ind),y);     set(gca,'Layer','top');
    % % set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    % % set(h,'BaseValue',0);
    % % hold on;
    % % hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    % % hl1 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);

    scatter(Ha1.daydate,Ha1.dayGEPdaymodel,10,'o','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl4 = plot(Ha1.daydate,smoothdata(Ha1.dayGEPdaymodel,'movmean',5),'-','Color',color_mtx_dark(2,:),'Linewidth',.5);

    % ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    % ax2.XAxis.MinorTick = 'on';
    % ax2.XAxis.MinorTickValues = Ha1.month(1:12:end);  ax2.XAxis.MinorTickValues = Ha1.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[ROIHa1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:12:end),'YColor','k');
    % ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    % text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl3,hl1],'model','observation'); legend box off;

    Ha1.dayGEPdaymodelLeafAge = Ha1.dayGEPdaymodel;
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
    StartGrowing = days(GCC.BegTdate-Ha1.daydate(1));%-LagStart;
    EndGrowing   = days(GCC.EndTdate-Ha1.daydate(1));%+LagStart;

    % MaxGrowing   = days(RCC.MaxTdate-Ha1.daydate(1)); %-LagStart7
    % StartGrowing = days(RCC.MaxTdate(1:2:end-1)-Ha1.daydate(1))+LagStart;
    % EndGrowing   = days(RCC.MaxTdate(2:2:end)-Ha1.daydate(1))-LagStart;

    counter = (1:1:(length(Ha1.daydate)))';

    % opts = optimoptions('lsqnonlin', 'Display', 'iter', 'MaxIterations', 5000,...
    %     'MaxFunctionEvaluations', 10000, 'FunctionTolerance', 1e-10,...      % Tighter tolerance for higher R2
    % 'StepTolerance', 1e-10,'OptimalityTolerance', 1e-10, 'FiniteDifferenceType', 'central', ... % More accurate gradient estimation
    % 'UseParallel', true);

    ind = find((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgccQA))&(~isnan(Ha1.ROIrccQA))&...
        (~isnan(Ha1.daytairday))&(~isnan(Ha1.dayPARday))&(Ha1.dayGEPday>0)&...
        (isfinite(Ha1.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPchromatic(params,counter(ind),...
        Ha1.dayPARday(ind), Ha1.daytairday(ind),Ha1.ROIgccQA(ind), Ha1.ROIrccQA(ind),....
        StartGrowing, EndGrowing, 1) - Ha1.dayGEPday(ind)) .* (sqrt(abs(Ha1.dayGEPday(ind))) + 0.25);

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('Topt: %.3f\nTmin: %.3f\nTmax: %.3f\nalphaGCC: %.3f\nalphaRCC: %.3f\n', best_params);

    % Display best-fit parameters
    Ha1modelParameter(3).parameters = best_params;

    Ha1.dayGEPdaymodel = FN_computeGEPchromatic(best_params,counter,...
        Ha1.dayPARday, Ha1.daytairday, Ha1.ROIgccQA, Ha1.ROIrccQA,....
        StartGrowing, EndGrowing, 1);

    % Statistics
    valid = Ha1.dayGEPday>0.1 & Ha1.dayGEPdaymodel>0.1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodel);
    r = corr(Ha1.dayGEPdaymodel(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodel(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    % yearSelect = 2019;
    % ind = find(Ha1.dayY==yearSelect);
    % v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    % figure('color','white','Position',[50 50 600 400],'units','inches');
    % y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
    % h = area(Ha1.daydate(ind),y);       set(gca,'Layer','top');
    % set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    % set(h,'BaseValue',0);
    % hold on;
    % hl2 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    % hl1 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);

    scatter(Ha1.daydate(valid),Ha1.dayGEPdaymodel(valid),10,'o','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl5 = plot(Ha1.daydate,smoothdata(Ha1.dayGEPdaymodel,'movmean',5),'-','Color',color_mtx_dark(3,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = Ha1.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    % legend([hl3,hl4,hl5,hl1],'leaf seasons','leaf age', 'chromatic','observation'); legend box off;

    Ha1.dayGEPdaymodelChromatic = Ha1.dayGEPdaymodel;
    RMSE3 = RMSE;    MAE3 = MAE;     Rsquared_3 = Rsquared;   MSRE3 = MSRE;

    % .......................................................................
    %% SIGMOID
    % .......................................................................
    % Initial guess: [Topt, Tmin, Tmax, alpha_green]
    params = [22, 0, 32, 1];

    % Lower and upper bounds for parameters
    lb = [18, -5, 30, .01];  % realistic lower bounds
    ub = [28, 8, 40, 6];  % realistic upper bounds

    counter = (1:1:(length(Ha1.daydate)))';

    % % opts = optimoptions('lsqnonlin', 'Display', 'iter', 'MaxIterations', 5000,...
    % %     'MaxFunctionEvaluations', 10000, 'FunctionTolerance', 1e-10,...      % Tighter tolerance for higher R2
    % % 'StepTolerance', 1e-10,'OptimalityTolerance', 1e-10, 'FiniteDifferenceType', 'central', ... % More accurate gradient estimation
    % % 'UseParallel', true);
    %
    % ind = find((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgccQA))&...
    %     (~isnan(Ha1.daytairday))&(~isnan(Ha1.dayPARday))&(Ha1.dayGEPday>0)&...
    %     (isfinite(Ha1.dayGEPday)));
    %
    % residualFunction = @(params) (FN_computeGEPsigmoidGCC(params,counter(ind),Ha1.ROIgccQA(ind),...
    %     Ha1.dayPARday(ind), Ha1.daytairday(ind), 1) - Ha1.dayGEPday(ind)) .* (sqrt(abs(Ha1.dayGEPday(ind))) + 0.25);
    %
    ind = find((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgriviQA))&...
        (~isnan(Ha1.daytairday))&(~isnan(Ha1.dayPARday))&(Ha1.dayGEPday>0)&...
        (isfinite(Ha1.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPsigmoidGRIVI(params,counter(ind),Ha1.ROIgriviQA(ind),...
        Ha1.dayPARday(ind), Ha1.daytairday(ind), 1) - Ha1.dayGEPday(ind)) .* (sqrt(abs(Ha1.dayGEPday(ind))) + 0.25);
    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('Topt: %.3f\nTmin: %.3f\nTmax: %.3f\nalpha: %.3f\n', best_params);

    % Display best-fit parameters
    Ha1modelParameter(4).parameters = best_params;

    % Ha1.dayGEPdaymodel = FN_computeGEPsigmoidGCC(best_params,counter,Ha1.ROIgccQA,...
    %     Ha1.dayPARday, Ha1.daytairday, 1);
    [Ha1.dayGEPdaymodel,Ha1.dayGRIVInorm] = FN_computeGEPsigmoidGRIVI(best_params,counter,Ha1.ROIgriviQA,...
        Ha1.dayPARday, Ha1.daytairday, 1);

    Ha1.dayGEPdaymodel(isnan(Ha1.ROIgriviQA)) = NaN;   Ha1.dayGEPdaymodel(Ha1.dayGEPdaymodel==0) = NaN;

    % Statistics
    valid = Ha1.dayGEPday>0.1 & Ha1.dayGEPdaymodel>0.1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodel);
    r = corr(Ha1.dayGEPdaymodel(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodel(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(Ha1.daydate(ind),Ha1.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(4,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl6 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(4,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';
    ax2.XAxis.MinorTickValues = Ha1.month(1:12:end);  ax2.XAxis.MinorTickValues = Ha1.month;
    set(ax2,'YTick',v3,'YLim',[v1 v2]);%,'XLim',[ROIHa1.daydate Ha1.daydate(ind(end))],...
    % 'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:12:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    % text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl3,hl1],'model','observation'); legend box off;
    % legend([hl1,hl2,hl3,hl4,hl5,hl6],'historical','obs','seasons','leaf age','chromatic','sigmoid')

    Ha1.dayGEPdaymodelSigmoidGRIVI = Ha1.dayGEPdaymodel;
    RMSE4 = RMSE;    MAE4 = MAE;     Rsquared_4 = Rsquared;   MSRE4 = MSRE;

    % .........................................................................
    %% Only GCC, no PAR, no Tair. Hockey stick
    % .....................................................................
    params = [3, 0.2];
    lb = [0.001, 0.00];  % Lowering beta to 0.0 allows no threshold
    ub = [500, 1];

    ind = find((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgccQA))&...
        (Ha1.dayGEPday>-3)& (isfinite(Ha1.dayGEPday))&...
        (Ha1.ROIgccQA<prctile(Ha1.ROIgccQA,97)));

    residualFunction = @(params) (FN_computeGEPhockeyGCC(params,counter(ind),...
        Ha1.ROIgccQA(ind),1) - Ha1.dayGEPday(ind)) .* (sqrt(abs(Ha1.dayGEPday(ind))) + 0.25);

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    fprintf('alphaGCC: %.3f\nwakeupGCC: %.3f\n', best_params);

    % Display best-fit parameters
    Ha1modelParameter(5).parameters = best_params;

    Ha1.dayGEPdaymodel = FN_computeGEPhockeyGCC(best_params,counter,Ha1.ROIgccQA,1);

    ind = find((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgccQA))&...
        (Ha1.dayGEPday>-3)& (isfinite(Ha1.dayGEPday)));

    % Statistics
    valid = Ha1.dayGEPday>0.1 & Ha1.dayGEPdaymodel>0.1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodel);
    r = corr(Ha1.dayGEPdaymodel(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodel(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(Ha1.daydate(ind),Ha1.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(5,:),'MarkerEdgeColor',color_mtx_dark(5,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl7 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx(5,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = Ha1.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    % legend([hl3,hl4,hl5,hl6,hl1],'leaf seasons','leaf age', 'chromatic','hockey','observation'); legend box off;

    Ha1.dayGEPdaymodelHockey = Ha1.dayGEPdaymodel;
    RMSE5 = RMSE;    MAE5 = MAE;     Rsquared_5 = Rsquared;   MSRE5 = MSRE;

    % ........................................................................
    %% GGC phenology as gatekeeper
    % ........................................................................
    % Linear relation between GEP v. GCC. Phenology modulated by temperature and PAR only after GCC threshold (a "wakeup" value)
    params = [prctile(Ha1.dayGEPday, 98), 4.5, 0.5, 100, 22, 20];
    lb     = [prctile(Ha1.dayGEPday, 95), 2, 0.1, 10, 18, 10];
    ub     = [max(Ha1.dayGEPday,[],'omitnan'), 8, 1, 400, 28, 30];

    counter = (1:1:(length(Ha1.daydate)))';

    ind = find((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgccQA))&...
        (~isnan(Ha1.daytairday))&(~isnan(Ha1.dayPARday))&(Ha1.dayGEPday>0)&...
        (isfinite(Ha1.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPgatekeeperGCCmeteo(params, counter(ind),...
        Ha1.dayPARday(ind), Ha1.daytairday(ind), Ha1.ROIgccQA(ind),1)...
        - Ha1.dayGEPday(ind));

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    fprintf('\nBest-fit parameters:\n');
    fprintf('GEP_{max}: %.3f\nSteeepness: %.3f\nSaturation: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    Ha1modelParameter(6).parameters = best_params;

    %FN_computeGEPgatekeeperGCCmeteo to calculate the parameters for PAR
    %and Tair
    [Ha1.dayGEPdaymodel,Ha1.dayGCCnorm] = FN_computeGEPgatekeeperGCCmeteo(best_params, counter,...
        Ha1.dayPARday, Ha1.daytairday, Ha1.ROIgccQA, 1);  %, Ha1.dayLength

    % Statistics
    valid = Ha1.dayGEPday>0.1 & Ha1.dayGEPdaymodel>0.1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodel);
    r = corr(Ha1.dayGEPdaymodel(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodel(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(Ha1.daydate(ind),Ha1.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(6,:),'MarkerEdgeColor',color_mtx_dark(6,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl8 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(6,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = Ha1.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    legend([hl3,hl4,hl5,hl6,hl7,hl1],'leaf seasons','leaf age', 'chromatic','hockey','gatekeeper','observation'); legend box off;

    Ha1.dayGEPdaymodelGate = Ha1.dayGEPdaymodel;
    RMSE6 = RMSE;    MAE6 = MAE;     Rsquared_6 = Rsquared;   MSRE6 = MSRE;

    % ........................................................................
    %% GGC phenology as gatekeeper greenup & browndown segments
    % ........................................................................
    % Linear relation between GEP v. GCC. Phenology modulated by temperature and PAR only after GCC threshold (a "wakeup" value)
    params = [prctile(Ha1.dayGEPday, 98), 4.5, 0.5,  4.5, 0.5, 100, 22, 20];
    lb     = [prctile(Ha1.dayGEPday, 95), 2, 0.1, 2, 0.1, 10, 18, 10];
    ub     = [max(Ha1.dayGEPday,[],'omitnan'), 8, 1, 8, 1, 400, 28, 30];

    counter = (1:1:(length(Ha1.daydate)))';

    ind = find((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgccQA))&...
        (~isnan(Ha1.daytairday))&(~isnan(Ha1.dayPARday))&(Ha1.dayGEPday>0)&...
        (isfinite(Ha1.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPphotosynthesisGCCgn2br(params,counter(ind),...
        Ha1.dayPARday(ind), Ha1.daytairday(ind),Ha1.ROIgccQA(ind), 1)...
        - Ha1.dayGEPday(ind));

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    % fprintf('GEP_{max}: %.3f\nSteeepness: %.3f\nSaturation: %.3f\n', best_params);
    fprintf('GEP_{max}: %.3f\nSteeep1: %.3f\nSat1: %.3f\nSteeep2: %.3f\nSat2: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    Ha1modelParameter(7).parameters = best_params;

    [Ha1.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params,counter,...
        Ha1.dayPARday, Ha1.daytairday, Ha1.ROIgccQA, 1);  %, Ha1.dayLength

    % Statistics
    valid = Ha1.dayGEPday>0.1 & Ha1.dayGEPdaymodel>0.1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodel);
    r = corr(Ha1.dayGEPdaymodel(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodel(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(Ha1.daydate(ind),Ha1.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(7,:),'MarkerEdgeColor',color_mtx_dark(7,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl9 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(7,:),'Linewidth',.5);
    % plot(Ha1.daydate,Ha1.dayLength*2,'-','Color','r','Linewidth',2);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = Ha1.month;
    % set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],...
    %     'FontSize',16,'XMinorGrid','on','XTick',Ha1.month(1:2:end),'YColor','k');
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)
    % legend([hl5,hl1],'model','observation'); legend box off;
    legend([hl3,hl4,hl5,hl6,hl7,hl8,hl9,hl1],'leaf seasons','leaf age', 'chromatic', 'sigmoid','hockey','gatekeeper','gatekeeper+gr&bw','observation'); legend box off;

    Ha1.dayGEPdaymodelGateGnBw = Ha1.dayGEPdaymodel;
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
    save ('modelResultsHa1.mat','ComparisonTable')

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
    scatter(Ha1.dayGEPday,Ha1.dayGEPdaymodelLeafStage,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    % Find x values for plotting the fit based on xlim
    x0 = linspace(min(Ha1.dayGEPday,[],'omitnan'), max(Ha1.dayGEPday,[],'omitnan'));
    valid = Ha1.dayGEPday>1  & Ha1.dayGEPdaymodelLeafStage>1 & Ha1.dayGEPday<maxGEPday &...
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodelLeafStage);
    % check1 = Ha1.dayGEPday > 10 & Ha1.dayGEPdaymodelLeafAge < 1;
    fitResults = polyfit(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelLeafStage(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    text(x4(1),y4(end-count),['GEP_{leaf stage} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])
    [ix,iy] = AM_class_eq_size(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelLeafStage(valid),15);
    % [ix,iy] = AM_bin_noplot(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelLeafStage(valid),15,5);
    hl11 = scatter(ix(:,2),iy,50,'s','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    % fitResults = polyfit(ix(:,2),iy,fittypesArray-1);
    % iy = polyval(fitResults,ix);
    % plot(iy,iy,'-','Color',color_mtx(count,:));
    % text(x4(3),y4(end-2*count),['GEP_{leaf stage} = ', num2str(fitResults(1)),'GEP_{obs}+',num2str(fitResults(2))])

    count = 2;
    scatter(Ha1.dayGEPday,Ha1.dayGEPdaymodelLeafAge,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = Ha1.dayGEPday > 1  & Ha1.dayGEPdaymodelLeafAge>1 & Ha1.dayGEPday<maxGEPday &...
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodelLeafAge);
    % check2 = Ha1.dayGEPday > 10 & Ha1.dayGEPdaymodelLeafAge < 1;
    fitResults = polyfit(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelLeafAge(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelLeafAge(valid),15);
    % [ix,iy] = AM_bin_noplot(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelLeafAge(valid),15,5);
    hl12 = scatter(ix(:,2),iy,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{leaf age} = ', num2str(fitResults(1),'%.2f'),' GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 3;
    scatter(Ha1.dayGEPday,Ha1.dayGEPdaymodelChromatic,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = Ha1.dayGEPday>1  & Ha1.dayGEPdaymodelChromatic>1 & Ha1.dayGEPday<maxGEPday &...
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodelChromatic);
    % check3 = Ha1.dayGEPday > 10 & Ha1.dayGEPdaymodelChromatic < 1;
    fitResults = polyfit(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelChromatic(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelChromatic(valid),15);
    % [ix,iy] = AM_bin_noplot(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelChromatic(valid),15,5);
    hl13 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{chromatic} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 4;
    scatter(Ha1.dayGEPday,Ha1.dayGEPdaymodelSigmoidGRIVI,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = Ha1.dayGEPday>1 & Ha1.dayGEPdaymodelSigmoidGRIVI>1 & Ha1.dayGEPday<maxGEPday &...
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodelSigmoidGRIVI);
    % check4 = Ha1.dayGEPday > 10 & Ha1.dayGEPdaymodelLeafAge < 1;
    fitResults = polyfit(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelSigmoidGRIVI(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelSigmoidGRIVI(valid),15);
    % [ix,iy] = AM_bin_noplot(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelSigmoidGRIVI(valid),15,5);
    hl14 = scatter(ix(:,2),iy,50,'^','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{sigmoid} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 5;
    scatter(Ha1.dayGEPday,Ha1.dayGEPdaymodelHockey,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = Ha1.dayGEPday>1  & Ha1.dayGEPdaymodelHockey>1 & Ha1.dayGEPday<maxGEPday &...
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodelHockey);
    % check3 = Ha1.dayGEPday > 10 & Ha1.dayGEPdaymodelHockey < 1;
    fitResults = polyfit(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelHockey(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelHockey(valid),15);
    % [ix,iy] = AM_bin_noplot(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelHockey(valid),15,5);
    hl15 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{hockey} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 6;
    scatter(Ha1.dayGEPday,Ha1.dayGEPdaymodelGate,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = Ha1.dayGEPday>1  & Ha1.dayGEPdaymodelGate>1 & Ha1.dayGEPday<maxGEPday &...
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodelGate);
    % check3 = Ha1.dayGEPday > 10 & Ha1.dayGEPdaymodelGate < 1;
    fitResults = polyfit(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelGate(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelGate(valid),15);
    % [ix,iy] = AM_bin_noplot(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelGate(valid),15,5);
    hl16 = scatter(ix(:,2),iy,50,'d','MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);
    text(x4(1),y4(end-count),['GEP_{gate} = ', num2str(fitResults(1),'%.2f'),'GEP_{obs}+',num2str(fitResults(2),'%.2f')])

    count = 7;
    scatter(Ha1.dayGEPday,Ha1.dayGEPdaymodelGateGnBw,5,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
    valid = Ha1.dayGEPday>1  & Ha1.dayGEPdaymodelGateGnBw>1 & Ha1.dayGEPday<maxGEPday &...
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodelGateGnBw);
    % check3 = Ha1.dayGEPday > 10 & Ha1.dayGEPdaymodelGate < 1;
    fitResults = polyfit(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelGateGnBw(valid),fittypesArray-1);
    y0 = polyval(fitResults,x0);
    plot(x0,y0,'-','Color',color_mtx(count,:));
    [ix,iy] = AM_class_eq_size(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelGateGnBw(valid),15);
    % [ix,iy] = AM_bin_noplot(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelGate(valid),15,5);
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
    y = [Ha1.day_recurrentGEPday-Ha1.day_recurrent_stdGEPday,2.*Ha1.day_recurrent_stdGEPday];
    h = area(Ha1.daydate,y);       set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    % set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
    hold on;
    hl2 = plot(Ha1.daydate,Ha1.day_recurrentGEPdayGoley,'-','LineWidth',1,'color',[0.5 0.5 0.5]); hold on;
    % hl3 = plot(Ha1.daydate,Ha1.dayGEPday,'-','LineWidth',1,'color',[0.3 0.3 0.3 ]); hold on;
    hl4 = scatter(Ha1.daydate,smoothdata(Ha1.dayGEPday,'movmean',1),10,'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.3 0.3 0.3],...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl6 = scatter(Ha1.daydate,Ha1.dayGEPdaymodelLeafStage,10,'MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    % hl5 = scatter(Ha1.daydate(check),Ha1.dayGEPdaymodelLeafStage(check),20,'MarkerFaceColor','r',...
    %     'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
    ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month(1:2:end);
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[ROI.daydate(1) Ha1.daydate(end)],...
        'FontSize',12,'XMinorGrid','on','XTick',Ha1.month(1:12:end));    %'XTickLabelColor',[0. 0. 0.7 ]
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',14);   xtickangle(0);   box on;   grid on;
    legend([hl2,hl4,hl6],'historical','obs','Leaf Stage')

    v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    figure('color','white','Position',[50 50 1600 400],'units','inches');
    y = [Ha1.day_recurrentGEPday-Ha1.day_recurrent_stdGEPday,2.*Ha1.day_recurrent_stdGEPday];
    h = area(Ha1.daydate,y);       set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    % set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
    hold on;
    hl2 = plot(Ha1.daydate,Ha1.day_recurrentGEPdayGoley,'-','LineWidth',1,'color',[0.5 0.5 0.5]); hold on;
    % hl3 = plot(Ha1.daydate,Ha1.dayGEPday,'-','LineWidth',1,'color',[0.3 0.3 0.3 ]); hold on;
    hl4 = scatter(Ha1.daydate,smoothdata(Ha1.dayGEPday,'movmean',1),10,'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.3 0.3 0.3],...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl6 = scatter(Ha1.daydate,Ha1.dayGEPdaymodelLeafAge,10,'MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    % hl3 = plot(Ha1.daydate,Ha1.dayGEPdaymodelLeafAge,'-','LineWidth',.5,'color',color_mtx(2,:)); hold on;
    hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
    ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month(1:2:end);
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[ROI.daydate(1) Ha1.daydate(end)],...
        'FontSize',12,'XMinorGrid','on','XTick',Ha1.month(1:12:end));    %'XTickLabelColor',[0. 0. 0.7 ]
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',14);   xtickangle(0);   box on;   grid on;
    legend([hl2,hl4,hl6],'historical','obs','Leaf Age')

    v1 = 0;                         v2 = 32;       v3 = v1:((v2-v1)/4):v2;
    figure('color','white','Position',[50 50 1600 400],'units','inches');
    y = [Ha1.day_recurrentGEPday-Ha1.day_recurrent_stdGEPday,2.*Ha1.day_recurrent_stdGEPday];
    h = area(Ha1.daydate,y);       set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    % set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[Ha1.daydate(ind(1)) Ha1.daydate(ind(end))],'FontSize',16,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
    hold on;
    hl2 = plot(Ha1.daydate,Ha1.day_recurrentGEPdayGoley,'-','LineWidth',1,'color',[0.5 0.5 0.5]); hold on;
    % hl3 = plot(Ha1.daydate,Ha1.dayGEPday,'-','LineWidth',1,'color',[0.3 0.3 0.3 ]); hold on;
    hl4 = scatter(Ha1.daydate,smoothdata(Ha1.dayGEPday,'movmean',1),10,'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.3 0.3 0.3],...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl5 = scatter(Ha1.daydate,Ha1.dayGEPdaymodelChromatic,10,'MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hl6 = scatter(Ha1.daydate,Ha1.dayGEPdaymodelSigmoidGRIVI,10,'MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(4,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.2);
    hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.3]);
    ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = Ha1.month(1:2:end);
    set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[ROI.daydate(1) Ha1.daydate(end)],...
        'FontSize',12,'XMinorGrid','on','XTick',Ha1.month(1:12:end));    %'XTickLabelColor',[0. 0. 0.7 ]
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',14);   xtickangle(0);   box on;   grid on;
    % legend([hl2,hl4,hl6],'historical','obs','Chromatic')

end

% .........................................................................
%% test
% .........................................................................
% % % trains the model on all years except one -iterates, and saves the parameters.
% % % looks at how the temperature and other parameters shift depending on which year is excluded.
if flag_model_test_chromatic == 1
    [Ha1.daydateY,Ha1.daydateM,Ha1.daydateD] = datevec(Ha1.daydate);
    Ha1.years = unique(Ha1.daydateY);
    modelResultsChromatic = struct();
    windowSmooth = 11;

    % Final QA for indices
    iy = Ha1.ROIgcc;
    iy(Ha1.ROIgcc<0.35) = NaN;   %Ha1.ROIrcc(Ha1.daydate>datetime(2021,12,31)) = NaN;
    Ha1.ROIgccQA = iy;            %Ha1.ROIrccQA(ind) = ix;    Ha1.ROIgccQA = iy;            %Ha1.ROIgccQA(ind) = ix;
    [~,Ha1.ROIgccQA] = AM_spike_detection(Ha1.ROIgccQA,3);
    % Ha1.ROIgccQA = FN_fillVI(Ha1.daydate,iy);

    iy = Ha1.ROIrcc;
    iy(Ha1.ROIrcc<0.28) = NaN;   %Ha1.ROIrcc(Ha1.daydate>datetime(2021,12,31)) = NaN;
    Ha1.ROIrccQA = iy;            %Ha1.ROIrccQA(ind) = ix;
    [~,Ha1.ROIrccQA] = AM_spike_detection(Ha1.ROIrccQA,3);
    iy = smoothdata(Ha1.ROIrccQA,'movmean',windowSmooth);
    Ha1.ROIrccQA = FN_fillVI(Ha1.daydate,iy);

    for ix = 1:length(Ha1.years)
        currentYear = Ha1.years(ix); display(currentYear);
        % if currentYear==2018;   currentYear = currentYear+1;   ix = ix+1;  end
        if flag_chromaticFixMeteo == 0
            params = [22, 0, 32, 1, 1];
            lb = [18, -5, 30, 0.01, 0.01];
            ub = [28, 8, 40, 6, 6];
        else
            params = [19, -5, 32, 1, 1];
            lb = [18, -5.01, 38.99, 0.01, 0.01];  % realistic lower bounds
            ub = [28, -4.99, 39.01, 6, 6];        % realistic upper bounds
        end

        StartGrowing = days(GCC.BegTdate-Ha1.daydate(1));
        EndGrowing   = days(GCC.EndTdate-Ha1.daydate(1));
        counter = (1:1:(length(Ha1.daydate)))';

        commonFilters = isfinite(Ha1.dayGEPday) & ...
            isfinite(Ha1.ROIgccQA) & isfinite(Ha1.ROIrccQA) & ...
            isfinite(Ha1.daytairday) & isfinite(Ha1.dayPARday) & (~isnan(Ha1.dayGEPday)) & ...
            (Ha1.dayPARday > 0) & (Ha1.dayGEPday > 0);

        indTrain = find((Ha1.daydateY ~= currentYear) & commonFilters);
        indTest  = find((Ha1.daydateY == currentYear) & commonFilters);

        % Optimization
        if length(indTrain)>100 && length(indTest)>100
            foldObj = @(p) (FN_computeGEPchromatic(p, counter(indTrain), ...
                Ha1.dayPARday(indTrain), Ha1.daytairday(indTrain), Ha1.ROIgccQA(indTrain), ...
                Ha1.ROIrccQA(indTrain), StartGrowing, EndGrowing, 1) - Ha1.dayGEPday(indTrain)) .* ...
                (sqrt(abs(Ha1.dayGEPday(indTrain))) + 0.25);

            [best_params, ~, res_fold, ~, ~, ~, J_fold] = lsqnonlin(foldObj, params, lb, ub, opts);
            % to convert the jacobian here to avoid crash
            J_dense = full(J_fold);

            % Evaluation
            gepPredTest = FN_computeGEPchromatic(best_params, counter(indTest), ...
                Ha1.dayPARday(indTest), Ha1.daytairday(indTest), Ha1.ROIgccQA(indTest), ...
                Ha1.ROIrccQA(indTest), StartGrowing, EndGrowing, 1);

            SGStest = StartGrowing(year(GCC.BegTdate) == currentYear);
            SGStest(isnan(SGStest)) = days(datetime(currentYear,1,1)-Ha1.daydate(1));
            EGStest = EndGrowing(year(GCC.EndTdate) == currentYear);
            EGStest(isnan(EGStest)) = days(datetime(currentYear,12,31)-Ha1.daydate(1));
            % Calculate Prediction Uncertainty (Margin)
            % ci gives parameter bounds; we use nlpredci for prediction bounds
            [~, delta] = nlpredci(@(p, x) FN_computeGEPchromatic(p, counter(indTest), ...
                Ha1.dayPARday(indTest), Ha1.daytairday(indTest), Ha1.ROIgccQA(indTest), ...
                Ha1.ROIrccQA(indTest), SGStest, EGStest, 1), ...
                counter(indTest), best_params, res_fold, 'jacobian', J_dense);

            % Calculate 95% Confidence Intervals for the parameters
            % p_ci will be a 5x2 matrix: [lower_bound, upper_bound] for each of your 5 parameters
            p_ci = nlparci(best_params, res_fold, 'jacobian', J_dense);

            % Calculate the 'margin' or standard error for each parameter
            p_error = (p_ci(:,2) - p_ci(:,1)) / 2;

            % Store Results
            modelResultsChromatic(ix).year = currentYear;
            modelResultsChromatic(ix).obs  = Ha1.dayGEPday(indTest);
            modelResultsChromatic(ix).pred = gepPredTest;
            modelResultsChromatic(ix).delta = delta;      % CI 'margin'
            modelResultsChromatic(ix).x = counter(indTest);
            modelResultsChromatic(ix).testRMSE = sqrt(mean((gepPredTest - Ha1.dayGEPday(indTest)).^2));
            modelResultsChromatic(ix).p_val = best_params;     % optimized parameters
            modelResultsChromatic(ix).p_ci  = p_ci;       % [lb, ub] for each parameter
            modelResultsChromatic(ix).p_err = p_error;    % +/- margin
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
    fprintf('***                                                   ***\n');

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
        xCounter  = modelResultsChromatic(ix).x;       xDate  = xCounter - min(xCounter) + 1;

        yModel = modelResultsChromatic(ix).pred;    yObs  = modelResultsChromatic(ix).obs;
        margin = modelResultsChromatic(ix).delta;

        fill([xDate; flipud(xDate)], [yModel + margin; flipud(yModel - margin)], ...
            [0.85 0.85 0.85], 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        hold on;
        plot(xDate, yObs, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'k');
        scatter(xDate, yModel, 8, 'MarkerFaceColor', color_mtx(1,:), 'MarkerFaceAlpha', 0.5);
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
    title(sprintf('Ha1 LOYO Validation (R^2 = %.2f, RMSE = %.2f)', ...
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
    [Ha1.dayGEPdaymodelChromaticLOYO] = FN_computeGEPchromatic(avg_p_val,counter,...
        Ha1.dayPARday, Ha1.daytairday, Ha1.ROIgccQA, Ha1.ROIrccQA, StartGrowing, EndGrowing, 1);
    valid = Ha1.dayGEPday>1 & Ha1.dayGEPdaymodelChromaticLOYO>1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodelChromaticLOYO);
    r = corr(Ha1.dayGEPdaymodelChromaticLOYO(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodelChromaticLOYO(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodelChromaticLOYO(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodelChromaticLOYO(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelChromaticLOYO(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    save ('modelResultsHa1.mat','modelResultsChromatic','-append')
end

% ........................................................................
%% Gatekeeper
% ........................................................................
if flag_model_test_gatekeeper == 1
    [Ha1.daydateY,Ha1.daydateM,Ha1.daydateD] = datevec(Ha1.daydate);
    Ha1.years = unique(Ha1.daydateY);
    modelResults = struct();

    % Final QA for indices
    iy = Ha1.ROIgcc;
    iy(Ha1.ROIgcc<0.35) = NaN;   %Ha1.ROIrcc(Ha1.daydate>datetime(2021,12,31)) = NaN;
    Ha1.ROIgccQA = iy;            %Ha1.ROIrccQA(ind) = ix;    Ha1.ROIgccQA = iy;            %Ha1.ROIgccQA(ind) = ix;
    [~,Ha1.ROIgccQA] = AM_spike_detection(Ha1.ROIgccQA,3);
    % Ha1.ROIgccQA = FN_fillVI(Ha1.daydate,iy);

    for ix = 1:length(Ha1.years)
        currentYear = Ha1.years(ix); display(currentYear);
        if flag_gatewayFixMeteo == 0
            params = [prctile(Ha1.dayGEPday, 98), 4.5, 0.5,  4.5, 0.5, 100, 20, 20];
            lb     = [prctile(Ha1.dayGEPday, 95), 2, 0.1, 2, 0.1, 10, 15, 10];
            ub     = [max(Ha1.dayGEPday,[],'omitnan'), 8, 1, 8, 1, 400, 25, 30];
        else
            % Here I am just "fixing" the parameters similar to the FN_computeGEPgatekeeperGCC
            params = [prctile(Ha1.dayGEPday, 98), 4.5, 0.5,  4.5, 0.5, 249, 24, 15];
            lb     = [prctile(Ha1.dayGEPday, 95), 2, 0.1, 2, 0.1, 248.99, 23.99, 14.99];
            ub     = [max(Ha1.dayGEPday,[],'omitnan'), 8, 1, 8, 1, 249.01, 24.01, 15.01];
        end

        commonFilters = ((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgccQA))&...
            (~isnan(Ha1.daytairday))&(~isnan(Ha1.dayPARday))&(Ha1.dayGEPday>0)&...
            (isfinite(Ha1.dayGEPday)));

        indTrain = find((Ha1.daydateY ~= currentYear) & commonFilters);
        indTest  = find((Ha1.daydateY == currentYear) & commonFilters);

        % Optimization
        if length(indTrain)>100 && length(indTest)>100
            foldObj = @(p) (FN_computeGEPphotosynthesisGCCgn2br(p, counter(indTrain), ...
                Ha1.dayPARday(indTrain),Ha1.daytairday(indTrain),...
                Ha1.ROIgccQA(indTrain),1) - Ha1.dayGEPday(indTrain));

            [best_params, ~, res_fold, ~, ~, ~, J_fold] = lsqnonlin(foldObj, params, lb, ub, opts);
            % to convert the jacobian here to avoid crash
            J_dense = full(J_fold);

            % Evaluation
            gepPredTest = FN_computeGEPphotosynthesisGCCgn2br(best_params, counter(indTest), ...
                Ha1.dayPARday(indTest),Ha1.daytairday(indTest),Ha1.ROIgccQA(indTest),1);

            SGStest = StartGrowing(year(GCC.BegTdate) == currentYear);
            SGStest(isnan(SGStest)) = days(datetime(currentYear,1,1)-Ha1.daydate(1));
            EGStest = EndGrowing(year(GCC.EndTdate) == currentYear);
            EGStest(isnan(EGStest)) = days(datetime(currentYear,12,31)-Ha1.daydate(1));
            % Calculate Prediction Uncertainty (Margin)
            % ci gives parameter bounds; we use nlpredci for prediction bounds
            [~, delta] = nlpredci(@(p, x) FN_computeGEPphotosynthesisGCCgn2br(p, counter(indTest), ...
                Ha1.dayPARday(indTest), Ha1.daytairday(indTest), Ha1.ROIgccQA(indTest),1), ...
                counter(indTest), best_params, res_fold, 'jacobian', J_dense);

            % Calculate 95% Confidence Intervals for the parameters
            % p_ci will be a 5x2 matrix: [lower_bound, upper_bound] for each of your 5 parameters
            p_ci = nlparci(best_params, res_fold, 'jacobian', J_dense);

            % Calculate the 'margin' or standard error for each parameter
            p_error = (p_ci(:,2) - p_ci(:,1)) / 2;

            % Store Results
            modelResults(ix).year = currentYear;
            modelResults(ix).obs  = Ha1.dayGEPday(indTest);
            modelResults(ix).pred = gepPredTest;
            modelResults(ix).delta = delta; % This is your CI 'margin'
            modelResults(ix).x = counter(indTest);
            modelResults(ix).testRMSE = sqrt(mean((gepPredTest - Ha1.dayGEPday(indTest)).^2));
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
    fprintf('***                                                   ***\n');

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
    title(sprintf('Ha1 LOYO Validation (R^2 = %.2f, RMSE = %.2f)', ...
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
    [Ha1.dayGEPdaymodelGateLOYO] = FN_computeGEPphotosynthesisGCCgn2br(avg_p_val,counter,...
        Ha1.dayPARday, Ha1.daytairday, Ha1.ROIgccQA, 1);
    valid = Ha1.dayGEPday>1 & Ha1.dayGEPdaymodelGateLOYO>1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodelGateLOYO);
    r = corr(Ha1.dayGEPdaymodelGateLOYO(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodelGateLOYO(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodelGateLOYO(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodelGateLOYO(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodelGateLOYO(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    save ('modelResultsHa1.mat','modelResults','-append')
    save('Ha1.mat', 'Ha1', '-append');
end

% .........................................................................
%% visualize
% .........................................................................
if flag_visualize == 1
    [Ha1.weekROIgccQA]  = AM_week2day_rs(Ha1.ROIgccQA,Ha1.daydate);
    [Ha1.eightROIgccQA] = AM_eightday_rs(Ha1.ROIgccQA,Ha1.daydate);

    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    plot(Ha1.weekROIgccQA,Ha1.weekGEPday,'-');
    plot(Ha1.weekROIgccQA,Ha1.weekGEPday,'.');
    hold on; plot(Ha1.weekROIgccQA(Ha1.weekM<7),Ha1.weekGEPday(Ha1.weekM<7),'.r');
    hold on; plot(Ha1.weekROIgccQA(Ha1.weekY==2013),Ha1.weekGEPday(Ha1.weekY==2013),'-g');
    hold on; plot(Ha1.weekROIgccQA(Ha1.weekY==2016),Ha1.weekGEPday(Ha1.weekY==2016),'-k');

    % Hockey stick
    idx = ~isnan(Ha1.eightROIgccQA) & ~isnan(Ha1.eightGEPday) & (Ha1.eightROIgccQA >= 0.0);
    x_data = Ha1.eightROIgccQA(idx);
    y_data = Ha1.eightGEPday(idx);
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
    fprintf('treshold (X_0): %.2f\n', threshold_opt);
    fprintf('model R-squared:     %.4f\n', rsquared);
    figure('color','white'); hold on;
    scatter(x_data, y_data, 15, 'o','MarkerFaceColor',color_mtx(1,:),'MarkerEdgeColor',color_mtx_dark(1,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    x_plot = linspace(0.32, max(x_data), 100);    y_plot = model(params, x_plot);
    plot(x_plot, y_plot, 'r', 'LineWidth', 2.5);
    xline(threshold_opt, '--', ['Threshold: ' num2str(threshold_opt, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .8]);
    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(min(Ha1.eightROIgccQA,[],'omitnan'),15,site_name,'FontSize',16)

    %%
    [Ha1.weekGRIVInorm]  = AM_week2day_rs(Ha1.dayGRIVInorm,Ha1.daydate);
    [Ha1.eightGRIVInorm] = AM_eightday_rs(Ha1.dayGRIVInorm,Ha1.daydate);

    % Hockey stick
    idx = ~isnan(Ha1.eightGRIVInorm) & ~isnan(Ha1.eightGEPday);
    x_data = Ha1.eightGRIVInorm(idx);
    y_data = Ha1.eightGEPday(idx);
    % Define the hockey model
    % params(1) is alpha (slope), params(2) is beta (threshold)
    model = @(params, x) params(1) * max(0, x - params(2));
    initial_guess = [200, 0.1];
    lower_bounds  = [0, 0.0];   % Slope must be positive, threshold at least 0.30
    upper_bounds  = [1000, 0.2]; % Threshold shouldn't exceed 0.40 for this data
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
    x_plot = linspace(0.0, max(x_data), 100);    y_plot = model(params, x_plot);
    plot(x_plot, y_plot, 'r', 'LineWidth', 2.5);
    xline(threshold_opt, '--', ['Threshold: ' num2str(threshold_opt, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .8]);
    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(min(Ha1.eightGRIVInorm,[],'omitnan'),15,site_name,'FontSize',16)

    %% gatekeeper
    color_mtx = jet(12);
    Ha1.eightGCCnorm = AM_eightday_rs(Ha1.dayGCCnorm,Ha1.daydate);
    % idx = ~isnan(Ha1.eightGCCnorm) & ~isnan(Ha1.eightGEPday);
    % x_data = Ha1.eightGCCnorm(idx);
    % y_data = Ha1.eightGEPday(idx);
    idx = ~isnan(Ha1.dayGCCnorm) & ~isnan(Ha1.dayGEPday);
    x_data = Ha1.dayGCCnorm(idx);
    y_data = Ha1.dayGEPday(idx);
    z_data = Ha1.dayM(idx);

    x0 = Ha1modelParameter(6).parameters(3);

    fLight= 1;
    fTemp = 1;
    x_plot = linspace(0, 1, 200)';  iy = (1:200)';
    y_plot = FN_computeGEPgatekeeperGCCmeteo(Ha1modelParameter(6).parameters,iy,...
        (iy.*0+1300),(iy.*0+Ha1modelParameter(6).parameters(5)),...
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
    idx = ~isnan(Ha1.dayGCCnorm) & ~isnan(Ha1.dayGEPday);
    z_data = round(Ha1.dayLength(idx));
    color_mtx = jet(length(unique(z_data))+1);
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    count = 1;
    for ix=(min(z_data)):round(max(z_data))
        ind = find(z_data==ix);
        scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        text(0.1,35-ix.*1.5,['Day length: ' num2str(ix)]);
        plot(0.05,35-ix.*1.5,'o','MarkerFaceColor',color_mtx(count,:),...
            'MarkerEdgeColor',color_mtx(count,:));
        count = count+1;
    end
    plot(x_plot, y_plot, 'b', 'LineWidth', 2.5);
    xline(x0, '--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .8]);
    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(0.8,33,site_name,'FontSize',16)
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 35]);
    set(gca, 'FontSize', 14);

    z_data = round(Ha1.daySZA(idx));
    color_mtx = jet(length(unique(z_data)));
    figure('Color', 'w', 'Position', [100, 100, 800, 500]); hold on;
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
    text(0.8,33,site_name,'FontSize',16)
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 35]);
    set(gca, 'FontSize', 14);

    %% Two sigmoids
    z_data = round(Ha1.dayM(idx));
    color_mtx = jet(length(unique(z_data))+1);
    figure('Color', 'w', 'Position', [100, 100, 600, 500]); hold on;
    count = 1;
    for ix=(min(z_data)):round(max(z_data))
        ind = find(z_data==ix);
        if length(ind)>2
            scatter(x_data(ind), y_data(ind), 15, 'o','MarkerFaceColor',color_mtx(count,:),...
                'MarkerEdgeColor',color_mtx(count,:),'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
            text(-0.05,35-ix.*1.5,datestr(datetime(0,ix,1),'mmm'));
            plot(-0.08,35-ix.*1.5,'o','MarkerFaceColor',color_mtx(count,:),...
                'MarkerEdgeColor',color_mtx(count,:));
        end
        count = count+1;
    end
    best_params = [Ha1modelParameter(7).parameters(1:3),Ha1modelParameter(7).parameters(6:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1300),...
        (iy.*0+Ha1modelParameter(7).parameters(7)),x_plot,1);
    x0 = Ha1modelParameter(7).parameters(3);
    plot(x_plot, y_plot, 'color',[0 0 0] ,'LineWidth', 2.5);
    xline(x0,'--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .0]);
    hold on;

    best_params = [Ha1modelParameter(7).parameters(1),Ha1modelParameter(7).parameters(4:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1300),...
        (iy.*0+Ha1modelParameter(7).parameters(7)),x_plot,1);
    x0 = Ha1modelParameter(7).parameters(5);
    plot(x_plot, y_plot, 'color',[0.5 0.5 .5], 'LineWidth', 2.5);
    xline(x0, '--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0.5 0.5 .5]);

    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(0.5,33,site_name,'FontSize',16)
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 35]);
    set(gca, 'FontSize', 14);

    %% Two sigmoids
    idx = ~isnan(Ha1.dayGCCnorm) & ~isnan(Ha1.dayGEPday);
    z_data = round(Ha1.dayLength(idx));
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
    best_params = [Ha1modelParameter(7).parameters(1:3),Ha1modelParameter(7).parameters(6:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1300),...
        (iy.*0+Ha1modelParameter(7).parameters(7)),x_plot,1);
    x0 = Ha1modelParameter(7).parameters(3);
    plot(x_plot, y_plot, 'color',[0 0 0] ,'LineWidth', 2.5);
    xline(x0,'--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .0]);
    hold on;

    best_params = [Ha1modelParameter(7).parameters(1),Ha1modelParameter(7).parameters(4:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1300),...
        (iy.*0+Ha1modelParameter(7).parameters(7)),x_plot,1);
    x0 = Ha1modelParameter(7).parameters(5);
    plot(x_plot, y_plot, 'color',[0.5 0.5 .5], 'LineWidth', 2.5);
    xline(x0, '--', ['Threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0.5 0.5 .5]);

    set(gca, 'FontSize', 14); box on; grid on;
    ylabel('GEP_{daytime} (gC m^{-2} d^{-1})'); xlabel('GCC');
    text(0.8,33,site_name,'FontSize',16)
    grid on; box on;
    xlim([-0.1 1.1]); ylim([0 35]);
    set(gca, 'FontSize', 14);

    % test_output = residualFunction(params);
    % bad_idx = find(~isfinite(test_output));
    % fprintf('There are %d non-finite values.\n', length(bad_idx));
    % disp('First few bad values are at indices:');

    %% Two sigmoids month
    z_data = round(Ha1.dayM(idx));
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
    best_params = [Ha1modelParameter(7).parameters(1:3),Ha1modelParameter(7).parameters(6:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1000),...
        (iy.*0+Ha1modelParameter(7).parameters(7)),x_plot,1);
    x0 = Ha1modelParameter(7).parameters(3);
    plot(x_plot, y_plot, 'color',[0 0 0] ,'LineWidth', 2.5);
    xline(x0,'--', ['X_0 threshold: ' num2str(x0, '%.3f')], 'LabelVerticalAlignment', 'top','Color', ...
        [0 0 .0]);
    text(x_plot(100)+.05, y_plot(100),'green-up','Color','k','FontSize',10);
    hold on;

    best_params = [Ha1modelParameter(7).parameters(1),Ha1modelParameter(7).parameters(4:8)];
    y_plot = FN_computeGEPgatekeeperGCCmeteo(best_params,iy,(iy.*0+1000),...
        (iy.*0+Ha1modelParameter(7).parameters(7)),x_plot,1);
    x0 = Ha1modelParameter(7).parameters(5);
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
    idx = ~isnan(Ha1.dayGCCnorm) & ~isnan(Ha1.dayGEPday);
    x_data = Ha1.dayGCCnorm(idx);
    y_data = -Ha1.dayNEE(idx);
    z_data = round(Ha1.dayM(idx));
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
%% using fixed deciduous parameters
% .........................................................................
if flag_chromaticFixMeteo == 1
    params = [20.0,	-5.0,	39.7,	0.039,	0.025];
    StartGrowing = days(GCC.BegTdate-Ha1.daydate(1));
    EndGrowing   = days(GCC.EndTdate-Ha1.daydate(1));
    counter = (1:1:(length(Ha1.daydate)))';
    gepPredTest = FN_computeGEPchromatic(params, counter, ...
        Ha1.dayPARday, Ha1.daytairday, Ha1.ROIgccQA, ...
        Ha1.ROIrccQA, StartGrowing, EndGrowing, 1);
    valid = Ha1.dayGEPday>1 & gepPredTest>1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(gepPredTest);
    r = corr(gepPredTest(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((gepPredTest(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - gepPredTest(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - gepPredTest(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),gepPredTest(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nstats chromatic fixed [final] parameters:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);
end

if  flag_gatewayFixMeteo == 1
    params = [26.5,	2.252,	0.757,	5.068,	0.356,	249,	24.4,	15.5];
    gepPredTest = FN_computeGEPphotosynthesisGCCgn2br(params, counter, ...
        Ha1.dayPARday,Ha1.daytairday,Ha1.ROIgccQA,1);
    valid = Ha1.dayGEPday>1 & gepPredTest>1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(gepPredTest);
    r = corr(gepPredTest(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((gepPredTest(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - gepPredTest(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - gepPredTest(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),gepPredTest(valid)));
    Rsquared = (Rsquared(1,2))^2;
    fprintf('\nstats gateway fixed [final] parameters:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);
end

%% Taylor
if flag_Taylor==1
    Ha1.eightGEPdaymodelLeafStage = AM_eightday_rs(Ha1.dayGEPdaymodelLeafStage,Ha1.daydate);
    Ha1.eightGEPdaymodelLeafStage = AM_fill(Ha1.eightGEPdaymodelLeafStage);
    [Ha1.weekGEPdaymodelLeafStage,~,~,~,~,Ha1.week_stddayGEPdaymodelLeafStage]  = AM_week2day_rs(Ha1.dayGEPdaymodelLeafStage,Ha1.daydate);
    Ha1.weekGEPdaymodelLeafStage  = AM_fill(Ha1.weekGEPdaymodelLeafStage);
    Ha1.monthGEPdaymodelLeafStage = AM_month(Ha1.dayGEPdaymodelLeafStage,Ha1.daydate);
    Ha1.monthGEPdaymodelLeafStage = AM_fill(Ha1.monthGEPdaymodelLeafStage);

    Ha1.eightGEPdaymodelLeafAge = AM_eightday_rs(Ha1.dayGEPdaymodelLeafAge,Ha1.daydate);
    Ha1.eightGEPdaymodelLeafAge = AM_fill(Ha1.eightGEPdaymodelLeafAge);
    [Ha1.weekGEPdaymodelLeafAge,~,~,~,~,Ha1.week_stdGEPdaymodelLeafAge]  = AM_week2day_rs(Ha1.dayGEPdaymodelLeafAge,Ha1.daydate);
    Ha1.weekGEPdaymodelLeafAge  = AM_fill(Ha1.weekGEPdaymodelLeafAge);
    Ha1.monthGEPdaymodelLeafAge = AM_month(Ha1.dayGEPdaymodelLeafAge,Ha1.daydate);
    Ha1.monthGEPdaymodelLeafAge = AM_fill(Ha1.monthGEPdaymodelLeafAge);

    Ha1.eightGEPdaymodelChromatic = AM_eightday_rs(Ha1.dayGEPdaymodelChromatic,Ha1.daydate);
    Ha1.eightGEPdaymodelChromatic = AM_fill(Ha1.eightGEPdaymodelChromatic);
    [Ha1.weekGEPdaymodelChromatic,~,~,~,~,Ha1.week_stdGEPdaymodelChromatic]  = AM_week2day_rs(Ha1.dayGEPdaymodelChromatic,Ha1.daydate);
    Ha1.weekGEPdaymodelChromatic  = AM_fill(Ha1.weekGEPdaymodelChromatic);
    Ha1.monthGEPdaymodelChromatic = AM_month(Ha1.dayGEPdaymodelChromatic,Ha1.daydate);
    Ha1.monthGEPdaymodelChromatic = AM_fill(Ha1.monthGEPdaymodelChromatic);

    Ha1.eightGEPdaymodelSigmoidGRIVI = AM_eightday_rs(Ha1.dayGEPdaymodelSigmoidGRIVI,Ha1.daydate);
    Ha1.eightGEPdaymodelSigmoidGRIVI = AM_fill(Ha1.eightGEPdaymodelSigmoidGRIVI);
    [Ha1.weekGEPdaymodelSigmoidGRIVI,~,~,~,~,Ha1.week_stdGEPdaymodelSigmoidGRIVI]  = AM_week2day_rs(Ha1.dayGEPdaymodelSigmoidGRIVI,Ha1.daydate);
    Ha1.weekGEPdaymodelSigmoidGRIVI  = AM_fill(Ha1.weekGEPdaymodelSigmoidGRIVI);
    Ha1.monthGEPdaymodelSigmoidGRIVI = AM_month(Ha1.dayGEPdaymodelSigmoidGRIVI,Ha1.daydate);
    Ha1.monthGEPdaymodelSigmoidGRIVI = AM_fill(Ha1.monthGEPdaymodelSigmoidGRIVI);

    Ha1.eightGEPdaymodelHockey = AM_eightday_rs(Ha1.dayGEPdaymodelHockey,Ha1.daydate);
    Ha1.eightGEPdaymodelHockey = AM_fill(Ha1.eightGEPdaymodelHockey);
    [Ha1.weekGEPdaymodelHockey,~,~,~,~,Ha1.week_stdGEPdaymodelHockey]  = AM_week2day_rs(Ha1.dayGEPdaymodelHockey,Ha1.daydate);
    Ha1.weekGEPdaymodelHockey  = AM_fill(Ha1.weekGEPdaymodelHockey);
    Ha1.monthGEPdaymodelHockey = AM_month(Ha1.dayGEPdaymodelHockey,Ha1.daydate);
    Ha1.monthGEPdaymodelHockey = AM_fill(Ha1.monthGEPdaymodelHockey);

    Ha1.eightGEPdaymodelGate = AM_eightday_rs(Ha1.dayGEPdaymodelGate,Ha1.daydate);
    Ha1.eightGEPdaymodelGate = AM_fill(Ha1.eightGEPdaymodelGate);
    [Ha1.weekGEPdaymodelGate,~,~,~,~,Ha1.week_stdGEPdaymodelGate]  = AM_week2day_rs(Ha1.dayGEPdaymodelGate,Ha1.daydate);
    Ha1.weekGEPdaymodelGate  = AM_fill(Ha1.weekGEPdaymodelGate);
    Ha1.monthGEPdaymodelGate = AM_month(Ha1.dayGEPdaymodelGate,Ha1.daydate);
    Ha1.monthGEPdaymodelGate = AM_fill(Ha1.monthGEPdaymodelGate);

    Ha1.eightGEPdaymodelGateGnBw = AM_eightday_rs(Ha1.dayGEPdaymodelGateGnBw,Ha1.daydate);
    Ha1.eightGEPdaymodelGateGnBw = AM_fill(Ha1.eightGEPdaymodelGateGnBw);
    [Ha1.weekGEPdaymodelGateGnBw,~,~,~,~,Ha1.week_stdGEPdaymodelGateGnBw]  = AM_week2day_rs(Ha1.dayGEPdaymodelGateGnBw,Ha1.daydate);
    Ha1.weekGEPdaymodelGateGnBw  = AM_fill(Ha1.weekGEPdaymodelGateGnBw);
    Ha1.monthGEPdaymodelGateGnBw = AM_month(Ha1.dayGEPdaymodelGateGnBw,Ha1.daydate);
    Ha1.monthGEPdaymodelGateGnBw = AM_fill(Ha1.monthGEPdaymodelGateGnBw);

    % .........................................................................
    %% Taylor
    % .........................................................................
    Ha1day_R_taylor=NaN(7,1);       Ha1day_STD_taylor=NaN(7,1);       Ha1day_STD_obs=NaN(7,1);
    [Ha1day_R_taylor(1,1),Ha1day_STD_taylor(1,1),Ha1day_STD_obs(1,1)] = AM_Taylor_normalize(Ha1.dayGEPday,Ha1.dayGEPdaymodelLeafStage);
    [Ha1day_R_taylor(2,1),Ha1day_STD_taylor(2,1),Ha1day_STD_obs(2,1)] = AM_Taylor_normalize(Ha1.dayGEPday,Ha1.dayGEPdaymodelLeafAge);
    [Ha1day_R_taylor(3,1),Ha1day_STD_taylor(3,1),Ha1day_STD_obs(3,1)] = AM_Taylor_normalize(Ha1.dayGEPday,Ha1.dayGEPdaymodelChromatic);
    [Ha1day_R_taylor(4,1),Ha1day_STD_taylor(4,1),Ha1day_STD_obs(4,1)] = AM_Taylor_normalize(Ha1.dayGEPday,Ha1.dayGEPdaymodelSigmoidGRIVI);
    [Ha1day_R_taylor(5,1),Ha1day_STD_taylor(5,1),Ha1day_STD_obs(5,1)] = AM_Taylor_normalize(Ha1.dayGEPday,Ha1.dayGEPdaymodelHockey);
    [Ha1day_R_taylor(6,1),Ha1day_STD_taylor(6,1),Ha1day_STD_obs(6,1)] = AM_Taylor_normalize(Ha1.dayGEPday,Ha1.dayGEPdaymodelGate);
    [Ha1day_R_taylor(7,1),Ha1day_STD_taylor(7,1),Ha1day_STD_obs(7,1)] = AM_Taylor_normalize(Ha1.dayGEPday,Ha1.dayGEPdaymodelGateGnBw);

    Ha1eight_R_taylor=NaN(7,1);       Ha1eight_STD_taylor=NaN(7,1);       Ha1eight_STD_obs=NaN(7,1);
    [Ha1eight_R_taylor(1,1),Ha1eight_STD_taylor(1,1),Ha1eight_STD_obs(1,1)] = AM_Taylor_normalize(Ha1.eightGEPday,Ha1.eightGEPdaymodelLeafStage);
    [Ha1eight_R_taylor(2,1),Ha1eight_STD_taylor(2,1),Ha1eight_STD_obs(2,1)] = AM_Taylor_normalize(Ha1.eightGEPday,Ha1.eightGEPdaymodelLeafAge);
    [Ha1eight_R_taylor(3,1),Ha1eight_STD_taylor(3,1),Ha1eight_STD_obs(3,1)] = AM_Taylor_normalize(Ha1.eightGEPday,Ha1.eightGEPdaymodelChromatic);
    [Ha1eight_R_taylor(4,1),Ha1eight_STD_taylor(4,1),Ha1eight_STD_obs(4,1)] = AM_Taylor_normalize(Ha1.eightGEPday,Ha1.eightGEPdaymodelSigmoidGRIVI);
    [Ha1eight_R_taylor(5,1),Ha1eight_STD_taylor(5,1),Ha1eight_STD_obs(5,1)] = AM_Taylor_normalize(Ha1.eightGEPday,Ha1.eightGEPdaymodelHockey);
    [Ha1eight_R_taylor(6,1),Ha1eight_STD_taylor(6,1),Ha1eight_STD_obs(6,1)] = AM_Taylor_normalize(Ha1.eightGEPday,Ha1.eightGEPdaymodelGate);
    [Ha1eight_R_taylor(7,1),Ha1eight_STD_taylor(7,1),Ha1eight_STD_obs(7,1)] = AM_Taylor_normalize(Ha1.eightGEPday,Ha1.eightGEPdaymodelGateGnBw);

    Ha1week_R_taylor=NaN(7,1);       Ha1week_STD_taylor=NaN(7,1);       Ha1week_STD_obs=NaN(7,1);
    [Ha1week_R_taylor(1,1),Ha1week_STD_taylor(1,1),Ha1week_STD_obs(1,1)] = AM_Taylor_normalize(Ha1.weekGEPday,Ha1.weekGEPdaymodelLeafStage);
    [Ha1week_R_taylor(2,1),Ha1week_STD_taylor(2,1),Ha1week_STD_obs(2,1)] = AM_Taylor_normalize(Ha1.weekGEPday,Ha1.weekGEPdaymodelLeafAge);
    [Ha1week_R_taylor(3,1),Ha1week_STD_taylor(3,1),Ha1week_STD_obs(3,1)] = AM_Taylor_normalize(Ha1.weekGEPday,Ha1.weekGEPdaymodelChromatic);
    [Ha1week_R_taylor(4,1),Ha1week_STD_taylor(4,1),Ha1week_STD_obs(4,1)] = AM_Taylor_normalize(Ha1.weekGEPday,Ha1.weekGEPdaymodelSigmoidGRIVI);
    [Ha1week_R_taylor(5,1),Ha1week_STD_taylor(5,1),Ha1week_STD_obs(5,1)] = AM_Taylor_normalize(Ha1.weekGEPday,Ha1.weekGEPdaymodelHockey);
    [Ha1week_R_taylor(6,1),Ha1week_STD_taylor(6,1),Ha1week_STD_obs(6,1)] = AM_Taylor_normalize(Ha1.weekGEPday,Ha1.weekGEPdaymodelGate);
    [Ha1week_R_taylor(7,1),Ha1week_STD_taylor(7,1),Ha1week_STD_obs(7,1)] = AM_Taylor_normalize(Ha1.weekGEPday,Ha1.weekGEPdaymodelGateGnBw);

    Ha1month_R_taylor=NaN(7,1);       Ha1month_STD_taylor=NaN(7,1);       Ha1month_STD_obs=NaN(7,1);
    [Ha1month_R_taylor(1,1),Ha1month_STD_taylor(1,1),Ha1month_STD_obs(1,1)] = AM_Taylor_normalize(Ha1.monthGEPday,Ha1.monthGEPdaymodelLeafStage);
    [Ha1month_R_taylor(2,1),Ha1month_STD_taylor(2,1),Ha1month_STD_obs(2,1)] = AM_Taylor_normalize(Ha1.monthGEPday,Ha1.monthGEPdaymodelLeafAge);
    [Ha1month_R_taylor(3,1),Ha1month_STD_taylor(3,1),Ha1month_STD_obs(3,1)] = AM_Taylor_normalize(Ha1.monthGEPday,Ha1.monthGEPdaymodelChromatic);
    [Ha1month_R_taylor(4,1),Ha1month_STD_taylor(4,1),Ha1month_STD_obs(4,1)] = AM_Taylor_normalize(Ha1.monthGEPday,Ha1.monthGEPdaymodelSigmoidGRIVI);
    [Ha1month_R_taylor(5,1),Ha1month_STD_taylor(5,1),Ha1month_STD_obs(5,1)] = AM_Taylor_normalize(Ha1.monthGEPday,Ha1.monthGEPdaymodelHockey);
    [Ha1month_R_taylor(6,1),Ha1month_STD_taylor(6,1),Ha1month_STD_obs(6,1)] = AM_Taylor_normalize(Ha1.monthGEPday,Ha1.monthGEPdaymodelGate);
    [Ha1month_R_taylor(7,1),Ha1month_STD_taylor(7,1),Ha1month_STD_obs(7,1)] = AM_Taylor_normalize(Ha1.monthGEPday,Ha1.monthGEPdaymodelGateGnBw);
    %%
    figure('color','white','position',[300,300,500,500]);
    Name_Taylor={'sn';'la';'ch';'sg';'hk';'gk';'gkx'};   color_mtx = jet(7);
    subplot(2,2,1);
    AM_Taylor_plot_std2(Name_Taylor,Ha1day_R_taylor,Ha1day_STD_taylor,Ha1day_STD_obs,'daily GEP_{daytime} v. model ',color_mtx);
    subplot(2,2,2);
    AM_Taylor_plot_std2(Name_Taylor,Ha1eight_R_taylor,Ha1eight_STD_taylor,Ha1eight_STD_obs,'8-days',color_mtx);
    subplot(2,2,3);
    AM_Taylor_plot_std2(Name_Taylor,Ha1week_R_taylor,Ha1week_STD_taylor,Ha1week_STD_obs,'16-days',color_mtx);
    subplot(2,2,4);
    AM_Taylor_plot_std2(Name_Taylor,Ha1month_R_taylor,Ha1month_STD_taylor,Ha1month_STD_obs,'monthly',color_mtx);
end

% .....................................................................
%% GGC phenology as gatekeeper greenup & browndown segments
% .....................................................................
if flag_normalize==1
    % .....................................................................
    %% Year-by-year normalization
    % .....................................................................
    params = [prctile(Ha1.dayGEPday, 98), 4.5, 0.5,  4.5, 0.5, 100, 22, 20];
    lb     = [prctile(Ha1.dayGEPday, 95), 2, 0.1, 2, 0.1, 10, 18, 10];
    ub     = [max(Ha1.dayGEPday,[],'omitnan'), 8, 1, 8, 1, 400, 28, 30];

    counter = (1:1:(length(Ha1.daydate)))';

    ind = find((~isnan(Ha1.dayGEPday))&(~isnan(Ha1.ROIgccQA))&...
        (~isnan(Ha1.daytairday))&(~isnan(Ha1.dayPARday))&(Ha1.dayGEPday>0)&...
        (isfinite(Ha1.dayGEPday)));

    residualFunction = @(params) (FN_computeGEPphotosynthesisGCCgn2br(params,counter(ind),...
        Ha1.dayPARday(ind), Ha1.daytairday(ind),Ha1.ROIgccQA(ind), 1)...
        - Ha1.dayGEPday(ind));

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    % fprintf('GEP_{max}: %.3f\nSteeepness: %.3f\nSaturation: %.3f\n', best_params);
    fprintf('GEP_{max}: %.3f\nSteeep1: %.3f\nSat1: %.3f\nSteeep2: %.3f\nSat2: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    Ha1modelNormal(1).parameters = best_params;

    [Ha1.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params,counter,...
        Ha1.dayPARday, Ha1.daytairday, Ha1.ROIgccQA, 1);  %, Ha1.dayLength

    % Statistics
    valid = Ha1.dayGEPday>0.1 & Ha1.dayGEPdaymodel>0.1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodel);
    r = corr(Ha1.dayGEPdaymodel(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodel(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    figure('color','white','Position',[50 50 1800 400],'units','inches');
    y = [Ha1.day_recurrentGEPday(ind)-Ha1.day_recurrent_stdGEPday(ind),2.*Ha1.day_recurrent_stdGEPday(ind)];
    h = area(Ha1.daydate(ind),y);     set(gca,'Layer','top');
    set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
    set(h,'BaseValue',0);
    hold on;
    hl1 = plot(Ha1.daydate(ind),Ha1.day_recurrentGEPdayGoley(ind),'-','LineWidth',1,'color',[0.6 0.6 0.6 ]); hold on;
    hl2 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPday(ind),'movmean',5),'-','LineWidth',1,'color',[0.3 0.3 0.3]);
    scatter(Ha1.daydate(ind),Ha1.dayGEPday(ind),10,'o','MarkerFaceColor',[.4 .4 .4],'MarkerEdgeColor',[.4 .4 .4],...
        'MarkerFaceAlpha',.9,'MarkerEdgeAlpha',.9);

    scatter(Ha1.daydate(ind),Ha1.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(7,:),'MarkerEdgeColor',color_mtx_dark(7,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl3 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(7,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = Ha1.month;
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)
    % Ha1.dayGEPdaymodelGateGnBw = Ha1.dayGEPdaymodel;

    %% Normalized
    residualFunction = @(params) (FN_computeGEPphotosynthesisGCCgn2br(params,counter(ind),...
        Ha1.dayPARday(ind), Ha1.daytairday(ind),Ha1.ROIgccQA(ind), 0)...
        - Ha1.dayGEPday(ind));

    % Run optimization
    [best_params, resnorm] = lsqnonlin(residualFunction, params, lb, ub, opts);

    % Print best-fit results
    fprintf('\nBest-fit parameters:\n');
    % fprintf('GEP_{max}: %.3f\nSteeepness: %.3f\nSaturation: %.3f\n', best_params);
    fprintf('GEP_{max}: %.3f\nSteeep1: %.3f\nSat1: %.3f\nSteeep2: %.3f\nSat2: %.3f\nPAR: %.3f\nTopt: %.3f\nTamplitude: %.3f\n', best_params);

    % % Display best-fit parameters
    Ha1modelNormal(2).parameters = best_params;

    [Ha1.dayGEPdaymodel] = FN_computeGEPphotosynthesisGCCgn2br(best_params,counter,...
        Ha1.dayPARday, Ha1.daytairday, Ha1.ROIgccQA, 0);  %, Ha1.dayLength

    % Statistics
    valid = Ha1.dayGEPday>0.1 & Ha1.dayGEPdaymodel>0.1 & Ha1.dayGEPday<maxGEPday &... %& Ha1.dayGEPday < 30
        ~isnan(Ha1.dayGEPday) & ~isnan(Ha1.dayGEPdaymodel);
    r = corr(Ha1.dayGEPdaymodel(valid), Ha1.dayGEPday(valid), 'rows', 'complete');
    MSRE = mean(((Ha1.dayGEPdaymodel(valid) - Ha1.dayGEPday(valid)) ./ Ha1.dayGEPday(valid)).^2);
    MSE = mean((Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid)).^2);
    RMSE = sqrt(MSE);  % Root Mean Square Error (RMSE)
    MAE = mean(abs(Ha1.dayGEPday(valid) - Ha1.dayGEPdaymodel(valid))); % Mean Absolute Error (MAE)
    Rsquared = (corrcoef(Ha1.dayGEPday(valid),Ha1.dayGEPdaymodel(valid)));
    Rsquared = (Rsquared(1,2))^2;

    fprintf('\nStats:\n');
    fprintf('MSRE: %.4f\nMSE: %.3f\nRMSE: %.3f\nMAE: %.3f\nRsquared: %.3f\n', [MSRE,MSE,RMSE,MAE,Rsquared]);

    scatter(Ha1.daydate(ind),Ha1.dayGEPdaymodel(ind),10,'o','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
    hl4 = plot(Ha1.daydate(ind),smoothdata(Ha1.dayGEPdaymodel(ind),'movmean',5),'-','Color',color_mtx_dark(2,:),'Linewidth',.5);

    ax2 = gca;                         set(ax2,'YColor',[0.3 0.3 0.5]);
    ax2.XAxis.MinorTick = 'on';        ax2.XAxis.MinorTickValues = Ha1.month;
    ylabel ('photosynthesis (gC m^-^2 d^-^1)','FontSize',16);   xtickangle(0);   box on;   grid on;
    text(Ha1.daydate(ind(20)),25,site_name,'FontSize',16)
    legend([hl3,hl4],'normalize year-to-year','normalize entire time series','observation'); legend box off;
    % Ha1.dayGEPdaymodelGateGnBw = Ha1.dayGEPdaymodel;

end