function [ block ] = dpa_des_deckeychunk2block(dec_key_chunks)
%DPA_DES_DECKEYCHUNK2BLOCK(DEC_KEY_CHUNKS) compute a round key block from an array
%of decimal values, one per sbox (value 1 for sbox 1 etc...)
%representation


num_chunks = size(dec_key_chunks, 2);

block = [];
for chunk = dec_key_chunks
    str = dec2bin(chunk,6);
    for c = str
        block = [block, str2num(c)];
    end
end