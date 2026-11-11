function [modelGEP] = FN_computeGEPleafage(params, DOY, PAR, Tair, ...
    GreenupStart, BrowndownEnd)
% Daily photosynthesis model driven by vegetation capacity (leaf-machinery), light and temperature
% The vegetation capacity is calculated as a function of the leaf age
% Leaf age defined by the start and end of the growing season.

% -------------------------------------------------------------------------
% inputs
% GEP is daily daytime gross ecosystem productivity ~ photosynthesis [gC m-2 d-1]
% PAR is daily daytime photosynthetic active radiation [umol m-2 s-1]
% Tair is daily maximum air temperature [degC]
% StartGrowing: start of growing season [days as counter DOY]
% EndGrowing: end of growing season [days as counter DOY]

% -------------------------------------------------------------------------
% parameters
% Topt   = params(1)   % Optimal temperature
% Tmin   = params(2)   % Minimum temperature
% Tmax   = params(3)   % Maximum temperature
% peakOffset = params(4)   % Days after leaf-out when LUEmax peaks
% LUEmax     = params(5)   % Maximum light use efficiency

% -------------------------------------------------------------------------
% TAME: Toronto Atmospheric Monitoring of Emissions  UofT-Debra Wunch lab
% Natalia Restrepo Coupe: nataliacoupe@gmail.com
% Toronto, November 12, 2025

% -------------------------------------------------------------------------
% unpack parameters
Topt       = params(1);   % Optimal temperature
Tmin       = params(2);   % Minimum temperature
Tmax       = params(3);   % Maximum temperature
peakOffset = params(4);   % Days after leaf-out when LUEmax peaks
LUEmax     = params(5);   % Maximum light use efficiency

%% initialize vectors
modelGEP = zeros(size(DOY));

%% compute the temperature response (fT)
% Wang & Engel functionq = (Tmax - Topt) / (Topt - Tmin);
% Lets ensure the peak is exactly at Topt and the max value is 1.0
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

%% determine final photosynthetic capacity as function of leaf age (time after leaf-out dates)
for ij = 1:length(GreenupStart)
    if BrowndownEnd(ij) <= GreenupStart(ij)
        continue
    end

    indGrowing = (DOY >= GreenupStart(ij)) & (DOY <= BrowndownEnd(ij));
    DOYgrowing = DOY(indGrowing);

    if isempty(DOYgrowing)
        continue
    end

    % define peak of LUEmax -- it can be after the vegetation index peak
    t_peak = GreenupStart(ij) + peakOffset;

    % Width of parabola (half-width from peak to either end)
    w = max([t_peak - GreenupStart(ij), BrowndownEnd(ij) - t_peak]);

    % parabolic LUE response (clipped at 0)
    f_leaf = 1 - ((DOYgrowing - t_peak) / w).^2;
    f_leaf(f_leaf <= 0) = 0;
    % figure('color','white');plot(f_leaf,'LineWidth',2); xlabel('leaf age (days)'); ylabel('capacity (fraction)')
    % set(gca, 'FontSize', 12);  grid on;

    %% GEP model
    modelGEP(indGrowing) = LUEmax .* f_leaf .* PAR(indGrowing) .* fT(indGrowing);
end

% Ensure the final output GEP is non-negative
modelGEP((modelGEP <= 0)|(~isfinite(modelGEP))) = 0;
modelGEP(isnan(f_leaf)) = NaN;

end
