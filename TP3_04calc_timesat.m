addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;
addpath /home/ncoupe/Documents/timesat33/timesat_matlab/main/
addpath /home/ncoupe/Documents/timesat33/timesat_matlab/tools/
addpath /home/ncoupe/Documents/timesat33/timesat_matlab/
load matlabTP3.mat

flag_input = 1;            flag_read_timesat = 1;

if flag_input==1
    windowSmooth = 21;

    % snow
    % polyorder  = 2;      % Polynomial order (typically 2 or 3)
    % framesize = 21;      % Window size (must be odd)
    % ROI.b_golay = sgolayfilt(ROI.b_mean,polyorder,framesize);
    ROI.b_golay = smoothdata(ROI.b_mean,'movmean');

    % .....................................................................
    %% GCC
    % .....................................................................
    figure('color','white');
    plot(ROI.daydate,ROI.gcc_mean); hold on;  ylabel('GCC');
    ROI.gcc_mean((ROI.gcc_mean<0.27)) = NaN;
    plot(ROI.daydate,ROI.gcc_mean,'.')

    [iy,~,~,~,ix] = AM_day(ROI.gcc_mean,ROI.daydate,0);
    plot(ix,iy)
    [im,~,~] = datevec(ix);

    newTime = (datetime(im(1),1,1):days(1):datetime(im(end)+1,12,31))';
    in = find(newTime==ix(1));   im = find(newTime==ix(end));
    iw = NaN(in-1,1);            iz = NaN(length(newTime)-im,1);
    ROITP3.dayGCC = [iw;iy;iz];  ROITP3.daydate = newTime;
    plot(ROITP3.daydate, ROITP3.dayGCC);

    [ROITP3.day_recurrentGCC,ROITP3.day_recurrent_stdGCC] = AM_fill_day_avg(ROITP3.dayGCC,ROITP3.daydate);
    ROITP3.day_recurrentGCCGoley = sgolayfilt(ROITP3.day_recurrentGCC,polyorder,framesize);

    ROITP3.dayJD = day(ROITP3.daydate,'dayofyear');
    [ROITP3.dayY,ROITP3.dayM,ROITP3.dayD] = datevec(ROITP3.daydate);

    ix = AM_fill_plus(ROITP3.dayGCC);   ix(isnan(ix)) = ROITP3.day_recurrentGCC(isnan(ix));
    % iy = zeros(length(ix),1);           iy(isnan(ix)) = 2;      %iy(ROI.b_golay>45) = 2;
    iy = ones(length(ix),1);            iy(isnan(ix)) = 0;
    ind = find((ROITP3.dayM==2)&(ROITP3.dayD==29));
    ix(ind) = [];                           iy(ind) = [];
    header = [num2str(round(length(ROITP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (ix.*100,'timesat/TP3tabletimesatGCC.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatGCC.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatGCC.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(ROITP3.daydate)./365)) num2str((length(ROITP3.daydate))/round(length(ROITP3.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(ROITP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TP3tabletimesatGCCqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatGCCqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatGCCqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % Create a table
    % T = table(ROITP3.dayY, ROITP3.dayJD, ROITP3.dayGCC);%, 'VariableNames', {'Year', 'DayOfYear', 'GCC'});

    % .....................................................................
    %% RCC
    % .....................................................................
    figure('color','white');
    plot(ROI.daydate,ROI.rcc_mean); hold on;  ylabel('RCC');
    ROI.rcc_mean((ROI.rcc_mean<0.36)|(ROI.rcc_mean>0.48)) = NaN;
    % % polyorder = 2;      % Polynomial order (typically 2 or 3)
    % % framesize = 27;     % Window size (must be odd)
    % % ix = sgolayfilt(ROI.rcc_mean,polyorder,framesize);
    ix  = smoothdata(ROI.rcc_mean,'movmean',windowSmooth);
    ind = find((ROI.dayM>=12)|(ROI.dayM<=4)); ROI.rcc_mean(ind) = ix(ind);
    ROI.rcc_mean = ix;
    % ROI.rcc_mean(ROI.daydate<datetime(2013,5,6)) = NaN;
    plot(ROI.daydate,ROI.rcc_mean,'.k')

    [iy,~,~,~,ix] = AM_day(ROI.rcc_mean,ROI.daydate,0);
    plot(ix,iy)
    [im,~,~] = datevec(ix);
    newTime = (datetime(im(1),1,1):days(1):datetime(im(end)+1,12,31))';
    in = find(newTime==ix(1));   im = find(newTime==ix(end));
    iw = NaN(in-1,1);            iz = NaN(length(newTime)-im,1);
    ROITP3.dayRCC = [iw;iy;iz];  ROITP3.daydate = newTime;
    plot( ROITP3.daydate, ROITP3.dayRCC);

    [ROITP3.day_recurrentRCC,ROITP3.day_recurrent_stdRCC]  = AM_fill_day_avg(ROITP3.dayRCC,ROITP3.daydate);
    ROITP3.day_recurrentRCCGoley = sgolayfilt(ROITP3.day_recurrentRCC,polyorder,framesize);

    ROITP3.dayJD = day(ROITP3.daydate,'dayofyear');
    [ROITP3.dayY,ROITP3.dayM,ROITP3.dayD] = datevec(ROITP3.daydate);

    ix = AM_fill_plus(ROITP3.dayRCC);     ix(isnan(ix)) = ROITP3.day_recurrentRCC(isnan(ix));
    % iy = zeros(length(ix),1);           iy(isnan(ix)) = 2;      %iy(ROI.b_golay>45) = 2;
    iy = ones(length(ix),1);              iy(isnan(ix)) = 0;
    ind = find((ROITP3.dayM==2)&(ROITP3.dayD==29));
    ix(ind) = [];                         iy(ind) = [];
    header = [num2str(round(length(ROITP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (ix.*100,'timesat/TP3tabletimesatRCC.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatRCC.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatRCC.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    figure('color','white');
    iz = 1-ix;           plot(iz);       hold on;              ylabel('RCCabs');
    writematrix (iz.*100,'timesat/TP3tabletimesatRCCabs.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatRCCabs.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatRCCabs.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    % header = [num2str(round(length(ROITP3.daydate)./365)) num2str((length(ROITP3.daydate))/round(length(ROITP3.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(ROITP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TP3tabletimesatRCCqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatRCCqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatRCCqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % Create a table
    % T = table(ROITP3.dayY, ROITP3.dayJD, ROITP3.dayRCC);%, 'VariableNames', {'Year', 'DayOfYear', 'RCC'});

    % .....................................................................
    %% GRRI
    % .....................................................................
    figure('color','white');
    plot(ROI.daydate,ROI.GRRI_mean); hold on;  ylabel('GRRI');
    % % polyorder  = 2;      % Polynomial order (typically 2 or 3)
    % % framesize = 27;     % Window size (must be odd)
    % % ix = sgolayfilt(ROI.GRRI_mean,polyorder,framesize);
    ix = smoothdata(ROI.GRRI_mean,'movmean');
    ind = find((ROI.dayM>=12)|(ROI.dayM<=4)|(ROI.GRRI_mean>1.7)); ROI.GRRI_mean(ind) = ix(ind);
    plot(ROI.daydate,ROI.GRRI_mean,'.')

    [iy,~,~,~,ix] = AM_day(ROI.GRRI_mean,ROI.daydate,0);
    plot(ix,iy)
    [im,~,~] = datevec(ix);

    newTime = (datetime(im(1),1,1):days(1):datetime(im(end)+1,12,31))';
    in = find(newTime==ix(1));    im = find(newTime==ix(end));
    iw = NaN(in-1,1);             iz = NaN(length(newTime)-im,1);
    ROITP3.dayGRRI = [iw;iy;iz];  ROITP3.daydate = newTime;
    plot( ROITP3.daydate, ROITP3.dayGRRI);

    [ROITP3.day_recurrentGRRI,ROITP3.day_recurrent_stdGRRI]  = AM_fill_day_avg(ROITP3.dayGRRI,ROITP3.daydate);
    ROITP3.day_recurrentGRRIGoley = sgolayfilt(ROITP3.day_recurrentGRRI,polyorder,framesize);

    ROITP3.dayJD = day(ROITP3.daydate,'dayofyear');
    [ROITP3.dayY,ROITP3.dayM,ROITP3.dayD] = datevec(ROITP3.daydate);

    ix = AM_fill_plus(ROITP3.dayGRRI);    ix(isnan(ix)) = ROITP3.day_recurrentGRRI(isnan(ix));
    % iy = zeros(length(ix),1);           iy(isnan(ix)) = 2;      %iy(ROI.b_golay>45) = 2;
    iy = ones(length(ix),1);            iy(isnan(ix)) = 0;
    ind = find((ROITP3.dayM==2)&(ROITP3.dayD==29));
    ix(ind) = [];                         iy(ind) = [];
    header = [num2str(round(length(ROITP3.daydate)./365)) ' 365 ' num2str(1) ];
    % iy = 1-ix;
    writematrix (ix.*100,'timesat/TP3tabletimesatGRRI.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatGRRI.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatGRRI.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(ROITP3.daydate)./365)) num2str((length(ROITP3.daydate))/round(length(ROITP3.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(ROITP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TP3tabletimesatGRRIqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatGRRIqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatGRRIqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % Create a table
    % T = table(ROITP3.dayY, ROITP3.dayJD, ROITP3.dayGRRI);%, 'VariableNames', {'Year', 'DayOfYear', 'GRRI'});

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
    ROITP3.dayGRIVI = [iw;iy;iz];  ROITP3.daydate = newTime;
    plot( ROITP3.daydate, ROITP3.dayGRIVI);

    [ROITP3.day_recurrentGRIVI,ROITP3.day_recurrent_stdGRIVI]  = AM_fill_day_avg(ROITP3.dayGRIVI,ROITP3.daydate);
    ROITP3.day_recurrentGRIVIGoley = sgolayfilt(ROITP3.day_recurrentGRIVI,polyorder,framesize);

    ROITP3.dayJD = day(ROITP3.daydate,'dayofyear');
    [ROITP3.dayY,ROITP3.dayM,ROITP3.dayD] = datevec(ROITP3.daydate);

    ix = AM_fill_plus(ROITP3.dayGRIVI);   ix(isnan(ix)) = ROITP3.day_recurrentGRIVI(isnan(ix));
    iy = zeros(length(ix),1);             iy(isnan(ix)) = 2;   iy(ROI.b_golay>55) = 2;
    ind = find((ROITP3.dayM==2)&(ROITP3.dayD==29));
    ix(ind) = [];                         iy(ind) = [];
    header = [num2str(round(length(ROITP3.daydate)./365)) ' 365 ' num2str(1) ];
    % iy = 1-ix;
    writematrix (ix.*100,'timesat/TP3tabletimesatGRIVI.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatGRIVI.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatGRIVI.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(ROITP3.daydate)./365)) num2str((length(ROITP3.daydate))/round(length(ROITP3.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(ROITP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TP3tabletimesatGRIVIqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatGRIVIqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatGRIVIqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    %%
    % timesat was having a hard time finding the peak and two minima (egs
    % and sgs) so let us do it ourselves
    windowSize = 21;
    % smoothedGRIVI = sgolayfilt(ROITP3.dayGRIVI, 3, windowSize);
    smoothedGRIVI = smoothdata(ROITP3.dayGRIVI, windowSize);
    ROITP3.years = unique(year(ROITP3.daydate));  ROITP3.years(end) = [];
    numYears = length(ROITP3.years);
    Year = zeros(numYears, 1);
    BegTdate = datetime(zeros(numYears,1), 0, 0); Val_Winter_Min = nan(numYears, 1);
    MaxTdate = datetime(zeros(numYears,1), 0, 0); Val_Peak = nan(numYears, 1);
    EndTdate = datetime(zeros(numYears,1), 0, 0); Val_Absolute_Min = nan(numYears, 1);

    for ix = 1:numYears
        currYear = ROITP3.years(ix);
        yearMask = (year(ROITP3.daydate) == currYear);
        idx = find(yearMask);

        idx(ROITP3.dayJD(idx) < (31+28)) = [];

        if (isempty(idx))|(length(idx)<10), continue; end
        Year(ix) = currYear;

        [vP, rP] = max(smoothedGRIVI(idx));
        peakAbsIdx = idx(rP);
        MaxTdate(ix) = ROITP3.daydate(peakAbsIdx);
        Val_Peak(ix)  = vP;

        searchStartW = max(idx(1), peakAbsIdx - 100);
        [vW, rW] = min(smoothedGRIVI(searchStartW:peakAbsIdx));
        BegTdate(ix) = ROITP3.daydate(searchStartW + rW - 1);
        Val_Winter_Min(ix) = vW;

        searchEndIdx = idx(end);
        [vA, rA] = min(smoothedGRIVI(peakAbsIdx:searchEndIdx));
        EndTdate(ix) = ROITP3.daydate(peakAbsIdx + rA - 1);
        Val_Absolute_Min(ix) = vA;
    end

    TP3seasonalityGRIVI = table(Year, BegTdate, Val_Winter_Min, ...
        MaxTdate, Val_Peak, ...
        EndTdate, Val_Absolute_Min);
    TP3seasonalityGRIVI(TP3seasonalityGRIVI.Year <= 0 | isnan(TP3seasonalityGRIVI.Year), :) = [];
    disp(TP3seasonalityGRIVI);
    writetable(TP3seasonalityGRIVI, 'timesat/TP3seasonalityGRIVI.txt', 'WriteVariableNames', true, 'Delimiter', '\t');

    figure('color','white');   plot(ROITP3.daydate, ROITP3.dayGRIVI, 'Color', [0.8 0.8 0.8]); hold on;
    plot(ROITP3.daydate, smoothedGRIVI, 'b', 'LineWidth', 1.5);
    plot(TP3seasonalityGRIVI.BegTdate, TP3seasonalityGRIVI.Val_Winter_Min, 'ms', 'MarkerFaceColor', 'm');
    plot(TP3seasonalityGRIVI.MaxTdate, TP3seasonalityGRIVI.Val_Peak, 'ro', 'MarkerFaceColor', 'r');
    plot(TP3seasonalityGRIVI.EndTdate, TP3seasonalityGRIVI.Val_Absolute_Min, 'gd', 'MarkerFaceColor', 'g');
    title('ROITP3 Phenological Milestones: Absolute Minima Correction');
    grid on;   ylabel('GRIVI');
    % Create a table
    % T = table(ROITP3.dayY, ROITP3.dayJD, ROITP3.dayGRIVI);%, 'VariableNames', {'Year', 'DayOfYear', 'GRIVI'});

    % .....................................................................
    %% EVI
    % .....................................................................
    TP3.dayJD = day(TP3.daydate,'dayofyear');
    [TP3.dayY,TP3.dayM,TP3.dayD] = datevec(TP3.daydate);

    ix = AM_fill_plus(TP3.dayEVI);            ix(isnan(ix)) = TP3.day_recurrentEVI(isnan(ix));
    iy = ones(length(ix),1);                         iy(isnan(ix))=0;
    ind = find((TP3.dayM==2)&(TP3.dayD==29));
    ix(ind) = [];                                            iy(ind) = [];
    header = [num2str(round(length(TP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (ix.*100,'timesat/TP3tabletimesatEVI.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatEVI.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatEVI.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(TP3.daydate)./365)) num2str((length(TP3.daydate))/round(length(TP3.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(TP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TP3tabletimesatEVIqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatEVIqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatEVIqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    % .....................................................................
    %% GEP
    % .....................................................................
    TP3.dayGEPqa = TP3.dayGEPday;
    % % TP3.dayGEPqa((TP3.daydate>datetime(1992,12,20))&(TP3.daydate<datetime(1993,2,23))) = NaN;
    % % TP3.dayGEPqa((TP3.daydate>datetime(2015,1,15))&(TP3.daydate<datetime(2015,2,27))) = NaN;
    % % TP3.dayGEPqa((TP3.daydate>datetime(2010,12,11))&(TP3.daydate<datetime(2011,2,1))) = NaN;
    TP3.dayGEPqa(TP3.dayGEPqa<-1) = NaN;
    figure; plot(TP3.daydate, TP3.dayGEPday); hold on; plot(TP3.daydate, TP3.dayGEPqa);
    TP3.dayGEPqa((TP3.daytairdaymin<0)&(TP3.dayGEPqa>1)) = NaN;
    plot(TP3.daydate, TP3.dayGEPqa,'g');
    [TP3.day_recurrentGEPday,TP3.day_recurrent_stdGEPday]  = AM_fill_day_avg(TP3.dayGEPqa,TP3.daydate);
    TP3.day_recurrentGEPdayGoley = sgolayfilt(TP3.day_recurrentGEPday,polyorder,framesize);

    TP3.dayJD = day(TP3.daydate,'dayofyear');
    [TP3.dayY,TP3.dayM,TP3.dayD] = datevec(TP3.daydate);

    ix = AM_fill_plus(TP3.dayGEPqa);          ix(isnan(ix)) = TP3.day_recurrentGEPday(isnan(ix));
    iy = ones(length(ix),1);                  iy(isnan(ix))=0;
    ind = find((TP3.dayM==2)&(TP3.dayD==29));
    ix(ind) = [];                                            iy(ind) = [];
    header = [num2str(round(length(TP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (ix,'timesat/TP3tabletimesatGEP.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatGEP.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatGEP.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(TP3.daydate)./365)) num2str((length(TP3.daydate))/round(length(TP3.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(TP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TP3tabletimesatGEPqaqc.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatGEPqaqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatGEPqaqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    % .....................................................................
    %% GEP/PAR
    % .....................................................................
    TP3.dayGEPpar = TP3.dayGEPday.*1000./TP3.dayPARday;
    figure; plot(TP3.daydate, TP3.dayGEPpar); hold on;  ylabel('GEP/PAR');
    % TP3.dayGEPpar((TP3.daydate>datetime(1992,12,20))&(TP3.daydate<datetime(1993,2,23))) = NaN;
    % TP3.dayGEPpar((TP3.daydate>datetime(2015,1,15))&(TP3.daydate<datetime(2015,2,27))) = NaN;
    % TP3.dayGEPpar((TP3.daydate>datetime(2010,12,11))&(TP3.daydate<datetime(2011,2,1))) = NaN;
    TP3.dayGEPpar((TP3.dayGEPpar<-10)|(TP3.dayGEPpar>60)) = NaN;
    plot(TP3.daydate, TP3.dayGEPpar);
    TP3.dayGEPpar((TP3.daytairdaymin<0)&(TP3.dayGEPpar>5)) = NaN;
    % TP3.dayGEPpar((TP3.dayM==12)|(TP3.dayM==1)&(TP3.dayGEPpar>10)) = NaN;
    % TP3.dayGEPpar = OZ_out_bad_neighbor(TP3.dayGEPpar);
    plot(TP3.daydate, TP3.dayGEPpar,'g');
    [TP3.day_recurrentGEPparday,TP3.day_recurrent_stdGEPparday] = AM_fill_day_avg(TP3.dayGEPpar,TP3.daydate);
    TP3.day_recurrentGEPpardayGoley = sgolayfilt(TP3.day_recurrentGEPparday,polyorder,framesize);
    plot(TP3.daydate, TP3.day_recurrentGEPpardayGoley,'m');

    TP3.dayJD = day(TP3.daydate,'dayofyear');
    [TP3.dayY,TP3.dayM,TP3.dayD] = datevec(TP3.daydate);

    ix = AM_fill_plus(TP3.dayGEPpar);         ix(isnan(ix)) = TP3.day_recurrentGEPpardayGoley(isnan(ix));
    iy = ones(length(ix),1);                  iy(isnan(ix))=0;
    ind = find((TP3.dayM==2)&(TP3.dayD==29));
    ix(ind) = [];                             iy(ind) = [];
    header = [num2str(round(length(TP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (ix,'timesat/TP3tabletimesatGEPpar.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatGEPpar.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatGEPpar.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);
    % header = [num2str(round(length(TP3.daydate)./365)) num2str((length(TP3.daydate))/round(length(TP3.daydate)./365)) num2str(1) ];
    header = [num2str(round(length(TP3.daydate)./365)) ' 365 ' num2str(1) ];
    writematrix (iy,'timesat/TP3tabletimesatGEPparqc.txt','Delimiter','tab');
    S = fileread('timesat/TP3tabletimesatGEPparqc.txt');
    S = [header, newline, S];
    fid = fopen('timesat/TP3tabletimesatGEPparqc.txt', 'w');
    if fid == -1, error('Cannot open file %s', FileName); end
    fwrite(fid, S, 'char');
    fclose(fid);

    % Write to CSV file
    % writetable(T, 'timesat/TP3tabletimesatGCC.txt');
    % timesat
    save('TP3.mat','ROITP3','-append')
    save('matlabTP3.mat','ROITP3','-append')
end


%% ........................................................................
if flag_read_timesat==1
    %% GCC
    filename = 'timesat/TP3seasonalityGCC.txt';
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
        if ~isnan(GCC.BegTtemp(ix));   GCC.BegTdate(ix) = ROITP3.daydate(ceil(GCC.BegTtemp(ix)));   end
        if ~isnan(GCC.EndTtemp(ix));   GCC.EndTdate(ix) = ROITP3.daydate(floor(GCC.EndTtemp(ix)));  end
        if ~isnan(GCC.MaxTtemp(ix));   GCC.MaxTdate(ix) = ROITP3.daydate(floor(GCC.MaxTtemp(ix)));  end
    end

    GCC.BegTjd = day(GCC.BegTdate,'dayofyear');
    GCC.EndTjd = day(GCC.EndTdate,'dayofyear');
    GCC.MaxTjd = day(GCC.MaxTdate,'dayofyear');

    ind = find((GCC.BegTdate>=ROITP3.daydate(1))&(GCC.BegTdate<=ROITP3.daydate(end)));  GCC.BegT = GCC.BegTjd(ind);
    ind = find((GCC.EndTdate>=ROITP3.daydate(1))&(GCC.EndTdate<=ROITP3.daydate(end)));  GCC.EndT = GCC.EndTjd(ind);
    ind = find((GCC.MaxTdate>=ROITP3.daydate(1))&(GCC.MaxTdate<=ROITP3.daydate(end)));  GCC.MaxT = GCC.MaxTjd(ind);

    [ROITP3.daydateY,ROITP3.daydateM,ROITP3.daydateD] = datevec(ROITP3.daydate);
    GCC.daydateYears = unique(ROITP3.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% GRRI
    filename = 'timesat/TP3seasonalityGRRI.txt';
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
        if ~isnan(GRRI.BegTtemp(ix));   GRRI.BegTdate(ix) = ROITP3.daydate(ceil(GRRI.BegTtemp(ix)));   end
        if ~isnan(GRRI.EndTtemp(ix));   GRRI.EndTdate(ix) = ROITP3.daydate(floor(GRRI.EndTtemp(ix)));  end
        if ~isnan(GRRI.MaxTtemp(ix));   GRRI.MaxTdate(ix) = ROITP3.daydate(floor(GRRI.MaxTtemp(ix)));  end
    end

    GRRI.BegTjd = day(GRRI.BegTdate,'dayofyear');
    GRRI.EndTjd = day(GRRI.EndTdate,'dayofyear');
    GRRI.MaxTjd = day(GRRI.MaxTdate,'dayofyear');

    ind = find((GRRI.BegTdate>=ROITP3.daydate(1))&(GRRI.BegTdate<=ROITP3.daydate(end)));  GRRI.BegT = GRRI.BegTjd(ind);
    ind = find((GRRI.EndTdate>=ROITP3.daydate(1))&(GRRI.EndTdate<=ROITP3.daydate(end)));  GRRI.EndT = GRRI.EndTjd(ind);
    ind = find((GRRI.MaxTdate>=ROITP3.daydate(1))&(GRRI.MaxTdate<=ROITP3.daydate(end)));  GRRI.MaxT = GRRI.MaxTjd(ind);

    [ROITP3.daydateY,ROITP3.daydateM,ROITP3.daydateD] = datevec(ROITP3.daydate);
    GRRI.daydateYears = unique(ROITP3.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% GRIVI
    filename = 'timesat/TP3seasonalityGRIVI.txt';
    GRIVI = readtable(filename, 'Delimiter', '\t');  GRIVI = table2struct(GRIVI, 'ToScalar', true);

    GRIVI.BegTjd = day(GRIVI.BegTdate, 'dayofyear');   % The start/first minima
    GRIVI.MaxTjd = day(GRIVI.MaxTdate, 'dayofyear');         % The peak
    GRIVI.EndTjd = day(GRIVI.EndTdate, 'dayofyear'); % The end/second minima
    % GRRI.Year = T.Year;[cite: 1]

    % GRIVI.BegT = [];            GRIVI.EndT = [];                GRIVI.MaxT = [];
    ind = find((GRIVI.BegTdate>=ROITP3.daydate(1))&(GRIVI.BegTdate<=ROITP3.daydate(end)));
    GRIVI.BegT = GRIVI.BegTjd(ind);
    ind = find((GRIVI.EndTdate>=ROITP3.daydate(1))&(GRIVI.EndTdate<=ROITP3.daydate(end)));  GRIVI.EndT = GRIVI.EndTjd(ind);
    ind = find((GRIVI.MaxTdate>=ROITP3.daydate(1))&(GRIVI.MaxTdate<=ROITP3.daydate(end)));  GRIVI.MaxT = GRIVI.MaxTjd(ind);

    [ROITP3.daydateY,ROITP3.daydateM,ROITP3.daydateD] = datevec(ROITP3.daydate);
    GRIVI.daydateYears = unique(ROITP3.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% RCC
    filename = 'timesat/TP3seasonalityRCC.txt';
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

    for ix = 1:length(RCC.BegTtemp) - 1
        if ~isnan(RCC.BegTtemp(ix));   RCC.BegTdate(ix) = ROITP3.daydate(ceil(RCC.BegTtemp(ix)));   end
        if ~isnan(RCC.EndTtemp(ix));   RCC.EndTdate(ix) = ROITP3.daydate(floor(RCC.EndTtemp(ix)));  end
        if ~isnan(RCC.MaxTtemp(ix));   RCC.MaxTdate(ix) = ROITP3.daydate(floor(RCC.MaxTtemp(ix)));  end
    end

    RCC.BegTjd = day(RCC.BegTdate,'dayofyear');
    RCC.EndTjd = day(RCC.EndTdate,'dayofyear');
    RCC.MaxTjd = day(RCC.MaxTdate,'dayofyear');

    ind = find((RCC.BegTdate>=ROITP3.daydate(1))&(RCC.BegTdate<=ROITP3.daydate(end)));  RCC.BegT = RCC.BegTjd(ind);
    ind = find((RCC.EndTdate>=ROITP3.daydate(1))&(RCC.EndTdate<=ROITP3.daydate(end)));  RCC.EndT = RCC.EndTjd(ind);
    ind = find((RCC.MaxTdate>=ROITP3.daydate(1))&(RCC.MaxTdate<=ROITP3.daydate(end)));  RCC.MaxT = RCC.MaxTjd(ind);

    RCC.daydateYears = unique(ROITP3.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% GEP
    filename = 'timesat/TP3seasonalityGEP.txt';
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
        if ~isnan(GEP.BegTtemp(ix));   GEP.BegTdate(ix) = TP3.daydate(ceil(GEP.BegTtemp(ix)));   end
        if ~isnan(GEP.EndTtemp(ix));   GEP.EndTdate(ix) = TP3.daydate(floor(GEP.EndTtemp(ix)));  end
        if ~isnan(GEP.MaxTtemp(ix));   GEP.MaxTdate(ix) = TP3.daydate(floor(GEP.MaxTtemp(ix)));  end
    end

    GEP.BegTjd = day(GEP.BegTdate,'dayofyear');
    GEP.EndTjd = day(GEP.EndTdate,'dayofyear');
    GEP.MaxTjd = day(GEP.MaxTdate,'dayofyear');

    ind = find((GEP.BegTdate>=TP3.daydate(1))&(GEP.BegTdate<=TP3.daydate(end)));  GEP.BegT = GEP.BegTjd(ind);
    ind = find((GEP.EndTdate>=TP3.daydate(1))&(GEP.EndTdate<=TP3.daydate(end)));  GEP.EndT = GEP.EndTjd(ind);
    ind = find((GEP.MaxTdate>=TP3.daydate(1))&(GEP.MaxTdate<=TP3.daydate(end)));  GEP.MaxT = GEP.MaxTjd(ind);

    [TP3.daydateY,TP3.daydateM,TP3.daydateD] = datevec(TP3.daydate);
    GEP.daydateYears = unique(TP3.daydateY);
    clearvars filename startRow formatSpec fileID dataArray ans;

    %% GEP
    filename = 'timesat/TP3seasonalityGEPpar.txt';
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
        if ~isnan(GEPpar.BegTtemp(ix));   GEPpar.BegTdate(ix) = TP3.daydate(ceil(GEPpar.BegTtemp(ix)));   end
        if ~isnan(GEPpar.EndTtemp(ix));   GEPpar.EndTdate(ix) = TP3.daydate(floor(GEPpar.EndTtemp(ix)));  end
        if ~isnan(GEPpar.MaxTtemp(ix));   GEPpar.MaxTdate(ix) = TP3.daydate(floor(GEPpar.MaxTtemp(ix)));  end
    end

    GEPpar.BegTjd = day(GEPpar.BegTdate,'dayofyear');
    GEPpar.EndTjd = day(GEPpar.EndTdate,'dayofyear');
    GEPpar.MaxTjd = day(GEPpar.MaxTdate,'dayofyear');

    ind = find((GEPpar.BegTdate>=TP3.daydate(1))&(GEPpar.BegTdate<=TP3.daydate(end)));  GEPpar.BegT = GEPpar.BegTjd(ind);
    ind = find((GEPpar.EndTdate>=TP3.daydate(1))&(GEPpar.EndTdate<=TP3.daydate(end)));  GEPpar.EndT = GEPpar.EndTjd(ind);
    ind = find((GEPpar.MaxTdate>=TP3.daydate(1))&(GEPpar.MaxTdate<=TP3.daydate(end)));  GEPpar.MaxT = GEPpar.MaxTjd(ind);

    [TP3.daydateY,TP3.daydateM,TP3.daydateD] = datevec(TP3.daydate);
    GEPpar.daydateYears = unique(TP3.daydateY);
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

    ix = (ROITP3.daydateY(1):1:ROITP3.daydateY(end))'; count =2;
    x1=ix(1);   x2=ix(end);   x4 = x1:2:x2;             x3 = (x1:6:x2)';
    figure('color','white');
    y1=55;     y2=150;       y3 = (y1:(y2-y1-2)/3:y2-2)';
    subplot(2,1,1);          hold on;
    count = 1;
    hl1 = scatter(year(GEP.BegTdate),GEP.BegTjd,50,'MarkerFaceColor',color_mtx_light(count,:),...
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
    axis ([x1 x2 y1 y2]);
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
    set(gca,'XTick',x4,'XTickLabel','','YTick',y3,'XLim',[x1 x2],'YLim',[y1 y2],'FontSize',14);
    xtickangle(0);                      grid on;     box on;
    legend([hl1,hl2,hl3,hl4,hl5],'start GEP','start GCC','peak RCC','GRRI','GRIVI','FontSize',10,...
        'orientation','horizontal','color','white','EdgeColor','none');
    text(year(GRIVI.BegTdate(1)),GRIVI.BegTjd(1),site_name,'FontWeight','normal');

    y1=270;     y2=342;      y3 = (y1:(y2-y1)/3:y2)';
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
    set(gca,'XTick',x4,'XTickLabel',x4,'YTick',y3,'XLim',[x1 x2],'YLim',[y1 y2],'FontSize',14);
    xtickangle(0);                      grid on;  box on;
    legend([hl1,hl2,hl3,hl4,hl5],'end GEP','end GCC','peak RCC','GRRI','GRIVI','FontSize',10,...
        'orientation','horizontal','color','white','EdgeColor','none');
    text(year(GCC.EndTdate(1)),GCC.EndTjd(1),site_name,'FontWeight','normal');

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
    fprintf('\n................................. CA-TP3 START OF SEASON (SGS) DIFFERENCES (VI - GEP) .................................\n');
    fprintf('GCC  - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_sgs.GCC, 'omitnan'),   std(diff_sgs.GCC, 'omitnan'),   length(diff_sgs.GCC));
    fprintf('RCC  - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_sgs.RCC, 'omitnan'),   std(diff_sgs.RCC, 'omitnan'),   length(diff_sgs.RCC));
    fprintf('GRRI - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_sgs.GRRI, 'omitnan'),  std(diff_sgs.GRRI, 'omitnan'),  length(diff_sgs.GRRI));
    fprintf('GRIVI- GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_sgs.GRIVI, 'omitnan'), std(diff_sgs.GRIVI, 'omitnan'), length(diff_sgs.GRIVI));

    fprintf('\n................................. CA-TP3 END OF SEASON (EGS) DIFFERENCES (VI - GEP) .................................\n');
    fprintf('GCC  - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_egs.GCC, 'omitnan'),   std(diff_egs.GCC, 'omitnan'),   length(diff_egs.GCC));
    fprintf('RCC  - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_egs.RCC, 'omitnan'),   std(diff_egs.RCC, 'omitnan'),   length(diff_egs.RCC));
    fprintf('GRRI - GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_egs.GRRI, 'omitnan'),  std(diff_egs.GRRI, 'omitnan'),  length(diff_egs.GRRI));
    fprintf('GRIVI- GEP: Mean = %6.2f days | Std = %6.2f days (N = %d years)\n', mean(diff_egs.GRIVI, 'omitnan'), std(diff_egs.GRIVI, 'omitnan'), length(diff_egs.GRIVI));
    fprintf('....................................................................................................................................\n');

    %%
    iw = ((datetime(year(max(ROITP3.daydate(1),RCC.MaxTdate(1))),1,1)):days(1):...
        (datetime(year(min(ROITP3.daydate(end),RCC.MaxTdate(end))),12,31)))';
    iz = unique(year(iw));
    y1=0;      y2=1;      y3 = (y1:(y2-y1)/2:y2)';
    x1=0;      x2=365;    x4 = x1:50:x2;             x3 = (x1:50:x2)';
    v1 = 0;    v2 = 30;   v3 = v1:((v2-v1)/3):v2;
    % w1 = 0.2;  w2 = .3;   w3 = w1:((w2-w1)/3):w2;
    w1 = .3;   w2 = .45;  w3 = w1:((w2-w1)/3):w2;

    figure('color','white');
    yearSelect = 1;
    while yearSelect<=(4*floor(length(iz)/4))
        subplot(floor(length(iz)./4),4,yearSelect);
        ind = find(TP3.dayY==iz(yearSelect));
        yyaxis left;
        y = [TP3.day_recurrentGEPday(ind)-TP3.day_recurrent_stdGEPday(ind),2.*TP3.day_recurrent_stdGEPday(ind)];
        h = area(TP3.daydate(ind),y);       set(gca,'Layer','top');
        set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
        set(h,'BaseValue',0);
        hold on;
        hl6 = scatter(TP3.daydate(ind),TP3.dayGEPday(ind),2,'MarkerFaceColor',[0.4 0.4 0.4],'MarkerEdgeColor',[0.5 0.5 0.5],...
            'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        hl1 = plot([GEP.BegTdate,GEP.BegTdate],[v1,v2],'--','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;
        hl1 = plot([GEP.EndTdate,GEP.EndTdate],[v1,v2],'--','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;

        ind = find(TP3.dayY==iz(yearSelect));
        hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
        ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TP3.month;
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
        ind = find(TP3.dayY==iz(yearSelect));
        % scatter(TP3.daydate(ind),TP3.ROIrcc(ind),'.','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
        %     'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
        % plot(TP3.daydate(ind),TP3.ROIrcc(ind),'-','Color',color_mtx_dark(3,:),'Linewidth',1);
        hl2 = plot([RCC.MaxTdate,RCC.MaxTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(3,:)); hold on; alpha = 0.3;
        hl2 = plot([RCC.MaxTdate,RCC.MaxTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(3,:)); hold on; alpha = 0.3;

        scatter(TP3.daydate(ind),TP3.ROIgcc(ind),'.','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
            'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
        plot(TP3.daydate(ind),TP3.ROIgcc(ind),'-','Color',color_mtx_dark(2,:),'Linewidth',1);
        hl3 = plot([GCC.BegTdate,GCC.BegTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(2,:)); hold on; alpha = 0.3;
        hl3 = plot([GCC.EndTdate,GCC.EndTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(2,:)); hold on; alpha = 0.3;


        scatter(TP3.daydate(ind),TP3.ROIrcc(ind),'.','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
            'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
        plot(TP3.daydate(ind),TP3.ROIrcc(ind),'-','Color',color_mtx_dark(4,:),'Linewidth',1);
        hl4 = plot([GRRI.BegTdate,RCC.BegTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(4,:)); hold on; alpha = 0.3;
        hl4 = plot([GRRI.EndTdate,RCC.EndTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(4,:)); hold on; alpha = 0.3;

        scatter(TP3.daydate(ind),TP3.ROIGRIVI(ind),'.','MarkerFaceColor',color_mtx(4,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
            'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
        plot(TP3.daydate(ind),TP3.ROIGRIVI(ind),'-','Color',color_mtx_dark(5,:),'Linewidth',1);
        hl5 = plot([GRIVI.BegTdate,GRIVI.BegTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(5,:)); hold on; alpha = 0.3;
        hl5 = plot([GRIVI.EndTdate,GRIVI.EndTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(5,:)); hold on; alpha = 0.3;

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
    ix = (ROITP3.daydateY(1):1:ROITP3.daydateY(end))'; count =2;
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
    iw = ((datetime(year(max(ROITP3.daydate(1),RCC.MaxTdate(1))),1,1)):days(1):...
        (datetime(year(min(ROITP3.daydate(end),RCC.MaxTdate(end))),12,31)))';
    iz = unique(year(iw));
    y1=0;      y2=10;     y3 = (y1:(y2-y1)/2:y2)';
    x1=0;      x2=365;    x4 = x1:50:x2;             x3 = (x1:50:x2)';
    v1 = 0;    v2 = 45;   v3 = v1:((v2-v1)/3):v2;
    w1 = 0.26; w2 = .53;  w3 = w1:((w2-w1)/3):w2;

    figure('color','white');
    yearSelect = 1;
    while yearSelect<=(4*floor(length(iz)/4))
        subplot(floor(length(iz)./4),4,yearSelect);
        ind = find(TP3.dayY==iz(yearSelect));
        yyaxis left;
        y = [TP3.day_recurrentGEPparday(ind)-TP3.day_recurrent_stdGEPparday(ind),2.*TP3.day_recurrent_stdGEPparday(ind)];
        h = area(TP3.daydate(ind),y);       set(gca,'Layer','top');
        set(h(2),'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8]);       set(h(1),'FaceColor','none','EdgeColor','none');
        set(h,'BaseValue',0);
        hold on;
        % hl1 = plot(TP3.daydate(ind),TP3.dayGEPparday(ind),'-','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;
        hl6 = scatter(TP3.daydate(ind),TP3.dayGEPpar(ind),2,'MarkerFaceColor',[0.4 0.4 0.4],'MarkerEdgeColor',[0.5 0.5 0.5],...
            'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5);
        hl1 = plot([GEPpar.BegTdate,GEPpar.BegTdate],[v1,v2],'--','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;
        hl1 = plot([GEPpar.EndTdate,GEPpar.EndTdate],[v1,v2],'--','LineWidth',0.5,'color',[0. 0. 0.]); hold on; alpha = 0.3;

        ind = find(TP3.dayY==iz(yearSelect));
        hold on;       ax2 = gca;             set(ax2,'YColor',[0.3 0.3 0.5]);
        ax2.XAxis.MinorTick = 'on';           ax2.XAxis.MinorTickValues = TP3.month;
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
        ind = find(TP3.dayY==iz(yearSelect));
        scatter(TP3.daydate(ind),TP3.ROIrcc(ind),'.','MarkerFaceColor',color_mtx(3,:),'MarkerEdgeColor',color_mtx_dark(3,:),...
            'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
        plot(TP3.daydate(ind),TP3.ROIrcc(ind),'-','Color',color_mtx_dark(3,:),'Linewidth',1);
        hl2 = plot([RCC.MaxTdate,RCC.MaxTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(3,:)); hold on; alpha = 0.3;
        hl2 = plot([RCC.MaxTdate,RCC.MaxTdate],[v1,v2],'--','LineWidth',0.5,'color',color_mtx_dark(3,:)); hold on; alpha = 0.3;

        scatter(TP3.daydate(ind),TP3.ROIgcc(ind),'.','MarkerFaceColor',color_mtx(2,:),'MarkerEdgeColor',color_mtx_dark(2,:),...
            'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
        plot(TP3.daydate(ind),TP3.ROIgcc(ind),'-','Color',color_mtx_dark(2,:),'Linewidth',1);
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

    %% ..................................................
    roiLength = width(ROI);
    color_mtx_dark = [0.67,0.87,0.64;0.17,0.51,0.73;0.89,0.68,0.38;0.84,0.10,0.11;...
        0.64,0.10,0.11;0.47,0.67,0.44];%jet(6);%othercolor('Dark28',16);
    color_mtx_light =color_mtx_dark;

    x = 0:1:365;         count =2;
    y1=0;     y2=4;     y3 = (y1:(y2-y1)/4:y2)';
    x1=0;     x2=365;    x4 = x1:50:x2;             x3 = [(x1:50:x2)'];
    figure('color','white');
    subplot(2,2,1);

    [muhat.BegT,sigmahat.BegT,muci.BegT,sigmaci.BegT]= normfit(GCC.BegT);
    n = numel(GCC.BegT);
    [bincounts,binedges] = histcounts(GCC.BegT,50);
    bincenters = binedges(1:end-1)+diff(binedges)/2;
    hh = bar(bincenters,bincounts,1,'FaceColor',color_mtx_light(count,:),...
        'EdgeColor',color_mtx_light(count,:),'FaceAlpha',.3);
    hold on
    binwidth = binedges(2)-binedges(1); % Finds the width of each bin
    areabin = n * binwidth;
    %         pd = fitdist(BegT,'Gamma');  mu = pd.a*pd.b;    sigma = sqrt(pd.a*pd.b^2);
    pd = fitdist(GCC.BegT,'tLocationScale');  mu = pd.mu;    sigma = pd.sigma;
    y = areabin * pdf(pd,x);
    hh1 = plot(x,y,'-','color',color_mtx_dark(count,:),'LineWidth',2);
    axis ([x1 x2 y1 y2]);
    %         xlabel({'start season (DOY)';['\mu DOY:' num2str(round(muhat.BegT)) ' \sigma:' num2str(round(sigmahat.BegT)) 'days']});
    xlabel({'start season (DOY)';...
        ['\mu DOY:' num2str(round(mu)) ' \sigma:' num2str(round(sigma)) ' [CI\sigma:' num2str(round(sigmaci.BegT(1))) '-' num2str(round(sigmaci.BegT(2))) '] days']});
    ylabel({'% individual crowns';['ROI:' num2str(roiLength) ' years:' num2str(round(length(TP3.daydate)/365))]});
    %returns 95% confidence intervals for the rgsameter estimates on the mean
    % text(50,8,[site_name_BF(ip)],'FontWeight','normal');
    set(gca,'XTick',x4,'XTickLabel',x3,'YTick',y3,'XLim',[x1 x2],'YLim',[y1 y2],'FontSize',12);
    xtickangle(0);     grid on;

    subplot(2,2,2);
    % if ip==3
    %     EndT(EndT<200) = EndT(EndT<200)+365;
    %     x1=200;     x2=565;     x4 = [(200:50:365)';(415:50:565)'];
    %     x3 = [(200:50:365)';(50:50:200)'];
    %     x = 200:1:565;
    % end
    [muhat.EndT,sigmahat.EndT,muci.EndT,sigmaci.EndT]= normfit(GCC.EndT);
    n = numel(GCC.EndT);
    [bincounts,binedges] = histcounts(GCC.EndT,50);
    bincenters = binedges(1:end-1)+diff(binedges)/2;
    hh = bar(bincenters,bincounts,1,'FaceColor',color_mtx_light(count,:),...
        'EdgeColor',color_mtx_light(count,:),'FaceAlpha',.3);
    hold on
    binwidth = binedges(2)-binedges(1); % Finds the width of each bin
    areabin = n * binwidth;
    %         pd = fitdist(EndT,'Gamma');  mu = pd.a*pd.b;    sigma = sqrt(pd.a*pd.b^2);
    pd = fitdist(GCC.EndT,'tLocationScale');  mu = pd.mu;    sigma = pd.sigma;
    y = areabin * pdf(pd,x);
    hh1 = plot(x,y,'-','color',color_mtx_dark(count,:),'LineWidth',2);
    axis ([x1 x2 y1 y2]);
    %         xlabel({'end season (DOY)';['\mu DOY:' num2str(round(muhat.EndT)) ' \sigma:' num2str(round(sigmahat.EndT)) 'days']});
    % if ip==3
    %     mu = mu-365;
    % end
    xlabel({'end season (DOY)';...
        ['\mu DOY:' num2str(round(mu)) ' \sigma:' num2str(round(sigma)) 'days']});
    set(gca,'XTick',x4,'XTickLabel',x3,'YTick',y3,'XLim',[x1 x2],'YLim',[y1 y2],'FontSize',12);
    xtickangle(0);     grid on;

    x = 1:1:365;
    x1=0;     x2=365;     x3 = (x1:50:x2)';
    subplot(2,2,3);
    [muhat.LengthVal,sigmahat.LengthVal,muci.LengthVal,sigmaci.LengthVal]= normfit(GCC.LengthVal);
    n = numel(GCC.LengthVal);
    [bincounts,binedges] = histcounts(GCC.LengthVal,50);
    bincenters = binedges(1:end-1)+diff(binedges)/2;
    hh = bar(bincenters,bincounts,1,'FaceColor',color_mtx_light(count,:),...
        'EdgeColor',color_mtx_light(count,:),'FaceAlpha',.3);
    hold on
    binwidth = binedges(2)-binedges(1); % Finds the width of each bin
    areabin = n * binwidth;
    %         pd = fitdist(LengthVal,'Gamma');  mu = pd.a*pd.b;    sigma = sqrt(pd.a*pd.b^2);
    pd = fitdist(GCC.LengthVal,'tLocationScale');  mu = pd.mu;    sigma = pd.sigma;
    y = areabin * pdf(pd,x);
    hh1 = plot(x,y,'-','color',color_mtx_dark(count,:),'LineWidth',2);
    axis ([x1 x2 y1 y2]);
    %         xlabel({'length season (no. days)';['\mu:' num2str(round(muhat.LengthVal)) 'days \sigma:' num2str(round(sigmahat.LengthVal)) 'days']});
    xlabel({'length season (no. days)';...
        ['\mu DOY:' num2str(round(mu)) ' \sigma:' num2str(round(sigma)) 'days']});
    ylabel({'% individual crowns';['ROI:' num2str(roiLength) ' years:' num2str(round(length(TP3.daydate)/365))]});
    set(gca,'XTick',x3,'XTickLabel',x3,'YTick',y3,'XLim',[x1 x2],'YLim',[y1 y2],'FontSize',12);
    xtickangle(0);     grid on;

    subplot(2,2,4);
    %         if ip==5
    [muhat.MaxT,sigmahat.MaxT,muci.MaxT,sigmaci.MaxT]= normfit(GCC.MaxT);
    % Do histogram calculations
    n = numel(GCC.MaxT);
    [bincounts,binedges] = histcounts(GCC.MaxT,50);
    bincenters = binedges(1:end-1)+diff(binedges)/2;
    % Plot the histogram with no gap between bars.
    hh = bar(bincenters,bincounts,1,'FaceColor',color_mtx_light(count,:),...
        'EdgeColor',color_mtx_light(count,:),'FaceAlpha',.3);
    hold on
    % Normalize the density to match the total area of the histogram
    binwidth = binedges(2)-binedges(1); % Finds the width of each bin
    areabin = n * binwidth;
    %         pd = fitdist(MaxT,'Gamma');  mu = pd.a*pd.b;    sigma = sqrt(pd.a*pd.b^2);
    pd = fitdist(GCC.MaxT,'tLocationScale');  mu = pd.mu;    sigma = pd.sigma;
    y = areabin * pdf(pd,x);
    % Overlay the density
    hh1 = plot(x,y,'-','color',color_mtx_dark(count,:),'LineWidth',2);
    axis ([x1 x2 y1 y2]);
    %         xlabel({'time of maximum greennes (DOY)';['\mu DOY:' num2str(round(muhat.MaxT)) ' \sigma:' num2str(round(sigmahat.MaxT)) 'days']});
    xlabel({'time of maximum greennes (DOY)';...
        ['\mu DOY:' num2str(round(mu)) ' \sigma:' num2str(round(sigma)) 'days']});
    set(gca,'XTick',x4,'XTickLabel',x3,'YTick',y3,'XLim',[x1 x2],'YLim',[y1 y2],'FontSize',12);
    xtickangle(0);     grid on;

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
