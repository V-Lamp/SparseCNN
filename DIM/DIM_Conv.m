function [ outMaps ] = DIM_Conv( inMaps,w,method,outMaps)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if nargin <3
    method=1;
end
if nargin <4
    outMaps={};
end
   
if method==1 % conv
    outMaps=aggConv(inMaps,w,'same',outMaps);
elseif method==2 %DIM
    outMaps=DIM_MaskSplitting(w,inMaps,outMaps,20);
else
    error('method != 1|2') 
end

