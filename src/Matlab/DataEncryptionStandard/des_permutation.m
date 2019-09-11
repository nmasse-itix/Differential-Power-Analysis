function [ outBlock32 ] = des_permutation( inBlock32 )
%DES_PERMUTATION Do the in-round permutation

% Test case :
%{
in = [1 : 32];
ret = des_permutation(in);
ref = [16 7 20 21 29 12 28 17 1 15 23 26 5 18 31 10 2  8 24 14 32];
ref = [ref 27  3  9 19 13 30 6 22 11  4 25];
all(ret == ref)
%}

P = [16 7 20 21 29 12 28 17 1 15 23 26 5 18 31 10 2  8 24 14 32 27  3  9];
P = [P 19 13 30 6 22 11  4 25];

outBlock32 = zeros(1, 32);

for i = [1 : 32]
    outBlock32(i) = inBlock32(P(i));
end

