
%%
cnn = build_cnn(5,[6,12],[28,28],10);
opts.alpha = 1.8;
opts.batchsize = 100;
opts.numepochs = 80;

[train_x, train_y, test_x, test_y] = get_mnist_data();
cnn = cnntrain(cnn, train_x, train_y, opts);

figure; plot(cnn.rL);
er_test = cnntest(cnn, test_x, test_y);
er_train = cnntest(cnn, train_x, train_y);
save(['saved_data', filesep, 'small_cnn'],'cnn')
figure; semilogy(cnn.rL);
plot_network(cnn)
assert(er_test<0.12, 'Too big error');
