function result = dpa_des_selection_function(ciphertext, tested_sbox, key_chunk )
%DES_SELECTION_FUNCTION(CIPHERTEXT, TESTED_SBOX, KEY_CHUNK)
%
% Return  0 or 1 depending of the value, before the round, of the first bit processed
% by the tested sbox.


block = dpa_des_oracle(ciphertext, tested_sbox, key_chunk);


% to keep bit processed by the sbox n in a contiguous block of bit
data = dpa_des_reverse_permutation(block(1:32));

tested_bit_index = 1 + (tested_sbox - 1) * 4;

result = data(tested_bit_index);

