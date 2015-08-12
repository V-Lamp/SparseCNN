function [ outmaps ] = cnn_last_layer( net, X )
%CNN_LAST_LAYER Summary of this function goes here
%   Detailed explanation goes here
net = cnnff(net,X);
outmaps = net.layers{numel(net.layers)}.a;
end

