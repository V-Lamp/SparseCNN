function [ net,er,bad ] = perc_train_from_file(filename )
%PERC_TRAIN_FROM_FILE Summary of this function goes here
%   Detailed explanation goes here
C = load(['Results\',filename]);
outmaps = C.outmaps;
[~, train_y, ~, test_y] = get_mnist_data();

outmaps_size = size(outmaps{1}(:,:,1));
outmaps_count = numel(outmaps);

net = perc_setup(outmaps_size, outmaps_count,10);

opts.alpha = 3;
opts.batchsize = 50;
opts.numepochs = 30;

net = perc_train(net, outmaps, Y, opts);
[er, bad] = perc_test(net,outmaps,  Y);




end

