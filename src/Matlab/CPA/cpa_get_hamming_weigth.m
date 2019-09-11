function [weights] =  cpa_get_hamming_weigth(directory_name, guess, num_curve)
%CPA_GET_HAMMING_WEIGHT(DIRECTORY_NAME, GUESS)
% return array containing the hamming weigth of
% the handled cleartext when the given guess is used, one line per sbox

weights = [];

for sbox = 1:8
 weights = [weights, cpa_get_hamming_weigth_per_sbox(directory_name, sbox, guess, num_curve)];   
end