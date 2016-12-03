load small_cnn;

opts.alpha = 0.05;
opts.batchsize = 500;
opts.numepochs = 1;
%[train_x, train_y, test_x, test_y] = get_mnist_data();
figure; plot(cnn.rL);
cnn = fc_train(cnn, train_x, train_y, opts, @cnnff);

figure; plot(cnn.rL);
er_test = cnntest(cnn, test_x, test_y);
%er_train = cnntest(cnn, train_x, train_y);
save('saved_data\small_dim_cnn','cnn')
plot_network(cnn)
assert(er_test<0.12, 'Too big error');
