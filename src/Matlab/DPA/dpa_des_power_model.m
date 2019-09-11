function [power criteria] = dpa_des_power_model(model_name)
%DES_POWER_MODEL(MODEL_NAME)

switch model_name
    case 'des_power1'
      power = @dpa_des_get_power;
      criteria = @dpa_des_spike;
    case 'des_power2'
        power = @dpa_des_power_simplest_model;
        criteria = @dpa_des_power_simplest_model_criteria;
    otherwise
        power = 0;    
        criteria = 0;
end
