% Quickly calculate percentiles

function p = FN_percentile_calc(data, prc, dim)
sorted_data = sort(data, dim);
n = size(data, dim);
idx = max(1, round((prc/100) * n));
if dim == 2
    p = sorted_data(:, idx);
else
    p = sorted_data(idx, :);
end
end