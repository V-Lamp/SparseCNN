function [ outmaps ] = cnn_last_layer( net, X )
%CNN_LAST_LAYER Summary of this function goes here
%   Detailed explanation goes here
net = cnnff(net,X);
for i = 1: numel(net.layers)    
    outmaps{i} = net.layers{i}.a;
end
end

