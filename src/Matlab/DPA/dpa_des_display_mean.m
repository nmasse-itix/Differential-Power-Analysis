function [g, b] = dpa_des_display_mean(num_samples, power_model_name, tested_sbox)
%DES_DISPLAY_MEAN COMPUTES A DPA ON ONE KEY CHUNK AND DISPLAY THE RESULTING PLOT)
% figure 1 resulting from a good key chunk, figure 2 resulting from afalse hypothesis
%on the key chunk; 


key = round(rand(1,64));
keys = des_key_schedule(key);
lastkey = keys(16,:);

[pmodel spdetector] = dpa_des_power_model(power_model_name);

% computing a dumb power trace to get its size
spower = size(pmodel(zeros(1,64)), 2);

%tested_sbox = 1;
i = ((tested_sbox - 1) * 6) + 1;

good_key_chunk = lastkey(i:i+5);

bad_key_chunk = round(rand(1,6));

%good_key_chunk = bad_key_chunk;

while all(bad_key_chunk == good_key_chunk)
     bad_key_chunk = round(rand(i,i+5));
end

% GA = Good key chunk, tested bit = 0
% GB = Good key chunk, tested bit = 1
% BA = Bad key chunk, tested bit = 0
% BB = Bad key chunk, tested bit = 1

trace_ga = zeros(1,spower);
trace_gb = zeros(1,spower);
trace_ba = zeros(1,spower);
trace_bb = zeros(1,spower);

s = num_samples;

nga = 0;
ngb = 0;
nba = 0;
nbb = 0;

tested_bit_index = 1 + (tested_sbox - 1) * 4;

while s > 0

	plaintext = round(rand(1,64));
	[ciphertext power] = dpa_des_pencryption(plaintext, keys, pmodel);


	% oracle using the good key chunk
	r = dpa_des_selection_function(ciphertext, tested_sbox, good_key_chunk);

	if r == 0
		trace_ga = trace_ga + power;
		nga = nga + 1;
	else
		trace_gb = trace_gb + power;
		ngb = ngb + 1;
	end


	% oracle using the erroneous key chunk
	r = dpa_des_selection_function(ciphertext, tested_sbox, bad_key_chunk);

	if r == 0
		trace_ba = trace_ba + power;
		nba = nba + 1;
	else
		trace_bb = trace_bb + power;
		nbb = nbb + 1;
	end

	s = s - 1;
end


if nga ~= 0
trace_ga = trace_ga / nga;
end

if ngb ~= 0
trace_gb = trace_gb / ngb;
end

if nba ~= 0
trace_ba = trace_ba / nba;
end

if nbb ~= 0
trace_bb = trace_bb / nbb;
end

g = trace_ga - trace_gb;
b = trace_ba - trace_bb;

figure(1);
x = 1:size(g,2);

n = 20; 
f = ones(1, n) / n;

lg = conv(f, g);
lb = conv(f, b);
lg = lg(1, 1 : spower);
lb = lb(1, 1 : spower);

% Some statistics (mean and standard deviation)
mlg = mean(lg);
mlb = mean(lb);
slg = std(lg);
slb = std(lb);
disp('dpaspike');
disp(dpa_des_spike(g));
disp(dpa_des_spike(b));
disp('/dpaspike');
nstd = 10;

% Plot the raw data
subplot(3,2,1);
plot(x, g, '-g');
subplot(3,2,2);
plot(x, b, '-r');



% Plot the filtered (smoothed) data with the limits
subplot(3,2,3);
hold on;
plot(x, lg, '-g');
plot([1 spower], [1 1] * nstd * (mlg - slg), '-b');
plot([1 spower], [1 1] * nstd * (mlg + slg), '-b');
subplot(3,2,4);
hold on;
plot(x, lb, '-r');
plot([1 spower], [1 1] * nstd * (mlb - slb), '-b');
plot([1 spower], [1 1] * nstd * (mlb + slb), '-b');


subplot(3,2,5);
n2 = 40;
[n, xout] = hist(lg, n2);
sumi = 0; for i = [1 : n2]; sumi = sumi + n(i); n(i) = sumi / spower; end
hold on;
plot(xout, n, '-g');
plot([1 1] * nstd * (mlg + slg), [0 1], '-b');
plot([1 1] * nstd * (mlg - slg), [0 1], '-b');
subplot(3,2,6);
[n, xout] = hist(lb, n2);
sumi = 0; for i = [1 : n2]; sumi = sumi + n(i); n(i) = sumi / spower; end
hold on;
plot(xout, n, '-r');
plot([1 1] * nstd * (mlb + slb), [0 1], '-b');
plot([1 1] * nstd * (mlb - slb), [0 1], '-b');

spdetector(g)
spdetector(b)
