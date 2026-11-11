function [modelGEP,GCCnorm,RCCnorm] = FN_computeGEPchromatic(params, DOY, PAR, Tair, GCC, RCC, ...
    StartGrowingIni, EndGrowingIni, flag_annualNorm)
% Daily photosynthesis model driven by vegetation capacity (leaf-machinery), light and temperature
% To infere the vegetation capacity we use phenocam vegetation indices,
% red (RCC) and green (GCC) chromatic indices:
%    - Growing Season (StartGrowing to EndGrowing): 1 - RCC proxy (absorption).
%    - Dormant Season (Dormancy): GCC proxy (background greenness).

% -------------------------------------------------------------------------
% inputs
% GEP is daily daytime gross ecosystem productivity ~ photosynthesis [gC m-2 d-1]
% PAR is daily daytime photosynthetic active radiation [umol m-2 s-1]
% Tair is daily maximum air temperature [degC]
% GCC the green chromatic index from phenocam images  [unitless]
% RCC phenocam-derived red chromatic index used as proxy of vegetation capacity
% StartGrowing: start of growing season [days as counter DOY]
% PeakGrowing: peak of growing season [days as counter DOY]
% EndGrowing: end of growing season [days as counter DOY]
% flag_annualNorm == 1 Normalize GCC annual cycle to remove the effect of
% changing the camera of difference between camera models across sites

% -------------------------------------------------------------------------
% parameters
% Topt   = params(1);   % Optimal temperature
% Tmin   = params(2);   % Minimum temperature
% Tmax   = params(3);   % Maximum temperature
% alpha_gcc = params(4);  % Light use efficiency GCC
% alpha_rcc = params(5);  % Light use efficiency RCC

% -------------------------------------------------------------------------
% TAME: Toronto Atmospheric Monitoring of Emissions  UofT-Debra Wunch lab
% Natalia Restrepo Coupe: nataliacoupe@gmail.com
% Toronto, November 12, 2025

% -------------------------------------------------------------------------
% unpack parameters
Topt        = params(1);   % Optimal temperature (°C)
Tmin        = params(2);   % Minimum temperature (°C)
Tmax        = params(3);   % Maximum temperature (°C)
alphaGCCdormant = params(4);  % Vegetation rate of response fn of GCC dormant season
alphaRCCgrowing = params(5);  % Vegetation rate of response fn of RCC growing season

%% initialize vectors
DOYdate = datetime(1,1,DOY);               DOYyear = unique(year(DOYdate));
SGSdate = datetime(1,1,StartGrowingIni);   EGSdate = datetime(1,1,EndGrowingIni);

n = length(DOY);            GCCyear = unique(year(SGSdate));
GCCnorm = zeros(n,1);       RCCnorm = zeros(n,1);
isDormant = false(n, 1);  % Consistent mask: true = Dormant, false = Growing

%% normalize GCC every year OR normalize the full time series
% normalize GCC every year
if flag_annualNorm==1
    for ix = 1:length(GCCyear)
        currentYear = GCCyear(ix);
        indYear = (year(DOYdate) == currentYear);
        indPheno = find(year(SGSdate) == currentYear);

        if (~isempty(indPheno))&(~isempty(indYear))
            SGS = SGSdate(indPheno);
            EGS = EGSdate(indPheno);

            yrDormant = indYear & ((DOYdate <= SGS) | (DOYdate >= EGS));
            yrGrowing = indYear & ((DOYdate > SGS) & (DOYdate < EGS));
            isDormant(yrDormant) = true;

            % Combine: Only mark as dormant if it's the correct year AND the correct period
            if any(yrDormant) && any(yrGrowing)
                % Calculate annual baseline (5th percentile) and peak (95th percentile)
                annualMin = prctile(GCC(yrDormant), 5);
                if isnan(annualMin)
                    x=1;
                end
                annualMax = prctile(GCC(yrGrowing), 95);
                % Normalize only that year's data
                denomGCC = annualMax - annualMin;
                if denomGCC > 1e-6
                    GCCnorm(indYear) = (GCC(indYear) - annualMin)./ denomGCC;
                else
                    GCCnorm(indYear) = 0;
                end

                % now normalize RCC
                annualMin = prctile(RCC(yrGrowing), 5);
                annualMax = prctile(RCC(yrDormant), 95);
                denomRCC = annualMax - annualMin;
                if denomRCC > 1e-6
                    RCCnorm(indYear) = (RCC(indYear) - annualMin)./ denomRCC;
                else
                    RCCnorm(indYear) = 0;
                end
                % RCCnorm(yrDormant) = 1;
                RCCnorm(RCCnorm>1) = 1;
            end
        end
    end
    % Normalize whole GCC time series
    % if flag_annualNorm==0
