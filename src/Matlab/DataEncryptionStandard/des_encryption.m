function ciphertext = des_encryption(plaintext, keys)
% DES_ENCRYPTION 64 bit block plaintext, keys
% compute the encryption of the input block

% compute subkeys if only master key is provided
if size(keys,1) == 1
	keys = des_key_schedule(keys);
end


data = des_initial_permutation(plaintext);

for round = 1:15
	data = des_round(data, keys(round,:));
	data = des_block_interchange(data);
end

data = des_round(data, keys(16,:));
ciphertext = des_final_permutation(data);
