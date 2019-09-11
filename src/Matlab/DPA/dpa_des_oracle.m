function block = dpa_des_oracle( ciphertext, tested_sbox, key_chunk )
%DES_ORACLE(CIPHERTEXT, TESTED_SBOX, KEY_CHUNK)
%
% Return  the value, before the last des round, of the four bits
% modified by the specified key_chunk during the last round

% expand the key chunk to a 48 bit key
key48 = dpa_des_expand_key_chunk(key_chunk, tested_sbox);

% invert final permutation (aka initial permutation) to retrive
% last des round result 
data = des_initial_permutation(ciphertext);

% reapply last round
block = des_round(data, key48);



