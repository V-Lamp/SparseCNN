function plot_network(net, overwrite)
%PLOT_NETWORK Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 2
        overwrite = false;
    end
    n_l = numel(net.layers);
    layers = cell(n_l,1);
    for i = 1: n_l
        layers{i} = net.layers{i}.a;
    end
    layers{n_l+1}={net.o(:,1)'};
    plot_layers(layers,overwrite)

end

 