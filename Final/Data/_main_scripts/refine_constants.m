close all;
[train_x, ~, test_x, ~] = get_mnist_data();
S = load(['saved_data',filesep,'small_cnn']);

dim_impl = @DIM_sep_mask_splitting;

net = dim_setup(S.cnn,[28,28],10);
net = remove_bias(net);
for i = 1:5
    X = test_x(:,:,i);
    
    cnn = cnnff(S.cnn,X);
    to_plot = {};
    for j = 1:numel(cnn.layers)
        to_plot{j} = cnn.layers{j}.a;
    end
    %plot_network(net,true);
    plot_layers(to_plot, true);
    pause(0.5)
    
%     net = dim_ff(net, X, dim_impl);
%     to_plot = {};
%     for j = 1:numel(net.layers)
%         to_plot{j} = net.layers{j}.a;
%     end
%     %plot_network(net,true);
%     plot_layers(to_plot, true);
%     pause(0.5)
    
end

