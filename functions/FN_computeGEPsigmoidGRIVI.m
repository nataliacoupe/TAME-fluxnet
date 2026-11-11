function [modelGEP,GRIVInorm] = FN_computeGEPsigmoidGRIVI(params, DOY, GRIVI, PAR, Tair, flag_annualNorm)
% Daily photosynthesis model driven by vegetation capacity (leaf-machinery), light and temperature
% To infer the vegetation capacity we use a phenocam vegetation index and
% its relation to photosynthesis is a beautifully simple sigmoid curve

% -------------------------------------------------------------------------
% inputs
% GEP is daily daytime gross ecosystem productivity ~ photosynthesis [gC m-2 d-1]
% PAR is daily daytime photosynthetic active radiation [umol m-2 s-1]
% Tair is daily maximum air temperature [degC]
% GRIVI the green/red vegetation index from phenocam images [unitless]
% flag_annualNorm == 1 Normalize GRIVI annual cycle to remove the effect of
% changing the camera of difference between camera models across sites
% NOTE: we assume start of the growing season after February

% -------------------------------------------------------------------------
% parameters
% Topt  = params(1);   % Optimal temperature
% Tmin  = params(2);   % Minimum temperature
% Tmax  = params(3);   % Maximum temperature
% alpha = params(4);   % Light use efficiency GRIVI

% -------------------------------------------------------------------------
% TAME: Toronto Atmospheric Monitoring of Emissions  UofT-Debra Wunch lab
% Natalia Restrepo Coupe: nataliacoupe@gmail.com
% Toronto, November 12, 2025

% -------------------------------------------------------------------------
% unpack parameters
Topt  = params(1);   % Optimal temperature
Tmin  = params(2);   % Minimum temperature
Tmax  = params(3);   % Maximum temperature
alpha = params(4);   % Saturation parameter * fPAR

%% initialize vectors
DOYdate = datetime(0,1,DOY);           [DOYdateY,DOYdateM,DOYdateD] = datevec(DOYdate);
DOYdateJD = day(DOYdate,'dayofyear');
DOYyear = unique(year(DOYdate));       GRIVInorm = zeros(length(GRIVI),1);

%% set the dormant season to nan
windowSize = 21;
smoothedGRIVI = sgolayfilt(GRIVI, 3, windowSize);
% smoothedGRIVI = smoothdata(GRIVI, windowSize);

years = unique(DOYyear);            years(end) = [];
numYears = length(years);           Year = zeros(numYears, 1);
BegTdate = datetime(zeros(numYears,1), 0, 0); Val_Winter_Min = nan(numYears, 1);
MaxTdate = datetime(zeros(numYears,1), 0, 0); Val_Peak = nan(numYears, 1);
EndTdate = datetime(zeros(numYears,1), 0, 0); Val_Absolute_Min = nan(numYears, 1);

for ix = 1:numYears
    currYear = years(ix);
    yearMask = (year(DOYdate) == currYear);
    idx = find(yearMask);

    idx(DOYdateJD(idx) < (31+28)) = [];

    if (isempty(idx))|(length(idx)<100), continue; end
    Year(ix) = currYear;

    [vP, rP] = max(smoothedGRIVI(idx));
    peakAbsIdx   = idx(rP);
    MaxTdate(ix) = DOYdate(peakAbsIdx);
    Val_Peak(ix) = vP;

    searchStartW = max(idx(1), peakAbsIdx - 100);
    [vW, rW] = min(smoothedGRIVI(searchStartW:peakAbsIdx));
    BegTdate(ix) = DOYdate(searchStartW + rW - 1);
    Val_Winter_Min(ix) = vW;

    searchEndIdx = idx(end);
    [vA, rA] = min(smoothedGRIVI(peakAbsIdx:searchEndIdx));
    EndTdate(ix) = DOYdate(peakAbsIdx + rA - 1);
    Val_Absolute_Min(ix) = vA;
end
ind = find(day(EndTdate,'dayofyear')<150);
iy = mean(day(EndTdate(day(EndTdate,'dayofyear')>150),'dayofyear'),'omitnan');
EndTdate(ind) = datetime(year(EndTdate(ind)),1,round(iy));
for ik = 1:length(ind)
    iy = smoothedGRIVI(DOYdate==EndTdate(ind(ik)));
    iy(isnan(iy)) = mean(Val_Absolute_Min,'omitnan');
    Val_Absolute_Min(ind(ik)) = iy;
end

% ........................................................................
%% dormant season is nan and gep zero -easy peasy
isDormant = true(size(GRIVI));
for ix = 1:numYears
    % Define the growing season window for the current year
    % From the start of green-up (BegTdate) to the end of senescence (EndTdate)
    growingSeasonMask = (DOYdate >= BegTdate(ix) & DOYdate <= EndTdate(ix));

    % Mark these periods as NOT dormant
    isDormant(growingSeasonMask) = false;
