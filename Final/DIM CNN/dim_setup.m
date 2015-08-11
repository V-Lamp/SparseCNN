function [ dim_cnn ] = dim_setup(plain_cnn, inputmap_size, output_size )
%SETUP_DIM Summary of this function goes here
%   Detailed explanation goes here
%     inputmaps = size(plain_cnn.layers{end}.a,2);
%     n_l = numel(plain_cnn.layers);
%     mapsize = size(plain_cnn.layers{n_l}.a{1}(:,:,1));

    net= plain_cnn;
    inputmaps = 1;
    mapsize = inputmap_size;
    for l = 1 : numel(plain_cnn.layers)   %  layer
        % subsampling
        if strcmp(net.layers{l}.type, 's')
            mapsize = mapsize / net.layers{l}.scale;
            assert(all(floor(mapsize)==mapsize),...
                ['Layer ' num2str(l) ' size must be integer. Actual: ' num2str(mapsize)]);
        end
        % convolutional
        if strcmp(net.layers{l}.type, 'c')
            mapsize = mapsize;            
            inputmaps = net.layers{l}.outputmaps;
        end
    end
    dim_cnn = plain_cnn;
    fvnum = prod(mapsize) * inputmaps;
    onum = output_size;
    
    
    
    dim_cnn.ffb = zeros(onum, 1);
    dim_cnn.ffW = (rand(onum, fvnum) - 0.5) * 2 * sqrt(6 / (onum + fvnum));
    
    dim_cnn.dffW = [];
    dim_cnn.dffb = [];
    dim_cnn.od = [];
    dim_cnn.fvd = [];
    
end

