function [good_bit] = dpa_des_dpa_test(num_samples, power_model)
%DES_DPA_TEST(NUM_SAMPLES, POWER_MODEL) Tests the simple version of the DPA algorithm

s = num_samples;

% we build a random key
key = round(rand(1,64));
% raz parity bit of the key. reverse key schedule do the same
key(8:8:64) = 0;

keys = des_key_schedule(key);


[pmodel spdetector] = dpa_des_power_model(power_model);

traces = [];
ciphers = [];
clears = [];

while s > 0
	plaintext = round(rand(1,64));
	[ciphertext power] = dpa_des_pencryption(plaintext, keys, pmodel);
    
    clears = [clears ; plaintext];
    ciphers = [ciphers ; ciphertext];
    traces = [traces ; power];
    
	s = s - 1;
end

returned_keys = dpa_des_dpa(traces, ciphers, spdetector);


%if all(returned_keys == keys(16,:))
%   disp('La clé est trouvée');
%end



fprintf(1, 'original key:\t%s\n', dpa_des_block2hexstr(key));

for i = [1 : size(returned_keys, 1)]
   %disp(sum(returned_keys(i, :) == key) - 8);
   k = returned_keys(i, :);
   if all(k == key)
       fprintf(1, 'found key\t%s\n', dpa_des_block2hexstr(k));
   end
end
