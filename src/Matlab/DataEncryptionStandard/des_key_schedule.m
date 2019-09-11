function [ keys ] = des_key_schedule( key64 )
%DES_KEY_SCHEDULE Generate 16 subkeys from a 64 bits master key

des_shift_number = [ 1 1 2 2 2 2 2 2 1 2 2 2 2 2 2 1 ];

[ Cn Dn ] = des_permuted_choice_1(key64);

keys = zeros(16, 48);

for i = [1 : 16]
    Dn = des_shift(Dn, des_shift_number(i));
    Cn = des_shift(Cn, des_shift_number(i));
    keys(i, :) = des_permuted_choice_2(Cn, Dn);
end