end

% Set GRIVI to NaN during the dormant season
GRIVImodified = GRIVI;
GRIVImodified(isDormant) = NaN;

% Remove comment if you want to check - figures
% % HA1seasonalityGRIVI = table(Year, BegTdate, Val_Winter_Min, ...
% %     MaxTdate, Val_Peak, ...
% %     EndTdate, Val_Absolute_Min);
% % HA1seasonalityGRIVI(HA1seasonalityGRIVI.Year <= 0 | isnan(HA1seasonalityGRIVI.Year), :) = [];
% % disp(HA1seasonalityGRIVI);
% % writetable(HA1seasonalityGRIVI, 'timesat/HA1seasonalityGRIVI.txt', 'WriteVariableNames', true, 'Delimiter', '\t');
% %
% % figure('color','white');   plot(DOYdate, GRIVImodified, 'Color', [0.8 0.8 0.8]); hold on;
% % plot(DOYdate, smoothedGRIVI, 'b', 'LineWidth', 1.5);
% % plot(DOYdate, GRIVImodified,'.', 'Color', [0.0 0.0 0.6], 'LineWidth', 1.5);
% % plot(HA1seasonalityGRIVI.BegTdate, HA1seasonalityGRIVI.Val_Winter_Min, 'ms', 'MarkerFaceColor', 'm');
% % plot(HA1seasonalityGRIVI.MaxTdate, HA1seasonalityGRIVI.Val_Peak, 'ro', 'MarkerFaceColor', 'r');
% % plot(HA1seasonalityGRIVI.EndTdate, HA1seasonalityGRIVI.Val_Absolute_Min, 'gd', 'MarkerFaceColor', 'g');
% % title('ROIINa Phenological Milestones: Absolute Minima Correction');
% % grid on;                   ylabel('GRIVI');

%% normalize GRIVImodified every year OR normalize the full time series
% normalize GRIVImodified every year
if flag_annualNorm==1
    for ix = 1:length(DOYyear)
        currentYear = DOYyear(ix);
        ind = (year(DOYdate) == currentYear);
        % Calculate annual baseline (5th percentile) and peak (95th percentile)
        annualMin = prctile(GRIVImodified(ind), 5);
        annualMax = prctile(GRIVImodified(ind), 95);
        % Normalize only that year's data
        denomGRIVI = annualMax - annualMin;
        if denomGRIVI > 1e-6
            GRIVInorm(ind) = (GRIVImodified(ind) - annualMin)./ denomGRIVI;
        else
            GRIVInorm(ind) = 0;
        end
    end
    % Normalize whole GRIVI time series - treats all years the same
elseif flag_annualNorm==0
    annualMin = prctile(GRIVImodified, 5);
    annualMax = prctile(GRIVImodified, 95);
    GRIVInorm = (GRIVI - annualMin) / (annualMax - annualMin);
end

% GRIVInorm = max(0, min(GRIVInorm, 1));
GRIVInorm(isnan(GRIVI)) = NaN;      GRIVInorm(GRIVInorm<0) = 0;
GRIVInorm(isDormant)    = NaN;

% figure('color','white');   plot(DOYdate, GRIVInorm, 'Color', [0.8 0.8 0.8]); hold on;

%% saturation functions from the phenocam GRIVI
num = 1 - exp(-alpha .* GRIVInorm);
den = 1 + exp(-alpha .* GRIVInorm - 0.5);
LUE = num ./ den;

LUE((isnan(GRIVInorm))|isDormant) = 0;

%% compute the temperature response (fT)
% Wang & Engel functionq = (Tmax - Topt) / (Topt - Tmin);
q = (Tmax - Topt) / (Topt - Tmin);
fT = zeros(size(Tair));
mask = ((Tair > Tmin) & (Tair < Tmax));
if any(mask)
    Tair_safe = Tair(mask);
    fT(mask) = ((Tair_safe - Tmin) .* (Tmax - Tair_safe).^q) ./ ...
        ((Topt - Tmin) * (Tmax - Topt)^q);
end
% fT = ((Tair - Tmin) .* (Tmax - Tair)) ./ ((Topt - Tmin) * (Tmax - Topt));
fT(fT < 0 | isnan(fT)| isinf(fT)) = 0;

%% GEP model
modelGEP = LUE .* PAR .* fT;

% Ensure the final output GEP is non-negative
modelGEP((modelGEP <= 0)) = 0;
modelGEP((isnan(LUE))|(~isfinite(modelGEP))) = NaN;

modelGEP(isDormant) = 0.0;
end
