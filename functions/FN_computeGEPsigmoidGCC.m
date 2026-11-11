function [modelGEP] = FN_computeGEPsigmoidGCC(params, DOY, GCC, PAR, Tair, flag_annualNorm)
% Daily photosynthesis model driven by vegetation capacity (leaf-machinery), light and temperature
% To infer the vegetation capacity we use a phenocam vegetation index and
% its relation to photosynthesis is a beautifully simple sigmoid curve

% -------------------------------------------------------------------------
% inputs
% GEP is daily daytime gross ecosystem productivity ~ photosynthesis [gC m-2 d-1]
% PAR is daily daytime photosynthetic active radiation [umol m-2 s-1]
% Tair is daily maximum air temperature [degC]
% GCC the green chromatic index from phenocam images [unitless]
% flag_annualNorm == 1 Normalize GCC annual cycle to remove the effect of
% changing the camera of difference between camera models across sites

% -------------------------------------------------------------------------
% parameters
% Topt   = params(1);   % Optimal temperature
% Tmin   = params(2);   % Minimum temperature
% Tmax   = params(3);   % Maximum temperature
% alpha = params(4);    % Light use efficiency GCC

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
DOYyear = unique(year(DOYdate));       GCCnorm = zeros(length(GCC),1);

%% normalize GCC every year OR normalize the full time series
% normalize GCC every year
if flag_annualNorm==1
    for ix = 1:length(DOYyear)
        currentYear = DOYyear(ix);
        ind = (year(DOYdate) == currentYear);
        % Calculate annual baseline (5th percentile) and peak (95th percentile)
        annualMin = prctile(GCC(ind), 10);
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
    annualMin = prctile(GCC, 5);
    annualMax = prctile(GCC, 95);
    GCCnorm = (GCC - annualMin) / (annualMax - annualMin);
end

% GCCnorm = max(0, min(GCCnorm, 1));
GCCnorm(isnan(GCC)) = NaN;      GCCnorm(GCCnorm<0) = 0;

%% saturation functions from the phenocam GCC
num = 1 - exp(-alpha .* GCCnorm);
den = 1 + exp(-alpha .* GCCnorm - 0.5);
LUE = num ./ den;

%% compute the temperature response (fT)
% Wang & Engel function q = (Tmax - Topt) / (Topt - Tmin);
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

end
