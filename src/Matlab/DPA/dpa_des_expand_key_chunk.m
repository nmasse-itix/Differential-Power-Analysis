function key48 = des_expand_key_ckunk(key_chunk, key_chunk_number )
%DES_EXPAND_KEY_CHUNK(KEY_CHUNK, KEY_CHUNK_NUMBER)
% compute a 48 bits key based on the provided chunk (6 bits), concatenate with 0
% key_chunk_number indicate where will be the chunk in the key48 (1 <= x  <= 8)

key48 = horzcat(zeros(1, (key_chunk_number - 1) * 6), key_chunk, zeros(1, 6 * (8 - key_chunk_number)));
