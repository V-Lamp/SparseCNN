

%%
cnn = build_cnn(5,[2,2],[28,28],10);
batch_x = rand(28,28,5);
batch_y = rand(10,5);
cnn = cnnff(cnn, batch_x);
cnn = cnnbp(cnn, batch_y);
cnnnumgradcheck(cnn, batch_x, batch_y);
disp('Gradients are correct!')
%%
cnn = build_cnn(5,[6,12],[28,28],10);
opts.alpha = 1;
opts.batchsize = 25;
opts.numepochs = 3;

[train_x, train_y] = get_mnist_data();
cnn = cnntrain(cnn, train_x, train_y, opts);

figure; plot(cnn.rL);
assert(er<0.12, 'Too big error');