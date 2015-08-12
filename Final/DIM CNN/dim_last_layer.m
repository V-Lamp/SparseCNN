function [ outmaps ] = dim_last_layer(net, X, dim_impl )
%DIM_LAST_LAYER Summary of this function goes here
%   Detailed explanation goes here
net = dim_ff(net, X, dim_impl);
outmaps = net.layers{numel(net.layers)}.a;

end

