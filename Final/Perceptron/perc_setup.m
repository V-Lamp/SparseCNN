function [ dim_cnn ] = perc_setup...
    (inputmap_size, inputmaps_count, output_size )
%SETUP_DIM Summary of this function goes here
%   Detailed explanation goes here
%     inputmaps = size(plain_cnn.layers{end}.a,2);
%     n_l = numel(plain_cnn.layers);
%     mapsize = size(plain_cnn.layers{n_l}.a{1}(:,:,1));
    fvnum = prod(inputmap_size) * inputmaps_count;
    onum = output_size;

    dim_cnn.ffb = zeros(onum, 1);
    dim_cnn.ffW = (rand(onum, fvnum) - 0.5) * 2 * sqrt(6 / (onum + fvnum));
    
    
end

