function [ output_args ] = plot_network(net)
%PLOT_NETWORK Summary of this function goes here
%   Detailed explanation goes here
    layers = {}
    for i = 1:
        layers{i} = net.layer{i}.a
    end
    plot_layers(layers)

end

