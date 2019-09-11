function [ power ] = dpa_des_power_simplest_model( block )
%DES_POWER_SIMPLEST_MODEL( BLOCK ) Computes a simple "over-correlated" power trace
%from a bit 64 bits block.


power = zeros(1, size(block,2));
power = (-2 * block) + 1;

