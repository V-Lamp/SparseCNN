% get trained cnn
S = load('small_cnn');
[train_x, train_y, test_x, test_y] = get_mnist_data();
sample = test_x(:,:,1);
dim_impls = {@DIM_MaskSplitting, @DIM_sigmoids, @ DIM_sep_mask_splitting};

% for each idea
close all;
for i =1:3
    dim_cnn = dim_setup(S.cnn,[28,28],10);
    dim_cnn = dim_ff(dim_cnn, sample, dim_impls{i});
    plot_network(dim_cnn);
end
% train last layer
% report accuracy
% plot output
