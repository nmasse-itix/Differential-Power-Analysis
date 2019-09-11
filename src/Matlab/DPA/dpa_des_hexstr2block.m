function [ block ] = dpa_des_hexstr2block(str)
%DPA_DES_HEXSTR2BLOCK(STR) compute a key block from an hexadecimal string
%representation

block = [];

for i = str
    num = hex2dec(i);
    bin = dec2bin(num,4);
    
    for i = bin
        block = [block, str2num(i)];
    end
end