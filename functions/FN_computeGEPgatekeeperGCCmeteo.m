function [modelGEP,GCCnorm] = FN_computeGEPgatekeeperGCCmeteo(params, DOY, PAR, Tair, GCC, flagNormalize)
% Daily photosynthesis model driven by vegetation capacity (leaf-machinery), light and temperature
% Based ont he relation between phenocam green chromatic vegetation index and
% photosyntesis, the GCC is seen as an envelope that dominates GEP and how
% meteorology interacts with GEP -- GCC is a sigmoid gate --
% The code allows you to find a half-saturation constant (PARhalf) parameter
% for a Michaelis-Menten equation that models the interaction of PAR and GEP
% and the temperature optimum and "amplitude" range where temperature does
% excert control over photosyntesis. The code will look for the peak greeness
% and get two sinusoidal curves, noe for greenup other for the browndown periods

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
% GEPmax = params(1)   % overall scale, maximum photosyntetic activity
% k  = params(2)       % steepness of the green-up
% x0 = params(3)       % gatekeeper GCC value when the meteorology start to control GEP
% k  = params(4)       % brown-down
% x0 = params(5)       % brown-down meteorology start to control GEP
% PARhalf = params(6)  % PAR half-saturation constant
% Topt = params(7);    % Tair optimum
% Tamplitude = params(8); % range for which temperature controls GEP (Topt
% as middle point)

% -------------------------------------------------------------------------
% TAME: Toronto Atmospheric Monitoring of Emissions  UofT-Debra Wunch lab
% Natalia Restrepo Coupe: nataliacoupe@gmail.com
% Toronto, November 12, 2025

% -------------------------------------------------------------------------
% unpack parameters
GEPmax  = params(1);
k       = params(2);
x0      = params(3);
PARhalf = params(4);
Topt    = params(5);
% Tmax    = params(6);
% Tmin    = -5;
Tamplitude = params(6);

%% initialize vectors
n = length(DOY);                   GCCnorm = zeros(n,1);
DOYdate = datetime(1,1,DOY);       GCCyear = unique(year(DOYdate));

%% normalize GCC every year OR normalize the full time series
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
fLight = PAR ./ (PAR + PARhalf);
fTemp  = exp(-((Tair - Topt).^2) / (2 * Tamplitude^2));
% compute the temperature response (fTemp)
% Wang & Engel functionq = (Tmax - Topt) / (Topt - Tmin);
% fTemp = zeros(size(Tair));
% q = (Tmax - Topt) / (Topt - Tmin);
% mask = ((Tair > Tmin) & (Tair < Tmax));
% if any(mask)
%     Tair_safe = Tair(mask);
%     fTemp(mask) = ((Tair_safe - Tmin) .* (Tmax - Tair_safe).^q) ./ ...
%         ((Topt - Tmin) * (Tmax - Topt)^q);
% end
% fTemp((fTemp < 0) | (isnan(fTemp)) | (isinf(fTemp))) = 0;

PotentialGEP = GEPmax .* fLight .* fTemp;

%% sigmoid gate (phenology control)
% GCCnorm should be 0 to 1 based on your normalization logic
fGate = 1 ./ (1 + exp(-k .* (GCCnorm - x0)));

%% GEP model
modelGEP = PotentialGEP .* fGate;

% Ensure the final output GEP is non-negative
modelGEP((modelGEP <= 0)) = 0;
modelGEP((isnan(GCC))|(~isfinite(modelGEP))) = NaN;

end
