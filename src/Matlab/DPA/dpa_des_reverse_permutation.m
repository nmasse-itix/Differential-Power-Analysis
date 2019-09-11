function [ outBlock32 ] = dpa_des_reverse_permutation( inBlock32 )
%DES_INVERSE_PERMUTATION DO REVERSE OF THE IN-ROUND PERMUTATION)

% Test case :
%{
in = [1 : 32];
ret = des_inverse_permutation(in);
ref = [16 7 20 21 29 12 28 17 1 15 23 26 5 18 31 10 2  8 24 14 32];
ref = [ref 27  3  9 19 13 30 6 22 11  4 25];
all(ret == ref)
%}

P = [9 17 23 31 13 28 2 18 24 16 30 6 26 20 10 1 8 14];
P = [P 25 3 4 29 11 19 32 12 22 7 5 27 15 21];

outBlock32 = zeros(1, 32);

for i = [1 : 32]
    outBlock32(i) = inBlock32(P(i));
end


