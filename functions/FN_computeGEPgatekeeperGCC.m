function [modelGEP,GCCnorm] = FN_computeGEPgatekeeperGCC(params, DOY, PAR, Tair, GCC, flagNormalize)
% Daily photosynthesis model driven by vegetation capacity (leaf-machinery), light and temperature
% Based ont he relation between phenocam green chromatic vegetation index and
% photosyntesis, the GCC is seen as an envelope that dominates GEP and how
% meteorology interacts with GEP -- GCC is a sigmoid gate --
% Hardwired parameters: half-saturation constant (PARhalf) parameter for a
% Michaelis–Menten equation, as well as parameters that define the temperature optimum
% and the 'amplitude' range over which temperature exerts control on photosynthesis.

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
% GEPmax = params(1)  % Overall scale, maximum photosyntetic activity
% k  = params(2)      % Steepness of the green-up
% x0 = params(3)      % Gatekeeper GCC value when the meteorology start to control GEP

% -------------------------------------------------------------------------
% TAME: Toronto Atmospheric Monitoring of Emissions  UofT-Debra Wunch lab
% Natalia Restrepo Coupe: nataliacoupe@gmail.com
% Toronto, November 12, 2025

% -------------------------------------------------------------------------
% unpack parameters
GEPmax = params(1);
k      = params(2);
x0     = params(3);

% hard-wired -- pre defined
% half-saturation constant (PARhalf) and temperature optimum and "amplitude"
% range where temperature does excert control over photosyntesis
PARhalf = 273;   Topt = 25;  Tamplitude = 18;

%% initialize vectors
n = length(DOY);                   GCCnorm = zeros(n,1);
DOYdate = datetime(1,1,DOY);       GCCyear = unique(year(DOYdate));

%% normalize GCC every year OR normalize the full time series
% normalize GCC every year
if flagNormalize==1
    for ix = 1:length(GCCyear)
        currentYear = GCCyear(ix);
        yearInd = (year(DOYdate) == currentYear);

        if any(yearInd)
            % use the whole year to find the bounds
            annualMin = prctile(GCC(yearInd), 5);
            annualMax = prctile(GCC(yearInd), 95);
            denomGCC = annualMax - annualMin;

            if denomGCC > 1e-6
                GCCnorm(yearInd) = (GCC(yearInd) - annualMin) ./ denomGCC;
            else
                GCCnorm(yearInd) = 0;
            end
        end
    end
elseif flagNormalize==0
    annualMin = prctile(GCC, 5);
    annualMax = prctile(GCC, 95);

    denomGCC = annualMax - annualMin;
    GCCnorm = (GCC-annualMin)./ denomGCC;
end

GCCnorm = max(0, min(GCCnorm, 1));
GCCnorm(isnan(GCC)) = NaN;
% GCCnorm = max(0, GCCnorm);

%% meteorological drivers (potential GEP)
% compute the temperature response (fTemp)
% Wang & Engel functionq = (Tmax - Topt) / (Topt - Tmin);
% Tmin = -10;                  Tmax = Topt+Tamplitude;
% fTemp = zeros(size(Tair));
% q = (Tmax - Topt) / (Topt - Tmin);
% mask = ((Tair > Tmin) & (Tair < Tmax));
% if any(mask)
%     Tair_safe = Tair(mask);
%     fTemp(mask) = ((Tair_safe - Tmin) .* (Tmax - Tair_safe).^q) ./ ...
%         ((Topt - Tmin) * (Tmax - Topt)^q);
% end
fTemp  = exp(-((Tair - Topt).^2) / (2 * Tamplitude^2));
fTemp(fTemp < 0 | isnan(fTemp)| isinf(fTemp)) = 0;

% fTemp  = exp(-((Tair - Topt).^2) / (2 * Tamplitude^2));  % symmetric
% fixed parametrization
fLight = PAR ./ (PAR + PARhalf);

PotentialGEP = GEPmax .* fLight .* fTemp;

%% sigmoid gate (phenology control)
% GCCnorm should be 0 to 1 based on your normalization logic
fGate = 1 ./ (1 + exp(-k .* (GCCnorm - x0)));

%% GEP model
modelGEP = PotentialGEP .* fGate;

% Ensure the final output GEP is non-negative
modelGEP((modelGEP <= 0)|(~isfinite(modelGEP))) = NaN;
modelGEP(isnan(GCC)) = NaN;

end
