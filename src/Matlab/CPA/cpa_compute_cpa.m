function [best_guess, max_corr_factor, max_corr_sample_id] = cpa_compute_cpa(directory_name, variant, max_curve_num)
%CPA_COMPUTE_CPA(DIRECTORY_NAME, VARIANT)
% Use the curves and the associated cleartext in the provided directory to compute the key chunks
% associated with the des first round subkey
% return    the best guess, one per sbox
%           the maximum correlation factor, one per sbox
%           the index in the curve of the sample associated with the
%           maximum correlation factor.

% initializing results arrays: max correlation factor for each sbox, and
% the associated guess on the key chunk
max_corr_factor = zeros(1,8);
max_corr_sample_id = zeros(1,8);
best_guess = zeros(1,8);


% preloading the curves data (40  * 50ko curves)
curves = cpa_load_curves(directory_name, variant, max_curve_num);

num_curve = size(curves, 1);
num_sample = size(curves, 2);

% computing standarg deviation among curves same timestep samples;
std_curve_sample = std(curves);
mean_curve_sample = mean(curves, 1);


% iterating over all the possible guess
for guess = 0:63
    disp(guess);
    % get the hamming weight assotiated with the cleartexts, one column per
    % sbox
    weights = cpa_get_hamming_weigth(directory_name, guess, num_curve);
    
    % computing standard deviation and mean
    std_hamming = std(weights);
    mean_hamming = mean(weights, 1);
    
    
    %iterating over sbox
    for sbox = 1:8
        w =  weights(:, sbox);
        
        max_corr = 0;
        max_corr_id = 0;
        
        %iterating over samples to compute correlation curve
        for i = 1:num_sample
            std_curve_sample_i = std_curve_sample(i);
            std_hamming_sbox = std_hamming(sbox);
            if std_curve_sample_i ~= 0 & std_hamming_sbox ~= 0
                correlation_factor= (mean(curves(:,i) .* w, 1) - (mean_curve_sample(i) * mean_hamming(sbox))) / (std_curve_sample_i * std_hamming_sbox);

                if correlation_factor > max_corr
                    max_corr = correlation_factor;
                    max_corr_id = i;
                end
            end
        end
        
        if max_corr > max_corr_factor(sbox)
            max_corr_factor(sbox) = max_corr;
            max_corr_sample_id(sbox) = max_corr_id;
            best_guess(sbox) = guess;
        end
    end
end