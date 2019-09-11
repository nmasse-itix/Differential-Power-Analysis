function plaintext = des_decryption(ciphertext, keys)
% DES_DECRYPTION 64 bit block ciphertext, keys
% compute the decryption of the input block

% compute subkeys if only master key is provided
if size(keys,1) == 1
	keys = des_key_schedule(keys);
end


data = des_initial_permutation(ciphertext);

for round = 1:15
	data = des_round(data, keys(17 - round,:));
	des_block_interchange(data);
end

data = des_round(data, keys(1,:));
plaintext = des_final_permutation(data);
