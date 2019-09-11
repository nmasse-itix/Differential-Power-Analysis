function [ outBlock64 ] = des_block_interchange( inBlock64 )
%DES_BLOCK_INTERCHANGE Exchange the parts of a 64 bits block

% Test case :
%{
ret = des_block_interchange(1:64);
ref = [33:64, 1:32];
all(ret == ref)
%}

outBlock64 = [inBlock64(33:64) inBlock64(1:32)];

