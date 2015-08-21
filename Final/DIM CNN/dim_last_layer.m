function [ outmaps ] = dim_last_layer(net, X, dim_impl )
%DIM_LAST_LAYER Summary of this function goes here
%   Detailed explanation goes here
net = dim_ff(net, X, dim_impl);
for i = 1: numel(net.layers)    
    outmaps{i} = net.layers{i}.a;
end

end

