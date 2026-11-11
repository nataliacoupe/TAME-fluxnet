function [modelGEP] = FN_computeGEPseasons(params, DOY, GCC, PAR, Tair, ...
    StartGrowing, PeakGrowing, EndGrowing, flag_annualNorm)

% Daily photosynthesis model driven by vegetation capacity (leaf-machinery), light and temperature
% Finds the relations for three diferent phenological periods, greenup-peak
% of the growing season, peak to end of the season and dormancy.

% -------------------------------------------------------------------------
% inputs
% GEP is daily daytime gross ecosystem productivity ~ photosynthesis [gC m-2 d-1]
% PAR is daily daytime photosynthetic active radiation [umol m-2 s-1]
% Tair is daily maximum air temperature [degC]
% GCC the green chromatic index from phenocam images is used as proxy of
% vegetation capacity [unitless]
% StartGrowing: start of growing season [days as counter DOY]
% PeakGrowing: peak of growing season [days as counter DOY]
% EndGrowing: end of growing season [days as counter DOY]
% flag_annualNorm == 1 Normalize GCC annual cycle to remove the effect of
% changing the camera of difference between camera models across sites


% -------------------------------------------------------------------------
% parameters
% Topt   = params(1);   % Optimal temperature degC
% Tmin   = params(2);   % Minimum temperature degC
% Tmax   = params(3);   % Maximum temperature degC
% alpha green = params(4);   % vegetation rate of response greenup-peak
% alpha peak  = params(5);   % vegetation rate of response peak-end growing season
% alpha brown = params(6);   % speed of adaptation end-start growing season

% -------------------------------------------------------------------------
% TAME: Toronto Atmospheric Monitoring of Emissions  UofT-Debra Wunch lab
% Natalia Restrepo Coupe: nataliacoupe@gmail.com
% Toronto, November 12, 2025

% -------------------------------------------------------------------------
% unpack parameters
Topt = params(1);
Tmin = params(2);
Tmax = params(3);
alpha_green = params(4);
alpha_peak  = params(5);
alpha_brown = params(6);

%% initialize vectors
DOYdate = datetime(0,1,DOY);
SGSdate = datetime(0,1,StartGrowing);  EGSdate = datetime(0,1,EndGrowing);

DOYyear = unique(year(DOYdate));       GCCyear = unique(year(SGSdate));
GCCnorm = zeros(length(GCC),1);        dormantMatrix = zeros(length(GCC),1);

% % Before normalizing, ensure there is a range
% rangeGCC = annualMax - annualMin;
% if rangeGCC > 0
%     GCCnorm(ind) = (GCC(ind) - annualMin) / rangeGCC;
% else
%     GCCnorm(ind) = 0; % or some baseline
% end

%% normalize GCC every year OR normalize the full time series
% Normalize every year GCC
if flag_annualNorm==1
    for ix = 1:length(GCCyear)
        currentYear = GCCyear(ix);
        ind = (year(DOYdate) == currentYear);
        % Define the dormant period for THIS year
        % dormantIndex = ind & ((DOYdate < (SGSdate(ix)-days(30))) | (DOYdate > (EGSdate(ix)+days(30))));
        dormantIndex = ind & ((DOYdate < SGSdate(ix)) | (DOYdate > EGSdate(ix)));
        % Calculate annual baseline (5th percentile) and peak (95th percentile)
        annualMin = prctile(GCC(dormantIndex), 10);
        annualMax = prctile(GCC(ind), 95);
        % Normalize only that year's data
        denomGCC = annualMax - annualMin;
        if denomGCC > 1e-6
            GCCnorm(ind) = (GCC(ind) - annualMin)./ denomGCC;
        else
            GCCnorm(ind) = 0;
        end
    end
    % Normalize whole GCC time series - treats all years the same
elseif flag_annualNorm==0
    for ix = 1:length(GCCyear)
        currentYear = GCCyear(ix);
        yearInd = (year(DOYdate) == currentYear);
        % isDormant = (DOYdate < (SGSdate(ix) - days(30))) | (DOYdate > (EGSdate(ix) + days(30)));
        isDormant = (DOYdate < SGSdate(ix)) | (DOYdate > EGSdate(ix) );
        % Combine: Only mark as dormant if it's the correct year AND the correct period
        dormantMatrix(yearInd & isDormant,1) = true;
    end
    annualMin = prctile(GCC(dormantMatrix==1), 5);
    annualMax = prctile(GCC(dormantMatrix==0), 95);

    denomGCC = annualMax - annualMin;
    GCCnorm = (GCC-annualMin)./ denomGCC;
end

% GCCnorm = max(0, min(GCCnorm, 1));
GCCnorm(isnan(GCC)) = NaN;      GCCnorm(GCCnorm<0) = 0.0001;

%% temperature response (fT)
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

%% alpha as speed of the vegetation response to the meteorological conditions
% using a vector to assign the specific alpha to every time step
alpha_vec = zeros(size(DOY));
% green = alpha_vec; peak = alpha_vec; brown = alpha_vec;

% Loop over phenological periods
num_cycles = length(StartGrowing);
for ij = 1:num_cycles
    % Determine the boundary for the end of this cycle's brown-down
    if ij < num_cycles
        cycle_end = StartGrowing(ij+1); % Next season's start
    else
        cycle_end = max(DOY);  % End of dataset
    end

    % green-up: start growing to peak growing season
    idx_green = ((DOY >= StartGrowing(ij)) & (DOY < PeakGrowing(ij)));
    % green(idx_green) = alpha_green;   % checking
    alpha_vec(idx_green) = alpha_green;

    % peak: peak growing to end growing season
    idx_peak = ((DOY >= PeakGrowing(ij)) & (DOY < EndGrowing(ij)));
    % peak(idx_peak) = alpha_peak;
    alpha_vec(idx_peak) = alpha_peak;

    % brown-down: end growing to next start growing season
    idx_brown = ((DOY >= EndGrowing(ij)) & (DOY < cycle_end));
    % brown(idx_brown) = alpha_brown;
    alpha_vec(idx_brown) = alpha_brown;
end

%% calculate light use efficiency (LUE)
LUE = (1 - exp(-alpha_vec .* GCCnorm)) ./ ...
    (1 + exp(-alpha_vec .* (GCCnorm - 0.5)));

%% GEP model
modelGEP = LUE .* PAR .* fT;

% Ensure the final output GEP is non-negative
modelGEP((modelGEP <= 0)|(~isfinite(modelGEP))) = 0;
modelGEP(isnan(GCC)) = NaN;

end