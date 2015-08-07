function [ net ] = build_cnn( kernel_size, out_maps_counts, input_map_size, output_size )
%BUILD_CNN Summary of this function goes here
%   Detailed explanation goes here
n_layers = numel(out_maps_counts);
layers ={struct('type', 'i')};
for i = 1: n_layers
    layers{1 + (i-1)*2 + 1} = ...
        struct('type', 'c', 'outputmaps', out_maps_counts(i), 'kernelsize', kernel_size);
    layers{1 + (i-1)*2 + 2} = struct('type', 's', 'scale', 2);
end
net.layers= layers;
net=cnnsetup(net, input_map_size, output_size);

end

