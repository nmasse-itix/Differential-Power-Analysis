function [weights] =  cpa_get_hamming_weigth_per_sbox(directory_name, sbox, guess, num_curve)
%CPA_GET_HAMMING_WEIGHT_PER_SBOX(DIRECTORY_NAME, SBOX, GUESS)
% return an array containing the hamming weigth of
% the handled cleartext when the given sbox and guess is used



filename = [directory_name, '/cpa/', 'S', num2str(sbox), '/outbox.64_4.s', num2str(sbox), '.p00.g', num2str(guess, '%02d')];
fid = fopen(filename, 'r');

weights = [];
i = 0;

while i < num_curve & ~ feof(fid)
   str = fgetl(fid);
   data = sscanf(str, '%d%d');
   weights = [weights; data(2)];
   i = i + 1;
end

fclose(fid);