function [ spike ] = dpa_des_spike( sample_mean )
%DES_SPIKE(MEAN) Detects a spike in sample_mean, the higher the returned value is, the
% more important the spike is.


% The filter
n = 20; 
f = ones(1, n) / n;

spower = size(sample_mean, 2);

% We filter the samples mean

f_mean = conv(f, sample_mean);
f_mean = f_mean(1, 1 : spower);

% Some statistics
s_std = std(f_mean);

nstd = 10;

tmp = abs(f_mean);

spike = 0;
if any(tmp > nstd * s_std)
    spike = max(tmp);
end
