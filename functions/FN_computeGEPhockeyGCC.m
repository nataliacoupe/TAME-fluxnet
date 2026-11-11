function [modelGEP] = FN_computeGEPhockeyGCCalone(params, DOY, GCC,flagNormalize)
% Daily photosynthesis model driven by vegetation capacity (leaf-machinery), light and temperature
% Based ont he relation between phenocam green chromatic vegetation index and
% photosyntesis. GCC controls GEP and little else matters

% -------------------------------------------------------------------------
% inputs
% GEP is gross ecosystem productivity ~ photosynthesis [gC m-2 d-1]
% GCC the green chromatic index from phenocam images [unitless]
% flag_annualNorm == 1 Normalize GCC annual cycle to remove the effect of
% changing the camera of difference between camera models across sites

% -------------------------------------------------------------------------
% parameters
% alpha = params(1)  % slope or scaling factor (maybe we can see it as a photosynthetic capacity?)
% beta  = params(2)  % GCC Threshold (the "Hinge")

% -------------------------------------------------------------------------
% TAME: Toronto Atmospheric Monitoring of Emissions  UofT-Debra Wunch lab
% Natalia Restrepo Coupe: nataliacoupe@gmail.com
% Toronto, November 12, 2025

% -------------------------------------------------------------------------
% unpack parameters
alpha = params(1);
beta  = params(2);


%% initialize vectors
n = length(DOY);                   GCCnorm = zeros(n,1);
DOYdate = datetime(1,1,DOY);       GCCyear = unique(year(DOYdate));
dormantMatrix = zeros(n,1);

%% normalize GCC every year OR normalize the full time series
if flagNormalize==1
    for ix = 1:length(GCCyear)
        currentYear = GCCyear(ix);
        yearInd = (year(DOYdate) == currentYear);
        if any(yearInd)
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

%% GEP model
% where GEP based strictly on vegetation capacity
modelGEP = alpha * max(0, GCCnorm - beta);

% Ensure the final output GEP is non-negative
modelGEP((modelGEP <= 0)|(~isfinite(modelGEP))) = 0;
modelGEP(isnan(GCC)) = NaN;

end