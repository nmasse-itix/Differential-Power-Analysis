function [block64out] = des_initial_permutation(block64in)
% DES_INITIAL_PERMUTATION(BLOCK64IN), permute bit, used before applying des first round

ip = [58, 50, 42, 34, 26, 18, 10, 2, 60, 52, 44, 36, 28, 20, 12, 4, 62, 54, 46, 38, 30, 22, 14, 6, 64, 56, 48, 40, 32, 24, 16, 8, 57, 49, 41, 33, 25, 17, 9, 1, 59, 51,  43,  35,  27,  19,  11, 3, 61, 53, 45, 37, 29, 21, 13, 5, 63, 55, 47, 39, 31, 23, 15, 7];

for i = 1:numel(ip);
	block64out(i) = block64in(ip(i));
end


%{
to test this function:
call it with block64in an array containing the 64 first strictly positive integer,
with the initial permutation table as defined in fips 46-3, page 10.

block64out = des_initial_permutation(1:64);
result = all(block64out == ip);

%}
