function res = perc_train_from_inputs(train_in, test_in)
%PERC_TRAIN_FROM_FILE Summary of this function goes here
%   Detailed explanation goes here

[~, train_y, ~, test_y] = get_mnist_data();

outmaps_size = size(train_in{1}(:,:,1));
outmaps_count = numel(train_in);

net = perc_setup(outmaps_size, outmaps_count, 10);

opts.alpha = 2;
opts.red_rate = 0.7;
opts.batchsize = 10;
opts.numepochs = 20;

res.net = perc_train(net, train_in, train_y, opts);
res.er_train = perc_test(res.net,train_in,  train_y);
[res.er_test, res.bad] = perc_test(res.net,test_in,  test_y);
end

