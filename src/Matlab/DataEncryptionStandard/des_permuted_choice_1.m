function [C0, D0] = des_permuted_choice_1(key64)
% DES_PERMUTED_CHOICE_1(k), where k is the 64 bits master key, compute C0 and D0

pc1_c = [57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35, 27, 19, 11, 3, 60, 52, 44, 36];
pc1_d = [63, 55, 47, 39, 31, 23, 15, 7, 62, 54, 46, 38, 30, 22, 14, 6, 61, 53, 45, 37, 29, 21, 13, 5, 28, 20, 12, 4];

for i = 1:numel(pc1_c);
	C0(i) = key64(pc1_c(i));
	D0(i) = key64(pc1_d(i));	
end


%{
to test this function:
call it with an array containing the 64 first strictly positive integer and
compare the output c and d with the permutation table as defined in fips 46-3,
page 19.

[c,d] = des_permuted_choice_1(1:64);
result = all(c == permut_table1) and all(d == permut_table2);

%}
