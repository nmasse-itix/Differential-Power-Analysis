function [ ciphertext power ] = dpa_des_pencryption( plaintext, keys, model )
%DES_PENCRYPTION(PLAINTEXT, KEYS, MODEL)
%Executes the DES algorithm and computes a power trace using the given model

% compute subkeys if only master key is provided
if size(keys,1) == 1
	keys = des_key_schedule(keys);
end

data = des_initial_permutation(plaintext);

for round = 1:15
	data = des_round(data, keys(round,:));
	data = des_block_interchange(data);
end

power = model(data);

data = des_round(data, keys(16,:));

ciphertext = des_final_permutation(data);
