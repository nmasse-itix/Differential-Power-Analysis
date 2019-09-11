function [ spike ] = dpa_des_power_simplest_model_criteria(mean)
%DES_POWER_SIMPLEST_MODEL_CRITERIA(MEAN ) return the peak height

spike = max(mean);
