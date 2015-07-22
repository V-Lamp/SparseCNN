function [ y ] = sigm_der( x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    y = x ./ (1 - x);
end
