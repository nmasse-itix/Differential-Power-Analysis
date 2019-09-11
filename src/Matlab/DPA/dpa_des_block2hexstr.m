function [ str ] = dpa_des_block2hexstr(block)
%DES_DPA(BLOCK) to display a block in hexadecimal format. block length must
% be a multiple of 8. Return a string

numblock = (size(block, 2) / 8) - 1;

str = '';

p2 = 2 .^ [7:-1:0];

for i = [0 : numblock]
    id =  i * 8;
    subblock = block(id + 1:id + 8);
    val = subblock * p2';
    str = strcat(str, dec2hex(val,2));
end