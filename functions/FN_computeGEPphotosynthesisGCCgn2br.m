function [modelGEP, GCCnorm] = FN_computeGEPphotosynthesisGCCgn2br(params, DOY, ...
    PAR, Tair, GCC, flagNormalize)
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
% here instead of unpackin the parameters I call them directly througouth
% the code
% Topt = params(7);          Tmax = params(8);       Tmin = -5;

%% initialize vectors
n = length(DOY);              modelGEP = zeros(n,1);
fGate = zeros(n,1);           GCCnorm = zeros(n,1);

DOYdate = datetime(1,1,DOY);  GCCyear = unique(year(DOYdate));

%% normalize GCC every year OR normalize the full time series
% process each year individually
if flagNormalize==1
    for ix = 1:length(GCCyear)
        currentYear = GCCyear(ix);
        yearInd = (year(DOYdate) == currentYear);

        if any(yearInd)
            annualMin = prctile(GCC(yearInd), 5);
            annualMax = prctile(GCC(yearInd), 95);
            denomGCC = annualMax - annualMin;

            if denomGCC > 1e-6
                yGCC = (GCC(yearInd) - annualMin) ./ denomGCC;
                GCCnorm(yearInd) = max(0, min(yGCC, 1));
            else
                GCCnorm(yearInd) = 0;
            end

            % find peak GCC for each year - smooth the current year's data to
            % avoid noise to have an effect on the selection
            GCCsmooth = movmean(GCCnorm(yearInd), 15, 'omitnan');
            [~, localPeakInd] = max(GCCsmooth);

            % Convert local index to the global index in the full vector
            globalIndices = find(yearInd);
            peakThresholdInd = globalIndices(localPeakInd);

            % apply the gate logic for this specific year
            for ix = globalIndices'
                if ix <= peakThresholdInd  % spring/green-up
                    k  = params(2);
                    x0 = params(3);
                else                      % fall/brown-down
                    k  = params(4);
                    x0 = params(5);
                end
                fGate(ix) = 1 ./ (1 + exp(-k .* (GCCnorm(ix) - x0)));
            end
        end
    end
end

if flagNormalize==0
    annualMin = prctile(GCC, 5);
    annualMax = prctile(GCC, 95);

    denomGCC = annualMax - annualMin;
    GCCnorm = (GCC-annualMin)./ denomGCC;
    % to separate the ascending and descending points in this function to obtain fGate
    % when the normalization of a multiyear daily GCC time series such that if lots of values
    % are missing for the year the normalization does not make crazy values
    GCCsmooth = movmean(GCCnorm, 30, 'omitnan');
    timeline = 1:length(DOY);
    GCCfilled = fillmissing(GCCsmooth, 'linear', 'SamplePoints', timeline);

    dGCC = diff(GCCfilled) ./ diff(DOY);
    dGCC = [dGCC(1); dGCC];

    for ix = 1:n
        % ascending GCC, positive dGCC if green-up
        % descending GCC, negative dGCC if brown-down
        isGreenup = (dGCC(ix) >= 0);
        if isGreenup
            k  = params(2);
            x0 = params(3);
        else
            k  = params(4);
            x0 = params(5);
        end
        fGate(ix) = 1 ./ (1 + exp(-k .* (GCCnorm(ix) - x0)));
    end
end

%% meteorological drivers (potential GEP)
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
% fTemp  = exp(-((Tair - Topt).^2) / (2 * Tamplitude^2));
fTemp  = exp(-((Tair - params(7)).^2) / (2 * params(8)^2));  % symmetric
% fixed parametrization
fLight = PAR ./ (PAR + params(6));

PotentialGEP = params(1) .* fLight .* fTemp;

%% GEP model
modelGEP = PotentialGEP .* fGate;

% Ensure the final output GEP is non-negative
modelGEP((modelGEP <= 0)) = 0;
modelGEP((isnan(GCC))|(~isfinite(modelGEP))) = NaN;

end