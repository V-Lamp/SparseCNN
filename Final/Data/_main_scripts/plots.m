[train_x, train_y, test_x, test_y] = get_mnist_data();
S = load('small_cnn');

to_plot{1}=S.cnn.layers{2}.k;
size(S.cnn.layers{4}.k)
for j = 1:6
    to_plot{j+1} = cell(12,1);
    for i = 1:12
    to_plot{j+1}{i,1} = S.cnn.layers{4}.k{j,i};
    end
end
plot_layers(to_plot, true);