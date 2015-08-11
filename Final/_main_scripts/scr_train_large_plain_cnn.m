
%%
cnn = build_cnn(5,[12,24],[28,28],10);
opts.alpha = 1.5;
opts.batchsize = 25;
opts.numepochs = 15;

[train_x, train_y, test_x, test_y] = get_mnist_data();
cnn = cnntrain(cnn, train_x, train_y, opts);

figure; plot(cnn.rL);
er_test = cnntest(cnn, test_x, test_y);
er_train = cnntest(cnn, train_x, train_y);
save('Results\large_cnn','cnn')
plot_network(cnn,false)
assert(er_test<0.12, 'Too big error');
