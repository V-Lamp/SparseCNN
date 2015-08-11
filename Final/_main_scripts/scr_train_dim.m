dim_impl = @DIM_MaskSplitting;

S = load('small_cnn');
opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 1;

[train_x, train_y, test_x, test_y] = get_mnist_data();
dim_cnn = dim_setup(S.cnn,[28,28],10);
ff = @(net, x) dim_ff(net, x, dim_impl);
dim_cnn = fc_train(dim_cnn, train_x, train_y, opts, ff);

figure; plot(dim_cnn.rL);
er_test = dim_test(dim_cnn, test_x, test_y);
er_train = dim_test(dim_cnn, train_x, train_y);
save('results\small_dim_cnn','cnn')
plot_network(dim_cnn)
assert(er_test<0.12, 'Too big error');
