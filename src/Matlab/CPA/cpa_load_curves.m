function [curves] = cpa_load_curves(directory_name, variant, max_curve_num)
%CPA_LOAD_CURVES(DIRECTORY_NAME, VARIANT, MAX_CURVE_NUM)
% a null max_num_curve lead to load all the curves in the specified directory
% return an array (size: [num_curves, num_sample_per_curve])


curves = [];
num_curve = 0;

filename = [directory_name, '/curves/00/', variant, '.', num2str(num_curve, '%05d')];
fid = fopen(filename,'r');


% try to load max_curve_num curve files in the directory
while  ((max_curve_num == 0) | (num_curve < max_curve_num)) & fid ~= -1
   
   curves = [curves; fread(fid, inf, 'uint8')'];
   fclose(fid);
   
   num_curve = num_curve + 1;
   filename = [directory_name, '/curves/00/', variant, '.', num2str(num_curve, '%05d')];
   fid = fopen(filename,'r');
end