elseif flag_annualNorm==0
    for ix = 1:length(GCCyear)
        currentYear = GCCyear(ix);
        indYear = (year(DOYdate) == currentYear);
        yrDormant = indYear & (DOYdate <= SGSdate(ix) | DOYdate >= EGSdate(ix));
        yrGrowing = indYear & (DOYdate > SGSdate(ix) & DOYdate < EGSdate(ix));
        isDormant(yrDormant) = true;
    end
    annualMin = prctile(GCC(isDormant), 5);   annualMax = prctile(GCC(~isDormant), 95);
    denomGCC = annualMax - annualMin;
    if denomGCC > 1e-6
        GCCnorm = (GCC - annualMin)./ denomGCC;
    else
        GCCnorm = 0;
    end

    annualMin = prctile(RCC(~isDormant), 5);  annualMax = prctile(RCC(isDormant), 95);
    denomRCC = annualMax - annualMin;
    if denomRCC > 1e-6
        RCCnorm = (RCC - annualMin)./ denomRCC;
    else
        RCCnorm = 0;
    end
    % RCCnorm(dormantMatrix==1) = NaN;

    if (sum(isDormant)<2)|(sum(~isDormant)<2)
        annualMin = prctile(GCC, 5);   annualMax = prctile(GCC, 95);
        denomGCC = annualMax - annualMin;
        GCCnorm = (GCC - annualMin)./ denomGCC;

        annualMin = prctile(RCC, 5);   annualMax = prctile(RCC, 95);
        denomRCC = annualMax - annualMin;
        RCCnorm = (RCC - annualMin)./ denomRCC;
    end

    % GCCnorm = max(0, min(GCCnorm, 1));
    GCCnorm(isnan(GCC)) = NaN;
    GCCnorm(GCCnorm<0) = 0;           GCCnorm(GCCnorm>1) = 1;
    % GCCnorm = max(0, min(GCCnorm, 1));
end

%% alpha proxy for growing season: 1 - RCC (absorption/fAPAR proxy)
RCCnorm(isnan(RCC)) = NaN;
RCC_raw_inv = 1 - RCCnorm;
ix = fillmissing(RCC_raw_inv, 'movmean', 3);
RCC_raw_inv(isnan(RCC_raw_inv)) = ix(isnan(RCC_raw_inv));
ix = fillmissing(RCC_raw_inv, 'movmean', 11);
RCC_raw_inv(isnan(RCC_raw_inv)) = ix(isnan(RCC_raw_inv));

RCCnorm = RCC_raw_inv;
RCCnorm(RCCnorm<0) = 0;           RCCnorm(RCCnorm>1) = 1;

% % % Logical mask for the growing season
% % is_growing = false(size(DOY));
% % for ij = 1:length(StartGrowing)
% %     is_growing(DOY >= StartGrowing(ij) & DOY <= EndGrowing(ij)) = true;
% % end
% % % Prevent the winter noise from affecting the min/max calculation
% % RCC_growing_only = RCC_raw_inv;
% % RCC_growing_only(~is_growing) = NaN; % remove winter
% % [~,RCC_growing_only] = AM_spike_detection(RCC_growing_only,5);
% %
% % RCCmin_clean = min(RCC_growing_only, [], 'omitnan');
% % RCCmax_clean = max(RCC_growing_only, [], 'omitnan');
% % RCCnorm = (RCC_growing_only - RCCmin_clean) / (RCCmax_clean - RCCmin_clean);
% % % RCCnorm = max(0, min(RCCnorm, 1));

%% compute the temperature response (fT)
% Wang & Engel functionq = (Tmax - Topt) / (Topt - Tmin);
fT = zeros(size(Tair));
q = (Tmax - Topt) / (Topt - Tmin);
mask = ((Tair > Tmin) & (Tair < Tmax));
if any(mask)
    Tair_safe = Tair(mask);
    fT(mask) = ((Tair_safe - Tmin) .* (Tmax - Tair_safe).^q) ./ ...
        ((Topt - Tmin) * (Tmax - Topt)^q);
end
% fT = ((Tair - Tmin) .* (Tmax - Tair)) ./ ((Topt - Tmin) * (Tmax - Topt));
fT(fT < 0 | isnan(fT)| isinf(fT)) = 0;

%% determine final photosynthetic capacity (f_capacity)
LUE = alphaGCCdormant.*GCCnorm;
LUE(~isDormant) = alphaRCCgrowing .* RCCnorm(~isDormant);

%% Check the three main drivers and parameters
% diagnostic checks because RCC can be noisy at times
if any(isnan(params)) || any(isinf(params))
    warning('achtung!: input parameters contains NaN and inf: %s', mat2str(params));
end

checkVars = {'fT', 'GCCnorm', 'RCCnorm', 'LUE', 'PAR'};
for i = 1:length(checkVars)
    varName = checkVars{i};
    varVal = eval(varName);

    if issparse(varVal)
        fprintf('!! [achtung SPARSE] %s is sparse. Shape: %s\n', varName, mat2str(size(varVal)));
    end

    if all(varVal==0)
        fprintf('?? [achtung ZERO] %s is entirely zeros. Check your bounds/logic.\n', varName);
    end

    if any(isnan(varVal))
        fprintf('** [achtung NaN] %s contains %d NaNs.\n', varName, sum(isnan(varVal(:))));
    end
end
%% GEP model
modelGEP = LUE .* PAR .* fT;

% Ensure the final output GEP is non-negative
modelGEP(modelGEP <= 0) = 0;
modelGEP((isnan(GCC))|(isnan(RCC))|(~isfinite(modelGEP))) = NaN;
