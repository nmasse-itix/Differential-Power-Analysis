function [ outBlock32 ] = des_cipher_function( inBlock32, subkey48 )
%DES_CIPHER_FUNCTION Encrypt a 32 bits block using a 48 bits subkey

% E function
inBlock48 = des_expand_box(inBlock32);

% XOR
outBlock48 = xor(inBlock48, subkey48);

% SBOXes
outBlock32 = zeros(1, 32);
for i = 1 : 8
    outBlock32(((i - 1) * 4) + 1 : i * 4) = des_sbox(outBlock48(((i - 1) * 6) + 1 : i * 6), i);
end

% P 
outBlock32 = des_permutation(outBlock32);
