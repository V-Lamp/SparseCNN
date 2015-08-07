clear variables
load('D:\Dropbox\KCL\Thesis\Coding\Matlab\DeepLearnToolbox\trained_cnn.mat')
load mnist_uint8;
l1_kernels = cnn.layers{2}.k;
l1_bias = cnn.layers{2}.b;


train_x = double(reshape(train_x',28,28,60000))/255;
test_x = double(reshape(test_x',28,28,10000))/255;
train_y = double(train_y');
test_y = double(test_y');


% for ind_image = 1:100
%     img = test_x(:,:,ind_image);
%     lbl = test_y(:,ind_image);
%     ind = find(lbl)-1; 
%     PlotAsImages({img},{num2str(ind)});
%     pause(1.5)
% end
ind_image = 51;
img = test_x(:,:,ind_image);
lbl = test_y(:,ind_image);
ind = find(lbl)-1;
conv_out = aggConv({img}, l1_kernels','valid');
outMaps={};

%dim_out = DIM_sigmoids(l1_kernels',{img},outMaps,50);

%PlotAsImages(dim_out);
cnn = cnnff_DIM(cnn, img);


plot_cnn(cnn);