function [ outBlock28 ] = des_shift( inBlock28, shift )
%DES_SHIFT Left shift of a 28 bits block
%  shift is 1 or 2

% Test case :
%{
all(des_shift(1:28, 2) == [3:28, 1:2])
all(des_shift(1:28, 1) == [2:28, 1])
%}

if shift == 1
    outBlock28 = [inBlock28(2:28) inBlock28(1)];
else % shift == 2
    outBlock28 = [inBlock28(3:28) inBlock28(1:2)];
end
