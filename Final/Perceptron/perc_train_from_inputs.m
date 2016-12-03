function res = perc_train_from_inputs(train_in, train_y, test_in, test_y)
%PERC_TRAIN_FROM_FILE Summary of this function goes here
%   Detailed explanation goes here

outmaps_size = size(train_in{1}(:,:,1));
outmaps_count = numel(train_in);

net = perc_setup(outmaps_size, outmaps_count, 10);

opts.alpha = 0.35;
opts.red_rate = 1;
opts.batchsize = 200;
opts.numepochs = 15;

net = perc_train(net, train_in, train_y, opts);

opts.alpha = 0.6;
opts.red_rate = 1;
opts.batchsize = 100;
opts.numepochs = 300;

res.net = perc_train(net, train_in, train_y, opts);
res.er_train = perc_test(res.net,train_in,  train_y);
[res.er_test, res.bad] = perc_test(res.net,test_in,  test_y);
end

