C = load('saved_data\cnn_outmaps');
outmaps = C.outmaps;
Y = C.Y;
[train_x, train_y, test_x, test_y] = get_mnist_data();
% outmaps = {train_x};
% Y = train_y;
outmaps_size = size(outmaps{1}(:,:,1));
outmaps_count = numel(outmaps);

net = perc_setup(outmaps_size, outmaps_count,10);

opts.alpha = 0.5;
opts.red_rate = 0.9;
opts.batchsize = 50;
opts.numepochs = 200;
[er, bad] = perc_test(net,outmaps,  Y);
net = perc_train(net, outmaps, Y, opts);
[er, bad] = perc_test(net,outmaps,  Y);


