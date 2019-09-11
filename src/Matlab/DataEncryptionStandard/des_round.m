function [ outBlock64 ] = des_round( inBlock64, subkey48 )
%DES_ROUND Do a DES round

% Test case :
%{
res = des_round([des_cipher_function(zeros(1,32), zeros(1,48)) zeros(1,32)], zeros(1,48))
all(res == zeros(1, 64))
%}

outBlock64 = [xor(des_cipher_function(inBlock64(33:64), subkey48), inBlock64(1:32)), inBlock64(33:64)];
