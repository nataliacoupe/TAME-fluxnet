addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;
addpath /home/ncoupe/Documents/timesat33/timesat_matlab/main/
addpath /home/ncoupe/Documents/timesat33/timesat_matlab/tools/
addpath /home/ncoupe/Documents/timesat33/timesat_matlab/
load matlabTPD.mat

flag_input = 10;                 flag_read_timesat = 1;

TPD.dayGEPpar = TPD.dayGEPday.*1000./TPD.dayPARday;
TPD.dayGEPpar((TPD.dayGEPpar<-10)|(TPD.dayGEPpar>60)) = NaN;
TPD.dayGEPpar((TPD.daytairdaymin<0)&(TPD.dayGEPpar>5)) = NaN;
[TPD.day_recurrentGEPparday,TPD.day_recurrent_stdGEPparday] = AM_fill_day_avg(TPD.dayGEPpar,TPD.daydate);
TPD.day_recurrentGEPpardayGoley = sgolayfilt(TPD.day_recurrentGEPparday,polyorder,framesize);

if flag_input==1
    %snow
    polyorder  = 2;      % Polynomial order (typically 2 or 3)
    framesize = 21;     % Window size (must be odd)
    ROI.b_golay = sgolayfilt(ROI.b_mean,polyorder,framesize);

    % .....................................................................
    %% GCC
    % .....................................................................
    figure('color','white');
    plot(ROI.daydate,ROI.gcc_mean); hold on
    ROI.gcc_mean((ROI.gcc_mean<0.27)) = NaN;
    plot(ROI.daydate,ROI.gcc_mean,'.')

    [iy,~,~,~,ix] = AM_day(ROI.gcc_mean,ROI.daydate,0);
    plot(ix,iy)
    [im,~,~] = datevec(ix);

    newTime = (datetime(im(1),1,1):days(1):datetime(im(end)+1,12,31))';
    in = find(newTime==ix(1));   im = find(newTime==ix(end));
    iw = NaN(in-1,1);            iz = NaN(length(newTime)-im,1);
    ROITPD.dayGCC = [iw;iy;iz];  ROITPD.daydate = newTime;
    plot(ROITPD.daydate, ROITPD.dayGCC);

    [ROITPD.day_recurrentGCC,ROITPD.day_recurrent_stdGCC] = AM_fill_day_avg(ROITPD.dayGCC,ROITPD.daydate);
    ROITPD.day_recurrentGCCGoley = sgolayfilt(ROITPD.day_recurrentGCC,polyorder,framesize);

    ROITPD.dayJD = day(ROITPD.daydate,'dayofyear');
    [ROITPD.dayY,ROITPD.dayM,ROITPD.dayD] = datevec(ROITPD.daydate);

    ix = AM_fill_plus(ROITPD.dayGCC);   ix(isnan(ix)) = ROITPD.day_recurrentGCC(isnan(ix));
    % iy = zeros(length(ix),1);           iy(isnan(ix)) = 2;      %iy(ROI.b_golay>45) = 2;
    iy = ones(length(ix),1);            iy(isnan(ix)) = 0;
    ind = find((ROITPD.dayM==2)&(ROITPD.dayD==29));
    ix(ind) = [];                           iy(ind) = [];
    header = [num2str(round(length(ROITPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (ix.*100,'timesat/TPDtabletimesatGCC.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatGCC.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatGCC.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(ROITPD.daydate)./365)) num2str((length(ROITPD.daydate))/round(length(ROITPD.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(ROITPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TPDtabletimesatGCCqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatGCCqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatGCCqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % Create a table
    % T = table(ROITPD.dayY, ROITPD.dayJD, ROITPD.dayGCC);%, 'VariableNames', {'Year', 'DayOfYear', 'GCC'});

    % .....................................................................
    %% RCC
    % .....................................................................
    figure('color','white');
    plot(ROI.daydate,ROI.rcc_mean); hold on
    ROI.rcc_mean(ROI.rcc_mean<0.26) = NaN;
    % % polyorder  = 2;      % Polynomial order (typically 2 or 3)
    % % framesize = 27;     % Window size (must be odd)
    % % ix = sgolayfilt(ROI.rcc_mean,polyorder,framesize);
    ix = smoothdata(ROI.rcc_mean,'movmean',27);
    % ind = find((ROI.b_golay>45)|(ROI.dayM>=11)|(ROI.dayM<=4)); ROI.rcc_mean(ind) = ix(ind);
    ind = find((ROI.dayM>=12)|(ROI.dayM<=4)); ROI.rcc_mean(ind) = ix(ind);
    plot(ROI.daydate,ROI.rcc_mean,'.')

    [iy,~,~,~,ix] = AM_day(ROI.rcc_mean,ROI.daydate,0);
    plot(ix,iy)
    [im,~,~] = datevec(ix);

    newTime = (datetime(im(1),1,1):days(1):datetime(im(end)+1,12,31))';
    in = find(newTime==ix(1));   im = find(newTime==ix(end));
    iw = NaN(in-1,1);            iz = NaN(length(newTime)-im,1);
    ROITPD.dayRCC = [iw;iy;iz];  ROITPD.daydate = newTime;
    plot(ROITPD.daydate, ROITPD.dayRCC);

    [ROITPD.day_recurrentRCC,ROITPD.day_recurrent_stdRCC]  = AM_fill_day_avg(ROITPD.dayRCC,ROITPD.daydate);
    ROITPD.day_recurrentRCCGoley = sgolayfilt(ROITPD.day_recurrentRCC,polyorder,framesize);

    ROITPD.dayJD = day(ROITPD.daydate,'dayofyear');
    [ROITPD.dayY,ROITPD.dayM,ROITPD.dayD] = datevec(ROITPD.daydate);

    ix = AM_fill_plus(ROITPD.dayRCC);          ix(isnan(ix)) = ROITPD.day_recurrentRCC(isnan(ix));
    iy = zeros(length(ix),1);                  iy(isnan(ix)) = 2;       %iy(ROI.b_golay>45) = 2;
    ind = find((ROITPD.dayM==2)&(ROITPD.dayD==29));
    ix(ind) = [];                           iy(ind) = [];
    header = [num2str(round(length(ROITPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (ix.*100,'timesat/TPDtabletimesatRCC.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatRCC.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatRCC.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    figure('color','white');
    iz = 1-ix;           plot(iz);
    writematrix (iz.*100,'timesat/TPDtabletimesatRCCabs.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatRCCabs.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatRCCabs.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    % header = [num2str(round(length(ROITPD.daydate)./365)) num2str((length(ROITPD.daydate))/round(length(ROITPD.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(ROITPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TPDtabletimesatRCCqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatRCCqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatRCCqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % Create a table
    % T = table(ROITPD.dayY, ROITPD.dayJD, ROITPD.dayRCC);%, 'VariableNames', {'Year', 'DayOfYear', 'RCC'});

    % .....................................................................
    %% GRRI
    % .....................................................................
    figure('color','white');
    plot(ROI.daydate,ROI.GRRI_mean); hold on
    % % polyorder  = 2;      % Polynomial order (typically 2 or 3)
    % % framesize = 27;     % Window size (must be odd)
    % % ix = sgolayfilt(ROI.GRRI_mean,polyorder,framesize);
    ix = smoothdata(ROI.GRRI_mean,'movmean');
    ind = find((ROI.dayM>=11)|(ROI.dayM<=4)|(ROI.GRRI_mean>1.7)); ROI.GRRI_mean(ind) = ix(ind);
    plot(ROI.daydate,ROI.GRRI_mean,'.')

    [iy,~,~,~,ix] = AM_day(ROI.GRRI_mean,ROI.daydate,0);
    plot(ix,iy)
    [im,~,~] = datevec(ix);

    newTime = (datetime(im(1),1,1):days(1):datetime(im(end)+1,12,31))';
    in = find(newTime==ix(1));    im = find(newTime==ix(end));
    iw = NaN(in-1,1);             iz = NaN(length(newTime)-im,1);
    ROITPD.dayGRRI = [iw;iy;iz];  ROITPD.daydate = newTime;
    plot( ROITPD.daydate, ROITPD.dayGRRI);

    [ROITPD.day_recurrentGRRI,ROITPD.day_recurrent_stdGRRI]  = AM_fill_day_avg(ROITPD.dayGRRI,ROITPD.daydate);
    ROITPD.day_recurrentGRRIGoley = sgolayfilt(ROITPD.day_recurrentGRRI,polyorder,framesize);

    ROITPD.dayJD = day(ROITPD.daydate,'dayofyear');
    [ROITPD.dayY,ROITPD.dayM,ROITPD.dayD] = datevec(ROITPD.daydate);

    ix = AM_fill_plus(ROITPD.dayGRRI);    ix(isnan(ix)) = ROITPD.day_recurrentGRRI(isnan(ix));
    % iy = zeros(length(ix),1);           iy(isnan(ix)) = 2;      %iy(ROI.b_golay>45) = 2;
    iy = ones(length(ix),1);            iy(isnan(ix)) = 0;
    ind = find((ROITPD.dayM==2)&(ROITPD.dayD==29));
    ix(ind) = [];                         iy(ind) = [];
    header = [num2str(round(length(ROITPD.daydate)./365)) ' 365 ' num2str(1) ];
    % iy = 1-ix;
    writematrix (ix.*100,'timesat/TPDtabletimesatGRRI.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatGRRI.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatGRRI.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(ROITPD.daydate)./365)) num2str((length(ROITPD.daydate))/round(length(ROITPD.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(ROITPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TPDtabletimesatGRRIqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatGRRIqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatGRRIqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % Create a table
    % T = table(ROITPD.dayY, ROITPD.dayJD, ROITPD.dayGRRI);%, 'VariableNames', {'Year', 'DayOfYear', 'GRRI'});

    % .....................................................................
    %% GRIVI
    % .....................................................................
    % ROI.GRIVI_mean = (ROI.g_mean-ROI.r_mean)./(ROI.g_mean+ROI.r_mean);
    figure('color','white');
    plot(ROI.daydate,ROI.GRIVI_mean); hold on; ylabel('GRIVI');
    % % polyorder  = 2;      % Polynomial order (typically 2 or 3)
    % % framesize = 27;     % Window size (must be odd)
    % % ix = sgolayfilt(ROI.GRIVI_mean,polyorder,framesize);
    ix = smoothdata(ROI.GRIVI_mean,'movmean');
    % ind = find((ROI.b_golay>45)|(ROI.dayM>=12)|(ROI.dayM<=4)|(ROI.GRIVI_mean>1.7)); ROI.GRIVI_mean(ind) = ix(ind);
    ind = find((ROI.dayM>=12)|(ROI.dayM<=4)); ROI.GRIVI_mean(ind) = ix(ind);
    plot(ROI.daydate,ROI.GRIVI_mean,'.')

    [iy,~,~,~,ix] = AM_day(ROI.GRIVI_mean,ROI.daydate,0);
    plot(ix,iy)
    [im,~,~] = datevec(ix);

    newTime = (datetime(im(1),1,1):days(1):datetime(im(end),12,31))';
    in = find(newTime==ix(1));    im = find(newTime==ix(end));
    iw = NaN(in-1,1);             iz = NaN(length(newTime)-im,1);
    ROITPD.dayGRIVI = [iw;iy;iz];  ROITPD.daydate = newTime;
    plot( ROITPD.daydate, ROITPD.dayGRIVI);

    [ROITPD.day_recurrentGRIVI,ROITPD.day_recurrent_stdGRIVI]  = AM_fill_day_avg(ROITPD.dayGRIVI,ROITPD.daydate);
    ROITPD.day_recurrentGRIVIGoley = sgolayfilt(ROITPD.day_recurrentGRIVI,polyorder,framesize);

    ROITPD.dayJD = day(ROITPD.daydate,'dayofyear');
    [ROITPD.dayY,ROITPD.dayM,ROITPD.dayD] = datevec(ROITPD.daydate);

    ix = AM_fill_plus(ROITPD.dayGRIVI);   ix(isnan(ix)) = ROITPD.day_recurrentGRIVI(isnan(ix));
    iy = zeros(length(ix),1);             iy(isnan(ix)) = 2;   iy(ROI.b_golay>55) = 2;
    ind = find((ROITPD.dayM==2)&(ROITPD.dayD==29));
    ix(ind) = [];                         iy(ind) = [];
    header = [num2str(round(length(ROITPD.daydate)./365)) ' 365 ' num2str(1) ];
    % iy = 1-ix;
    writematrix (ix.*100,'timesat/TPDtabletimesatGRIVI.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatGRIVI.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatGRIVI.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(ROITPD.daydate)./365)) num2str((length(ROITPD.daydate))/round(length(ROITPD.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(ROITPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TPDtabletimesatGRIVIqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatGRIVIqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatGRIVIqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
  
    %%
    % timesat was having a hard time finding the peak and two minima (egs
    % and sgs) so let us do it ourselves
    windowSize = 21;
    smoothedData = sgolayfilt(ROITPD.dayGRIVI, 3, windowSize);
    ROITPD.years = unique(year(ROITPD.daydate));  ROITPD.years(end) = [];
    numYears = length(ROITPD.years);
    Year = zeros(numYears, 1);
    BegTdate = datetime(zeros(numYears,1), 0, 0); Val_Winter_Min = nan(numYears, 1);
    MaxTdate = datetime(zeros(numYears,1), 0, 0); Val_Peak = nan(numYears, 1);
    EndTdate = datetime(zeros(numYears,1), 0, 0); Val_Absolute_Min = nan(numYears, 1);

        for ix = 1:numYears
        currYear = ROITPD.years(ix);
        yearMask = (year(ROITPD.daydate) == currYear);
        idx = find(yearMask);

        idx(ROITPD.dayJD(idx) < (31+28)) = [];

        if isempty(idx), continue; end
        Year(ix) = currYear;

        [vP, rP] = max(smoothedData(idx));
        peakAbsIdx = idx(rP);
        MaxTdate(ix) = ROITPD.daydate(peakAbsIdx);
        Val_Peak(ix)  = vP;

        searchStartW = max(idx(1), peakAbsIdx - 100);
        [vW, rW] = min(smoothedData(searchStartW:peakAbsIdx));
        BegTdate(ix) = ROITPD.daydate(searchStartW + rW - 1);
        Val_Winter_Min(ix) = vW;

        searchEndIdx = idx(end);
        [vA, rA] = min(smoothedData(peakAbsIdx:searchEndIdx));
        EndTdate(ix) = ROITPD.daydate(peakAbsIdx + rA - 1);
        Val_Absolute_Min(ix) = vA;
    end
    ind = find(day(EndTdate,'dayofyear')<150);
    iy = mean(day(EndTdate(day(EndTdate,'dayofyear')>150),'dayofyear'),'omitnan');
    EndTdate(ind) = datetime(year(EndTdate(ind)),1,round(iy));
    for ik = 1:length(ind)
        iy = smoothedData(ROITPD.daydate==EndTdate(ind(ik)));
        iy(isnan(iy)) = mean(Val_Absolute_Min,'omitnan');
        Val_Absolute_Min(ind(ik)) = iy;
    end

    TPDseasonalityGRIVI = table(Year, BegTdate, Val_Winter_Min, ...
        MaxTdate, Val_Peak, ...
        EndTdate, Val_Absolute_Min);
    TPDseasonalityGRIVI(TPDseasonalityGRIVI.Year <= 0 | isnan(TPDseasonalityGRIVI.Year), :) = [];
    disp(TPDseasonalityGRIVI);
    writetable(TPDseasonalityGRIVI, 'timesat/TPDseasonalityGRIVI.txt', 'WriteVariableNames', true, 'Delimiter', '\t');

    figure('color','white');   plot(ROITPD.daydate, ROITPD.dayGRIVI, 'Color', [0.8 0.8 0.8]); hold on;
    plot(ROITPD.daydate, smoothedData, 'b', 'LineWidth', 1.5);
    plot(TPDseasonalityGRIVI.BegTdate, TPDseasonalityGRIVI.Val_Winter_Min, 'ms', 'MarkerFaceColor', 'm');
    plot(TPDseasonalityGRIVI.MaxTdate, TPDseasonalityGRIVI.Val_Peak, 'ro', 'MarkerFaceColor', 'r');
    plot(TPDseasonalityGRIVI.EndTdate, TPDseasonalityGRIVI.Val_Absolute_Min, 'gd', 'MarkerFaceColor', 'g');
    title('ROITPD Phenological Milestones: Absolute Minima Correction');
    grid on;   ylabel('GRIVI');
    % Create a table
    % T = table(ROITPD.dayY, ROITPD.dayJD, ROITPD.dayGRIVI);%, 'VariableNames', {'Year', 'DayOfYear', 'GRIVI'});

    % .....................................................................
    %% EVI
    % .....................................................................
    TPD.dayJD = day(TPD.daydate,'dayofyear');
    [TPD.dayY,TPD.dayM,TPD.dayD] = datevec(TPD.daydate);

    ix = AM_fill_plus(TPD.dayEVI);            ix(isnan(ix)) = TPD.day_recurrentEVI(isnan(ix));
    iy = ones(length(ix),1);                         iy(isnan(ix))=0;
    ind = find((TPD.dayM==2)&(TPD.dayD==29));
    ix(ind) = [];                                            iy(ind) = [];
    header = [num2str(round(length(TPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (ix.*100,'timesat/TPDtabletimesatEVI.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatEVI.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatEVI.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(TPD.daydate)./365)) num2str((length(TPD.daydate))/round(length(TPD.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(TPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TPDtabletimesatEVIqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatEVIqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatEVIqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    % .....................................................................
    %% GEP
    % .....................................................................
    TPD.dayGEPqa = TPD.dayGEPday;
    % % TPD.dayGEPqa((TPD.daydate>datetime(1992,12,20))&(TPD.daydate<datetime(1993,2,23))) = NaN;
    % % TPD.dayGEPqa((TPD.daydate>datetime(2015,1,15))&(TPD.daydate<datetime(2015,2,27))) = NaN;
    % % TPD.dayGEPqa((TPD.daydate>datetime(2010,12,11))&(TPD.daydate<datetime(2011,2,1))) = NaN;
    TPD.dayGEPqa(TPD.dayGEPqa<-1) = NaN;
    figure; plot(TPD.daydate, TPD.dayGEPday); hold on; plot(TPD.daydate, TPD.dayGEPqa);
    TPD.dayGEPqa((TPD.daytairdaymin<0)&(TPD.dayGEPqa>1)) = NaN;
    plot(TPD.daydate, TPD.dayGEPqa,'g');
    [TPD.day_recurrentGEPday,TPD.day_recurrent_stdGEPday]  = AM_fill_day_avg(TPD.dayGEPqa,TPD.daydate);
    TPD.day_recurrentGEPdayGoley = sgolayfilt(TPD.day_recurrentGEPday,polyorder,framesize);

    TPD.dayJD = day(TPD.daydate,'dayofyear');
    [TPD.dayY,TPD.dayM,TPD.dayD] = datevec(TPD.daydate);

    ix = AM_fill_plus(TPD.dayGEPqa);          ix(isnan(ix)) = TPD.day_recurrentGEPday(isnan(ix));
    iy = ones(length(ix),1);                  iy(isnan(ix))=0;
    ind = find((TPD.dayM==2)&(TPD.dayD==29));
    ix(ind) = [];                                            iy(ind) = [];
    header = [num2str(round(length(TPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (ix,'timesat/TPDtabletimesatGEP.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatGEP.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatGEP.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(TPD.daydate)./365)) num2str((length(TPD.daydate))/round(length(TPD.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(TPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TPDtabletimesatGEPqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatGEPqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatGEPqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    % .....................................................................
    %% GEP/PAR
    % .....................................................................
    TPD.dayGEPpar = TPD.dayGEPday.*1000./TPD.dayPARday;
    figure; plot(TPD.daydate, TPD.dayGEPpar); hold on;
    % TPD.dayGEPpar((TPD.daydate>datetime(1992,12,20))&(TPD.daydate<datetime(1993,2,23))) = NaN;
    % TPD.dayGEPpar((TPD.daydate>datetime(2015,1,15))&(TPD.daydate<datetime(2015,2,27))) = NaN;
    % TPD.dayGEPpar((TPD.daydate>datetime(2010,12,11))&(TPD.daydate<datetime(2011,2,1))) = NaN;
    TPD.dayGEPpar((TPD.dayGEPpar<-10)|(TPD.dayGEPpar>60)) = NaN;
    plot(TPD.daydate, TPD.dayGEPpar);
    TPD.dayGEPpar((TPD.daytairdaymin<0)&(TPD.dayGEPpar>5)) = NaN;
    % TPD.dayGEPpar((TPD.dayM==12)|(TPD.dayM==1)&(TPD.dayGEPpar>10)) = NaN;
    % TPD.dayGEPpar = OZ_out_bad_neighbor(TPD.dayGEPpar);
    plot(TPD.daydate, TPD.dayGEPpar,'g');
    [TPD.day_recurrentGEPparday,TPD.day_recurrent_stdGEPparday] = AM_fill_day_avg(TPD.dayGEPpar,TPD.daydate);
    TPD.day_recurrentGEPpardayGoley = sgolayfilt(TPD.day_recurrentGEPparday,polyorder,framesize);
    plot(TPD.daydate, TPD.day_recurrentGEPpardayGoley,'m');

    TPD.dayJD = day(TPD.daydate,'dayofyear');
    [TPD.dayY,TPD.dayM,TPD.dayD] = datevec(TPD.daydate);

    ix = AM_fill_plus(TPD.dayGEPpar);         ix(isnan(ix)) = TPD.day_recurrentGEPpardayGoley(isnan(ix));
    iy = ones(length(ix),1);                  iy(isnan(ix))=0;
    ind = find((TPD.dayM==2)&(TPD.dayD==29));
    ix(ind) = [];                             iy(ind) = [];
    header = [num2str(round(length(TPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (ix,'timesat/TPDtabletimesatGEPpar.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatGEPpar.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatGEPpar.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(TPD.daydate)./365)) num2str((length(TPD.daydate))/round(length(TPD.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(TPD.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TPDtabletimesatGEPparqc.txt','Delimiter','tab');
    S = fileread('timesat/TPDtabletimesatGEPparqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TPDtabletimesatGEPparqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    % Write to CSV file
    % writetable(T, 'timesat/TPDtabletimesatGCC.txt');
    % timesat
    save('TPD.mat','TPD','ROITPD','-append');
    save('matlabTPD.mat','ROITPD','-append');
end

% .................................................................................................................................................
% % % y = [TPD.day_recurrentLEday(ind)-TPD.day_recurrent_stdLEday(ind),2.*TPD.day_recurrent_stdLEday(ind)];
% % % h = area(TPD.daydate(ind),y);       set(gca,'Layer','top');
% % % set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
% % % set(h,'BaseValue',0);
% % % % set(h,'YTick',v3,'YLim',[v1 v2],'XLim',[TPD.daydate(ind(1)) TPD.daydate(ind(end))],'FontSize',12,'XMinorGrid','on');    %'XTickLabelColor',[0. 0. 0.7 ]
% % % hold on;
% % % hl2 = plot(TPD.daydate(ind),TPD.day_recurrentLEdayGoley(ind),'-','LineWidth',1,'color',[0. 0.6 0.6 ]); hold on;
% % % hl1 = plot(TPD.daydate(ind),TPD.dayLEday(ind),'-','LineWidth',0.5,'color',[0.6 0.6 0.6]); hold on; alpha = 0.3;
% % % hl3 = plot(TPD.daydate(ind),(TPD.dayLEday(ind).*0)+mean(TPD.dayLEday,'omitnan'),':','LineWidth',2,'color',[ 0.2 0.2 0.2]); hold on;
% % % hl4 = plot(TPD.daydate(ind),TPD.dayLEdayGrowth(ind),'.','LineWidth',0.8,'color',[0.3 0.3 0.5]); hold on; alpha = 0.3;


%% ........................................................................
if flag_read_timesat==1
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

    %% RCC two seasons per year
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

    %% GEP
    filename = 'timesat/TPDseasonalityGEP.txt';
    startRow = 2;
    formatSpec = '%5f%6f%6f%10f%9f%9f%9f%9f%9f%9f%10f%10f%9f%9f%9f%9f%C%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    GEP.Seas = dataArray{:, 3};     GEP.BegTtemp = dataArray{:, 4}; GEP.EndTtemp = dataArray{:, 5};
    GEP.LengthVal= dataArray{:, 6}; GEP.Baseval = dataArray{:, 7};  GEP.MaxTtemp = dataArray{:, 8};
    GEP.MaxVal = dataArray{:, 9};   GEP.Ampl = dataArray{:, 10};    GEP.Lder = dataArray{:, 11};
    GEP.Rder = dataArray{:, 12};    GEP.Linteg = dataArray{:, 13};  GEP.Sinteg = dataArray{:, 14};
    GEP.StartVal = dataArray{:, 15};GEP.EndVa = dataArray{:, 16};   GEP.lVal = dataArray{:, 17};

    GEP.BegTtemp(GEP.BegTtemp<=0) = NaN;    GEP.EndTtemp(GEP.EndTtemp<=0) = NaN;
    GEP.MaxTtemp(GEP.MaxTtemp<=0) = NaN;    GEP.LengthVal(GEP.LengthVal<=0) = NaN;
    GEP.LengthVal = AM_fill_plus(GEP.LengthVal);

    GEP.BegTdate = NaT(length(GEP.BegTtemp),1);     GEP.EndTdate = GEP.BegTdate;
    GEP.MaxTdate = GEP.BegTdate;
    for ix = 1:length(GEP.BegTtemp)
        if ~isnan(GEP.BegTtemp(ix));   GEP.BegTdate(ix) = TPD.daydate(ceil(GEP.BegTtemp(ix)));   end
        if ~isnan(GEP.EndTtemp(ix));   GEP.EndTdate(ix) = TPD.daydate(floor(GEP.EndTtemp(ix)));  end
        if ~isnan(GEP.MaxTtemp(ix));   GEP.MaxTdate(ix) = TPD.daydate(floor(GEP.MaxTtemp(ix)));  end
    end

    GEP.BegTjd = day(GEP.BegTdate,'dayofyear');
    GEP.EndTjd = day(GEP.EndTdate,'dayofyear');
    GEP.MaxTjd = day(GEP.MaxTdate,'dayofyear');

    ind = find((GEP.BegTdate>=TPD.daydate(1))&(GEP.BegTdate<=TPD.daydate(end)));  GEP.BegT = GEP.BegTjd(ind);
    ind = find((GEP.EndTdate>=TPD.daydate(1))&(GEP.EndTdate<=TPD.daydate(end)));  GEP.EndT = GEP.EndTjd(ind);
    ind = find((GEP.MaxTdate>=TPD.daydate(1))&(GEP.MaxTdate<=TPD.daydate(end)));  GEP.MaxT = GEP.MaxTjd(ind);

    [TPD.daydateY,TPD.daydateM,TPD.daydateD] = datevec(TPD.daydate);
    GEP.daydateYears = unique(TPD.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% GEP
    filename = 'timesat/TPDseasonalityGEPpar.txt';
    startRow = 2;
    formatSpec = '%5f%6f%6f%10f%9f%9f%9f%9f%9f%9f%10f%10f%9f%9f%9f%9f%C%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    GEPpar.Seas = dataArray{:, 3};     GEPpar.BegTtemp = dataArray{:, 4}; GEPpar.EndTtemp = dataArray{:, 5};
    GEPpar.LengthVal= dataArray{:, 6}; GEPpar.Baseval = dataArray{:, 7};  GEPpar.MaxTtemp = dataArray{:, 8};
    GEPpar.MaxVal = dataArray{:, 9};   GEPpar.Ampl = dataArray{:, 10};    GEPpar.Lder = dataArray{:, 11};
    GEPpar.Rder = dataArray{:, 12};    GEPpar.Linteg = dataArray{:, 13};  GEPpar.Sinteg = dataArray{:, 14};
    GEPpar.StartVal = dataArray{:, 15};GEPpar.EndVa = dataArray{:, 16};   GEPpar.lVal = dataArray{:, 17};

    GEPpar.BegTtemp(GEPpar.BegTtemp<=0) = NaN;    GEPpar.EndTtemp(GEPpar.EndTtemp<=0) = NaN;
    GEPpar.MaxTtemp(GEPpar.MaxTtemp<=0) = NaN;    GEPpar.LengthVal(GEPpar.LengthVal<=0) = NaN;
    GEPpar.LengthVal = AM_fill_plus(GEPpar.LengthVal);

    GEPpar.BegTdate = NaT(length(GEPpar.BegTtemp),1);     GEPpar.EndTdate = GEPpar.BegTdate;
    GEPpar.MaxTdate = GEPpar.BegTdate;
    for ix = 1:length(GEPpar.BegTtemp)
        if ~isnan(GEPpar.BegTtemp(ix));   GEPpar.BegTdate(ix) = TPD.daydate(ceil(GEPpar.BegTtemp(ix)));   end
        if ~isnan(GEPpar.EndTtemp(ix));   GEPpar.EndTdate(ix) = TPD.daydate(floor(GEPpar.EndTtemp(ix)));  end
        if ~isnan(GEPpar.MaxTtemp(ix));   GEPpar.MaxTdate(ix) = TPD.daydate(floor(GEPpar.MaxTtemp(ix)));  end
    end

    GEPpar.BegTjd = day(GEPpar.BegTdate,'dayofyear');
    GEPpar.EndTjd = day(GEPpar.EndTdate,'dayofyear');
    GEPpar.MaxTjd = day(GEPpar.MaxTdate,'dayofyear');

    ind = find((GEPpar.BegTdate>=TPD.daydate(1))&(GEPpar.BegTdate<=TPD.daydate(end)));  GEPpar.BegT = GEPpar.BegTjd(ind);
    ind = find((GEPpar.EndTdate>=TPD.daydate(1))&(GEPpar.EndTdate<=TPD.daydate(end)));  GEPpar.EndT = GEPpar.EndTjd(ind);
    ind = find((GEPpar.MaxTdate>=TPD.daydate(1))&(GEPpar.MaxTdate<=TPD.daydate(end)));  GEPpar.MaxT = GEPpar.MaxTjd(ind);

    [TPD.daydateY,TPD.daydateM,TPD.daydateD] = datevec(TPD.daydate);
    GEPpar.daydateYears = unique(TPD.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;


    %         nbins = 50;
    %         [h, centres] = hist(d, nbins);
    %         % normalise to unit area
    %         norm_h = h / (numel(d) * (centres(2)-centres(1)));
    % .....................................................................
    %% figures
    % .....................................................................
    color_mtx_light = [ 255/255 127/255 20/255; 60/255 187/255 255/255; 245/255  55/255 58/255; 50/255 77/255 255/255; ...
        0.1020 0.5882 0.2549; 0.1020 0.5882 0.2549; 0.1020 0.5882 0.2549; 0.1020 0.5882 0.2549];

    color_mtx_dark = [ 235/255 107/255 0/255; 40/255 167/255 235/255; 225/255  35/255 38/255; 30/255 57/255 235/255; ...
        0.0820 0.3882 0.0549; 0.0020 0.2882 0.0549; 0.0020 0.3882 0.0549; 0.0020 0.3882 0.0549];

    ix = (ROITPD.daydateY(1):1:ROITPD.daydateY(end))'; count =2;
    x1=ix(1);  x2=ix(end);   x4 = x1:1:x2;             x3 = (x1:2:x2)';
    figure('color','white');
    y1=120;     y2=150;       y3 = (y1:(y2-y1)/3:y2)';
    subplot(2,1,1);          hold on;
    count = 1;
    hl1 = scatter(year(GEP.BegTdate),GEP.BegTjd,60,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GEP.BegTdate),GEP.BegTjd,num2str(GEP.BegTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 2;
    hl2 = scatter(year(GCC.BegTdate),GCC.BegTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GCC.BegTdate),GCC.BegTjd,num2str(GCC.BegTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 3;
    hl3 = scatter(year(RCC.MaxTdate),RCC.MaxTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(RCC.MaxTdate),RCC.MaxTjd,num2str(RCC.MaxTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 4;
    hl4 = scatter(year(GRRI.BegTdate),GRRI.BegTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GRRI.BegTdate),GRRI.BegTjd,num2str(GRRI.BegTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 5;
    hl5 = scatter(year(GRIVI.BegTdate),GRIVI.BegTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GRIVI.BegTdate),GRIVI.BegTjd,num2str(GRIVI.BegTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    axis ([x1 x2 y1 y2]);
    %         xlabel({'start season (DOY)';['\mu DOY:' num2str(round(muhat.BegT)) ' \sigma:' num2str(round(sigmahat.BegT)) 'days']});
    ylabel({'season (DOY)'});     %xlabel('year');
    set(gca,'XTick',x4,'XTickLabel','','XLim',[x1 x2],'YLim',[y1 y2],'YTick',y3,'FontSize',12);
   grid on;     box on;
    legend([hl1,hl2,hl3,hl4,hl5],'GEP','GCC','peak RCC','GRRI','GRIVI','FontSize',10,'orientation','horizontal'); legend box off;
text(year(GRIVI.BegTdate(2)),140,'(e) TPD');

    y1=270;     y2=300;       y3 = (y1:(y2-y1)/3:y2)';
    subplot(2,1,2);          hold on;
    count = 1;
    hl1 = scatter(year(GEP.EndTdate),GEP.EndTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GEP.EndTdate),GEP.EndTjd,num2str(GEP.EndTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 2;
    hl2 = scatter(year(GCC.EndTdate),GCC.EndTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GCC.EndTdate),GCC.EndTjd,num2str(GCC.EndTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 3;
    hl3 = scatter(year(RCC.MaxTdate),RCC.MaxTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(RCC.MaxTdate),RCC.MaxTjd,num2str(RCC.MaxTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 4;
    hl4 = scatter(year(GRRI.EndTdate),GRRI.EndTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GRRI.EndTdate),GRRI.EndTjd,num2str(GRRI.EndTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 5;
    hl5 = scatter(year(GRIVI.EndTdate),GRIVI.EndTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GRIVI.EndTdate),GRIVI.EndTjd,num2str(GRIVI.EndTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    axis ([x1 x2 y1 y2]);
    %         xlabel({'start season (DOY)';['\mu DOY:' num2str(round(muhat.BegT)) ' \sigma:' num2str(round(sigmahat.BegT)) 'days']});
    ylabel({'season (DOY)'});     %xlabel('year');
    set(gca,'XTick',x4,'XTickLabel',x3,'XLim',[x1 x2],'YLim',[y1 y2],'YTick',y3,'FontSize',12);
    xtickangle(0);                      grid on;  box on;
    text(year(GRIVI.BegTdate(2)),294,'(f) TPD');
    % legend([hl1,hl2,hl3],'end GEP','end GCC','peak RCC','FontSize',10,'orientation','horizontal'); legend box off;


    %% --- Calculate Differences & Summary Statistics (Start & End of Season) ---
    % Convention: VI - GEP (positive = VI occurs later than GEP)

    % Helper function handle for year-matched subtraction
    calc_diff = @(date_vi, val_vi, date_gep, val_gep) ...
        val_vi(second(intersect(year(date_gep), year(date_vi)), 'legacy')) - ...
        val_gep(first(intersect(year(date_gep), year(date_vi)), 'legacy'));

    % --- 1. START OF SEASON (SGS) ---
    [~, iGEP_gcc, iGCC]     = intersect(year(GEP.BegTdate), year(GCC.BegTdate));
    [~, iGEP_rcc, iRCC]     = intersect(year(GEP.BegTdate), year(RCC.MaxTdate));
    [~, iGEP_grri, iGRRI]   = intersect(year(GEP.BegTdate), year(GRRI.BegTdate));
    [~, iGEP_grivi, iGRIVI] = intersect(year(GEP.BegTdate), year(GRIVI.BegTdate));

    diff_sgs.GCC   = GCC.BegTjd(iGCC)     - GEP.BegTjd(iGEP_gcc);
    diff_sgs.RCC   = RCC.MaxTjd(iRCC)     - GEP.BegTjd(iGEP_rcc);
    diff_sgs.GRRI  = GRRI.BegTjd(iGRRI)   - GEP.BegTjd(iGEP_grri);
    diff_sgs.GRIVI = GRIVI.BegTjd(iGRIVI) - GEP.BegTjd(iGEP_grivi);

    % --- 2. END OF SEASON (EGS) ---
    [~, iGEP_gcc_e, iGCC_e]     = intersect(year(GEP.EndTdate), year(GCC.EndTdate));
    [~, iGEP_rcc_e, iRCC_e]     = intersect(year(GEP.EndTdate), year(RCC.MaxTdate));
    [~, iGEP_grri_e, iGRRI_e]   = intersect(year(GEP.EndTdate), year(GRRI.EndTdate));
    [~, iGEP_grivi_e, iGRIVI_e] = intersect(year(GEP.EndTdate), year(GRIVI.EndTdate));

    diff_egs.GCC   = GCC.EndTjd(iGCC_e)     - GEP.EndTjd(iGEP_gcc_e);
    diff_egs.RCC   = RCC.MaxTjd(iRCC_e)     - GEP.EndTjd(iGEP_rcc_e); % RCC Peak compared with GEP End
    diff_egs.GRRI  = GRRI.EndTjd(iGRRI_e)   - GEP.EndTjd(iGEP_grri_e);
    diff_egs.GRIVI = GRIVI.EndTjd(iGRIVI_e) - GEP.EndTjd(iGEP_grivi_e);

    % --- PRINT RESULTS TO COMMAND WINDOW ---
    fprintf('\n................................. CA-TPD START OF SEASON (SGS) DIFFERENCES (VI - GEP) .................................\n');
    fprintf('GCC  - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_sgs.GCC, 'omitnan'),   std(diff_sgs.GCC, 'omitnan'),   length(diff_sgs.GCC));
    fprintf('RCC  - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_sgs.RCC, 'omitnan'),   std(diff_sgs.RCC, 'omitnan'),   length(diff_sgs.RCC));
    fprintf('GRRI - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_sgs.GRRI, 'omitnan'),  std(diff_sgs.GRRI, 'omitnan'),  length(diff_sgs.GRRI));
    fprintf('GRIVI- GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_sgs.GRIVI, 'omitnan'), std(diff_sgs.GRIVI, 'omitnan'), length(diff_sgs.GRIVI));

    fprintf('\n................................. CA-TPD END OF SEASON (EGS) DIFFERENCES (VI - GEP) .................................\n');
    fprintf('GCC  - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_egs.GCC, 'omitnan'),   std(diff_egs.GCC, 'omitnan'),   length(diff_egs.GCC));
    fprintf('RCC  - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_egs.RCC, 'omitnan'),   std(diff_egs.RCC, 'omitnan'),   length(diff_egs.RCC));
    fprintf('GRRI - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_egs.GRRI, 'omitnan'),  std(diff_egs.GRRI, 'omitnan'),  length(diff_egs.GRRI));
    fprintf('GRIVI- GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_egs.GRIVI, 'omitnan'), std(diff_egs.GRIVI, 'omitnan'), length(diff_egs.GRIVI));
    fprintf('....................................................................................................................................\n');
    
    %%
    iw = ((datetime(year(max(ROITPD.daydate(1),RCC.MaxTdate(1))),1,1)):days(1):...
        (datetime(year(min(ROITPD.daydate(end),RCC.MaxTdate(end))),12,31)))';
    iz = unique(year(iw));
    y1=0;      y2=10;     y3 = (y1:(y2-y1)/2:y2)';
    x1=0;      x2=365;    x4 = x1:50:x2;             x3 = (x1:50:x2)';
    v1 = 0;    v2 = 30;   v3 = v1:((v2-v1)/3):v2;
    w1 = 0.26; w2 = .50;  w3 = w1:((w2-w1)/3):w2;

    figure('color','white');
    yearSelect = 1;
    while yearSelect<=length(iz) %(4*ceil(length(iz)/4))
        subplot(ceil(length(iz)./4),4,yearSelect);
        ind = find(TPD.dayY==iz(yearSelect));
        yyaxis left;
        y = [TPD.day_recurrentGEPday(ind)-TPD.day_recurrent_stdGEPday(ind),2.*TPD.day_recurrent_stdGEPday(ind)];
        h = area(TPD.daydate(ind),y);       set(gca,'Layer','top');
        set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
        set(h,'BaseValue',0);
        hold on;
        % hl1 = plot(TPD.daydate(ind),TPD.dayGEPday(ind),'-','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;
        hl6 = scatter(TPD.daydate(ind),TPD.dayGEPday(ind),2,'MarkerFaceColor',[0.4 0.4 0.4],'MarkerEdgeColor',[0.5 0.5 0.5],...
            'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        hl1 = plot([GEP.BegTdate,GEP.BegTdate],[v1,v2],'--','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;
        hl1 = plot([GEP.EndTdate,GEP.EndTdate],[v1,v2],'--','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;

        ind = find(TPD.dayY==iz(yearSelect));
        hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
        ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month;
        set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(iz(yearSelect),1,1) datetime(iz(yearSelect),12,31)],...
            'FontSize',12,'XMinorGrid','on','Xtick','','YTickLabel','');
        if ((yearSelect==1)|(yearSelect==5)|(yearSelect==9)|(yearSelect==13))
            set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(iz(yearSelect),1,1) datetime(iz(yearSelect),12,31)],...
                'FontSize',12,'XMinorGrid','on','Xtick','','YTickLabel',v3);
        end
        xtickangle(0); box on;   grid on;
        title(num2str(iz(yearSelect)),'FontSize',12,'FontWeight','normal')
        if ((yearSelect==5)|(yearSelect==13))
            ylabel ({'photosynthesis (gC m^-^2 d^-^1)'},'FontSize',12);
        end
        if (yearSelect>=13)
            set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(iz(yearSelect),1,1) datetime(iz(yearSelect),12,31)],...
                'FontSize',12,'XMinorGrid','on');
        end
        yyaxis right;
        ind = find(TPD.dayY==iz(yearSelect));
        scatter(TPD.daydate(ind),TPD.ROIrcc(ind),'.','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
            'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
        plot(TPD.daydate(ind),TPD.ROIrcc(ind),'-','Color',color_mtx_dark(3,:),'Linewidth',1);
        hl2 = plot([RCC.MaxTdate,RCC.MaxTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(3,:)); hold on; alpha = 0.3;
        hl2 = plot([RCC.MaxTdate,RCC.MaxTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(3,:)); hold on; alpha = 0.3;

        scatter(TPD.daydate(ind),TPD.ROIgcc(ind),'.','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
            'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
        plot(TPD.daydate(ind),TPD.ROIgcc(ind),'-','Color',color_mtx_dark(2,:),'Linewidth',1);
        hl3 = plot([GCC.BegTdate,GCC.BegTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(2,:)); hold on; alpha = 0.3;
        hl3 = plot([GCC.EndTdate,GCC.EndTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(2,:)); hold on; alpha = 0.3;

        set(ax2,'YTick',w3,'YTickLabel','','YLim',[w1 w2],'XLim',[datetime(iz(yearSelect),1,1) datetime(iz(yearSelect),12,31)]);
        if ((yearSelect==4)|(yearSelect==8)|(yearSelect==12)|(yearSelect==16))
            set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(iz(yearSelect),1,1) datetime(iz(yearSelect),12,31)],...
                'YTickLabel',w3);
        end
        ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(3,:); ax2.YAxis(2).Color = color_mtx_dark(3,:);
        if (yearSelect>=9)
            set(ax2,'Xtick',datetime(iz(yearSelect),1:1:12,1),'XtickLabel',datestr(datetime(iz(yearSelect),1:1:12,1),'m'),...
                'FontSize',12);
        end
        if ((yearSelect==4)|(yearSelect==12))
            ylabel ('RCC_{phenocam}','FontSize',12,'color',color_mtx_dark(3,:));
        end
        if ((yearSelect==8))
            ylabel ('GCC_{phenocam}','FontSize',12,'color',color_mtx_dark(2,:));
        end

        xtickangle(0);   box on;
        % legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
        yearSelect = yearSelect+1;
    end
    % .........................................................................
    %% GEP/PAR
    % .........................................................................
    ix = (ROITPD.daydateY(1):1:ROITPD.daydateY(end))'; count =2;
    x1=ix(1);  x2=ix(end);   x4 = x1:1:x2;             x3 = (x1:2:x2)';
    figure('color','white');
    y1=105;     y2=140;       y3 = (y1:(y2-y1)/5:y2)';
    subplot(2,1,1);          hold on;
    count = 1;
    hl1 = scatter(year(GEPpar.BegTdate),GEPpar.BegTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GEPpar.BegTdate),GEPpar.BegTjd,num2str(GEPpar.BegTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 2;
    hl2 = scatter(year(GCC.BegTdate),GCC.BegTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GCC.BegTdate),GCC.BegTjd,num2str(GCC.BegTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 3;
    hl3 = scatter(year(RCC.MaxTdate),RCC.MaxTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(RCC.MaxTdate),RCC.MaxTjd,num2str(RCC.MaxTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    axis ([x1 x2 y1 y2]);
    %         xlabel({'start season (DOY)';['\mu DOY:' num2str(round(muhat.BegT)) ' \sigma:' num2str(round(sigmahat.BegT)) 'days']});
    ylabel({'season (DOY)'});     %xlabel('year');
    set(gca,'XTick',x4,'XTickLabel',x3,'YTick',y3,'XLim',[x1 x2],'YLim',[y1 y2],'FontSize',10);
    xtickangle(0);                      grid on;     box on;
    legend([hl1,hl2,hl3],'start GEP/PAR','start GCC','*max* RCC','FontSize',10,'orientation','horizontal'); legend box off;

    y1=270;     y2=350;       y3 = (y1:(y2-y1)/5:y2)';
    subplot(2,1,2);          hold on;
    count = 1;
    hl1 = scatter(year(GEPpar.EndTdate),GEPpar.EndTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GEPpar.EndTdate),GEPpar.EndTjd,num2str(GEPpar.EndTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 2;
    hl2 = scatter(year(GCC.EndTdate),GCC.EndTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(GCC.EndTdate),GCC.EndTjd,num2str(GCC.EndTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    count = 3;
    hl3 = scatter(year(RCC.MaxTdate),RCC.MaxTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
        'MarkerEdgeColor',color_mtx_light(count,:),'MarkerFaceAlpha',.5);
    text(year(RCC.MaxTdate),RCC.MaxTjd,num2str(RCC.MaxTjd),'Color',color_mtx_dark(count,:),'FontSize',8);
    axis ([x1 x2 y1 y2]);
    %         xlabel({'start season (DOY)';['\mu DOY:' num2str(round(muhat.BegT)) ' \sigma:' num2str(round(sigmahat.BegT)) 'days']});
    ylabel({'season (DOY)'});     %xlabel('year');
    set(gca,'XTick',x4,'XTickLabel',x3,'YTick',y3,'XLim',[x1 x2],'YLim',[y1 y2],'FontSize',10);
    xtickangle(0);                      grid on;  box on;
    legend([hl1,hl2,hl3],'end GEP/PAR','end GCC','*max* RCC','FontSize',10,'orientation','horizontal'); legend box off;

    %%
    iw = ((datetime(year(max(ROITPD.daydate(1),RCC.MaxTdate(1))),1,1)):days(1):...
        (datetime(year(min(ROITPD.daydate(end),RCC.MaxTdate(end))),12,31)))';
    iz = unique(year(iw));
    y1=0;      y2=10;     y3 = (y1:(y2-y1)/2:y2)';
    x1=0;      x2=365;    x4 = x1:50:x2;             x3 = (x1:50:x2)';
    v1 = 0;    v2 = 45;   v3 = v1:((v2-v1)/3):v2;
    w1 = 0.26; w2 = .53;  w3 = w1:((w2-w1)/3):w2;

    figure('color','white');
    yearSelect = 1;
    while yearSelect<=length(iz) %(4*ceil(length(iz)/4))
        subplot(ceil(length(iz)./4),4,yearSelect);
        ind = find(TPD.dayY==iz(yearSelect));
        yyaxis left;
        y = [TPD.day_recurrentGEPparday(ind)-TPD.day_recurrent_stdGEPparday(ind),2.*TPD.day_recurrent_stdGEPparday(ind)];
        h = area(TPD.daydate(ind),y);       set(gca,'Layer','top');
        set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
        set(h,'BaseValue',0);
        hold on;
        % hl1 = plot(TPD.daydate(ind),TPD.dayGEPparday(ind),'-','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;
        hl6 = scatter(TPD.daydate(ind),TPD.dayGEPpar(ind),2,'MarkerFaceColor',[0.4 0.4 0.4],'MarkerEdgeColor',[0.5 0.5 0.5],...
            'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        hl1 = plot([GEPpar.BegTdate,GEPpar.BegTdate],[v1,v2],'--','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;
        hl1 = plot([GEPpar.EndTdate,GEPpar.EndTdate],[v1,v2],'--','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;

        ind = find(TPD.dayY==iz(yearSelect));
        hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
        ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TPD.month;
        set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(iz(yearSelect),1,1) datetime(iz(yearSelect),12,31)],...
            'FontSize',12,'XMinorGrid','on','Xtick','','YTick','');
        if ((yearSelect==1)|(yearSelect==5)|(yearSelect==9)|(yearSelect==13))
            set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(iz(yearSelect),1,1) datetime(iz(yearSelect),12,31)],...
                'FontSize',12,'XMinorGrid','on','Xtick','','YTickLabel',v3);
        end
        xtickangle(0); box on;   grid on;
        title(num2str(iz(yearSelect)),'FontSize',12,'FontWeight','normal')
        if ((yearSelect==5)|(yearSelect==13))
            ylabel ({'GEP/PAR (gC mol^-^1)'},'FontSize',12);
        end
        if (yearSelect>=13)
            set(ax2,'YTick',v3,'YLim',[v1 v2],'XLim',[datetime(iz(yearSelect),1,1) datetime(iz(yearSelect),12,31)],...
                'FontSize',12,'XMinorGrid','on');
        end
        yyaxis right;
        ind = find(TPD.dayY==iz(yearSelect));
        scatter(TPD.daydate(ind),TPD.ROIrcc(ind),'.','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
            'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
        plot(TPD.daydate(ind),TPD.ROIrcc(ind),'-','Color',color_mtx_dark(3,:),'Linewidth',1);
        hl2 = plot([RCC.MaxTdate,RCC.MaxTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(3,:)); hold on; alpha = 0.3;
        hl2 = plot([RCC.MaxTdate,RCC.MaxTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(3,:)); hold on; alpha = 0.3;

        scatter(TPD.daydate(ind),TPD.ROIgcc(ind),'.','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
            'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
        plot(TPD.daydate(ind),TPD.ROIgcc(ind),'-','Color',color_mtx_dark(2,:),'Linewidth',1);
        hl3 = plot([GCC.BegTdate,GCC.BegTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(2,:)); hold on; alpha = 0.3;
        hl3 = plot([GCC.EndTdate,GCC.EndTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(2,:)); hold on; alpha = 0.3;

        ax2 = gca;  ax2.YAxis(2).TickLabelColor = color_mtx_dark(3,:); ax2.YAxis(2).Color = color_mtx_dark(3,:);
        set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(iz(yearSelect),1,1) datetime(iz(yearSelect),12,31)],'YTickLabel','');
        if ((yearSelect==4)|(yearSelect==8)|(yearSelect==12)|(yearSelect==16))
            set(ax2,'YTick',w3,'YLim',[w1 w2],'XLim',[datetime(iz(yearSelect),1,1) datetime(iz(yearSelect),12,31)],...
                'YTickLabel',w3);
        end
        if (yearSelect>=9)
            set(ax2,'Xtick',datetime(iz(yearSelect),1:1:12,1),'XtickLabel',datestr(datetime(iz(yearSelect),1:1:12,1),'m'),...
                'FontSize',12);
        end
        if ((yearSelect==4)|(yearSelect==12))
            ylabel ('RCC_{phenocam}','FontSize',12,'color',color_mtx_dark(3,:));
        end
        if ((yearSelect==8))
            ylabel ('GCC_{phenocam}','FontSize',12,'color',color_mtx_dark(2,:));
        end

        xtickangle(0);   box on;
        % legend([hl5,hl6,hl7],'Q95','diff AR{1}','Hurst<0.5','color','none'); legend box off;
        yearSelect = yearSelect+1;
    end
end

% .........................................................................
%% duration
% .........................................................................
[commonYears, ia, ib] = intersect(year(GEP.BegTdate),year(GCC.BegTdate));
GEPoffsetVI = table();
GEPoffsetVI.year = commonYears;
GEPoffsetVI.durationSGS = days(GEP.BegTdate(ia) - GCC.BegTdate(ib));
mean(GEPoffsetVI.durationSGS(GEPoffsetVI.durationSGS<20))
GEPoffsetVI.durationEGS = days(GEP.EndTdate(ia) - GCC.EndTdate(ib));
mean(GEPoffsetVI.durationEGS(GEPoffsetVI.durationEGS<20))
