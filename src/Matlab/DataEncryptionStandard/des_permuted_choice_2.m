function [subkey48] = des_permuted_choice_2(c, d)
% DES_PERMUTED_CHOICE_2(C, D), where C and D come from shifted C0 and D0

pc2 = [14, 17, 11, 24, 1, 5, 3, 28, 15, 6, 21, 10, 23, 19, 12, 4, 26, 8, 16, 7, 27, 20, 13, 2, 41, 52, 31, 37, 47, 55, 30, 40, 51, 45, 33, 48, 44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29, 32];

for i = 1:numel(pc2);
	bit_num = pc2(i);
	if bit_num <= 28
		subkey48(i) = c(bit_num);
	else   
		subkey48(i) = d(bit_num - 28);
	end
end


%{
to test this function:
call it with c an  array containing the 24 first strictly positive integer,
d an  array containing the 24 following integer and compare the output subkey
with the permutation table as defined in fips 46-3, page 21.

subkey = des_permuted_choice_2(1:28, 29:56);
result = all(subkey == permut_table2);

%}
