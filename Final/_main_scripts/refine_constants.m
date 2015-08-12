% load dim_out_mask_split.mat
% for i = 1:100
%     plot_layers({cell_slice(test_out,i,i)},true);
%     waitforbuttonpress
% end
[train_x, ~, test_x, ~] = get_mnist_data();
S = load('saved_data\small_cnn');
dim_impl = @DIM_sep_mask_splitting;
net = dim_setup(S.cnn,[28,28],10);
for i = 1:5
    X = test_x(:,:,i);
    net = dim_ff(net, X, dim_impl);
    plot_network(net,true);
    pause(0.8)
end

