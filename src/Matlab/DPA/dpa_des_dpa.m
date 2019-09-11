function [ keys ] = dpa_des_dpa(traces, ciphers, spike_detector)
%DES_DPA(TRACES,CIPHERS,CLEARS) Simple version of the DPA on DES
%  Returns the possible keys, using the provided traces and ciphers

n_traces = size(traces, 1);
n_samples = size(traces, 2);
sbox_num = 8;

hypothesis_spike_max = zeros(1, sbox_num);
hypothesis_subkey = zeros(1, sbox_num);

% we iterate over the 64 possible subkeys
for ikey = [0 : 63]
    fprintf(1, 'test sous clé %d\n', ikey);

    %if mod(i,16) == 0
    %    figure((i / 16) + 1);
    %end

    % compute the key chunk block
    key_chunk = dec2bin(ikey, 6) == '1';

    % place to store 8 parallele dpa over the 8 s-box
    trace_a = zeros(sbox_num, n_samples);
    trace_b = zeros(sbox_num, n_samples);

    na = zeros(1,sbox_num);
    nb = zeros(1,sbox_num);

    % iterate over all the trace
    for n_trace = [1 : n_traces]

        % iterate over the 8 sbox
        for n_sbox = [1:sbox_num]
            r = dpa_des_selection_function(ciphers(n_trace,:), n_sbox, key_chunk);

            if r == 0
                trace_a(n_sbox,:) = trace_a(n_sbox,:) + traces(n_trace,:);
                na(n_sbox) = na(n_sbox) + 1;
            else
                trace_b(n_sbox,:) = trace_b(n_sbox,:) + traces(n_trace,:);
                nb(n_sbox) = nb(n_sbox) + 1;
            end
        end
    end

    % iterate over the 8 sbox
    for n_sbox = [1:sbox_num]
        if na(n_sbox) ~= 0
            trace_a(n_sbox,:) = trace_a(n_sbox,:) / na(n_sbox);
        end

        if nb(n_sbox) ~= 0
            trace_b(n_sbox,:) = trace_b(n_sbox,:) / nb(n_sbox);
        end
        
        spike_value = spike_detector(trace_a(n_sbox,:) - trace_b(n_sbox,:));
        %if spike_value == 2
        %   fprintf(1, 'key chunk num: %d found, %s\n', n_sbox,dec2bin(ikey,6)) ;
        %end
        
        if spike_value > hypothesis_spike_max(n_sbox)
            hypothesis_spike_max(n_sbox) = spike_value;
            hypothesis_subkey(n_sbox) = ikey;
        end
    end
end

% rebuild the last key using the chosen subkey
computed_last_key = [];
for n_sbox = [1:sbox_num]
    k = dec2bin(hypothesis_subkey(n_sbox), 6) == '1';
    computed_last_key = [computed_last_key k];
end

keys = dpa_des_reverse_ks(computed_last_key);
%keys = computed_last_key;
