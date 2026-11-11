function [VIfill] = FN_fillVI(DOYdate,VI)

% Timesat needs 3-years+ to calculte the phenological timing and other
% metrics. It is a good idea to pad observations with one year before and
% one year after so you get start and end of the growing season at the two 
% first and last years.

% -------------------------------------------------------------------------
% TAME: Toronto Atmospheric Monitoring of Emissions  UofT-Debra Wunch lab
% Natalia Restrepo Coupe: nataliacoupe@gmail.com
% Toronto, November 12, 2025


% Assuming your data is in a timetable or has a 'DOYdate' vector
uniqueYears = unique(year(DOYdate));
VIfill = VI; % Initialize cleaned vector
VIfillAll = AM_fill_day_cycle(VI,DOYdate,6,18);

for i = 1:length(uniqueYears)
    yr = uniqueYears(i);
    yrIdx = (year(DOYdate) == yr);
    
    % Calculate data density for this year
    nonNaNCount = sum(~isnan(VI(yrIdx)));
    totalDaysInYear = sum(yrIdx);
    density = nonNaNCount / totalDaysInYear;
    
    if density < 0.50
        % Remove year if < 50% data
        VIfill(yrIdx) = NaN;
    else
        % Fill gaps only for years with > 50% data
        % Using 'akima' or 'pchip' preserves the seasonal peaks seen in your plot
        % VIfill(yrIdx) = fillmissing(VIfill(yrIdx), 'makima');
        VIfill(isnan(VIfill)&yrIdx) = VIfillAll(isnan(VIfill)&yrIdx);
    end
end