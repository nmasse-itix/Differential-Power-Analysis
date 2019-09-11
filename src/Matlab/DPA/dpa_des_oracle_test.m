function [ good_response, false_response ] = dpa_des_oracle_test(number_of_test)
%DES_ORACLE_TEST(NUMBER_OF_TEST) Return the number of oracle's good and false response, after <number_of_test>

good_response = 0;
false_response = 0;

for test = 1:number_of_test 

% choose a plaintext and a key to use in this test
keys = round(rand(1,64));
plaintext = round(rand(1,64));


if size(keys,1) == 1
	keys = des_key_schedule(keys);
end

data = des_initial_permutation(plaintext);

for rnd = 1:15
	data = des_round(data, keys(rnd,:));
	data = des_block_interchange(data);
end

% store the value of the left block before applying last round
before_16_data = data(1:32);
before_16_data = dpa_des_reverse_permutation(before_16_data);

data = des_round(data, keys(16,:));

ciphertext = des_final_permutation(data);

lastkey48 = keys(16,:);

for sbox_number = [1:8]

	id32 = ((sbox_number - 1) * 4) + 1;
	id48 = ((sbox_number - 1) * 6) + 1;

	block = dpa_des_oracle(ciphertext, sbox_number, lastkey48(id48 : id48 + 5));

	if all(block == before_16_data(id32:id32 + 3)) == 1
		good_response = good_response + 1;
	else
		false_response = false_response + 1;
	end

end

end
