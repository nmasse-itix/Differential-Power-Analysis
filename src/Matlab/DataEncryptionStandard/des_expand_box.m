function [ block48 ] = des_expand_box( block32 )
%DES_EXPAND_BOX Expand a 32 bits block into a 48 bits block

% Test case :
%{
in = [1 : 32];
ret = des_expand_box(in);
ref = [32 1 2 3 4 5 4 5 6 7 8 9 8 9 10 11 12 13 12 13 14 15 16 17 16];
ref = [ref 17 18 19 20 21 20 21 22 23 24 25 24 25 26 27 28 29 28 29];
ref = [ref 30 31 32  1];
all(ret == ref)
%}

E = [32  1  2  3  4  5  4  5  6  7  8  9  8  9 10 11 12 13 12 13 14 15 16];
E = [E 17 16 17 18 19 20 21 20 21 22 23 24 25 24 25 26 27 28 29 28 29 30];
E = [E 31 32  1];

block48 = zeros(1, 48);

for i = [1 : 48]
    block48(i) = block32(E(i));
end
